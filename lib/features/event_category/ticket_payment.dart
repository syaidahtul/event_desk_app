import 'package:event_deskop_app/features/auth/logout.dart';
import 'package:event_deskop_app/features/event_category/ticket_provider.dart';
import 'package:event_deskop_app/models/events.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TicketPayment extends StatelessWidget {
  final Events event;
  final List<Map<String, dynamic>> selectedTickets;

  const TicketPayment({
    super.key,
    required this.event,
    required this.selectedTickets,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildButton(
                  context,
                  "Cash",
                  () {
                    _buyTickets(context, "cash");
                  },
                ),
                _buildButton(
                  context,
                  "QR",
                  () {
                    _buyTickets(context, "qr");
                  },
                ),
                _buildButton(
                  context,
                  "Terminal",
                  () {
                    _buyTickets(context, "terminal");
                  },
                ),
              ],
            ),
          ),
          // Expanded(
          //   child: ListView.builder(
          //     itemCount: selectedTickets.length,
          //     itemBuilder: (context, index) {
          //       final ticket = selectedTickets[index];
          //       return ListTile(
          //         title: Text("Category ID: ${ticket['id']}"),
          //         subtitle: Text("Quantity: ${ticket['quantity']}"),
          //       );
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      toolbarHeight: 100,
      backgroundColor: Theme.of(context).primaryColorLight,
      title: Row(
        children: [
          event.logoUrl != null
              ? Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Image.network(
                    event.logoUrl!,
                    width: 70,
                    height: 70,
                    fit: BoxFit.contain,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Image.asset(
                    'assets/images/perbadanan_putrajaya-logo.png',
                    width: 70,
                    height: 70,
                    fit: BoxFit.contain,
                  ),
                ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              event.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () => logoutAndNavigate(context),
          icon: const Icon(Icons.logout),
        ),
      ],
    );
  }

  Widget _buildButton(
      BuildContext context, String title, Function() onPressed) {
    return SizedBox(
      width: 100,
      child: MaterialButton(
        color: Theme.of(context).primaryColor,
        textColor: Colors.black,
        onPressed: onPressed,
        padding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: Colors.grey.shade400),
        ),
        child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  void _buyTickets(BuildContext context, String paymentMethod) {
    final ticketProvider = Provider.of<TicketProvider>(context, listen: false);
    ticketProvider.buyTickets(
      event,
      selectedTickets,
      paymentMethod,
      context, // Pass context for navigation on success
    );
  }
}
