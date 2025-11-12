import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_service.dart'; 

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService(); 

  String _message = 'Please sign in or register';
  bool _isError = false;

  Future<void> _signInOrRegister({required bool isRegister}) async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    User? user;

    setState(() {
      _message = 'Loading...';
      _isError = false;
    });

    if (isRegister) {
      user = await _authService.registerWithEmailAndPassword(email, password);
    } else {
      user = await _authService.signInWithEmailAndPassword(email, password);
    }

    if (user != null) {
      setState(() {
        _message = isRegister
            ? 'Registration successful! Signed in as ${user!.email}'
            : 'Successfully signed in as ${user!.email}';
        _isError = false;
      });
    } else {
      setState(() {
        _message = isRegister
            ? 'Registration Failed. Check console for details.'
            : 'Sign In Failed. Check credentials.';
        _isError = true;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Authentication'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Text(
                'Welcome!',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
                validator: (value) => (value?.isEmpty ?? true) ? 'Please enter your email' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
                validator: (value) => (value?.isEmpty ?? true) ? 'Please enter your password' : null,
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: () => _signInOrRegister(isRegister: false),
                icon: const Icon(Icons.login),
                label: const Text('Sign In'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 15),
              OutlinedButton.icon(
                onPressed: () => _signInOrRegister(isRegister: true),
                icon: const Icon(Icons.person_add),
                label: const Text('Register'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  side: const BorderSide(color: Colors.deepPurple),
                  foregroundColor: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 30),
              Text(
                _message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _isError ? Colors.red.shade700 : Colors.green.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
