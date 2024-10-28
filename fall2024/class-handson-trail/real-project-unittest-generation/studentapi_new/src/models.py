import pymysql
from database import get_db_connection, logger

class Student:

    @staticmethod
    def create_student(name, age, major):
        try:
            connection = get_db_connection()
            cursor = connection.cursor()
            cursor.execute('INSERT INTO students (name, age, major) VALUES (%s, %s, %s)', (name, age, major))
            connection.commit()
            student_id = cursor.lastrowid
            cursor.close()
            connection.close()
            logger.info(f"Student created with ID: {student_id}")
            return student_id
        except pymysql.MySQLError as e:
            logger.error(f"Error creating student: {e}")
            raise

    @staticmethod
    def get_students():
        try:
            connection = get_db_connection()
            cursor = connection.cursor(pymysql.cursors.DictCursor)
            cursor.execute('SELECT * FROM students')
            students = cursor.fetchall()
            cursor.close()
            connection.close()
            logger.info(f"Retrieved {len(students)} students from the database.")
            return students
        except pymysql.MySQLError as e:
            logger.error(f"Error fetching students: {e}")
            raise

    @staticmethod
    def get_student_by_id(student_id):
        try:
            connection = get_db_connection()
            cursor = connection.cursor(pymysql.cursors.DictCursor)
            cursor.execute('SELECT * FROM students WHERE id = %s', (student_id,))
            student = cursor.fetchone()
            cursor.close()
            connection.close()
            if student:
                logger.info(f"Retrieved student with ID: {student_id}")
            else:
                logger.warning(f"Student with ID {student_id} not found.")
            return student
        except pymysql.MySQLError as e:
            logger.error(f"Error fetching student by ID: {e}")
            raise

    @staticmethod
    def update_student(student_id, name, age, major):
        try:
            connection = get_db_connection()
            cursor = connection.cursor()

            # Check if student exists
            cursor.execute('SELECT * FROM students WHERE id = %s', (student_id,))
            if cursor.fetchone() is None:
                logger.warning(f"Student with ID: {student_id} does not exist")
                cursor.close()
                connection.close()
                return None

            # Update student record
            cursor.execute('UPDATE students SET name = %s, age = %s, major = %s WHERE id = %s', (name, age, major, student_id))
            connection.commit()
            cursor.close()
            connection.close()
            logger.info(f"Student with ID: {student_id} updated successfully")
            return student_id, name, age, major
        except pymysql.MySQLError as e:
            logger.error(f"Error updating student with ID {student_id}: {e}")
            raise

    @staticmethod
    def delete_student(student_id):
        try:
            connection = get_db_connection()
            cursor = connection.cursor()

            # Check if the student exists before attempting to delete
            cursor.execute('SELECT * FROM students WHERE id = %s', (student_id,))
            student = cursor.fetchone()

            if student:  # Proceed with deletion only if the student exists
                cursor.execute('DELETE FROM students WHERE id = %s', (student_id,))
                connection.commit()
                logger.info(f"Deleted student with ID: {student_id}")
                return student_id  # Return the deleted student's ID
            else:
                logger.warning(f"Student with ID: {student_id} does not exist.")
                return None  # Or raise an exception if desired

        except pymysql.MySQLError as e:
            logger.error(f"Error deleting student: {e}")
            raise
        finally:
            cursor.close()
            connection.close()
