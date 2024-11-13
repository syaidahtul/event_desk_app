import 'package:event_deskop_app/features/auth/auth_provider.dart';
import 'package:event_deskop_app/features/event_category/ticket_provider.dart';
import 'package:event_deskop_app/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


Future<void> logoutAndNavigate(BuildContext context) async {
  // to reset ticket counts
  final ticketProvider = Provider.of<TicketProvider>(context, listen: false);
  ticketProvider.resetTicketCounts();

  final authService = Provider.of<AuthProvider>(context, listen: false);
  await authService.logout();

  // Navigate to LoginPage and clear navigation stack
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (context) => const LoginPage()),
    (Route<dynamic> route) => false, // Remove all previous routes
  );
}
