import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taba/domain/perfume/perfume.dart';
import 'package:taba/domain/perfume/perfume_provider.dart';
import 'package:taba/screen/main/home/image_rec.dart';

final currentPageProvider = StateProvider<int>((ref) => 0);

class HomeScreen extends ConsumerWidget {
  HomeScreen({Key? key}) : super(key: key);

  final PageController _pageController = PageController();
  final int _totalAds = 2; // 총 광고 페이지 수

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<PerfumeList> perfumeList = ref.watch(perfumeListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Align(
          alignment: Alignment.centerLeft,
          child: Text('로고'),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(
              height: 200, // 광고 배너의 높이
              child: PageView.builder(
                controller: _pageController,
                itemCount: _totalAds,
                itemBuilder: (_, index) {
                  return Container(
                    color: Colors.grey, // 광고 이미지를 넣을 수 있음
                    child: Center(
                      child: Text('배너 ${index + 1}'),
                    ),
                  );
                },
              ),
            ),
          ),
          // 기타 SliverToBoxAdapter 위젯들...
          SliverToBoxAdapter(
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ImageRecScreen()),
                  );
                },
                child: Text('이미지로 향수 추천받기'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 120, vertical: 40),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverToBoxAdapter(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Best Rated'),
              ),
            ),
          ),
          perfumeList.when(
            data: (data) => SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3 / 4,
              ),
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final perfume = data.content[index];
                  return Card(
                    color: Colors.white,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: perfume.thumbnailUrl != null
                              ? Image.network(
                            perfume.thumbnailUrl!,
                            fit: BoxFit.cover,
                          )
                              : const Placeholder(),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(perfume.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              Text('Rating: ${perfume.rating}'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
                childCount: data.content.length,
              ),
            ),
            loading: () => SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, stack) => SliverFillRemaining(
              child: Center(child: Text('An error occurred: $e')),
            ),
          ),
          SliverToBoxAdapter(
            child: OutlinedButton(
              onPressed: () {
                final currentPage = ref.read(currentPageProvider);
                ref.read(perfumeListProvider.notifier).getPerfumeList(currentPage + 1, 10);
              },
              child: const Text('더 경험하기'),
            ),
          ),
        ],
      ),
    );
  }
}
