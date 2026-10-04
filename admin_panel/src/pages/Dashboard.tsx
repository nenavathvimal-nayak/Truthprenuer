import { Users, Activity, CheckCircle, Shield, Cpu, Database, Flame } from 'lucide-react';

function StatCard({ 
  title, 
  value, 
  subtitle,
  icon: Icon, 
  accent = false 
}: { 
  title: string; 
  value: string; 
  subtitle?: string;
  icon: any; 
  accent?: boolean;
}) {
  return (
    <div className={`rounded-2xl border p-6 transition-all ${
      accent 
        ? 'border-[#F44A22]/50 bg-gradient-to-br from-[#1F1F1F] to-[#2A1510] shadow-lg shadow-[#F44A22]/10' 
        : 'border-[#2A2A2A] bg-[#1F1F1F]'
    }`}>
      <div className="flex items-center justify-between mb-4">
        <h3 className="text-xs font-mono uppercase tracking-wider text-gray-400">{title}</h3>
        <div className={`p-2.5 rounded-xl ${accent ? 'bg-[#F44A22] text-[#FEF8E8]' : 'bg-[#161616] text-[#F44A22] border border-[#2A2A2A]'}`}>
          <Icon size={18} />
        </div>
      </div>
      <div className="text-3xl font-black text-[#FEF8E8] tracking-tight">{value}</div>
      {subtitle && <div className="text-xs text-gray-400 mt-2">{subtitle}</div>}
    </div>
  );
}

export function Dashboard() {
  return (
    <div className="space-y-8">
      <div>
        <h2 className="text-2xl font-bold tracking-tight text-[#FEF8E8]">Platform Telemetry & Overview</h2>
        <p className="text-xs text-gray-400 mt-1">
          Real-time health, security boundaries, and validation ecosystem status.
        </p>
      </div>
      
      {/* Primary KPI Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-5">
        <StatCard 
          title="Active Validations" 
          value="184" 
          subtitle="+14% this sprint"
          icon={Activity} 
          accent={true}
        />
        <StatCard 
          title="Founder Profiles" 
          value="2,810" 
          subtitle="All email verified"
          icon={Users} 
        />
        <StatCard 
          title="Empirical Evidence" 
          value="1,492" 
          subtitle="Signed, tamper-checked"
          icon={CheckCircle} 
        />
        <StatCard 
          title="Security Actions" 
          value="0 Breaches" 
          subtitle="Zero Trust active"
          icon={Shield} 
        />
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Activity & Validation Stream */}
        <div className="lg:col-span-2 rounded-2xl border border-[#2A2A2A] bg-[#1F1F1F] p-6">
          <div className="flex items-center justify-between mb-6">
            <div>
              <h3 className="font-bold text-sm text-[#FEF8E8]">Live Validation Activity</h3>
              <p className="text-xs text-gray-400">Stream of newly created sprints and responses</p>
            </div>
            <span className="text-[11px] font-mono bg-green-500/10 text-green-400 border border-green-500/20 px-2 py-0.5 rounded-full">
              ● Live Stream
            </span>
          </div>

          <div className="space-y-3">
            {[
              { title: "B2B AI Knowledge Graph for Medical Clinics", stage: "MVP Validation", responses: 28, time: "4m ago" },
              { title: "Micro-SaaS for Freelance Tax Compliance in UAE", stage: "Problem Discovery", responses: 41, time: "18m ago" },
              { title: "Autonomous Security Scanner for Supabase RLS", stage: "Interactive Prototype", responses: 67, time: "1h ago" },
              { title: "Developer Tooling for Offline-First Flutter Apps", stage: "Early Traction", responses: 89, time: "3h ago" }
            ].map((v, i) => (
              <div key={i} className="flex items-center justify-between p-3.5 rounded-xl border border-[#2A2A2A] bg-[#161616] hover:border-[#F44A22]/50 transition-colors">
                <div>
                  <div className="text-xs font-semibold text-[#FEF8E8]">{v.title}</div>
                  <div className="text-[11px] text-gray-400 font-mono mt-0.5">{v.stage} · {v.responses} evidence submissions</div>
                </div>
                <div className="text-[11px] font-mono text-gray-500">{v.time}</div>
              </div>
            ))}
          </div>
        </div>
        
        {/* Security & System Infrastructure Posture */}
        <div className="rounded-2xl border border-[#2A2A2A] bg-[#1F1F1F] p-6 flex flex-col justify-between">
          <div>
            <h3 className="font-bold text-sm text-[#FEF8E8] mb-1">Infrastructure & Quotas</h3>
            <p className="text-xs text-gray-400 mb-6">Targeting ₹0 baseline free-tier architecture</p>

            <div className="space-y-3 font-mono text-xs">
              <div className="flex justify-between items-center p-3 rounded-xl bg-[#161616] border border-[#2A2A2A]">
                <div className="flex items-center space-x-2">
                  <Database size={15} className="text-[#F44A22]" />
                  <span className="text-gray-300">Supabase RLS</span>
                </div>
                <span className="text-green-400 font-bold">100% Enforced</span>
              </div>

              <div className="flex justify-between items-center p-3 rounded-xl bg-[#161616] border border-[#2A2A2A]">
                <div className="flex items-center space-x-2">
                  <Shield size={15} className="text-[#F44A22]" />
                  <span className="text-gray-300">FastAPI Gateway</span>
                </div>
                <span className="text-green-400 font-bold">Passing (12/12)</span>
              </div>

              <div className="flex justify-between items-center p-3 rounded-xl bg-[#161616] border border-[#2A2A2A]">
                <div className="flex items-center space-x-2">
                  <Flame size={15} className="text-[#F44A22]" />
                  <span className="text-gray-300">Cloudflare Edge</span>
                </div>
                <span className="text-green-400 font-bold">Strict WAF</span>
              </div>

              <div className="flex justify-between items-center p-3 rounded-xl bg-[#161616] border border-[#2A2A2A]">
                <div className="flex items-center space-x-2">
                  <Cpu size={15} className="text-[#F44A22]" />
                  <span className="text-gray-300">OCI Compute</span>
                </div>
                <span className="text-[#FEF8E8] font-bold">₹0 Free Tier</span>
              </div>
            </div>
          </div>

          <div className="mt-6 pt-4 border-t border-[#2A2A2A] text-[11px] text-gray-500 text-center font-mono">
            Zero Trust Verification Active
          </div>
        </div>
      </div>
    </div>
  );
}
