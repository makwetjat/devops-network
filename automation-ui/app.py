import asyncio
import os
import shlex
from fastapi import FastAPI, WebSocket, WebSocketDisconnect, Request # type: ignore
from fastapi.responses import HTMLResponse # type: ignore
from fastapi.templating import Jinja2Templates
from fastapi.responses import FileResponse


templates = Jinja2Templates(directory="templates")

app = FastAPI(root_path="/remotescripts")

REMOTE_PATH = "/app/devops-network/remote-scripts"
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

@app.get("/image/{filename}")
async def get_image(filename: str):
    file_path = os.path.join("/app/devops-network/remote-scripts/image", filename)
    if os.path.isfile(file_path):
        return FileResponse(file_path)
    return {"error": "Image not found"}

@app.get("/")
async def root(request: Request):
    return templates.TemplateResponse("index.html", {"request": request, "root_path": app.root_path})

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
            ssh_cmd = (
                       f"sshpass -p {shlex.quote(password)} ssh -o StrictHostKeyChecking=no {user}@{host} "
                       f"'sudo -S bash /tmp/{script} <<< {shlex.quote(password)} && sudo rm -f /tmp/{script}'")

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