from flask import Flask, jsonify

app = Flask(__name__)

@app.route('/teams')
def get_teams():
    teams = [
        {"name": "Mumbai Indians", "city": "Mumbai"},
        {"name": "Chennai Super Kings", "city": "Chennai"}
    ]
    return jsonify(teams)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
