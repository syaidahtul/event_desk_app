import 'package:event_deskop_app/models/event_categories.dart';
import 'package:intl/intl.dart';

class Events {
  final int id;
  final String name;
  final String slug;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? logoUrl;
  final List<EventCategories>? categories;

  Events({
    required this.id,
    required this.name,
    required this.slug,
    this.startDate,
    this.endDate,
    this.logoUrl,
    this.categories,
  });

  String get formattedStartDate {
    if (startDate != null) {
      return DateFormat('dd/MM/yyyy').format(startDate!);
    }
    return 'Not available';
  }

  // Getter to format endDate
  String get formattedEndDate {
    if (endDate != null) {
      return DateFormat('dd/MM/yyyy').format(endDate!);
    }
    return 'Not available';
  }

  factory Events.fromJson(Map<String, dynamic> json) {
    return Events(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      startDate: json['started_at'] != null
          ? DateTime.parse(json['started_at'])
          : null,
      endDate:
          json['ended_at'] != null ? DateTime.parse(json['ended_at']) : null,
      logoUrl: json['logo'] != null ? json['logo']['original_url'] : null,
      categories: json['event_categories'] != null
          ? (json['event_categories'] as List)
              .map((category) => EventCategories.fromJson(category))
              .toList()
          : null,
    );
  }
}
