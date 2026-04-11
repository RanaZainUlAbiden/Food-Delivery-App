const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');
const compression = require('compression');
require('dotenv').config();

const categoryRoutes = require('./routes/category.routes');
const menuRoutes = require('./routes/menu.routes');
const orderRoutes = require('./routes/order.routes');

const app = express();
const PORT = process.env.PORT || 3000;

// ── Middleware ──
app.use(helmet());
app.use(cors());
app.use(compression());
app.use(morgan('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// ── Routes ──
app.use('/api/categories', categoryRoutes);
app.use('/api/menu', menuRoutes);
app.use('/api/orders', orderRoutes);

// ── Health Check ──
app.get('/api/health', (req, res) => {
  res.json({
    success: true,
    message: 'The Stone Oves API is running!',
    timestamp: new Date().toISOString(),
  });
});

// ── 404 Handler ──
app.use((req, res) => {
  res.status(404).json({ success: false, message: 'Route not found' });
});

// ── Error Handler ──
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ success: false, message: 'Internal server error' });
});

// app.listen(PORT, () => {
//   console.log(`🚀 Server running on http://localhost:${PORT}`);
// });

app.listen(PORT, '0.0.0.0', () => {
  console.log(`Server running on http://0.0.0.0:${PORT}`);
});