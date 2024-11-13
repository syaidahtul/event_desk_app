import 'dart:convert';
import 'package:event_deskop_app/core/component/custom_button_widget.dart';
import 'package:event_deskop_app/features/events/events_view.dart';
import 'package:event_deskop_app/models/events.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TicketPrint extends StatelessWidget {
  final Events event;
  final Map<String, dynamic> qrData;

  const TicketPrint({
    super.key,
    required this.event,
    required this.qrData,
  });

  @override
  Widget build(BuildContext context) {
    final qrCodeData = jsonEncode(qrData);

    return Scaffold(
      appBar: AppBar(title: const Text("Confirmation")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: sa(qrCodeData, context),
          ),
        ),
      ),
    );
  }

  List<Widget> sa(String qrCodeData, BuildContext context) {
    return [
      const Text(
        "Thank you for your purchase!",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 20),
      Text(
        "Event: ${event.name}",
        style: const TextStyle(fontSize: 16),
      ),
      const SizedBox(height: 20),
      QrImageView(
        data: qrCodeData,
        version: QrVersions.auto,
        size: 200.0,
      ),
      const SizedBox(height: 20),
      const Text("Show this QR code at the event for entry."),
      const SizedBox(height: 20),
      CustomButtonWidget(
        onPressed: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    const EventsView()), // Replace EventPage() with the correct widget
            (route) => false, // Remove all previous routes
          );
        },
        btnName: "Print",
      ),
    ];
  }
}
