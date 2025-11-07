from flask import Flask, request, jsonify


app = Flask(__name__)

# Define the root endpoint for GET requests
@app.route('/', methods=['GET'])
def home():
    return "<h1>Welcome to a Simple Flask API!</h1>"

# Define an endpoint for GET requests
@app.route('/sqa', methods=['GET'])
def greetSQA():
    return "<h1>Welcome to the SQA course!</h1>"


if __name__ == '__main__':
    app.run(debug=True)
