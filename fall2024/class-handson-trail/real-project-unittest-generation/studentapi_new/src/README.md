
# Student API Project - Test Case Gen using LLM

This project implements a RESTful API for managing student records using Flask and MySQL. The API allows you to perform CRUD (Create, Read, Update, Delete) operations on student data.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Installation](#installation)
3. [Setup](#setup)
4. [API Endpoints](#api-endpoints)
5. [Running the Application](#running-the-application)
6. [Testing](#testing)
7. [Tasks](#tasks)

## Prerequisites

- Python 3.x
- MySQL Server
- A virtual environment (recommended)

## Installation

1. Clone the repository:

   ```bash
   git clone <repository_url>
   cd studentapi
   ```

2. Create and activate a virtual environment:

   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows use `venv\Scripts\activate`
   ```

3. Install required packages:

   ```bash
   pip install Flask pymysql flask-swagger-ui
   ```

## Setup

1. **Configure MySQL Database**:
    - Open your MySQL client (like MySQL Workbench or command line).
    - Create a user (if necessary) and a database:

   ```sql
   CREATE DATABASE student_db;
   CREATE USER 'username'@'localhost' IDENTIFIED BY 'password';
   GRANT ALL PRIVILEGES ON student_db.* TO 'username'@'localhost';
   ```

   Replace `username` and `password` with your own values.

2. **Modify Configuration**:
    - Open `database.py` and update the `DB_CONFIG` dictionary with your MySQL credentials:

   ```python
   DB_CONFIG = {
       'host': 'localhost',
       'user': 'your_username',
       'password': 'your_password',
       'database': 'student_db'
   }
   ```

3. **Run Database Setup**:
    - The script will automatically create the database and tables when you run the application for the first time.

## API Endpoints

| Method | Endpoint              | Description                      |
|--------|-----------------------|----------------------------------|
| GET    | /students             | Get a list of all students      |
| POST   | /students             | Create a new student            |
| GET    | /students/<id>        | Get a student by ID             |
| PUT    | /students/<id>        | Update a student by ID          |
| DELETE | /students/<id>        | Delete a student by ID          |

### Swagger UI

- You can access the Swagger UI for the API documentation by navigating to `http://127.0.0.1:5050/apidocs`.

## Running the Application

1. Start the Flask application:

   ```bash
   python app.py
   ```

2. Open your browser and go to `http://localhost:5000` to see the API running.

## Testing

### Running Unit Tests

1. To run the unit tests, execute the following command:

   ```bash
   python -m unittest discover -s test
   ```

### Generating Test Cases

#### Database Tests

1. Create a new file `test_database.py` in the `test` directory.
2. Write test cases to verify the functionality of the database functions:
    - Test the creation of the database.
    - Test the creation of the students table.
    - Mock the database connection and cursor to avoid hitting the actual database.

#### Student Model Tests

1. Create a new file `test_models.py` in the `test` directory.
2. Write test cases to verify the functionality of the `Student` model:
    - Test creating a new student.
    - Test retrieving a student by ID.
    - Test updating a student.
    - Test deleting a student.
    - Mock the database connection and cursor to isolate the tests from the database.

### Example of a Test Case

Here's a simple example of how a test case for the `create_db` function in `database.py` might look:

```python
import unittest
from unittest.mock import patch, MagicMock
from database import create_db

class TestDatabaseFunctions(unittest.TestCase):
    
    @patch('pymysql.connect')
    def test_create_db(self, mock_connect):
        # Setup mock connection and cursor
        mock_connection = MagicMock()
        mock_cursor = mock_connection.cursor.return_value
        mock_connect.return_value = mock_connection

        create_db()

        # Verify the database creation command
        mock_cursor.execute.assert_called_once_with("CREATE DATABASE IF NOT EXISTS student_db")
        mock_connection.commit.assert_called_once()
        mock_cursor.close.assert_called_once()
        mock_connection.close.assert_called_once()

if __name__ == '__main__':
    unittest.main()
```

## Tasks

- [ ] Set up the Flask application with routes for CRUD operations.
- [ ] Implement the `Student` model with necessary methods for database interaction.
- [ ] Write unit tests for the `database.py` functions.
- [ ] Write unit tests for the `Student` model.
- [ ] Set up Swagger for API documentation.

## License

This project is licensed under the PASER License, Auburn. See the [LICENSE](LICENSE) file for details.


### Notes:
- Replace `<repository_url>` with the actual URL of your repository.
- Adjust the database configuration in `database.py` according to your setup.
- This README provides a structured overview of your project, making it easier for others (or future you) to set it up and understand how to use it. You can expand or modify sections based on your project's specific needs. Let me know if you need further assistance!