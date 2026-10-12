import { useState } from 'react';
import { 
  Users, 
  Activity, 
  CheckCircle, 
  Shield, 
  ArrowUpRight, 
  RefreshCw, 
  Clock 
} from 'lucide-react';
import { VerificationVelocityChart } from '../components/visuals/VerificationVelocityChart';
import { CategoryDonutChart } from '../components/visuals/CategoryDonutChart';
import { SystemMetricsGauges } from '../components/visuals/SystemMetricsGauges';
import { SecurityPostureRadar } from '../components/visuals/SecurityPostureRadar';
import { ActivityHeatmap } from '../components/visuals/ActivityHeatmap';
import { GlobalMeshNodes } from '../components/visuals/GlobalMeshNodes';

function MiniSparkline({ data, color }: { data: number[]; color: string }) {
  const min = Math.min(...data);
  const max = Math.max(...data);
  const range = max - min || 1;
  const w = 68;
  const h = 24;
  const points = data
    .map((v, i) => `${(i / (data.length - 1)) * w},${h - ((v - min) / range) * (h - 4) - 2}`)
    .join(' ');

  return (
    <svg width={w} height={h} className="overflow-visible select-none">
      <polyline
        fill="none"
        stroke={color}
        strokeWidth="2"
        strokeLinecap="round"
        strokeLinejoin="round"
        points={points}
      />
    </svg>
  );
}

function EnhancedStatCard({
  title,
  value,
  change,
  subtitle,
  icon: Icon,
  sparkData,
  color = '#F44A22',
  accent = false,
}: {
  title: string;
  value: string;
  change: string;
  subtitle: string;
  icon: any;
  sparkData: number[];
  color?: string;
  accent?: boolean;
}) {
  return (
    <div
      className={`rounded-2xl border p-5 transition-all duration-300 hover:scale-[1.01] hover:shadow-xl ${
        accent
          ? 'border-[#F44A22]/50 bg-gradient-to-br from-[#221A18] via-[#1E1716] to-[#161616] shadow-lg shadow-[#F44A22]/10'
          : 'border-[#2A2A2A] bg-gradient-to-br from-[#1F1F1F] to-[#171717]'
      }`}
    >
      <div className="flex items-center justify-between mb-3">
        <span className="text-[11px] font-mono uppercase tracking-wider text-gray-400">{title}</span>
        <div
          className="p-2 rounded-xl"
          style={{ backgroundColor: `${color}18`, color: color }}
        >
          <Icon size={17} />
        </div>
      </div>

      <div className="flex items-end justify-between">
        <div>
          <div className="text-3xl font-black text-[#FEF8E8] tracking-tight">{value}</div>
          <div className="flex items-center space-x-1 mt-1">
            <span className="text-xs font-mono font-bold text-green-400 flex items-center">
              <ArrowUpRight size={13} className="mr-0.5" />
              {change}
            </span>
            <span className="text-[11px] text-gray-400 font-normal">· {subtitle}</span>
          </div>
        </div>

        <div className="pb-1">
          <MiniSparkline data={sparkData} color={color} />
        </div>
      </div>
    </div>
  );
}

export function Dashboard() {
  const [isRefreshing, setIsRefreshing] = useState(false);

  const handleRefresh = () => {
    setIsRefreshing(true);
    setTimeout(() => setIsRefreshing(false), 700);
  };

  return (
    <div className="space-y-7">
      {/* Top Banner & Header Controls */}
      <div className="flex flex-col lg:flex-row lg:items-center justify-between gap-4 pb-2 border-b border-[#2A2A2A]">
        <div>
          <div className="flex items-center space-x-3">
            <h2 className="text-2xl font-black tracking-tight text-[#FEF8E8]">
              Executive Telemetry & Verification Hub
            </h2>
            <span className="px-2.5 py-1 rounded-full text-[10px] font-mono font-bold bg-[#F44A22]/10 text-[#F44A22] border border-[#F44A22]/30 flex items-center space-x-1">
              <span className="w-1.5 h-1.5 rounded-full bg-[#F44A22] animate-pulse" />
              <span>LIVE TELEMETRY</span>
            </span>
          </div>
          <p className="text-xs text-gray-400 mt-1">
            Autonomous verification velocity, domain distribution, cryptographic consensus, and Zero-Trust boundary posture.
          </p>
        </div>

        <div className="flex items-center space-x-3">
          <div className="hidden sm:flex items-center space-x-2 text-xs font-mono text-gray-400 bg-[#141414] border border-[#2A2A2A] px-3 py-2 rounded-xl">
            <Clock size={14} className="text-[#F44A22]" />
            <span>UTC 15:15 · 127.0.0.1:60135</span>
          </div>

          <button
            onClick={handleRefresh}
            className="flex items-center space-x-2 text-xs font-mono px-3.5 py-2 rounded-xl bg-[#222222] text-[#FEF8E8] border border-[#2A2A2A] hover:border-[#F44A22] hover:text-[#F44A22] transition-colors"
          >
            <RefreshCw size={13} className={isRefreshing ? 'animate-spin' : ''} />
            <span>Refresh</span>
          </button>
        </div>
      </div>

      {/* Top Interactive KPI Stat Cards with SVG Sparklines */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
        <EnhancedStatCard
          title="Consensus Validations"
          value="1,842"
          change="+18.4%"
          subtitle="this sprint"
          icon={Activity}
          sparkData={[12, 19, 15, 25, 22, 30, 38, 42]}
          color="#F44A22"
          accent={true}
        />
        <EnhancedStatCard
          title="Verified Truth Records"
          value="1,492"
          change="+12.1%"
          subtitle="cryptographically sealed"
          icon={CheckCircle}
          sparkData={[8, 14, 12, 18, 20, 26, 31, 35]}
          color="#10B981"
        />
        <EnhancedStatCard
          title="Active Founder Profiles"
          value="2,810"
          change="+8.6%"
          subtitle="authenticated identities"
          icon={Users}
          sparkData={[20, 21, 23, 24, 26, 28, 29, 32]}
          color="#3B82F6"
        />
        <EnhancedStatCard
          title="Security Incidents"
          value="0 Breaches"
          change="100%"
          subtitle="Zero-Trust enforced"
          icon={Shield}
          sparkData={[0, 0, 0, 0, 0, 0, 0, 0]}
          color="#8B5CF6"
        />
      </div>

      {/* Primary Analytics Row: Velocity Area Chart & Industry Donut Chart */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <div className="lg:col-span-2">
          <VerificationVelocityChart />
        </div>
        <div className="lg:col-span-1">
          <CategoryDonutChart />
        </div>
      </div>

      {/* Secondary Row: System Metrics Gauges & Security Posture Radar */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <div className="lg:col-span-2">
          <SystemMetricsGauges />
        </div>
        <div className="lg:col-span-1">
          <SecurityPostureRadar />
        </div>
      </div>

      {/* Tertiary Row: Hourly Heatmap & Global Mesh Nodes */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <ActivityHeatmap />
        <GlobalMeshNodes />
      </div>

      {/* Recent High-Priority Validation Decisions Table */}
      <div className="rounded-2xl border border-[#2A2A2A] bg-gradient-to-br from-[#1F1F1F] to-[#171717] p-6 shadow-xl">
        <div className="flex items-center justify-between mb-5">
          <div>
            <h3 className="font-bold text-sm text-[#FEF8E8]">Recent Verification Dispatches & Evidence Reports</h3>
            <p className="text-xs text-gray-400 mt-0.5">Directly verified by autonomous consensus algorithms</p>
          </div>
          <span className="text-[11px] font-mono text-gray-400 bg-[#161616] px-2.5 py-1 rounded-lg border border-[#2A2A2A]">
            Auto-Sync Active
          </span>
        </div>

        <div className="space-y-3">
          {[
            {
              id: 'VAL-9821',
              title: 'Autonomous LLM Hallucination Guard with Sub-10ms Gate',
              category: 'AI & DeepTech',
              verdict: 'VERIFIED TRUTH',
              confidence: '98.4%',
              validators: 42,
              statusColor: 'text-green-400 bg-green-500/10 border-green-500/30'
            },
            {
              id: 'VAL-9820',
              title: 'Decentralized Micro-Invoice Factoring for Dubai Logistics',
              category: 'FinTech',
              verdict: 'VERIFIED TRUTH',
              confidence: '94.1%',
              validators: 29,
              statusColor: 'text-green-400 bg-green-500/10 border-green-500/30'
            },
            {
              id: 'VAL-9819',
              title: '100x Compression Ratio Genomic Alignment Pipeline',
              category: 'HealthTech',
              verdict: 'DISPUTED EVIDENCE',
              confidence: '43.2%',
              validators: 38,
              statusColor: 'text-[#F44A22] bg-[#F44A22]/10 border-[#F44A22]/30'
            },
            {
              id: 'VAL-9818',
              title: 'Zero-Overhead SQLite Cache Invalidation on Mobile',
              category: 'DevTools',
              verdict: 'VERIFIED TRUTH',
              confidence: '91.8%',
              validators: 19,
              statusColor: 'text-green-400 bg-green-500/10 border-green-500/30'
            }
          ].map((item) => (
            <div
              key={item.id}
              className="flex flex-col sm:flex-row sm:items-center justify-between p-4 rounded-xl bg-[#161616] border border-[#2A2A2A] hover:border-[#3A3A3A] transition-all gap-3"
            >
              <div className="space-y-1">
                <div className="flex items-center space-x-2">
                  <span className="text-[10px] font-mono text-gray-500">{item.id}</span>
                  <span className="text-[11px] font-mono px-2 py-0.5 rounded bg-[#222222] text-gray-300">
                    {item.category}
                  </span>
                </div>
                <div className="text-xs font-bold text-[#FEF8E8]">{item.title}</div>
              </div>

              <div className="flex items-center space-x-4 self-end sm:self-auto">
                <div className="text-right">
                  <div className="text-xs font-mono font-bold text-[#FEF8E8]">{item.confidence}</div>
                  <div className="text-[10px] font-mono text-gray-500">{item.validators} nodes</div>
                </div>

                <span className={`px-2.5 py-1 rounded-lg text-[10px] font-mono font-bold border ${item.statusColor}`}>
                  {item.verdict}
                </span>
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}
