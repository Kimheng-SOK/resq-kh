import 'package:flutter/material.dart';
import 'package:app/models/contact_model.dart';
import 'widgets/contact_card.dart';
import 'package:app/services/contacts_storage.dart';

class GeneralContactsScreen extends StatefulWidget {
  const GeneralContactsScreen({super.key});

  @override
  State<GeneralContactsScreen> createState() => _GeneralContactsScreenState();
}

class _GeneralContactsScreenState extends State<GeneralContactsScreen> {
  List<Contact> contacts = [];

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  // load contact
  Future<void> _loadContacts() async {
    final loadedContacts = await ContactsStorage.loadContacts();

    if (loadedContacts.isEmpty) {
      contacts = [
        Contact(
          id: '1',
          name: 'Mom',
          phoneNumber: '012345678',
          relationship: 'Mother',
        ),
        Contact(
          id: '2',
          name: 'Dad',
          phoneNumber: '098765432',
          relationship: 'Father',
        ),
      ];

      await ContactsStorage.saveContacts(contacts);
    } else {
      contacts = loadedContacts;
    }

    setState(() {});
  }

  // Delete
  Future<void> _deleteContact(String id) async {
    setState(() {
      contacts.removeWhere((contact) => contact.id == id);
    });

    await ContactsStorage.saveContacts(contacts);
  }

  Future<void> _confirmDelete(String id) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Contact'),
          content: const Text('Are you sure?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (result == true) {
      await _deleteContact(id);
    }
  }

  // Edit
  Future<void> _updateContact(Contact updatedContact) async {
    final index = contacts.indexWhere(
      (contact) => contact.id == updatedContact.id,
    );

    if (index == -1) return;

    setState(() {
      contacts[index] = updatedContact;
    });

    await ContactsStorage.saveContacts(contacts);
  }

  Future<void> _showEditContactDialog(Contact contact) async {
    final nameController = TextEditingController(text: contact.name);

    final phoneController = TextEditingController(text: contact.phoneNumber);

    final relationshipController = TextEditingController(
      text: contact.relationship,
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Contact'),

          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: relationshipController,
                  decoration: const InputDecoration(labelText: 'Relationship'),
                ),
              ],
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),

            ElevatedButton(
              onPressed: () async {
                final updatedContact = Contact(
                  id: contact.id,
                  name: nameController.text,
                  phoneNumber: phoneController.text,
                  relationship: relationshipController.text,
                );

                await _updateContact(updatedContact);

                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showAddContactDialog() {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final relationshipController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Contact'),

          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: relationshipController,
                  decoration: const InputDecoration(labelText: 'Relationship'),
                ),
              ],
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),

            ElevatedButton(
              onPressed: () async {
                final name = nameController.text.trim();
                final phone = phoneController.text.trim();
                final relationship = relationshipController.text.trim();

                if (name.isEmpty || phone.isEmpty || relationship.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill all fields')),
                  );
                  return;
                }

                setState(() {
                  contacts.add(
                    Contact(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      name: name,
                      phoneNumber: phone,
                      relationship: relationship,
                    ),
                  );
                });

                await ContactsStorage.saveContacts(contacts);

                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFD32F2F),
        onPressed: _showAddContactDialog,
        child: const Icon(Icons.add, color: Colors.white),
      ),

      body: ListView(
        children: [
          const SizedBox(height: 16),

          const Center(
            child: Text(
              'Emergency Contacts',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: 16),

          ...contacts.map(
            (contact) => ContactCard(
              contact: contact,

              onEdit: () => _showEditContactDialog(contact),

              onDelete: () => _confirmDelete(contact.id),
            ),
          ),
        ],
      ),
    );
  }
}
