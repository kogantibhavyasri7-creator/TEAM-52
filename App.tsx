import React, { useState, useEffect } from 'react';
import { AppState, HealthReport, UserProfile } from './types';
import AuthScreen from './components/AuthScreen';
import CameraScanner from './components/CameraScanner';
import ResultsView from './components/ResultsView';
import { analyzeEyeScan } from './services/geminiService';

const App: React.FC = () => {
  const [appState, setAppState] = useState<AppState>(AppState.SPLASH);
  const [userProfile, setUserProfile] = useState<UserProfile | null>(null);
  const [scannedImage, setScannedImage] = useState<string | null>(null);
  const [report, setReport] = useState<HealthReport | null>(null);

  useEffect(() => {
    // Simulate Splash Screen
    const timer = setTimeout(() => {
      setAppState(AppState.AUTH);
    }, 2500);
    return () => clearTimeout(timer);
  }, []);

  const handleAuthComplete = (profile: UserProfile) => {
    setUserProfile(profile);
    setAppState(AppState.DASHBOARD);
  };

  const startScan = () => {
    setAppState(AppState.SCANNING);
  };

  const handleCapture = async (imageSrc: string) => {
    setScannedImage(imageSrc);
    setAppState(AppState.ANALYZING);
    
    // Call Gemini API with user profile
    const result = await analyzeEyeScan(imageSrc, userProfile);
    setReport(result);
    setAppState(AppState.RESULTS);
  };

  const handleReset = () => {
    setScannedImage(null);
    setReport(null);
    setAppState(AppState.DASHBOARD);
  };

  // Render Logic based on State
  if (appState === AppState.SPLASH) {
    return (
      <div className="flex flex-col items-center justify-center min-h-screen bg-slate-900 animate-pulse">
        <div className="w-24 h-24 bg-blue-500 rounded-full flex items-center justify-center shadow-[0_0_30px_rgba(59,130,246,0.5)]">
          <svg xmlns="http://www.w3.org/2000/svg" className="h-12 w-12 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.5} d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.5} d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
          </svg>
        </div>
        <h1 className="mt-6 text-2xl font-bold text-white tracking-wider">BE HEALTHY WITH AI</h1>
        <p className="text-blue-400 text-sm tracking-widest mt-2 uppercase">System Initializing...</p>
      </div>
    );
  }

  if (appState === AppState.AUTH) {
    return <AuthScreen onComplete={handleAuthComplete} />;
  }

  if (appState === AppState.DASHBOARD) {
    return (
      <div className="flex flex-col min-h-screen p-6 relative overflow-hidden">
        {/* Decorative Background */}
        <div className="absolute top-0 right-0 w-64 h-64 bg-blue-600/10 rounded-full blur-3xl -translate-y-1/2 translate-x-1/2 pointer-events-none"></div>
        <div className="absolute bottom-0 left-0 w-64 h-64 bg-purple-600/10 rounded-full blur-3xl translate-y-1/2 -translate-x-1/2 pointer-events-none"></div>

        <header className="flex justify-between items-center mb-10">
          <div>
            <h1 className="text-xl font-bold text-white">Hello, {userProfile?.name?.split(' ')[0] || 'User'}</h1>
            <p className="text-slate-400 text-sm">ID: {userProfile?.phoneNumber.slice(-4) || '####'}</p>
          </div>
          <div className="w-10 h-10 rounded-full bg-slate-800 border border-slate-700 flex items-center justify-center">
            <span className="text-slate-300 text-xs font-bold">
              {userProfile?.gender === 'Female' ? 'F' : userProfile?.gender === 'Male' ? 'M' : 'AI'}
            </span>
          </div>
        </header>

        <main className="flex-1 flex flex-col justify-center">
          <div className="bg-slate-800/50 backdrop-blur-lg border border-slate-700 p-6 rounded-2xl mb-8">
            <div className="flex items-center space-x-4 mb-4">
              <div className="p-3 bg-blue-500/20 rounded-lg">
                <svg className="w-6 h-6 text-blue-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" /></svg>
              </div>
              <div>
                <h3 className="text-white font-semibold">Ready to Scan</h3>
                <p className="text-slate-400 text-xs">Ensure good lighting for accurate neural analysis.</p>
              </div>
            </div>
          </div>

          <div className="text-center mb-8">
            <h2 className="text-2xl font-bold text-white mb-2">Biometric Scan</h2>
            <p className="text-slate-400 text-sm max-w-xs mx-auto">
              We analyze retinal patterns to generate a neural network prototype of your current health status.
            </p>
          </div>

          <button
            onClick={startScan}
            className="group relative w-full bg-gradient-to-r from-blue-600 to-indigo-600 text-white font-bold py-4 rounded-xl shadow-xl shadow-blue-600/20 overflow-hidden transform transition-all active:scale-95"
          >
            <div className="absolute inset-0 bg-white/20 group-hover:translate-x-full transition-transform duration-500 ease-in-out -skew-x-12 origin-left"></div>
            <span className="relative flex items-center justify-center gap-2">
              <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M3 9a2 2 0 012-2h.93a2 2 0 001.664-.89l.812-1.22A2 2 0 0110.07 4h3.86a2 2 0 011.664.89l.812 1.22A2 2 0 0018.07 7H19a2 2 0 012 2v9a2 2 0 01-2 2H5a2 2 0 01-2-2V9z" /><path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 13a3 3 0 11-6 0 3 3 0 016 0z" /></svg>
              START DIAGNOSIS
            </span>
          </button>
        </main>
      </div>
    );
  }

  if (appState === AppState.SCANNING) {
    return (
      <CameraScanner 
        onCapture={handleCapture} 
        onCancel={() => setAppState(AppState.DASHBOARD)} 
      />
    );
  }

  if (appState === AppState.ANALYZING) {
    return (
      <div className="flex flex-col items-center justify-center min-h-screen bg-black">
        <div className="relative w-32 h-32">
          <div className="absolute inset-0 border-4 border-slate-800 rounded-full"></div>
          <div className="absolute inset-0 border-4 border-t-blue-500 rounded-full animate-spin"></div>
          <div className="absolute inset-4 rounded-full bg-slate-900 flex items-center justify-center overflow-hidden">
             {scannedImage && (
               <img src={scannedImage} alt="Scanning" className="w-full h-full object-cover opacity-50" />
             )}
          </div>
        </div>
        <h2 className="text-white text-xl font-bold mt-8 animate-pulse">Analyzing Neural Patterns</h2>
        <p className="text-slate-400 text-sm mt-2">Connecting to diagnostic mainframe...</p>
        
        <div className="w-64 mt-8 bg-slate-800 rounded-full h-2 overflow-hidden">
          <div className="h-full bg-blue-500 animate-[width_2s_ease-in-out_infinite] w-full origin-left"></div>
        </div>
      </div>
    );
  }

  if (appState === AppState.RESULTS && report && scannedImage) {
    return (
      <ResultsView 
        report={report} 
        imageSrc={scannedImage} 
        onReset={handleReset} 
      />
    );
  }

  return null;
};

export default App;