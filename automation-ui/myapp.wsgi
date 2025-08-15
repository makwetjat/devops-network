import sys
import os

# Add your app directory to sys.path
sys.path.insert(0, "/app/devops-network/automation-ui")

# Activate virtual environment if you are using one
activate_this = "/app/devops-network/automation-ui/venv/bin/activate_this.py"
if os.path.exists(activate_this):
    with open(activate_this) as f:
        exec(f.read(), dict(__file__=activate_this))

# Import FastAPI app
from main import app as application  # Change 'main' if your main .py file is named differently
