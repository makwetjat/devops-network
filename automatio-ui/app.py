import asyncio
import os
import shlex
from fastapi import FastAPI, WebSocket, WebSocketDisconnect # type: ignore
from fastapi.responses import HTMLResponse # type: ignore

app = FastAPI()

REMOTE_PATH = "/apps/remote-scripts"
SCRIPTS_PATH = f"{REMOTE_PATH}/run-remote-scripts"
_variable_files= {
    "ansible": f"{REMOTE_PATH}/secrets/.file1",
    "root": f"{REMOTE_PATH}/secrets/.file2"
}

def get_password(user: str) -> str:
    path = _variable_files.get(user)
    if not path or not os.path.isfile(path):
        raise FileNotFoundError(f"Password file for user '{user}' not found")
    with open(path, "r") as f:
        return f.readline().strip()

html = """
<!DOCTYPE html>
<html>
<head>
  <title>Run Remote Script UI</title>
</head>
<body>
  <h2>Run Remote Script on Servers</h2>
  <form id="form">
    <label>Server names (one per line):</label><br>
    <textarea id="servers" rows="6" cols="40"></textarea><br><br>

    <label>Choose remote user:</label><br>
    <select id="remote_user">
      <option value="ansible">ansible</option>
      <option value="root">root</option>
    </select><br><br>

    <label>Choose script to run:</label><br>
    <select id="script_select"></select><br><br>

    <button type="button" onclick="startRun()">Run Script</button>
  </form>

  <h3>Output:</h3>
  <pre id="output" style="background:#222; color:#0f0; height:300px; overflow:auto;"></pre>

<script>
  async function loadScripts() {
    const res = await fetch("/scripts");
    const scripts = await res.json();
    const select = document.getElementById("script_select");
    scripts.forEach(s => {
      let option = document.createElement("option");
      option.value = s;
      option.text = s;
      select.appendChild(option);
    });
  }

  loadScripts();

  let ws;

  function startRun() {
    const servers = document.getElementById("servers").value;
    const user = document.getElementById("remote_user").value;
    const script = document.getElementById("script_select").value;

    if(ws) {
      ws.close();
    }

    ws = new WebSocket(`ws://${location.host}/ws`);

    ws.onopen = () => {
      ws.send(JSON.stringify({servers, user, script}));
      document.getElementById("output").textContent = "";
    };
    ws.onmessage = (event) => {
      const output = document.getElementById("output");
      output.textContent += event.data + "\\n";
      output.scrollTop = output.scrollHeight;
    };
    ws.onclose = () => {
      const output = document.getElementById("output");
      output.textContent += "\\nConnection closed.";
    };
    ws.onerror = () => {
      const output = document.getElementById("output");
      output.textContent += "\\nError occurred.";
    };
  }
</script>
</body>
</html>
"""

@app.get("/")
async def root():
    return HTMLResponse(html)

@app.get("/scripts")
async def list_scripts():
    try:
        files = [f for f in os.listdir(SCRIPTS_PATH) if f.endswith(".sh")]
    except Exception:
        files = []
    return files

@app.websocket("/ws")
async def websocket_endpoint(websocket: WebSocket):
    await websocket.accept()
    try:
        data = await websocket.receive_text()
        import json
        params = json.loads(data)
        servers_raw = params.get("servers", "")
        user = params.get("user")
        script = params.get("script")

        # Validate user and get password from file
        try:
            password = get_password(user)
        except Exception as e:
            await websocket.send_text(f"ERROR: {str(e)}")
            await websocket.close()
            return

        servers = [s.strip() for s in servers_raw.splitlines() if s.strip()]
        if not servers:
            await websocket.send_text("ERROR: No servers provided")
            await websocket.close()
            return

        script_path = os.path.join(SCRIPTS_PATH, script)
        if not os.path.isfile(script_path):
            await websocket.send_text(f"ERROR: Script '{script}' not found")
            await websocket.close()
            return

        await websocket.send_text(f"Running script '{script}' as user '{user}' on {len(servers)} server(s)...")

        for host in servers:
            await websocket.send_text(f"\n--- Processing {host} ---")
            scp_cmd = f"sshpass -p {shlex.quote(password)} scp -o StrictHostKeyChecking=no {shlex.quote(script_path)} {user}@{host}:/tmp/{script}"
            ssh_cmd = f"sshpass -p {shlex.quote(password)} ssh -o StrictHostKeyChecking=no {user}@{host} sudo bash /tmp/{script}; rm -f /tmp/{script}"

            await websocket.send_text(f"Copying script to {host}...")
            proc_scp = await asyncio.create_subprocess_shell(scp_cmd, stdout=asyncio.subprocess.PIPE, stderr=asyncio.subprocess.STDOUT)
            while True:
                line = await proc_scp.stdout.readline()
                if not line:
                    break
                await websocket.send_text(line.decode().rstrip())
            await proc_scp.wait()
            if proc_scp.returncode != 0:
                await websocket.send_text(f"Failed to copy script to {host}, skipping...")
                continue

            await websocket.send_text(f"Executing script on {host}...")
            proc_ssh = await asyncio.create_subprocess_shell(ssh_cmd, stdout=asyncio.subprocess.PIPE, stderr=asyncio.subprocess.STDOUT)
            while True:
                line = await proc_ssh.stdout.readline()
                if not line:
                    break
                await websocket.send_text(line.decode().rstrip())
            await proc_ssh.wait()
            await websocket.send_text(f"Finished processing {host}.")

        await websocket.send_text("\nAll done.")
        await websocket.close()
    except WebSocketDisconnect:
        print("Client disconnected")
    except Exception as e:
        await websocket.send_text(f"ERROR: {str(e)}")
        await websocket.close()
