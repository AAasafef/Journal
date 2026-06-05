class JournalEntryModel {
  final String id;
  final String title;
  final String content;
  final String summary;
  final List<String> keywords;
  final String category;
  final String mood;
  final bool isFavorite;
  final DateTime createdAt;
  final DateTime updatedAt;

  const JournalEntryModel({
    required this.id,
    required this.title,
    required this.content,
    required this.summary,
    required this.keywords,
    required this.category,
    required this.mood,
    required this.isFavorite,
    required this.createdAt,
    required this.updatedAt,
  });

  JournalEntryModel copyWith({
    String? id,
    String? title,
    String? content,
    String? summary,
    List<String>? keywords,
    String? category,
    String? mood,
    bool? isFavorite,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return JournalEntryModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      summary: summary ?? this.summary,
      keywords: keywords ?? this.keywords,
      category: category ?? this.category,
      mood: mood ?? this.mood,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'summary': summary,
      'keywords': keywords,
      'category': category,
      'mood': mood,
      'isFavorite': isFavorite,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory JournalEntryModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return JournalEntryModel(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      summary: json['summary'],
      keywords: List<String>.from(
        json['keywords'] ?? [],
      ),
      category: json['category'],
      mood: json['mood'],
      isFavorite: json['isFavorite'] ?? false,
      createdAt: DateTime.parse(
        json['createdAt'],
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'],
      ),
    );
  }
}
