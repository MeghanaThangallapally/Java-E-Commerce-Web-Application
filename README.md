# ⚡ ShopFlow — Java E-Commerce Web Application

A fully functional, dynamic e-commerce web application built with Java EE technologies. Supports user registration & authentication, product browsing, cart management, and order processing — backed by a MySQL database via JDBC.
---

## ✨ Features

### 👤 User Module
- Secure **Registration & Login** with session management
- Password hashing for secure credential storage
- Profile management and session-based authentication

### 🛍️ Product Module
- Browse and **search products** by name/category
- Dynamic product listing fetched via JDBC
- Product detail pages with stock availability

### 🛒 Cart & Order Module
- Add/remove items from the cart
- Adjust quantities with real-time price calculation
- Place orders with automatic stock deduction
- Order history per user

### 🔧 Admin Module
- Add, update, and delete products
- View all user orders
- Manage inventory and stock levels

---

## 🗂️ Project Structure

```
ShopFlow/
├── src/
│   └── main/
│       ├── java/
│       │   └── com/shopflow/
│       │       ├── servlet/
│       │       │   ├── LoginServlet.java
│       │       │   ├── RegisterServlet.java
│       │       │   ├── ProductServlet.java
│       │       │   ├── CartServlet.java
│       │       │   ├── OrderServlet.java
│       │       │   └── AdminServlet.java
│       │       ├── dao/
│       │       │   ├── UserDAO.java
│       │       │   ├── ProductDAO.java
│       │       │   └── OrderDAO.java
│       │       ├── model/
│       │       │   ├── User.java
│       │       │   ├── Product.java
│       │       │   ├── Cart.java
│       │       │   └── Order.java
│       │       └── util/
│       │           ├── DBConnection.java
│       │           └── PasswordUtil.java
│       └── webapp/
│           ├── WEB-INF/
│           │   └── web.xml
│           ├── jsp/
│           │   ├── index.jsp
│           │   ├── login.jsp
│           │   ├── register.jsp
│           │   ├── products.jsp
│           │   ├── cart.jsp
│           │   ├── orders.jsp
│           │   └── admin/
│           │       ├── dashboard.jsp
│           │       └── productManagement.jsp
│           ├── css/
│           │   └── style.css
│           └── js/
│               └── main.js
├── sql/
│   └── schema.sql
├── pom.xml
└── README.md
```

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| Backend | Java (Servlets, JSP) |
| Database | MySQL 8.x |
| DB Connectivity | JDBC |
| Server | Apache Tomcat 9.x |
| Build Tool | Maven |
| Frontend | HTML5, CSS3, JavaScript |

---


## 🧠 Key Learning Outcomes

- JDBC connection pooling and prepared statements to prevent SQL injection
- MVC architecture with Servlets (Controller) + JSP (View) + DAO (Model)
- HTTP session management for login state and cart persistence
- Database transactions for atomic order placement

---

> Built with Java · Made for learning and showcasing full-stack Java web development
