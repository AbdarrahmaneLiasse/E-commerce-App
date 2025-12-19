🛒 <h2>E-Commerce Mobile Application</h2>
A full-stack e-commerce mobile application built with Flutter, Spring Boot, and MySQL.
This project demonstrates how to build a modern, secure, and scalable mobile commerce platform from scratch.


🚀 <h3>Features</h3>

👤 User Features

User registration & login (JWT authentication)

Browse products

View product details

Add/remove products from cart

Place orders

View order history


🛠️ <b>Admin Features</b>

Manage products (create, update, delete)

Manage categories

View and manage orders


🧰 <b>Tech Stack</b>

-Frontend (Mobile App)
Flutter- 
Dart- 
REST API integration- 
Clean & responsive UI

-Backend (API)
Spring Boot- 
Spring Security + JWT- 
Spring Data JPA & Hibernate- 
RESTful architecture- 

-Database
MySQL


📱 <b>Application Architecture</b>

Flutter App  →  Spring Boot REST API  →  MySQL Database
Flutter handles UI and user interaction- 
Spring Boot manages business logic and security- 
MySQL stores users, products, orders, and categories- 


🔐 <b>Security</b>

JWT-based authentication- 
Role-based access (USER / ADMIN)- 
Secured API endpoints using Spring Security- 


⚙️<b> Installation & Setup</b>

<b>Backend (Spring Boot)</b>

Clone the repository:

git clone https://github.com/your-username/your-repo-name.git

<b>Configure MySQL in application.properties:</b>

spring.datasource.url=jdbc:mysql://localhost:3306/ecommerce_db

spring.datasource.username=root

spring.datasource.password=your_password


<b>Run the backend:</b>

mvn spring-boot:run


<b>Backend will start on:</b>

http://localhost:8080


<b>Frontend (Flutter)</b>

-Navigate to the Flutter project folder:

cd frontend

-Install dependencies:

flutter pub get

-Run the app:

flutter run
