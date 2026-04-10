const express = require('express');
const router = express.Router();
const ctrl = require('../controllers/menu.controller');

router.get('/', ctrl.getAllItems);
router.get('/:id', ctrl.getItemById);
router.post('/', ctrl.createItem);
router.put('/:id', ctrl.updateItem);
router.delete('/:id', ctrl.deleteItem);

module.exports = router;