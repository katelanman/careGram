from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db


organizations = Blueprint('organizations', __name__)

# get all organizations
@organizations.route('/organizations', methods=['GET'])
def get_orgs():
    # get a cursor object from the database
    cursor = db.get_db().cursor()

    # use cursor to query the database for a list of orgs
    cursor.execute('select * from organization')

    # grab the column headers from the returned data
    column_headers = [x[0] for x in cursor.description]

    # create an empty dictionary object to use in 
    # putting column headers together with data
    json_data = []

    # fetch all the data from the cursor  
    theData = cursor.fetchall()

    # for each of the rows, zip the data elements together with
    # the column headers. 
    for row in theData:
        json_data.append(dict(zip(column_headers, row)))

    return jsonify(json_data)

# map new posted event to org that posted it
@organizations.route('/posted_event', methods=['POST'])
def post_event():
    current_app.logger.info(request.form)
    cursor = db.get_db().cursor()
    org_id = request.form['org_id']
    query = f'INSERT INTO org_event(org_id, event_id) \
        VALUES({org_id}, \
        (SELECT event_id FROM event ORDER BY event_id DESC LIMIT 0,1))'
    cursor.execute(query)
    db.get_db().commit()
    return "Success!"





