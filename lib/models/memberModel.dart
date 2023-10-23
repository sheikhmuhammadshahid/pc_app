import 'dart:convert';

class MemberModel {
  String name;
  String image;
  String img;
  String phoneNo;
  int id;
  String aridNo;
  String semester;
  MemberModel({
    required this.name,
    required this.image,
    required this.img,
    required this.phoneNo,
    required this.id,
    required this.aridNo,
    required this.semester,
  });

  MemberModel copyWith({
    String? name,
    String? image,
    String? img,
    String? phoneNo,
    int? id,
    String? aridNo,
    String? semester,
  }) {
    return MemberModel(
      name: name ?? this.name,
      image: image ?? this.image,
      img: img ?? this.img,
      phoneNo: phoneNo ?? this.phoneNo,
      id: id ?? this.id,
      aridNo: aridNo ?? this.aridNo,
      semester: semester ?? this.semester,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'name': name});
    result.addAll({'image': image});
    result.addAll({'img': img});
    result.addAll({'phoneNo': phoneNo});
    result.addAll({'id': id});
    result.addAll({'aridNo': aridNo});
    result.addAll({'semester': semester});

    return result;
  }

  factory MemberModel.fromMap(Map<String, dynamic> map) {
    return MemberModel(
      name: map['name'] ?? '',
      image: map['image'] ?? '',
      img: map['img'] ?? '',
      phoneNo: map['phoneNo'] ?? '',
      id: map['id']?.toInt() ?? 0,
      aridNo: map['aridNo'] ?? '',
      semester: map['semester'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory MemberModel.fromJson(String source) =>
      MemberModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'MemberModel(name: $name, image: $image, img: $img, phoneNo: $phoneNo, id: $id, aridNo: $aridNo, semester: $semester)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MemberModel &&
        other.name == name &&
        other.image == image &&
        other.img == img &&
        other.phoneNo == phoneNo &&
        other.id == id &&
        other.aridNo == aridNo &&
        other.semester == semester;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        image.hashCode ^
        img.hashCode ^
        phoneNo.hashCode ^
        id.hashCode ^
        aridNo.hashCode ^
        semester.hashCode;
  }
}
