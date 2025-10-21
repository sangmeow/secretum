import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/secret.dart';
import 'secret_edit_page.dart';

/// View page for displaying a secret's content
/// Read-only view with edit button in app bar
class SecretViewPage extends StatelessWidget {
  final Secret secret;

  const SecretViewPage({super.key, required this.secret});

  String _formatDate(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp, isUtc: true);
    return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')} '
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')} GMT';
  }

  Future<void> _deleteSecret(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2C2C2C),
          title: const Text(
            'Delete Secret',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'Are you sure you want to delete this secret? This action cannot be undone.',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white70),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed == true && context.mounted) {
      final box = Hive.box('secretum');
      await box.delete(secret.id);

      if (context.mounted) {
        Navigator.of(context).pop(true);
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
        leadingWidth: 80,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: TextButton(
            onPressed: () => _deleteSecret(context),
            child: const Text(
              'Delete',
              style: TextStyle(
                fontSize: 16,
                color: Colors.red,
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Back',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: () async {
              // Navigate to edit page
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SecretEditPage(secret: secret),
                ),
              );
              // Pop back to list after editing
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            },
            child: const Text(
              'Edit',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24.0, 4.0, 24.0, 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date Row
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    _formatDate(secret.updatedAt),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white38,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Title
              Text(
                secret.title,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 24),

              // Divider
              Container(
                height: 1,
                color: Colors.white12,
              ),

              const SizedBox(height: 24),

              // Note content
              Text(
                secret.note.isNotEmpty ? secret.note : 'No content',
                style: TextStyle(
                  fontSize: 16,
                  color: secret.note.isNotEmpty ? Colors.white : Colors.white38,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
