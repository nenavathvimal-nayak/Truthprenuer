import { AlertTriangle, Check, X, Eye } from 'lucide-react';

export function Moderation() {
  const flags = [
    { id: '1', type: 'Validation Request', user: 'Founder_492', reason: 'Spam / Low Quality', date: '2 hours ago', severity: 'medium' },
    { id: '2', type: 'Chat Message', user: 'Investor_X', reason: 'Harassment', date: '5 hours ago', severity: 'high' },
    { id: '3', type: 'Profile Bio', user: 'TechBro99', reason: 'Inappropriate Content', date: '1 day ago', severity: 'low' },
  ];

  return (
    <div className="space-y-6">
      <div className="flex justify-between items-center">
        <h2 className="text-2xl font-bold">Content Moderation</h2>
        <div className="flex space-x-2">
          <button className="bg-[#1A1A1A] text-gray-300 px-4 py-2 rounded-lg border border-gray-800 hover:bg-gray-800">Review History</button>
          <button className="bg-[#8A2BE2] text-white px-4 py-2 rounded-lg hover:bg-[#9d4edd]">Auto-Mod Settings</button>
        </div>
      </div>

      <div className="grid gap-4">
        {flags.map((flag) => (
          <div key={flag.id} className="bg-[#151515] border border-gray-800 rounded-xl p-5 flex items-center justify-between">
            <div className="flex items-start space-x-4">
              <div className={`p-2 rounded-lg mt-1 ${
                flag.severity === 'high' ? 'bg-red-500/10 text-red-500' :
                flag.severity === 'medium' ? 'bg-yellow-500/10 text-yellow-500' :
                'bg-blue-500/10 text-blue-500'
              }`}>
                <AlertTriangle size={20} />
              </div>
              <div>
                <div className="flex items-center space-x-3 mb-1">
                  <h3 className="font-semibold text-lg">{flag.type}</h3>
                  <span className="text-xs text-gray-500">{flag.date}</span>
                </div>
                <p className="text-gray-400 text-sm">
                  Reported by system: <span className="text-white">{flag.reason}</span> 
                  <span className="mx-2">•</span> 
                  User: <span className="text-[#8A2BE2]">{flag.user}</span>
                </p>
              </div>
            </div>
            
            <div className="flex items-center space-x-2">
              <button className="p-2 text-gray-400 hover:text-white hover:bg-gray-800 rounded-lg tooltip" title="View Content">
                <Eye size={20} />
              </button>
              <button className="p-2 text-green-400 hover:bg-green-400/10 rounded-lg tooltip" title="Approve / Safe">
                <Check size={20} />
              </button>
              <button className="p-2 text-red-400 hover:bg-red-400/10 rounded-lg tooltip" title="Take Down / Ban">
                <X size={20} />
              </button>
            </div>
          </div>
        ))}
        
        {flags.length === 0 && (
          <div className="text-center py-12 text-gray-500 bg-[#151515] border border-gray-800 rounded-xl">
            <Shield size={48} className="mx-auto mb-4 opacity-50" />
            <p>No pending moderation flags. Good job!</p>
          </div>
        )}
      </div>
    </div>
  );
}
