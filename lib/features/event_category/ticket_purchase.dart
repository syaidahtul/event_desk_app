import 'package:event_deskop_app/features/event_category/ticket_provider.dart';
import 'package:event_deskop_app/models/event_categories.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TicketPurchase extends StatelessWidget {
  final EventCategories? category;

  const TicketPurchase({super.key, this.category});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category!.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(category!.description),
                  ],
                ),
              ),
              Text('RM ${category?.price.toStringAsFixed(2)}'),
              const SizedBox(width: 16),
              _buildTicketCounter(context),
            ],
          ),
        ),
        Divider(
          color: Colors.grey.shade800,
          thickness: 1,
        ),
      ],
    );
  }

  Widget _buildTicketCounter(BuildContext context) {
    return Consumer<TicketProvider>(
      builder: (context, manager, child) => Container(
        decoration: BoxDecoration(
          color: Colors.purple.shade50,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Theme.of(context).primaryColorLight),
        ),
        child: Row(
          children: <Widget>[
            _buildTicketCountButton(
              context,
              Icons.remove,
              () => manager.decrementTicket(category!.id, category!.price),
              "Decrease ticket count",
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                '${manager.ticketCounts[category?.id] ?? 0}',
                style: const TextStyle(fontSize: 18),
              ),
            ),
            _buildTicketCountButton(
              context,
              Icons.add,
              () => manager.incrementTicket(category!.id, category!.price),
              "Increase ticket count",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTicketCountButton(BuildContext context, IconData icon,
      VoidCallback onPressed, String tooltip) {
    return Tooltip(
      message: tooltip,
      child: MaterialButton(
        minWidth: 36,
        color: Theme.of(context).primaryColor,
        textColor: Colors.white,
        onPressed: onPressed,
        padding: const EdgeInsets.all(8),
        child: Icon(icon, size: 24),
      ),
    );
  }
}
