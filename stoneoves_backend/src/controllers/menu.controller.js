const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

exports.getAllItems = async (req, res) => {
  try {
    const { category } = req.query;
    const where = { isActive: true };
    if (category) where.category = { name: category };

    const items = await prisma.menuItem.findMany({
      where,
      include: { category: true },
      orderBy: { sortOrder: 'asc' },
    });
    res.json({ success: true, data: items });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

exports.getItemById = async (req, res) => {
  try {
    const item = await prisma.menuItem.findUnique({
      where: { id: parseInt(req.params.id) },
      include: { category: true },
    });
    if (!item) return res.status(404).json({ success: false, message: 'Item not found' });
    res.json({ success: true, data: item });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

exports.createItem = async (req, res) => {
  try {
    const { name, description, price, image, tag, categoryId, sortOrder } = req.body;
    const item = await prisma.menuItem.create({
      data: {
        name,
        description,
        price: parseFloat(price),
        image,
        tag,
        categoryId: parseInt(categoryId),
        sortOrder: sortOrder || 0,
      },
      include: { category: true },
    });
    res.status(201).json({ success: true, data: item });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

exports.updateItem = async (req, res) => {
  try {
    const { id } = req.params;
    const item = await prisma.menuItem.update({
      where: { id: parseInt(id) },
      data: req.body,
      include: { category: true },
    });
    res.json({ success: true, data: item });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

exports.deleteItem = async (req, res) => {
  try {
    await prisma.menuItem.update({
      where: { id: parseInt(req.params.id) },
      data: { isActive: false },
    });
    res.json({ success: true, message: 'Item deleted' });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};