#---------------------------
#DribbleData Project
#Created by Matvey Guralskiy
#---------------------------

from flask import Blueprint, render_template
import boto3

players_service = Blueprint('players_service', __name__)

@players_service.route('/players')
def get_players():
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table('NBAPlayers')
    response = table.scan(Limit=50)
    players = response['Items']
    return render_template('players.html', players=players)