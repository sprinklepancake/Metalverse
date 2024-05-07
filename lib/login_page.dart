import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proj_mobile_flutter/auth.dart';
import 'package:proj_mobile_flutter/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  //controllers to handle user credentials
  bool isLogin = true;
  final Auth auth = Auth();
  String? _errorMsg = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isLogin ? 'Log In' : 'Sign Up', //if is not logged in then take to sign up page
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            shadows: [
              Shadow(
                offset: Offset(1.0, 1.0),
                blurRadius: 2.0,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ],
          ),
        ),
        backgroundColor: const Color(0xFF8B0000), 
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF212121), 
              Color(0xFF1a1a1a), 
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  isLogin ? "Login" : "Sign Up",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    shadows: [
                      Shadow(
                        offset: Offset(1.0, 1.0),
                        blurRadius: 2.0,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  _errorMsg!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
              Visibility(
                visible: !isLogin, // Show username field only during signup, (when the user is in the login page, islogin is true, so visible is false. when user is in sign up page, islogin is false, so visible is true)
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    style: const TextStyle(color: Colors.white),
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Username',
                      hintStyle: TextStyle(color: Colors.white), 
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  style: const TextStyle(color: Colors.white),
                  controller: _emailController,
                  decoration: const InputDecoration(
                    
                    border: OutlineInputBorder(),
                    hintText: 'Email',
                    hintStyle: TextStyle(color: Colors.white), 
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white), 
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white), 
                    ),
                  ),
                ),

              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  style: const TextStyle(color: Colors.white),
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Password',
                    hintStyle: TextStyle(color: Colors.white), 
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //the next  buttons check what state we are in now (login or signup and then function accordingly)
                  ElevatedButton(
                    onPressed: () async {
                      isLogin ? await _login() : await _signup();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(isLogin ? "Login" : "Signup"),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8B0000).withOpacity(0.5),
                    ),

                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() => isLogin = !isLogin);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        isLogin ? 'Sign Up' : 'Log In',
                        style: const TextStyle(
                            color: Colors.blue, decoration: TextDecoration.underline),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    try {
      if (isLogin) {
        // Login (username not required)
        await auth.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
      } else {
        throw Exception("Unexpected state during login");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        setState(() => _errorMsg = "user not found");
      } else if (e.code == 'wrong-password') {
        setState(() => _errorMsg = "wrong password");
      } else {
        setState(() => _errorMsg = e.message);
      }
      _emailController.clear();
      _passwordController.clear();
    }
  }

  Future<void> _signup() async {
    try{
      await auth.createUserWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text, username: _usernameController.text);

      setState(() => isLogin = true);

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Signup successful"),
        duration: Duration(seconds: 3),
      ));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        setState(() {
          _errorMsg = "password too weak";
          _passwordController.clear();
          _emailController.clear();
        });
      } else if (e.code == 'email-already-in-use') {
        setState(() {
          _errorMsg = "email already in use";
          _passwordController.clear();
          _emailController.clear();
        });
      } else {
        setState(() => _errorMsg = e.message);
      }
    }
  }
}
