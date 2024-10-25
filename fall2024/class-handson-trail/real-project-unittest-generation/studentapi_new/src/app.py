from flask import Flask, request, jsonify, abort
from flasgger import Swagger, swag_from
from models import Student
from database import app, logger

# Custom Swagger template
swagger_template = {
    "swagger": "2.0",
    "info": {
        "title": "Student Management API for AUBURN SQA Course",
        "description": "API for managing students. Designed by Jahidul Arafat.",
        "version": "1.0.0"
    },
    "host": "127.0.0.1:5050",
    "basePath": "/",
    "schemes": ["http"],
}

# Initialize Swagger with custom template
swagger = Swagger(app, template=swagger_template)


@app.route('/students', methods=['POST'])
@swag_from({
    'tags': ['Students'],
    'description': 'Create a new student',
    'parameters': [
        {
            'name': 'body',
            'in': 'body',
            'required': True,
            'schema': {
                'type': 'object',
                'properties': {
                    'name': {'type': 'string'},
                    'age': {'type': 'integer'},
                    'major': {'type': 'string'}
                },
                'required': ['name', 'age']
            }
        }
    ],
    'responses': {
        201: {
            'description': 'Student created',
            'schema': {
                'type': 'object',
                'properties': {
                    'id': {'type': 'integer'},
                    'message': {'type': 'string'}
                }
            }
        },
        400: {'description': 'Invalid request'}
    }
})
def create_student():
    data = request.get_json()
    if not data or 'name' not in data or 'age' not in data:
        logger.warning("Bad request: Missing name or age in POST data.")
        abort(400, 'Name and age are required fields')

    student_id = Student.create_student(data['name'], data['age'], data.get('major', None))
    logger.info(f"Student created successfully with ID: {student_id}")
    return jsonify({'id': student_id, 'message': 'Student created'}), 201

# PUT: Update a student by ID
@app.route('/students/<int:id>', methods=['PUT'])
@swag_from({
    'tags': ['Students'],
    'description': 'Update an existing student by ID',
    'parameters': [
        {
            'name': 'id',
            'in': 'path',
            'type': 'integer',
            'required': True,
            'description': 'Student ID'
        },
        {
            'name': 'body',
            'in': 'body',
            'required': True,
            'schema': {
                'type': 'object',
                'properties': {
                    'name': {'type': 'string'},
                    'age': {'type': 'integer'},
                    'major': {'type': 'string'}
                }
            }
        }
    ],
    'responses': {
        200: {'description': 'Student updated'},
        404: {'description': 'Student not found'}
    }
})
def update_student(id):
    data = request.get_json()
    updated = Student.update_student(id, data.get('name'), data.get('age'), data.get('major'))
    if not updated:
        logger.warning(f"Student with ID {id} not found for update.")
        abort(404, 'Student not found')
    logger.info(f"Student with ID {id} updated successfully.")
    return jsonify({'message': 'Student updated'}), 200

@app.route('/students', methods=['GET'])
@swag_from({
    'tags': ['Students'],
    'description': 'Retrieve all students',
    'responses': {
        200: {
            'description': 'List of students',
            'schema': {
                'type': 'array',
                'items': {
                    'type': 'object',
                    'properties': {
                        'id': {'type': 'integer'},
                        'name': {'type': 'string'},
                        'age': {'type': 'integer'},
                        'major': {'type': 'string'}
                    }
                }
            }
        }
    }
})
def get_students():
    students = Student.get_students()
    return jsonify(students), 200

@app.route('/students/<int:id>', methods=['GET'])
@swag_from({
    'tags': ['Students'],
    'description': 'Retrieve a single student by ID',
    'parameters': [
        {
            'name': 'id',
            'in': 'path',
            'type': 'integer',
            'required': True,
            'description': 'Student ID'
        }
    ],
    'responses': {
        200: {
            'description': 'Student details',
            'schema': {
                'type': 'object',
                'properties': {
                    'id': {'type': 'integer'},
                    'name': {'type': 'string'},
                    'age': {'type': 'integer'},
                    'major': {'type': 'string'}
                }
            }
        },
        404: {'description': 'Student not found'}
    }
})
def get_student(id):
    student = Student.get_student_by_id(id)
    if student:
        return jsonify(student), 200
    abort(404, 'Student not found')

@app.route('/students/<int:id>', methods=['DELETE'])
@swag_from({
    'tags': ['Students'],
    'description': 'Delete a student by ID',
    'parameters': [
        {
            'name': 'id',
            'in': 'path',
            'type': 'integer',
            'required': True,
            'description': 'Student ID'
        }
    ],
    'responses': {
        200: {
            'description': 'Student deleted',
            'schema': {
                'type': 'object',
                'properties': {
                    'message': {'type': 'string'}
                }
            }
        },
        404: {'description': 'Student not found'}
    }
})
def delete_student(id):
    student = Student.get_student_by_id(id)
    if student:
        Student.delete_student(id)
        return jsonify({'message': 'Student deleted'}), 200
    abort(404, 'Student not found')

if __name__ == '__main__':
    app.run(debug=True, port=5050)
