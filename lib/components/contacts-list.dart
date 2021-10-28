import 'package:contacts_app/app-contact.class.dart';

import 'package:flutter/material.dart';

import 'contact-avatar.dart';

class ContactsList extends StatelessWidget {
  final List<AppContact> contacts;
  Function() reloadContacts;
  ContactsList({Key key, this.contacts, this.reloadContacts}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          AppContact contact = contacts[index];
          return Card(
            color: Colors.green,
            elevation: 5,
            child: ListTile(
              title: Text(
                contact.info.displayName,
                style: TextStyle(color: Colors.black),
              ),
              subtitle: Text(contact.info.phones.length > 0
                  ? contact.info.phones.elementAt(0).value
                  : ''),
              leading: ContactAvatar(contact, 36),
              trailing: IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.person_add,
                  color: Colors.deepOrange,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
