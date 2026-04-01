import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyAppTest2 extends StatelessWidget {
  const MyAppTest2({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 위젯1
            Center( // 가운데 배치하는 역할. 단일 위젯
              child: Text(
                // 이 글자를 수정해 보세요.
                '위젯1 내용입니다. ',
                // 옵션, 텍스트 옵션, 1)크기 2) 굵기 3) 색상
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                    color: Colors.blue
                ),
              ),
            ),
            // 위젯2
            Center( // 가운데 배치하는 역할. 단일 위젯
              child: Text(
                // 이 글자를 수정해 보세요.
                '위젯2 내용입니다. ',
                // 옵션, 텍스트 옵션, 1)크기 2) 굵기 3) 색상
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                    color: Colors.blue
                ),
              ),
            ),
            // 위젯3
            Center( // 가운데 배치하는 역할. 단일 위젯
              child: Text(
                // 이 글자를 수정해 보세요.
                '위젯3 내용입니다. ',
                // 옵션, 텍스트 옵션, 1)크기 2) 굵기 3) 색상
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                    color: Colors.blue
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
