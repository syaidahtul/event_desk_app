import 'dart:convert';

import 'package:event_deskop_app/core/utils/app_constant.dart';
import 'package:event_deskop_app/features/event_category/ticket_print.dart';
import 'package:event_deskop_app/models/events.dart';
import 'package:flutter/material.dart';
import 'package:event_deskop_app/models/event_categories.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class TicketProvider with ChangeNotifier {
  final List<EventCategories> _categories = [];
  final Map<int, int> ticketCounts = {};
  double _totalPrice = 0.0;

  List<EventCategories> get categories => _categories;

  int get totalTickets =>
      ticketCounts.values.fold(0, (total, count) => total + count);

  double get totalPrice => _totalPrice;

  List<Map<String, dynamic>> get selectedTickets => ticketCounts.entries
      .where((entry) => entry.value > 0)
      .map((entry) => {
            "id": entry.key,
            "quantity": entry.value,
          })
      .toList();

  void setTicketCount(int categoryId, int count, double price) {
    final currentCount = ticketCounts[categoryId] ?? 0;
    _totalPrice += (count - currentCount) * price;
    ticketCounts[categoryId] = count;
    notifyListeners();
  }

  void incrementTicket(int categoryId, double price) {
    ticketCounts[categoryId] = (ticketCounts[categoryId] ?? 0) + 1;
    _totalPrice += price;
    notifyListeners();
  }

  void decrementTicket(int categoryId, double price) {
    if (ticketCounts[categoryId] != null && ticketCounts[categoryId]! > 0) {
      ticketCounts[categoryId] = ticketCounts[categoryId]! - 1;
      _totalPrice -= price;
      notifyListeners();
    }
  }

  void resetTicketCounts() {
    ticketCounts.clear();
    _totalPrice = 0.0;
    notifyListeners();
  }

  Future<void> buyTickets(
      Events event,
      List<Map<String, dynamic>> selectedTickets,
      String paymentMethod,
      BuildContext context) async {
    final String endpoint = "/events/${event.slug}/offline-tickets/purchase";
    final Uri url = Uri.parse("${AppConstant.eventBaseUrl}$endpoint");
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('userDetails');
    Map<String, dynamic> user = jsonDecode(userJson!);
    final authToken = prefs.getString('authToken');

    final body = {
      "event_id": event.id,
      "sold_by_id": user["id"],
      "payment_method": paymentMethod,
      "categories": selectedTickets,
    };

    try {
      final response = await http
          .post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $authToken",
        },
        body: jsonEncode(body),
      )
          .timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException(
              "The connection has timed out, please try again!");
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        resetTicketCounts();
        final responseData = jsonDecode(response.body);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TicketPrint(
              event: event,
              qrData: responseData['ticket'],
            ),
          ),
        );
      } else {
        print("Failed to purchase tickets: ${response.statusCode}");
      }
    } on TimeoutException catch (_) {
      print("The request timed out. Please try again later.");
    } catch (error) {
      print("Error during ticket purchase: $error");
    }
  }
}
