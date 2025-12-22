EyeScan Prototype app
A research-only prototype that explores eye-region imaging and machine learning to generate educational health insights. It includes a simple mobile sign-in, a “continue” bar, and a camera-based eye capture flow. It does not diagnose, treat, or prescribe. Always consult qualified healthcare professionals.

Project overview
- Purpose: Educational demo of a pipeline that captures eye images, runs a neural model, and presents non-diagnostic insights with general precautions.
- Frontend: App icon tap shows a popup, mobile number sign-in, onboarding completion with a “Continue” action bar.
- Backend: Camera capture, preprocessing, inference on a neural network, explanation UI with general, non-diagnostic health information and early precaution guidance.
- Status: Prototype; not medically validated. For research, UX exploration, and ML experimentation only.

Features
- Popup launcher: Tap the app icon to open a lightweight popup with sign-in.
- Mobile sign-in: OTP-based mobile number authentication.
- Onboarding + continue: After signup, a persistent “Continue” bar advances to capture flow.
- Camera eye capture: Guides the user to align eyes; captures frames securely.
- ML inference: Runs a local or server-side model to produce risk flags and explanations.
- Insights & precautions: Presents general health insights, risk levels, and non-diagnostic precautions.
- Privacy-first: Local processing option, opt-in consent, data minimization, and deletion.

Strict disclaimer
- Not a medical device: This app does not diagnose, treat, or provide medical advice.
- Educational insights only: Outputs are experimental and may be inaccurate.
- Professional care: If you have any health concerns, speak with a qualified clinician.
- Consent required: Users must opt in to capture, processing, and storage.

Architecture
App Icon → Popup (Sign-In) → Onboarding → Continue Bar → Camera Capture
           ↓
         Auth API (OTP) → User Store
           ↓
      Capture Service → Preprocessing (face/eye ROI, quality checks)
           ↓
      ML Inference (eye images → embeddings → classifier)
           ↓
      Insights Service (risk flags + explanations + general precautions)
           ↓
      UI Presentation (cards, levels, guidance)
           ↓
      Audit & Privacy (consent logs, data retention, deletion)



Tech stack
- Frontend (mobile/web): React Native or Flutter; alternative: React + Vite (web PWA)
- UI libraries: Material UI (web) or Cupertino/Material (mobile)
- Auth: OTP via Firebase Auth or custom SMS provider
- Camera: React Native Vision Camera / Flutter camera / Web MediaDevices API
- Backend: Node.js (NestJS/Express) or Python (FastAPI)
- Model: PyTorch or TensorFlow; ONNX for cross-runtime deployment
- Storage: Postgres for users/consent; S3-compatible object store for images (optional)
- Security: JWT, HTTPS, CSP, encrypted at rest, role-based access

Data flow
- Consent: User accepts terms and capture consent.
- Auth: Mobile number → OTP → JWT issued.
- Capture: Guide alignment; capture multiple frames; quality scoring.
- Preprocess: Face/eye detection, glare and focus checks, normalization.
- Inference: Send processed ROI to model; get risk scores and explanations.
- Present: Show cards: “Risk flags,” “Confidence,” “What this means,” “General precautions.”
- Actions: Save result locally, opt-in cloud sync, or delete data.
- Follow-up: Provide information on seeking professional care.

Frontend structure
frontend/
  src/
    components/
      AppIconPopup.tsx
      MobileSignin.tsx
      ContinueBar.tsx
      CameraCapture.tsx
      InsightsCards.tsx
      ConsentModal.tsx
    screens/
      SigninScreen.tsx
      CaptureScreen.tsx
      InsightsScreen.tsx
    services/
      api.ts
      auth.ts
      camera.ts
    utils/
      validators.ts
      accessibility.ts


- AppIconPopup: Lightweight overlay to launch sign-in.
- MobileSignin: Mobile number + OTP; validation and error handling.
- ContinueBar: Sticky action to proceed after onboarding.
- CameraCapture: Live preview, alignment guides, multi-frame capture.
- InsightsCards: Risk flag cards with explanations and general precautions.
- ConsentModal: Terms, privacy, and explicit consent.

Backend structure
backend/
  src/
    api/
      auth.controller.ts
      capture.controller.ts
      insights.controller.ts
    services/
      otp.service.ts
      storage.service.ts
      preprocess.service.ts
      inference.service.ts
      insights.service.ts
      privacy.service.ts
    models/
      user.entity.ts
      consent.entity.ts
      session.entity.ts
    ml/
      onnx_runner.ts
      postprocessing.ts
    config/
      env.ts
      security.ts


- Auth controller: OTP request/verify; JWT issuance.
- Capture controller: Receives images; validates consent; stores or discards.
- Inference service: Runs model (local or remote), returns scores.
- Insights service: Converts scores to human-readable, non-diagnostic insights.
- Privacy service: Data retention, deletion, audit logs.

API endpoints
POST /auth/request-otp
Body: { "mobile": "+91XXXXXXXXXX" }

POST /auth/verify-otp
Body: { "mobile": "+91XXXXXXXXXX", "otp": "123456" }
Returns: { "token": "JWT..." }

POST /capture
Headers: Authorization: Bearer <token>
Body: { "sessionId": "...", "images": [base64...] }

POST /inference
Headers: Authorization: Bearer <token>
Body: { "sessionId": "...", "roi": [ { "eye": "left", "image": "..." }, { "eye": "right", "image": "..." } ] }

GET /insights/:sessionId
Headers: Authorization: Bearer <token>
Returns: { "flags": [...], "precautions": [...], "confidence": 0.78, "notes": "..." }

DELETE /sessions/:sessionId
Headers: Authorization: Bearer <token>



Sample payloads and responses
// Request: /capture
{
  "sessionId": "sess_2025_12_22_1349",
  "images": ["data:image/jpeg;base64,/9j/4AAQ...", "data:image/jpeg;base64,/9j/7Q..."]
}


// Response: /insights/:sessionId
{
  "flags": [
    { "label": "Dry eye risk", "level": "moderate", "explanation": "Patterns consistent with dryness; lighting and screen-time may contribute." },
    { "label": "Fatigue indicator", "level": "low", "explanation": "Subtle vascular cues may correlate with general tiredness." }
  ],
  "precautions": [
    "Follow the 20-20-20 rule for screens.",
    "Ensure adequate hydration and sleep.",
    "Consider scheduling a comprehensive eye exam with a professional."
  ],
  "confidence": 0.72,
  "notes": "This is experimental and not a diagnosis."
}



ML model notes
- Input: Cropped eye ROI images RGB,224×224, normalized.
- Pipeline:
- Detection: Face/eye landmarks (e.g., MediaPipe or Dlib alternatives).
- Quality checks: Focus, glare, occlusion, eyelid coverage thresholds.
- Feature extraction: CNN encoder → embeddings.
- Classification: Risk flags (multi-label) with calibrated confidence.
- Explainability: Grad-CAM or saliency maps rendered server-side.
- Deployment: ONNX Runtime or TensorRT for inference; batch or streaming.

Precautions content policy
- General only: Provide hygiene, ergonomics, environment, and lifestyle tips (hydration, sleep, screen breaks).
- No medical advice: Avoid personalized treatment, medications, dosages, or diagnostic claims.
- Escalation guidance: Encourage users to seek professional evaluation for concerns or symptoms.

Installation
Prerequisites
- Node.js 18+, npm or pnpm
- Python 3.10+ (if using Python inference service)
- Postgres 13+ (or SQLite for local dev)
- Android Studio/Xcode (for mobile builds)
Setup steps
- Clone repository
- git clone https://github.com/your-org/eyescan-prototype.git
- cd eyescan-prototype
- Environment variables
- Create .env files in frontend and backend:
- Frontend: API_BASE_URL, OTP_PROVIDER_KEY
- Backend: DATABASE_URL, JWT_SECRET, STORAGE_BUCKET, OTP_PROVIDER_KEY, PRIVACY_RETENTION_DAYS
- Install dependencies
- Frontend: npm install
- Backend: npm install (Node) or pip install -r requirements.txt (Python)
- Run dev servers
- Frontend: npm run dev
- Backend (Node): npm run start:dev
- Backend (Python): uvicorn app:api --reload
- Mobile build (optional)
- Android: npm run android
- iOS: npm run ios

Usage
- Launch app icon → popup appears.
- Enter mobile number → receive OTP → sign in.
- Complete onboarding → tap Continue bar.
- Consent to capture → align eyes using on-screen guides → capture frames.
- View insights → review flags, confidence, and general precautions.
- Manage data → save locally, opt-in sync, or delete session.

UI/UX guidelines
- Accessibility: High-contrast guides, screen-reader labels, large tap targets.
- Capture flow: Live stability indicator, glare warnings, “retake” option.
- Transparency: Clear labeling: “Experimental, not diagnostic.”
- Localization: Support regional formats and languages (e.g., English, Telugu).
- Performance: Debounced camera capture, background upload, low-power mode.

Security and privacy
- Consent-first: No capture or processing without explicit consent.
- Minimization: Store only what’s necessary; allow local-only mode.
- Encryption: TLS in transit; encrypted storage at rest.
- Access control: JWT tokens, role-based permissions, audit logs.
- Deletion: One-tap session deletion; verifiable purge from storage.

Ethics and compliance
- Bias assessment: Test across diverse demographics; document limitations.
- Human-in-the-loop: Encourage professional review for concerns.
- Regulatory awareness: Align with regional privacy laws; avoid medical claims.
- Transparency: Explain model confidence and uncertainty.

Roadmap
- Short-term:
- Improved eye ROI detection and quality scoring
- Better confidence calibration
- Local-only inference mode
- Mid-term:
- Federated learning experiments (opt-in)
- Explainability overlays in UI
- Multi-language content expansion
- Long-term:
- Formal clinical validation studies (with IRB/ethics approvals)
- Device-grade security hardening
- Robust accessibility improvements

Development scripts
{
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "preview": "vite preview",
    "start:dev": "nest start --watch",
    "start": "node dist/main.js",
    "lint": "eslint .",
    "test": "jest"
  }
}



Contributing
- Issues and PRs: Welcome for UX, privacy, and ML performance improvements.
- Coding standards: Prettier + ESLint, conventional commits, CI tests.
- Documentation: Update README and in-code comments for any changes.

License
- Research-only license: Not for clinical use. See LICENSE for details.

Acknowledgments
- Community and open-source tools that make rapid prototyping possible.
- Users and testers who provide feedback to improve safety and clarity.

Quick start checklist
- Set .env files
- Enable OTP provider
- Run backend + frontend
- Test capture flow with consent
- Verify insights cards show general precautions
- Validate deletion and privacy controls

