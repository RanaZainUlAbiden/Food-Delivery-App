const express = require('express');
const router = express.Router();
const ctrl = require('../controllers/order.controller');
const { verifyToken, isAdmin } = require('../middleware/auth');
const { body } = require('express-validator');
const { validate } = require('../middleware/validate');

// Public route but checks req.user inside if token provided
router.post('/', [
  body('customerPhone').notEmpty().withMessage('Phone is required'),
  body('address').notEmpty().withMessage('Address is required'),
  body('items').isArray({ min: 1 }).withMessage('At least one item is required')
], validate, ctrl.createOrder);

router.post('/webhook/payment', ctrl.paymentWebhook);

router.get('/', verifyToken, isAdmin, ctrl.getAllOrders);
router.get('/phone/:phone', ctrl.getOrderByPhone);
router.get('/:id', verifyToken, ctrl.getOrderById);
router.patch('/:id/status', verifyToken, isAdmin, ctrl.updateOrderStatus);

module.exports = router;