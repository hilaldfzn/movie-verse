import 'package:flutter/material.dart';

class AboutMePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About Me')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(radius: 50, backgroundImage: AssetImage('assets/profile.jpg')),
            const SizedBox(height: 16),
            const Text('William B.', style: TextStyle(fontSize: 24)),
            const Text('Hobbies: Coding, Movies, Traveling'),
            const SizedBox(height: 16),
            const Text('Follow me on:'),
            const Text('Instagram: @william.b'),
          ],
        ),
      ),
    );
  }
}