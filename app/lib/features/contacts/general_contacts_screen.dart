import 'package:app/core/theme/app_color.dart';
import 'package:app/core/utils/launcher_helper.dart';
import 'package:app/widgets/refresh_drag_pop_widget.dart';
import 'package:flutter/material.dart';
import 'package:app/features/contacts/models/contacts_model.dart';
import 'widgets/contact_card.dart';
import 'package:app/services/contact_service.dart';

class GeneralContactsScreen extends StatefulWidget {
  const GeneralContactsScreen({super.key});

  @override
  State<GeneralContactsScreen> createState() => _GeneralContactsScreenState();
}

class _GeneralContactsScreenState extends State<GeneralContactsScreen> {
  List<Contact> contacts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    try {
      final result = await ContactService.getContacts();
      if (!mounted) return;
      setState(() {
        contacts = result.map<Contact>((e) => Contact.fromJson(e)).toList();
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('LOAD CONTACT ERROR: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteContact(String id) async {
    await ContactService.deleteContact(id);
    await _loadContacts();
  }

  Future<void> _updateContact(Contact updated) async {
    await ContactService.updateContact(
      contactId: updated.id,
      name: updated.name,
      phoneNumber: updated.phoneNumber,
      relationship: updated.relationship,
    );
    await _loadContacts();
  }

  // ── Contact detail sheet (tap on card) ──────────────────────

  void _showContactDetail(Contact contact) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        final theme = Theme.of(ctx);
        final initials = contact.name.isNotEmpty
            ? contact.name[0].toUpperCase()
            : '?';

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),

              // Avatar
              CircleAvatar(
                radius: 36,
                backgroundColor: AppColors.red,
                child: Text(
                  initials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Name
              Text(
                contact.name,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),

              // Relationship badge
              if (contact.relationship.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.red.withAlpha(20),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    contact.relationship,
                    style: const TextStyle(
                      color: AppColors.red,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),

              const SizedBox(height: 20),

              // Phone row
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.brightness == Brightness.dark
                      ? Colors.white.withValues(alpha: 0.06)
                      : const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.phone_rounded, color: AppColors.red),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Phone',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            contact.phoneNumber,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () =>
                          LauncherHelper.makeCall(contact.phoneNumber),
                      icon: const Icon(Icons.call_rounded),
                      color: AppColors.success,
                      tooltip: 'Call',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Actions
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(ctx);
                        _showEditContactDialog(contact);
                      },
                      icon: const Icon(Icons.edit_outlined, size: 18),
                      label: const Text('Edit'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(ctx);
                        _confirmDelete(contact.id);
                      },
                      icon: const Icon(Icons.delete_outline, size: 18),
                      label: const Text('Delete'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.red,
                        side: const BorderSide(color: AppColors.red),
                        minimumSize: const Size(0, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  // ── Edit dialog ─────────────────────────────────────────────

  Future<void> _showEditContactDialog(Contact contact) async {
    final nameController = TextEditingController(text: contact.name);
    final phoneController = TextEditingController(text: contact.phoneNumber);
    final relationshipController = TextEditingController(
      text: contact.relationship,
    );

    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
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
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (saved == true) {
      await _updateContact(Contact(
        id: contact.id,
        name: nameController.text.trim(),
        phoneNumber: phoneController.text.trim(),
        relationship: relationshipController.text.trim(),
      ));
    }
  }

  // ── Delete confirmation ─────────────────────────────────────

  Future<void> _confirmDelete(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Contact'),
        content: const Text('Are you sure you want to delete this contact?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _deleteContact(id);
    }
  }

  // ── Add contact dialog ──────────────────────────────────────

  void _showAddContactDialog() {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final relationshipController = TextEditingController();
    final messenger = ScaffoldMessenger.of(context);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
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
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final name = nameController.text.trim();
              final phone = phoneController.text.trim();
              final relationship = relationshipController.text.trim();

              if (name.isEmpty || phone.isEmpty || relationship.isEmpty) {
                messenger.showSnackBar(
                  const SnackBar(content: Text('Please fill all fields')),
                );
                return;
              }

              await ContactService.addContact(
                name: name,
                phoneNumber: phone,
                relationship: relationship,
              );
              await _loadContacts();

              if (!mounted) return;
              Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.red,
        onPressed: _showAddContactDialog,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: RefreshDragPopWidget(
        onRefresh: _loadContacts,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : contacts.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.people_outline, size: 64,
                            color: Colors.grey[400]),
                        const SizedBox(height: 12),
                        const Text(
                          'No emergency contacts yet',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Tap + to add your first contact',
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(0, 16, 0, 80),
                    itemCount: contacts.length,
                    itemBuilder: (context, index) {
                      final contact = contacts[index];
                      return ContactCard(
                        contact: contact,
                        onTap: () => _showContactDetail(contact),
                      );
                    },
                  ),
      ),
    );
  }
}
