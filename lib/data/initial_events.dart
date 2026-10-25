import '../models/campus_event.dart';

List<CampusEvent> createInitialEvents() {
  return [
    CampusEvent(
      id: 'EVT-101',
      title: 'ESTU AI & Flutter Mobile Hackathon',
      category: 'Technology',
      dateTime: 'Nov 02, 2026 • 10:00 - 18:00',
      venue: 'Engineering Faculty Hall A-104',
      description:
          'Collaborate with fellow students to build cross-platform mobile prototypes using Flutter and Dart. Mentors from student tech clubs will guide teams through UI composition, layout widgets, and interactive prototyping.',
      imagePath: 'assets/images/tech_hackathon.png',
      totalCapacity: 60,
      availablePlaces: 14,
    ),
    CampusEvent(
      id: 'EVT-102',
      title: 'Cybersecurity & Cloud Defense Workshop',
      category: 'Technology',
      dateTime: 'Nov 05, 2026 • 14:00 - 16:30',
      venue: 'Computer Engineering Lab B-202',
      description:
          'Hands-on training covering network traffic inspection, web application security fundamentals, and zero-trust architecture. Includes live attack-defense simulations in an isolated lab network.',
      imagePath: 'assets/images/cyber_workshop.png',
      totalCapacity: 40,
      availablePlaces: 0, // Initially full event requirement
    ),
    CampusEvent(
      id: 'EVT-103',
      title: 'Modern Ceramic & Digital Arts Exhibition',
      category: 'Arts',
      dateTime: 'Nov 08, 2026 • 13:30 - 17:00',
      venue: 'Campus Fine Arts Gallery',
      description:
          'Discover original ceramic sculptures, generative digital projections, and mixed-media installations curated by the Department of Industrial Design and Fine Arts students.',
      imagePath: 'assets/images/art_exhibition.png',
      totalCapacity: 25,
      availablePlaces: 1, // Initially 1 available place requirement
    ),
    CampusEvent(
      id: 'EVT-104',
      title: 'Autumn Campus Theater Night: The Glass Archive',
      category: 'Arts',
      dateTime: 'Nov 12, 2026 • 19:30 - 21:30',
      venue: 'ESTU Main Cultural Center Stage',
      description:
          'An original two-act stage drama performed by the University Student Drama Society exploring memory, technology, and human connection. Followed by a backstage Q&A session with the cast.',
      imagePath: 'assets/images/theater_festival.png',
      totalCapacity: 120,
      availablePlaces: 32,
    ),
    CampusEvent(
      id: 'EVT-105',
      title: 'ESTU 10K Autumn Campus Run',
      category: 'Sports',
      dateTime: 'Nov 15, 2026 • 09:00 - 12:00',
      venue: 'Iki Eylul Campus Main Stadium Track',
      description:
          'Lace up your running shoes for the annual 10K and 5K campus circuit race. Open to runners of all experience levels with hydration stations, finisher medals, and post-race stretching sessions.',
      imagePath: 'assets/images/campus_marathon.png',
      totalCapacity: 100,
      availablePlaces: 18,
    ),
    CampusEvent(
      id: 'EVT-106',
      title: 'Inter-Faculty 3x3 Basketball Cup',
      category: 'Sports',
      dateTime: 'Nov 19, 2026 • 16:00 - 20:00',
      venue: 'Indoor Sports Arena Court 1',
      description:
          'Fast-paced half-court 3x3 basketball tournament featuring teams from Engineering, Science, Architecture, and Aviation faculties. Register to compete or reserve a courtside spectator spot.',
      imagePath: 'assets/images/basketball_cup.png',
      totalCapacity: 80,
      availablePlaces: 9,
    ),
    CampusEvent(
      id: 'EVT-107',
      title: 'Open Source Dart & Mobile UI Design Clinic',
      category: 'Technology',
      dateTime: 'Nov 23, 2026 • 15:00 - 17:00',
      venue: 'Central Library Seminar Room 3',
      description:
          'Bring your mobile programming projects for peer code reviews, custom typography styling tips, and responsive layout patterns using Row, Column, Padding, and Expanded.',
      imagePath: 'assets/images/tech_hackathon.png',
      totalCapacity: 35,
      availablePlaces: 7,
    ),
    CampusEvent(
      id: 'EVT-108',
      title: 'Campus Acoustic & Sketchbook Evening',
      category: 'Arts',
      dateTime: 'Nov 27, 2026 • 18:00 - 20:30',
      venue: 'Student Center Courtyard Lounge',
      description:
          'An evening combining live acoustic guitar sets with live charcoal and watercolor sketching sessions. Drawing boards and basic sketching materials are provided at the venue.',
      imagePath: 'assets/images/art_exhibition.png',
      totalCapacity: 45,
      availablePlaces: 12,
    ),
  ];
}
