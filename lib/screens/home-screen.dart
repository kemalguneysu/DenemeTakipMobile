import 'package:flutter/material.dart';
import 'package:mobil_denemetakip/services/auth-service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return StreamBuilder<Map<String, dynamic>>(
      stream: authService.authStatusStream, // AuthService'den stream alıyoruz
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Error loading user data'));
        }

        final userStatus = snapshot.data!;

        String displayText = userStatus['isAuthenticated']
            ? (userStatus['isAdmin'] ? "62" : "auth")
            : "31";

        return Center(
          child: Text(
            displayText,
            style: const TextStyle(fontSize: 18),
          ),
        );
      },
    );
  }
}
