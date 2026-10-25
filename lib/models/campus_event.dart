class CampusEvent {
  final String id;
  final String title;
  final String category;
  final String dateTime;
  final String venue;
  final String description;
  final String imagePath;
  final int totalCapacity;
  int availablePlaces;
  bool isFavorite;
  bool isJoined;

  CampusEvent({
    required this.id,
    required this.title,
    required this.category,
    required this.dateTime,
    required this.venue,
    required this.description,
    required this.imagePath,
    required this.totalCapacity,
    required this.availablePlaces,
    this.isFavorite = false,
    this.isJoined = false,
  }) : assert(
          availablePlaces >= 0 && availablePlaces <= totalCapacity,
          'availablePlaces must remain between 0 and totalCapacity',
        );

  bool get isFull => availablePlaces <= 0;

  String get availabilityLabel {
    if (isFull) {
      return 'Full (0 / $totalCapacity places)';
    } else if (availablePlaces == 1) {
      return '1 place left (1 / $totalCapacity places)';
    }
    return '$availablePlaces / $totalCapacity places available';
  }
}
