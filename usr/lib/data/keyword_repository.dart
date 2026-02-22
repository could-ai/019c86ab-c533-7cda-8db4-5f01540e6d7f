import 'package:supabase_flutter/supabase_flutter.dart';
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

  // Fetch data from Supabase with pagination, filtering, and sorting
  Future<List<KeywordItem>> fetchKeywords({
    required int page,
    required int limit,
    String? category,
    bool sortAlphabetical = true,
  }) async {
    try {
      final supabase = Supabase.instance.client;
      
      // Start building the query
      var query = supabase.from('keywords').select();

      // Apply Category Filter
      if (category != null && category != 'All') {
        query = query.eq('category', category);
      }

      // Apply Sorting
      if (sortAlphabetical) {
        query = query.order('keyword', ascending: true);
      } else {
        // Random sort is tricky in simple queries, usually we sort by ID or created_at if not alphabetical
        // Or we could sort by word_count for variety
        query = query.order('created_at', ascending: false);
      }

      // Apply Pagination (Range)
      final int from = page * limit;
      final int to = from + limit - 1;
      
      // Execute query
      final List<dynamic> response = await query.range(from, to);

      // Parse response
      return response.map((data) => KeywordItem.fromMap(data)).toList();
    } catch (e) {
      // In case of error (e.g., connection issues), return empty list or rethrow
      // For now, we print to console for debugging
      print('Error fetching keywords: $e');
      return [];
    }
  }
}
