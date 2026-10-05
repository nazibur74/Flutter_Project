# Zstore - Inventory Management System

Zstore is a mobile inventory and sales management application built with
**Flutter** and **Dart**. It is designed to help small businesses manage
products, stock, employees, suppliers, and sales from a single mobile
application.

The application uses **SQLite** for local data storage, making it
possible to manage business data directly on the device without
requiring a separate backend server.

## ✨ Features

-   📦 **Product Management**
    -   Add, update, view, and manage products
    -   Track product quantity and stock information
-   👨‍💼 **Employee Management**
    -   Add and manage employee information
    -   Update or remove employee records
-   🚚 **Supplier Management**
    -   Store and manage supplier information
    -   Keep supplier details organized with product records
-   🛒 **Sales / POS**
    -   Add products to a sales cart
    -   Process sales from the mobile application
    -   Automatically update stock after a sale
    -   Generate sales bills/invoices
-   📊 **Dashboard & Business Insights**
    -   View important inventory and sales information
    -   Get a quick overview of business activity
-   📑 **Excel Export**
    -   Export stored business data to Excel
    -   Useful for reporting, backup, and further analysis
-   💾 **Local Database**
    -   Uses SQLite for persistent local storage
    -   Supports efficient CRUD operations without an internet
        connection
-   🎨 **User-Friendly Interface**
    -   Clean and simple mobile UI
    -   Designed for practical day-to-day inventory operations

## 🛠️ Technologies Used

  Technology       Purpose
  ---------------- -------------------------------------------
  **Flutter**      Mobile application development
  **Dart**         Application programming language
  **SQLite**       Local database
  **sqflite**      SQLite integration in Flutter
  **Flutter UI**   Application interface and user experience

## 🏗️ Core Modules

``` text
Zstore
│
├── Dashboard
│   └── Business & inventory overview
│
├── Products
│   ├── Add Product
│   ├── Update Product
│   ├── Delete Product
│   └── Stock Management
│
├── Employees
│   ├── Add Employee
│   ├── Update Employee
│   └── Delete Employee
│
├── Suppliers
│   └── Supplier Management
│
├── Sales / POS
│   ├── Product Selection
│   ├── Shopping Cart
│   ├── Sales Processing
│   ├── Stock Update
│   └── Bill / Invoice
│
└── Excel Export
    └── Export Business Data
```

## 🗄️ Data Management

Zstore uses a local **SQLite database** to store application data.

The database is responsible for maintaining information such as:

-   Products
-   Stock quantities
-   Employees
-   Suppliers
-   Sales
-   Customer/sales information
-   Other application records

The application performs standard **CRUD (Create, Read, Update,
Delete)** operations to manage these records.

## 🔄 Sales Workflow

A typical sales process works like this:

``` text
Select Product
      ↓
Add Product to Cart
      ↓
Set Quantity
      ↓
Calculate Total
      ↓
Confirm Sale
      ↓
Save Sale
      ↓
Update Stock
      ↓
Generate Bill / Invoice
```

## 📱 Application Purpose

Zstore was developed as a practical inventory management solution for
businesses that need a simple way to manage their daily operations from
a mobile device.

Instead of maintaining separate records for products, employees,
suppliers, and sales, ZStore brings these operations together in one
application.

## 🚀 Getting Started

### Prerequisites

Make sure you have the following installed:

-   [Flutter](https://flutter.dev/)
-   Dart SDK
-   Android Studio or VS Code
-   Android emulator or a physical Android device

### Installation

Clone the repository:

``` bash
git clone https://github.com/nazibur74/Zstore.git
```

Navigate to the project directory:

``` bash
cd ZStore
```

Install dependencies:

``` bash
flutter pub get
```

Run the application:

``` bash
flutter run
```

> Replace the repository URL above if the Zstore repository uses a
> different GitHub URL.

## 📂 Suggested Project Structure

``` text
lib/
├── models/
├── database/
├── screens/
├── widgets/
├── services/
└── main.dart
```

The exact structure may vary depending on the current implementation.

## 🔐 Data Storage

Zstore is designed around local-first data management. Business records
are stored locally using SQLite, allowing the core inventory and sales
functionality to work without depending on a remote database.

## 🎯 Project Goals

The main goals of Zstore are to:

-   Simplify inventory management
-   Reduce manual record keeping
-   Make sales processing faster
-   Automatically maintain stock quantities
-   Keep employee and supplier information organized
-   Provide useful business information from one mobile application
-   Make business data exportable for reporting and analysis

## 📌 Project Status

**Status:** Completed / Portfolio Project

Zstore was developed as a Flutter-based inventory management application
demonstrating practical mobile application development, local database
management, CRUD operations, POS functionality, and business data
handling.

## 👨‍💻 Developer

**Md. Nazibur Rahman**

B.Sc. in Computer Science & Engineering

GitHub: [nazibur74](https://github.com/nazibur74)

------------------------------------------------------------------------

⭐ If you find this project useful, consider giving the repository a
star.
