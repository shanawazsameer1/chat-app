import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';
import '../models/message_model.dart';
import '../viewmodels/chat_detail_viewmodel.dart';
import '../viewmodels/theme_provider.dart';
import '../widgets/message_bubble.dart';
import '../widgets/loading_indicator.dart';
import 'package:uuid/uuid.dart';

class ChatDetailScreen extends StatefulWidget {
  final UserModel peer;
  const ChatDetailScreen({super.key, required this.peer});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late ChatDetailViewModel vm;
  final String chatId = 'demo_chat_id'; // Replace with real chatId logic

  @override
  void initState() {
    super.initState();
    vm = ChatDetailViewModel();
    vm.loadMessages(chatId);
  }

  void _sendMessage() {
    if (_controller.text.trim().isNotEmpty) {
      final msg = MessageModel(
        id: const Uuid().v4(),
        senderId: 'my_uid', // Replace with real user id
        receiverId: widget.peer.uid,
        text: _controller.text.trim(),
        timestamp: DateTime.now(),
      );
      vm.sendMessage(chatId, msg);
      _controller.clear();

      // Auto-scroll to bottom
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return ChangeNotifierProvider.value(
      value: vm,
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          title: Row(
            children: [
              // Profile Picture
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColor.withValues(alpha: 0.7),
                    ],
                  ),
                ),
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.transparent,
                  backgroundImage: widget.peer.photoUrl != null
                      ? NetworkImage(widget.peer.photoUrl!)
                      : null,
                  child: widget.peer.photoUrl == null
                      ? Text(
                          (widget.peer.displayName ?? widget.peer.email)
                              .substring(0, 1)
                              .toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        )
                      : null,
                ),
              ),
              const SizedBox(width: 12),

              // User Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.peer.displayName ?? widget.peer.email,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      widget.peer.isOnline ? 'Online' : 'Last seen recently',
                      style: TextStyle(
                        fontSize: 12,
                        color: widget.peer.isOnline
                            ? Colors.green
                            : isDark ? Colors.grey[400] : Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.videocam),
              onPressed: () {
                // TODO: Implement video call
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Video call coming soon!')),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.call),
              onPressed: () {
                // TODO: Implement voice call
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Voice call coming soon!')),
                );
              },
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0B141A) : const Color(0xFFE5DDD5),
            image: DecorationImage(
              image: NetworkImage(
                isDark
                    ? 'https://images.unsplash.com/photo-1557682224-5b8590cd9ec5?w=400&h=800&fit=crop'
                    : 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=400&h=800&fit=crop',
              ),
              fit: BoxFit.cover,
              opacity: 0.05,
            ),
          ),
          child: Column(
            children: [
              // Messages List
              Expanded(
                child: Consumer<ChatDetailViewModel>(
                  builder: (context, vm, _) {
                    if (vm.isLoading) {
                      return const LoadingIndicator();
                    }

                    if (vm.messages.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.chat_bubble_outline_rounded,
                              size: 80,
                              color: Theme.of(
                                context,
                              ).primaryColor.withValues(alpha: 0.3),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Start your chat',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.color
                                        ?.withValues(alpha: 0.7),
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Send a message to ${widget.peer.displayName ?? 'this person'}',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.color
                                        ?.withValues(alpha: 0.5),
                                  ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      controller: _scrollController,
                      reverse: true,
                      padding: const EdgeInsets.all(8),
                      itemCount: vm.messages.length,
                      itemBuilder: (context, index) {
                        final msg = vm.messages[vm.messages.length - 1 - index];
                        final isMe = msg.senderId == 'my_uid';
                        return MessageBubble(message: msg, isMe: isMe);
                      },
                    );
                  },
                ),
              ),

              // Message Input
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isDark 
                    ? const Color(0xFF1F2C34)
                    : Colors.grey[50],
                  border: Border(
                    top: BorderSide(
                      color: isDark 
                        ? Colors.grey[800]!
                        : Colors.grey[300]!,
                      width: 0.5,
                    ),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isDark 
                        ? Colors.black.withValues(alpha: 0.3)
                        : Colors.grey.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Row(
                    children: [
                      // Emoji button
                      Container(
                        decoration: BoxDecoration(
                          color: isDark
                            ? Colors.grey[800]?.withValues(alpha: 0.5)
                            : Colors.grey[100],
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.emoji_emotions_outlined),
                          color: isDark 
                            ? Colors.yellow[600]
                            : Colors.orange[600],
                          iconSize: 24,
                          onPressed: () {
                            // TODO: Implement emoji picker
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('😊 Emoji picker coming soon!'),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(width: 8),

                      // Message TextField
                      Expanded(
                        child: Container(
                          constraints: const BoxConstraints(maxHeight: 120),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF2A3942)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                              color: isDark 
                                ? Colors.grey[600]!
                                : Colors.grey[300]!,
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: isDark 
                                  ? Colors.black.withValues(alpha: 0.2)
                                  : Colors.grey.withValues(alpha: 0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _controller,
                            maxLines: null,
                            style: TextStyle(
                              color: isDark ? Colors.white : Colors.black87,
                              fontSize: 16,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Type a message...',
                              hintStyle: TextStyle(
                                color: isDark 
                                  ? Colors.grey[400]
                                  : Colors.grey[600],
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              border: InputBorder.none,
                            ),
                            onSubmitted: (_) => _sendMessage(),
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),

                      // Attachment button
                      Container(
                        decoration: BoxDecoration(
                          color: isDark
                            ? Colors.grey[800]?.withValues(alpha: 0.5)
                            : Colors.grey[100],
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.attach_file),
                          color: isDark 
                            ? Colors.blue[300]
                            : Theme.of(context).primaryColor,
                          iconSize: 24,
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('📎 Attachments coming soon!'),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(width: 8),

                      // Send button
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context).primaryColor,
                              Theme.of(context).primaryColor.withValues(alpha: 0.8),
                            ],
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.send, color: Colors.white),
                          iconSize: 22,
                          onPressed: _sendMessage,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
