import sqlite3, subprocess
from flask import Flask, request
app = Flask(__name__)

@app.route("/search")
def search():
    q = request.args.get("q")
    sqlite3.connect("db").execute("SELECT * FROM data WHERE name='" + q + "'")

@app.route("/run")
def run():
    cmd = request.args.get("cmd")
    subprocess.check_output("sh -c '" + cmd + "'", shell=True)

app.run(debug=True, host="0.0.0.0")
