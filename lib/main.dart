import 'package:contact_list/pages/add_person.dart';
import 'package:contact_list/pages/home_page.dart';
import 'package:contact_list/repository/person_repository.dart';
import 'package:contact_list/utils/approutes.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var documentStorage = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(documentStorage.path);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => PersonRespository(),
        )
      ],
      child: MaterialApp(
        title: 'Contact List App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        routes: {
          AppRoutes.HOME_PAGE: (ctx) => HomePage(),
          AppRoutes.ADD_PERSON: (ctx) => AddPerson(),
        },
      ),
    );
  }
}
