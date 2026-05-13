# E-Commerce 
This project is a simple web application I built while practicing Java web development. It’s a small product system where users can register, log in, browse products, and write reviews, while admins can manage products by adding, editing, and deleting them.

I tried to apply what I learned in Servlets and JSP and understand how a full request goes from the browser to the backend and then to the database and back again. The structure is split into layers: JSP for the interface, Servlets for handling requests, a service layer for the logic, and DAO for database operations with MySQL. I also added Redis in a simple way to improve performance a bit by caching some data instead of hitting the database every time.

For security, passwords are hashed instead of being stored as plain text, and there is basic login protection so some pages are only accessible after authentication. I also handled some basic HTTP error pages like 403, 404, and 500 to make the flow cleaner when something goes wrong.

On the user side, anyone can create an account, log in, see products, and add reviews. On the admin side, there is control over products like adding new ones, updating existing ones, or deleting them. Everything is connected in a simple flow where the request goes from JSP to Servlet, then Service, then DAO, then MySQL, and the response comes back to the user.

Overall, this project helped me understand how Java web applications are actually built in real life, how layers interact with each other, and how data moves between the frontend and backend.
