import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controller/food_controller.dart';
import 'food_detail_screen.dart';

class MyPdTestScreen extends StatefulWidget {
  const MyPdTestScreen({super.key});

  @override
  State<MyPdTestScreen> createState() => _MyPdTestScreenState();
}

class _MyPdTestScreenState extends State<MyPdTestScreen> {

  // 최초에 그림을 한번만 그릴 때, 한번만 초기화 사용하기.
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // 화면이 처음 그려진 직후에 딱 한 번만 API 호출 (main.dart에 있는 전역 객체를 사용!)
    WidgetsBinding.instance.addPostFrameCallback((_) {
    context.read<FoodController>().fetchFoodData();
    });
  }

  // 그림을 그릴때 사용하는 메서드,
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('부산 맛집 정보 서비스')),
      body: Consumer<FoodController>(
        builder: (context, controller, _) {
          // 상태 1: 로딩 중
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          // 상태 2: 데이터 없음
          if (controller.items.isEmpty) {
            return const Center(child: Text('데이터가 없습니다.'));
          }
          // 상태 3: 데이터 표시
          return ListView.builder(
            itemCount: controller.items.length,
            itemBuilder: (context, index) {
              final item = controller.items[index];
              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  // 2️⃣ ListTile 안에 onTap 이벤트 추가 👈
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FoodDetailScreen(foodItem: item),
                      ),
                    );
                  },
                  // 기본 이미지 1
                  // leading: item.image != null
                  //     ? Image.network(item.image!, width: 80, fit: BoxFit.cover)
                  //     : const Icon(Icons.image_not_supported),

                  // 애니메이션 효과2
                  // 3️⃣ Hero 애니메이션을 위해 이미지를 Hero로 감싸줍니다 (선택사항)
                  leading: item.image != null && item.image!.isNotEmpty
                      ? Hero(
                    tag: 'food_image_${item.title}', // 상세 화면의 태그와 동일해야 함
                    child: Image.network(
                      item.image!,
                      width: 80,
                      fit: BoxFit.cover,
                    ),
                  )
                      : const SizedBox(width: 80, child: Icon(Icons.restaurant)),
                  // 애니메이션 효과2

                  title: Text(item.mainTitle ?? ""),
                  subtitle: Text(item.title ?? ""),
                ),
              );
            },
          );
        },
      ),
    );
  }
}