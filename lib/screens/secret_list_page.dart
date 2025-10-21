import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/secret.dart';
import 'secret_edit_page.dart';
import 'secret_view_page.dart';

class SecretListPage extends StatefulWidget {
  const SecretListPage({super.key});

  @override
  State<SecretListPage> createState() => _SecretListPageState();
}

class _SecretListPageState extends State<SecretListPage> {
  late Box _secretBox;
  List<Secret> _secrets = [];

  @override
  void initState() {
    super.initState();
    _loadSecrets();
  }

  Future<void> _loadSecrets() async {
    _secretBox = Hive.box('secretum');
    _refreshSecrets();
  }

  void _refreshSecrets() {
    final List<Secret> secrets = [];

    for (var key in _secretBox.keys) {
      final data = _secretBox.get(key);
      if (data != null) {
        secrets.add(Secret.fromMap(Map<String, dynamic>.from(data)));
      }
    }

    // Sort by updated date (newest first)
    secrets.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

    setState(() {
      _secrets = secrets;
    });
  }

  String _formatDate(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp, isUtc: true);
    return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')} '
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')} GMT';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 8,
      ),
      body: _secrets.isEmpty
          ? const Center(
              child: Text(
                'No secrets yet\nTap + to create one',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white38,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _secrets.length,
              itemBuilder: (context, index) {
                final secret = _secrets[index];
                return Card(
                  color: const Color(0xFF2C2C2C),
                  margin: const EdgeInsets.only(bottom: 12.0),
                  child: InkWell(
                    onTap: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => SecretViewPage(secret: secret),
                        ),
                      );
                      // Refresh list when returning from view page
                      _refreshSecrets();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 12.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          Text(
                            secret.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          // Note
                          if (secret.note.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(
                              secret.note,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white60,
                              ),
                            ),
                          ],
                          const SizedBox(height: 8),
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
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const SecretEditPage(),
            ),
          );
          // Refresh list when returning from edit page
          _refreshSecrets();
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
