const express = require('express');
const router = express.Router();
const ctrl = require('../controllers/category.controller');

router.get('/', ctrl.getAllCategories);
router.post('/', ctrl.createCategory);
router.put('/:id', ctrl.updateCategory);
router.delete('/:id', ctrl.deleteCategory);

module.exports = router;