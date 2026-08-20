'use client';

import React, { useState } from 'react';
import WebPlayer from '@/components/WebPlayer';
import { Tv, Play, Layers, Activity, Settings, RefreshCw } from 'lucide-react';

export default function Dashboard() {
  const [activeStream, setActiveStream] = useState<string>(
    'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8'
  );

  return (
    <div className="flex h-screen bg-[#0B0E14] text-slate-200 overflow-hidden">
      {/* Sidebar Navigation */}
      <aside className="w-64 bg-[#151921] border-r border-slate-800/80 p-4 flex flex-col justify-between">
        <div className="space-y-6">
          <div className="flex items-center space-x-3 px-2">
            <div className="p-2 bg-blue-600 rounded-lg shadow-lg shadow-blue-600/30">
              <Tv className="w-6 h-6 text-white" />
            </div>
            <span className="font-bold text-lg tracking-wide text-white">
              SMART <span className="text-blue-500">IPTV</span>
            </span>
          </div>

          <nav className="space-y-1">
            <button className="flex items-center w-full px-3 py-2.5 text-sm font-medium rounded-lg bg-blue-600/20 text-blue-400 border border-blue-500/30">
              <Play className="w-4 h-4 mr-3" /> Live Player
            </button>
            <button className="flex items-center w-full px-3 py-2.5 text-sm font-medium rounded-lg text-slate-400 hover:bg-slate-800/50 hover:text-slate-200 transition">
              <Layers className="w-4 h-4 mr-3" /> EPG Manager
            </button>
            <button className="flex items-center w-full px-3 py-2.5 text-sm font-medium rounded-lg text-slate-400 hover:bg-slate-800/50 hover:text-slate-200 transition">
              <Activity className="w-4 h-4 mr-3" /> Smart Failover Sync
            </button>
          </nav>
        </div>

        <div className="pt-4 border-t border-slate-800">
          <button className="flex items-center w-full px-3 py-2 text-sm font-medium text-slate-400 hover:text-slate-200">
            <Settings className="w-4 h-4 mr-3" /> Settings
          </button>
        </div>
      </aside>

      {/* Main Workspace */}
      <main className="flex-1 flex flex-col overflow-hidden">
        <header className="h-16 border-b border-slate-800/80 bg-[#151921]/50 backdrop-blur px-6 flex items-center justify-between">
          <h1 className="text-lg font-semibold text-white flex items-center gap-2">
            <span className="h-2 w-2 rounded-full bg-emerald-500 animate-pulse"></span>
            Active Engine Session
          </h1>
          <button className="px-3 py-1.5 text-xs font-medium bg-slate-800 hover:bg-slate-700 text-slate-300 rounded-md border border-slate-700 flex items-center gap-2 transition">
            <RefreshCw className="w-3.5 h-3.5" /> Sync Cloud State
          </button>
        </header>

        <section className="flex-1 p-6 grid grid-cols-12 gap-6 overflow-y-auto">
          {/* Main WebGL Video Display */}
          <div className="col-span-12 lg:col-span-8 flex flex-col space-y-4">
            <div className="aspect-video w-full bg-black rounded-xl overflow-hidden border border-slate-800 shadow-2xl relative">
              <WebPlayer src={activeStream} />
            </div>
            <div className="bg-[#151921] p-4 rounded-xl border border-slate-800 flex justify-between items-center">
              <div>
                <p className="text-xs text-blue-400 font-semibold tracking-wider uppercase">Active Stream Source</p>
                <p className="text-sm text-slate-200 font-mono mt-1">{activeStream}</p>
              </div>
              <span className="px-2.5 py-1 text-xs rounded bg-emerald-500/10 text-emerald-400 border border-emerald-500/20 font-medium">
                HLS Active
              </span>
            </div>
          </div>

          {/* Controller & Playlist Quick Panel */}
          <div className="col-span-12 lg:col-span-4 space-y-4">
            <div className="bg-[#151921] p-4 rounded-xl border border-slate-800">
              <h3 className="text-sm font-semibold text-white mb-3">Live Multi-Source Failovers</h3>
              <div className="space-y-2">
                {[
                  { name: 'Primary HLS Stream', url: 'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8' },
                  { name: 'Secondary Test Feed', url: 'https://playertest.longtailvideo.com/adaptive/oceans/oceans.m3u8' }
                ].map((stream, idx) => (
                  <button
                    key={idx}
                    onClick={() => setActiveStream(stream.url)}
                    className={`w-full p-3 rounded-lg text-left text-xs transition flex justify-between items-center ${
                      activeStream === stream.url
                        ? 'bg-blue-600/20 border border-blue-500/50 text-white'
                        : 'bg-slate-900/50 border border-slate-800 text-slate-400 hover:bg-slate-800'
                    }`}
                  >
                    <span className="font-medium">{stream.name}</span>
                    {activeStream === stream.url && <span className="text-[10px] bg-blue-500 px-1.5 py-0.5 rounded text-white">ONLINE</span>}
                  </button>
                ))}
              </div>
            </div>
          </div>
        </section>
      </main>
    </div>
  );
}
