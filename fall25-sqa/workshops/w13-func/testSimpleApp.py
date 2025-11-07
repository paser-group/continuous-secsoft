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


    def test_sqa(self):
        response = self.client.get('/sqa')
        self.assertEqual(response.status_code, 200)
        self.assertIn(b"Welcome to the SQA course!", response.data)

if __name__ == '__main__':
    unittest.main()