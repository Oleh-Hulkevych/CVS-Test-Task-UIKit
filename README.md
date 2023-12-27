### Computer Voice Systems - Test Task / UIKit / Mock data

***

![Preview](https://github.com/Oleh-Hulkevych/CVS-Test-Task-UIKit/assets/109086187/d82d1573-097b-4fe4-ae7e-98402ca8c3f9)

***

Movies / A small test task (an application that shows movie information for the user) for Computer Voice Systems with local data in JSON format.

The initial screen displays a movie list along with a sorting button positioned at the top. This button locally arranges our movie collection based on the movie titles and release dates. By default, the movie order reflects the sequence specified in the JSON file at the program's launch or when you refresh the list by dragging it.

Each cell showcases a movie image, movie title, a brief description including movie duration and genre, and an 'ON MY WATCHLIST' button if the movie has been added to the watchlist.

> Note: The label "ON MY WATCHLIST" specified in the test task has been changed by me to a button! This allows the user to easily remove the movie from the watchlist without navigating to the second screen (movie detail view controller)... After pressing the "ON MY WATCHLIST" button in the cell, you will be asked: "Are you sure you want to remove the movie from the watchlist?", and two buttons, "Remove" and "Cancel," will be displayed on the screen.

The second screen presents comprehensive details about the movie, including an image, title, rating, a brief movie description, and specifics such as genre and release date.
Additionally, below the labels for "movie title" and "movie rating," there are two buttons: "+ ADD TO WATCHLIST" (which changes to "REMOVE FROM WATCHLIST" when the movie is added to the watchlist), and the "WATCH TRAILER" button.

> Note: Upon tapping the "+ ADD TO WATCHLIST" button, it not only changes its label but also adds an "ON MY WATCHLIST" button to the movie's cell within the movies list. Movie cells also retain their state consistently, except when the application is restarted.

> Note: The "WATCH TRAILER" button will open the YouTube app if it's installed on the iPhone; otherwise, it will present a full-screen Safari browser controller.

***

Furthermore, I wanted to mention that I've made some design changes, added specific colors, configured the sorting button using text and an image in the navigation bar, implemented light and dark themes, and a few other minor changes that I hope you'll like.

***

Used stack:

Swift / UIKti / Auto Layout / HIG / MVC + Coordinator / JSON.

Also, iOS 15 or higher is supported.

***

Thanks for reading this far! :smile:

Have a nice day & happy coding! :wink:

***
