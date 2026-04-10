const express = require('express');
const router = express.Router();
const ctrl = require('../controllers/order.controller');

router.post('/', ctrl.createOrder);
router.get('/', ctrl.getAllOrders);
router.get('/phone/:phone', ctrl.getOrderByPhone);
router.get('/:id', ctrl.getOrderById);
router.patch('/:id/status', ctrl.updateOrderStatus);

module.exports = router;