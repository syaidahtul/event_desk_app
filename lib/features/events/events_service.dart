import 'dart:convert';
import 'package:event_deskop_app/core/utils/app_constant.dart';
import 'package:event_deskop_app/models/events.dart';
import 'package:http/http.dart' as http;

class EventsService {
  Future<List<Events>> fetchEvent() async {
    const String endpoint = "/events";
    const String url = "${AppConstant.eventBaseUrl}$endpoint";
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List eventsData = jsonData['events']['data'];
        return eventsData.map((data) => Events.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load events');
      }
    } catch (error) {
      throw Exception('Failed to load events: $error');
    }
  }
}
