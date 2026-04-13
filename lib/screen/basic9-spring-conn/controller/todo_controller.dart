import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../model/page_response_dto.dart';
import '../model/todo_dto.dart';

class TodoController extends ChangeNotifier {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  // final String serverIp = "http://192.168.219.103:8080/api/todo"; // 서버 주소
  final String serverIp = "http://10.100.201.87:8080/api/todo"; // 서버 주소

  List<TodoDTO> todos = [];
  bool isLoading = false;
  bool isFetchingMore = false; // ✅ 추가 데이터 로드 중 여부
  bool hasMore = true; // ✅ 추가 데이터 여부 확인

  // 페이징_기반_코드
  // int currentPage = 1;
  // int pageSize = 10;
  // int total = 0; // 전체 데이터 개수

  // 커서_기반_코드
  int? lastCursorId; // ✅ 마지막 아이템 ID (커서)
  int remainingCount = 10; // ✅ 최초 호출 이후 줄여나갈 데이터 개수

  // ✅ 로그인한 사용자 ID 가져오기
  Future<String?> getLoggedInUserId() async {
    return await secureStorage.read(key: "mid"); // 보안 저장소에서 유저 ID 가져오기
  }

  // ✅ 검색 파라미터 추가
  String searchType = "TWC";  // 기본 검색 타입
  String keyword = "";

  // ✅ 검색어 변경
  void updateSearchParams(String type, String newKeyword) {
    searchType = type;
    keyword = newKeyword;
    fetchTodos();  // ✅ 검색어 변경 시 다시 데이터 요청
  }

  // Todos 리스트 조회 요청
  Future<void> fetchTodos() async {
    isLoading = true;

    // 커서_기반_코드
    lastCursorId = null; // ✅ 커서를 초기화
    remainingCount = 10;  //  ✅ 최초에는 전체 개수를 먼저 가져옴
    // 페이징_기반_코드
    // currentPage = 1;
    hasMore = true; // ✅ 처음 로드할 때 더 많은 데이터가 있다고 가정
    notifyListeners();

    String? accessToken = await secureStorage.read(key: "accessToken");

    if (accessToken == null) {
      print("토큰이 없습니다.");
      isLoading = false;
      notifyListeners();
      return;
    }

    print("📢 [Flutter] fetchTodos() 최초 호출: cursor=null, 전체 개수 요청, 검색어=$keyword");


    // ✅ PageRequestDTO 데이터를 쿼리 파라미터로 변환
    final Uri requestUrl = Uri.parse(
      // 페이징_기반_코드
      // "$serverIp/list?page=$currentPage&size=$pageSize&type=&keyword=&from=&to=&completed=",
      // 커서_기반_코드
      // "$serverIp/list2?size=10${lastCursorId != null ? '&cursor=$lastCursorId' : ''}",

      // ✅ 최초 호출에서는 전체 개수를 가져오기 위해 size=0
      // "$serverIp/list2?size=10",
      // 검색 기능 추가,
        "$serverIp/list?size=10${lastCursorId != null ? '&cursor=$lastCursorId' : ''}&type=$searchType&keyword=$keyword"

    );

    try {
      final response = await http.get(
        requestUrl,
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": "Bearer $accessToken",
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(utf8.decode(response.bodyBytes));
        PageResponseDTO<TodoDTO> pageResponse = PageResponseDTO.fromJson(
          responseData,
              (json) => TodoDTO.fromJson(json),
        );

        // 페이징_기반_코드
        // todos = pageResponse.dtoList;
        // total = pageResponse.total; // ✅ 전체 데이터 개수 설정
        // hasMore = pageResponse.dtoList.isNotEmpty; // ✅ 다음 데이터 존재 여부 확인

        // 커서_기반_코드
        if (pageResponse.dtoList.isNotEmpty) {
          todos = pageResponse.dtoList; // ✅ 최초 10개 데이터 추가
          lastCursorId = pageResponse.nextCursor; // ✅ 다음 커서 업데이트
          hasMore = pageResponse.hasNext; // ✅ 다음 데이터 여부 확인
          remainingCount = pageResponse.total - todos.length; // ✅ 전체 개수 - 받은 데이터 개수
          print("✅ [Flutter] 전체 개수: ${pageResponse.total}, 남은 개수: $remainingCount");
        } else {
          lastCursorId = null; // ✅ 만약 데이터가 없으면 커서 초기화
          hasMore = false;
        }
      } else {
        print("에러 발생: ${response.body}");
      }
    } catch (e) {
      print("네트워크 오류: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  // ✅ 스크롤을 내릴 때 다음 페이지 로드
  // ✅ 스크롤을 내릴 때 10개씩 줄여서 데이터 요청
  // ✅ 스크롤을 내릴 때 다음 페이지 로드 (10개 제외한 나머지부터)
  Future<void> fetchMoreTodos() async {
    if (isFetchingMore || !hasMore || lastCursorId == null || remainingCount <= 0) {
      print("🚨 [Flutter] 데이터 로딩 중단: cursor=$lastCursorId, hasMore=$hasMore, remaining=$remainingCount");
      hasMore = false; // ✅ 데이터가 남아 있지 않으면 로딩 중단
      notifyListeners();
      return;
    }

    isFetchingMore = true;
    notifyListeners();

    String? accessToken = await secureStorage.read(key: "accessToken");

    if (accessToken == null) {
      print("토큰이 없습니다.");
      isFetchingMore = false;
      notifyListeners();
      return;
    }

    final int fetchSize = remainingCount > 10 ? 10 : remainingCount; // ✅ 남은 개수에서 최대 10개씩 요청


    print("📢 [Flutter] fetchMoreTodos() 요청: cursor=$lastCursorId, fetchSize=$fetchSize, remaining=$remainingCount");


    final Uri requestUrl = Uri.parse(
      // 페이징_기반_코드
      // "$serverIp/list?page=${currentPage + 1}&size=$pageSize&type=&keyword=&from=&to=&completed=",
      // 커서_기반_코드
        "$serverIp/list2?size=$fetchSize${lastCursorId != null ? '&cursor=$lastCursorId' : ''}"
    );

    try {
      final response = await http.get(
        requestUrl,
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": "Bearer $accessToken",
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(utf8.decode(response.bodyBytes));
        PageResponseDTO<TodoDTO> pageResponse = PageResponseDTO.fromJson(
          responseData,
              (json) => TodoDTO.fromJson(json),
        );

        // 커서_기반_코드
        if (pageResponse.dtoList.isNotEmpty) {
          todos.addAll(pageResponse.dtoList);
          lastCursorId = pageResponse.nextCursor; // ✅ 다음 커서 업데이트
          remainingCount -= fetchSize; // ✅ 남은 개수에서 요청한 개수만큼 감소
          // ✅ 남은 개수가 0이거나 nextCursor가 null이면 데이터 로딩 중단
          if (remainingCount <= 0 || pageResponse.nextCursor == null) {
            hasMore = false; // ✅ 더 이상 데이터 없음
            lastCursorId = null; // ✅ 커서 초기화
          }
          print("✅ [Flutter] 전체 개수: ${pageResponse.total}, 남은 개수: $remainingCount");
          // 페이징_기반_코드
          // currentPage++; // ✅ 페이지 증가
          // hasMore = pageResponse.dtoList.length == pageSize; // ✅ 다음 페이지 여부 확인
        } else {
          print("🚨 [Flutter] 더 이상 데이터 없음, hasMore=false");
          lastCursorId = null; // ✅ 만약 데이터가 없으면 커서 초기화
          hasMore = false;
        }
      } else {
        print("에러 발생: ${response.body}");
      }
    } catch (e) {
      print("네트워크 오류: $e");
    }

    isFetchingMore = false;
    notifyListeners();
  }

  // ✅ Todo 상세 조회 요청 (`GET /api/todo/{tno}`)
  Future<TodoDTO?> fetchTodoDetails(int tno) async {
    String? accessToken = await secureStorage.read(key: "accessToken");
    if (accessToken == null) return null;

    final Uri requestUrl = Uri.parse("$serverIp/$tno");

    try {
      final response = await http.get(
        requestUrl,
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": "Bearer $accessToken",
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(utf8.decode(response.bodyBytes));
        return TodoDTO.fromJson(responseData);
      }
    } catch (e) {
      print("네트워크 오류: $e");
    }
    return null;
  }

  // ✅ Todo 수정 요청 (`PUT /api/todo/{tno}`)
  Future<bool> updateTodo(int tno, String title, String writer,
      DateTime dueDate, bool complete) async {
    String? accessToken = await secureStorage.read(key: "accessToken");
    if (accessToken == null) return false;

    final Uri requestUrl = Uri.parse("$serverIp/$tno");

    final Map<String, dynamic> updateData = {
      "tno": tno,
      "title": title,
      "writer": writer,
      "dueDate":
      "${dueDate.year}-${dueDate.month.toString().padLeft(2, '0')}-${dueDate.day.toString().padLeft(2, '0')}", // ✅ 날짜 포맷 수정
      "complete": complete,
    };

    try {
      final response = await http.put(
        requestUrl,
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": "Bearer $accessToken",
        },
        body: jsonEncode(updateData),
      );
      print("📢 [Flutter] 응답 코드: ${response.statusCode}");
      print("📢 [Flutter] 응답 바디: ${response.body}");

      if (response.statusCode == 200) {
        print("✅ [Flutter] Todo 수정 성공!");

        // ✅ 리스트 새로고침
        await fetchTodos(); // ✅ Todo 리스트 다시 불러오기
        notifyListeners(); // ✅ UI 업데이트
        return true;
      } else {
        print("⚠️ [Flutter] 서버 응답 오류: ${response.body}");
      }
    } catch (e) {
      print("❌ [Flutter] 네트워크 오류: $e");
    }
    return false;
  }

  Future<bool> deleteTodo(int tno) async {
    String? accessToken = await secureStorage.read(key: "accessToken");
    if (accessToken == null) {
      print("⚠️ [Flutter] accessToken 없음!");
      return false;
    }

    final Uri requestUrl = Uri.parse("$serverIp/$tno");
    print("📢 [Flutter] DELETE 요청 URL: $requestUrl");

    try {
      final response = await http.delete(
        requestUrl,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );

      if (response.statusCode == 200) {
        print("✅ [Flutter] Todo 삭제 성공!");

        // ✅ 리스트 새로고침
        await fetchTodos(); // ✅ UI 업데이트
        notifyListeners();

        return true;
      } else {
        print("⚠️ [Flutter] 삭제 실패: ${response.body}");
      }
    } catch (e) {
      print("❌ [Flutter] 네트워크 오류: $e");
    }
    return false;
  }

  // ✅ 삭제 확인 다이얼로그 (UI에서 호출)
  void confirmDelete(BuildContext context, int tno) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("삭제 확인"),
          content: const Text("정말 삭제하시겠습니까?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("취소"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // ✅ 다이얼로그 닫기
                bool success = await deleteTodo(tno);
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("삭제되었습니다.")),
                  );
                }
              },
              child: const Text("삭제", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

// ✅ Todo 작성 요청 (`POST /api/todo`)
  Future<bool> createTodo(String title, DateTime dueDate, bool complete) async {
    String? accessToken = await secureStorage.read(key: "accessToken");
    String? mid = await getLoggedInUserId(); // 로그인한 사용자 ID 가져오기

    if (accessToken == null || mid == null) {
      print("⚠️ [Flutter] 액세스 토큰 또는 사용자 ID 없음");
      return false;
    }

    final Uri requestUrl = Uri.parse("$serverIp");

    final Map<String, dynamic> postData = {
      "title": title,
      "writer": mid, // ✅ 로그인한 사용자 ID 자동 입력
      "dueDate":
      "${dueDate.year}-${dueDate.month.toString().padLeft(2, '0')}-${dueDate.day.toString().padLeft(2, '0')}",
      "complete": complete,
    };

    try {
      final response = await http.post(
        requestUrl,
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": "Bearer $accessToken",
        },
        body: jsonEncode(postData),
      );

      print("📢 [Flutter] 응답 코드: ${response.statusCode}");
      print("📢 [Flutter] 응답 바디: ${response.body}");

      if (response.statusCode == 200) {
        print("✅ [Flutter] Todo 작성 성공!");

        // ✅ 리스트 새로고침
        await fetchTodos();
        notifyListeners();
        return true;
      } else {
        print("⚠️ [Flutter] 서버 응답 오류: ${response.body}");
      }
    } catch (e) {
      print("❌ [Flutter] 네트워크 오류: $e");
    }
    return false;
  }
}
