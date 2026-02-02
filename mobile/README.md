# KickStream Mobile

A Flutter mobile application for KickStream, using state-of-the-art techniques.

## Features

- **State Management**: Riverpod for reactive state management
- **Routing**: GoRouter for declarative routing
- **API Communication**: OpenAPI generated client for seamless backend integration
- **Modern UI**: Material Design 3
- **Secure Storage**: For tokens and sensitive data

## Setup

1. Ensure the NestJS backend is running on `http://localhost:3003`
2. Run `flutter pub get` to install dependencies
3. Generate API client: `generate_api.bat` (requires backend running)
4. Run `flutter pub run build_runner build` to generate model serializers
5. Run `flutter run` to start the app

## Architecture

- `lib/api/`: Generated OpenAPI client
- `lib/providers/`: Riverpod providers for state and APIs
- `lib/screens/`: UI screens
- `lib/main.dart`: App entry point with routing

## State-of-the-Art Techniques Used

- **Riverpod**: For dependency injection and state management
- **GoRouter**: For type-safe routing
- **OpenAPI Generator**: For automatic API client generation
- **Built Value**: For immutable models with serialization
- **Material 3**: For modern UI design
- **Dio**: For HTTP requests with interceptors
