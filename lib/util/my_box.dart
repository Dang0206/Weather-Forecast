import 'package:flutter/material.dart';

class MyBox extends StatelessWidget {
  const MyBox({super.key, required title, required String temp, required String icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: const Color.fromARGB(255, 149, 200, 243),
        ),
      ),
    );
  }
}