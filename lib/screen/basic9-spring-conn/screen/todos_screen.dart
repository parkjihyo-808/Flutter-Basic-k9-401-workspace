import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controller/todo_controller.dart';

class TodosScreen extends StatefulWidget {
  const TodosScreen({super.key});

  @override
  _TodosScreenState createState() => _TodosScreenState();
}

class _TodosScreenState extends State<TodosScreen> {
  late ScrollController _scrollController;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode(); // ✅ 포커스 감지용 FocusNode
  bool showScrollToTopButton = false;

  @override
  void initState() { // 화면을 그릴 때 최초로 1번 실행, 첫 변수들을 , 객체등을 초기화 할 때 많이 사용.
    super.initState();

    final todoController = context.read<TodoController>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      todoController.fetchTodos();
    });

    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels > 300) {
        if (!showScrollToTopButton) {
          setState(() {
            showScrollToTopButton = true;
          });
        }
      } else {
        if (showScrollToTopButton) {
          setState(() {
            showScrollToTopButton = false;
          });
        }
      }

      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent &&
          !todoController.isFetchingMore) {
        todoController.fetchMoreTodos();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      context.read<TodoController>().updateSearchParams("TWC", ""); // ✅ 검색어 및 결과 초기화
    });
  }

  @override
  Widget build(BuildContext context) {
    final todoController = context.watch<TodoController>();

    return GestureDetector(
      onTap: () {
        // ✅ 다른 곳을 터치하면 키보드 숨기고 검색 초기화
        if (_searchFocusNode.hasFocus) {
          _searchFocusNode.unfocus();
          // _clearSearch();
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("Todos 리스트")),
        body: Column(
          children: [
            // ✅ 검색 입력창
            Container(
              height: 100,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: TextField(
                controller: _searchController,
                focusNode: _searchFocusNode, // ✅ 포커스 노드 적용
                decoration: InputDecoration(
                  labelText: "검색어 입력",
                  border: OutlineInputBorder(),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: _clearSearch,
                  )
                      : null,
                ),
                onChanged: (value) {
                  todoController.updateSearchParams("TWC", value); // ✅ 검색어 변경 시 즉시 서버 호출
                },
              ),
            ),

            // ✅ 검색 결과 및 출력 개수 표시
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  todoController.todos.isEmpty
                      ? "🔍 검색 결과가 없습니다."
                      : "🔍 검색어: \"${todoController.keyword}\" / 총 ${todoController.remainingCount }개 중 ${todoController.todos.length}개 출력",
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87),
                ),
              ),
            ),

            // ✅ 리스트 출력
            Expanded(
              child: todoController.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : todoController.todos.isEmpty
                  ? const Center(child: Text("할 일이 없습니다."))
                  : ListView.builder(
                controller: _scrollController,
                itemCount: todoController.todos.length + (todoController.hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (!todoController.hasMore && index == todoController.todos.length) {
                    return const SizedBox();
                  }

                  if (index == todoController.todos.length) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  final todo = todoController.todos[index];
                  return ListTile(
                    title: Text(
                      "${index + 1}. ${todo.title}",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text("ID: ${todo.tno}",
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black54)),
                            Text(", 작성자: ${todo.writer}",
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black54)),
                          ],
                        ),
                        Text("작성일: ${todo.dueDate}",
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black54)),
                        Icon(
                          todo.complete ? Icons.check_circle : Icons.circle_outlined,
                          color: todo.complete ? Colors.green : Colors.grey,
                          size: 24,
                        ),
                        Text(
                          todo.complete ? '완료' : '미완료',
                          style: TextStyle(
                            fontSize: 14,
                            color: todo.complete ? Colors.black : Colors.grey,
                            decoration: todo.complete ? TextDecoration.lineThrough : TextDecoration.none,
                          ),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // ✅ 수정 아이콘 버튼 추가
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              "/todoDetail",
                              arguments: todo.tno, // ✅ tno 전달
                            );
                          },
                        ),
                        // ✅ 삭제 버튼 (삭제 확인 다이얼로그 호출)
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => todoController.confirmDelete(context, todo.tno),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),

        // ✅ "맨 위로" 버튼 및 "추가하기" 버튼
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (showScrollToTopButton)
              FloatingActionButton(
                heroTag: "scrollToTop",
                onPressed: _scrollToTop,
                backgroundColor: Colors.blueAccent,
                child: const Icon(Icons.arrow_upward, color: Colors.white),
              ),
            const SizedBox(height: 10),
            FloatingActionButton(
              heroTag: "addTodo",
              onPressed: () {
                Navigator.pushNamed(context, "/todoCreate");
              },
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}