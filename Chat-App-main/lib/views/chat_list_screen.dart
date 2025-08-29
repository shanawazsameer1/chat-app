import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/chat_list_viewmodel.dart';
import '../viewmodels/theme_provider.dart';
import '../widgets/user_tile.dart';
import '../widgets/loading_indicator.dart';
import '../utils/theme.dart';
import 'chat_detail_screen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChatListViewModel(),
      child: Consumer3<ChatListViewModel, AuthViewModel, ThemeProvider>(
        builder: (context, vm, authVm, themeProvider, _) {
          final isDark = themeProvider.isDarkMode;

          return Scaffold(
            body: Container(
              decoration: BoxDecoration(
                gradient: isDark
                    ? AppTheme.darkBackgroundGradient
                    : AppTheme.lightBackgroundGradient,
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    // Custom App Bar
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          // Profile Avatar
                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: AppTheme.sentMessageGradient,
                            ),
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: isDark
                                  ? Colors.grey[800]
                                  : Colors.grey[300],
                              child: Text(
                                '😊', // Always show smile emoji for better UX
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),

                          // Title
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '💬 NexTalk',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24,
                                      ),
                                ),
                                Text(
                                  '${vm.filteredUsers.length} chats',
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(fontSize: 14),
                                ),
                              ],
                            ),
                          ),

                          // Theme Toggle
                          IconButton(
                            onPressed: themeProvider.toggleTheme,
                            icon: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? Colors.white.withOpacity(0.1)
                                    : Colors.black.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                isDark ? Icons.light_mode : Icons.dark_mode,
                                size: 20,
                              ),
                            ),
                          ),

                          // Logout
                          IconButton(
                            onPressed: () => authVm.signOut(),
                            icon: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.logout,
                                color: Colors.red,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Search Bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.grey[800]?.withValues(alpha: 0.6)
                              : Colors
                                    .grey[50], // Better visibility in light mode
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isDark
                                ? Colors.grey[600]!
                                : Colors
                                      .grey[300]!, // Add border for better definition
                            width: 1,
                          ),
                          boxShadow: isDark
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : [
                                  BoxShadow(
                                    color: Colors.grey.withValues(alpha: 0.2),
                                    blurRadius: 10,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                        ),
                        child: StatefulBuilder(
                          builder: (context, setSearchState) {
                            return TextField(
                              controller: _searchController,
                              onChanged: (query) {
                                vm.searchUsers(query);
                                setSearchState(
                                  () {},
                                ); // Rebuild to show/hide clear button
                              },
                              decoration: InputDecoration(
                                hintText: 'Search chats...',
                                hintStyle: TextStyle(
                                  color: isDark ? Colors.white60 : Colors.grey,
                                ),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: isDark ? Colors.white60 : Colors.grey,
                                ),
                                suffixIcon: _searchController.text.isNotEmpty
                                    ? IconButton(
                                        icon: Icon(
                                          Icons.clear,
                                          color: isDark
                                              ? Colors.white60
                                              : Colors.grey,
                                        ),
                                        onPressed: () {
                                          _searchController.clear();
                                          vm.clearSearch();
                                          setSearchState(
                                            () {},
                                          ); // Rebuild to hide clear button
                                        },
                                      )
                                    : null,
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 16,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Chat List
                    Expanded(
                      child: vm.isLoading
                          ? const LoadingIndicator()
                          : vm.filteredUsers.isEmpty &&
                                vm.searchQuery.isNotEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.search_off,
                                    size: 64,
                                    color: isDark
                                        ? Colors.white60
                                        : Colors.grey,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No chats found',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: isDark
                                          ? Colors.white60
                                          : Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Try searching with a different name',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: isDark
                                          ? Colors.white60
                                          : Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              itemCount: vm.filteredUsers.length,
                              itemBuilder: (context, index) {
                                final user = vm.filteredUsers[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: UserTile(
                                    user: user,
                                    gradientIndex: index,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              ChatDetailScreen(peer: user),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),

            // Floating Action Button
            floatingActionButton: Container(
              decoration: BoxDecoration(
                gradient: AppTheme.sentMessageGradient,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: FloatingActionButton(
                onPressed: () {
                  // TODO: Add new chat functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('New chat feature coming soon!'),
                      backgroundColor: Colors.blue,
                    ),
                  );
                },
                backgroundColor: Colors.transparent,
                elevation: 0,
                child: const Icon(
                  Icons.add_comment_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
