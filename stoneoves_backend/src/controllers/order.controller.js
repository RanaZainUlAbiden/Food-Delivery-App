const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();
const catchAsync = require('../utils/catchAsync');

const generateOrderNumber = () => {
  const timestamp = Date.now().toString().slice(-6);
  const random = Math.floor(Math.random() * 1000).toString().padStart(3, '0');
  return `ORD-${timestamp}-${random}`;
};

exports.createOrder = catchAsync(async (req, res) => {
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
    return res.status(400).json({ success: false, message: 'Order must have at least one item' });
  }

  const menuItems = await prisma.menuItem.findMany({
    where: {
      id: { in: items.map((i) => i.menuItemId) },
      isActive: true,
      isAvailable: true,
    },
  });

  if (menuItems.length !== items.length) {
    return res.status(400).json({ success: false, message: 'One or more items are unavailable' });
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

  const order = await prisma.$transaction(async (tx) => {
    return await tx.order.create({
      data: {
        orderNumber: generateOrderNumber(),
        customerPhone,
        customerName,
        address,
        totalAmount,
        deliveryFee,
        paymentMethod,
        paymentStatus: 'PENDING',
        paymentRef,
        status: 'PENDING',
        notes,
        userId: req.user ? req.user.id : null,
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
  });

  res.status(201).json({ success: true, data: order });
});

exports.getOrderByPhone = catchAsync(async (req, res) => {
  const orders = await prisma.order.findMany({
    where: { customerPhone: req.params.phone },
    include: {
      items: { include: { menuItem: true } },
    },
    orderBy: { createdAt: 'desc' },
  });
  res.json({ success: true, data: orders });
});

exports.getOrderById = catchAsync(async (req, res) => {
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
});

exports.updateOrderStatus = catchAsync(async (req, res) => {
  const order = await prisma.order.update({
    where: { id: parseInt(req.params.id) },
    data: { status: req.body.status },
  });
  res.json({ success: true, data: order });
});

exports.getAllOrders = catchAsync(async (req, res) => {
  const page = parseInt(req.query.page) || 1;
  const limit = parseInt(req.query.limit) || 10;
  const skip = (page - 1) * limit;
  const where = req.query.status ? { status: req.query.status } : {};
  
  const orders = await prisma.order.findMany({
    where,
    skip,
    take: limit,
    include: {
      items: { include: { menuItem: true } },
    },
    orderBy: { createdAt: 'desc' },
  });
  res.json({ success: true, data: orders });
});

exports.paymentWebhook = catchAsync(async (req, res) => {
  const { orderId, status } = req.body;
  if (!orderId || !status) {
    return res.status(400).json({ success: false, message: 'Missing parameters' });
  }

  const order = await prisma.order.update({
    where: { id: parseInt(orderId) },
    data: { 
      paymentStatus: status === 'SUCCESS' ? 'PAID' : 'FAILED',
      status: status === 'SUCCESS' ? 'CONFIRMED' : 'CANCELLED' 
    },
  });
  
  res.json({ success: true, message: 'Payment webhook processed', data: order });
});