import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:portfolio/page/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyD6lZiWJA6qP-ZsWQ6PZXoVSj-ZhPFfOV4",
      authDomain: "dung-sportfolio.firebaseapp.com",
      projectId: "dung-sportfolio",
      storageBucket: "dung-sportfolio.appspot.com",
      messagingSenderId: "374081632563",
      appId: "1:374081632563:web:73a6cf49f1b30c89db2646",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      builder: EasyLoading.init(),
    );
  }
}
