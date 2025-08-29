import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/message_model.dart';
import '../viewmodels/theme_provider.dart';

class MessageBubble extends StatelessWidget {
  final MessageModel message;
  final bool isMe;

  const MessageBubble({super.key, required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    
    // Define beautiful gradient colors
    final sentMessageGradient = LinearGradient(
      colors: [
        const Color(0xFF25D366), // WhatsApp green
        const Color(0xFF128C7E), // Darker green
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
    
    final receivedMessageGradient = isDark
        ? LinearGradient(
            colors: [
              const Color(0xFF374151), // Cool blue-gray
              const Color(0xFF4B5563), // Darker blue-gray
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
        : LinearGradient(
            colors: [
              const Color(0xFFF8FAFC), // Light gray-blue
              const Color(0xFFE2E8F0), // Slightly darker
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          );
    
    return Container(
      margin: EdgeInsets.only(
        left: isMe ? 80 : 16,
        right: isMe ? 16 : 80,
        top: 6,
        bottom: 6,
      ),
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          decoration: BoxDecoration(
            gradient: isMe ? sentMessageGradient : receivedMessageGradient,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(20),
              topRight: const Radius.circular(20),
              bottomLeft: isMe ? const Radius.circular(20) : const Radius.circular(6),
              bottomRight: isMe ? const Radius.circular(6) : const Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: isMe 
                  ? const Color(0xFF25D366).withValues(alpha: 0.3)
                  : isDark
                    ? Colors.black.withValues(alpha: 0.4)
                    : Colors.grey.withValues(alpha: 0.2),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message.text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isMe
                      ? Colors.white // White text on green gradient
                      : isDark 
                        ? Colors.white // White text on dark gradient
                        : const Color(0xFF374151), // Dark gray on light gradient
                ),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    DateFormat.Hm().format(message.timestamp.toLocal()),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: isMe
                          ? Colors.white.withValues(alpha: 0.8) // Subtle white on green
                          : isDark 
                            ? Colors.white.withValues(alpha: 0.7) // Subtle white on dark
                            : const Color(0xFF6B7280), // Gray on light
                    ),
                  ),
                  if (isMe) ...[
                    const SizedBox(width: 6),
                    Icon(
                      message.seen ? Icons.done_all : Icons.done,
                      size: 16,
                      color: message.seen 
                          ? Colors.lightBlueAccent // Blue for seen
                          : Colors.white.withValues(alpha: 0.8), // White for sent
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
