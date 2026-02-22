class KeywordItem {
  final String keyword;
  final String category;
  final String description;
  final int wordCount;

  KeywordItem({
    required this.keyword,
    required this.category,
    required this.description,
    required this.wordCount,
  });

  // Helper to get the full operator string
  String get fullQuery => 'inurl:$keyword';
}
