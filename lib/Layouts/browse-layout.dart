import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bookswap/Services/book_providers.dart';
import 'package:bookswap/Firebase/auth_providers.dart';
import 'package:bookswap/Models/book.dart';

/// Browse Layout - Shows all book listings with swap functionality
class BrowseLayout extends ConsumerWidget {
  const BrowseLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allBooksAsync = ref.watch(allBooksProvider);
    final currentUserAsync = ref.watch(currentUserStreamProvider);

    return currentUserAsync.when(
      data: (currentUser) {
        return allBooksAsync.when(
          data: (books) {
            // Filter out user's own books and books that are not available for swap
            // A book is available for swap when swapStatus is null
            final filteredBooks = currentUser != null
                ? books.where((book) => 
                    book.userId != currentUser.uid && 
                    book.swapStatus == null).toList()
                : books.where((book) => book.swapStatus == null).toList();

        if (filteredBooks.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.book_outlined,
                  size: 80,
                  color: Color.fromARGB(255, 150, 150, 150),
                ),
                SizedBox(height: 16),
                Text(
                  'No books available for swap yet',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color.fromARGB(255, 100, 100, 100),
                  ),
                ),
              ],
            ),
          );
        }

            return ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: filteredBooks.length,
              itemBuilder: (context, index) {
                final book = filteredBooks[index];
                return _BookCard(book: book, currentUserId: currentUser?.uid);
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(
            child: Text('Error: $error'),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => allBooksAsync.when(
        data: (books) {
          // Filter out books that are not available for swap
          final availableBooks = books.where((book) => book.swapStatus == null).toList();
          if (availableBooks.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.book_outlined,
                    size: 80,
                    color: Color.fromARGB(255, 150, 150, 150),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No books available yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(255, 100, 100, 100),
                    ),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: availableBooks.length,
            itemBuilder: (context, index) {
              final book = availableBooks[index];
              return _BookCard(book: book, currentUserId: null);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }
}

/// Book Card Widget for Browse Screen
class _BookCard extends ConsumerWidget {
  final Book book;
  final String? currentUserId;

  const _BookCard({
    required this.book,
    this.currentUserId,
  });

  String _getDaysAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    final days = difference.inDays;
    
    if (days == 0) {
      return 'Today';
    } else if (days == 1) {
      return '1 day ago';
    } else {
      return '$days days ago';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color.fromARGB(255, 230, 230, 230),
            width: 1,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Book Cover Image
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.network(
              book.coverImageUrl,
              width: 60,
              height: 90,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 60,
                  height: 90,
                  color: Colors.grey[300],
                  child: const Icon(Icons.book, size: 30),
                );
              },
            ),
          ),
          const SizedBox(width: 16),
          // Book Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  book.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'by ${book.author}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color.fromARGB(255, 100, 100, 100),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  book.condition.displayName,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color.fromARGB(255, 100, 100, 100),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.folder_outlined,
                      size: 14,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _getDaysAgo(book.createdAt),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}
