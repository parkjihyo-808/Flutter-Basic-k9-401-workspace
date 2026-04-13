import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import '../controller/todos_login_controller.dart';

class TodosMainScreen extends StatefulWidget {
  const TodosMainScreen({super.key});

  @override
  State<TodosMainScreen> createState() => _TodosMainScreenState();
}

class _TodosMainScreenState extends State<TodosMainScreen> {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  String? userId; // 저장소에서 읽어온 로그인 ID

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    String? mid = await secureStorage.read(key: "mid");
    setState(() => userId = mid); // 상태 업데이트 → 화면 갱신
  }

  @override
  Widget build(BuildContext context) {
    final loginController = context.watch<LoginController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('메인 화면'),
        actions: [
          // 로그인 상태일 때만 로그아웃 버튼 표시
          if (loginController.isLoggedIn)
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () => loginController.showLogoutDialog(context),
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(child: FlutterLogo(size: 100)),
            const SizedBox(height: 20),
            // 로그인한 유저 ID 표시
            if (userId != null)
              Text('👤 $userId 님 환영합니다!',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/signup'),
              child: const Text('회원 가입'),
            ),
            OutlinedButton(
              onPressed: () => Navigator.pushNamed(context, '/login'),
              child: const Text('로그인'),
            ),
            if (loginController.isLoggedIn)
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/todos'),
                child: const Text('todos 일정'),
              ),
          ],
        ),
      ),
    );
  }
}