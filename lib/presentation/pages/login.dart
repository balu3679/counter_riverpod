import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:messenger/domain/utils/alerts.dart';
import 'package:messenger/presentation/pages/home.dart';
import 'package:messenger/presentation/pages/signup.dart';
import '../providers/auth_providers.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final formkey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isloading = false;
  bool isobsure = true;

  Future<void> login() async {
    if (!(formkey.currentState!.validate())) return;
    final loginUseCase = ref.read(loginUseCaseProvider);
    FocusScope.of(context).unfocus();
    setState(() {
      isloading = true;
    });
    try {
      final user = await loginUseCase(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      if (user == null) {
        Constants.showtoast(context, message: 'Login Failed');
      } else {
        Constants.showtoast(context, message: 'Login Successfully');
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomePage()));
      }
    } catch (e) {
      Constants.showtoast(context, message: '$e');
    } finally {
      setState(() {
        isloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        bool resp = await Constants.showalert(
          context,
          title: 'Exit App ?',
          subtitle: 'Are you sure want to exit',
        );
        if (resp) {
          exit(0);
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Login')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: formkey,
            child: Column(
              children: [
                TextFormField(
                  controller: _emailController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Email Id required';
                    }
                    if (!value.contains('@')) {
                      return 'Invalid Email id';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isobsure = !isobsure;
                        });
                      },
                      icon: Icon(isobsure ? Icons.visibility_off_outlined : Icons.visibility),
                    ),
                  ),
                  obscureText: isobsure,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Password is required';
                    }
                    if (value.length < 6) {
                      return 'Password must be min 6 digit';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                isloading
                    ? Center(child: CircularProgressIndicator())
                    : FilledButton(onPressed: login, child: const Text('Login')),
                TextButton(
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    Navigator.push(context, MaterialPageRoute(builder: (_) => SignUpPage()));
                  },
                  child: const Text('Create an account'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
