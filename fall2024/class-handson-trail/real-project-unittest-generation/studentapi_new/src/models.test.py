import unittest
from unittest.mock import patch, MagicMock
from src.models import Student
import pymysql

class TestStudent(unittest.TestCase):
    @patch('src.models.get_db_connection')
    def test_create_student_success(self, mock_get_db_connection):
        mock_connection = MagicMock()
        mock_cursor = MagicMock()
        mock_cursor.lastrowid = 1
        mock_connection.cursor.return_value = mock_cursor
        mock_get_db_connection.return_value = mock_connection

        student_id = Student.create_student("John Doe", 20, "Computer Science")

        self.assertEqual(student_id, 1)
        mock_cursor.execute.assert_called_once_with(
            'INSERT INTO students (name, age, major) VALUES (%s, %s, %s)',
            ("John Doe", 20, "Computer Science")
        )
        mock_connection.commit.assert_called_once()
        mock_cursor.close.assert_called_once()
        mock_connection.close.assert_called_once()
        
if __name__ == '__main__':
    unittest.main()
