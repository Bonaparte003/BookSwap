import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bookswap/Services/swap_providers.dart';
import 'package:bookswap/Services/chat_providers.dart';
import 'package:bookswap/Firebase/auth_providers.dart';
import 'package:bookswap/Services/notification_service.dart';
import 'package:bookswap/Services/book_providers.dart';
import 'package:bookswap/Models/swap.dart';
import 'package:bookswap/Models/message.dart' as msg;
import 'package:flutter/foundation.dart';

/// Widget that listens for new swaps and messages and shows notifications
/// This should be added to the app's widget tree (e.g., in Home widget)
class NotificationListenerWidget extends ConsumerStatefulWidget {
  final Widget child;

  const NotificationListenerWidget({
    super.key,
    required this.child,
  });

  @override
  ConsumerState<NotificationListenerWidget> createState() => _NotificationListenerWidgetState();
}

class _NotificationListenerWidgetState extends ConsumerState<NotificationListenerWidget> {
  final NotificationService _notificationService = NotificationService();
  Set<String> _lastSwapIds = {};
  Map<String, Set<String>> _lastMessageIds = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);

    if (currentUser != null) {
      // Listen for new swaps
      final receivedOffersAsync = ref.watch(receivedOffersProvider(currentUser.uid));
      receivedOffersAsync.whenData((swaps) {
        if (_lastSwapIds.isEmpty) {
          // First load, just store the IDs
          _lastSwapIds = swaps.map((s) => s.id).toSet();
          return;
        }

        final nextIds = swaps.map((s) => s.id).toSet();
        final newSwapIds = nextIds.difference(_lastSwapIds);

        // Find new swaps
        if (newSwapIds.isNotEmpty) {
          final newSwap = swaps.firstWhere((s) => newSwapIds.contains(s.id));
          _showSwapNotification(newSwap);
        }

        _lastSwapIds = nextIds;
      });

      // Listen for new chats and their messages
      final userChatsAsync = ref.watch(userChatsProvider(currentUser.uid));
      userChatsAsync.whenData((chats) {
        final currentChatIds = chats.map((c) => c.id).toSet();
        final existingChatIds = _lastMessageIds.keys.toSet();
        final newChatIds = currentChatIds.difference(existingChatIds);

        // Start listening to new chats
        for (final chatId in newChatIds) {
          _listenToChatMessages(chatId, currentUser.uid);
        }
      });
    }

    return widget.child;
  }

  /// Listen to messages in a specific chat
  void _listenToChatMessages(String chatId, String currentUserId) {
    // Use a timer or effect to watch the messages
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final messagesAsync = ref.read(chatMessagesProvider(chatId));
      messagesAsync.whenData((messages) {
        if (!_lastMessageIds.containsKey(chatId)) {
          // First load, just store the IDs
          _lastMessageIds[chatId] = messages.map((m) => m.id).toSet();
          return;
        }

        final previousIds = _lastMessageIds[chatId]!;
        final nextIds = messages.map((m) => m.id).toSet();

        // Find new messages that weren't sent by current user
        final newMessageIds = nextIds.difference(previousIds);
        if (newMessageIds.isNotEmpty) {
          final newMessages = messages.where((m) => 
            newMessageIds.contains(m.id) && m.senderId != currentUserId
          );
          
          if (newMessages.isNotEmpty) {
            final newMessage = newMessages.first;
            _showMessageNotification(newMessage, chatId);
          }
        }

        // Update last seen message IDs
        _lastMessageIds[chatId] = nextIds;
      });
    });
  }

  /// Show notification for a new swap
  Future<void> _showSwapNotification(Swap swap) async {
    try {
      // Get book title
      final bookAsync = ref.read(bookByIdProvider(swap.bookId));
      bookAsync.whenData((book) async {
        final requesterName = swap.requesterEmail.split('@')[0];
        
        await _notificationService.showSwapRequestNotification(
          requesterName: requesterName,
          bookTitle: book.title,
        );
      });
    } catch (e) {
      debugPrint('Error showing swap notification: $e');
    }
  }

  /// Show notification for a new message
  Future<void> _showMessageNotification(msg.Message message, String chatId) async {
    try {
      // Get chat to find sender name
      final chatAsync = ref.read(chatByIdProvider(chatId));
      chatAsync.whenData((chat) async {
        final senderId = message.senderId;
        final senderName = chat.participantNames[senderId] ?? 
            (chat.participantEmails[senderId]?.split('@')[0] ?? 'Someone');
        
        final messagePreview = message.text.length > 50 
            ? '${message.text.substring(0, 50)}...' 
            : message.text;
        
        await _notificationService.showMessageNotification(
          senderName: senderName,
          messageText: messagePreview,
          chatId: chatId,
        );
      });
    } catch (e) {
      debugPrint('Error showing message notification: $e');
    }
  }
}

