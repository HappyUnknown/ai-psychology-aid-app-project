import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mental_health_app/firebase_options.dart';
import 'package:mental_health_app/main.dart';

class Environment {
  Environment() {
    _init();
  }

  Future<void> _init() async {
    print("hello");
    await WidgetsFlutterBinding.ensureInitialized();

    // FirebaseAuth.instance.authStateChanges().listen((User? user) {
    //   if (user == null) {
    //     print('User is currently signed out!');
    //   } else {
    //     print('User is signed in!');
    //   }
    // });
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

    } catch (e, stackrace) {
      print("Error: $e $stackrace");
       
    }

    runApp(ProviderScope(child: MyApp()));

  }
}
