import { Users, Activity, CheckCircle, AlertTriangle } from 'lucide-react';

function StatCard({ title, value, icon: Icon, color }: { title: string, value: string, icon: any, color: string }) {
  return (
    <div className="bg-[#151515] border border-gray-800 rounded-xl p-6">
      <div className="flex items-center justify-between mb-4">
        <h3 className="text-gray-400 font-medium">{title}</h3>
        <div className={`p-2 rounded-lg bg-${color}-500/10 text-${color}-500`}>
          <Icon size={20} />
        </div>
      </div>
      <div className="text-3xl font-bold">{value}</div>
    </div>
  );
}

export function Dashboard() {
  return (
    <div className="space-y-6">
      <h2 className="text-2xl font-bold">Platform Overview</h2>
      
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        <StatCard title="Total Users" value="2,543" icon={Users} color="blue" />
        <StatCard title="Active Validations" value="142" icon={Activity} color="purple" />
        <StatCard title="Decisions Reached" value="89" icon={CheckCircle} color="green" />
        <StatCard title="Pending Reports" value="12" icon={AlertTriangle} color="red" />
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6 mt-8">
        <div className="lg:col-span-2 bg-[#151515] border border-gray-800 rounded-xl p-6 h-96">
          <h3 className="font-semibold mb-4">Recent Activity</h3>
          <div className="flex h-full items-center justify-center text-gray-500">
            Activity chart will appear here
          </div>
        </div>
        
        <div className="bg-[#151515] border border-gray-800 rounded-xl p-6 h-96">
          <h3 className="font-semibold mb-4">System Health</h3>
          <div className="space-y-4">
            <div className="flex justify-between items-center p-3 rounded bg-green-500/10 text-green-400 border border-green-500/20">
              <span>API Status</span>
              <span className="font-mono text-sm">Operational</span>
            </div>
            <div className="flex justify-between items-center p-3 rounded bg-green-500/10 text-green-400 border border-green-500/20">
              <span>Database</span>
              <span className="font-mono text-sm">99.9% Uptime</span>
            </div>
            <div className="flex justify-between items-center p-3 rounded bg-yellow-500/10 text-yellow-400 border border-yellow-500/20">
              <span>Gemini API Quota</span>
              <span className="font-mono text-sm">82% Used</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
