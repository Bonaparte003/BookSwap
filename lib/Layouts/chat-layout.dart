import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bookswap/Services/chat_providers.dart';
import 'package:bookswap/Firebase/auth_providers.dart';
import 'package:bookswap/Models/chat.dart';
import 'package:bookswap/Screens/chat_detail.dart';

/// Chat Layout - Shows chat conversations
class ChatLayout extends ConsumerWidget {
  const ChatLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);

    if (currentUser == null) {
      return const Center(
        child: Text('Please log in to view chats'),
      );
    }

    final userChatsAsync = ref.watch(userChatsProvider(currentUser.uid));

    return userChatsAsync.when(
      data: (chats) {
        if (chats.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.message_outlined,
                  size: 80,
                  color: Color.fromARGB(255, 150, 150, 150),
                ),
                const SizedBox(height: 16),
                const Text(
                  'No chats yet',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color.fromARGB(255, 100, 100, 100),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Start a swap to begin chatting!',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color.fromARGB(255, 150, 150, 150),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: chats.length,
          itemBuilder: (context, index) {
            final chat = chats[index];
            return _ChatCard(chat: chat, currentUserId: currentUser.uid);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(
        child: Text('Error: $error'),
      ),
    );
  }
}

/// Chat Card Widget
class _ChatCard extends ConsumerWidget {
  final Chat chat;
  final String currentUserId;

  const _ChatCard({
    required this.chat,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final otherParticipantId = chat.getOtherParticipant(currentUserId);
    final otherParticipantName = chat.getOtherParticipantName(currentUserId);
    final otherParticipantEmail = chat.getOtherParticipantEmail(currentUserId);
    final otherParticipantPhotoURL = chat.getOtherParticipantPhotoURL(currentUserId);
    
    // Use name, then extract name from email, then email, then fallback to ID
    String displayName = otherParticipantName ?? 'Unknown User';
    if (displayName == 'Unknown User' && otherParticipantEmail != null && otherParticipantEmail.isNotEmpty) {
      // Extract name from email (part before @)
      final emailParts = otherParticipantEmail.split('@');
      if (emailParts.isNotEmpty && emailParts[0].isNotEmpty) {
        displayName = emailParts[0];
      } else {
        displayName = otherParticipantEmail;
      }
    } else if (displayName == 'Unknown User') {
      displayName = otherParticipantEmail ?? otherParticipantId ?? 'Unknown User';
    }
    
    final initial = displayName.isNotEmpty 
        ? displayName.substring(0, 1).toUpperCase() 
        : 'U';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 28,
          backgroundColor: const Color.fromARGB(255, 0, 0, 0),
          backgroundImage: otherParticipantPhotoURL != null && otherParticipantPhotoURL.isNotEmpty
              ? NetworkImage(otherParticipantPhotoURL)
              : null,
          child: otherParticipantPhotoURL == null || otherParticipantPhotoURL.isEmpty
              ? Text(
                  initial,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                )
              : null,
        ),
        title: Text(
          displayName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          chat.lastMessage ?? 'No messages yet',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Color.fromARGB(255, 100, 100, 100),
          ),
        ),
        trailing: chat.lastMessageTime != null
            ? Text(
                _formatTime(chat.lastMessageTime!),
                style: const TextStyle(
                  fontSize: 12,
                  color: Color.fromARGB(255, 150, 150, 150),
                ),
              )
            : null,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatDetailScreen(chat: chat),
            ),
          );
        },
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      // Today - show time
      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${dateTime.day}/${dateTime.month}';
    }
  }
}
