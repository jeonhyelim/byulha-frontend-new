//perfume.dart

class Perfume {
  final int id;
  final String name;
  final String company;
  final double rating;
  final String forGender;
  final String? thumbnailUrl;

  Perfume({
    required this.id,
    required this.name,
    required this.company,
    required this.rating,
    required this.forGender,
    required this.thumbnailUrl,
  });

  factory Perfume.fromJson(Map<String, dynamic> json) {
    return Perfume(
      id: json['id'],
      name: json['name'],
      company: json['company'],
      rating: json['rating'],
      forGender: json['forGender'],
      thumbnailUrl: json['thumbnailUrl'],
    );
  }
}

class PerfumeList {
  final List<Perfume> content;
  final bool hasNext;
  final int totalPages;
  final int totalElements;
  final int page;
  final int size;
  final bool first;
  final bool last;

  PerfumeList({
    required this.content,
    required this.hasNext,
    required this.totalPages,
    required this.totalElements,
    required this.page,
    required this.size,
    required this.first,
    required this.last,
  });

  factory PerfumeList.fromJson(Map<String, dynamic> json) {
    List<Perfume> content = [];
    for (var item in json['content']) {
      content.add(Perfume.fromJson(item));
    }
    return PerfumeList(
      content: content,
      hasNext: json['hasNext'],
      totalPages: json['totalPages'],
      totalElements: json['totalElements'],
      page: json['page'],
      size: json['size'],
      first: json['first'],
      last: json['last'],
    );
  }
}

class PerfumeDetail {
  // final List<Perfume> content;
  String perfumeUrl;
  String name;
  String company;
  List<String> notes;
  String rating;
  String forGender;
  String longevity;
  String sillage;
  String priceValue;
  String perfumeImage;

  PerfumeDetail({
    required this.perfumeUrl,
    required this.name,
    required this.company,
    required this.notes,
    required this.rating,
    required this.forGender,
    required this.longevity,
    required this.sillage,
    required this.priceValue,
    required this.perfumeImage,
  });

  factory PerfumeDetail.fromJson(Map<String, dynamic> json) {
    return PerfumeDetail(
      perfumeUrl: json['perfumeUrl'],
      name: json['name'],
      company: json['company'],
      // notes: json['notes'],
      notes: List<String>.from(json['notes']),
      rating: json['rating'],
      forGender: json['forGender'],
      longevity: json['longevity'],
      sillage: json['sillage'],
      priceValue: json['priceValue'],
      perfumeImage: json['perfumeImage'],
    );
  }
}
