import 'package:flutter/foundation.dart';
import '../models/event_model.dart';

class EventsProvider extends ChangeNotifier {
  List<EventModel> _myEvents = [];
  List<EventModel> _upcomingEvents = [];
  String _searchQuery = '';
  bool _isLoading = false;

  // Static data for now
  final List<EventModel> _staticMyEvents = [
    EventModel(
      id: '1',
      title: 'Summer Music Fest',
      description: 'Experience an unforgettable day with live bands and vibrant crowds.',
      imageUrl: '',
      date: DateTime(2025, 10, 10),
      location: 'San Francisco, CA',
      participantAvatars: [],
      participantCount: 50,
      isRegistered: true,
      category: 'Music',
      organizer: 'MusicEvents Inc',
    ),
    EventModel(
      id: '2',
      title: 'Tech Conference',
      description: 'Connect with industry leaders and discover cutting-edge technology.',
      imageUrl: '',
      date: DateTime(2025, 11, 5),
      location: 'Austin, TX',
      participantAvatars: [],
      participantCount: 120,
      isRegistered: true,
      category: 'Technology',
      organizer: 'TechWorld',
    ),
  ];

  final List<EventModel> _staticUpcomingEvents = [
    EventModel(
      id: '3',
      title: 'Mountain Retreat',
      description: 'Rejuvenate your mind and body in a peaceful mountain setting.',
      imageUrl: '',
      date: DateTime(2025, 11, 15),
      location: 'Ooty, Tamil Nadu',
      participantAvatars: [],
      participantCount: 12,
      isRegistered: false,
      category: 'Wellness',
      organizer: 'Nature Retreats',
    ),
    EventModel(
      id: '4',
      title: 'Urban Art Walk',
      description: 'Explore contemporary street art and meet local artists.',
      imageUrl: '',
      date: DateTime(2025, 11, 20),
      location: 'Brooklyn, NY',
      participantAvatars: [],
      participantCount: 35,
      isRegistered: false,
      category: 'Art',
      organizer: 'ArtCity',
    ),
    EventModel(
      id: '5',
      title: 'Startup Pitch Night',
      description: 'Watch innovative startups present their ideas to investors.',
      imageUrl: '',
      date: DateTime(2025, 12, 1),
      location: 'Silicon Valley, CA',
      participantAvatars: [],
      participantCount: 80,
      isRegistered: false,
      category: 'Business',
      organizer: 'Startup Hub',
    ),
  ];

  // Getters
  List<EventModel> get myEvents =>
      _myEvents.isEmpty ? _staticMyEvents : _myEvents;
  List<EventModel> get upcomingEvents =>
      _upcomingEvents.isEmpty ? _staticUpcomingEvents : _upcomingEvents;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;

  // Set search query
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
    if (query.isNotEmpty) {
      searchEvents(query);
    }
  }

  // Set loading state
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Fetch my events
  Future<void> fetchMyEvents() async {
    setLoading(true);
    try {
      // TODO: Implement API call
      // final response = await http.get(
      //   Uri.parse('YOUR_API_URL/events/my-events'),
      //   headers: {'Authorization': 'Bearer $token'},
      // );
      
      await Future.delayed(const Duration(milliseconds: 500));
      _myEvents = _staticMyEvents;
      notifyListeners();
    } catch (e) {
      // Error fetching my events
    } finally {
      setLoading(false);
    }
  }

  // Fetch upcoming events
  Future<void> fetchUpcomingEvents() async {
    setLoading(true);
    try {
      // TODO: Implement API call
      // final response = await http.get(
      //   Uri.parse('YOUR_API_URL/events/upcoming'),
      // );
      
      await Future.delayed(const Duration(milliseconds: 500));
      _upcomingEvents = _staticUpcomingEvents;
      notifyListeners();
    } catch (e) {
      // Error fetching upcoming events
    } finally {
      setLoading(false);
    }
  }

  // Search events
  Future<void> searchEvents(String query) async {
    setLoading(true);
    try {
      // TODO: Implement API call
      // final response = await http.get(
      //   Uri.parse('YOUR_API_URL/events/search?q=$query'),
      // );
      
      await Future.delayed(const Duration(milliseconds: 300));
      // For now, filter static data
      final allEvents = [..._staticMyEvents, ..._staticUpcomingEvents];
      final filtered = allEvents
          .where((event) =>
              event.title.toLowerCase().contains(query.toLowerCase()) ||
              event.location.toLowerCase().contains(query.toLowerCase()) ||
              event.category.toLowerCase().contains(query.toLowerCase()))
          .toList();
      
      _upcomingEvents = filtered;
      notifyListeners();
    } catch (e) {
      // Error searching events
    } finally {
      setLoading(false);
    }
  }

  // Register for event
  Future<void> registerForEvent(String eventId) async {
    try {
      // TODO: Implement API call
      // final response = await http.post(
      //   Uri.parse('YOUR_API_URL/events/$eventId/register'),
      //   headers: {'Authorization': 'Bearer $token'},
      // );
      
      await Future.delayed(const Duration(milliseconds: 300));
      
      // Update local state
      final eventIndex = _upcomingEvents.indexWhere((e) => e.id == eventId);
      if (eventIndex != -1) {
        _upcomingEvents[eventIndex] = _upcomingEvents[eventIndex].copyWith(
          isRegistered: true,
        );
        // Move to my events
        _myEvents.add(_upcomingEvents[eventIndex]);
        notifyListeners();
      }
    } catch (e) {
      // Error registering for event
    }
  }

  // Unregister from event
  Future<void> unregisterFromEvent(String eventId) async {
    try {
      // TODO: Implement API call
      // final response = await http.delete(
      //   Uri.parse('YOUR_API_URL/events/$eventId/unregister'),
      //   headers: {'Authorization': 'Bearer $token'},
      // );
      
      await Future.delayed(const Duration(milliseconds: 300));
      
      // Update local state
      _myEvents.removeWhere((e) => e.id == eventId);
      notifyListeners();
    } catch (e) {
      // Error unregistering from event
    }
  }

  // View event details
  void viewEventDetails(String eventId) {
    // TODO: Navigate to event details page
  }

  // Clear search
  void clearSearch() {
    _searchQuery = '';
    _upcomingEvents = _staticUpcomingEvents;
    notifyListeners();
  }

  // Fetch all events
  Future<void> fetchAllEvents() async {
    await Future.wait([
      fetchMyEvents(),
      fetchUpcomingEvents(),
    ]);
  }
}



