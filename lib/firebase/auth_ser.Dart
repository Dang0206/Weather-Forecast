import 'package:flutter/material.dart';
import 'auth_ser.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';





class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Đăng ký và gửi email xác thực
  Future<String?> signUp(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await userCredential.user!.sendEmailVerification();
      return null; // thành công
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') return 'Mật khẩu quá yếu.';
      //if (e.fluflucode == 'email-already-in-use') return 'Email này đã được sử dụng.';
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  // Lấy user hiện tại
  User? get currentUser => _auth.currentUser;

  // Xóa user
  Future<String?> deleteUser() async {
    final user = _auth.currentUser;
    if (user == null) return 'Chưa có tài khoản nào để hủy.';
    try {
      await user.delete();
      return null;
    } catch (e) {
      return 'Không thể hủy đăng ký: $e';
    }
  }
}
