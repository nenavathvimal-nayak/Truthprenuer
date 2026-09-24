import { Outlet, Link, useLocation } from 'react-router-dom';
import { LayoutDashboard, Users, ShieldAlert, Settings } from 'lucide-react';
import { clsx, type ClassValue } from 'clsx';
import { twMerge } from 'tailwind-merge';

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}

export function Layout() {
  const location = useLocation();

  const navItems = [
    { name: 'Dashboard', path: '/', icon: LayoutDashboard },
    { name: 'Users', path: '/users', icon: Users },
    { name: 'Moderation', path: '/moderation', icon: ShieldAlert },
    { name: 'Settings', path: '/settings', icon: Settings },
  ];

  return (
    <div className="flex h-screen bg-[#0A0A0A] text-white">
      {/* Sidebar */}
      <div className="w-64 border-r border-gray-800 bg-[#151515] p-4 flex flex-col">
        <div className="text-xl font-bold mb-8 px-4 text-[#8A2BE2]">TRUTHPRENUER</div>
        
        <nav className="flex-1 space-y-2">
          {navItems.map((item) => {
            const isActive = location.pathname === item.path;
            const Icon = item.icon;
            
            return (
              <Link
                key={item.path}
                to={item.path}
                className={cn(
                  "flex items-center space-x-3 px-4 py-3 rounded-lg transition-colors",
                  isActive 
                    ? "bg-[#8A2BE2]/20 text-[#8A2BE2]" 
                    : "text-gray-400 hover:bg-gray-800 hover:text-white"
                )}
              >
                <Icon size={20} />
                <span className="font-medium">{item.name}</span>
              </Link>
            );
          })}
        </nav>

        <div className="mt-auto px-4 py-3 text-sm text-gray-500">
          Admin Portal v1.0.0
        </div>
      </div>

      {/* Main Content */}
      <div className="flex-1 overflow-auto">
        <header className="h-16 border-b border-gray-800 flex items-center px-8 bg-[#151515]/50 backdrop-blur">
          <h1 className="text-lg font-medium">Platform Admin</h1>
          <div className="ml-auto">
            <div className="w-8 h-8 rounded-full bg-gray-700 flex items-center justify-center">
              A
            </div>
          </div>
        </header>
        <main className="p-8">
          <Outlet />
        </main>
      </div>
    </div>
  );
}
