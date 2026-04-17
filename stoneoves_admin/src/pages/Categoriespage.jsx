import { useState, useEffect } from 'react';
import { getCategories, createCategory, updateCategory, deleteCategory } from '../services/api';
import { Plus, Pencil, Trash2, X, Grid3x3 } from 'lucide-react';

export default function CategoriesPage() {
  const [categories, setCategories] = useState([]);
  const [loading, setLoading] = useState(true);
  const [showModal, setShowModal] = useState(false);
  const [editCategory, setEditCategory] = useState(null);
  const [form, setForm] = useState({
    name: '',
    image: '',
    sortOrder: '0',
  });

  const fetchCategories = async () => {
    try {
      setLoading(true);
      const res = await getCategories();
      setCategories(res.data.data);
    } catch (e) {
      console.error(e);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchCategories();
  }, []);

  const openAdd = () => {
    setEditCategory(null);
    setForm({ name: '', image: '', sortOrder: '0' });
    setShowModal(true);
  };

  const openEdit = (category) => {
    setEditCategory(category);
    setForm({
      name: category.name,
      image: category.image || '',
      sortOrder: category.sortOrder.toString(),
    });
    setShowModal(true);
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      const data = {
        ...form,
        sortOrder: parseInt(form.sortOrder),
      };
      if (editCategory) {
        await updateCategory(editCategory.id, data);
      } else {
        await createCategory(data);
      }
      setShowModal(false);
      fetchCategories();
    } catch (e) {
      console.error(e);
      alert('Failed to save category. Please try again.');
    }
  };

  const handleDelete = async (id) => {
    if (!confirm('Are you sure you want to delete this category? This will affect all menu items in this category.')) return;
    try {
      await deleteCategory(id);
      fetchCategories();
    } catch (e) {
      console.error(e);
      alert('Failed to delete category. Please try again.');
    }
  };

  const inputStyle = {
    width: '100%',
    border: '1px solid #eee',
    borderRadius: '10px',
    padding: '10px 14px',
    fontSize: '14px',
    outline: 'none',
    fontFamily: 'Inter, sans-serif',
    boxSizing: 'border-box',
  };

  const labelStyle = {
    fontSize: '13px',
    fontWeight: '600',
    color: '#444',
    display: 'block',
    marginBottom: '6px',
  };

  return (
    <div style={{ padding: '32px' }}>
      {/* Header */}
      <div style={{
        display: 'flex',
        justifyContent: 'space-between',
        alignItems: 'center',
        marginBottom: '32px',
      }}>
        <div>
          <h1 style={{
            fontSize: '24px',
            fontWeight: '700',
            color: '#1D1D1D',
            margin: 0,
          }}>
            Categories
          </h1>
          <p style={{
            color: '#888',
            fontSize: '14px',
            marginTop: '4px',
          }}>
            Manage menu categories and display order
          </p>
        </div>
        <button
          onClick={openAdd}
          style={{
            display: 'flex',
            alignItems: 'center',
            gap: '8px',
            padding: '12px 20px',
            backgroundColor: '#E63946',
            color: 'white',
            border: 'none',
            borderRadius: '12px',
            fontSize: '14px',
            fontWeight: '600',
            cursor: 'pointer',
          }}
        >
          <Plus size={18} /> Add Category
        </button>
      </div>

      {/* Table */}
      {loading ? (
        <div style={{
          textAlign: 'center',
          padding: '80px',
          color: '#888',
        }}>
          Loading...
        </div>
      ) : categories.length === 0 ? (
        <div style={{
          backgroundColor: 'white',
          borderRadius: '16px',
          border: '1px solid #eee',
          padding: '60px',
          textAlign: 'center',
        }}>
          <Grid3x3 size={48} style={{ color: '#ddd', margin: '0 auto 16px' }} />
          <p style={{ color: '#888', fontSize: '14px', margin: 0 }}>
            No categories yet. Add your first category to get started.
          </p>
        </div>
      ) : (
        <div style={{
          backgroundColor: 'white',
          borderRadius: '16px',
          border: '1px solid #eee',
          overflow: 'hidden',
          boxShadow: '0 1px 4px rgba(0,0,0,0.05)',
        }}>
          <table style={{ width: '100%', borderCollapse: 'collapse' }}>
            <thead>
              <tr style={{
                backgroundColor: '#F8F8F8',
                borderBottom: '1px solid #eee',
              }}>
                {['Category', 'Sort Order', 'Items Count', 'Status', 'Actions'].map((h) => (
                  <th key={h} style={{
                    textAlign: h === 'Actions' ? 'right' : 'left',
                    padding: '14px 20px',
                    fontSize: '13px',
                    fontWeight: '600',
                    color: '#555',
                  }}>
                    {h}
                  </th>
                ))}
              </tr>
            </thead>
            <tbody>
              {categories.map((category, i) => (
                <tr key={category.id} style={{
                  borderBottom: i < categories.length - 1 ? '1px solid #f5f5f5' : 'none',
                  backgroundColor: 'white',
                }}>
                  <td style={{
                    padding: '16px 20px',
                    display: 'flex',
                    alignItems: 'center',
                    gap: '12px',
                  }}>
                    <div style={{
                      width: '48px',
                      height: '48px',
                      borderRadius: '10px',
                      overflow: 'hidden',
                      backgroundColor: '#eee',
                      flexShrink: 0,
                    }}>
                      {category.image ? (
                        <img
                          src={category.image}
                          alt={category.name}
                          style={{
                            width: '100%',
                            height: '100%',
                            objectFit: 'cover',
                          }}
                        />
                      ) : (
                        <span style={{
                          display: 'flex',
                          height: '100%',
                          justifyContent: 'center',
                          alignItems: 'center',
                          color: '#aaa',
                          fontSize: '10px',
                        }}>
                          No img
                        </span>
                      )}
                    </div>
                    <div>
                      <p style={{
                        fontWeight: '600',
                        color: '#1D1D1D',
                        margin: 0,
                        fontSize: '15px',
                      }}>
                        {category.name}
                      </p>
                      <p style={{
                        color: '#888',
                        fontSize: '12px',
                        margin: '2px 0 0',
                      }}>
                        ID: {category.id}
                      </p>
                    </div>
                  </td>
                  <td style={{
                    padding: '16px 20px',
                    color: '#555',
                    fontSize: '14px',
                  }}>
                    <span style={{
                      padding: '4px 12px',
                      backgroundColor: '#F8F8F8',
                      borderRadius: '8px',
                      fontSize: '13px',
                      fontWeight: '600',
                    }}>
                      {category.sortOrder}
                    </span>
                  </td>
                  <td style={{
                    padding: '16px 20px',
                    color: '#555',
                    fontSize: '14px',
                  }}>
                    <span style={{
                      padding: '4px 12px',
                      backgroundColor: '#FFF0F0',
                      color: '#E63946',
                      borderRadius: '8px',
                      fontSize: '13px',
                      fontWeight: '600',
                    }}>
                      {category._count?.menuItems || 0} items
                    </span>
                  </td>
                  <td style={{ padding: '16px 20px' }}>
                    <span style={{
                      padding: '4px 12px',
                      borderRadius: '20px',
                      fontSize: '12px',
                      fontWeight: '600',
                      backgroundColor: category.isActive ? '#E8F5E9' : '#FFEBEE',
                      color: category.isActive ? '#2E7D32' : '#C62828',
                    }}>
                      {category.isActive ? 'Active' : 'Inactive'}
                    </span>
                  </td>
                  <td style={{
                    padding: '16px 20px',
                    textAlign: 'right',
                  }}>
                    <button
                      onClick={() => openEdit(category)}
                      style={{
                        padding: '8px',
                        backgroundColor: '#F8F8F8',
                        border: 'none',
                        borderRadius: '8px',
                        cursor: 'pointer',
                        marginRight: '6px',
                        color: '#555',
                      }}
                    >
                      <Pencil size={15} />
                    </button>
                    <button
                      onClick={() => handleDelete(category.id)}
                      style={{
                        padding: '8px',
                        backgroundColor: '#FFF0F0',
                        border: 'none',
                        borderRadius: '8px',
                        cursor: 'pointer',
                        color: '#E63946',
                      }}
                    >
                      <Trash2 size={15} />
                    </button>
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
          position: 'fixed',
          inset: 0,
          backgroundColor: 'rgba(0,0,0,0.5)',
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
          zIndex: 1000,
          padding: '16px',
        }}>
          <div style={{
            backgroundColor: 'white',
            borderRadius: '20px',
            width: '100%',
            maxWidth: '460px',
            boxShadow: '0 20px 60px rgba(0,0,0,0.2)',
          }}>
            {/* Modal Header */}
            <div style={{
              display: 'flex',
              justifyContent: 'space-between',
              alignItems: 'center',
              padding: '20px 24px',
              borderBottom: '1px solid #eee',
            }}>
              <h2 style={{
                fontSize: '18px',
                fontWeight: '700',
                color: '#1D1D1D',
                margin: 0,
              }}>
                {editCategory ? 'Edit Category' : 'Add New Category'}
              </h2>
              <button
                onClick={() => setShowModal(false)}
                style={{
                  padding: '6px',
                  backgroundColor: '#F8F8F8',
                  border: 'none',
                  borderRadius: '8px',
                  cursor: 'pointer',
                }}
              >
                <X size={18} />
              </button>
            </div>

            {/* Modal Form */}
            <form onSubmit={handleSubmit} style={{ padding: '24px' }}>
              <div style={{ marginBottom: '16px' }}>
                <label style={labelStyle}>Category Name *</label>
                <input
                  required
                  value={form.name}
                  onChange={(e) => setForm({ ...form, name: e.target.value })}
                  style={inputStyle}
                  placeholder="e.g., Pizza, Burgers, Drinks"
                />
              </div>

              <div style={{ marginBottom: '16px' }}>
                <label style={labelStyle}>Image URL</label>
                <input
                  value={form.image}
                  onChange={(e) => setForm({ ...form, image: e.target.value })}
                  style={inputStyle}
                  placeholder="https://example.com/category-image.jpg"
                />
                {form.image && (
                  <div style={{ marginTop: '12px' }}>
                    <p style={{
                      fontSize: '12px',
                      color: '#888',
                      marginBottom: '6px',
                    }}>
                      Preview:
                    </p>
                    <div style={{
                      width: '100%',
                      height: '120px',
                      borderRadius: '10px',
                      overflow: 'hidden',
                      backgroundColor: '#f5f5f5',
                    }}>
                      <img
                        src={form.image}
                        alt="Preview"
                        style={{
                          width: '100%',
                          height: '100%',
                          objectFit: 'cover',
                        }}
                        onError={(e) => {
                          e.target.style.display = 'none';
                        }}
                      />
                    </div>
                  </div>
                )}
              </div>

              <div style={{ marginBottom: '24px' }}>
                <label style={labelStyle}>Sort Order</label>
                <input
                  type="number"
                  value={form.sortOrder}
                  onChange={(e) => setForm({ ...form, sortOrder: e.target.value })}
                  style={inputStyle}
                  placeholder="0"
                  min="0"
                />
                <p style={{
                  fontSize: '11px',
                  color: '#888',
                  marginTop: '6px',
                  marginBottom: 0,
                }}>
                  Lower numbers appear first in the list
                </p>
              </div>

              <div style={{ display: 'flex', gap: '12px' }}>
                <button
                  type="button"
                  onClick={() => setShowModal(false)}
                  style={{
                    flex: 1,
                    padding: '12px',
                    backgroundColor: '#F8F8F8',
                    border: 'none',
                    borderRadius: '12px',
                    fontSize: '14px',
                    fontWeight: '600',
                    cursor: 'pointer',
                    color: '#555',
                  }}
                >
                  Cancel
                </button>
                <button
                  type="submit"
                  style={{
                    flex: 1,
                    padding: '12px',
                    backgroundColor: '#E63946',
                    border: 'none',
                    borderRadius: '12px',
                    fontSize: '14px',
                    fontWeight: '600',
                    cursor: 'pointer',
                    color: 'white',
                  }}
                >
                  {editCategory ? 'Update Category' : 'Add Category'}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
}