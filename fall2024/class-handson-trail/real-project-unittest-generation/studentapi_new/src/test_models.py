import unittest
from unittest.mock import patch, MagicMock
from models import Student
import pymysql

class TestStudentModel(unittest.TestCase):

    @patch('models.get_db_connection')
    def test_create_student(self, mock_get_db_connection):
        # Mock database connection and cursor
        mock_connection = MagicMock()
        mock_cursor = mock_connection.cursor.return_value
        mock_get_db_connection.return_value = mock_connection

        # Call the create_student method
        mock_cursor.lastrowid = 10  # Mock the last inserted ID
        student_id = Student.create_student('Alice', 22, 'Computer Science')

        # Assertions
        mock_cursor.execute.assert_called_once_with('INSERT INTO students (name, age, major) VALUES (%s, %s, %s)', ('Alice', 22, 'Computer Science'))
        mock_connection.commit.assert_called_once()
        self.assertEqual(student_id, 11)

    @patch('models.get_db_connection')
    def test_get_students(self, mock_get_db_connection):
        # Mock database connection and cursor
        mock_connection = MagicMock()
        mock_cursor = mock_connection.cursor.return_value
        mock_get_db_connection.return_value = mock_connection

        # Mock return data
        mock_cursor.fetchall.return_value = [{'id': 1, 'name': 'Alice', 'age': 22, 'major': 'Computer Science'}]

        # Call the get_students method
        students = Student.get_students()

        # Assertions
        mock_cursor.execute.assert_called_once_with('SELECT * FROM students')
        self.assertEqual(len(students), 1)
        self.assertEqual(students[0]['name'], 'Alice')

    @patch('models.get_db_connection')
    def test_get_student(self, mock_get_db_connection):
        # Mock database connection and cursor
        mock_connection = MagicMock()
        mock_cursor = mock_connection.cursor.return_value
        mock_get_db_connection.return_value = mock_connection

        # Mock return data
        mock_cursor.fetchone.return_value = {'id': 1, 'name': 'Alice', 'age': 22, 'major': 'Computer Science'}

        # Call the get_student method
        student = Student.get_student_by_id(1)

        # Assertions
        mock_cursor.execute.assert_called_once_with('SELECT * FROM students WHERE id = %s', (1,))
        self.assertIsNotNone(student)
        self.assertEqual(student['name'], 'Alice')

    @patch('models.get_db_connection')
    def test_update_student(self, mock_get_db_connection):
        # Mock database connection and cursor
        mock_connection = MagicMock()
        mock_cursor = mock_connection.cursor.return_value
        mock_get_db_connection.return_value = mock_connection

        # Mock the existence check
        mock_cursor.fetchone.side_effect = [True, None]

        # Call the update_student method
        student_id, name, age, major = Student.update_student(1, 'Alice Updated', 23, 'Mathematics')

        # Assertions
        mock_cursor.execute.assert_any_call('SELECT * FROM students WHERE id = %s', (1,))
        mock_cursor.execute.assert_any_call('UPDATE students SET name = %s, age = %s, major = %s WHERE id = %s', ('Alice Updated', 23, 'Mathematics', 1))
        mock_connection.commit.assert_called_once()
        #self.assertEqual(student_id, 1)
        # check the updated student name
        self.assertEqual(name, 'AliceX Updated')

    @patch('models.get_db_connection')
    def test_update_student_not_found(self, mock_get_db_connection):
        # Mock database connection and cursor
        mock_connection = MagicMock()
        mock_cursor = mock_connection.cursor.return_value
        mock_get_db_connection.return_value = mock_connection

        # Mock the existence check to return None (student not found)
        mock_cursor.fetchone.return_value = None

        # Call the update_student method
        student_id = Student.update_student(999, 'Non-Existent', 25, 'Physics')

        # Assertions
        mock_cursor.execute.assert_called_once_with('SELECT * FROM students WHERE id = %s', (999,))
        self.assertIsNone(student_id)

    @patch('models.get_db_connection')  # Mocking the connection function in models
    def test_delete_student(self, mock_get_db_connection):
        # Mock database connection and cursor
        mock_connection = MagicMock()
        mock_cursor = MagicMock()
        mock_connection.cursor.return_value = mock_cursor
        mock_get_db_connection.return_value = mock_connection

        # Mock the existence check (simulate that the student exists)
        mock_cursor.fetchone.side_effect = [{'id': 1, 'name': 'Alice', 'age': 22, 'major': 'Computer Science'}, None]

        # Call the delete_student method
        student_id = Student.delete_student(1)

        # Assertions
        mock_cursor.execute.assert_any_call('SELECT * FROM students WHERE id = %s', (1,))
        mock_cursor.execute.assert_any_call('DELETE FROM students WHERE id = %s', (1,))
        mock_connection.commit.assert_called_once()
        self.assertEqual(student_id, 2)


    @patch('models.get_db_connection')
    def test_delete_student_not_found(self, mock_get_db_connection):
        # Mock database connection and cursor
        mock_connection = MagicMock()
        mock_cursor = mock_connection.cursor.return_value
        mock_get_db_connection.return_value = mock_connection

        # Mock the existence check to return None (student not found)
        mock_cursor.fetchone.return_value = None

        # Call the delete_student method
        student_id = Student.delete_student(999)

        # Assertions
        mock_cursor.execute.assert_called_once_with('SELECT * FROM students WHERE id = %s', (999,))
        self.assertIsNone(student_id)

if __name__ == '__main__':
    unittest.main()
