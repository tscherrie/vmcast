# vmcast
pro voice messenger

## Overview
vmcast is a privacy-first long-form voice messenger with a playback experience similar to audiobook/podcast players. Messages are end-to-end encrypted and delivered via decentralized store-and-forward relays. Transcription, summaries, and a timestamped table of contents are generated entirely on-device.

## Roadmap (milestones)
- M1: Local core
  - Recording/playback (up to 90 min), local storage, delete, basic UI, Settings skeleton
  - Acceptance: record, save, play back; survive lock/interruptions where OS allows
- M2: Transport + E2EE
  - libsignal sessions (X3DH + Double Ratchet), encrypted envelopes, media upload/download via relays, delivered/listened receipts, push wake-up
  - Acceptance: send/receive between two devices, receipts update correctly, privacy-preserving push
- M3: On-device AI
  - Model manager, post-recording transcription (language auto-detect), FTS search, LLM summaries, LLM-first Table of Contents (jump-to)
  - Acceptance: transcripts visible and searchable; summary/ToC generated locally
- M4: UX polish
  - Mini-player, continuous play, Material 3 polish (iOS uses native patterns where beneficial), accessibility
  - Acceptance: seamless navigation, consistent controls, accessible labels
- M5: Hardening
  - Storage warnings, relay redundancy, performance/thermal tuning, optional key export/import
  - Acceptance: stable under load, graceful low-storage handling

## High-level development TODOs
- App core and UI
  - Contacts → VM List → VM Detail navigation; mini-player; recorder screen
  - Global playback speed, ±10s skip, simple seek bar, continuous play
- Crypto and transport
  - libsignal integration; encrypted envelopes; receipts; push wake-up
  - Relay client: resumable chunked uploads/downloads, outbox retry/backoff
  - Bootstrap default relay list; relay settings per contact
- Data and search
  - SQLite + FTS5 for transcripts; content-addressed audio storage
  - Indexing pipeline and background jobs
- On-device AI
  - Model manager (download/verify/manage); Whisper.cpp ASR; LLM summaries/ToC
  - LLM-first ToC generation aligned to ASR timestamps
- Settings and privacy
  - Backup opt-in, listened receipts toggle, auto-transcribe options, storage usage

## Tester setup (iOS)
Prerequisites
- iPhone/iPad running a supported iOS version (TBD), TestFlight installed
- Stable Wi‑Fi and sufficient free storage (models can be hundreds of MB)

Install
1) Join TestFlight: use the public invite link (to be provided)
2) Install vmcast via TestFlight and accept required permissions

First run
1) Grant microphone and notifications permissions when prompted
2) Download AI models in Settings → AI Models
   - Recommended: Whisper base/small (ASR) and a small local LLM (e.g., 3–7B quantized)
3) Relays are preconfigured with a bootstrap list; optionally add/remove in Settings → Relays
4) Create your username and share QR with a tester partner to add each other

What to test
- Recording reliability up to 90 minutes; resume after brief interruptions/lock
- Sending/receiving; delivered/listened receipts; push notifications with privacy-preserving content
- Post-recording transcription; confirm language detection; search across transcripts (global and per-thread)
- Summary and Table of Contents generation; tap ToC items to jump playback
- Storage usage view and low-storage warnings (if applicable)

## Tester setup (Android)
Prerequisites
- Android phone/tablet on a supported version (TBD), Google Play services

Install
1) Join Google Play testing track: internal/closed testing link (to be provided)
2) Install vmcast from Play, accept required permissions

First run
1) Grant microphone and notifications permissions when prompted
2) Download AI models in Settings → AI Models (Whisper + small LLM)
3) Relays are preconfigured with a bootstrap list; optionally add/remove in Settings → Relays
4) Create your username and share QR with a tester partner to add each other

What to test
- Same scenarios as iOS; also validate Material 3 polish and device-specific behavior

## Reporting bugs and feedback
- Please file issues with device model, OS version, app build number, and reproduction steps
- Attach logs if prompted in-app; note whether AI models were downloaded and which sizes

## Privacy notes for testers
- All audio and status messages are end-to-end encrypted
- AI runs on-device; no cloud AI services are used
- No contact book access in MVP; contacts are added via username/QR

## Build/install from source (early adopters)
- Instructions will be added once public source is available (Flutter, iOS/Android toolchains)