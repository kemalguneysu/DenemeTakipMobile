import 'package:flutter/material.dart';

class KayitOlScreen extends StatefulWidget {
  const KayitOlScreen({Key? key}) : super(key: key);

  @override
  _KayitOlScreenState createState() => _KayitOlScreenState();
}

class _KayitOlScreenState extends State<KayitOlScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Login işlemi
              },
              child: const Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}
