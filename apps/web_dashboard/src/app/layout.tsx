import React from 'react';
import './globals.css';

export const metadata = {
  title: 'IPTV Smart Platform Engine',
  description: 'Next-Gen Multi-Room IPTV Sync Controller & Web Player',
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en" className="dark">
      <body className="bg-[#0B0E14] text-slate-100 antialiased min-h-screen selection:bg-blue-600 selection:text-white">
        {children}
      </body>
    </html>
  );
}
