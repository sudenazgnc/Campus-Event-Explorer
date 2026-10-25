import 'package:flutter/material.dart';
import '../models/campus_event.dart';
import 'enlarged_image_screen.dart';

class EventDetailsScreen extends StatefulWidget {
  final CampusEvent event;
  final VoidCallback onToggleFavorite;
  final Future<void> Function() onParticipationAction;

  const EventDetailsScreen({
    super.key,
    required this.event,
    required this.onToggleFavorite,
    required this.onParticipationAction,
  });

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  void _handleFavoriteTap() {
    widget.onToggleFavorite();
    setState(() {});
  }

  Future<void> _handleParticipationTap() async {
    await widget.onParticipationAction();
    if (mounted) {
      setState(() {});
    }
  }

  void _openEnlargedImage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => EnlargedImageScreen(event: widget.event),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final CampusEvent event = widget.event;
    final bool isFullAndNotJoined = event.isFull && !event.isJoined;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Details'),
        actions: [
          IconButton(
            tooltip: event.isFavorite
                ? 'Remove from Favorites'
                : 'Add to Favorites',
            icon: Icon(
              event.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: event.isFavorite ? Colors.redAccent : null,
            ),
            onPressed: _handleFavoriteTap,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Double-tap image to open enlarged image viewer screen
            GestureDetector(
              onDoubleTap: _openEnlargedImage,
              child: Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.asset(
                      event.imagePath,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.72),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.zoom_out_map,
                              color: Colors.white, size: 14),
                          SizedBox(width: 5),
                          Text(
                            'Double-tap image to enlarge',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Event ID & Category row
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          event.category,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'ID: ${event.id}',
                        style: TextStyle(
                          fontSize: 13,
                          color: Theme.of(context).colorScheme.outline,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      if (event.isJoined)
                        Chip(
                          avatar: const Icon(Icons.check_circle,
                              size: 16, color: Colors.white),
                          label: const Text(
                            'Joined',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          backgroundColor: Colors.teal.shade700,
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Event title in custom NotoSerif font
                  Text(
                    event.title,
                    style: const TextStyle(
                      fontFamily: 'NotoSerif',
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Event metadata card
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .surfaceContainerHighest
                          .withOpacity(0.45),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.calendar_month,
                                color: Theme.of(context).colorScheme.primary),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                event.dateTime,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 20),
                        Row(
                          children: [
                            Icon(Icons.place,
                                color: Theme.of(context).colorScheme.primary),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                event.venue,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 20),
                        Row(
                          children: [
                            Icon(
                              event.isFull
                                  ? Icons.block
                                  : Icons.people_alt_outlined,
                              color: event.isFull
                                  ? Colors.red.shade700
                                  : Colors.green.shade700,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Capacity: ${event.totalCapacity}  •  Available: ${event.availablePlaces} (${event.isFull ? "Full" : "Open"})',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: event.isFull
                                      ? Colors.red.shade700
                                      : Colors.green.shade800,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'About This Event',
                    style: TextStyle(
                      fontFamily: 'NotoSerif',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    event.description,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 28),
                  // Favorite and Participation controls
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _handleFavoriteTap,
                          icon: Icon(
                            event.isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: event.isFavorite ? Colors.redAccent : null,
                          ),
                          label: Text(
                            event.isFavorite ? 'Favorited' : 'Add Favorite',
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: event.isJoined
                            ? ElevatedButton.icon(
                                onPressed: _handleParticipationTap,
                                icon: const Icon(Icons.cancel_outlined),
                                label: const Text('Cancel Participation'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red.shade700,
                                  foregroundColor: Colors.white,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                ),
                              )
                            : ElevatedButton.icon(
                                onPressed: isFullAndNotJoined
                                    ? null
                                    : _handleParticipationTap,
                                icon: Icon(isFullAndNotJoined
                                    ? Icons.block
                                    : Icons.how_to_reg),
                                label: Text(isFullAndNotJoined
                                    ? 'Event Full'
                                    : 'Join Event'),
                                style: ElevatedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                ),
                              ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
