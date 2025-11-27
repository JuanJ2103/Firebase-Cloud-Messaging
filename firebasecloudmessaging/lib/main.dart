import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Necesario para manejar mensajes en background (solo Android/iOS)
  await Firebase.initializeApp();
  print("Mensaje recibido en background: ${message.notification?.title}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Firebase
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBN0Ueq3pvzOqM6It4jYTlgRAaaOhNNCRk",
      authDomain: "fir-cloud-messaging-91374.firebaseapp.com",
      projectId: "fir-cloud-messaging-91374",
      storageBucket: "fir-cloud-messaging-91374.firebasestorage.app",
      messagingSenderId: "824599449446",
      appId: "1:824599449446:web:a03c9c9794f2e981af82a7",
    ),
  );

  // Handler para mensajes en background (NO funciona en Web, pero es requerido)
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? token = "Obteniendo token...";

  @override
  void initState() {
    super.initState();
    setupFirebaseMessaging();
  }

  Future<void> setupFirebaseMessaging() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Solicitar permisos (Web + Android + iOS)
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print("Permisos: ${settings.authorizationStatus}");

    // Obtener token FCM
    String? newToken = await messaging.getToken();
    print("TOKEN FCM:" + newToken.toString());

    setState(() {
      token = newToken;
    });

    // Escuchar mensajes en FOREGROUND
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Mensaje en FOREGROUND:");
      print("Título: ${message.notification?.title}");
      print("Cuerpo: ${message.notification?.body}");
    });

    // Cuando el usuario hace clic en una notificación (background → app)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Notificación abierta: ${message.notification?.title}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("Firebase Cloud Messaging Web")),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: SelectableText(
              "TOKEN FCM:\n\n$token\n\nCópialo y úsalo en Postman o Firebase",
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }
}
