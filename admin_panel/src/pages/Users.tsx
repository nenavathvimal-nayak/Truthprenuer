import { useState, useEffect } from 'react';
import { supabase } from '../lib/supabase';
import { MoreVertical, Shield, Ban, CheckCircle, Search, Filter } from 'lucide-react';

export function Users() {
  // Fallback mock data until DB is connected
  const [users, setUsers] = useState([
    { id: '1', full_name: 'Elena Rostova', role: 'Founder', status: 'Active', created_at: '2023-10-01' },
    { id: '2', full_name: 'Marcus Chen', role: 'Investor', status: 'Active', created_at: '2023-10-02' },
    { id: '3', full_name: 'Sarah Jenkins', role: 'Mentor', status: 'Active', created_at: '2023-10-03' },
    { id: '4', full_name: 'Suspicious Bot', role: 'Founder', status: 'Suspended', created_at: '2023-10-05' },
  ]);

  return (
    <div className="space-y-6">
      <div className="flex justify-between items-center">
        <h2 className="text-2xl font-bold">User Management</h2>
        <div className="flex space-x-3">
          <div className="relative">
            <Search className="absolute left-3 top-1/2 -translate-y-1/2 text-gray-500" size={18} />
            <input 
              type="text" 
              placeholder="Search users..." 
              className="bg-[#151515] border border-gray-800 text-white pl-10 pr-4 py-2 rounded-lg focus:outline-none focus:border-[#8A2BE2]"
            />
          </div>
          <button className="flex items-center space-x-2 bg-[#151515] border border-gray-800 px-4 py-2 rounded-lg hover:bg-gray-800">
            <Filter size={18} />
            <span>Filter</span>
          </button>
        </div>
      </div>

      <div className="bg-[#151515] border border-gray-800 rounded-xl overflow-hidden">
        <table className="w-full text-left">
          <thead className="bg-[#1A1A1A] border-b border-gray-800 text-gray-400 text-sm">
            <tr>
              <th className="px-6 py-4 font-medium">Name</th>
              <th className="px-6 py-4 font-medium">Role</th>
              <th className="px-6 py-4 font-medium">Status</th>
              <th className="px-6 py-4 font-medium">Joined</th>
              <th className="px-6 py-4 font-medium text-right">Actions</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-gray-800">
            {users.map((user) => (
              <tr key={user.id} className="hover:bg-white/[0.02] transition-colors">
                <td className="px-6 py-4 font-medium flex items-center space-x-3">
                  <div className="w-8 h-8 rounded-full bg-[#8A2BE2]/20 text-[#8A2BE2] flex items-center justify-center font-bold">
                    {user.full_name.charAt(0)}
                  </div>
                  <span>{user.full_name}</span>
                </td>
                <td className="px-6 py-4">
                  <span className="px-2.5 py-1 rounded-md bg-gray-800 text-xs font-medium text-gray-300">
                    {user.role}
                  </span>
                </td>
                <td className="px-6 py-4">
                  {user.status === 'Active' ? (
                    <span className="flex items-center space-x-1 text-green-400 text-sm">
                      <CheckCircle size={14} />
                      <span>Active</span>
                    </span>
                  ) : (
                    <span className="flex items-center space-x-1 text-red-400 text-sm">
                      <Ban size={14} />
                      <span>Suspended</span>
                    </span>
                  )}
                </td>
                <td className="px-6 py-4 text-gray-400 text-sm">{user.created_at}</td>
                <td className="px-6 py-4 text-right">
                  <button className="text-gray-500 hover:text-white p-1">
                    <MoreVertical size={18} />
                  </button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}
