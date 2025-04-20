from flask import Flask, request, jsonify
from datetime import datetime

app = Flask(__name__)

@app.route("/", methods=["GET"])
def simple_time_service():
    timestamp = datetime.now()
    ip_address = request.remote_addr
    return jsonify({
        "timestamp": timestamp,
        "ip": ip_address
    })

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=80)

def lambda_handler(event, context):
    return {
        'statusCode': 200,
        'body': 'Hello from Lambda!'
    }
