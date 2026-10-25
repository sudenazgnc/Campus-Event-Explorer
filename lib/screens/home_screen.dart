import 'package:flutter/material.dart';
import '../data/initial_events.dart';
import '../models/campus_event.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/event_card.dart';
import '../widgets/search_filter_header.dart';
import 'event_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<CampusEvent> _events = createInitialEvents();
  final TextEditingController _searchController = TextEditingController();

  final List<String> _categories = const [
    'All',
    'Technology',
    'Arts',
    'Sports',
  ];

  String _searchQuery = '';
  String _selectedCategory = 'All';
  int _currentTabIndex = 0; // 0: Explore, 1: Favorites, 2: My Events

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  int get _totalJoinedCount => _events.where((e) => e.isJoined).length;
  int get _totalFavoritesCount => _events.where((e) => e.isFavorite).length;

  List<CampusEvent> get _baseEventsForCurrentTab {
    switch (_currentTabIndex) {
      case 1:
        return _events.where((e) => e.isFavorite).toList();
      case 2:
        return _events.where((e) => e.isJoined).toList();
      case 0:
      default:
        return _events;
    }
  }

  List<CampusEvent> get _filteredEvents {
    final String normalizedQuery = _searchQuery.trim().toLowerCase();
    return _baseEventsForCurrentTab.where((event) {
      final bool matchesTitle = normalizedQuery.isEmpty ||
          event.title.toLowerCase().contains(normalizedQuery);
      final bool matchesCategory =
          _selectedCategory == 'All' || event.category == _selectedCategory;
      return matchesTitle && matchesCategory;
    }).toList();
  }

  void _clearSearchAndFilters() {
    setState(() {
      _searchController.clear();
      _searchQuery = '';
      _selectedCategory = 'All';
    });
  }

  void _toggleFavorite(CampusEvent event) {
    setState(() {
      event.isFavorite = !event.isFavorite;
    });
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          event.isFavorite
              ? 'Added "${event.title}" to Favorites.'
              : 'Removed "${event.title}" from Favorites.',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _handleParticipationAction(CampusEvent event) async {
    if (event.isJoined) {
      // Cancel participation confirmation dialog
      final bool? confirmed = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text(
            'Cancel Participation?',
            style: TextStyle(
              fontFamily: 'NotoSerif',
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Are you sure you want to cancel your participation in this event?',
              ),
              const SizedBox(height: 12),
              Text(
                event.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text('Date/Time: ${event.dateTime}'),
              Text('Venue: ${event.venue}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('No'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade700,
                foregroundColor: Colors.white,
              ),
              child: const Text('Yes'),
            ),
          ],
        ),
      );

      if (confirmed == true && mounted) {
        setState(() {
          event.isJoined = false;
          if (event.availablePlaces < event.totalCapacity) {
            event.availablePlaces += 1;
          }
        });
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Canceled participation in "${event.title}". 1 place restored.',
            ),
          ),
        );
      }
    } else {
      // Guard against full or already-joined events
      if (event.isFull) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('This event is Full and cannot be joined.'),
          ),
        );
        return;
      }

      // Join confirmation dialog showing title, date/time, and venue with Yes and No options
      final bool? confirmed = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text(
            'Confirm Event Participation',
            style: TextStyle(
              fontFamily: 'NotoSerif',
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Would you like to join the following campus event?'),
              const SizedBox(height: 12),
              Text(
                event.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text('Date/Time: ${event.dateTime}'),
              Text('Venue: ${event.venue}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('No'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Yes'),
            ),
          ],
        ),
      );

      if (confirmed == true && mounted) {
        if (!event.isJoined && event.availablePlaces > 0) {
          setState(() {
            event.isJoined = true;
            event.availablePlaces -= 1;
          });
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Successfully joined "${event.title}"! (${event.availablePlaces} places remaining)',
              ),
            ),
          );
        }
      }
    }
  }

  void _openEventDetails(CampusEvent event) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => EventDetailsScreen(
          event: event,
          onToggleFavorite: () => _toggleFavorite(event),
          onParticipationAction: () => _handleParticipationAction(event),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    final bool hasActiveFilter =
        _searchQuery.trim().isNotEmpty || _selectedCategory != 'All';

    if (_currentTabIndex == 1 && _totalFavoritesCount == 0 && !hasActiveFilter) {
      return EmptyStateWidget(
        icon: Icons.favorite_border,
        title: 'No Favorite Events Yet',
        message:
            'Tap the heart icon on any event card or details screen to save events to your Favorites.',
        showClearButton: false,
        onClearFilters: _clearSearchAndFilters,
      );
    }

    if (_currentTabIndex == 2 && _totalJoinedCount == 0 && !hasActiveFilter) {
      return EmptyStateWidget(
        icon: Icons.event_busy,
        title: 'You Have Not Joined Any Events',
        message:
            'Explore upcoming campus events and tap Join to confirm your participation.',
        showClearButton: false,
        onClearFilters: _clearSearchAndFilters,
      );
    }

    return EmptyStateWidget(
      icon: Icons.search_off,
      title: 'No Matching Events Found',
      message:
          'No events in this view match "${_searchQuery.trim()}" under the "$_selectedCategory" category.',
      showClearButton: hasActiveFilter,
      onClearFilters: _clearSearchAndFilters,
    );
  }

  String get _currentTitle {
    switch (_currentTabIndex) {
      case 1:
        return 'Favorite Events';
      case 2:
        return 'My Joined Events';
      case 0:
      default:
        return 'Campus Event Explorer';
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<CampusEvent> displayedEvents = _filteredEvents;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _currentTitle,
          style: const TextStyle(
            fontFamily: 'NotoSerif',
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          SearchFilterHeader(
            searchController: _searchController,
            searchQuery: _searchQuery,
            selectedCategory: _selectedCategory,
            categories: _categories,
            matchingCount: displayedEvents.length,
            totalJoinedCount: _totalJoinedCount,
            onSearchChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
            onClearSearch: _clearSearchAndFilters,
            onCategorySelected: (category) {
              setState(() {
                _selectedCategory = category;
              });
            },
          ),
          Expanded(
            child: displayedEvents.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.only(top: 6, bottom: 20),
                    itemCount: displayedEvents.length,
                    itemBuilder: (context, index) {
                      final CampusEvent event = displayedEvents[index];
                      return EventCard(
                        event: event,
                        onTapDetails: () => _openEventDetails(event),
                        onToggleFavorite: () => _toggleFavorite(event),
                        onParticipationAction: () =>
                            _handleParticipationAction(event),
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTabIndex,
        onTap: (index) {
          setState(() {
            _currentTabIndex = index;
          });
        },
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            activeIcon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.favorite_outline),
            activeIcon: const Icon(Icons.favorite),
            label: 'Favorites ($_totalFavoritesCount)',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.event_available_outlined),
            activeIcon: const Icon(Icons.event_available),
            label: 'My Events ($_totalJoinedCount)',
          ),
        ],
      ),
    );
  }
}
