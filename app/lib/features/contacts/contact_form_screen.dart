import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_color.dart';
import '../../core/models/emergency_contact.dart';
import '../../core/services/storage_service.dart';

class ContactFormScreen extends StatefulWidget {
  final String? contactId;

  const ContactFormScreen({super.key, this.contactId});

  @override
  State<ContactFormScreen> createState() => _ContactFormScreenState();
}

class _ContactFormScreenState extends State<ContactFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _relationshipController = TextEditingController();
  bool _isPriority = false;
  bool _loading = true;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.contactId != null;
    if (_isEditing) {
      _loadContact();
    } else {
      setState(() => _loading = false);
    }
  }

  Future<void> _loadContact() async {
    final contacts = await StorageService.loadContacts();
    final contact = contacts.where((c) => c.id == widget.contactId).firstOrNull;
    if (contact != null && mounted) {
      _nameController.text = contact.name;
      _phoneController.text = contact.phone;
      _relationshipController.text = contact.relationship ?? '';
      _isPriority = contact.isPriority;
    }
    if (mounted) setState(() => _loading = false);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _relationshipController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final contact = EmergencyContact(
      id: _isEditing
          ? widget.contactId!
          : DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      relationship: _relationshipController.text.trim().isNotEmpty
          ? _relationshipController.text.trim()
          : null,
      isPriority: _isPriority,
    );

    if (_isEditing) {
      await StorageService.updateContact(contact);
    } else {
      await StorageService.addContact(contact);
    }

    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Contact' : 'Add Contact'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.red))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Label('Full Name', onSurface),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _nameController,
                      textInputAction: TextInputAction.next,
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Please enter a name' : null,
                      decoration: const InputDecoration(hintText: 'Enter full name'),
                    ),
                    const SizedBox(height: 20),
                    _Label('Phone Number', onSurface),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Please enter a phone number' : null,
                      decoration: const InputDecoration(hintText: 'Enter phone number'),
                    ),
                    const SizedBox(height: 20),
                    _Label('Relationship (optional)', onSurface),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _relationshipController,
                      textInputAction: TextInputAction.done,
                      decoration: const InputDecoration(
                          hintText: 'e.g. Father, Mother, Sibling'),
                    ),
                    const SizedBox(height: 24),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppColors.red.withValues(alpha: 0.12),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.star_rounded,
                                  color: AppColors.red, size: 22),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Priority Contact',
                                      style: TextStyle(
                                          color: onSurface,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600)),
                                  Text('Show at the top of your contacts list',
                                      style: theme.textTheme.bodyMedium),
                                ],
                              ),
                            ),
                            Switch(
                              value: _isPriority,
                              onChanged: (val) => setState(() => _isPriority = val),
                              activeTrackColor: AppColors.red,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _save,
                        child: Text(
                          _isEditing ? 'Update Contact' : 'Save Contact',
                          style: const TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  final Color color;
  const _Label(this.text, this.color);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: TextStyle(
            color: color, fontSize: 14, fontWeight: FontWeight.w600));
  }
}
