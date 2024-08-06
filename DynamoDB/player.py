import boto3
from botocore.exceptions import ClientError

dynamodb = boto3.resource('dynamodb', region_name='us-east-1')
table_name = 'Players'
table = dynamodb.Table(table_name)

players = [
    {'PlayerID': '1', 'Name': 'LeBron James', 'Team': 'Los Angeles Lakers', 'Position': 'SF', 'Rank': 1, 'Wikipedia': 'https://en.wikipedia.org/wiki/LeBron_James'},
    {'PlayerID': '2', 'Name': 'Kevin Durant', 'Team': 'Phoenix Suns', 'Position': 'SF', 'Rank': 2, 'Wikipedia': 'https://en.wikipedia.org/wiki/Kevin_Durant'},
    {'PlayerID': '3', 'Name': 'Giannis Antetokounmpo', 'Team': 'Milwaukee Bucks', 'Position': 'PF', 'Rank': 3, 'Wikipedia': 'https://en.wikipedia.org/wiki/Giannis_Antetokounmpo'},
    {'PlayerID': '4', 'Name': 'Stephen Curry', 'Team': 'Golden State Warriors', 'Position': 'PG', 'Rank': 4, 'Wikipedia': 'https://en.wikipedia.org/wiki/Stephen_Curry'},
    {'PlayerID': '5', 'Name': 'James Harden', 'Team': 'Philadelphia 76ers', 'Position': 'SG', 'Rank': 5, 'Wikipedia': 'https://en.wikipedia.org/wiki/James_Harden'},
    {'PlayerID': '6', 'Name': 'Kawhi Leonard', 'Team': 'Los Angeles Clippers', 'Position': 'SF', 'Rank': 6, 'Wikipedia': 'https://en.wikipedia.org/wiki/Kawhi_Leonard'},
    {'PlayerID': '7', 'Name': 'Anthony Davis', 'Team': 'Los Angeles Lakers', 'Position': 'PF', 'Rank': 7, 'Wikipedia': 'https://en.wikipedia.org/wiki/Anthony_Davis'},
    {'PlayerID': '8', 'Name': 'Luka Dončić', 'Team': 'Dallas Mavericks', 'Position': 'PG', 'Rank': 8, 'Wikipedia': 'https://en.wikipedia.org/wiki/Luka_Dončić'},
    {'PlayerID': '9', 'Name': 'Joel Embiid', 'Team': 'Philadelphia 76ers', 'Position': 'C', 'Rank': 9, 'Wikipedia': 'https://en.wikipedia.org/wiki/Joel_Embiid'},
    {'PlayerID': '10', 'Name': 'Jimmy Butler', 'Team': 'Miami Heat', 'Position': 'SF', 'Rank': 10, 'Wikipedia': 'https://en.wikipedia.org/wiki/Jimmy_Butler'},
    {'PlayerID': '11', 'Name': 'Damian Lillard', 'Team': 'Portland Trail Blazers', 'Position': 'PG', 'Rank': 11, 'Wikipedia': 'https://en.wikipedia.org/wiki/Damian_Lillard'},
    {'PlayerID': '12', 'Name': 'Paul George', 'Team': 'Los Angeles Clippers', 'Position': 'SF', 'Rank': 12, 'Wikipedia': 'https://en.wikipedia.org/wiki/Paul_George'},
    {'PlayerID': '13', 'Name': 'Jayson Tatum', 'Team': 'Boston Celtics', 'Position': 'SF', 'Rank': 13, 'Wikipedia': 'https://en.wikipedia.org/wiki/Jayson_Tatum'},
    {'PlayerID': '14', 'Name': 'Devin Booker', 'Team': 'Phoenix Suns', 'Position': 'SG', 'Rank': 14, 'Wikipedia': 'https://en.wikipedia.org/wiki/Devin_Booker'},
    {'PlayerID': '15', 'Name': 'Russell Westbrook', 'Team': 'Los Angeles Lakers', 'Position': 'PG', 'Rank': 15, 'Wikipedia': 'https://en.wikipedia.org/wiki/Russell_Westbrook'},
    {'PlayerID': '16', 'Name': 'Zion Williamson', 'Team': 'New Orleans Pelicans', 'Position': 'PF', 'Rank': 16, 'Wikipedia': 'https://en.wikipedia.org/wiki/Zion_Williamson'},
    {'PlayerID': '17', 'Name': 'Bradley Beal', 'Team': 'Washington Wizards', 'Position': 'SG', 'Rank': 17, 'Wikipedia': 'https://en.wikipedia.org/wiki/Bradley_Beal'},
    {'PlayerID': '18', 'Name': 'Rudy Gobert', 'Team': 'Minnesota Timberwolves', 'Position': 'C', 'Rank': 18, 'Wikipedia': 'https://en.wikipedia.org/wiki/Rudy_Gobert'},
    {'PlayerID': '19', 'Name': 'Trae Young', 'Team': 'Atlanta Hawks', 'Position': 'PG', 'Rank': 19, 'Wikipedia': 'https://en.wikipedia.org/wiki/Trae_Young'},
    {'PlayerID': '20', 'Name': 'Bam Adebayo', 'Team': 'Miami Heat', 'Position': 'C', 'Rank': 20, 'Wikipedia': 'https://en.wikipedia.org/wiki/Bam_Adebayo'},
    {'PlayerID': '21', 'Name': 'De Aaron Fox', 'Team': 'Sacramento Kings', 'Position': 'PG', 'Rank': 21, 'Wikipedia': 'https://en.wikipedia.org/wiki/De%27Aaron_Fox'},
    {'PlayerID': '22', 'Name': 'John Collins', 'Team': 'Atlanta Hawks', 'Position': 'PF', 'Rank': 22, 'Wikipedia': 'https://en.wikipedia.org/wiki/John_Collins_(basketball)'},
    {'PlayerID': '23', 'Name': 'Myles Turner', 'Team': 'Indiana Pacers', 'Position': 'C', 'Rank': 23, 'Wikipedia': 'https://en.wikipedia.org/wiki/Myles_Turner'},
    {'PlayerID': '24', 'Name': 'Shai Gilgeous-Alexander', 'Team': 'Oklahoma City Thunder', 'Position': 'PG', 'Rank': 24, 'Wikipedia': 'https://en.wikipedia.org/wiki/Shai_Gilgeous-Alexander'},
    {'PlayerID': '25', 'Name': 'Jaren Jackson Jr.', 'Team': 'Memphis Grizzlies', 'Position': 'PF', 'Rank': 25, 'Wikipedia': 'https://en.wikipedia.org/wiki/Jaren_Jackson_Jr.'},
    {'PlayerID': '26', 'Name': 'Clint Capela', 'Team': 'Atlanta Hawks', 'Position': 'C', 'Rank': 26, 'Wikipedia': 'https://en.wikipedia.org/wiki/Clint_Capela'},
    {'PlayerID': '27', 'Name': 'Gordon Hayward', 'Team': 'Charlotte Hornets', 'Position': 'SF', 'Rank': 27, 'Wikipedia': 'https://en.wikipedia.org/wiki/Gordon_Hayward'},
    {'PlayerID': '28', 'Name': 'Lonzo Ball', 'Team': 'Chicago Bulls', 'Position': 'PG', 'Rank': 28, 'Wikipedia': 'https://en.wikipedia.org/wiki/Lonzo_Ball'},
    {'PlayerID': '29', 'Name': 'Michael Porter Jr.', 'Team': 'Denver Nuggets', 'Position': 'SF', 'Rank': 29, 'Wikipedia': 'https://en.wikipedia.org/wiki/Michael_Porter_Jr.'},
    {'PlayerID': '30', 'Name': 'Terry Rozier', 'Team': 'Charlotte Hornets', 'Position': 'PG', 'Rank': 30, 'Wikipedia': 'https://en.wikipedia.org/wiki/Terry_Rozier'},
    {'PlayerID': '31', 'Name': 'Kelly Oubre Jr.', 'Team': 'Charlotte Hornets', 'Position': 'SF', 'Rank': 31, 'Wikipedia': 'https://en.wikipedia.org/wiki/Kelly_Oubre_Jr.'},
    {'PlayerID': '32', 'Name': 'D Angelo Russell', 'Team': 'Minnesota Timberwolves', 'Position': 'PG', 'Rank': 32, 'Wikipedia': 'https://en.wikipedia.org/wiki/D%27Angelo_Russell'},
    {'PlayerID': '33', 'Name': 'C.J. McCollum', 'Team': 'New Orleans Pelicans', 'Position': 'SG', 'Rank': 33, 'Wikipedia': 'https://en.wikipedia.org/wiki/C._J._McCollum'},
    {'PlayerID': '34', 'Name': 'Malcolm Brogdon', 'Team': 'Boston Celtics', 'Position': 'PG', 'Rank': 34, 'Wikipedia': 'https://en.wikipedia.org/wiki/Malcolm_Brogdon'},
    {'PlayerID': '35', 'Name': 'Marcus Smart', 'Team': 'Boston Celtics', 'Position': 'SG', 'Rank': 35, 'Wikipedia': 'https://en.wikipedia.org/wiki/Marcus_Smart'},
    {'PlayerID': '36', 'Name': 'Victor Oladipo', 'Team': 'Miami Heat', 'Position': 'SG', 'Rank': 36, 'Wikipedia': 'https://en.wikipedia.org/wiki/Victor_Oladipo'},
    {'PlayerID': '37', 'Name': 'Jrue Holiday', 'Team': 'Milwaukee Bucks', 'Position': 'PG', 'Rank': 37, 'Wikipedia': 'https://en.wikipedia.org/wiki/Jrue_Holiday'},
    {'PlayerID': '38', 'Name': 'Khris Middleton', 'Team': 'Milwaukee Bucks', 'Position': 'SF', 'Rank': 38, 'Wikipedia': 'https://en.wikipedia.org/wiki/Khris_Middleton'},
    {'PlayerID': '39', 'Name': 'Jusuf Nurkić', 'Team': 'Portland Trail Blazers', 'Position': 'C', 'Rank': 39, 'Wikipedia': 'https://en.wikipedia.org/wiki/Jusuf_Nurkić'},
    {'PlayerID': '40', 'Name': 'Tobias Harris', 'Team': 'Philadelphia 76ers', 'Position': 'SF', 'Rank': 40, 'Wikipedia': 'https://en.wikipedia.org/wiki/Tobias_Harris'},
    {'PlayerID': '41', 'Name': 'Buddy Hield', 'Team': 'Indiana Pacers', 'Position': 'SG', 'Rank': 41, 'Wikipedia': 'https://en.wikipedia.org/wiki/Buddy_Hield'},
    {'PlayerID': '42', 'Name': 'Nikola Vučević', 'Team': 'Chicago Bulls', 'Position': 'C', 'Rank': 42, 'Wikipedia': 'https://en.wikipedia.org/wiki/Nikola_Vučević'},
    {'PlayerID': '43', 'Name': 'Domantas Sabonis', 'Team': 'Sacramento Kings', 'Position': 'PF', 'Rank': 43, 'Wikipedia': 'https://en.wikipedia.org/wiki/Domantas_Sabonis'},
    {'PlayerID': '44', 'Name': 'Kyle Lowry', 'Team': 'Miami Heat', 'Position': 'PG', 'Rank': 44, 'Wikipedia': 'https://en.wikipedia.org/wiki/Kyle_Lowry'},
    {'PlayerID': '45', 'Name': 'Mike Conley', 'Team': 'Utah Jazz', 'Position': 'PG', 'Rank': 45, 'Wikipedia': 'https://en.wikipedia.org/wiki/Mike_Conley_Jr.'},
    {'PlayerID': '46', 'Name': 'Fred VanVleet', 'Team': 'Toronto Raptors', 'Position': 'PG', 'Rank': 46, 'Wikipedia': 'https://en.wikipedia.org/wiki/Fred_VanVleet'},
    {'PlayerID': '47', 'Name': 'Derrick White', 'Team': 'Boston Celtics', 'Position': 'SG', 'Rank': 47, 'Wikipedia': 'https://en.wikipedia.org/wiki/Derrick_White'},
    {'PlayerID': '48', 'Name': 'Jonas Valančiūnas', 'Team': 'New Orleans Pelicans', 'Position': 'C', 'Rank': 48, 'Wikipedia': 'https://en.wikipedia.org/wiki/Jonas_Valančiūnas'},
    {'PlayerID': '49', 'Name': 'Jalen Brunson', 'Team': 'New York Knicks', 'Position': 'PG', 'Rank': 49, 'Wikipedia': 'https://en.wikipedia.org/wiki/Jalen_Brunson'},
    {'PlayerID': '50', 'Name': 'Tyrese Haliburton', 'Team': 'Indiana Pacers', 'Position': 'PG', 'Rank': 50, 'Wikipedia': 'https://en.wikipedia.org/wiki/Tyrese_Haliburton'}
]

def insert_players(table, players):
    for player in players:
        try:
            # Use ConditionExpression to ensure the item does not already exist
            table.put_item(
                Item=player,
                ConditionExpression='attribute_not_exists(PlayerID)'
            )
            print(f"Inserted player: {player['Name']}")
        except ClientError as e:
            if e.response['Error']['Code'] == 'ConditionalCheckFailedException':
                print(f"Player {player['Name']} already exists.")
            else:
                print(f"Error inserting player: {player['Name']}. Error: {e}")

insert_players(table, players)

dynamodb = boto3.resource('dynamodb', region_name='us-east-1')
table = dynamodb.Table('Players')

updates = [
    {'PlayerID': '1', 'Achievements': ['4x NBA Champion', '4x NBA MVP'], 'InterestingFacts': ['Known for his versatility', 'Philanthropist']},
    {'PlayerID': '2', 'Achievements': ['2x NBA Champion', '4x Scoring Champion'], 'InterestingFacts': ['Known for his shooting range', 'Has won MVP awards']},
    {'PlayerID': '3', 'Achievements': ['2x NBA MVP', '1x NBA Champion'], 'InterestingFacts': ['Known as the Greek Freak', 'Has a unique playing style']},
    {'PlayerID': '4', 'Achievements': ['2x NBA MVP', '3x NBA Champion'], 'InterestingFacts': ['Greatest shooter in NBA history', 'Has multiple NBA records']},
    {'PlayerID': '5', 'Achievements': ['1x NBA MVP', '2018 NBA Scoring Champion'], 'InterestingFacts': ['Known for his offensive skills', 'Has played for multiple teams']},
    {'PlayerID': '6', 'Achievements': ['2x NBA Champion', '2x NBA Defensive Player of the Year'], 'InterestingFacts': ['Known for his defensive prowess', 'Has a strong presence on both ends of the court']},
    {'PlayerID': '7', 'Achievements': ['1x NBA Champion', '8x NBA All-Star'], 'InterestingFacts': ['One of the best defenders', 'Has a versatile offensive game']},
    {'PlayerID': '8', 'Achievements': ['NBA Rookie of the Year', '3x NBA All-Star'], 'InterestingFacts': ['Known for his exceptional passing', 'Has a bright future ahead']},
    {'PlayerID': '9', 'Achievements': ['1x NBA MVP', '4x NBA All-Star'], 'InterestingFacts': ['Known for his dominant presence in the paint', 'A key player for his team']},
    {'PlayerID': '10', 'Achievements': ['5x NBA All-Star', '2x All-NBA Team'], 'InterestingFacts': ['Known for his clutch performances', 'Has led his team to the NBA Finals']},
    {'PlayerID': '11', 'Achievements': ['6x NBA All-Star', 'All-NBA Second Team'], 'InterestingFacts': ['Known for his scoring and leadership', 'A key player for his team']},
    {'PlayerID': '12', 'Achievements': ['2x NBA All-Star', 'NBA All-Defensive Team'], 'InterestingFacts': ['Known for his defensive skills', 'A versatile player']},
    {'PlayerID': '13', 'Achievements': ['1x NBA All-Star', 'NBA All-Rookie First Team'], 'InterestingFacts': ['Known for his scoring ability', 'A rising star']},
    {'PlayerID': '14', 'Achievements': ['2x NBA All-Star', 'All-NBA Third Team'], 'InterestingFacts': ['Known for his scoring and shooting', 'A key player for his team']},
    {'PlayerID': '15', 'Achievements': ['2017 NBA MVP', '9x NBA All-Star'], 'InterestingFacts': ['Known for his explosive style of play', 'A dominant force on the court']},
    {'PlayerID': '16', 'Achievements': ['NBA All-Rookie First Team', 'Rising Star'], 'InterestingFacts': ['Known for his athleticism', 'A promising young talent']},
    {'PlayerID': '17', 'Achievements': ['3x NBA All-Star', 'All-NBA Third Team'], 'InterestingFacts': ['Known for his scoring and shooting', 'A consistent performer']},
    {'PlayerID': '18', 'Achievements': ['3x NBA Defensive Player of the Year', '4x NBA All-Star'], 'InterestingFacts': ['Known for his shot-blocking skills', 'A key defensive player']},
    {'PlayerID': '19', 'Achievements': ['NBA All-Star', 'Rising Star'], 'InterestingFacts': ['Known for his shooting and playmaking', 'A young and talented guard']},
    {'PlayerID': '20', 'Achievements': ['NBA All-Star', 'All-NBA Defensive Team'], 'InterestingFacts': ['Known for his versatility', 'A strong presence on defense']},
    {'PlayerID': '21', 'Achievements': ['Rising Star', 'NBA All-Rookie Team'], 'InterestingFacts': ['Known for his speed and agility', 'A young and promising player']},
    {'PlayerID': '22', 'Achievements': ['NBA All-Star', 'All-NBA Team'], 'InterestingFacts': ['Known for his scoring ability', 'A key player for his team']},
    {'PlayerID': '23', 'Achievements': ['NBA All-Star', 'All-NBA Defensive Team'], 'InterestingFacts': ['Known for his shot-blocking and rebounding', 'A dominant force in the paint']},
    {'PlayerID': '24', 'Achievements': ['NBA All-Star', 'Rising Star'], 'InterestingFacts': ['Known for his scoring and playmaking', 'A promising young guard']},
    {'PlayerID': '25', 'Achievements': ['NBA All-Star', 'All-NBA Defensive Team'], 'InterestingFacts': ['Known for his shot-blocking', 'A key player on defense']},
    {'PlayerID': '26', 'Achievements': ['NBA All-Star', 'All-NBA Team'], 'InterestingFacts': ['Known for his rebounding and defense', 'A key player for his team']},
    {'PlayerID': '27', 'Achievements': ['NBA All-Star', 'All-NBA Team'], 'InterestingFacts': ['Known for his scoring and versatility', 'A consistent performer']},
    {'PlayerID': '28', 'Achievements': ['NBA All-Star', 'Rising Star'], 'InterestingFacts': ['Known for his passing and playmaking', 'A promising young talent']},
    {'PlayerID': '29', 'Achievements': ['NBA All-Star', 'All-NBA Third Team'], 'InterestingFacts': ['Known for his scoring and shooting', 'A key player for his team']},
    {'PlayerID': '30', 'Achievements': ['NBA All-Star', 'All-NBA Team'], 'InterestingFacts': ['Known for his scoring and playmaking', 'A strong offensive player']},
    {'PlayerID': '31', 'Achievements': ['NBA All-Star', 'All-NBA Team'], 'InterestingFacts': ['Known for his versatility and scoring', 'A key player for his team']},
    {'PlayerID': '32', 'Achievements': ['NBA All-Star', 'All-NBA Third Team'], 'InterestingFacts': ['Known for his scoring and playmaking', 'A consistent performer']},
    {'PlayerID': '33', 'Achievements': ['NBA All-Star', 'All-NBA Team'], 'InterestingFacts': ['Known for his scoring and shooting', 'A key player for his team']},
    {'PlayerID': '34', 'Achievements': ['NBA All-Star', 'All-NBA Second Team'], 'InterestingFacts': ['Known for his scoring and defense', 'A versatile guard']},
    {'PlayerID': '35', 'Achievements': ['NBA All-Star', 'All-NBA Third Team'], 'InterestingFacts': ['Known for his defense and leadership', 'A strong guard']},
    {'PlayerID': '36', 'Achievements': ['NBA All-Star', 'All-NBA Team'], 'InterestingFacts': ['Known for his scoring and shooting', 'A key player for his team']},
    {'PlayerID': '37', 'Achievements': ['NBA All-Star', 'All-NBA Defensive Team'], 'InterestingFacts': ['Known for his defense and playmaking', 'A strong guard']},
    {'PlayerID': '38', 'Achievements': ['NBA All-Star', 'All-NBA Third Team'], 'InterestingFacts': ['Known for his scoring and leadership', 'A key player for his team']},
    {'PlayerID': '39', 'Achievements': ['NBA All-Star', 'All-NBA Defensive Team'], 'InterestingFacts': ['Known for his defense and rebounding', 'A strong center']},
    {'PlayerID': '40', 'Achievements': ['NBA All-Star', 'All-NBA Team'], 'InterestingFacts': ['Known for his versatility and scoring', 'A key player for his team']},
    {'PlayerID': '41', 'Achievements': ['NBA All-Star', 'All-NBA Team'], 'InterestingFacts': ['Known for his scoring and shooting', 'A versatile forward']},
    {'PlayerID': '42', 'Achievements': ['NBA All-Star', 'All-NBA Third Team'], 'InterestingFacts': ['Known for his scoring and shooting', 'A key player for his team']},
    {'PlayerID': '43', 'Achievements': ['NBA All-Star', 'All-NBA Defensive Team'], 'InterestingFacts': ['Known for his defense and rebounding', 'A strong center']},
    {'PlayerID': '44', 'Achievements': ['NBA All-Star', 'Rising Star'], 'InterestingFacts': ['Known for his playmaking and scoring', 'A promising young guard']},
    {'PlayerID': '45', 'Achievements': ['NBA All-Star', 'All-NBA Third Team'], 'InterestingFacts': ['Known for his scoring and versatility', 'A key player for his team']},
    {'PlayerID': '46', 'Achievements': ['NBA All-Star', 'All-NBA Team'], 'InterestingFacts': ['Known for his scoring and shooting', 'A strong offensive player']},
    {'PlayerID': '47', 'Achievements': ['NBA All-Star', 'All-NBA Defensive Team'], 'InterestingFacts': ['Known for his defense and shot-blocking', 'A key player on defense']},
    {'PlayerID': '48', 'Achievements': ['NBA All-Star', 'All-NBA Team'], 'InterestingFacts': ['Known for his scoring and versatility', 'A strong offensive player']},
    {'PlayerID': '49', 'Achievements': ['NBA All-Star', 'All-NBA Third Team'], 'InterestingFacts': ['Known for his scoring and shooting', 'A key player for his team']},
    {'PlayerID': '50', 'Achievements': ['NBA All-Star', 'All-NBA Team'], 'InterestingFacts': ['Known for his scoring and playmaking', 'A strong guard']},
]

def update_player(table, player_id, achievements, interesting_facts):
    try:
        response = table.update_item(
            Key={'PlayerID': player_id},
            UpdateExpression="SET Achievements = :a, InterestingFacts = :f",
            ExpressionAttributeValues={
                ':a': achievements,
                ':f': interesting_facts
            },
            ReturnValues="UPDATED_NEW"
        )
        print(f"Updated player {player_id}: {response}")
    except ClientError as e:
        print(f"Error updating player {player_id}. Error: {e}")

# Main function
def main():
    # Insert players into the DynamoDB table
    insert_players(table, players)
    
    # Update players with achievements and interesting facts
    for update in updates:
        update_player(table, update['PlayerID'], update['Achievements'], update['InterestingFacts'])

# Run the main function
if __name__ == "__main__":
    main()