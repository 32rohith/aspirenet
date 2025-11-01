import 'package:flutter/foundation.dart';
import '../models/conversation_model.dart';
import '../models/message_model.dart';

class MessagesProvider extends ChangeNotifier {
  List<ConversationModel> _conversations = [];
  final Map<String, List<MessageModel>> _messages = {};
  String _searchQuery = '';
  bool _isLoading = false;
  String? _currentConversationId;

  // Static data
  final List<ConversationModel> _staticConversations = [
    ConversationModel(
      id: '1',
      name: 'Danny',
      lastMessage: 'Hey, I\'m excited about our proj',
      lastMessageTime: DateTime.now().subtract(const Duration(minutes: 30)),
      unreadCount: 2,
      isOnline: true,
      participantIds: ['user1'],
      participantNames: ['Danny'],
      type: ConversationType.direct,
    ),
    ConversationModel(
      id: '2',
      name: 'Project Alpha',
      lastMessage: 'New update on the backend syster',
      lastMessageTime: DateTime.now().subtract(const Duration(days: 1)),
      unreadCount: 1,
      isGroup: true,
      participantIds: ['user2', 'user3', 'user4'],
      participantNames: ['Alice', 'Bob', 'Carol'],
      type: ConversationType.group,
    ),
    ConversationModel(
      id: '3',
      name: 'Jane Smith',
      lastMessage: 'Let\'s review the mockups for t',
      lastMessageTime: DateTime.now().subtract(const Duration(days: 2)),
      unreadCount: 0,
      isOnline: false,
      participantIds: ['user5'],
      participantNames: ['Jane Smith'],
      type: ConversationType.direct,
    ),
    ConversationModel(
      id: '4',
      name: 'Design Crew',
      lastMessage: 'Finalizing the icon set for the nex',
      lastMessageTime: DateTime(2025, 10, 1),
      unreadCount: 3,
      isGroup: true,
      participantIds: ['user6', 'user7'],
      participantNames: ['Designer1', 'Designer2'],
      type: ConversationType.group,
    ),
    ConversationModel(
      id: '5',
      name: 'Sarah Johnson (Mentor)',
      lastMessage: 'Remember to submit your weekly',
      lastMessageTime: DateTime(2024, 12, 15),
      unreadCount: 0,
      isOnline: true,
      participantIds: ['user8'],
      participantNames: ['Sarah Johnson'],
      type: ConversationType.direct,
    ),
  ];

  final Map<String, List<MessageModel>> _staticMessages = {
    '1': [
      MessageModel(
        id: 'm1',
        conversationId: '1',
        senderId: 'me',
        senderName: 'Me',
        senderAvatar: '',
        content: 'Hey Danny, I just finished the report. It looks great!',
        timestamp: DateTime.now().subtract(const Duration(minutes: 35)),
        isRead: true,
      ),
      MessageModel(
        id: 'm2',
        conversationId: '1',
        senderId: 'user1',
        senderName: 'Danny',
        senderAvatar: '',
        content: 'That\'s fantastic! Can you send it over for a quick review?',
        timestamp: DateTime.now().subtract(const Duration(minutes: 34)),
        isRead: true,
      ),
      MessageModel(
        id: 'm3',
        conversationId: '1',
        senderId: 'me',
        senderName: 'Me',
        senderAvatar: '',
        content: 'Sure, just sent it. Let me know if you need any adjustments.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 33)),
        isRead: true,
      ),
      MessageModel(
        id: 'm4',
        conversationId: '1',
        senderId: 'user1',
        senderName: 'Danny',
        senderAvatar: '',
        content: 'Got it. I\'ll take a look this afternoon and get back to you. Thanks!',
        timestamp: DateTime.now().subtract(const Duration(minutes: 32)),
        isRead: true,
      ),
      MessageModel(
        id: 'm5',
        conversationId: '1',
        senderId: 'me',
        senderName: 'Me',
        senderAvatar: '',
        content: 'No problem! Looking forward to your feedback.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 31)),
        isRead: true,
      ),
      MessageModel(
        id: 'm6',
        conversationId: '1',
        senderId: 'user1',
        senderName: 'Danny',
        senderAvatar: '',
        content: 'I was also thinking about the new project. I have a few ideas that might enhance our presentation. Are you free for a quick call tomorrow?',
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        isRead: false,
      ),
      MessageModel(
        id: 'm7',
        conversationId: '1',
        senderId: 'me',
        senderName: 'Me',
        senderAvatar: '',
        content: 'Absolutely! I\'m available after 10 AM. Let me know what time works best for you.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 29)),
        isRead: false,
      ),
      MessageModel(
        id: 'm8',
        conversationId: '1',
        senderId: 'user1',
        senderName: 'Danny',
        senderAvatar: '',
        content: 'Perfect! How about 11 AM? I\'ll send an invite.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 28)),
        isRead: false,
      ),
    ],
  };

  // Getters
  List<ConversationModel> get conversations =>
      _conversations.isEmpty ? _staticConversations : _conversations;
  List<MessageModel> getMessages(String conversationId) =>
      _messages[conversationId] ?? _staticMessages[conversationId] ?? [];
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;
  String? get currentConversationId => _currentConversationId;
  int get totalUnreadCount =>
      conversations.fold(0, (sum, conv) => sum + conv.unreadCount);

  // Set current conversation
  void setCurrentConversation(String? conversationId) {
    _currentConversationId = conversationId;
    if (conversationId != null) {
      markConversationAsRead(conversationId);
    }
    notifyListeners();
  }

  // Search conversations
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // Set loading
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Fetch conversations
  Future<void> fetchConversations() async {
    setLoading(true);
    try {
      // TODO: Implement API call
      // final response = await http.get(
      //   Uri.parse('YOUR_API_URL/messages/conversations'),
      // );
      
      await Future.delayed(const Duration(milliseconds: 500));
      _conversations = _staticConversations;
      notifyListeners();
    } catch (e) {
      // Error fetching conversations
    } finally {
      setLoading(false);
    }
  }

  // Fetch messages for a conversation
  Future<void> fetchMessages(String conversationId) async {
    setLoading(true);
    try {
      // TODO: Implement API call
      // final response = await http.get(
      //   Uri.parse('YOUR_API_URL/messages/$conversationId'),
      // );
      
      await Future.delayed(const Duration(milliseconds: 300));
      _messages[conversationId] = _staticMessages[conversationId] ?? [];
      notifyListeners();
    } catch (e) {
      // Error fetching messages
    } finally {
      setLoading(false);
    }
  }

  // Send message
  Future<void> sendMessage(String conversationId, String content) async {
    try {
      final newMessage = MessageModel(
        id: 'm${DateTime.now().millisecondsSinceEpoch}',
        conversationId: conversationId,
        senderId: 'me',
        senderName: 'Me',
        senderAvatar: '',
        content: content,
        timestamp: DateTime.now(),
        isRead: true,
      );

      // Add to local state immediately
      if (_messages[conversationId] != null) {
        _messages[conversationId]!.add(newMessage);
      } else {
        _messages[conversationId] = [newMessage];
      }

      // Update conversation last message
      final convIndex = _conversations.indexWhere((c) => c.id == conversationId);
      if (convIndex != -1) {
        _conversations[convIndex] = _conversations[convIndex].copyWith(
          lastMessage: content,
          lastMessageTime: DateTime.now(),
        );
      }

      notifyListeners();

      // TODO: Implement API call
      // final response = await http.post(
      //   Uri.parse('YOUR_API_URL/messages/$conversationId'),
      //   body: json.encode({'content': content}),
      // );
    } catch (e) {
      // Error sending message
    }
  }

  // Mark conversation as read
  void markConversationAsRead(String conversationId) {
    final index = _conversations.indexWhere((c) => c.id == conversationId);
    if (index != -1 && _conversations[index].unreadCount > 0) {
      _conversations[index] = _conversations[index].copyWith(unreadCount: 0);
      notifyListeners();

      // TODO: Implement API call
      // http.post(Uri.parse('YOUR_API_URL/messages/$conversationId/read'));
    }
  }

  // Delete conversation
  Future<void> deleteConversation(String conversationId) async {
    try {
      _conversations.removeWhere((c) => c.id == conversationId);
      _messages.remove(conversationId);
      notifyListeners();

      // TODO: Implement API call
      // await http.delete(
      //   Uri.parse('YOUR_API_URL/messages/conversations/$conversationId'),
      // );
    } catch (e) {
      // Error deleting conversation
    }
  }
}

