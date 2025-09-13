import 'package:flutter/material.dart';
import 'auth_ser.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';



class EmailSubscriptionDialog extends StatefulWidget {
  final bool isSubscribed;

  const EmailSubscriptionDialog({
    Key? key,
    required this.isSubscribed,
  }) : super(key: key);

  @override
  _EmailSubscriptionDialogState createState() =>
      _EmailSubscriptionDialogState();
}

class _EmailSubscriptionDialogState extends State<EmailSubscriptionDialog> {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late bool _isSubscribed;

  @override
  void initState() {
    super.initState();
    
    _isSubscribed = widget.isSubscribed || _authService.currentUser != null;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showErrorDialog('Please enter full email and password.');
      return;
    }

    String? errorMessage = await _authService.signUp(email, password);

    if (errorMessage != null) {
      _showErrorDialog(errorMessage);
    } else {
      setState(() {
        _isSubscribed = true;
      });
      _showSuccessDialog(
          'A verification email has been sent to you. Please check your inbox. Spam if you do not see it.');
    }
  }

  Future<void> _cancelSubscription() async {
    String? result = await _authService.deleteUser();
    if (result != null) {
      _showErrorDialog(result);
    } else {
      setState(() {
        _isSubscribed = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration has been cancelled.')),
      );
      Navigator.of(context).pop();
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('OK'))
        ],
      ),
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Success'),
        content: Text(message),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(ctx).pop(); 
                Navigator.of(context).pop(); 
              },
              child: const Text('OK'))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        _isSubscribed
            ? "Cancel registration"
            : "Sign up to receive daily weather forecasts",
      ),
      content: SingleChildScrollView(
        child: _isSubscribed
            ? const Text("You have signed up to receive information. Click Cancel to stop.")
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Enter email and password to register an account.Enter email and password to register an account."),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                      hintText: 'VD: email@example.com',
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                    obscureText: true,
                  ),
                ],
              ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Close"),
        ),
        if (_isSubscribed)
          TextButton(
            onPressed: _cancelSubscription,
            child: const Text("Cancel registration"),
          )
        else
          ElevatedButton(
            onPressed: _signUp,
            child: const Text("Sign up"),
          ),
      ],
    );
  }
}