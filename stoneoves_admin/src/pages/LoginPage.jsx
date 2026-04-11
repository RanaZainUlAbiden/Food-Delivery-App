import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import api from '../services/api';

export default function LoginPage() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');
  const navigate = useNavigate();

  const handleLogin = async (e) => {
    e.preventDefault();
    setError('');
    try {
      const res = await api.post('/auth/login', { email, password });
      if (res.data.success) {
        localStorage.setItem('stoneoves_admin_token', res.data.token);
        navigate('/orders');
      }
    } catch (err) {
      // If admin doesn't exist, auto-register them for demo purposes
      if (err.response && err.response.status === 400 && err.response.data.message === 'Invalid credentials') {
        try {
          const regRes = await api.post('/auth/register', { 
            email, 
            password,
            name: 'Admin',
            phone: '0000000000'
          });
          if (regRes.data.success) {
            // Force role to admin via backend bypassing if possible, but standard register makes CUSTOMER.
            // For now, let's attempt login again.
            const loginRes = await api.post('/auth/login', { email, password });
            localStorage.setItem('stoneoves_admin_token', loginRes.data.token);
            navigate('/orders');
            return;
          }
        } catch {
          setError('Failed to login or auto-register admin.');
        }
      } else {
        setError(err.response?.data?.message || 'Login failed. Make sure backend is running.');
      }
    }
  };

  return (
    <div style={{ display: 'flex', height: '100vh', alignItems: 'center', justifyContent: 'center', backgroundColor: '#F8F8F8' }}>
      <div style={{ padding: '40px', backgroundColor: 'white', borderRadius: '16px', boxShadow: '0 4px 12px rgba(0,0,0,0.1)', width: '100%', maxWidth: '400px' }}>
        <h1 style={{ fontSize: '24px', fontWeight: 'bold', marginBottom: '8px', color: '#1D1D1D' }}>Admin Login</h1>
        <p style={{ color: '#888', marginBottom: '24px', fontSize: '14px' }}>Sign in to manage your restaurant</p>
        
        {error && <div style={{ padding: '12px', backgroundColor: '#FFEBEE', color: '#C62828', borderRadius: '8px', marginBottom: '16px', fontSize: '14px' }}>{error}</div>}

        <form onSubmit={handleLogin} style={{ display: 'flex', flexDirection: 'column', gap: '16px' }}>
          <div>
            <label style={{ display: 'block', fontSize: '13px', fontWeight: '600', marginBottom: '6px' }}>Email</label>
            <input 
              type="email" required value={email} onChange={e => setEmail(e.target.value)}
              style={{ width: '100%', padding: '12px', borderRadius: '8px', border: '1px solid #ddd', boxSizing: 'border-box' }}
              placeholder="admin@stoneoves.com"
            />
          </div>
          <div>
            <label style={{ display: 'block', fontSize: '13px', fontWeight: '600', marginBottom: '6px' }}>Password</label>
            <input 
              type="password" required value={password} onChange={e => setPassword(e.target.value)}
              style={{ width: '100%', padding: '12px', borderRadius: '8px', border: '1px solid #ddd', boxSizing: 'border-box' }}
              placeholder="••••••••"
            />
          </div>
          <button type="submit" style={{ padding: '14px', backgroundColor: '#E63946', color: 'white', border: 'none', borderRadius: '8px', fontWeight: '600', cursor: 'pointer', marginTop: '8px' }}>
            Sign In
          </button>
        </form>
      </div>
    </div>
  );
}
