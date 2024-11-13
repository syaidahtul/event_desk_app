import 'package:event_deskop_app/features/auth/auth_provider.dart';
import 'package:event_deskop_app/features/event_category/event_category_view.dart';
import 'package:event_deskop_app/features/events/events_service.dart';
import 'package:event_deskop_app/main.dart';
import 'package:event_deskop_app/models/events.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventsView extends StatefulWidget {
  const EventsView({super.key});
  @override
  _EventsViewState createState() => _EventsViewState();
}

class _EventsViewState extends State<EventsView> {
  final EventsService _service = EventsService();
  late Future<List<Events>> _events;

  @override
  void initState() {
    super.initState();
    _events = _service.fetchEvent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: Theme.of(context).primaryColor,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset("assets/images/perbadanan_putrajaya-logo.png"),
        ),
        leadingWidth: 100,
        titleTextStyle: const TextStyle(
            color: Colors.white70,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'Roboto'),
        title: const Text("Event App"),
        actions: [
          IconButton(
            onPressed: () async {
              final authService =
                  Provider.of<AuthProvider>(context, listen: false);
              await authService.logout(); // Call logout once

              // Navigate to LoginPage after logout
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: FutureBuilder<List<Events>>(
              future: _events,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No events found'));
                }

                final events = snapshot.data!;
                return ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];
                    return _buildEventCard(context, event);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildEventCard(BuildContext context, Events event) {
  return InkWell(
    onTap: () {
      // Navigate to the EventDetailView, passing the event data
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EventCategoryView(event: event),
        ),
      );
    },
    child: Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            event.logoUrl != null
                ? Image.network(
                    event.logoUrl!,
                    width: 50,
                    height: 50,
                    fit: BoxFit.contain,
                  )
                : Image.asset(
                    'assets/images/perbadanan_putrajaya-logo.png',
                    width: 50,
                    height: 50,
                    fit: BoxFit.contain,
                  ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Date: ${event.formattedStartDate} - ${event.formattedEndDate}',
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
