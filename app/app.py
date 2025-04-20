from flask import Flask, jsonify
from datetime import datetime
import json

app = Flask(__name__)

def lambda_handler(event, context):
    # Get current timestamp
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

    # Get client IP from API Gateway event
    ip_address = "Unknown"
    if event.get('headers') and event['headers'].get('X-Forwarded-For'):
        ip_address = event['headers']['X-Forwarded-For']
    elif event.get('requestContext') and event['requestContext'].get('identity'):
        ip_address = event['requestContext']['identity'].get('sourceIp', 'Unknown')

    # Return the data in API Gateway format
    return {
        'statusCode': 200,
        'headers': {
            'Content-Type': 'application/json'
        },
        'body': json.dumps({
            "timestamp": timestamp,
            "ip": ip_address
        })
    }

# This is only for local testing and won't run in Lambda
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=80)