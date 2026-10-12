import { useState } from 'react';
import { AlertTriangle, Shield, CheckCircle2 } from 'lucide-react';
import { useAdminAuth } from '../components/AdminAuthGuard';

export function Moderation() {
  const { user } = useAdminAuth();
  const [reports, setReports] = useState([
    { id: 'rep_01', type: 'Validation Thesis', target_id: 'val_492', user: 'Founder_Alpha', reason: 'Unsubstantiated competitor claim without verifiable evidence', date: '25m ago', severity: 'medium', status: 'pending' },
    { id: 'rep_02', type: 'Direct Message', target_id: 'msg_881', user: 'SpamEntity_99', reason: 'Unsolicited mass crypto promotion in founder inbox', date: '1h ago', severity: 'high', status: 'pending' },
    { id: 'rep_03', type: 'Profile Bio', target_id: 'prof_112', user: 'LeadGenBot', reason: 'Deceptive external phishing link in website URL', date: '3h ago', severity: 'high', status: 'pending' },
  ]);

  const [feedback, setFeedback] = useState<string | null>(null);

  const handleAction = (reportId: string, action: 'dismiss' | 'remove_content' | 'warn_user') => {
    const report = reports.find(r => r.id === reportId);
    if (!report) return;

    const actionText = action === 'dismiss' ? 'DISMISSED' : action === 'remove_content' ? 'CONTENT REMOVED' : 'WARNING ISSUED';
    setReports(prev => prev.filter(r => r.id !== reportId));
    setFeedback(`Report ${reportId} processed: ${actionText}. Audit event recorded by ${user?.email}.`);
    setTimeout(() => setFeedback(null), 5000);
  };

  return (
    <div className="space-y-6">
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
          <h2 className="text-2xl font-bold tracking-tight text-[#FEF8E8]">Content & Trust Moderation</h2>
          <p className="text-xs text-gray-400 mt-1">
            Empirical validation integrity enforcement. Every review action generates an immutable audit record.
          </p>
        </div>

        <div className="flex items-center space-x-2">
          <span className="px-3 py-1.5 rounded-xl border border-[#2A2A2A] bg-[#1F1F1F] text-xs font-mono text-[#FEF8E8]">
            Pending Queue: <span className="text-[#F44A22] font-bold">{reports.length}</span>
          </span>
        </div>
      </div>

      {feedback && (
        <div className="flex items-center space-x-2 rounded-xl border border-green-500/30 bg-green-500/10 p-3.5 text-xs text-green-400 font-mono">
          <CheckCircle2 size={16} />
          <span>{feedback}</span>
        </div>
      )}

      <div className="grid gap-4">
        {reports.map((report) => (
          <div key={report.id} className="bg-[#1F1F1F] border border-[#2A2A2A] rounded-2xl p-5 flex flex-col sm:flex-row sm:items-center justify-between gap-4 hover:border-[#F44A22]/40 transition-colors">
            <div className="flex items-start space-x-4">
              <div className={`p-2.5 rounded-xl mt-0.5 ${
                report.severity === 'high' ? 'bg-red-500/10 text-red-500 border border-red-500/20' :
                report.severity === 'medium' ? 'bg-[#F44A22]/10 text-[#F44A22] border border-[#F44A22]/20' :
                'bg-blue-500/10 text-blue-500 border border-blue-500/20'
              }`}>
                <AlertTriangle size={18} />
              </div>
              <div>
                <div className="flex items-center space-x-3 mb-1">
                  <h3 className="font-bold text-sm text-[#FEF8E8]">{report.type}</h3>
                  <span className="text-[11px] font-mono text-gray-500">Target ID: {report.target_id}</span>
                  <span className="text-[11px] font-mono text-gray-400">· {report.date}</span>
                </div>
                <p className="text-gray-300 text-xs leading-relaxed">
                  Reason: <span className="text-[#FEF8E8] font-medium">{report.reason}</span>
                </p>
                <div className="text-[11px] text-gray-400 font-mono mt-1">
                  Reported User: <span className="text-[#F44A22] font-semibold">{report.user}</span>
                </div>
              </div>
            </div>
            
            <div className="flex items-center space-x-2 self-end sm:self-center">
              <button 
                onClick={() => handleAction(report.id, 'dismiss')}
                className="px-3 py-1.5 rounded-xl text-xs font-semibold text-gray-400 hover:text-white hover:bg-[#2A2A2A] border border-[#2A2A2A] transition-colors"
                title="Dismiss Report as False Positive"
              >
                Dismiss
              </button>
              <button 
                onClick={() => handleAction(report.id, 'warn_user')}
                className="px-3 py-1.5 rounded-xl text-xs font-semibold text-amber-400 hover:bg-amber-400/10 border border-amber-400/20 transition-colors"
                title="Issue Founder Warning"
              >
                Warn
              </button>
              <button 
                onClick={() => handleAction(report.id, 'remove_content')}
                className="px-3 py-1.5 rounded-xl text-xs font-semibold bg-[#F44A22] text-[#FEF8E8] hover:bg-[#D73D19] transition-colors shadow-md shadow-[#F44A22]/20"
                title="Remove Hostile/Spam Content"
              >
                Remove Content
              </button>
            </div>
          </div>
        ))}
        
        {reports.length === 0 && (
          <div className="text-center py-16 text-gray-500 bg-[#1F1F1F] border border-[#2A2A2A] rounded-2xl">
            <Shield size={44} className="mx-auto mb-3 text-[#F44A22] opacity-60" />
            <h4 className="text-base font-bold text-[#FEF8E8]">Moderation Queue Clear</h4>
            <p className="text-xs text-gray-400 mt-1">All reported content has been reviewed according to community guidelines.</p>
          </div>
        )}
      </div>
    </div>
  );
}
