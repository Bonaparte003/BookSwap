import 'package:cloud_firestore/cloud_firestore.dart';

/// Book Condition Enum
enum BookCondition {
  newBook,    // New
  likeNew,    // Like New
  good,       // Good
  used,       // Used
}

/// Extension to convert enum to/from string
extension BookConditionExtension on BookCondition {
  String get displayName {
    switch (this) {
      case BookCondition.newBook:
        return 'New';
      case BookCondition.likeNew:
        return 'Like New';
      case BookCondition.good:
        return 'Good';
      case BookCondition.used:
        return 'Used';
    }
  }

  static BookCondition fromString(String value) {
    switch (value) {
      case 'New':
        return BookCondition.newBook;
      case 'Like New':
        return BookCondition.likeNew;
      case 'Good':
        return BookCondition.good;
      case 'Used':
        return BookCondition.used;
      default:
        return BookCondition.good;
    }
  }
}

/// Book Model representing a book listing
class Book {
  final String id;                    // Document ID from Firestore
  final String title;                 // Book title
  final String author;                // Book author
  final BookCondition condition;      // Book condition (New, Like New, Good, Used)
  final String coverImageUrl;         // URL to the cover image (stored in Firebase Storage)
  final String userId;                // ID of the user who created the listing
  final String userEmail;             // Email of the user who created the listing (for display)
  final String? swapStatus;           // Swap status: null (available), 'pending', 'swapped'
  final DateTime createdAt;           // When the listing was created
  final DateTime updatedAt;           // When the listing was last updated

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.condition,
    required this.coverImageUrl,
    required this.userId,
    required this.userEmail,
    this.swapStatus,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create a Book from a Firestore document
  factory Book.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    
    return Book(
      id: doc.id,
      title: data['title'] ?? '',
      author: data['author'] ?? '',
      condition: BookConditionExtension.fromString(data['condition'] ?? 'Good'),
      coverImageUrl: data['coverImageUrl'] ?? '',
      userId: data['userId'] ?? '',
      userEmail: data['userEmail'] ?? '',
      swapStatus: data['swapStatus'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  /// Convert Book to a Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'author': author,
      'condition': condition.displayName,
      'coverImageUrl': coverImageUrl,
      'userId': userId,
      'userEmail': userEmail,
      'swapStatus': swapStatus,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  /// Create a copy of this Book with updated fields
  Book copyWith({
    String? id,
    String? title,
    String? author,
    BookCondition? condition,
    String? coverImageUrl,
    String? userId,
    String? userEmail,
    String? swapStatus,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      condition: condition ?? this.condition,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      userId: userId ?? this.userId,
      userEmail: userEmail ?? this.userEmail,
      swapStatus: swapStatus ?? this.swapStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}


