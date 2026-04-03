import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('메인 화면')),
      body: SafeArea(
        child: ListView(
          children: [
            // const Center(child: FlutterLogo(size: 100)),
            Center(
              // child: FlutterLogo(size: 100)
              child: Image.asset(
                'assets/images/logo2.png',
                width: 200,
                height: 200,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/signup'),
              child: const Text('회원 가입'),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: () => Navigator.pushNamed(context, '/login'),
              child: const Text('로그인'),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: () => Navigator.pushNamed(context, '/tabMenuTest'),
              child: const Text('탭 메뉴 연습'),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: () => Navigator.pushNamed(context, '/viewPagerTest'),
              child: const Text('뷰페이져 연습'),
            ),
          ],
        ),
      ),
    );
  }

}
