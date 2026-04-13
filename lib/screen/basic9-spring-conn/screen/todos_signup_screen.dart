import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/todos_signup_controller.dart';

class TodosSignupScreen extends StatelessWidget {
  const TodosSignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<SignupController>();

    // 패스워드 입력 상태에 따른 테두리 색상 결정
    OutlineInputBorder _borderColor(String text) => OutlineInputBorder(
      borderSide: BorderSide(
        color: text.isNotEmpty
            ? (controller.isPasswordMatch ? Colors.green : Colors.red)
            : Colors.grey,
        width: 2.0,
      ),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('회원 가입')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              // 아이디 + 중복체크
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.idController,
                      decoration: const InputDecoration(labelText: '아이디'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () => controller.checkDuplicateId(context),
                    child: const Text('중복 체크'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // TextField(
              //   controller: controller.emailController,
              //   decoration: const InputDecoration(labelText: '이메일'),
              // ),
              // const SizedBox(height: 16),
              // 패스워드
              TextField(
                controller: controller.passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: '패스워드',
                  enabledBorder: _borderColor(controller.passwordController.text),
                  focusedBorder: _borderColor(controller.passwordController.text),
                ),
                onChanged: (_) => controller.validatePassword(),
              ),
              const SizedBox(height: 16),
              // 패스워드 확인
              TextField(
                controller: controller.passwordConfirmController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: '패스워드 확인',
                  enabledBorder: _borderColor(controller.passwordConfirmController.text),
                  focusedBorder: _borderColor(controller.passwordConfirmController.text),
                ),
                onChanged: (_) => controller.validatePassword(),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => controller.signup(context),
                child: const Text('회원 가입'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}