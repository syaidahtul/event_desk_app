import 'package:event_deskop_app/core/component/custom_button_widget.dart';
import 'package:event_deskop_app/features/auth/logout.dart';
import 'package:event_deskop_app/features/event_category/ticket_payment.dart';
import 'package:event_deskop_app/features/event_category/ticket_provider.dart';
import 'package:event_deskop_app/features/event_category/ticket_purchase.dart';
import 'package:event_deskop_app/models/events.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventCategoryView extends StatelessWidget {
  final Events event;

  const EventCategoryView({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Provider.of<TicketProvider>(context, listen: false).resetTicketCounts();
        return true;
      },
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tickets:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildTicketList(),
              const SizedBox(height: 16),
              _buildTicketSummary(context),
              const SizedBox(height: 16),
              _buildBuyButton(context, event),
            ],
          ),
        ),
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

  Widget _buildTicketList() {
    return Expanded(
      child: event.categories != null && event.categories!.isNotEmpty
          ? ListView.builder(
              itemCount: event.categories!.length,
              itemBuilder: (context, index) {
                final category = event.categories![index];
                return TicketPurchase(category: category);
              },
            )
          : const Center(
              child: Text('No categories available'),
            ),
    );
  }

  Widget _buildTicketSummary(BuildContext context) {
    return Consumer<TicketProvider>(
      builder: (context, manager, child) => Table(
        columnWidths: const {
          0: FlexColumnWidth(),
          1: FixedColumnWidth(100),
        },
        children: [
          TableRow(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  "Total Tickets:",
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 14),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  "${manager.totalTickets}",
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
          TableRow(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  "Total Price:",
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 14),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  "RM ${manager.totalPrice.toStringAsFixed(2)}",
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBuyButton(BuildContext context, Events event) {
    return Align(
      alignment: Alignment.centerRight,
      child: CustomButtonWidget(
        onPressed: () {
          final manager = Provider.of<TicketProvider>(context, listen: false);

          // Retrieve the selected tickets with non-zero quantities
          final selectedTickets = manager.ticketCounts.entries
              .where((entry) => entry.value > 0)
              .map((entry) => {
                    "id": entry.key,
                    "quantity": entry.value,
                  })
              .toList();

          // Navigate to TicketPayment and pass the event and selectedTickets
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TicketPayment(
                event: event,
                selectedTickets: selectedTickets,
              ),
            ),
          );
        },
        tooltip: 'Confirm Purchase',
        btnName: 'Confirm Purchase',
      ),
    );
  }
}
