import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

FirebaseOptions get firebaseOptions => FirebaseOptions(
  apiKey: dotenv.env['API_KEY'] ?? "YOUR_API_KEY",
  authDomain: dotenv.env['AUTH_DOMAIN'] ?? "YOUR_AUTH_DOMAIN",
  projectId: dotenv.env['PROJECT_ID'] ?? "YOUR_PROJECT_ID",
  storageBucket: dotenv.env['STORAGE_BUCKET'] ?? "YOUR_STORAGE_BUCKET",
  messagingSenderId: dotenv.env['MESSAGING_SENDER_ID'] ?? "YOUR_MESSAGING_SENDER_ID",
  appId: dotenv.env['APP_ID'] ?? "YOUR_APP_ID",
  measurementId: dotenv.env['MEASUREMENT_ID'] ?? "YOUR_MEASUREMENT_ID",
);