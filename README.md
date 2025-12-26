# laza

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# LAZA - Flutter E-commerce App (Firebase)

## Project Overview
LAZA is a Flutter e-commerce mobile application built with Firebase:
- Authentication (Sign Up / Login / Forgot Password) using Firebase Auth
- Products + Product Details
- Reviews (Firestore: products/{productId}/reviews)
- Cart (Firestore under user)
- Favorites (Firestore under user)
- Payment Cards (Firestore under user)
- Basic UI similar to the provided design screens

---

## How to Install Flutter & Project Dependencies

### 1) Install Flutter
Install Flutter from official docs:
- https://docs.flutter.dev/get-started/install

Verify installation:
```bash
flutter --version
flutter doctor

## 2) Install dependencies

flutter pub get

## 3) Clean and Run
flutter clean
flutter pub get
flutter run