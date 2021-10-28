import 'package:contacts_app/app-contact.class.dart';
import 'package:contacts_app/components/contacts-list.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

class PopScreen extends StatefulWidget {
  final List<AppContact> contacts;
  // List<AppContact> contacts = [];
  PopScreen({@required this.contacts});

  @override
  State<PopScreen> createState() => _PopScreenState();
}

class _PopScreenState extends State<PopScreen> {
  List<AppContact> contactsFiltered = [];

  bool contactsLoaded = false;

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
      _contacts = _contacts;
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
        ((contactsFiltered.length > 0) || (widget.contacts.length > 0));

    return Container(
        child: Material(
      borderOnForeground: false,
      color: Colors.transparent,
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                icon: Icon(Icons.info_outline_rounded), onPressed: () {}),
            IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ],
        ),
        Text(
          "Abonne-toi a tes amis",
          style: TextStyle(
            fontFamily: 'Robirto',
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(
          child: Container(
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
                        contacts: widget.contacts,
                      )
                    : Container(
                        padding: EdgeInsets.only(top: 40),
                        child: Text(
                          'No contacts exist',
                          style: TextStyle(color: Colors.grey, fontSize: 20),
                        ))
                // : Container(
                //     // still loading contacts
                //     padding: EdgeInsets.only(top: 40),
                //     child: Center(
                //       child: CircularProgressIndicator(),
                //     ),
                //   ),
              ],
            ),
          ),
        ),
      ]),
    ));
  }

  void CshowAlertDialog(BuildContext context) {}
}


/**
 *contacts[0].info.phones.last.value,
 */