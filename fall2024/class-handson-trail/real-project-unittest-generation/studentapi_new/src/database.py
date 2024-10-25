import pymysql
import logging
from flask import Flask

# Flask app configuration
app = Flask(__name__)

# MySQL configuration
DB_CONFIG = {
    'host': 'localhost',
    'user': 'auburn',  # Change this to your MySQL username
    'password': 'auburn',  # Change this to your MySQL password
    'database': 'student_db'
}

# Set up logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

def create_db():
    # Create database if it doesn't exist
    try:
        connection = pymysql.connect(
            host=DB_CONFIG['host'],
            user=DB_CONFIG['user'],
            password=DB_CONFIG['password']
        )
        cursor = connection.cursor()
        cursor.execute("CREATE DATABASE IF NOT EXISTS student_db")
        connection.commit()
        cursor.close()
        connection.close()
        logger.info("Database 'student_db' created or already exists.")
    except pymysql.MySQLError as e:
        logger.error(f"Error creating database: {e}")
        raise

def get_db_connection():
    try:
        connection = pymysql.connect(**DB_CONFIG)
        return connection
    except pymysql.MySQLError as e:
        logger.error(f"Error connecting to the database: {e}")
        raise

def create_table():
    try:
        connection = get_db_connection()
        cursor = connection.cursor()
        cursor.execute('''
            CREATE TABLE IF NOT EXISTS students (
                id INT AUTO_INCREMENT PRIMARY KEY,
                name VARCHAR(80) NOT NULL,
                age INT NOT NULL,
                major VARCHAR(100)
            )
        ''')
        connection.commit()
        cursor.close()
        connection.close()
        logger.info("Table 'students' created or already exists.")
    except pymysql.MySQLError as e:
        logger.error(f"Error creating table: {e}")
        raise

# Initialize database and table
create_db()
create_table()
