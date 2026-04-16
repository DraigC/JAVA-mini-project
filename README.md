# A3 Project Registry

A simple Java web application built with JSP and MySQL for managing project team registrations. The app lets you create, view, edit, and delete project records from a `teams` table in a MySQL database.

## Features

- Register a new project with team name, title, description, and members
- List all registered projects on the home page
- Edit an existing project entry
- Delete a project entry
- Basic duplicate-title rejection during registration using string similarity checks

## Tech Stack

- Java EE / JSP
- Apache Tomcat 9
- MySQL
- MySQL Connector/J

## Project Structure

- `src/main/webapp/index.jsp` - lists all registered projects
- `src/main/webapp/register.jsp` - registration form and insert logic
- `src/main/webapp/edit.jsp` - update form and update logic
- `src/main/webapp/delete.jsp` - delete handler
- `src/main/webapp/WEB-INF/lib/mysql-connector-j-9.6.0.jar` - JDBC driver

## Database Setup

Create the database and table before running the app:

```sql
CREATE DATABASE project_registry;

USE project_registry;

CREATE TABLE teams (
  team_id INT AUTO_INCREMENT PRIMARY KEY,
  team_name VARCHAR(255) NOT NULL,
  project_title VARCHAR(255) NOT NULL,
  description TEXT,
  members TEXT
);
```

The JSP files currently connect with these default credentials:

- Host: `localhost`
- Port: `3306`
- Database: `project_registry`
- Username: `root`
- Password: `root`

If your local MySQL setup uses different credentials, update the JDBC connection strings in the JSP files.

## How to Run

1. Import the project into Eclipse as a Dynamic Web Project or existing web project.
2. Make sure Tomcat 9 is configured in the workspace.
3. Create the `project_registry` database and `teams` table.
4. Update the MySQL username and password in the JSP files if needed.
5. Deploy the app to Tomcat and open `index.jsp` in the browser.

## Notes

- The app logic is implemented directly inside JSP pages.
- The `build/` folder is generated output and should not be committed.
- The `.classpath` file in this workspace references JavaSE-25 and a Tomcat 9 runtime.