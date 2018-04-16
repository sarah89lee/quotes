## TODO
- Feed Pagination
  - The feed should only load x amount from the server and check for hasMore as the user scrolls. If hasMore == true, load the next batch before the user reaches the bottom
- User Authentication
  - Right now the app uses the phoneNumber entered to log in and mock data instead of doing a real login with authentication.

## TL;DR
- User login is just taking in a phoneNumber so we can detect who the loggedInUser is from the phone’s contacts
- Data is mocked by creating a user object for every contact that has a first and last name. 
- Quotes are generated from a json file found on GitHub
- Dates are randomly generated
- Data is stored on Google Firebase
