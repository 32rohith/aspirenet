import 'package:flutter/foundation.dart';
import '../models/user_profile_model.dart';
import '../models/filter_model.dart';

enum DiscoverLayout { grid, list }

class DiscoverProvider extends ChangeNotifier {
  DiscoverLayout _currentLayout = DiscoverLayout.grid;
  List<UserProfileModel> _suggestedProfiles = [];
  final List<String> _likedProfiles = [];
  bool _isLoading = false;
  String _searchQuery = '';
  FilterModel _currentFilter = FilterModel();

  // Static data for now - will be replaced with API calls
  final List<UserProfileModel> _staticProfiles = [
    UserProfileModel(
      id: '1',
      name: 'Maya',
      age: 24,
      title: 'Aspiring Musician',
      location: 'Los Angeles, CA',
      bio: 'Passionate about creating melodies that touch souls. Looking for collaborators to produce amazing music together.',
      profileImageUrl: '',
      skills: ['Music', 'Singing', 'Guitar'],
      followers: 1200,
      isVerified: false,
    ),
    UserProfileModel(
      id: '2',
      name: 'Ethan',
      age: 28,
      title: 'Creative Entrepreneur',
      location: 'San Francisco, CA',
      bio: 'Building innovative startups and helping others achieve their entrepreneurial dreams.',
      profileImageUrl: '',
      skills: ['Business', 'Marketing', 'Leadership'],
      followers: 3400,
      isVerified: true,
    ),
    UserProfileModel(
      id: '3',
      name: 'Chloe',
      age: 22,
      title: 'Digital Artist',
      location: 'New York, NY',
      bio: 'Creating stunning digital art and illustrations. Open to collaborations and commissions.',
      profileImageUrl: '',
      skills: ['Digital Art', 'Illustration', 'Design'],
      followers: 2100,
      isVerified: false,
    ),
    UserProfileModel(
      id: '4',
      name: 'Liam',
      age: 26,
      title: 'Fitness Enthusiast',
      location: 'Miami, FL',
      bio: 'Helping people transform their lives through fitness. Personal trainer and nutrition coach.',
      profileImageUrl: '',
      skills: ['Fitness', 'Nutrition', 'Coaching'],
      followers: 5600,
      isVerified: true,
    ),
    UserProfileModel(
      id: '5',
      name: 'Sophia',
      age: 25,
      title: 'Activist & Leader',
      location: 'Seattle, WA',
      bio: 'Fighting for social justice and environmental causes. Join me in making a difference.',
      profileImageUrl: '',
      skills: ['Leadership', 'Public Speaking', 'Community Building'],
      followers: 4200,
      isVerified: true,
    ),
    UserProfileModel(
      id: '6',
      name: 'Noah',
      age: 23,
      title: 'Indie Game Developer',
      location: 'Austin, TX',
      bio: 'Creating immersive gaming experiences. Always looking for talented developers and artists.',
      profileImageUrl: '',
      skills: ['Game Dev', 'Unity', 'C#'],
      followers: 2800,
      isVerified: false,
    ),
    UserProfileModel(
      id: '7',
      name: 'Evelyn Reed',
      age: 21,
      title: 'Software Engineer',
      location: 'San Francisco, CA',
      bio: 'Aspiring software engineer passionate about AI, ethics and sustainable tech. Love coding, hiking, and exploring local music scenes.',
      profileImageUrl: '',
      skills: ['Coding', 'Coffee', 'AI'],
      followers: 1042,
      isVerified: true,
    ),
    UserProfileModel(
      id: '8',
      name: 'Kai Sharma',
      age: 22,
      title: 'Film Student',
      location: 'Charleston, CA',
      bio: 'Film studies major with a knack for visual storytelling. Always looking for new narratives and unique perspectives.',
      profileImageUrl: '',
      skills: ['Photography', 'Art History', 'Indie Cinema'],
      followers: 2043,
      isVerified: false,
    ),
    UserProfileModel(
      id: '9',
      name: 'Lena Petrova',
      age: 20,
      title: 'Fashion Design Student',
      location: 'New York, NY',
      bio: 'Fashion design student with a focus on upcycling and streetwear. Passionate about sustainability and style.',
      profileImageUrl: '',
      skills: ['Fashion Design', 'Upcycling', 'Streetwear'],
      followers: 3024,
      isVerified: false,
    ),
  ];

  // Getters
  DiscoverLayout get currentLayout => _currentLayout;
  List<UserProfileModel> get suggestedProfiles =>
      _suggestedProfiles.isEmpty ? _staticProfiles : _suggestedProfiles;
  List<String> get likedProfiles => _likedProfiles;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  bool get isGridLayout => _currentLayout == DiscoverLayout.grid;
  FilterModel get currentFilter => _currentFilter;
  bool get hasActiveFilters => _currentFilter.hasActiveFilters;

  // Toggle layout
  void toggleLayout() {
    _currentLayout = _currentLayout == DiscoverLayout.grid
        ? DiscoverLayout.list
        : DiscoverLayout.grid;
    notifyListeners();
  }

  // Set layout
  void setLayout(DiscoverLayout layout) {
    _currentLayout = layout;
    notifyListeners();
  }

  // Search
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
    // TODO: Implement search API call
  }

  // Like profile
  void likeProfile(String profileId) {
    if (!_likedProfiles.contains(profileId)) {
      _likedProfiles.add(profileId);
      notifyListeners();
    }
  }

  // Unlike profile
  void unlikeProfile(String profileId) {
    _likedProfiles.remove(profileId);
    notifyListeners();
  }

  // Check if profile is liked
  bool isProfileLiked(String profileId) {
    return _likedProfiles.contains(profileId);
  }

  // Set loading state
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Future methods for backend integration
  Future<void> fetchSuggestedProfiles() async {
    setLoading(true);
    try {
      // TODO: Implement API call
      // final response = await http.get(Uri.parse('YOUR_API_URL/discover/suggested'));
      // final data = json.decode(response.body);
      // _suggestedProfiles = (data as List)
      //     .map((profile) => UserProfileModel.fromJson(profile))
      //     .toList();
      
      // For now, using static data
      await Future.delayed(const Duration(milliseconds: 500));
      _suggestedProfiles = _staticProfiles;
    } catch (e) {
      // Error fetching profiles - will be replaced with proper error handling
    } finally {
      setLoading(false);
    }
  }

  Future<void> searchProfiles(String query) async {
    setLoading(true);
    try {
      // TODO: Implement API call
      // final response = await http.get(
      //   Uri.parse('YOUR_API_URL/discover/search?q=$query')
      // );
      
      await Future.delayed(const Duration(milliseconds: 300));
    } catch (e) {
      // Error searching profiles - will be replaced with proper error handling
    } finally {
      setLoading(false);
    }
  }

  Future<void> connectWithSimilarInterests() async {
    // TODO: Implement API call for connecting with similar interests
  }

  Future<void> connectWithComplementarySkills() async {
    // TODO: Implement API call for connecting with complementary skills
  }

  Future<void> viewProfile(String profileId) async {
    // TODO: Implement navigation to profile details
  }

  // Filter methods
  void applyFilters({
    required String filterType,
    required List<String> skills,
    required String location,
    required String projectDomain,
    required int availabilityHours,
  }) {
    _currentFilter = FilterModel(
      filterType: filterType,
      skills: skills,
      location: location,
      projectDomain: projectDomain,
      availabilityHours: availabilityHours,
    );
    notifyListeners();
    
    // TODO: Implement API call with filters
    fetchFilteredProfiles();
  }

  void resetFilters() {
    _currentFilter = FilterModel();
    notifyListeners();
    
    // Refresh profiles without filters
    fetchSuggestedProfiles();
  }

  Future<void> fetchFilteredProfiles() async {
    setLoading(true);
    try {
      // TODO: Implement API call with filter parameters
      // final response = await http.post(
      //   Uri.parse('YOUR_API_URL/discover/filter'),
      //   body: json.encode(_currentFilter.toJson()),
      // );
      
      await Future.delayed(const Duration(milliseconds: 500));
      // For now, just reload the same data
      _suggestedProfiles = _staticProfiles;
    } catch (e) {
      // Error fetching filtered profiles
    } finally {
      setLoading(false);
    }
  }
}

