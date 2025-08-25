# mastering-sql

This repository is dedicated to practicing and mastering SQL through hands-on exercises.  
It contains SQL scripts to create tables, insert data, and run queries for learning purposes.

---

## Table of Contents
- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Setup Instructions](#setup-instructions)
- [Running SQL Scripts](#running-sql-scripts)
- [Directory Structure](#directory-structure)
- [Contributing](#contributing)
- [License](#license)

---

## Overview
- Use this repository to practice SQL queries, learn database concepts, and experiment with different setups.
- The main database setup is configured via Docker with PostgreSQL, providing an isolated and reproducible environment.
- You can add your own SQL scripts in the `exercises/` folder and run them inside your PostgreSQL instance.

---

## Prerequisites
Make sure you have:
- [Docker Desktop](https://www.docker.com/products/docker-desktop) installed and running.
- [VS Code](https://code.visualstudio.com/) with SQLTools extension (recommended for running queries).

---

## Setup Instructions

### 1. Clone this repository
```bash
git clone https://github.com/yourusername/mastering-sql.git
cd mastering-sql
```

### 2. Prepare setup directories
Create necessary folders:

```bash
mkdir -p data exercises/01-basic-queries initial-scripts
```

### 3. Configure Docker Compose
Ensure your `docker-compose.yml` is ready with the following settings:

```yaml
version: '3.8'

services:
  postgres:
    image: postgres:16
    container_name: mastering-sql-postgres
    environment:
      POSTGRES_DB: mastering_sql
      POSTGRES_USER: sql_learner
      POSTGRES_PASSWORD: learning123
      POSTGRES_HOST_AUTH_METHOD: trust
    ports:
      - "5432:5432"
    volumes:
      - ./data:/var/lib/postgresql/data            # Persist database data
      - ./exercises:/exercises                     # Your SQL practice scripts
      - ./initial-scripts:/docker-entrypoint-initdb.d  # Run initial scripts once
```

### 4. Run PostgreSQL with Docker
Start the database:

```bash
docker-compose up -d
```

This will:
- Launch PostgreSQL server.
- Execute any SQL scripts in `initial-scripts/` **once** during the first run.
- Persist data in the `data/` folder for future use.

---

## How to Install and Use SQLTools in VS Code

### 1. Install the SQLTools Extension
- Open **VS Code**.
- Go to the **Extensions View**: press `Cmd+Shift+X`.
- Search for **SQLTools**.
- Find **SQLTools – Database Tools**, published by **Matheus Teixeira**.
- Click **Install**.
- Also, install the **SQLTools PostgreSQL / MySQL / Mssql Driver** extension by searching for it and installing.

---

### 2. Add a New Connection to PostgreSQL
- After installing, press `Cmd+Shift+P`.
- Search for **SQLTools: Add New Connection**.
- Choose **PostgreSQL** from the list.
- Fill in the connection details:
  - **Connection Name:** e.g., `Local PostgreSQL`
  - **Server / Host:** `localhost`
  - **Port:** `5432`
  - **Database:** `mastering_sql`
  - **User:** `sql_learner`
  - **Password:** `learning123`
  - **SSL Mode:** `Disable` (default for local)
- Save the connection.

### 3. Connect to PostgreSQL
- In the SQLTools sidebar, locate your saved connection.
- Right-click and choose **Connect**.
- Wait for the connection to establish (status bar should show connected).

### 4. Open Your SQL Files
- Open your script, e.g., `exercises/01-basic-queries/basic-queries.sql`.
- Make sure your connection is highlighted/active.
- Highlight the whole script or the part you want to run.
- Press `Cmd + Enter` or click **Run**.
- View the output/results in the bottom panel.

---

## Running SQL Scripts

### Using **VS Code + SQLTools**
1. Connect to your PostgreSQL database (host: `localhost`, port: `5432`, username: `sql_learner`, password: `learning123`, database: `mastering_sql`).
2. Open your SQL scripts located in the `exercises/` folder.
3. Highlight the queries you want to run.
4. Press `Cmd + Enter` to execute.
5. View query results in the output panel below.

### Using **docker exec**
Run scripts directly inside container:

```bash
docker exec -it mastering-sql-postgres psql -U sql_learner -d mastering_sql -f /exercises/your-script.sql
```

---

## Directory Structure
```
mastering-sql/
│
├── data/                       # Persistent database data (do NOT check into Git)
├── exercises/                  # Your SQL practice scripts
│   └── 01-basic-queries/       # Basic SQL exercises
│       └── basic-queries.sql   # Example SQL script
├── initial-scripts/             # Scripts to run once at first startup
│   └── setup.sql                # Initial setup scripts
└── docker-compose.yml           # Docker configuration for PostgreSQL
└── README.md                    # This file
```

---

## Best Practices
- **Do NOT** commit the `data/` folder to version control—add it to `.gitignore`.
- Use the `exercises/` folder to organize your learning scripts.
- Restart the container anytime with:

```bash
docker-compose down
docker-compose up -d
```

---

## Contributing
Feel free to fork, make improvements, and submit pull requests to enhance this learning environment.

---

## License
This project is for educational purposes. Use freely and adapt as needed.

---

**Happy learning! 🚀**
```

---