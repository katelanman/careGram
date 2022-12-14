from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db
import base64


generic_users = Blueprint('generic_users', __name__)

# Get all generic_users from the DB
@generic_users.route('/generic_users', methods=['GET'])
def get_users():
    cursor = db.get_db().cursor()
    cursor.execute('select * from generic_user')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        row = list(row)
        if row[7] is not None:
            row[7] = row[7].decode('utf-8')
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# add user 
@generic_users.route('/signup', methods = ['POST'])
def add_user():
    current_app.logger.info(request.form)
    cursor = db.get_db().cursor()
    fname = request.form['fname']
    lname = request.form['lname']
    user = request.form['user']
    passw = request.form['passw']
    bday = request.form['bday']
    email = request.form['email']
    phone = request.form['phone']
    pfp = request.form['pfp']
    query = f'INSERT INTO \
        generic_user(first_name, last_name, username, user_password, birthday, email, phone, profile_pic) \
        VALUES(\"{fname}\", \"{lname}\",\"{user}\", \"{passw}\", \"{bday}\",\"{email}\", \"{phone}\", \"{pfp}\")'
    cursor.execute(query)
    db.get_db().commit()
    return "Success!"

# change current user's profile picture
@generic_users.route('/changeProfilePic', methods=['POST'])
def new_pic():
    current_app.logger.info(request.form)
    cursor = db.get_db().cursor()
    pfp = request.form['pfp']
    user = request.form['user']
    query = f'UPDATE generic_user \
            SET profile_pic = (\"{pfp}\") \
            WHERE user_id = {user}'
    cursor.execute(query)
    db.get_db().commit()
    return "Success!"

# calculate a user's following and update
@generic_users.route('/follow_count', methods=['POST'])
def count_following():
    current_app.logger.info(request.form)
    cursor = db.get_db().cursor()
    user = request.form['user']
    query = f'UPDATE generic_user \
            SET num_following = ( \
                (SELECT COUNT(user_id) FROM user_follow_user \
                 WHERE user_id = {user}) + \
                (SELECT COUNT(user_id) FROM user_follow_org \
                 WHERE user_id = {user})) \
            WHERE user_id = {user}'
    cursor.execute(query)
    db.get_db().commit()
    return "Success!"
 
# calculate a user's followers and update
@generic_users.route('/follower_count', methods=['POST'])
def count_followers():
    current_app.logger.info(request.form)
    cursor = db.get_db().cursor()
    user = request.form['user']
    query = f'UPDATE generic_user \
            SET num_followers = ( \
                SELECT COUNT(follow_id) FROM user_follow_user \
                WHERE follow_id = {user}) \
            WHERE user_id = {user}'
    cursor.execute(query)
    db.get_db().commit()
    return "Success!"

# get a list of user's followers
@generic_users.route('/followers', methods=['GET'])
def get_followers():
    current_app.logger.info(request.form)
    cursor = db.get_db().cursor()
    user = request.form['user']
    query = f'select u.user_id as id, u.username as username, \
        CONCAT(u.first_name, \" \", u.last_name) as name \
        from generic_user u \
        where u.user_id in (select uu.user_id from user_follow_user uu \
                            where follow_id = {user})'
    cursor.execute(query)
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row))) 
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# get a list of user's followers
@generic_users.route('/following', methods=['GET'])
def get_following():
    current_app.logger.info(request.form)
    cursor = db.get_db().cursor()
    user = request.form['user']
    query = f'(select u.user_id as id, u.username as username,\
        CONCAT(u.first_name, \" \", u.last_name) as name, \"user\" as type \
        from generic_user u \
        where u.user_id in (select uu.follow_id from user_follow_user uu \
                            where user_id = {user})) \
            UNION ALL \
            (select o.org_id as id, o.username as username, o.org_name as name, \"org\" as type \
             from organization o where o.org_id in ( \
                                select uo.follow_id from user_follow_org uo \
                                where user_id = {user}))'
    cursor.execute(query)
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row))) 
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response
       
    
    
    
    
    
    
    
    
    
    
    
    
    
    
			