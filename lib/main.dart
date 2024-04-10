import 'package:flutter/material.dart';
import 'package:third_step/chat/all_chats.dart';
import 'package:third_step/chat/model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'chat/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ModelProvider(
      model: Model(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AllChats(),
      ),
    );
  }
}
