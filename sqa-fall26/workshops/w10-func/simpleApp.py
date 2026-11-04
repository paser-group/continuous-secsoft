from flask import Flask, request, jsonify


app = Flask(__name__)

# Define the root endpoint for GET requests
@app.route('/', methods=['GET'])
def home():
    return "<h1>Welcome to a Simple Flask API!</h1>"

# Define an endpoint for POST requests
@app.route('/greet', methods=['POST'])
def greet_user():
    # Check if the request body is valid JSON
    if not request.json or 'name' not in request.json:
        return jsonify({"error": "Bad Request: 'name' key is missing"}), 400

    name = request.json['name']
    response = {"message": f"Hello, {name}! This is your first RESTful service."}
    return jsonify(response), 200

# Define an endpoint for GET requests
@app.route('/sqa', methods=['GET'])
def greetSQA():
    return "<h1>Welcome to the SQA course!</h1>"


if __name__ == '__main__':
    app.run(debug=True)
