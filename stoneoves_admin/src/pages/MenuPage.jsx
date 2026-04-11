import { useState, useEffect } from 'react';
import { getMenuItems, createMenuItem, updateMenuItem, deleteMenuItem, getCategories } from '../services/api';
import { Plus, Pencil, Trash2, X } from 'lucide-react';

export default function MenuPage() {
  const [items, setItems] = useState([]);
  const [categories, setCategories] = useState([]);
  const [loading, setLoading] = useState(true);
  const [showModal, setShowModal] = useState(false);
  const [editItem, setEditItem] = useState(null);
  const [form, setForm] = useState({
    name: '', description: '', price: '',
    tag: '', categoryId: '', sortOrder: '0', image: '',
  });

  const fetchData = async () => {
    try {
      setLoading(true);
      const [menuRes, catRes] = await Promise.all([getMenuItems(), getCategories()]);
      setItems(menuRes.data.data);
      setCategories(catRes.data.data);
    } catch (e) {
      console.error(e);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => { fetchData(); }, []);

  const openAdd = () => {
    setEditItem(null);
    setForm({ name: '', description: '', price: '', tag: '', categoryId: '', sortOrder: '0', image: '' });
    setShowModal(true);
  };

  const openEdit = (item) => {
    setEditItem(item);
    setForm({
      name: item.name, description: item.description || '',
      price: item.price.toString(), tag: item.tag || '',
      categoryId: item.categoryId.toString(), sortOrder: item.sortOrder.toString(),
      image: item.image || '',
    });
    setShowModal(true);
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      const data = {
        ...form,
        price: parseFloat(form.price),
        categoryId: parseInt(form.categoryId),
        sortOrder: parseInt(form.sortOrder),
      };
      if (editItem) {
        await updateMenuItem(editItem.id, data);
      } else {
        await createMenuItem(data);
      }
      setShowModal(false);
      fetchData();
    } catch (e) {
      console.error(e);
    }
  };

  const handleDelete = async (id) => {
    if (!confirm('Delete this item?')) return;
    try {
      await deleteMenuItem(id);
      fetchData();
    } catch (e) {
      console.error(e);
    }
  };

  const inputStyle = {
    width: '100%', border: '1px solid #eee', borderRadius: '10px',
    padding: '10px 14px', fontSize: '14px', outline: 'none',
    fontFamily: 'Inter, sans-serif', boxSizing: 'border-box',
  };

  const labelStyle = {
    fontSize: '13px', fontWeight: '600', color: '#444',
    display: 'block', marginBottom: '6px',
  };

  return (
    <div style={{ padding: '32px' }}>
      {/* Header */}
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '32px' }}>
        <div>
          <h1 style={{ fontSize: '24px', fontWeight: '700', color: '#1D1D1D', margin: 0 }}>Menu Items</h1>
          <p style={{ color: '#888', fontSize: '14px', marginTop: '4px' }}>Add, edit, or remove menu items</p>
        </div>
        <button
          onClick={openAdd}
          style={{
            display: 'flex', alignItems: 'center', gap: '8px',
            padding: '12px 20px', backgroundColor: '#E63946',
            color: 'white', border: 'none', borderRadius: '12px',
            fontSize: '14px', fontWeight: '600', cursor: 'pointer',
          }}
        >
          <Plus size={18} /> Add Item
        </button>
      </div>

      {/* Table */}
      {loading ? (
        <div style={{ textAlign: 'center', padding: '80px', color: '#888' }}>Loading...</div>
      ) : (
        <div style={{
          backgroundColor: 'white', borderRadius: '16px',
          border: '1px solid #eee', overflow: 'hidden',
          boxShadow: '0 1px 4px rgba(0,0,0,0.05)',
        }}>
          <table style={{ width: '100%', borderCollapse: 'collapse' }}>
            <thead>
              <tr style={{ backgroundColor: '#F8F8F8', borderBottom: '1px solid #eee' }}>
                {['Item', 'Category', 'Price', 'Tag', 'Status', 'Actions'].map(h => (
                  <th key={h} style={{
                    textAlign: h === 'Actions' ? 'right' : 'left',
                    padding: '14px 20px', fontSize: '13px',
                    fontWeight: '600', color: '#555',
                  }}>{h}</th>
                ))}
              </tr>
            </thead>
            <tbody>
              {items.map((item, i) => (
                <tr key={item.id} style={{
                  borderBottom: i < items.length - 1 ? '1px solid #f5f5f5' : 'none',
                  backgroundColor: 'white',
                }}>
                  <td style={{ padding: '16px 20px', display: 'flex', alignItems: 'center', gap: '12px' }}>
                    <div style={{ width: '40px', height: '40px', borderRadius: '8px', overflow: 'hidden', backgroundColor: '#eee', flexShrink: 0 }}>
                      {item.image ? <img src={item.image} alt={item.name} style={{ width: '100%', height: '100%', objectFit: 'cover' }} /> : <span style={{ display: 'flex', height: '100%', justifyContent: 'center', alignItems: 'center', color: '#aaa', fontSize: '10px' }}>No img</span>}
                    </div>
                    <div>
                      <p style={{ fontWeight: '600', color: '#1D1D1D', margin: 0, fontSize: '14px' }}>{item.name}</p>
                      <p style={{ color: '#888', fontSize: '12px', margin: '2px 0 0', maxWidth: '280px', overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>
                        {item.description}
                      </p>
                    </div>
                  </td>
                  <td style={{ padding: '16px 20px', color: '#555', fontSize: '14px' }}>{item.category.name}</td>
                  <td style={{ padding: '16px 20px' }}>
                    <span style={{ color: '#E63946', fontWeight: '700', fontSize: '14px' }}>Rs. {item.price}</span>
                  </td>
                  <td style={{ padding: '16px 20px' }}>
                    {item.tag ? (
                      <span style={{
                        padding: '3px 10px', backgroundColor: '#FFF0F0',
                        color: '#E63946', borderRadius: '6px',
                        fontSize: '12px', fontWeight: '600',
                      }}>{item.tag}</span>
                    ) : <span style={{ color: '#ddd' }}>—</span>}
                  </td>
                  <td style={{ padding: '16px 20px' }}>
                    <span style={{
                      padding: '4px 12px', borderRadius: '20px', fontSize: '12px', fontWeight: '600',
                      backgroundColor: item.isAvailable ? '#E8F5E9' : '#FFEBEE',
                      color: item.isAvailable ? '#2E7D32' : '#C62828',
                    }}>
                      {item.isAvailable ? 'Available' : 'Unavailable'}
                    </span>
                  </td>
                  <td style={{ padding: '16px 20px', textAlign: 'right' }}>
                    <button
                      onClick={() => openEdit(item)}
                      style={{
                        padding: '8px', backgroundColor: '#F8F8F8',
                        border: 'none', borderRadius: '8px',
                        cursor: 'pointer', marginRight: '6px',
                        color: '#555',
                      }}
                    ><Pencil size={15} /></button>
                    <button
                      onClick={() => handleDelete(item.id)}
                      style={{
                        padding: '8px', backgroundColor: '#FFF0F0',
                        border: 'none', borderRadius: '8px',
                        cursor: 'pointer', color: '#E63946',
                      }}
                    ><Trash2 size={15} /></button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}

      {/* Modal */}
      {showModal && (
        <div style={{
          position: 'fixed', inset: 0, backgroundColor: 'rgba(0,0,0,0.5)',
          display: 'flex', alignItems: 'center', justifyContent: 'center',
          zIndex: 1000, padding: '16px',
        }}>
          <div style={{
            backgroundColor: 'white', borderRadius: '20px',
            width: '100%', maxWidth: '460px',
            boxShadow: '0 20px 60px rgba(0,0,0,0.2)',
          }}>
            {/* Modal Header */}
            <div style={{
              display: 'flex', justifyContent: 'space-between', alignItems: 'center',
              padding: '20px 24px', borderBottom: '1px solid #eee',
            }}>
              <h2 style={{ fontSize: '18px', fontWeight: '700', color: '#1D1D1D', margin: 0 }}>
                {editItem ? 'Edit Item' : 'Add New Item'}
              </h2>
              <button
                onClick={() => setShowModal(false)}
                style={{
                  padding: '6px', backgroundColor: '#F8F8F8',
                  border: 'none', borderRadius: '8px', cursor: 'pointer',
                }}
              ><X size={18} /></button>
            </div>

            {/* Modal Form */}
            <form onSubmit={handleSubmit} style={{ padding: '24px' }}>
              <div style={{ marginBottom: '16px' }}>
                <label style={labelStyle}>Name *</label>
                <input
                  required value={form.name}
                  onChange={(e) => setForm({ ...form, name: e.target.value })}
                  style={inputStyle} placeholder="Item name"
                />
              </div>

              <div style={{ marginBottom: '16px' }}>
                <label style={labelStyle}>Description</label>
                <textarea
                  value={form.description}
                  onChange={(e) => setForm({ ...form, description: e.target.value })}
                  style={{ ...inputStyle, resize: 'none', height: '72px' }}
                  placeholder="Item description"
                />
              </div>

              <div style={{ marginBottom: '16px' }}>
                <label style={labelStyle}>Image URL</label>
                <input
                  value={form.image}
                  onChange={(e) => setForm({ ...form, image: e.target.value })}
                  style={inputStyle} placeholder="https://example.com/pizza.jpg"
                />
              </div>

              <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '12px', marginBottom: '16px' }}>
                <div>
                  <label style={labelStyle}>Price (Rs.) *</label>
                  <input
                    required type="number" value={form.price}
                    onChange={(e) => setForm({ ...form, price: e.target.value })}
                    style={inputStyle} placeholder="0"
                  />
                </div>
                <div>
                  <label style={labelStyle}>Tag</label>
                  <input
                    value={form.tag}
                    onChange={(e) => setForm({ ...form, tag: e.target.value })}
                    style={inputStyle} placeholder="Best Seller"
                  />
                </div>
              </div>

              <div style={{ marginBottom: '24px' }}>
                <label style={labelStyle}>Category *</label>
                <select
                  required value={form.categoryId}
                  onChange={(e) => setForm({ ...form, categoryId: e.target.value })}
                  style={{ ...inputStyle, backgroundColor: 'white' }}
                >
                  <option value="">Select category</option>
                  {categories.map((c) => (
                    <option key={c.id} value={c.id}>{c.name}</option>
                  ))}
                </select>
              </div>

              <div style={{ display: 'flex', gap: '12px' }}>
                <button
                  type="button" onClick={() => setShowModal(false)}
                  style={{
                    flex: 1, padding: '12px', backgroundColor: '#F8F8F8',
                    border: 'none', borderRadius: '12px', fontSize: '14px',
                    fontWeight: '600', cursor: 'pointer', color: '#555',
                  }}
                >Cancel</button>
                <button
                  type="submit"
                  style={{
                    flex: 1, padding: '12px', backgroundColor: '#E63946',
                    border: 'none', borderRadius: '12px', fontSize: '14px',
                    fontWeight: '600', cursor: 'pointer', color: 'white',
                  }}
                >{editItem ? 'Update' : 'Add Item'}</button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
}