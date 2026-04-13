import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../screen/todos_main_screen.dart';


class LoginController extends ChangeNotifier {
  final TextEditingController idController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  final String serverIp = "http://10.100.201.87:8080"; // ← IP 변경 필요

  bool isLoading = false;
  bool isLoggedIn = false;

  LoginController() {
    _checkLoginStatus(); // 앱 시작 시 로그인 상태 복원
  }

  // ── 로그인 요청 ──────────────────────────────────
  Future<void> login(BuildContext context) async {
    String inputId = idController.text.trim();
    String inputPw = passwordController.text.trim();

    if (inputId.isEmpty || inputPw.isEmpty) {
      _showDialog(context, "오류", "아이디와 비밀번호를 입력하세요.");
      return;
    }

    try {
      isLoading = true;
      notifyListeners();

      final response = await http.post(
        Uri.parse("$serverIp/generateToken"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"mid": inputId, "mpw": inputPw}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await secureStorage.write(key: "accessToken",  value: data["accessToken"]);
        await secureStorage.write(key: "refreshToken", value: data["refreshToken"]);
        await secureStorage.write(key: "mid",          value: inputId);

        clearInputFields();
        isLoggedIn = true;
        notifyListeners();

        _showDialog(context, "로그인 성공", "메인 화면으로 이동합니다.");
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const TodosMainScreen()),
                (route) => false,
          );
        });
      } else {
        _showDialog(context, "로그인 실패", "아이디 또는 비밀번호가 잘못되었습니다.");
      }
    } catch (e) {
      _showDialog(context, "네트워크 오류", "오류 발생: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ── 로그아웃 ──────────────────────────────────────
  Future<void> showLogoutDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("로그아웃 확인"),
        content: const Text("정말 로그아웃 하시겠습니까?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("취소")),
          TextButton(
            onPressed: () { Navigator.pop(context); logout(context); },
            child: const Text("확인", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    await secureStorage.delete(key: "accessToken");
    await secureStorage.delete(key: "refreshToken");
    await secureStorage.delete(key: "mid");

    isLoggedIn = false;
    notifyListeners();

    _showDialog(context, "로그아웃", "성공");
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const TodosMainScreen()),
          (route) => false,
    );
  }

  // ── 유틸 ─────────────────────────────────────────
  void clearInputFields() {
    idController.clear();
    passwordController.clear();
    notifyListeners();
  }

  Future<void> _checkLoginStatus() async {
    String? mid = await secureStorage.read(key: "mid");
    isLoggedIn = mid != null;
    notifyListeners();
  }

  Future<String?> getAccessToken() => secureStorage.read(key: "accessToken");
  Future<String?> getUserId()      => secureStorage.read(key: "mid");

  void _showDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("확인"))],
      ),
    );
  }
}