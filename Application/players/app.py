from flask import Flask, jsonify, redirect, url_for, render_template
import boto3
import logging
import os
from dotenv import load_dotenv

dotenv_path = os.path.join(os.path.dirname(__file__), '../.env')
load_dotenv(dotenv_path)

dynamodb = boto3.resource('dynamodb', region_name='us-east-1')

table = dynamodb.Table('Players')

app = Flask(__name__)

@app.route('/players', methods=['GET'])
def get_top_50_players():
    try:
        response = table.scan()
        players = response.get('Items', [])
        players_sorted = sorted(players, key=lambda x: int(x.get('Rank', 0)))

        return render_template('players.html',        
        base_url_service_1=os.getenv('BASE_URL_SERVICE_1'),
        base_url_service_2=os.getenv('BASE_URL_SERVICE_2'),
        base_url_service_3=os.getenv('BASE_URL_SERVICE_3'),
        base_url_service_4=os.getenv('BASE_URL_SERVICE_4'), players=players_sorted)
    except Exception as e:
        logging.error(f"Error: {e}")
        return jsonify({"error": "Error from the server"}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5003)
