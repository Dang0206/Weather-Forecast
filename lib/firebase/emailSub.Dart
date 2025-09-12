import 'package:flutter/material.dart';
import 'auth_ser.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';


// class EmailSubscriptionDialog extends StatefulWidget {
//   const EmailSubscriptionDialog({Key? key}) : super(key: key);

//   @override
//   _EmailSubscriptionDialogState createState() => _EmailSubscriptionDialogState();
// }

// class _EmailSubscriptionDialogState extends State<EmailSubscriptionDialog> {
//   final AuthService _authService = AuthService();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   // Hàm xử lý đăng ký
//   void _signUp() async {
//     final email = _emailController.text.trim();
//     final password = _passwordController.text.trim();

//     if (email.isEmpty || password.isEmpty) {
//       _showErrorDialog('Vui lòng nhập đầy đủ email và mật khẩu.');
//       return;
//     }

//     String? errorMessage = await _authService.signUp(email, password);

//     if (errorMessage != null) {
//       // Đã có lỗi xảy ra
//       _showErrorDialog(errorMessage);
//     } else {
//       // Thành công: thông báo cho người dùng
//       _showSuccessDialog();
//     }
//   }

//   // Hàm hiển thị dialog lỗi
//   void _showErrorDialog(String message) {
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: const Text('Lỗi'),
//         content: Text(message),
//         actions: <Widget>[
//           TextButton(
//             child: const Text('OK'),
//             onPressed: () {
//               Navigator.of(ctx).pop();
//             },
//           )
//         ],
//       ),
//     );
//   }

//   // Hàm hiển thị dialog thành công
//   void _showSuccessDialog() {
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: const Text('Thành công!'),
//         content: const Text('Một email xác thực đã được gửi đến bạn. Vui lòng kiểm tra hộp thư đến.'),
//         actions: <Widget>[
//           TextButton(
//             child: const Text('OK'),
//             onPressed: () {
//               Navigator.of(ctx).pop();
//               Navigator.of(context).pop(); // Đóng dialog đăng ký
//             },
//           )
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: const Text('Đăng ký để nhận dự báo thời tiết hàng ngày'),
//       content: SingleChildScrollView(
//         child: Column(
//           children: <Widget>[
//             const Text('Nhập email và mật khẩu để đăng ký tài khoản.'),
//             const SizedBox(height: 16),
//             TextField(
//               controller: _emailController,
//               decoration: const InputDecoration(
//                 border: OutlineInputBorder(),
//                 labelText: 'Email',
//                 hintText: 'VD: email@example.com',
//               ),
//               keyboardType: TextInputType.emailAddress,
//             ),
//             const SizedBox(height: 12),
//             TextField(
//               controller: _passwordController,
//               decoration: const InputDecoration(
//                 border: OutlineInputBorder(),
//                 labelText: 'Mật khẩu',
//               ),
//               obscureText: true,
//             ),
//           ],
//         ),
//       ),
//       actions: <Widget>[
//         TextButton(
//           child: const Text('Hủy'),
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//         ),
//         ElevatedButton(
//           child: const Text('Đăng ký'),
//           onPressed: _signUp, // Gọi hàm _signUp khi nhấn nút
//         ),
//       ],
//     );
//   }
// }




class EmailSubscriptionDialog extends StatefulWidget {
  const EmailSubscriptionDialog({Key? key}) : super(key: key);

  @override
  _EmailSubscriptionDialogState createState() =>
      _EmailSubscriptionDialogState();
}

class _EmailSubscriptionDialogState extends State<EmailSubscriptionDialog> {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signUp() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showErrorDialog('Vui lòng nhập đầy đủ email và mật khẩu.');
      return;
    }

    String? errorMessage = await _authService.signUp(email, password);

    if (errorMessage != null) {
      _showErrorDialog(errorMessage);
    } else {
      _showSuccessDialog(
          'Một email xác thực đã được gửi đến bạn. Vui lòng kiểm tra hộp thư đến (Spam nếu không thấy).');
    }
  }

  void _cancelSubscription() async {
    String? result = await _authService.deleteUser();
    if (result != null) {
      _showErrorDialog(result);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Đăng ký đã bị hủy.')));
      Navigator.of(context).pop(); // đóng dialog
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Lỗi'),
        content: Text(message),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(), child: const Text('OK'))
        ],
      ),
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Thành công'),
        content: Text(message),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(ctx).pop(); // đóng dialog thành công
                Navigator.of(context).pop(); // đóng dialog chính
              },
              child: const Text('OK'))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userExists = _authService.currentUser != null;

    return AlertDialog(
      title: const Text('Đăng ký để nhận dự báo thời tiết hàng ngày'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            const Text('Nhập email và mật khẩu để đăng ký tài khoản.'),
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
                labelText: 'Mật khẩu',
              ),
              obscureText: true,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Hủy'),
        ),
        if (userExists)
          TextButton(
            onPressed: _cancelSubscription,
            child: const Text('Hủy đăng ký'),
          ),
        ElevatedButton(
          onPressed: _signUp,
          child: const Text('Đăng ký'),
        ),
      ],
    );
  }
}