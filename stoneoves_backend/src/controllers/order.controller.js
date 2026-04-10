const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

const generateOrderNumber = () => {
  const timestamp = Date.now().toString().slice(-6);
  const random = Math.floor(Math.random() * 1000).toString().padStart(3, '0');
  return `ORD-${timestamp}-${random}`;
};

exports.createOrder = async (req, res) => {
  try {
    const {
      customerPhone,
      customerName,
      address,
      items,
      paymentMethod,
      paymentRef,
      notes,
    } = req.body;

    if (!items || items.length === 0) {
      return res.status(400).json({
        success: false,
        message: 'Order must have at least one item',
      });
    }

    const menuItems = await prisma.menuItem.findMany({
      where: {
        id: { in: items.map((i) => i.menuItemId) },
        isActive: true,
        isAvailable: true,
      },
    });

    if (menuItems.length !== items.length) {
      return res.status(400).json({
        success: false,
        message: 'One or more items are unavailable',
      });
    }

    let subtotal = 0;
    const orderItems = items.map((item) => {
      const menuItem = menuItems.find((m) => m.id === item.menuItemId);
      const lineTotal = menuItem.price * item.quantity;
      subtotal += lineTotal;
      return {
        menuItemId: item.menuItemId,
        quantity: item.quantity,
        price: menuItem.price,
      };
    });

    const deliveryFee = subtotal >= 1000 ? 0 : 50;
    const totalAmount = subtotal + deliveryFee;

    const order = await prisma.order.create({
      data: {
        orderNumber: generateOrderNumber(),
        customerPhone,
        customerName,
        address,
        totalAmount,
        deliveryFee,
        paymentMethod,
        paymentStatus: 'PAID',
        paymentRef,
        status: 'CONFIRMED',
        notes,
        items: {
          create: orderItems,
        },
      },
      include: {
        items: {
          include: { menuItem: true },
        },
      },
    });

    res.status(201).json({ success: true, data: order });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

exports.getOrderByPhone = async (req, res) => {
  try {
    const orders = await prisma.order.findMany({
      where: { customerPhone: req.params.phone },
      include: {
        items: { include: { menuItem: true } },
      },
      orderBy: { createdAt: 'desc' },
    });
    res.json({ success: true, data: orders });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

exports.getOrderById = async (req, res) => {
  try {
    const order = await prisma.order.findUnique({
      where: { id: parseInt(req.params.id) },
      include: {
        items: { include: { menuItem: true } },
      },
    });
    if (!order) {
      return res.status(404).json({ success: false, message: 'Order not found' });
    }
    res.json({ success: true, data: order });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

exports.updateOrderStatus = async (req, res) => {
  try {
    const order = await prisma.order.update({
      where: { id: parseInt(req.params.id) },
      data: { status: req.body.status },
    });
    res.json({ success: true, data: order });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

exports.getAllOrders = async (req, res) => {
  try {
    const where = req.query.status ? { status: req.query.status } : {};
    const orders = await prisma.order.findMany({
      where,
      include: {
        items: { include: { menuItem: true } },
      },
      orderBy: { createdAt: 'desc' },
    });
    res.json({ success: true, data: orders });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};