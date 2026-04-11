# 🖥️ Stone Oves — Admin Panel

A web-based admin dashboard for The Stone Oves restaurant built with React.js + Vite.

## Prerequisites — Pehle Yeh Install Karo

| Tool | Download |
|---|---|
| Node.js v20+ | https://nodejs.org |
| Git | https://git-scm.com |

> ⚠️ Backend server pehle start hona chahiye — Admin Panel backend se data leta hai.

---

## Project Setup

### 1. Repo Clone karo
```bash
git clone 
cd Food-Delivery-App/stoneoves_admin
```

### 2. Dependencies Install karo
```bash
npm install
```

### 3. Backend URL check karo
`src/services/api.js` mein:
```javascript
const api = axios.create({
  baseURL: 'http://localhost:3000/api', // Backend ka URL
});
```

### 4. Run karo
```bash
npm run dev
```

Browser mein kholo:
http://localhost:5173

---

## Features

| Feature | Description |
|---|---|
| 📦 Orders | Live orders dekhna, status update karna |
| 🍕 Menu Items | Add, edit, delete menu items |
| 🔄 Auto Refresh | Orders har 30 seconds mein refresh hoti hain |
| ✅ Status Management | CONFIRMED → PREPARING → OUT_FOR_DELIVERY → DELIVERED |

---

## Folder Structure
src/
├── components/
│   └── Layout.jsx       → Sidebar + Main layout
├── pages/
│   ├── OrdersPage.jsx   → Orders management
│   └── MenuPage.jsx     → Menu management
├── services/
│   └── api.js           → Backend API calls
├── App.jsx              → Routes
└── index.css            → Global styles

---

## Tech Stack
- React.js + Vite
- React Router DOM
- Axios
- Lucide React Icons
- Tailwind CSS v4