import 'package:flutter/foundation.dart';
import '../models/recommended_person_model.dart';
import '../models/trending_topic_model.dart';
import '../models/tribe_model.dart';

class SearchProvider extends ChangeNotifier {
  List<RecommendedPersonModel> _recommendedPeople = [];
  List<TrendingTopicModel> _trendingTopics = [];
  List<TribeModel> _popularTribes = [];
  String _searchQuery = '';
  bool _isLoading = false;

  // Static data for now
  final List<RecommendedPersonModel> _staticPeople = [
    RecommendedPersonModel(
      id: '1',
      name: 'Alice Johnson',
      description: 'Podcasting and content creation for Youtube channel',
      profileImageUrl: '',
      isVerified: true,
    ),
    RecommendedPersonModel(
      id: '2',
      name: 'Bob Williams',
      description: 'Guitarist and content creation on Instagram',
      profileImageUrl: '',
      isVerified: false,
    ),
    RecommendedPersonModel(
      id: '3',
      name: 'Charlie Davis',
      description: 'FTik Tok videos and funny content',
      profileImageUrl: '',
      isVerified: false,
    ),
    RecommendedPersonModel(
      id: '4',
      name: 'Diana Miller',
      description: 'Content Strategy and Digital Marketing',
      profileImageUrl: '',
      isVerified: true,
    ),
  ];

  final List<TrendingTopicModel> _staticTopics = [
    TrendingTopicModel(
      id: '1',
      title: 'Podcasting',
      description: 'Script writing, Communication',
      iconUrl: '',
      tags: ['Script writing', 'Communication'],
    ),
    TrendingTopicModel(
      id: '2',
      title: 'Machine Learning',
      description: 'AI, Data Science, Algorithms',
      iconUrl: '',
      tags: ['AI', 'Data Science', 'Algorithms'],
    ),
    TrendingTopicModel(
      id: '3',
      title: 'Stocks and Trading',
      description: 'Crypto, Market trends and Analysis',
      iconUrl: '',
      tags: ['Crypto', 'Market trends', 'Analysis'],
    ),
  ];

  final List<TribeModel> _staticTribes = [
    TribeModel(
      id: '1',
      name: 'Goal Souls',
      description: 'Fitness, Gym, Running',
      iconUrl: '',
      memberCount: 2500,
      tags: ['Fitness', 'Gym', 'Running'],
    ),
    TribeModel(
      id: '2',
      name: 'Storytelling byData',
      description: 'Data science & Analysis',
      iconUrl: '',
      memberCount: 1800,
      tags: ['Data science', 'Analysis'],
    ),
    TribeModel(
      id: '3',
      name: 'FinTech Futures',
      description: 'Finance, Blockchain',
      iconUrl: '',
      memberCount: 3200,
      tags: ['Finance', 'Blockchain'],
    ),
  ];

  // Getters
  List<RecommendedPersonModel> get recommendedPeople =>
      _recommendedPeople.isEmpty ? _staticPeople : _recommendedPeople;
  List<TrendingTopicModel> get trendingTopics =>
      _trendingTopics.isEmpty ? _staticTopics : _trendingTopics;
  List<TribeModel> get popularTribes =>
      _popularTribes.isEmpty ? _staticTribes : _popularTribes;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;

  // Set search query
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
    if (query.isNotEmpty) {
      performSearch(query);
    }
  }

  // Set loading state
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Perform search
  Future<void> performSearch(String query) async {
    setLoading(true);
    try {
      // TODO: Implement API call
      // final response = await http.get(
      //   Uri.parse('YOUR_API_URL/search?q=$query')
      // );
      
      await Future.delayed(const Duration(milliseconds: 300));
      // For now, filter static data
      _recommendedPeople = _staticPeople
          .where((person) =>
              person.name.toLowerCase().contains(query.toLowerCase()) ||
              person.description.toLowerCase().contains(query.toLowerCase()))
          .toList();
      
      notifyListeners();
    } catch (e) {
      // Error searching
    } finally {
      setLoading(false);
    }
  }

  // Fetch recommendations
  Future<void> fetchRecommendations() async {
    setLoading(true);
    try {
      // TODO: Implement API call
      await Future.delayed(const Duration(milliseconds: 500));
      _recommendedPeople = _staticPeople;
      _trendingTopics = _staticTopics;
      _popularTribes = _staticTribes;
      notifyListeners();
    } catch (e) {
      // Error fetching recommendations
    } finally {
      setLoading(false);
    }
  }

  // Clear search
  void clearSearch() {
    _searchQuery = '';
    _recommendedPeople = _staticPeople;
    notifyListeners();
  }
}



