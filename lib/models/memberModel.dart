import 'dart:convert';

class member {
  int id;
  String name;
  String image;
  String aridNo;
  String img;
  String semester;
  String phoneNo;
  member({
    required this.id,
    required this.name,
    required this.image,
    required this.aridNo,
    required this.img,
    required this.semester,
    required this.phoneNo,
  });

  member copyWith({
    int? id,
    String? name,
    String? image,
    String? aridNo,
    String? img,
    String? semester,
    String? phoneNo,
  }) {
    return member(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      aridNo: aridNo ?? this.aridNo,
      img: img ?? this.img,
      semester: semester ?? this.semester,
      phoneNo: phoneNo ?? this.phoneNo,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'name': name});
    result.addAll({'image': image});
    result.addAll({'aridNo': aridNo});
    result.addAll({'img': img});
    result.addAll({'semester': semester});
    result.addAll({'phoneNo': phoneNo});

    return result;
  }

  factory member.fromMap(Map<String, dynamic> map) {
    return member(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      image: map['image'] ?? '',
      aridNo: map['aridNo'] ?? '',
      img: map['img'] ?? '',
      semester: map['semester'] ?? '',
      phoneNo: map['phoneNo'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory member.fromJson(String source) => member.fromMap(json.decode(source));

  @override
  String toString() {
    return 'member(id: $id, name: $name, image: $image, aridNo: $aridNo, img: $img, semester: $semester, phoneNo: $phoneNo)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is member &&
        other.id == id &&
        other.name == name &&
        other.image == image &&
        other.aridNo == aridNo &&
        other.img == img &&
        other.semester == semester &&
        other.phoneNo == phoneNo;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        image.hashCode ^
        aridNo.hashCode ^
        img.hashCode ^
        semester.hashCode ^
        phoneNo.hashCode;
  }
}
