# Agricultural SOP Management SaaS - Enterprise Portal

An enterprise-grade multi-tenant platform designed to optimize agricultural operations through digitalized Standard Operating Procedures (SOPs), real-time team messaging, task scheduling, and AI-driven manual parsing.

---

## 🚀 Key Features

* **Multi-Tenant Farm Isolation**: Clean data partitioning supporting granular permissions across System Owners, Farm Admins, Managers, and Employees.
* **AI-Powered SOP Parser**: Processes raw PDF/Word documents to output structured, interactive checklists with localized language parameters.
* **Task Dispatch & Completion Tracking**: Shifts, automated scheduling, and proof of work verification with completion logs.
* **Real-time Notifications & Chat**: Instant direct messaging utilizing Socket.IO websocket orchestration.
* **Integrated Subscriptions & Stripe Payments**: Out-of-the-box billing supporting tier limits on employee numbers.

---

## 🛠 Tech Stack

* **Frontend**: React, Vite, Tailwind CSS v4, React Query, React Router Dom
* **Backend**: Node.js, Express, Prisma ORM, Socket.IO, PDFKit
* **Databases**: PostgreSQL (Relational schema), Redis (Session Cache & Event Queue)
* **Mobile Client**: Flutter SDK, GetX State Management
* **Containerization**: Docker, Docker Compose, Nginx Reverse Proxy

---

## 📂 Project Organization

```
├── app-codebase/         # Flutter Mobile Client codebase
├── backend/              # Node.js Express server with Prisma Schema definitions
└── frontend/             # React SPA (Vite, Tailwind v4)
```

---

## ⚡ Quick Start

### 1. Setup Environment
Copy the example environment configuration:
```bash
cp .env.example .env
```
Modify `.env` to supply database connections, JWT secrets, Redis endpoints, and Stripe API credentials.

### 2. Run with Docker Compose
To boot up the entire development ecosystem (Nginx, React Frontend, Node.js Backend, Postgres DB, and Redis):
```bash
docker-compose -f docker-compose.yml -f docker-compose.dev.yml up --build
```

Access the systems at:
* **Frontend UI**: `http://localhost:3000`
* **API Engine**: `http://localhost:8000/api`

---

## 🛡 Security & Best Practices

1. **Authentication**: Handled via stateless JWT tokens with automatic expiration and refresh token rotation.
2. **Access Control**: Strict role-based routing (RBAC) separating System Owners from Farm Admins, Managers, and field Employees.
3. **Database Security**: Powered by Prisma's param-safe query generator preventing SQL Injections.

---

## 📈 Performance Optimization

* **Database Level**: Indexes configured on high-traffic fields (`role`, `farmId`, `email`, `status`).
* **Caching**: Redis is utilized for caching session information and managing rate limits.
* **Docker Multi-Stage Compilation**: Clean production builds eliminating build-time dependencies, maintaining minimal image footprints.
