from flask import Flask, jsonify, redirect, url_for, render_template
import boto3
import logging
import os

# Initialize DynamoDB resource using DAX endpoint
dax_endpoint = os.getenv('DAX_ENDPOINT')
dynamodb = boto3.resource('dynamodb', region_name='us-east-1', endpoint_url=dax_endpoint)
table = dynamodb.Table('Players')

app = Flask(__name__)

@app.route('/')
def overview():
    return redirect(url_for('get_top_50_players'))

@app.route('/players', methods=['GET'])
def get_top_50_players():
    try:
        response = table.scan()
        players = response.get('Items', [])
        players_sorted = sorted(players, key=lambda x: int(x.get('Rank', 0)))

        return render_template('players.html', players=players_sorted)
    except Exception as e:
        logging.error(f"Error: {e}")
        return jsonify({"error": "Error from the server"}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5003)
