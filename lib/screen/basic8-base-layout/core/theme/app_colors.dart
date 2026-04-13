// lib/core/theme/app_colors.dart

import 'package:flutter/material.dart';

class AppColors {
  AppColors._(); // 인스턴스 생성 방지

  // Primary
  static const Color primary    = Color(0xFF2563EB); // 메인 파란색
  static const Color primaryDark = Color(0xFF1D4ED8);
  static const Color primaryLight = Color(0xFFDBEAFE);

  // Background
  static const Color background  = Color(0xFFF8FAFC); // 앱 배경
  static const Color surface     = Color(0xFFFFFFFF); // 카드/컨테이너 배경
  static const Color surfaceGrey = Color(0xFFF1F5F9);

  // Text
  static const Color textPrimary   = Color(0xFF1E293B); // 본문 텍스트
  static const Color textSecondary = Color(0xFF64748B); // 서브 텍스트
  static const Color textHint      = Color(0xFF94A3B8); // 힌트/플레이스홀더
  static const Color textOnPrimary = Color(0xFFFFFFFF); // 버튼 위 텍스트

  // Semantic
  static const Color success = Color(0xFF16A34A);
  static const Color warning = Color(0xFFD97706);
  static const Color error   = Color(0xFFDC2626);
  static const Color info    = Color(0xFF0284C7);

  // Border
  static const Color border     = Color(0xFFE2E8F0);
  static const Color borderFocus = Color(0xFF2563EB);
}