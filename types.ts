export enum AppState {
  SPLASH = 'SPLASH',
  AUTH = 'AUTH',
  DASHBOARD = 'DASHBOARD',
  SCANNING = 'SCANNING',
  ANALYZING = 'ANALYZING',
  RESULTS = 'RESULTS',
}

export interface DietItem {
  item: string;
  reason: string;
}

export interface HealthReport {
  conditionName: string;
  riskLevel: 'Low' | 'Moderate' | 'High' | 'Critical';
  description: string;
  neuralBodyAnalysis: string;
  healthIssues: string[];
  precautions: string[];
  dietMenu: DietItem[];
}

export interface UserProfile {
  name?: string;
  age?: string;
  gender?: 'Male' | 'Female' | 'Other';
  phoneNumber: string;
}
