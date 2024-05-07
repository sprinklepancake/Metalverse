import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart'; 
import 'home_page.dart'; 
import 'login_page.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> authStateChanges() => _auth.authStateChanges();



  Future<UserCredential?> signInWithEmailAndPassword(String email, String password) async {
    try { 
      final credential = await _auth.signInWithEmailAndPassword(  //using the auth.dart file methods we handle the sign in
        email: email,
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for the provided email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for the email.');
      } else {
      }
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AuthService _authService = AuthService();

  MyApp({super.key}); 

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Metal Music Genres',
      routes: {
        '/': (context) => Provider<AuthService>(
              create: (_) => _authService,
              child: const MaterialAppShell(), 
            ),
        '/login': (context) => const LoginPage(),
      },
    );
  }
}

class MaterialAppShell extends StatelessWidget {
  const MaterialAppShell({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    if (user != null) {
      // User is signed in, show HomePage
      return const HomePage();
    } else {
      // User is not signed in, show LoginPage
      return const LoginPage();
    }
  }
}
