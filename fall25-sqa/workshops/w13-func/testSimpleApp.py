import unittest
import json
from simpleApp import app

class AppTestCase(unittest.TestCase):
    def setUp(self):
        self.client = app.test_client()

    def test_home_get(self):
        response = self.client.get('/')
        self.assertEqual(response.status_code, 200)
        self.assertIn(b"Welcome to a Simple Flask API!", response.data)

    def test_greet_post_valid(self):
        # Prepare a valid JSON payload
        data = {'name': 'Charlie'}
        
        # Make a POST request with the JSON data
        response = self.client.post('/greet', 
                                    data=json.dumps(data), 
                                    content_type='application/json')
        
        # Check the status code and response data
        self.assertEqual(response.status_code, 200)
        expected_response = {"message": "Hello, Charlie! This is your first RESTful service."}
        self.assertEqual(response.get_json(), expected_response)

    def test_sqa(self):
        response = self.client.get('/sqa')
        self.assertEqual(response.status_code, 200)
        self.assertIn(b"Welcome to the SQA course!", response.data)

if __name__ == '__main__':
    unittest.main()