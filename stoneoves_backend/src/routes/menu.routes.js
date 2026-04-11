const express = require('express');
const router = express.Router();
const ctrl = require('../controllers/menu.controller');
const { verifyToken, isAdmin } = require('../middleware/auth');
const { body } = require('express-validator');
const { validate } = require('../middleware/validate');

router.get('/', ctrl.getAllItems);
router.get('/:id', ctrl.getItemById);
router.post('/', verifyToken, isAdmin, [
  body('name').notEmpty().withMessage('Name is required'),
  body('price').isNumeric().withMessage('Price must be a number'),
  body('categoryId').isInt().withMessage('Category ID is required')
], validate, ctrl.createItem);
router.put('/:id', verifyToken, isAdmin, ctrl.updateItem);
router.delete('/:id', verifyToken, isAdmin, ctrl.deleteItem);

module.exports = router;