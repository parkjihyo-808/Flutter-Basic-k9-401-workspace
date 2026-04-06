import 'package:busanit_401_k9_flutter_project/screen/basic3-http/_3_news_api/models/news_article.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewsDetailScreen extends StatelessWidget {
  final NewsArticle article;
  const NewsDetailScreen({super.key,required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(article.source), // 앱바 제목을 언론사 이름으로 설정
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. 기사 이미지 (있을 경우에만 표시)
            if (article.imageUrl != null)
              Image.network(
                article.imageUrl!,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox(),
              ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 2. 제목
                  Text(
                    article.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // 3. 작성자 및 날짜
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (article.author != null && article.author!.isNotEmpty)
                        Expanded(
                          child: Text(
                            '✍️ ${article.author}',
                            style: const TextStyle(color: Colors.grey),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      Text(
                        article.formattedDate,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  const Divider(height: 32, thickness: 1),

                  // 4. 본문/요약 (description)
                  if (article.description != null)
                    Text(
                      article.description!,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.6,
                        color: Colors.black87,
                      ),
                    )
                  else
                    const Text('본문 요약이 제공되지 않는 기사입니다.',
                        style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
