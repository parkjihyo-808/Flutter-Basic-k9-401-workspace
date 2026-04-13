// lib/core/widgets/base_layout.dart

import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// 앱 내 모든 화면에서 공통으로 사용하는 기본 레이아웃 위젯입니다.
/// Scaffold를 감싸고 있으며, 공통적인 AppBar 설정과 본문 패딩, 스크롤 기능을 포함합니다.
class BaseLayout extends StatelessWidget {
  /// 앱바(AppBar)에 표시될 제목
  final String title;

  /// 화면의 메인 콘텐츠 위젯
  final Widget body;

  /// 앱바 우측에 표시될 아이콘이나 버튼 리스트 (선택 사항)
  final List<Widget>? actions;

  /// 우측 하단에 떠 있는 버튼 (선택 사항)
  final Widget? floatingActionButton;

  /// 화면 하단 네비게이션 바 (선택 사항)
  final Widget? bottomNavigationBar;

  /// 앱바의 뒤로가기 버튼 표시 여부 (기본값: false)
  final bool showBackButton;

  /// 화면 전체 배경색 (지정하지 않으면 AppColors.background 사용)
  final Color? backgroundColor;

  /// 본문(body)의 내부 여백 (지정하지 않으면 기본값 16 사용)
  final EdgeInsetsGeometry? padding;

  const BaseLayout({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.showBackButton = false,
    this.backgroundColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 배경색 설정: 전달받은 색상이 없으면 앱 기본 배경색 적용
      backgroundColor: backgroundColor ?? AppColors.background,

      // 상단 앱바 구성
      appBar: AppBar(
        title: Text(title),
        // 뒤로가기 버튼 자동 생성 여부 제어
        automaticallyImplyLeading: showBackButton,
        actions: actions,
      ),

      // 본문 영역: 시스템 UI(노치 등)와 겹치지 않도록 SafeArea 적용
      body: SafeArea(
        // 본문 내용이 길어질 경우를 대비해 스크롤 가능하게 설정
        child: SingleChildScrollView(
          // 여백 설정: 전달받은 여백이 없으면 8방향 모두 16pt 적용
          padding: padding ?? const EdgeInsets.all(16),
          child: body,
        ),
      ),

      // 기타 공통 컴포넌트 연결
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}