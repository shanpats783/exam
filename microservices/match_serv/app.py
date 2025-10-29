from flask import Flask, jsonify

app = Flask(__name__)

@app.route('/matches')
def get_matches():
    matches = [
        {"match": "MI vs CSK", "date": "Oct 29, 2025"},
        {"match": "KKR vs RCB", "date": "Oct 30, 2025"}
    ]
    return jsonify(matches)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5001)
