import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gap/gap.dart';
import 'package:shopping_list/models/auth.dart';

class AuthScreen extends StatefulWidget {
  AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();

  String? errorMesage = '';

  bool isLogin = true;

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  Future<void> signInWithEmailAndPassword() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    try {
      await Auth().signInWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);
    } on FirebaseAuthException catch (e) {
      // Handle other authentication errors
      if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
        scaffoldMessenger.showSnackBar(
          const SnackBar(
            backgroundColor: Colors.amberAccent,
            content: Text('No such user exists for this email.'),
          ),
        );
      }
      print(e.message);
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    try {
      await Auth().createUserWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMesage = e.message;
      });
      scaffoldMessenger.clearSnackBars;
      scaffoldMessenger.showSnackBar(
        SnackBar(
          backgroundColor: Colors.amberAccent,
          content: Text(errorMesage ?? 'Authentication Failed'),
        ),
      );
      print(errorMesage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to the \n Shopping List',
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const Gap(20),
            ListTile(
              leading: const Icon(CupertinoIcons.person),
              title: TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Enter your email address',
                ),
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                textCapitalization: TextCapitalization.none,
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty ||
                      !value.contains('@')) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
                onSaved: (newValue) {
                  _emailController.text = newValue!;
                },
              ),
            ),
            ListTile(
              leading: const Icon(CupertinoIcons.lock),
              title: TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Enter you password',
                ),
                controller: _passwordController,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.trim().length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
                onSaved: (newValue) {
                  _passwordController.text = newValue!;
                },
              ),
            ),
            const Gap(20),
            Platform.isIOS
                ? CupertinoButton.filled(
                    onPressed: isLogin
                        ? signInWithEmailAndPassword
                        : createUserWithEmailAndPassword,
                    child: Text(
                      isLogin ? 'Login' : 'Sign up',
                      style: const TextStyle(fontSize: 18),
                    ),
                  )
                : ElevatedButton(
                    onPressed: isLogin
                        ? signInWithEmailAndPassword
                        : createUserWithEmailAndPassword,
                    child: Text(
                      isLogin ? 'Login' : 'Sign up',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
            const Gap(20),
            Platform.isIOS
                ? CupertinoButton(
                    child: Text(isLogin
                        ? 'Create an account'
                        : 'Already have an account? Log in.'),
                    onPressed: () {
                      setState(
                        () {
                          isLogin = !isLogin;
                        },
                      );
                    },
                  )
                : TextButton(
                    onPressed: () {
                      setState(() {
                        isLogin = !isLogin;
                      });
                    },
                    child: Text(isLogin
                        ? 'Create an account'
                        : 'Already have an account? Log in.'),
                  )
          ],
        ),
      ),
    );
  }
}
