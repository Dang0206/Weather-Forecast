import 'package:flutter/material.dart';

class EmailSubscriptionDialog extends StatelessWidget {
  const EmailSubscriptionDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Sign up for daily weather forecasts'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            const Text('Enter your email to receive the latest weather updates.'),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'Email',
                hintText: 'VD: email@example.com',
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          child: const Text('Subscribe'),
          onPressed: () {
            // Thêm logic xử lý đăng ký email tại đây
            // VD: Gửi email đến một API hoặc dịch vụ
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}