import 'dart:io';

import 'package:contact_list/models/person.dart';
import 'package:contact_list/repository/person_repository.dart';
import 'package:contact_list/utils/image_input.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddPerson extends StatefulWidget {
  const AddPerson({super.key});

  @override
  State<AddPerson> createState() => _AddPersonState();
}

class _AddPersonState extends State<AddPerson> {
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _numberFocus = FocusNode();
  Map<String, dynamic> _formData = {};
  final _formKey = GlobalKey<FormState>();

  void updateImage() {
    setState(() {});
  }

  void _handleImagePick(File image) {
    _formData['image'] = image;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar pessoa'),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(30),
        child: Form(
          key: _formKey,
          child: Column(children: [
            UserImagePicker(onImagePick: _handleImagePick),

            // IconButton(
            //     onPressed: () {

            //     }, icon: const Icon(Icons.person), iconSize: 90),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              decoration: const InputDecoration(label: Text('Nome')),
              focusNode: _nameFocus,
              onSaved: (name) {
                _formData['name'] = name;
              },
              validator: (name) {
                if (name!.isEmpty) {
                  return 'Por favor, adicione algum nome.';
                }
              },
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              decoration: const InputDecoration(label: Text('Número')),
              focusNode: _numberFocus,
              keyboardType: const TextInputType.numberWithOptions(),
              onSaved: (number) {
                _formData['number'] = number;
              },
              validator: (number) {
                if (number!.isEmpty) {
                  return 'Por favor, adicione algum número.';
                }
              },
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () async {
                  final isValid = _formKey.currentState?.validate() ?? false;

                  if (!isValid) {
                    return;
                  }
                  if (_formData['image'] != null) {
                    _formKey.currentState?.save();
                  } else {
                    showDialog(
                        context: context,
                        builder: (ctx) {
                          return const AlertDialog.adaptive(
                            content: Text(
                                'Por favor, adicione uma imagem para o seu contato!'),
                          );
                        });
                    return;
                  }

                  Person person = Person(
                      image: _formData['image'],
                      name: _formData['name'],
                      number: _formData['number']);
                  await Provider.of<PersonRespository>(context, listen: false)
                      .addPerson(person)
                      .then((value) => Navigator.pop(context));
                },
                child: const Text('Adicionar contato'))
          ]),
        ),
      )),
    );
  }
}
