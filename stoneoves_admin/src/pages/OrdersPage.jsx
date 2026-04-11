import { useState, useEffect } from 'react';
import { getOrders, updateOrderStatus } from '../services/api';
import { RefreshCw } from 'lucide-react';

const STATUS_OPTIONS = ['All', 'PENDING', 'CONFIRMED', 'PREPARING', 'OUT_FOR_DELIVERY', 'DELIVERED', 'CANCELLED'];

const STATUS_COLORS = {
  PENDING: { bg: '#FFF9C4', color: '#F57F17' },
  CONFIRMED: { bg: '#E3F2FD', color: '#1565C0' },
  PREPARING: { bg: '#FFF3E0', color: '#E65100' },
  OUT_FOR_DELIVERY: { bg: '#F3E5F5', color: '#6A1B9A' },
  DELIVERED: { bg: '#E8F5E9', color: '#2E7D32' },
  CANCELLED: { bg: '#FFEBEE', color: '#C62828' },
};

const NEXT_STATUS = {
  CONFIRMED: 'PREPARING',
  PREPARING: 'OUT_FOR_DELIVERY',
  OUT_FOR_DELIVERY: 'DELIVERED',
};

export default function OrdersPage() {
  const [orders, setOrders] = useState([]);
  const [loading, setLoading] = useState(true);
  const [filter, setFilter] = useState('All');

  const fetchOrders = async () => {
    try {
      setLoading(true);
      const res = await getOrders(filter === 'All' ? null : filter);
      setOrders(res.data.data);
    } catch (e) {
      console.error(e);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchOrders();
    const interval = setInterval(fetchOrders, 30000);
    return () => clearInterval(interval);
  }, [filter]);

  const handleStatusUpdate = async (id, status) => {
    try {
      await updateOrderStatus(id, status);
      fetchOrders();
    } catch (e) {
      console.error(e);
    }
  };

  return (
    <div style={{ padding: '32px' }}>
      {/* Header */}
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '32px' }}>
        <div>
          <h1 style={{ fontSize: '24px', fontWeight: '700', color: '#1D1D1D', margin: 0 }}>Orders</h1>
          <p style={{ color: '#888', fontSize: '14px', marginTop: '4px' }}>Manage and track all orders</p>
        </div>
        <button
          onClick={fetchOrders}
          style={{
            display: 'flex', alignItems: 'center', gap: '8px',
            padding: '10px 16px', backgroundColor: 'white',
            border: '1px solid #eee', borderRadius: '12px',
            fontSize: '14px', fontWeight: '500', cursor: 'pointer',
          }}
        >
          <RefreshCw size={16} /> Refresh
        </button>
      </div>

      {/* Filter Tabs */}
      <div style={{ display: 'flex', gap: '8px', marginBottom: '24px', flexWrap: 'wrap' }}>
        {STATUS_OPTIONS.map((s) => (
          <button
            key={s}
            onClick={() => setFilter(s)}
            style={{
              padding: '8px 16px', borderRadius: '20px', fontSize: '13px',
              fontWeight: '500', cursor: 'pointer', border: 'none',
              backgroundColor: filter === s ? '#E63946' : 'white',
              color: filter === s ? 'white' : '#555',
              boxShadow: '0 1px 3px rgba(0,0,0,0.1)',
            }}
          >
            {s.replace(/_/g, ' ')}
          </button>
        ))}
      </div>

      {/* Orders */}
      {loading ? (
        <div style={{ textAlign: 'center', padding: '80px', color: '#888' }}>
          Loading orders...
        </div>
      ) : orders.length === 0 ? (
        <div style={{ textAlign: 'center', padding: '80px', color: '#888' }}>
          No orders found
        </div>
      ) : (
        <div style={{ display: 'flex', flexDirection: 'column', gap: '16px' }}>
          {orders.map((order) => (
            <div key={order.id} style={{
              backgroundColor: 'white', borderRadius: '16px',
              border: '1px solid #eee', padding: '24px',
              boxShadow: '0 1px 4px rgba(0,0,0,0.05)',
            }}>
              {/* Order Header */}
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', marginBottom: '16px' }}>
                <div>
                  <div style={{ display: 'flex', alignItems: 'center', gap: '12px' }}>
                    <h3 style={{ fontSize: '18px', fontWeight: '700', color: '#1D1D1D', margin: 0 }}>
                      {order.orderNumber}
                    </h3>
                    <span style={{
                      padding: '4px 12px', borderRadius: '20px', fontSize: '12px', fontWeight: '600',
                      backgroundColor: STATUS_COLORS[order.status]?.bg || '#eee',
                      color: STATUS_COLORS[order.status]?.color || '#333',
                    }}>
                      {order.status.replace(/_/g, ' ')}
                    </span>
                  </div>
                  <p style={{ color: '#888', fontSize: '13px', marginTop: '4px' }}>
                    {new Date(order.createdAt).toLocaleString()}
                  </p>
                </div>
                <div style={{ textAlign: 'right' }}>
                  <p style={{ fontSize: '22px', fontWeight: '700', color: '#E63946', margin: 0 }}>
                    Rs. {order.totalAmount}
                  </p>
                  <p style={{ color: '#888', fontSize: '12px', marginTop: '2px' }}>
                    {order.paymentMethod} • {order.paymentStatus}
                  </p>
                </div>
              </div>

              {/* Customer Info */}
              <div style={{
                backgroundColor: '#F8F8F8', borderRadius: '12px',
                padding: '16px', marginBottom: '16px',
                display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '12px',
              }}>
                <div>
                  <p style={{ color: '#888', fontSize: '12px', margin: 0 }}>Customer</p>
                  <p style={{ fontWeight: '600', color: '#1D1D1D', fontSize: '14px', margin: '2px 0 0' }}>
                    {order.customerName || 'N/A'}
                  </p>
                </div>
                <div>
                  <p style={{ color: '#888', fontSize: '12px', margin: 0 }}>Phone</p>
                  <p style={{ fontWeight: '600', color: '#1D1D1D', fontSize: '14px', margin: '2px 0 0' }}>
                    {order.customerPhone}
                  </p>
                </div>
                <div style={{ gridColumn: '1 / -1' }}>
                  <p style={{ color: '#888', fontSize: '12px', margin: 0 }}>Address</p>
                  <p style={{ fontWeight: '600', color: '#1D1D1D', fontSize: '14px', margin: '2px 0 0' }}>
                    {order.address}
                  </p>
                </div>
              </div>

              {/* Items */}
              <div style={{ marginBottom: '16px' }}>
                <p style={{ fontWeight: '600', fontSize: '14px', color: '#1D1D1D', marginBottom: '8px' }}>Items</p>
                {order.items.map((item) => (
                  <div key={item.id} style={{
                    display: 'flex', justifyContent: 'space-between',
                    fontSize: '14px', padding: '4px 0',
                    borderBottom: '1px solid #f5f5f5',
                  }}>
                    <span style={{ color: '#555' }}>
                      {item.quantity}x {item.menuItem.name}
                    </span>
                    <span style={{ fontWeight: '600', color: '#1D1D1D' }}>
                      Rs. {item.price * item.quantity}
                    </span>
                  </div>
                ))}
              </div>

              {/* Actions */}
              <div style={{ display: 'flex', gap: '8px', flexWrap: 'wrap' }}>
                {NEXT_STATUS[order.status] && (
                  <button
                    onClick={() => handleStatusUpdate(order.id, NEXT_STATUS[order.status])}
                    style={{
                      padding: '10px 20px', backgroundColor: '#E63946',
                      color: 'white', border: 'none', borderRadius: '10px',
                      fontSize: '13px', fontWeight: '600', cursor: 'pointer',
                    }}
                  >
                    Mark as {NEXT_STATUS[order.status].replace(/_/g, ' ')}
                  </button>
                )}
                {order.status !== 'CANCELLED' && order.status !== 'DELIVERED' && (
                  <button
                    onClick={() => handleStatusUpdate(order.id, 'CANCELLED')}
                    style={{
                      padding: '10px 20px', backgroundColor: '#f5f5f5',
                      color: '#555', border: 'none', borderRadius: '10px',
                      fontSize: '13px', fontWeight: '600', cursor: 'pointer',
                    }}
                  >
                    Cancel Order
                  </button>
                )}
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}