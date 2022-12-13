CareGram Project
This repo contains the code and infrastructure to run the back-end containers:
1. A MySQL 8 container for creating the CareGram database and adding mock data.
2. A Python Flask container to implement the REST API for our project.
How to setup and start the containers
1. Build the images with docker compose build
2. Start the containers with docker compose up. To run in detached mode, run docker compose up -d.
3. Connect through ngrok with ./ngrok http 8001.
4. In the CareGram Appsmith, edit the CareGram datasource to add your forwarding url. 


For using the CareGram app:
  

1. App pages
   1. profile, create account, and event sign up are generic user pages
   2. post event is an organization user page
2. Use the drop down menu to switch which profile you are viewing.
3. Click the current profile picture to change the current user’s profile picture.
4. Use the followers, following, and find events buttons to control the view in the bottom left pane. 
5. The sign up button on each event takes the user to the sign up page.
6. The link button on each event takes the user to the link of the event (if one was posted).
7. The sign up button at the top takes the user to the “Create new profile” page.
  

8. On the Event Sign up page, use the dropdown in the top right corner in order to select which user you are signing up.