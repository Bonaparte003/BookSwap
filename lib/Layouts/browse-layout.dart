import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bookswap/Services/book_providers.dart';
import 'package:bookswap/Services/swap_providers.dart';
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
            // Filter out user's own books from browse listings
            final filteredBooks = currentUser != null
                ? books.where((book) => book.userId != currentUser.uid).toList()
                : books;

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
              padding: const EdgeInsets.all(16),
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
        data: (books) => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: books.length,
          itemBuilder: (context, index) {
            final book = books[index];
            return _BookCard(book: book, currentUserId: null);
          },
        ),
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final swapService = ref.watch(swapServiceProvider);
    final isOwnBook = currentUserId != null && book.userId == currentUserId;
    final canSwap = currentUserId != null &&
        !isOwnBook &&
        (book.swapStatus == null || book.swapStatus == 'available');

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Book Cover Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                book.coverImageUrl,
                width: 80,
                height: 120,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
    return Container(
                    width: 80,
                    height: 120,
                    color: Colors.grey[300],
                    child: const Icon(Icons.book, size: 40),
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
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
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
                  const SizedBox(height: 8),
                  Row(
        children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getConditionColor(book.condition),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          book.condition.displayName,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (book.swapStatus != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getSwapStatusColor(book.swapStatus!),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            book.swapStatus!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Listed by: ${book.userEmail}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color.fromARGB(255, 150, 150, 150),
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (isOwnBook)
                    const Text(
                      'Your book',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 100, 100, 100),
                      ),
                    )
                  else if (canSwap)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          // Show confirmation dialog
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Request Swap'),
                              content: Text(
                                'Send a swap request for "${book.title}" by ${book.author}?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: const Text('Cancel'),
                                ),
                                ElevatedButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Text('Request Swap'),
                                ),
                              ],
                            ),
                          );

                          if (confirmed == true && context.mounted) {
                            try {
                              await swapService.createSwapOffer(
                                bookId: book.id,
                                book: book,
                              );
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Swap request sent successfully!'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error: $e'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          }
                        },
                        icon: const Icon(Icons.swap_horiz, size: 18),
                        label: const Text('Request Swap'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    )
                  else
                    const Text(
                      'Swap not available',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color.fromARGB(255, 150, 150, 150),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getConditionColor(BookCondition condition) {
    switch (condition) {
      case BookCondition.newBook:
        return Colors.green;
      case BookCondition.likeNew:
        return Colors.blue;
      case BookCondition.good:
        return Colors.orange;
      case BookCondition.used:
        return Colors.grey;
    }
  }

  Color _getSwapStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'swapped':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
