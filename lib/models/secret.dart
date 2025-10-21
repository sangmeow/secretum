class Secret {
  final String id;
  final String title;
  final String note;
  final int createdAt;
  final int updatedAt;

  Secret({
    required this.id,
    required this.title,
    required this.note,
    required this.createdAt,
    required this.updatedAt,
  });

  // Convert Secret to Map for Hive storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'note': note,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  // Create Secret from Map
  factory Secret.fromMap(Map<String, dynamic> map) {
    return Secret(
      id: map['id'] as String,
      title: map['title'] as String,
      note: map['note'] as String,
      createdAt: map['created_at'] as int,
      updatedAt: map['updated_at'] as int,
    );
  }
}
