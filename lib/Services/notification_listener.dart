import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bookswap/Services/swap_providers.dart';
import 'package:bookswap/Services/chat_providers.dart';
import 'package:bookswap/Firebase/auth_providers.dart';
import 'package:bookswap/Services/notification_service.dart';
import 'package:bookswap/Services/book_providers.dart';
import 'package:bookswap/Models/swap.dart';
import 'package:bookswap/Models/chat.dart';
import 'package:bookswap/Models/message.dart' as msg;
import 'package:flutter/foundation.dart';

/// Provider for tracking last seen swap IDs to detect new swaps
final lastSeenSwapIdsProvider = StateProvider<Set<String>>((ref) => <String>{});

/// Provider for tracking last seen message IDs per chat to detect new messages
final lastSeenMessageIdsProvider = StateProvider<Map<String, Set<String>>>((ref) => <String, Set<String>>{});

/// Notification listener that watches for new swaps and messages
class NotificationListenerService {
  final WidgetRef ref;
  final NotificationService _notificationService = NotificationService();
  Set<String>? _lastSwapIds;
  Map<String, Set<String>>? _lastMessageIds;

  NotificationListenerService(this.ref);

  /// Start listening for new swaps for the current user
  void listenForSwaps(String userId) {
    ref.listen<List<Swap>>(
      receivedOffersProvider(userId),
      (previous, next) {
        if (previous == null || previous.isEmpty) {
          // First load, just store the IDs
          _lastSwapIds = next.map((s) => s.id).toSet();
          return;
        }

        final previousIds = _lastSwapIds ?? previous.map((s) => s.id).toSet();
        final nextIds = next.map((s) => s.id).toSet();

        // Find new swaps
        final newSwapIds = nextIds.difference(previousIds);
        if (newSwapIds.isNotEmpty) {
          // Get the new swap
          final newSwap = next.firstWhere((s) => newSwapIds.contains(s.id));
          _showSwapNotification(newSwap);
        }

        _lastSwapIds = nextIds;
      },
    );
  }

  /// Start listening for new messages in user's chats
  void listenForMessages(String userId) {
    ref.listen<List<Chat>>(
      userChatsProvider(userId),
      (previous, next) async {
        if (previous == null) {
          // First load, initialize message listeners for each chat
          for (final chat in next) {
            _listenToChatMessages(chat.id, userId);
          }
          return;
        }

        // Find new chats
        final previousChatIds = previous.map((c) => c.id).toSet();
        final nextChatIds = next.map((c) => c.id).toSet();
        final newChatIds = nextChatIds.difference(previousChatIds);

        // Start listening to new chats
        for (final chatId in newChatIds) {
          _listenToChatMessages(chatId, userId);
        }
      },
    );
  }

  /// Listen to messages in a specific chat
  void _listenToChatMessages(String chatId, String currentUserId) {
    ref.listen<List<msg.Message>>(
      chatMessagesProvider(chatId),
      (previous, next) {
        if (previous == null || previous.isEmpty) {
          // First load, just store the IDs
          final lastIds = ref.read(lastSeenMessageIdsProvider);
          lastIds[chatId] = next.map((m) => m.id).toSet();
          ref.read(lastSeenMessageIdsProvider.notifier).state = Map.from(lastIds);
          return;
        }

        final lastIds = ref.read(lastSeenMessageIdsProvider);
        final previousIds = lastIds[chatId] ?? previous.map((m) => m.id).toSet();
        final nextIds = next.map((m) => m.id).toSet();

        // Find new messages that weren't sent by current user
        final newMessageIds = nextIds.difference(previousIds);
        if (newMessageIds.isNotEmpty) {
          final newMessages = next.where((m) => 
            newMessageIds.contains(m.id) && m.senderId != currentUserId
          );
          
          if (newMessages.isNotEmpty) {
            final newMessage = newMessages.first;
            _showMessageNotification(newMessage, chatId);
          }
        }

        // Update last seen message IDs
        final updatedIds = Map<String, Set<String>>.from(lastIds);
        updatedIds[chatId] = nextIds;
        ref.read(lastSeenMessageIdsProvider.notifier).state = updatedIds;
      },
    );
  }

  /// Show notification for a new swap
  Future<void> _showSwapNotification(Swap swap) async {
    try {
      // Get book title
      final bookAsync = ref.read(bookByIdProvider(swap.bookId));
      final book = await bookAsync.future;
      
      final requesterName = swap.requesterEmail.split('@')[0];
      
      await _notificationService.showSwapRequestNotification(
        requesterName: requesterName,
        bookTitle: book.title,
      );
    } catch (e) {
      debugPrint('Error showing swap notification: $e');
    }
  }

  /// Show notification for a new message
  Future<void> _showMessageNotification(msg.Message message, String chatId) async {
    try {
      // Get chat to find sender name
      final chatAsync = ref.read(chatByIdProvider(chatId));
      final chat = await chatAsync.future;
      
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
    } catch (e) {
      debugPrint('Error showing message notification: $e');
    }
  }
}

