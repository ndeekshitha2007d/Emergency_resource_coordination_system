# 🚨 Emergency Resource Coordination System (ERCS)

A Java Enterprise Edition (Java EE) web application designed for real-time emergency resource dispatching and tracking. Built using pure **Java Servlets, JSP, JDBC, and MySQL**, the system provides real-time resource status management, historical audit logging, client-side validation, and a styled operator dashboard.

---

## 🌟 Key Features

* **Real-Time Dispatching:** Form interface allowing operators to assign resources to critical emergency incidents.
* **Input Validation:** Client-side JavaScript validation with regex string parsing to enforce strict Resource ID formatting (`RES-XXXX`).
* **Relational Persistence & Audit Logging:** Updates resource inventory in MySQL and records every event into a historical `dispatch_logs` audit table.
* **Dynamic Operator Dashboard:** Modern dashboard UI built with JSP and styled CSS featuring status indicator badges, metric cards, and clean inventory tables.
* **MVC Architecture:** Strict separation of concerns using Data Access Objects (`ResourceDAO`), JavaBeans (`ResourceBean`), Control Servlets (`DispatchServlet`), and Dynamic Views (`dashboard.jsp`).

---

## 🛠️ Tech Stack

* **Language:** Java 17 (JDK 17)
* **Backend:** Java Servlets (`javax.servlet`), JSP (JavaServer Pages), JDBC
* **Frontend:** HTML5, CSS3, JavaScript (DOM Validation)
* **Database:** MySQL / phpMyAdmin
* **Application Server:** Apache Tomcat 9.x
* **IDE & Tooling:** Visual Studio Code (Community Server Connectors), Git

---

## 📁 Project Structure

```text
Emergency_resource_coordination_system/
├── src/
│   └── com/ercs/
│       ├── controller/
│       │   └── DispatchServlet.java     # Route handler for dispatch POST/GET requests
│       ├── dao/
│       │   ├── DBConnection.java        # MySQL JDBC Driver configuration & connections
│       │   └── ResourceDAO.java         # SQL queries for resource status & audit logging
│       └── model/
│           └── ResourceBean.java        # Data Transfer Object (DTO) for resource items
├── WebContent/
│   ├── js/
│   │   └── validation.js                # Regex client validation script
│   ├── WEB-INF/
│   │   ├── classes/                     # Compiled bytecode output
│   │   └── lib/                         # MySQL Connector/J & Servlet API dependencies
│   ├── dispatch_request.html            # Emergency Dispatch form interface
│   └── dashboard.jsp                    # Operator Live Inventory & Status Dashboard
├── .gitignore
└── README.md