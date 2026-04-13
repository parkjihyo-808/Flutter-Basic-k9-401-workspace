import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SignupController extends ChangeNotifier {
  final TextEditingController idController       = TextEditingController();
  final TextEditingController emailController    = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController = TextEditingController();

  bool isPasswordMatch = true;
  final String serverIp = "http://10.100.201.87:8080"; // ← IP 변경 필요

  // 패스워드 일치 여부 검사
  void validatePassword() {
    isPasswordMatch = passwordController.text == passwordConfirmController.text;
    notifyListeners();
  }

  // 아이디 중복 체크
  Future<void> checkDuplicateId(BuildContext context) async {
    String inputId = idController.text.trim();
    if (inputId.isEmpty) { _showDialog(context, "오류", "아이디를 입력하세요."); return; }

    try {
      final response = await http.get(Uri.parse("$serverIp/member/check-mid?mid=$inputId"));
      if (response.statusCode == 200) {
        _showDialog(context, "사용 가능", "이 아이디는 사용할 수 있습니다.");
      } else if (response.statusCode == 409) {
        _showDialog(context, "중복된 아이디", "이미 사용 중인 아이디입니다.");
      } else {
        _showDialog(context, "오류", "서버 응답 오류: ${response.statusCode}");
      }
    } catch (e) {
      _showDialog(context, "오류", "네트워크 오류 발생: $e");
    }
  }

  // 회원가입 요청 (디버깅 강화 버전)
  Future<void> signup(BuildContext context) async {
    if (!isPasswordMatch) { _showDialog(context, "오류", "패스워드가 일치해야 합니다."); return; }

    String inputId = idController.text.trim();
    String inputPw = passwordController.text.trim();
    if (inputId.isEmpty || inputPw.isEmpty) { _showToast(context, "아이디와 비밀번호를 입력하세요."); return; }

    // 전송할 데이터 준비
    final url = Uri.parse("$serverIp/member/register");
    final headers = {"Content-Type": "application/json"};
    final body = jsonEncode({"mid": inputId, "mpw": inputPw});

    // [DEBUG] 요청 정보 출력
    print("------- [DEBUG] 회원가입 요청 시작 -------");
    print("URL: $url");
    print("Headers: $headers");
    print("Body: $body");

    try {
      final response = await http.post(url, headers: headers, body: body);

      // [DEBUG] 응답 정보 출력
      print("------- [DEBUG] 서버 응답 수신 -------");
      print("Status Code: ${response.statusCode}");
      print("Response Body: ${utf8.decode(response.bodyBytes)}"); // 한글 깨짐 방지 처리
      print("-----------------------------------");

      if (response.statusCode == 200) {
        _showToast(context, "회원 가입 성공!");
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pushReplacementNamed(context, "/main");
        });
      } else {
        // 실패 원인을 구체적으로 파악하기 위해 statusCode와 함께 body 출력
        String errorMsg = response.body.isNotEmpty ? response.body : "알 수 없는 오류";
        _showToast(context, "회원 가입 실패 (${response.statusCode}): $errorMsg");

        // 403인 경우 Security 설정 확인 필요, 400인 경우 DTO 필드명 확인 필요
      }
    } catch (e) {
      // [DEBUG] 예외 상황 출력 (네트워크 타임아웃, IP 오타 등)
      print("------- [DEBUG] 네트워크 예외 발생 -------");
      print("Exception Type: ${e.runtimeType}");
      print("Error Detail: $e");
      print("------------------------------------");
      _showToast(context, "오류 발생: $e");
    }
  }

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

  void _showToast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 1)),
    );
  }
}