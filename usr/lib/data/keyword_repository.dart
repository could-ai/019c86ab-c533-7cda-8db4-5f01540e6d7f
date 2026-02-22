import '../models/keyword_item.dart';

class KeywordRepository {
  // Categories
  static const String catEcommerce = 'E-commerce';
  static const String catAdmin = 'Admin & Login';
  static const String catContent = 'Guest Post & Blogs';
  static const String catFiles = 'Files & Directories';
  static const String catForum = 'Forums & Communities';

  static final List<String> categories = [
    catEcommerce,
    catAdmin,
    catContent,
    catFiles,
    catForum,
  ];

  // Mock Data Generator
  // In a real app, this would come from a database (Supabase)
  static List<KeywordItem> _generateMockData() {
    return [
      // E-commerce
      KeywordItem(keyword: 'view/cart', category: catEcommerce, description: 'Finds shopping cart pages', wordCount: 2),
      KeywordItem(keyword: 'shop/category', category: catEcommerce, description: 'Specific shop categories', wordCount: 2),
      KeywordItem(keyword: 'product-tag', category: catEcommerce, description: 'Product tagging pages', wordCount: 2),
      KeywordItem(keyword: 'checkout/shipping', category: catEcommerce, description: 'Shipping checkout steps', wordCount: 2),
      KeywordItem(keyword: 'store/item', category: catEcommerce, description: 'Individual store items', wordCount: 2),
      
      // Admin
      KeywordItem(keyword: 'admin/login', category: catAdmin, description: 'Administrative login portals', wordCount: 2),
      KeywordItem(keyword: 'wp-admin', category: catAdmin, description: 'WordPress admin dashboard', wordCount: 2),
      KeywordItem(keyword: 'user/register', category: catAdmin, description: 'User registration pages', wordCount: 2),
      KeywordItem(keyword: 'forgot-password', category: catAdmin, description: 'Password recovery pages', wordCount: 2),
      KeywordItem(keyword: 'secure/login', category: catAdmin, description: 'Secure login areas', wordCount: 2),

      // Content / Guest Post
      KeywordItem(keyword: 'write-for-us', category: catContent, description: 'Guest posting opportunities', wordCount: 3),
      KeywordItem(keyword: 'submit-guest-post', category: catContent, description: 'Direct submission pages', wordCount: 3),
      KeywordItem(keyword: 'blog/category', category: catContent, description: 'Blog category archives', wordCount: 2),
      KeywordItem(keyword: 'author/name', category: catContent, description: 'Author profile pages', wordCount: 2),
      KeywordItem(keyword: 'category/news', category: catContent, description: 'News specific categories', wordCount: 2),

      // Files
      KeywordItem(keyword: 'wp-content/uploads', category: catFiles, description: 'WordPress upload directories', wordCount: 3),
      KeywordItem(keyword: 'index-of', category: catFiles, description: 'Open directory listings', wordCount: 2),
      KeywordItem(keyword: 'documents/pdf', category: catFiles, description: 'PDF document folders', wordCount: 2),
      KeywordItem(keyword: 'images/public', category: catFiles, description: 'Public image folders', wordCount: 2),
      
      // Forums
      KeywordItem(keyword: 'viewtopic', category: catForum, description: 'Forum topic views (phpBB etc)', wordCount: 1),
      KeywordItem(keyword: 'showthread', category: catForum, description: 'Show thread pages (vBulletin)', wordCount: 1),
      KeywordItem(keyword: 'forum/index', category: catForum, description: 'Main forum index pages', wordCount: 2),
      KeywordItem(keyword: 'member-profile', category: catForum, description: 'Member profile pages', wordCount: 2),
    ];
  }

  // Simulate fetching data with pagination
  Future<List<KeywordItem>> fetchKeywords({
    required int page,
    required int limit,
    String? category,
    bool sortAlphabetical = true,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    List<KeywordItem> allItems = [];
    // Generate enough data to scroll
    // We duplicate the base list to simulate a large database
    var baseList = _generateMockData();
    for (int i = 0; i < 10; i++) {
      allItems.addAll(baseList.map((e) => KeywordItem(
        keyword: '${e.keyword}-${i > 0 ? i : ""}'.replaceAll(RegExp(r'-$'), ''), 
        category: e.category, 
        description: e.description,
        wordCount: e.wordCount
      )));
    }

    // Filter
    if (category != null) {
      allItems = allItems.where((item) => item.category == category).toList();
    }

    // Sort
    if (sortAlphabetical) {
      allItems.sort((a, b) => a.keyword.compareTo(b.keyword));
    }

    // Paginate
    int startIndex = page * limit;
    if (startIndex >= allItems.length) return [];

    int endIndex = startIndex + limit;
    if (endIndex > allItems.length) endIndex = allItems.length;

    return allItems.sublist(startIndex, endIndex);
  }
}
