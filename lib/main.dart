import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'models/article.dart';
import 'services/news_service.dart';
import 'screen/detail_screen.dart';
import 'screen/berita_screen.dart';
import 'screen/login_screen.dart';
import 'screen/register_screen.dart';
import 'screen/reset_password_screen.dart';
import 'screen/saved_screen.dart';
import 'firebase_options.dart';

void main() async {
  // Inisialisasi Flutter & Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Inisialisasi Hive untuk penyimpanan lokal
  await Hive.initFlutter();
  Hive.registerAdapter(ArticleAdapter());
  await Hive.openBox<Article>('saved_news');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NewsApp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: false,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.lightBlueAccent,
          foregroundColor: Colors.white,
        ),
      ),

      // Daftar rute halaman
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/reset-password': (context) => const ResetPasswordScreen(),
        '/home': (context) => const BeritaScreen(),
        '/saved': (context) => const SavedScreen(),
      },

      // Cek status login: jika login tampilkan berita, jika tidak login tampilkan halaman login
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            return const BeritaScreen(); // Sudah login
          } else {
            return const LoginScreen(); // Belum login
          }
        },
      ),
    );
  }
}
