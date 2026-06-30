# 🐦 Social Media REST API — Ballerina

A Twitter-like Social Media REST API built from scratch using **Ballerina**, developed as part of my WSO2 internship learning journey.

---

## 📌 Project Overview

This project is a backend REST API for a social media platform supporting users, posts, and followers. It is built progressively, covering 14 features of the Ballerina language and ecosystem from basic REST APIs to security, message brokers, and concurrency.

---

## 🗂️ Entity Relationship

```
users ──< posts
users ──< followers >── users
```

| Table     | Key Fields                                      |
|-----------|-------------------------------------------------|
| users     | id, name, birth_date, mobile_number             |
| posts     | id, description, category, tags, created_date, user_id |
| followers | id, leader_id, follower_id, created_date        |

---

## 🚀 API Endpoints

| Method | Endpoint                        | Description              |
|--------|---------------------------------|--------------------------|
| GET    | `/social_media/users`           | Get all users            |
| GET    | `/social_media/users/{id}`      | Get user by ID           |
| POST   | `/social_media/users`           | Create a new user        |
| DELETE | `/social_media/users/{id}`      | Delete a user            |
| GET    | `/social_media/users/{id}/posts`| Get posts by user        |
| POST   | `/social_media/users/{id}/posts`| Create a post for a user |

---

## 🛠️ Tech Stack

| Technology        | Purpose                        |
|-------------------|--------------------------------|
| Ballerina 2201.13.4| Primary language               |
| MySQL             | Relational database            |
| Ballerina MySQL Connector | Database access       |
| HTTP Client       | Calling external services      |
| NATS              | Message broker (Feature 14)    |

---

## ✅ Features Covered

| # | Feature                        | Status |
|---|--------------------------------|--------|
| 1 | REST API (verbs, URLs, binding)| ✅ Done |
| 2 | Database access (MySQL)        | ✅ Done |
| 3 | Configurability (Config.toml)  | ✅ Done |
| 4 | Data transformation            | ✅ Done |
| 5 | HTTP Client                    | ✅ Done |
| 6 | Resiliency & Retry             | ✅ Done |
| 7 | Writing tests                  | ✅ Done |
| 8 | Slack connector                | ✅ Done |
| 9 | OpenAPI & client stubs         | 🔄 In Progress |
| 10| Validations                    | ⏳ Pending |
| 11| Security — OAuth2              | ⏳ Pending |
| 12| Error handlers                 | ⏳ Pending |
| 13| Ballerina concurrency          | ⏳ Pending |
| 14| Message broker (NATS)          | ⏳ Pending |

---

## ⚙️ Setup & Run

### Prerequisites
- Ballerina 2201.13.4 or higher
- MySQL 8.0 or higher
- Node.js 18+ (only needed for the `frontend/` React app)

### 1. Clone the Repository
```bash
git clone https://github.com/2003dinijay/social-media-app-dini.git
cd social-media-app-dini
```

### 2. Set Up the Database
```bash
mysql -u root -p -e "CREATE DATABASE social_media_database;"
mysql -u root -p social_media_database < db-setup/init.sql
```

### 3. Configure the Backend
Create `backend/Config.toml`:
```toml
dbHost = "localhost"
dbUser = "root"
dbPassword = "your_password"
dbName = "social_media_database"
dbPort = 3306
```

### 4. Run the Backend
```bash
cd backend
bal run
```

The service starts on **https://localhost:9090**

### 5. Run the Frontend (optional)
A React app for exercising the API with WSO2 Identity Server login lives in
`frontend/` — see [`frontend/README.md`](frontend/README.md) for setup.
```bash
cd frontend
npm install
npm run dev
```

---

## 📁 Project Structure

```
social-media-app-dini/
├── backend/                  # Ballerina service
│   ├── Ballerina.toml        # Package config & dependencies
│   ├── Config.toml           # Environment config (not committed)
│   ├── main.bal              # Service & resource functions
│   ├── types.bal             # Data type definitions
│   ├── db.bal                # Database access functions
│   ├── transform.bal         # Data transformation logic
│   ├── error_interceptor.bal # Error handling
│   ├── sentiment_client.bal  # External HTTP client
│   ├── resources/            # TLS cert/key for the secured listener
│   └── tests/                # Ballerina tests
└── frontend/                  # React + Vite app (WSO2 Identity login demo)
    ├── src/
    └── README.md
```

---

## 🔒 Security Note

`backend/Config.toml` contains sensitive credentials and is excluded from
version control via `.gitignore`. Never commit this file.

---

## 👩‍💻 Author

**Dinijay**- WSO2 Intern  
GitHub: [@2003dinijay](https://github.com/2003dinijay)
