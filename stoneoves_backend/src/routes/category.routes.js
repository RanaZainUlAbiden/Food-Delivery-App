const express = require('express');
const router = express.Router();
const ctrl = require('../controllers/category.controller');
const { verifyToken, isAdmin } = require('../middleware/auth');
const { body } = require('express-validator');
const { validate } = require('../middleware/validate');

router.get('/', ctrl.getAllCategories);
router.post('/', verifyToken, isAdmin, [
  body('name').notEmpty().withMessage('Name is required')
], validate, ctrl.createCategory);
router.put('/:id', verifyToken, isAdmin, ctrl.updateCategory);
router.delete('/:id', verifyToken, isAdmin, ctrl.deleteCategory);

module.exports = router;