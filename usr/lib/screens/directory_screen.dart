import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/keyword_repository.dart';
import '../models/keyword_item.dart';

class DirectoryScreen extends StatefulWidget {
  const DirectoryScreen({super.key});

  @override
  State<DirectoryScreen> createState() => _DirectoryScreenState();
}

class _DirectoryScreenState extends State<DirectoryScreen> {
  final KeywordRepository _repository = KeywordRepository();
  final ScrollController _scrollController = ScrollController();

  List<KeywordItem> _keywords = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 0;
  final int _limit = 20;

  String? _selectedCategory;
  bool _sortAlphabetical = true;

  @override
  void initState() {
    super.initState();
    _loadMoreData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 &&
        !_isLoading &&
        _hasMore) {
      _loadMoreData();
    }
  }

  Future<void> _loadMoreData() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final newItems = await _repository.fetchKeywords(
        page: _currentPage,
        limit: _limit,
        category: _selectedCategory,
        sortAlphabetical: _sortAlphabetical,
      );

      setState(() {
        _keywords.addAll(newItems);
        _currentPage++;
        _isLoading = false;
        if (newItems.length < _limit) {
          _hasMore = false;
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Handle error
    }
  }

  void _resetAndReload() {
    setState(() {
      _keywords.clear();
      _currentPage = 0;
      _hasMore = true;
      _isLoading = false;
    });
    _loadMoreData();
  }

  void _onCategorySelected(String? category) {
    if (_selectedCategory == category) return;
    _selectedCategory = category;
    _resetAndReload();
  }

  void _toggleSort() {
    _sortAlphabetical = !_sortAlphabetical;
    _resetAndReload();
  }

  @override
  Widget build(BuildContext context) {
    // Determine if we are on a wide screen (Web/Desktop) or mobile
    final isWideScreen = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.search, color: Colors.blue),
            const SizedBox(width: 10),
            const Text(
              'inurl: Directory',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(_sortAlphabetical ? Icons.sort_by_alpha : Icons.shuffle),
            tooltip: 'Sort Alphabetically',
            onPressed: _toggleSort,
          ),
          const SizedBox(width: 16),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Colors.grey.shade200, height: 1.0),
        ),
      ),
      body: Row(
        children: [
          // Sidebar for Categories (Visible on Wide Screens)
          if (isWideScreen)
            Container(
              width: 250,
              decoration: BoxDecoration(
                border: Border(right: BorderSide(color: Colors.grey.shade200)),
              ),
              child: _buildCategoryList(),
            ),

          // Main Content Area
          Expanded(
            child: Column(
              children: [
                // Mobile Category Filter (Dropdown or Horizontal List)
                if (!isWideScreen)
                  SizedBox(
                    height: 60,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      children: [
                        _buildMobileCategoryChip(null, 'All'),
                        ...KeywordRepository.categories.map((cat) => 
                          _buildMobileCategoryChip(cat, cat)
                        ),
                      ],
                    ),
                  ),

                // Keyword List
                Expanded(
                  child: _keywords.isEmpty && !_isLoading
                      ? const Center(child: Text('No keywords found.'))
                      : ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(16),
                          itemCount: _keywords.length + (_hasMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == _keywords.length) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }

                            final item = _keywords[index];
                            return _buildKeywordCard(item);
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
      // Drawer for mobile categories if preferred, but horizontal list is used above
    );
  }

  Widget _buildCategoryList() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'CATEGORIES',
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 10),
        _buildCategoryTile(null, 'All Keywords'),
        ...KeywordRepository.categories.map((cat) => _buildCategoryTile(cat, cat)),
      ],
    );
  }

  Widget _buildCategoryTile(String? categoryValue, String title) {
    final isSelected = _selectedCategory == categoryValue;
    return ListTile(
      title: Text(title),
      selected: isSelected,
      selectedColor: Colors.blue,
      selectedTileColor: Colors.blue.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      onTap: () => _onCategorySelected(categoryValue),
      leading: Icon(
        isSelected ? Icons.folder_open : Icons.folder,
        color: isSelected ? Colors.blue : Colors.grey,
      ),
    );
  }

  Widget _buildMobileCategoryChip(String? categoryValue, String label) {
    final isSelected = _selectedCategory == categoryValue;
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => _onCategorySelected(categoryValue),
        backgroundColor: Colors.white,
        selectedColor: Colors.blue.shade100,
        labelStyle: TextStyle(
          color: isSelected ? Colors.blue.shade900 : Colors.black87,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected ? Colors.blue : Colors.grey.shade300,
          ),
        ),
      ),
    );
  }

  Widget _buildKeywordCard(KeywordItem item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'inurl:',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Courier',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    item.keyword,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Courier',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.copy, size: 20, color: Colors.grey),
                  tooltip: 'Copy to clipboard',
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: item.fullQuery));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Copied: ${item.fullQuery}'),
                        duration: const Duration(seconds: 1),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              item.description,
              style: TextStyle(color: Colors.grey.shade700),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.label_outline, size: 16, color: Colors.grey.shade500),
                const SizedBox(width: 4),
                Text(
                  item.category,
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 12,
                  ),
                ),
                const Spacer(),
                Text(
                  '${item.wordCount} words',
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
