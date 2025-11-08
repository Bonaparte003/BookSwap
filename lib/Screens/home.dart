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

    // If MyListings tab is selected, wrap everything in DefaultTabController
    if (selectedIndex == 1) {
      return DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 252, 252, 252),
          appBar: AppBar(
            title: const Text('My Listings', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            centerTitle: true,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: Color.fromARGB(255, 250, 174, 22)),
            ),
            backgroundColor: const Color.fromARGB(255, 5, 22, 46),
            foregroundColor: Colors.white,
            titleTextStyle: const TextStyle(color: Colors.white),
            bottom: const TabBar(
              labelColor: const Color.fromARGB(255, 250, 174, 22),
              unselectedLabelColor: Colors.white,
              indicatorColor: const Color.fromARGB(255, 250, 174, 22),
              tabs: [
                Tab(text: 'My Books'),
                Tab(text: 'My Offers'),
              ],
            ),
          ),
          body: IndexedStack(
            index: selectedIndex,
            children: screens,
          ),
          bottomNavigationBar: BottomNavigation(context, selectedIndex: selectedIndex),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.addBook);
            },
            backgroundColor: const Color.fromARGB(255, 5, 22, 46),
            child: const Icon(
              Icons.add,
              color: Color.fromARGB(255, 255, 255, 255),
              size: 30,
            ),
          ),
        ),
      );
    }

    // Conditional appBar based on selected tab
    PreferredSizeWidget? appBar;
    if (selectedIndex == 2) {
      // Chats tab - show "Chat Section"
      appBar = AppBar(
        toolbarHeight: 80,
        actionsPadding: EdgeInsets.all(10),
        backgroundColor: const Color.fromARGB(255, 5, 22, 46),
        titleTextStyle: TextStyle(color: Colors.white),
        title: Text('Chat Section', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
          onPressed: () async {
            if (context.mounted) {
              Navigator.pushNamed(context, AppRoutes.home);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Error logging out'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          icon: Icon(Icons.arrow_back, color: const Color.fromARGB(255, 250, 174, 22)),
        ),
        actions: [
          Container(
            width: 40,
            height: 40,
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: ClipOval(
              child: (user?.photoURL != null && user!.photoURL!.isNotEmpty)
                  ? Image(
                      image: NetworkImage(user.photoURL!),
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    )
                  : CircleAvatar(
                      radius: 18,
                      backgroundColor: const Color.fromARGB(255, 190, 190, 190),
                      child: Text(
                        (user?.displayName != null && user!.displayName!.isNotEmpty)
                            ? user.displayName!.substring(0, 1).toUpperCase()
                            : (user?.email != null && user!.email!.isNotEmpty)
                                ? user.email!.substring(0, 1).toUpperCase()
                                : '?',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
            ),
          ),
        ],
      );
    } else if (selectedIndex == 3) {
      // Settings tab - show "Profile Settings"
      appBar = AppBar(
        toolbarHeight: 80,
        actionsPadding: EdgeInsets.all(10),
        backgroundColor: const Color.fromARGB(255, 5, 22, 46),
        titleTextStyle: TextStyle(color: Colors.white),
        title: Text('Profile Settings', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
          onPressed: () async {
            if (context.mounted) {
              Navigator.pushNamed(context, AppRoutes.home);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Error logging out'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          icon: Icon(Icons.arrow_back, color: const Color.fromARGB(255, 250, 174, 22)),
        ),
        actions: [
          Container(
            width: 40,
            height: 40,
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: ClipOval(
              child: (user?.photoURL != null && user!.photoURL!.isNotEmpty)
                  ? Image(
                      image: NetworkImage(user.photoURL!),
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    )
                  : CircleAvatar(
                      radius: 18,
                      backgroundColor: const Color.fromARGB(255, 190, 190, 190),
                      child: Text(
                        (user?.displayName != null && user!.displayName!.isNotEmpty)
                            ? user.displayName!.substring(0, 1).toUpperCase()
                            : (user?.email != null && user!.email!.isNotEmpty)
                                ? user.email!.substring(0, 1).toUpperCase()
                                : '?',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
            ),
          ),
        ],
      );
    } else {
      appBar = topNavigation(context, user, ref);
    }

    // For other tabs, use the regular topNavigation
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 252, 252, 252),
      appBar: appBar,
      body: IndexedStack(
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
      color: const Color.fromARGB(255, 248, 248, 248),
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
