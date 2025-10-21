import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/secret.dart';

class SecretEditPage extends StatefulWidget {
  final Secret? secret;

  const SecretEditPage({super.key, this.secret});

  @override
  State<SecretEditPage> createState() => _SecretEditPageState();
}

class _SecretEditPageState extends State<SecretEditPage> {
  final _titleController = TextEditingController();
  final _noteController = TextEditingController();
  final _titleFocusNode = FocusNode();
  final _noteFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // If editing existing secret, populate fields
    if (widget.secret != null) {
      _titleController.text = widget.secret!.title;
      _noteController.text = widget.secret!.note;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    _titleFocusNode.dispose();
    _noteFocusNode.dispose();
    super.dispose();
  }

  void _cancel() {
    Navigator.of(context).pop();
  }

  Future<void> _save() async {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a title'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    try {
      // Get Hive box
      final box = Hive.box('secretum');

      final Secret secret;
      final String id;

      final now = DateTime.now().toUtc().millisecondsSinceEpoch;

      if (widget.secret != null) {
        // Updating existing secret
        id = widget.secret!.id;
        secret = Secret(
          id: id,
          title: _titleController.text.trim(),
          note: _noteController.text.trim(),
          createdAt: widget.secret!.createdAt, // Keep original creation time
          updatedAt: now, // Update modification time
        );
      } else {
        // Creating new secret
        const uuid = Uuid();
        id = uuid.v4();
        secret = Secret(
          id: id,
          title: _titleController.text.trim(),
          note: _noteController.text.trim(),
          createdAt: now,
          updatedAt: now, // Same as creation time for new secrets
        );
      }

      // Save to Hive with UUID as key
      await box.put(id, secret.toMap());

      // Navigate back without showing success message
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      // Show error message only on failure
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving secret: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            onPressed: _cancel,
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: _save,
            child: Text(
              'Save',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24.0),
          children: [
            // Title Input
            TextField(
              controller: _titleController,
              focusNode: _titleFocusNode,
              autofocus: true,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              decoration: const InputDecoration(
                hintText: 'Title',
                hintStyle: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white38,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 8),
              ),
              textCapitalization: TextCapitalization.sentences,
            ),

            const SizedBox(height: 8),

            // Divider
            Container(
              height: 1,
              color: Colors.white12,
            ),

            const SizedBox(height: 24),

            // Note Input
            TextField(
              controller: _noteController,
              focusNode: _noteFocusNode,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                height: 1.5,
              ),
              decoration: const InputDecoration(
                hintText: 'Start typing your secret note...',
                hintStyle: TextStyle(
                  fontSize: 16,
                  color: Colors.white38,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              maxLines: null,
              keyboardType: TextInputType.multiline,
              textCapitalization: TextCapitalization.sentences,
            ),
          ],
        ),
      ),
    );
  }
}
