import tkinter as tk
from tkinter import scrolledtext
import threading
import pexpect
import os

SCRIPT_PATH = "/apps/remote-scripts/back/run-remote-script-plink.sh"  # Change to your script path

class BashRunnerApp:
    def __init__(self, root):
        self.root = root
        self.root.title("Bash Script Runner")
        
        # Scrollable output log
        self.output_box = scrolledtext.ScrolledText(root, wrap=tk.WORD, width=90, height=25, bg="black", fg="white")
        self.output_box.pack(padx=10, pady=10)
        
        # Input frame
        input_frame = tk.Frame(root)
        input_frame.pack(fill=tk.X, padx=10, pady=5)
        
        self.input_field = tk.Entry(input_frame, width=70)
        self.input_field.pack(side=tk.LEFT, expand=True, fill=tk.X)
        self.input_field.bind("<Return>", self.send_input)
        
        send_button = tk.Button(input_frame, text="Send", command=self.send_input)
        send_button.pack(side=tk.LEFT, padx=5)
        
        # Run button
        run_button = tk.Button(root, text="Run Script", command=self.start_script, bg="green", fg="white")
        run_button.pack(pady=5)
        
        self.child = None

    def start_script(self):
        """Starts the script in a separate thread to keep GUI responsive."""
        if not os.path.exists(SCRIPT_PATH):
            self.append_output(f"[ERROR] Script not found: {SCRIPT_PATH}\n", "error")
            return
        threading.Thread(target=self.run_script, daemon=True).start()

    def run_script(self):
        """Runs the bash script and captures its output."""
        try:
            self.child = pexpect.spawn(SCRIPT_PATH, encoding='utf-8')
            self.append_output(f"[INFO] Running script: {SCRIPT_PATH}\n", "info")
            
            while True:
                try:
                    line = self.child.readline()
                    if not line:
                        break
                    self.append_output(line, "normal")
                except pexpect.EOF:
                    break
        except Exception as e:
            self.append_output(f"[ERROR] {str(e)}\n", "error")

    def send_input(self, event=None):
        """Sends typed input to the script."""
        if self.child and self.child.isalive():
            user_input = self.input_field.get()
            self.child.sendline(user_input)
            self.input_field.delete(0, tk.END)
        else:
            self.append_output("[WARN] No active script running.\n", "warn")

    def append_output(self, text, tag="normal"):
        """Displays output in the text box with optional coloring."""
        self.output_box.insert(tk.END, text, tag)
        self.output_box.see(tk.END)
        
        # Define text colors
        self.output_box.tag_config("info", foreground="cyan")
        self.output_box.tag_config("error", foreground="red")
        self.output_box.tag_config("warn", foreground="yellow")
        self.output_box.tag_config("normal", foreground="white")

if __name__ == "__main__":
    root = tk.Tk()
    app = BashRunnerApp(root)
    root.mainloop()
