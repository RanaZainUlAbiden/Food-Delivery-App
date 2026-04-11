const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();
const catchAsync = require('../utils/catchAsync');

exports.getAllCategories = catchAsync(async (req, res) => {
  const categories = await prisma.category.findMany({
    where: { isActive: true },
    orderBy: { sortOrder: 'asc' },
  });
  res.json({ success: true, data: categories });
});

exports.createCategory = catchAsync(async (req, res) => {
  const { name, image, sortOrder } = req.body;
  const category = await prisma.category.create({
    data: { name, image, sortOrder: sortOrder || 0 },
  });
  res.status(201).json({ success: true, data: category });
});

exports.updateCategory = catchAsync(async (req, res) => {
  const { id } = req.params;
  const category = await prisma.category.update({
    where: { id: parseInt(id) },
    data: req.body,
  });
  res.json({ success: true, data: category });
});

exports.deleteCategory = catchAsync(async (req, res) => {
  const { id } = req.params;
  await prisma.category.update({
    where: { id: parseInt(id) },
    data: { isActive: false },
  });
  res.json({ success: true, message: 'Category deleted' });
});