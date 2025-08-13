from flask import Flask, request, render_template
import subprocess
import os

app = Flask(__name__)

# Path to the scripts directory
scripts_dir = '/c/Users/makwetjat/remote-scripts/front/dashboard/scripts'

# List all the scripts in the directory
def get_scripts():
    return [f for f in os.listdir(scripts_dir) if f.endswith('.sh')]

@app.route("/", methods=["GET", "POST"])
def index():
    output = ""
    if request.method == "POST":
        script_name = request.form.get("script")
        if script_name:
            script_path = os.path.join(scripts_dir, script_name)
            # Run the selected script
            result = subprocess.run(script_path, shell=True, capture_output=True, text=True)
            output = result.stdout if result.stdout else result.stderr
    return render_template("index.html", output=output, scripts=get_scripts())

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
