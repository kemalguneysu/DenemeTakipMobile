import 'package:flutter/material.dart';
import 'package:mobil_denemetakip/components/home/authenticated/authenticatedHome.dart';
import 'package:mobil_denemetakip/components/home/notAuthenticatedHome.dart';
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

        return Container(
          child: userStatus['isAuthenticated']?AuthenticatedHome():NotAuthenticatedHome(),
        );
      },
    );
  }
}
