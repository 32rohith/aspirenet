import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../providers/discover_provider.dart';
import '../providers/messages_provider.dart';
import '../widgets/discover/profile_grid_card.dart';
import '../widgets/discover/profile_list_card.dart';
import '../widgets/discover/filter_modal.dart';
import 'search_screen.dart';
import 'messages_list_screen.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({Key? key}) : super(key: key);

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DiscoverProvider>(context, listen: false)
          .fetchSuggestedProfiles();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final discoverProvider = Provider.of<DiscoverProvider>(context);
    final messagesProvider = Provider.of<MessagesProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            discoverProvider.isGridLayout
                ? Icons.grid_view_rounded
                : Icons.view_list_rounded,
            color: AppColors.textColor,
          ),
          onPressed: () {
            discoverProvider.toggleLayout();
          },
        ),
        title: const Text(
          'Discover',
          style: TextStyle(
            color: AppColors.textColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_outlined,
              color: AppColors.textColor,
            ),
            onPressed: () {
              // Handle notifications
            },
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.chat_bubble_outline,
                  color: AppColors.textColor,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MessagesListScreen(),
                    ),
                  );
                },
              ),
              if (messagesProvider.totalUnreadCount > 0)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Center(
                      child: Text(
                        messagesProvider.totalUnreadCount > 9
                            ? '9+'
                            : messagesProvider.totalUnreadCount.toString(),
                        style: const TextStyle(
                          color: AppColors.textColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Filter Icon
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      builder: (context) => const FilterModal(),
                    );
                  },
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: discoverProvider.hasActiveFilters
                          ? AppColors.primaryPurple
                          : AppColors.cardColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(
                          Icons.filter_list,
                          color: discoverProvider.hasActiveFilters
                              ? AppColors.textColor
                              : AppColors.textColor,
                          size: 24,
                        ),
                        if (discoverProvider.hasActiveFilters)
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Search Field
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SearchScreen(),
                        ),
                      );
                    },
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.cardColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: const [
                          SizedBox(width: 16),
                          Icon(
                            Icons.search,
                            color: AppColors.textSecondaryColor,
                            size: 20,
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Search for people, passions, or tribes...',
                            style: TextStyle(
                              color: AppColors.textSecondaryColor,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Content
          Expanded(
            child: discoverProvider.isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryPurple,
                    ),
                  )
                : SingleChildScrollView(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Suggested for you header
                        if (discoverProvider.isGridLayout) ...[
                          const Text(
                            'Suggested for you',
                            style: TextStyle(
                              color: AppColors.textColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                        // Profile Cards
                        discoverProvider.isGridLayout
                            ? _buildGridLayout(discoverProvider)
                            : _buildListLayout(discoverProvider),
                        const SizedBox(height: 20),
                        // Connection Buttons
                        if (discoverProvider.isGridLayout) ...[
                          _buildConnectionButton(
                            'Connect with Similar Interests',
                            const Color(0xFFBBAECC),
                            () => discoverProvider.connectWithSimilarInterests(),
                          ),
                          const SizedBox(height: 12),
                          _buildConnectionButton(
                            'Connect with Complementary Skills',
                            const Color(0xFF4CAF50),
                            () =>
                                discoverProvider.connectWithComplementarySkills(),
                          ),
                        ] else ...[
                          _buildConnectionButton(
                            'Explore Your Network',
                            const Color(0xFFBBAECC),
                            () {},
                          ),
                          const SizedBox(height: 12),
                          _buildConnectionButton(
                            'Connect with Similar Interests',
                            const Color(0xFFBBAECC),
                            () => discoverProvider.connectWithSimilarInterests(),
                          ),
                          const SizedBox(height: 12),
                          _buildConnectionButton(
                            'Connect with Complementary Skills',
                            const Color(0xFF4CAF50),
                            () =>
                                discoverProvider.connectWithComplementarySkills(),
                          ),
                        ],
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridLayout(DiscoverProvider provider) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.75,
      ),
      itemCount: provider.suggestedProfiles.length,
      itemBuilder: (context, index) {
        final profile = provider.suggestedProfiles[index];
        return ProfileGridCard(
          profile: profile,
          onViewProfile: () {
            provider.viewProfile(profile.id);
          },
        );
      },
    );
  }

  Widget _buildListLayout(DiscoverProvider provider) {
    return Column(
      children: provider.suggestedProfiles.map((profile) {
        return ProfileListCard(
          profile: profile,
          isLiked: provider.isProfileLiked(profile.id),
          onLike: () {
            if (provider.isProfileLiked(profile.id)) {
              provider.unlikeProfile(profile.id);
            } else {
              provider.likeProfile(profile.id);
            }
          },
          onViewProfile: () {
            provider.viewProfile(profile.id);
          },
        );
      }).toList(),
    );
  }

  Widget _buildConnectionButton(String text, Color color, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: AppColors.textColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

