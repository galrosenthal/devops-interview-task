from flask import Flask, jsonify
import random

app = Flask(__name__)

@app.route("/")
def root():
    return jsonify({"status": "ok", "value": random.randint(1, 100)})

if __name__ == "__main__":
    app.run(host="127.0.0.1", port=5000)
