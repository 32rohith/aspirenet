import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../providers/search_provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SearchProvider>(context, listen: false)
          .fetchRecommendations();
      _searchFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<SearchProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // Back Button
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: AppColors.textColor,
                      size: 20,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  // Search Field
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.textFieldColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: _searchController,
                        focusNode: _searchFocusNode,
                        style: const TextStyle(
                          color: AppColors.textColor,
                          fontSize: 14,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Search for people, passions, or tribes...',
                          hintStyle: TextStyle(
                            color: AppColors.textSecondaryColor,
                            fontSize: 14,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: AppColors.textSecondaryColor,
                            size: 20,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                        onChanged: (value) {
                          searchProvider.setSearchQuery(value);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Content
            Expanded(
              child: searchProvider.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryPurple,
                      ),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Recommended People
                          const Text(
                            'Recommended People',
                            style: TextStyle(
                              color: AppColors.textColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Based on your connections',
                            style: TextStyle(
                              color: AppColors.textSecondaryColor,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ...searchProvider.recommendedPeople.map((person) {
                            return _buildPersonTile(person);
                          }).toList(),
                          const SizedBox(height: 24),
                          // Trending Topics
                          const Text(
                            'Trending Topics',
                            style: TextStyle(
                              color: AppColors.textColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Popular searches today',
                            style: TextStyle(
                              color: AppColors.textSecondaryColor,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ...searchProvider.trendingTopics.map((topic) {
                            return _buildTopicTile(topic);
                          }).toList(),
                          const SizedBox(height: 24),
                          // Popular Tribes
                          const Text(
                            'Popular Tribes',
                            style: TextStyle(
                              color: AppColors.textColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Communities you might like',
                            style: TextStyle(
                              color: AppColors.textSecondaryColor,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ...searchProvider.popularTribes.map((tribe) {
                            return _buildTribeTile(tribe);
                          }).toList(),
                          const SizedBox(height: 80),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonTile(person) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 24,
            backgroundColor: _getGradientColor(person.id),
            child: Text(
              person.name[0].toUpperCase(),
              style: const TextStyle(
                color: AppColors.textColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      person.name,
                      style: const TextStyle(
                        color: AppColors.textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (person.isVerified) ...[
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.verified,
                        color: Color(0xFF2196F3),
                        size: 16,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  person.description,
                  style: const TextStyle(
                    color: AppColors.textSecondaryColor,
                    fontSize: 13,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopicTile(topic) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _getGradientColor(topic.id),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getTopicIcon(topic.title),
              color: AppColors.textColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  topic.title,
                  style: const TextStyle(
                    color: AppColors.textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  topic.description,
                  style: const TextStyle(
                    color: AppColors.textSecondaryColor,
                    fontSize: 13,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTribeTile(tribe) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _getGradientColor(tribe.id),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getTribeIcon(tribe.name),
              color: AppColors.textColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tribe.name,
                  style: const TextStyle(
                    color: AppColors.textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  tribe.description,
                  style: const TextStyle(
                    color: AppColors.textSecondaryColor,
                    fontSize: 13,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getGradientColor(String id) {
    final colors = [
      const Color(0xFF9B4DCA),
      const Color(0xFF4CAF50),
      const Color(0xFFE91E63),
      const Color(0xFF2196F3),
      const Color(0xFFFF9800),
      const Color(0xFF00BCD4),
    ];
    return colors[id.hashCode % colors.length];
  }

  IconData _getTopicIcon(String title) {
    if (title.toLowerCase().contains('podcast')) return Icons.podcasts;
    if (title.toLowerCase().contains('machine')) return Icons.psychology;
    if (title.toLowerCase().contains('stock')) return Icons.trending_up;
    return Icons.topic;
  }

  IconData _getTribeIcon(String name) {
    if (name.toLowerCase().contains('goal')) return Icons.fitness_center;
    if (name.toLowerCase().contains('story')) return Icons.bar_chart;
    if (name.toLowerCase().contains('fintech')) return Icons.account_balance;
    return Icons.groups;
  }
}



