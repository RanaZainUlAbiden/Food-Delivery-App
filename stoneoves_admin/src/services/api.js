import axios from 'axios';

const api = axios.create({
  baseURL: 'http://localhost:3000/api',
  headers: { 'Content-Type': 'application/json' },
});

api.interceptors.request.use((config) => {
  const token = localStorage.getItem('stoneoves_admin_token');
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
}, (error) => Promise.reject(error));

// ══════════════════════════════════════════════════════════════
// AUTH
// ══════════════════════════════════════════════════════════════
export const loginAdmin = (data) => api.post('/auth/login', data);

// ══════════════════════════════════════════════════════════════
// ORDERS
// ══════════════════════════════════════════════════════════════
export const getOrders = (status) =>
  api.get('/orders', { params: status ? { status } : {} });

export const updateOrderStatus = (id, status) =>
  api.patch(`/orders/${id}/status`, { status });

// ══════════════════════════════════════════════════════════════
// MENU ITEMS
// ══════════════════════════════════════════════════════════════
export const getMenuItems = () => api.get('/menu');

export const createMenuItem = (data) => api.post('/menu', data);

export const updateMenuItem = (id, data) => api.put(`/menu/${id}`, data);

export const deleteMenuItem = (id) => api.delete(`/menu/${id}`);

// ══════════════════════════════════════════════════════════════
// CATEGORIES
// ══════════════════════════════════════════════════════════════
export const getCategories = () => api.get('/categories');

export const createCategory = (data) => api.post('/categories', data);

export const updateCategory = (id, data) => api.put(`/categories/${id}`, data);

export const deleteCategory = (id) => api.delete(`/categories/${id}`);

export default api;