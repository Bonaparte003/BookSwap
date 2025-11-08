import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bookswap/Layouts/top-navigation.dart';
import 'package:bookswap/Layouts/bottom-navigation.dart';
import 'package:bookswap/Layouts/browse-layout.dart';
import 'package:bookswap/Layouts/listing-layout.dart';
import 'package:bookswap/Layouts/chat-layout.dart';
import 'package:bookswap/Layouts/settings-layout.dart';
import 'package:bookswap/Screens/my_offers.dart';
import 'package:bookswap/routes/routes.dart';
import 'package:bookswap/Firebase/auth_providers.dart';

/// Provider for current selected tab index
final selectedTabIndexProvider = StateProvider<int>((ref) => 0);

class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(selectedTabIndexProvider);
    final user = ref.watch(currentUserProvider);

    // List of screens to display
    final screens = [
      const BrowseScreen(),
      const MyListingsScreen(),
      const ChatsScreen(),
      const SettingsScreen(),
    ];

    // Conditional appBar based on selected tab
    PreferredSizeWidget? appBar;
    if (selectedIndex == 1) {
      // MyListingsScreen has its own appBar with tabs
      appBar = AppBar(
        title: const Text('My Listings'),
        backgroundColor: const Color.fromARGB(255, 53, 77, 197),
        foregroundColor: Colors.white,
        titleTextStyle: const TextStyle(color: Colors.white),
        bottom: const TabBar(
          labelColor: Color.fromARGB(255, 220, 187, 133),
          unselectedLabelColor: Colors.white,
          indicatorColor: Color.fromARGB(255, 220, 187, 133),
          tabs: [
            Tab(text: 'My Books'),
            Tab(text: 'My Offers'),
          ],
        ),
      );
    } else {
      appBar = topNavigation(context, user);
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 252, 252, 252),
      appBar: appBar,
      body: selectedIndex == 1
          ? DefaultTabController(
              length: 2,
              child: IndexedStack(
                index: selectedIndex,
                children: screens,
              ),
            )
          : IndexedStack(
              index: selectedIndex,
              children: screens,
            ),
      bottomNavigationBar: BottomNavigation(context, selectedIndex: selectedIndex),
      floatingActionButton: selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.addBook);
              },
                backgroundColor: const Color.fromARGB(255, 15, 23, 61),
              child: const Icon(
                Icons.add,
                color: Color.fromARGB(255, 255, 255, 255),
                size: 30,
              ),
            )
          : selectedIndex == 1
              ? FloatingActionButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.addBook);
                  },
                  backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                  child: const Icon(
                    Icons.add,
                    color: Color.fromARGB(255, 220, 187, 133),
                    size: 30,
                  ),
                )
              : null,
    );
  }
}

/// Browse Screen - Shows all book listings
class BrowseScreen extends StatelessWidget {
  const BrowseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const BrowseLayout();
  }
}

/// My Listings Screen - Shows user's own books with tab for My Offers
class MyListingsScreen extends StatelessWidget {
  const MyListingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 253, 230, 193),
      child: const TabBarView(
        children: [
          ListingLayout(),
          MyOffersScreen(),
        ],
      ),
    );
  }
}

/// Chats Screen - Shows chat conversations
class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ChatLayout();
  }
}

/// Settings Screen - Shows user settings and profile
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SettingsLayout();
  }
}
