// homescreen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taba/domain/perfume/perfume.dart';
import 'package:taba/domain/perfume/perfume_provider.dart';
import 'package:taba/domain/auth/repository.dart';
import 'package:taba/screen/main/home/image_rec.dart';

final currentPageProvider = StateProvider<int>((ref) => 0);

class HomeScreen extends ConsumerWidget {
  HomeScreen({Key? key}) : super(key: key);

  final PageController _pageController = PageController();
  final int _totalAds = 3; // 총 광고 페이지 수

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int currentPage = ref.watch(currentPageProvider);
    final AsyncValue<PerfumeList>? perfumeList = ref.watch(perfumeListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Align(
          alignment: Alignment.centerLeft,
          child: Text('로고'), // 로고 대신에 이미지 위젯을 사용할 수 있음
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 200, // 광고 배너의 높이
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (page) => ref.read(currentPageProvider.notifier).state = page,
                itemCount: _totalAds,
                itemBuilder: (_, index) {
                  return Container(
                    color: Colors.grey, // 여기에 광고 이미지를 넣을 수 있음
                    child: Center(
                      child: Text('배너 ${index + 1}'),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10), // 페이지 인디케이터와 광고 배너 사이의 간격
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _totalAds,
                    (index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: CircleAvatar(
                    radius: 5,
                    backgroundColor: currentPage == index ? Colors.blue : Colors.grey,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20), // 버튼 위의 간격
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // image_rec.dart 페이지로 이동
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ImageRecScreen()), // ImageRecPage는 image_rec.dart의 페이지 위젯
                  );
                },
                child: Text('이미지로 향수추천받기'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 120, vertical: 40),
                ),
              ),
            ),
            SizedBox(height: 20), // 버튼 아래의 간격
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Best Rated'),
              ),
            ),
            GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3 / 4,
              ),
              itemCount: perfumeList?.value?.content.length ?? 0,
              itemBuilder: (context, index) {
                final perfume = perfumeList?.value?.content[index];
                if (perfume != null) {
                  return Card(
                    child: Column(
                      children: [
                        Text(perfume.name),
                        Text('Rating: ${perfume.rating.toString()}'),
                        // 향수 이미지와 기타 속성을 여기에 추가할 수 있습니다.
                      ],
                    ),
                  );
                } else {
                  return SizedBox(); // 데이터가 없는 경우 비어있는 위젯을 반환합니다.
                }
              },
            ),
            if (perfumeList?.value?.hasNext == true)
              ElevatedButton(
                onPressed: () {
                  int currentPage = ref.read(currentPageProvider);
                  ref.read(perfumeListProvider.notifier).getPerfumeList(currentPage + 1, 10);
                },
                child: Text('더보기'),
              )
            else
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('마지막 페이지입니다'),
              ),
          ],
        ),
      ),
    );
  }
}
