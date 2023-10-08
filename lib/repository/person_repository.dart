import 'dart:io';

import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import '../models/person.dart';
import 'package:flutter/material.dart';

class PersonRespository with ChangeNotifier {
  late Box? storage;
  List _items = [];
  List get items => [..._items];

  int get itemsCount => _items.length;

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');

    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.create(recursive: true);
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

  Future<void> fetchPerson() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _items.clear();

    if (Hive.isBoxOpen('person')) {
      storage = Hive.box('person');
    } else {
      storage = await Hive.openBox('person');
    }
    final data = storage!.keys.map((key) {
      final item = storage!.get(key);
      return Person(
          key: key,
          image: File(item['image'] ?? ''),
          name: item['name'],
          number: item['number']);
    }).toList();

    _items = data.reversed.toList();
    notifyListeners();
  }

  Future<void> deletePerson(Person person) async {
    if (Hive.isBoxOpen('person')) {
      storage = Hive.box('person');
    } else {
      storage = await Hive.openBox('person');
    }

    await storage!.delete(person.key).then(
          (value) => _items.remove(person),
        );
    notifyListeners();
  }

  Future<void> addPerson(Person person) async {
    storage = Hive.box('person');
    storage!.add(person.toJson());
    await fetchPerson();
    notifyListeners();
  }
}
