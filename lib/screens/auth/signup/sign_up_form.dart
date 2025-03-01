import 'package:flutter/material.dart';
import 'package:my_invoice_app/static/screen_route.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(hintText: 'Email'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          TextFormField(
            obscureText: true,
            controller: _passwordController,
            decoration: InputDecoration(hintText: 'Password'),
            validator: (value) {
              if (value == null || value.isEmpty || value.length < 8) {
                return 'Password must be at least 8 characters long';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          TextFormField(
            obscureText: true,
            decoration: InputDecoration(hintText: 'Confirm Password'),
            validator: (value) {
              if (value == null || value.isEmpty || value != _passwordController.text) {
                return 'Password don\'t match';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Navigator.pushNamed(context, ScreenRoute.login.route,);
                }
              },
              child: const Text('Sign Up'),
            ),
          ),
        ],
      ),
    );
  }
}
