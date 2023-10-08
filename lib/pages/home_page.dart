import 'package:contact_list/models/person.dart';
import 'package:contact_list/repository/person_repository.dart';
import 'package:contact_list/utils/approutes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Provider.of<PersonRespository>(
      context,
      listen: false,
    ).fetchPerson();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Contatos')),
      // body: FutureBuilder(
      //     future: Provider.of<PersonRespository>(context, listen: false)
      //         .fetchPerson(),
      //     builder: (context, snapshot) {
      //       switch (snapshot.connectionState) {
      //         case ConnectionState.none:
      //         case ConnectionState.waiting:
      //           return const Center(
      //             child: CircularProgressIndicator(),
      //           );
      //         default:
      //           if (snapshot.hasError) {
      //             return Center(child: Text(snapshot.error.toString()));
      //           } else {
      //             if (snapshot.data!.isNotEmpty) {
      //               return ListView.builder(
      //                   itemCount: snapshot.data!.length,
      //                   itemBuilder: (ctx, i) {
      //                     Person person = snapshot.data![i];
      //                     return ListTile(title: Text(person.name));
      //                   });
      //             }
      //           }
      //           return ListTile();
      //       }
      //     }),
      body: Consumer<PersonRespository>(
        builder: (ctx, personRepo, child) {
          return ListView.builder(
            itemCount: personRepo.itemsCount,
            itemBuilder: (ctx, i) {
              Person person = personRepo.items[i];
              return ListTile(
                title: Text(person.name),
                subtitle: Text(person.number),
                leading: CircleAvatar(
                  backgroundImage: person.image != null
                      ? FileImage(person.image!)
                      : const AssetImage('assets/images/person_simple.jpg')
                          as ImageProvider,
                ),
                trailing: IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  onPressed: () =>
                      Provider.of<PersonRespository>(context, listen: false)
                          .deletePerson(person),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.ADD_PERSON);
          },
          icon: const Icon(Icons.person_add),
          label: const Text('Adicionar contato')),
    );
  }
}
