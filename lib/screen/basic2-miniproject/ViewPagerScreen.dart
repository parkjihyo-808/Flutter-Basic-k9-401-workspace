import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PageViewScreen extends StatefulWidget {
  const PageViewScreen({super.key});
  @override
  State<PageViewScreen> createState() => _PageViewScreenState();
}

class _PageViewScreenState extends State<PageViewScreen> {
  // PageController: 페이지 이동 및 현재 페이지 추적
  final PageController _controller = PageController();
  int _currentPage = 0; // 현재 페이지 인덱스

  // 각 페이지의 배경 색상 목록
  final List<Color> _colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
  ];

  @override
  void dispose() {
    _controller.dispose(); // 메모리 누수 방지를 위해 dispose 호출
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PageView 뷰페이저')),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,           // 컨트롤러 연결
              scrollDirection: Axis.horizontal,  // 가로 스크롤
              onPageChanged: (index) {
                // 페이지 변경 시 현재 인덱스 업데이트
                setState(() => _currentPage = index);
              },
              itemCount: _colors.length,         // 총 페이지 수
              itemBuilder: (context, index) {
                // 각 페이지 위젯 생성
                return Container(
                  color: _colors[index],
                  child: Center(
                    child: Text(
                      '페이지 ${index + 1}',
                      style: const TextStyle(
                        fontSize: 32,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // 페이지 인디케이터 (점 표시)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _colors.length,
                  (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.all(4),
                width: _currentPage == index ? 20 : 10,
                height: 10,
                decoration: BoxDecoration(
                  color: _currentPage == index ? Colors.black : Colors.grey,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // 이전 / 다음 버튼
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  // 이전 페이지로 이동 (애니메이션 포함)
                  _controller.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.ease,
                  );
                },
                child: const Text('이전'),
              ),
              ElevatedButton(
                onPressed: () {
                  // 다음 페이지로 이동 (애니메이션 포함)
                  _controller.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.ease,
                  );
                },
                child: const Text('다음'),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
