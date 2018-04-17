## UPDATE V2
- No longer using Firebase
- Data parsed and store in a plist
- Fixed search to show both Said By and Heard By. It was only filtering for Said By users.
- Fixed tab bar underline returning back to index 0 whenever view appears again.

## NOTES
- Only tested on iPhone X iOS 11.3
- Must run on an actual device since we are using the phone's contacts to mock data.

## TL;DR
- User login is just taking in a phoneNumber so we can detect who the loggedInUser is from the phone’s contacts
- Data is mocked by creating a user object for every contact that has a first and last name. 
- Quotes are generated from a json file found on GitHub
- Dates are randomly generated
- Data is stored on Google Firebase
- Quotes are sent to Firebase and Feed is updated with new quote.
- Contacts library was found on Github and does not display properly on an iPhone X. Also, it is not sorted.

## TODO
- Caching feed
  - Loading the feed is really slow since it pulls in the all quotes and users from the database on every launch. 
- Feed Pagination
  - The feed should only load x amount from the server and check for hasMore as the user scrolls. If hasMore == true, load the next batch before the user reaches the bottom
- User Authentication
  - Right now the app uses the phoneNumber entered to log in and mock data instead of doing a real login with authentication.
- Contacts Select
  - Currently using a custom contact select found on Github (SwiftMultiSelect). UI is not sized correctly with some bugs, but figured this is a quick pod to throw in for this assignment.
  - Should create own custom contacts selection.
- Check Text Fields
  - Valiate all text fields are correct: phone numbers, passwords, month, year, day.
- Presenting User Profiles
  - An idea response from the server will return Quotes with User objects, which will make presenting user profiles easier. Right now the mock data is created for the purpose of displaying data quickly for the assignment. NOT THE BEST. 
- GenerateUsersAndQuotesController
  - This class is bloated, but is just used to mock data. 

## DESIGN CHANGES
- Since the Quotes button displays a modal and is not an actual tab, I made it into a button that hovers over the tab bar instead. See screenshot below.

## SCREENSHOTS
![feed](https://github.com/sarah89lee/quotes/blob/34ddf15b683dac1f8e062911188e60a43faa387a/Quotes/Supporting%20Files/Screenshots/Feed.PNG) ![profile](https://github.com/sarah89lee/quotes/blob/34ddf15b683dac1f8e062911188e60a43faa387a/Quotes/Supporting%20Files/Screenshots/Profile.PNG) ![search](https://github.com/sarah89lee/quotes/blob/34ddf15b683dac1f8e062911188e60a43faa387a/Quotes/Supporting%20Files/Screenshots/Search.PNG) ![quote](https://github.com/sarah89lee/quotes/blob/34ddf15b683dac1f8e062911188e60a43faa387a/Quotes/Supporting%20Files/Screenshots/Quote.PNG) ![review](https://github.com/sarah89lee/quotes/blob/34ddf15b683dac1f8e062911188e60a43faa387a/Quotes/Supporting%20Files/Screenshots/Review.PNG)
