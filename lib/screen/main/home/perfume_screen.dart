// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taba/screen/login/login_screen.dart';
import '../../../modules/orb/components/components.dart';
import 'package:taba/domain/perfume/perfume.dart';
import 'package:taba/domain/perfume/perfume_provider.dart';
import 'package:taba/screen/main/home/image_recognition_screen.dart';
import 'package:taba/screen/main/home/perfume_screen.dart';

class PerfumeScreen extends ConsumerStatefulWidget {
  final String perfumeId;

  const PerfumeScreen({Key? key, required this.perfumeId}) : super(key: key);

  @override
  createState() => _PerfumeScreen();
}

class _PerfumeScreen extends ConsumerState<PerfumeScreen> {
  @override
  Widget build(BuildContext context) {
    // final perfumeDetail = ref.watch(perfumeDetailProvider(widget.perfumeId));

    final perfumeDetailNotifier = ref.read(perfumeDetailProvider.notifier);

    // 향수 상세 정보 로드
    perfumeDetailNotifier.perfumeDetail(perfumeId: widget.perfumeId);

    // 상태를 관찰
    final perfumeDetail = ref.watch(perfumeDetailProvider);

    return Scaffold(
      appBar: AppBar(
        // title: Text('PERFUME PAGE: perfume.id'),
        title: Text(widget.perfumeId),
        // title: Text(Perfume.id),

        centerTitle: true,
      ),
      body: perfumeDetail.when(
          loading: () => Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
          data: (PerfumeDetail data) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Image.network(
                        data.perfumeImage,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      data.company,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      data.name,
                      style: TextStyle(
                        fontSize: 20,
                        // fontStyle: FontStyle,
                      ),
                    ),

                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.star, color: Colors.amber),
                        Text(data.rating),
                        Text(data.forGender)
                      ],
                    ),
                    // SizedBox(height: 20),
                    // ElevatedButton(
                    //   onPressed: () {
                    //     // 구매 기능을 여기에 구현
                    //   },
                    //   child: Text('Buy Now'),
                    //   style: ElevatedButton.styleFrom(
                    //     primary: const Color.fromARGB(255, 250, 220, 255),
                    //     padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    //   ),
                    // ),
                    SizedBox(height: 20),
                    Text(
                      'NOTES',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 5),
                    Text(
                      'This perfume is a blend of...',
                      textAlign: TextAlign.justify,
                    ),

                    //NOTE 그래프 추가
                    Text(data.notes[1]),

                    //
                    Text('sillage: ${data.sillage}'),
                    Text('longevity: ${data.longevity}'),

                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // 구매 기능을 여기에 구현
                      },
                      child: Text('Buy Now'),
                      style: ElevatedButton.styleFrom(
                        primary: const Color.fromARGB(255, 250, 220, 255),
                        padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      ),
                    ),
                    SizedBox(height: 20),
                    // 리뷰 섹션 추가 가능
                  ],
                ),
              ),
            );
          }),
    );
  }
}
