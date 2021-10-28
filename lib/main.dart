import 'dart:convert';

import 'package:contacts_app/app-contact.class.dart';
import 'package:contacts_app/components/contacts-list.dart';
import 'package:contacts_app/pop_screen.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<AppContact> contacts = [];
  List<String> phone = [];
  List<AppContact> contactsFiltered = [];
  Map<String, Color> contactsColorMap = new Map();
  TextEditingController searchController = new TextEditingController();
  bool contactsLoaded = false;

  @override
  void initState() {
    super.initState();
    getPermissions();
  }

  getPermissions() async {
    if (await Permission.contacts.request().isGranted) {
      getAllContacts();
    }
  }

  getAllContacts() async {
    List<AppContact> _contacts =
        (await ContactsService.getContacts()).map((contact) {
      return AppContact(
        info: contact,
      );
    }).toList();
    setState(() async {
      contacts = _contacts;
      contactsLoaded = true;
      var phone = "";
      for (var item in _contacts) {
        // print(item.info.phones.last.value);
        // phone.add(item.info.phones.last.value);
        phone += item.info.phones.last.value.replaceAll(' ', '') + ';';
      }

      print(phone + '');

      try {
        var rep = await http.get(
          Uri.parse(
              "https://dev.waza.fun/api/get-users-by-phone-numbers?phone_numbers=$phone"),
          headers: {
            'Authorization':
                'Bearer 4638|f7sxjgWnq44X9H8iidorxkyJzX6J9SWSa0Fmr1Aj'
          },
        );

        // (jsonDecode(rep.body) as List<dynamic>).forEach((element) {
        //
        //    print(element+'\n');
        //
        // });

      } catch (e) {
        print(e.toString());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool listItemsExist =
        ((contactsFiltered.length > 0) || (contacts.length > 0));
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            // if the contacts have not been loaded yet
            listItemsExist == true
                ? // if we have contacts to show
                ContactsList(
                    reloadContacts: () {
                      getAllContacts();
                    },
                    contacts: contacts,
                  )
                : Container(
                    padding: EdgeInsets.only(top: 40),
                    child: Text(
                      'No contacts exist',
                      style: TextStyle(color: Colors.grey, fontSize: 20),
                    )),
            // : Container(
            //     // still loading contacts
            //     padding: EdgeInsets.only(top: 40),
            //     child: Center(
            //       child: CircularProgressIndicator(),
            //     ),
            //   ),
            ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Center(
                        child: Container(
                            height: MediaQuery.of(context).size.height - 100,
                            width: MediaQuery.of(context).size.width - 50,
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(32))),
                            child: PopScreen(
                              contacts: contacts,
                            )),
                      );
                    },
                  );
                },
                child: Text("click"))
          ],
        ),
      ),
    );
  }
}
