# 🖥️ Stone Oves — Backend API

## Prerequisites — Pehle Yeh Install Karo

| Tool | Download Link |
|---|---|
| Node.js v20+ | https://nodejs.org |
| PostgreSQL 16 | https://www.postgresql.org/download/windows |
| Git | https://git-scm.com |

---

## Project Setup

### 1. Repo Clone karo
```bash
git clone <your-repo-url>
cd Food-Delivery-App/stoneoves_backend
```

### 2. Dependencies Install karo
```bash
npm install
```

### 3. `.env` file banao
Root mein `.env` file banao:
```env
DATABASE_URL="postgresql://postgres:YOUR_PASSWORD@localhost:5432/stoneoves_db"
JWT_SECRET="stoneoves_super_secret_key_2025"
PORT=3000
NODE_ENV="development"
```
> `YOUR_PASSWORD` ki jagah apna PostgreSQL password likho

### 4. PostgreSQL Database banao
- pgAdmin kholo
- `stoneoves_db` naam ka database banao

### 5. Prisma Setup
```bash
npx prisma generate
npx prisma migrate dev --name init
```

### 6. Server Start karo
```bash
npm run dev
```

### 7. Verify karo
Browser mein kholo:
http://localhost:3000/api/health

Yeh aana chahiye:
```json
{
  "success": true,
  "message": "The Stone Oves API is running!"
}
```

---

## Seed Data — Menu Items Add karo
Sab categories aur menu items add karne ke liye PowerShell mein:

```powershell
# Categories
Invoke-WebRequest -Uri "http://localhost:3000/api/categories" -Method POST -Headers @{"Content-Type"="application/json"} -Body '{"name":"Pizzas","sortOrder":1}'
Invoke-WebRequest -Uri "http://localhost:3000/api/categories" -Method POST -Headers @{"Content-Type"="application/json"} -Body '{"name":"Burgers","sortOrder":2}'
Invoke-WebRequest -Uri "http://localhost:3000/api/categories" -Method POST -Headers @{"Content-Type"="application/json"} -Body '{"name":"Deals","sortOrder":3}'
Invoke-WebRequest -Uri "http://localhost:3000/api/categories" -Method POST -Headers @{"Content-Type"="application/json"} -Body '{"name":"Drinks","sortOrder":4}'
Invoke-WebRequest -Uri "http://localhost:3000/api/categories" -Method POST -Headers @{"Content-Type"="application/json"} -Body '{"name":"Sides","sortOrder":5}'
```

---

## API Endpoints

### Categories
| Method | Endpoint | Description |
|---|---|---|
| GET | `/api/categories` | Sari categories |
| POST | `/api/categories` | Nayi category |
| PUT | `/api/categories/:id` | Update category |
| DELETE | `/api/categories/:id` | Delete category |

### Menu
| Method | Endpoint | Description |
|---|---|---|
| GET | `/api/menu` | Sare items |
| GET | `/api/menu/:id` | Single item |
| POST | `/api/menu` | Naya item |
| PUT | `/api/menu/:id` | Update item |
| DELETE | `/api/menu/:id` | Delete item |

### Orders
| Method | Endpoint | Description |
|---|---|---|
| POST | `/api/orders` | Order banao |
| GET | `/api/orders` | Sare orders |
| GET | `/api/orders/phone/:phone` | Phone se orders |
| GET | `/api/orders/:id` | Single order |
| PATCH | `/api/orders/:id/status` | Status update |

---

## Folder Structure