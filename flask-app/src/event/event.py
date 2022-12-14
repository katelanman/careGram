from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db

event = Blueprint('event', __name__)

# get all events
@event.route('/events', methods=['GET'])
def get_events():
    # get a cursor object from the database
    cursor = db.get_db().cursor()

    # use cursor to query the database for a list of orgs
    cursor.execute('select * from event order by posted_on desc')

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
        # decode images
        row = list(row)
        if row[5] is not None:
            row[5] = row[5].decode('utf-8')
        json_data.append(dict(zip(column_headers, row)))

    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# creates sign in sheet
def create_sign_in(eName, link, descr):
    cursor = db.get_db().cursor()
    query = f'INSERT INTO sign_in_sheet(event_id, event_name) \
    VALUES((SELECT event_id FROM event WHERE event_name = \"{eName}\" AND \
    link = \"{link}\" AND descr = \"{descr}\"), \"{eName}\")'
    cursor.execute(query)
    db.get_db().commit()

# posts new event to database
@event.route('/new_event', methods=['POST'])
def add_event():
    current_app.logger.info(request.form)
    cursor = db.get_db().cursor()
    ename = request.form['ename']
    link = request.form['link']
    age_r = request.form['age_r']
    loc = request.form['loc']
    desc = request.form['desc']
    num_vol = request.form['num_vol']
    time = request.form['time']
    postPic = request.form['postPic']
    query = f'INSERT INTO \
        event(event_name, link, age_restriction, location, descr, num_volunteers, event_time, image) \
        VALUES(\"{ename}\", \"{link}\",\"{age_r}\", \"{loc}\", \"{desc}\",\"{num_vol}\", \"{time}\", \"{postPic}\")'
    cursor.execute(query)
    db.get_db().commit()

    # call create sign in for new event
    create_sign_in(ename, link, desc)
    return "Success!"

# get information for the wanted event
@event.route('/current_event', methods = ['GET'])
def current_event():

    current_app.logger.info(request.form)
    # get a cursor object from the database
    cursor = db.get_db().cursor()

    e_id = request.form['e_id']
    
    query = f'SELECT * FROM event WHERE event_id = {e_id}'
    # use cursor to query the database for a list of orgs
    cursor.execute(query)

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
        row = list(row)
        if row[5] is not None:
            row[5] = row[5].decode('utf-8')
        json_data.append(dict(zip(column_headers, row)))

    return jsonify(json_data)

# add user to sign up sheet 
@event.route('/e_signup', methods = ['POST'])
def add_user():
    current_app.logger.info(request.form)
    cursor = db.get_db().cursor()
    first_name = request.form['first_name']
    last_name = request.form['last_name']
    event_email = request.form['event_email']
    event_phone = request.form['event_phone']
    user_id = request.form['user_id']
    e_id = request.form['e_id']
    
    query = f'INSERT INTO \
        sheet_line(sheet_id, first_name, last_name, email, phone, user_id) \
        VALUES((SELECT sheet_id from sign_in_sheet WHERE event_id = {e_id}), \"{first_name}\", \"{last_name}\", \"{event_email}\", \"{event_phone}\", {user_id})'
    cursor.execute(query)
    db.get_db().commit()
    return "Success!"

# update number of volunteers signed up for an event
@event.route('/update_volunteers', methods=['POST'])
def updateV():
    current_app.logger.info(request.form)
    cursor = db.get_db().cursor()
    
    e_id = request.form['e_id']
    cursor.execute(f'UPDATE sign_in_sheet SET total_volunteers = (total_volunteers + 1) WHERE event_id = {e_id}')
    db.get_db().commit()
    return "Success!"






