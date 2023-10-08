import 'dart:io';

class Person {
  dynamic key;
  String name;
  String number;
  File? image;

  Person(
      {this.key,
      required this.name,
      required this.number,
      required this.image});

  Map<String, dynamic> toJson() {
    return {
      'key': key ?? '',
      'name': name,
      'number': number,
      'image': image?.path,
    };
  }

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      key: json['key'] ?? '',
      name: json['name'],
      number: json['number'],
      image: File(json['image']),
    );
  }
}
