# Wisp

Ambient presence app for iOS — share your vibe with close friends via home screen widgets. No messages, no feeds, no notifications. Just a quiet sense of presence.

**Stack:** SwiftUI (iOS 17+) · Supabase (Auth, DB, Realtime, Storage) · WidgetKit

## Features

- **Aura gradients** — 15 animated palettes that represent your current mood
- **Vibe sharing** — set an emoji, text, or photo status visible only to bonded friends
- **Home screen widgets** — small and lock screen widgets that update in real time
- **Social battery** — share how social you're feeling without saying a word
- **Bonding** — connect with friends via QR code or shareable link
- **Targeting** — choose which friends see each vibe

## Setup

1. Clone the repo
2. Copy `Secrets.xcconfig.example` → `Secrets.xcconfig` and fill in your Supabase project URL and anon key
3. Run `xcodegen generate`
4. Open `Wisp.xcodeproj` in Xcode and build

> Get your Supabase credentials from your project dashboard under **Settings → API**.
