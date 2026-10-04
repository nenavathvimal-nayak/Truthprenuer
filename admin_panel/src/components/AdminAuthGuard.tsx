import React, { useState, useEffect, createContext, useContext } from 'react';
import { supabase } from '../lib/supabase';
import { Shield, Lock, AlertCircle, LogOut } from 'lucide-react';

interface AdminUser {
  id: string;
  email: string;
  role: string;
  isSimulated?: boolean;
}

interface AuthContextType {
  user: AdminUser | null;
  loading: boolean;
  signOut: () => Promise<void>;
  simulateAdmin: () => void;
}

const AuthContext = createContext<AuthContextType>({
  user: null,
  loading: true,
  signOut: async () => {},
  simulateAdmin: () => {},
});

export const useAdminAuth = () => useContext(AuthContext);

export function AdminAuthGuard({ children }: { children: React.ReactNode }) {
  const [user, setUser] = useState<AdminUser | null>(null);
  const [loading, setLoading] = useState(true);
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [errorMsg, setErrorMsg] = useState('');
  const [isSubmitting, setIsSubmitting] = useState(false);

  useEffect(() => {
    // Check existing Supabase session
    async function checkSession() {
      try {
        const { data: { session }, error } = await supabase.auth.getSession();
        if (session && !error) {
          const userMeta = session.user.app_metadata || {};
          const role = userMeta.role || 'Admin';
          setUser({
            id: session.user.id,
            email: session.user.email || 'admin@truthprenuer.com',
            role: role,
          });
        }
      } catch (err) {
        console.warn('Session check failed:', err);
      } finally {
        setLoading(false);
      }
    }

    checkSession();

    const { data: authListener } = supabase.auth.onAuthStateChange((_event, session) => {
      if (session) {
        const userMeta = session.user.app_metadata || {};
        setUser({
          id: session.user.id,
          email: session.user.email || 'admin@truthprenuer.com',
          role: userMeta.role || 'Admin',
        });
      } else {
        setUser((prev) => (prev?.isSimulated ? prev : null));
      }
    });

    return () => {
      authListener?.subscription.unsubscribe();
    };
  }, []);

  const handleSignIn = async (e: React.FormEvent) => {
    e.preventDefault();
    setIsSubmitting(true);
    setErrorMsg('');

    try {
      const { data, error } = await supabase.auth.signInWithPassword({
        email,
        password,
      });

      if (error) {
        setErrorMsg(error.message);
        setIsSubmitting(false);
        return;
      }

      if (data.session) {
        const role = data.session.user.app_metadata?.role || 'Admin';
        setUser({
          id: data.session.user.id,
          email: data.session.user.email || email,
          role,
        });
      }
    } catch (err: any) {
      setErrorMsg(err.message || 'Authentication failed. Please verify credentials.');
    } finally {
      setIsSubmitting(false);
    }
  };

  const simulateAdmin = () => {
    setUser({
      id: 'local-dev-admin-uuid',
      email: 'dev.admin@truthprenuer.internal',
      role: 'Super_Admin',
      isSimulated: true,
    });
  };

  const signOut = async () => {
    try {
      await supabase.auth.signOut();
    } catch (err) {
      console.warn('Sign out error:', err);
    }
    setUser(null);
  };

  if (loading) {
    return (
      <div className="flex h-screen items-center justify-center bg-[#161616] text-[#FEF8E8]">
        <div className="animate-spin rounded-full h-8 w-8 border-t-2 border-[#F44A22]"></div>
      </div>
    );
  }

  // Not authenticated: render privileged security gate
  if (!user) {
    return (
      <div className="flex min-h-screen items-center justify-center bg-[#161616] p-6 text-white">
        <div className="w-full max-w-md rounded-2xl border border-[#2A2A2A] bg-[#1F1F1F] p-8 shadow-2xl">
          <div className="flex items-center space-x-3 mb-6">
            <div className="flex h-12 w-12 items-center justify-center rounded-xl bg-[#F44A22]/10 text-[#F44A22]">
              <Shield size={26} />
            </div>
            <div>
              <div className="text-xl font-bold tracking-tight text-[#FEF8E8]">TRUTHPRENUER</div>
              <div className="text-xs font-mono uppercase tracking-widest text-[#F44A22]">Privileged Boundary</div>
            </div>
          </div>

          <p className="text-xs text-gray-400 mb-6 leading-relaxed">
            Administrative access is monitored and logged in compliance with Zero Trust policy. Every action is tied to an immutable audit record.
          </p>

          {errorMsg && (
            <div className="mb-4 flex items-center space-x-2 rounded-lg border border-red-500/30 bg-red-500/10 p-3 text-xs text-red-400">
              <AlertCircle size={16} />
              <span>{errorMsg}</span>
            </div>
          )}

          <form onSubmit={handleSignIn} className="space-y-4">
            <div>
              <label className="block text-xs font-medium uppercase tracking-wider text-gray-400 mb-1">
                Admin Identity (Email)
              </label>
              <input
                type="email"
                required
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                placeholder="admin@truthprenuer.com"
                className="w-full rounded-lg border border-[#2A2A2A] bg-[#161616] px-4 py-2.5 text-sm text-white placeholder-gray-600 focus:border-[#F44A22] focus:outline-none transition-colors"
              />
            </div>

            <div>
              <label className="block text-xs font-medium uppercase tracking-wider text-gray-400 mb-1">
                Password
              </label>
              <input
                type="password"
                required
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                placeholder="••••••••••••"
                className="w-full rounded-lg border border-[#2A2A2A] bg-[#161616] px-4 py-2.5 text-sm text-white placeholder-gray-600 focus:border-[#F44A22] focus:outline-none transition-colors"
              />
            </div>

            <button
              type="submit"
              disabled={isSubmitting}
              className="w-full rounded-lg bg-[#F44A22] py-2.5 text-sm font-semibold text-white hover:bg-[#D73D19] transition-colors disabled:opacity-50 flex items-center justify-center space-x-2 shadow-lg shadow-[#F44A22]/20"
            >
              <Lock size={16} />
              <span>{isSubmitting ? 'Authenticating...' : 'Authenticate Privileged Session'}</span>
            </button>
          </form>

          {/* Local Development Simulation Bypass */}
          <div className="mt-8 border-t border-[#2A2A2A] pt-4 text-center">
            <button
              onClick={simulateAdmin}
              className="text-xs text-gray-500 hover:text-[#FEF8E8] transition-colors underline"
            >
              [Dev Mode] Enter as Local Super_Admin
            </button>
          </div>
        </div>
      </div>
    );
  }

  // Authenticated user exists: verify RBAC permissions
  const privilegedRoles = ['Admin', 'Super_Admin', 'Moderator', 'Security'];
  const hasAccess = privilegedRoles.includes(user.role);

  if (!hasAccess) {
    return (
      <div className="flex min-h-screen items-center justify-center bg-[#161616] p-6 text-white">
        <div className="w-full max-w-md rounded-2xl border border-red-500/30 bg-[#1F1F1F] p-8 text-center shadow-2xl">
          <div className="mx-auto mb-4 flex h-14 w-14 items-center justify-center rounded-full bg-red-500/10 text-red-500">
            <AlertCircle size={32} />
          </div>
          <h2 className="text-xl font-bold text-white mb-2">Access Denied</h2>
          <p className="text-xs text-gray-400 mb-6">
            Your account ({user.email}) has role <span className="font-mono text-[#F44A22]">{user.role}</span>, which lacks administrative authorization to access this portal.
          </p>
          <button
            onClick={signOut}
            className="inline-flex items-center space-x-2 rounded-lg bg-[#2A2A2A] px-4 py-2 text-xs font-semibold text-white hover:bg-gray-700 transition-colors"
          >
            <LogOut size={14} />
            <span>Sign Out</span>
          </button>
        </div>
      </div>
    );
  }

  return (
    <AuthContext.Provider value={{ user, loading, signOut, simulateAdmin }}>
      {children}
    </AuthContext.Provider>
  );
}
