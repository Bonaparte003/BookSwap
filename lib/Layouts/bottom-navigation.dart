import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bookswap/Screens/home.dart';

/// Bottom Navigation Bar Widget
class BottomNavigation extends ConsumerWidget {
  final int selectedIndex;

  const BottomNavigation(BuildContext context, {required this.selectedIndex, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
  return ClipRRect(
    child: Container(
      height: MediaQuery.of(context).size.height * 0.09,
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 0, 0, 0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
            _NavItem(
              icon: Icons.home,
              label: 'Browse',
              isSelected: selectedIndex == 0,
              onTap: () => ref.read(selectedTabIndexProvider.notifier).state = 0,
            ),
            _NavItem(
              icon: Icons.library_books,
              label: 'My Listings',
              isSelected: selectedIndex == 1,
              onTap: () => ref.read(selectedTabIndexProvider.notifier).state = 1,
            ),
            _NavItem(
              icon: Icons.message,
              label: 'Chats',
              isSelected: selectedIndex == 2,
              onTap: () => ref.read(selectedTabIndexProvider.notifier).state = 2,
            ),
            _NavItem(
              icon: Icons.settings,
              label: 'Settings',
              isSelected: selectedIndex == 3,
              onTap: () => ref.read(selectedTabIndexProvider.notifier).state = 3,
            ),
        ],
      ),
    ),
  );
}
}

/// Navigation Item Widget
class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? const Color.fromARGB(255, 220, 187, 133)
                  : Colors.white,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? const Color.fromARGB(255, 220, 187, 133)
                    : Colors.white,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
