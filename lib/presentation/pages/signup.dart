import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:messenger/domain/utils/alerts.dart';
import '../providers/auth_providers.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final formkey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _cpasswordController = TextEditingController();

  bool isloading = false;
  bool isobsure1 = true;
  bool isobsure2 = true;

  void toggle(int id) {
    if (id == 1) {
      isobsure1 = !isobsure1;
    } else {
      isobsure2 = !isobsure2;
    }
    setState(() {});
  }

  Future<void> signUp() async {
    if (!(formkey.currentState!.validate())) return;
    FocusScope.of(context).unfocus();
    setState(() {
      isloading = true;
    });

    final signUpUseCase = ref.read(signUpUseCaseProvider);
    try {
      final user = await signUpUseCase(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (user == null) {
        Constants.showtoast(context, message: 'Sign Up Failed');
      } else {
        Constants.showtoast(context, message: 'SignUp Successfully');
        Navigator.pop(context);
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
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formkey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: TextFormField(
                  controller: _passwordController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isobsure1 = !isobsure1;
                        });
                      },
                      icon: Icon(isobsure1 ? Icons.visibility_off_outlined : Icons.visibility),
                    ),
                  ),
                  obscureText: isobsure1,
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
              ),
              TextFormField(
                controller: _cpasswordController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        isobsure2 = !isobsure2;
                      });
                    },
                    icon: Icon(isobsure2 ? Icons.visibility_off_outlined : Icons.visibility),
                  ),
                ),
                obscureText: isobsure2,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Confirm Password is required';
                  }
                  if (value != _passwordController.text) {
                    return 'Password Mismatch';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              isloading
                  ? Center(child: CircularProgressIndicator())
                  : FilledButton(onPressed: signUp, child: const Text('Sign Up')),
            ],
          ),
        ),
      ),
    );
  }
}
