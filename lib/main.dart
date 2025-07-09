import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // 1. Impor Firebase Core
import 'firebase_options.dart'; // 2. Impor file konfigurasi
import 'login.dart'; // Ganti dengan halaman awal Anda

// 3. Ubah fungsi main menjadi async
Future<void> main() async {
  // 4. Pastikan semua widget binding sudah siap
  WidgetsFlutterBinding.ensureInitialized();

  // 5. Inisialisasi Firebase dan TUNGGU sampai selesai
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 6. Jalankan aplikasi Anda SETELAH Firebase siap
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firebase App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const LoginPage(), // Halaman awal Anda
    );
  }
}