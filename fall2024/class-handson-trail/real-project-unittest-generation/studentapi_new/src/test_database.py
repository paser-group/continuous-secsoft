import unittest
from unittest.mock import patch, MagicMock
import pymysql
from database import create_db, get_db_connection, create_table

class TestDatabaseFunctions(unittest.TestCase):

    @patch('database.pymysql.connect')  # Mocking the pymysql.connect method
    def test_create_db(self, mock_connect):
        # Mock the connection and cursor
        mock_connection = MagicMock()
        mock_cursor = MagicMock()
        mock_connection.cursor.return_value = mock_cursor
        mock_connect.return_value = mock_connection

        # Call the create_db function
        create_db()

        # Assertions
        mock_connect.assert_called_once_with(
            host='localhost',
            user='auburn',
            password='auburn'
        )
        mock_cursor.execute.assert_called_once_with("CREATE DATABASE IF NOT EXISTS student_db")
        mock_connection.commit.assert_called_once()
        mock_cursor.close.assert_called_once()
        mock_connection.close.assert_called_once()

    @patch('database.pymysql.connect')
    def test_get_db_connection(self, mock_connect):
        # Mock the connection object
        mock_connection = MagicMock()
        mock_connect.return_value = mock_connection

        # Call the function
        connection = get_db_connection()

        # Assertions
        mock_connect.assert_called_once_with(
            host='localhost',
            user='auburn',
            password='auburn',
            database='student_db'
        )
        self.assertEqual(connection, mock_connection)

    @patch('database.pymysql.connect')
    def test_create_table(self, mock_connect):
        # Mock the connection and cursor
        mock_connection = MagicMock()
        mock_cursor = MagicMock()
        mock_connection.cursor.return_value = mock_cursor
        mock_connect.return_value = mock_connection

        # Call the create_table function
        create_table()

        # Assertions
        mock_connect.assert_called_once_with(
            host='localhost',
            user='auburn',
            password='auburn',
            database='student_db'
        )
        mock_cursor.execute.assert_called_once_with('''
            CREATE TABLE IF NOT EXISTS students (
                id INT AUTO_INCREMENT PRIMARY KEY,
                name VARCHAR(80) NOT NULL,
                age INT NOT NULL,
                major VARCHAR(100)
            )
        ''')
        mock_connection.commit.assert_called_once()
        mock_cursor.close.assert_called_once()
        mock_connection.close.assert_called_once()

if __name__ == '__main__':
    unittest.main()
