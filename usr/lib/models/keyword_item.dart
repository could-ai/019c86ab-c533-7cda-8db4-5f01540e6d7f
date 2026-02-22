class KeywordItem {
  final int? id;
  final String keyword;
  final String category;
  final String description;
  final int wordCount;

  KeywordItem({
    this.id,
    required this.keyword,
    required this.category,
    required this.description,
    required this.wordCount,
  });

  // Helper to get the full operator string
  String get fullQuery => 'inurl:$keyword';

  // Factory constructor to create a KeywordItem from a Map (Supabase response)
  factory KeywordItem.fromMap(Map<String, dynamic> map) {
    return KeywordItem(
      id: map['id'] as int?,
      keyword: map['keyword'] as String,
      category: map['category'] as String,
      description: map['description'] as String? ?? '',
      wordCount: map['word_count'] as int? ?? 0,
    );
  }

  // Convert KeywordItem to Map (for inserting/updating if needed later)
  Map<String, dynamic> toMap() {
    return {
      'keyword': keyword,
      'category': category,
      'description': description,
      'word_count': wordCount,
    };
  }
}
