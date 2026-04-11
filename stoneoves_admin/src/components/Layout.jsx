import { Outlet, NavLink } from 'react-router-dom';
import { ShoppingBag, UtensilsCrossed } from 'lucide-react';

export default function Layout() {
  return (
    <div style={{ display: 'flex', minHeight: '100vh', fontFamily: 'Inter, sans-serif' }}>
      {/* Sidebar */}
      <aside style={{
        width: '240px',
        minHeight: '100vh',
        backgroundColor: '#1D1D1D',
        display: 'flex',
        flexDirection: 'column',
        position: 'fixed',
        left: 0,
        top: 0,
        bottom: 0,
      }}>
        {/* Logo */}
        <div style={{
          padding: '24px',
          borderBottom: '1px solid #333',
        }}>
          <h1 style={{ color: 'white', fontSize: '18px', fontWeight: '700', margin: 0 }}>
            🍕 Stone Oves
          </h1>
          <p style={{ color: '#888', fontSize: '12px', marginTop: '4px' }}>
            Admin Panel
          </p>
        </div>

        {/* Nav */}
        <nav style={{ flex: 1, padding: '16px' }}>
          <NavLink
            to="/orders"
            style={({ isActive }) => ({
              display: 'flex',
              alignItems: 'center',
              gap: '12px',
              padding: '12px 16px',
              borderRadius: '12px',
              marginBottom: '8px',
              textDecoration: 'none',
              fontSize: '14px',
              fontWeight: '500',
              backgroundColor: isActive ? '#E63946' : 'transparent',
              color: isActive ? 'white' : '#888',
              transition: 'all 0.2s',
            })}
          >
            <ShoppingBag size={18} />
            Orders
          </NavLink>

          <NavLink
            to="/menu"
            style={({ isActive }) => ({
              display: 'flex',
              alignItems: 'center',
              gap: '12px',
              padding: '12px 16px',
              borderRadius: '12px',
              textDecoration: 'none',
              fontSize: '14px',
              fontWeight: '500',
              backgroundColor: isActive ? '#E63946' : 'transparent',
              color: isActive ? 'white' : '#888',
              transition: 'all 0.2s',
            })}
          >
            <UtensilsCrossed size={18} />
            Menu Items
          </NavLink>
        </nav>

        {/* Footer */}
        <div style={{
          padding: '16px',
          borderTop: '1px solid #333',
          textAlign: 'center',
        }}>
          <p style={{ color: '#555', fontSize: '11px' }}>
            Powered by DevInfantary
          </p>
        </div>
      </aside>

      {/* Main Content */}
      <main style={{
        flex: 1,
        marginLeft: '240px',
        backgroundColor: '#F8F8F8',
        minHeight: '100vh',
      }}>
        <Outlet />
      </main>
    </div>
  );
}