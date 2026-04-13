// lib/screen/home_screen.dart

import 'package:flutter/material.dart';
import '../core/widgets/base_layout.dart';
import '../core/widgets/app_button.dart';
import '../core/widgets/app_text_field.dart';
import '../core/widgets/app_card.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      title: '디자인 시스템 데모',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ── 타이포그래피 섹션 ──────────────────
          Text('타이포그래피', style: AppTextStyles.h2),
          const SizedBox(height: 12),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('H1 헤딩 텍스트 (28px Bold)',   style: AppTextStyles.h1),
                Text('H2 헤딩 텍스트 (22px Bold)',   style: AppTextStyles.h2),
                Text('H3 헤딩 텍스트 (18px SemiBold)', style: AppTextStyles.h3),
                Text('본문 Large (16px)',  style: AppTextStyles.bodyLarge),
                Text('본문 Medium (14px)', style: AppTextStyles.bodyMedium),
                Text('서브 텍스트 (12px)', style: AppTextStyles.bodySmall),
                Text('캡션 (11px)',       style: AppTextStyles.caption),
              ]
                  .expand((w) => [w, const SizedBox(height: 6)])
                  .toList()
                ..removeLast(),
            ),
          ),

          const SizedBox(height: 24),

          // ── 색상 팔레트 섹션 ───────────────────
          Text('색상 팔레트', style: AppTextStyles.h2),
          const SizedBox(height: 12),
          AppCard(
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _ColorChip('Primary',   AppColors.primary),
                _ColorChip('PriLight',  AppColors.primaryLight),
                _ColorChip('BG',        AppColors.background),
                _ColorChip('Surface',   AppColors.surface),
                _ColorChip('Success',   AppColors.success),
                _ColorChip('Warning',   AppColors.warning),
                _ColorChip('Error',     AppColors.error),
                _ColorChip('Info',      AppColors.info),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ── 입력 필드 섹션 ────────────────────
          Text('입력 필드', style: AppTextStyles.h2),
          const SizedBox(height: 12),
          AppTextField(
            label: '이메일',
            hint: 'example@email.com',
            controller: _controller,
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 12),
          AppTextField(
            label: '비밀번호',
            hint: '비밀번호를 입력하세요',
            prefixIcon: Icons.lock_outline,
            suffixIcon: Icons.visibility_off_outlined,
            obscureText: true,
          ),

          const SizedBox(height: 24),

          // ── 버튼 섹션 ────────────────────────
          Text('버튼', style: AppTextStyles.h2),
          const SizedBox(height: 12),
          AppButton(
            label: 'Primary 버튼',
            icon: Icons.check_circle_outline,
            onPressed: () {},
          ),
          const SizedBox(height: 10),
          AppButton(
            label: 'Outline 버튼',
            style: AppButtonStyle.outline,
            icon: Icons.edit_outlined,
            onPressed: () {},
          ),
          const SizedBox(height: 4),
          Center(
            child: AppButton(
              label: 'Text 버튼',
              style: AppButtonStyle.text,
              onPressed: () {},
            ),
          ),
          const SizedBox(height: 10),
          AppButton(
            label: '로딩 중...',
            isLoading: true,
            onPressed: null,
          ),

          const SizedBox(height: 24),

          // ── 카드 섹션 ────────────────────────
          Text('카드', style: AppTextStyles.h2),
          const SizedBox(height: 12),
          AppCard(
            onTap: () {},
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.primaryLight,
                  child: Icon(Icons.person, color: AppColors.primary),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('홍길동', style: AppTextStyles.label),
                    Text('Flutter 개발자', style: AppTextStyles.bodySmall),
                  ],
                ),
                const Spacer(),
                Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textSecondary),
              ],
            ),
          ),
          const SizedBox(height: 10),
          AppCard(
            backgroundColor: AppColors.primaryLight,
            child: Row(
              children: [
                Icon(Icons.info_outline, color: AppColors.primary),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '공통 위젯으로 일관된 UI를 만들 수 있습니다.',
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primary),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// ── 색상 미리보기 칩 헬퍼 위젯 ──────────────────
class _ColorChip extends StatelessWidget {
  final String name;
  final Color color;
  const _ColorChip(this.name, this.color);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 48, height: 48,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border),
          ),
        ),
        const SizedBox(height: 4),
        Text(name, style: AppTextStyles.caption),
      ],
    );
  }
}