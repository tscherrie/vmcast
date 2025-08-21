## vmcast
Pro voice messenger for long-form, end-to-end encrypted voice messages with audiobook/podcast-grade playback and on-device AI (transcription, summaries, table of contents).

### Specs
See `SPECS.md` for the full product and technical specifications.

## Roadmap (dev phases)
- M1 — Local core
  - Recording/playback (reliable, background where allowed), local storage, delete
  - Basic UI: Contacts → VM List → VM Detail; Settings skeleton
- M2 — Transport + E2EE
  - Decentralized relays (store-and-forward), resumable media upload/download
  - libsignal (X3DH + Double Ratchet), encrypted receipts, push wake-ups
- M3 — On-device AI
  - Model manager; post-recording transcription (Whisper.cpp), FTS search
  - Summaries + LLM-first table of contents (Llama.cpp/MLC)
- M4 — UX polish
  - Mini-player, continuous play, iOS glass accents, Android dynamic color, accessibility
- M5 — Hardening
  - Storage warnings, relay redundancy, perf/thermal tuning, optional key export/import

## Developer setup
This repository uses Flutter for a shared codebase targeting Android and iOS. For day-to-day development:
- macOS: primary for iOS builds and Android emulation
- Windows: primary for Android builds; iOS testing via TestFlight/App Distribution (once CI is set up)

### Common prerequisites
- Git
- Flutter SDK (stable channel)
- Dart (bundled with Flutter)

#### Install Flutter
macOS (Homebrew):
```bash
brew install --cask flutter
flutter doctor
```

Windows:
1) Download Flutter for Windows (stable) and add `flutter\bin` to PATH.
2) In PowerShell:
```powershell
flutter doctor
```

### macOS setup (iOS dev/build)
Prerequisites:
- macOS 13+
- Xcode (latest stable)
- CocoaPods
- Android Studio (optional, for Android emulator)

Steps:
1) Install Xcode from App Store, then run:
```bash
xcode-select --install || true
sudo xcodebuild -runFirstLaunch
```
2) Accept licenses by opening Xcode once and launching a Simulator.
3) Install CocoaPods:
```bash
sudo gem install cocoapods || brew install cocoapods
```
4) Install Android tooling (optional):
```bash
brew install --cask android-studio
```
5) Clone and bootstrap:
```bash
git clone https://github.com/your-org/vmcast.git
cd vmcast
flutter pub get
flutter doctor -v
```
6) Run on iOS Simulator:
```bash
open -a Simulator
flutter devices
flutter run -d ios
```
7) Build iOS (for release later):
```bash
flutter build ios --release
```

### Windows setup (Android dev/build)
Prerequisites:
- Windows 10/11
- Android Studio (SDK, Platform-Tools, Emulator)
- Java JDK 17 (installed via Android Studio or separately)

Steps:
1) Install Android Studio and components (SDK Platforms, SDK Tools, AVD).
2) Ensure environment variables (if needed): `ANDROID_HOME` and add `platform-tools` to PATH.
3) Clone and bootstrap:
```powershell
git clone https://github.com/your-org/vmcast.git
cd vmcast
flutter pub get
flutter doctor -v
```
4) Create and launch an Android emulator, or connect a device with USB debugging.
5) Run on Android:
```powershell
flutter run -d emulator-5554
```
6) Build Android APK/AAB:
```powershell
flutter build apk --release
flutter build appbundle --release
```

### On-device AI models (local only)
- ASR (transcription): use Whisper.cpp models (e.g., tiny/base/small). Download from the official sources and place them under `assets/models/whisper/`. See [whisper.cpp releases](https://github.com/ggerganov/whisper.cpp).
- LLM (summary/ToC): use a small quantized model (e.g., 3–7B Q4). Place under `assets/models/llm/`. See [llama.cpp](https://github.com/ggerganov/llama.cpp) or [MLC LLM](https://github.com/mlc-ai/mlc-llm).
- The app will provide a model manager UI to download/verify models in-app (planned in M3).

Directory convention (planned):
```
assets/
  models/
    whisper/
      ggml-base.bin
    llm/
      model-q4_k_m.gguf
```

### Bootstrap relays
- The app ships with a hardcoded bootstrap list of public relays for easy onboarding (configurable later in Settings).
- Developers can override via an environment file (planned):
```
.env
RELAYS_DEFAULT=wss://relay1.example.org,wss://relay2.example.org
```

### Running tests (to be added)
- Unit tests: `flutter test`
- Integration tests: `flutter test integration_test`
- Golden tests and E2E: will be added alongside implementation milestones

### Troubleshooting
- If `flutter doctor` shows iOS toolchain issues, ensure Xcode Command Line Tools are selected in Preferences → Locations.
- For CocoaPods issues: run `pod repo update` inside the `ios` directory after `flutter clean`.
- On Windows, ensure Hyper-V/WSL is configured correctly if using certain emulator images.

## Contributing
- Please read `SPECS.md` before starting work. Align contributions with the current milestone.
- Use conventional commits and open small, focused PRs.

## License
TBD
