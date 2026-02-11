import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountInactivePage extends StatelessWidget {
  const AccountInactivePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.block_rounded,
                  color: theme.colorScheme.error, size: 70),
              const SizedBox(height: 28),
              Text(
                "Account Not Active",
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 18),
              Text(
                "Please contact your administrator or customer support to reactivate your account.",
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.black87,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      label: const Text("Close App"),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      onPressed: () {
                        exit(0);
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.support_agent_rounded,
                          color: Colors.blue),
                      label: const Text("Customer Support"),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        side:
                            BorderSide(color: Colors.blue.shade500, width: 1.6),
                        foregroundColor: Colors.blue.shade700,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      onPressed: helpCenter,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  helpCenter() async {
    String? encodeQueryParameters(Map<String, String> params) {
      return params.entries
          .map((MapEntry<String, String> e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
    }

    final Uri emailLaunchUri = Uri(
      scheme: "mailto",
      path: "admin@payhive.in",
      query: encodeQueryParameters(<String, String>{
        "subject": "payhive : Customer's issue",
        'body': 'Type your queries or issues here'
      }),
    );

    launchUrl(emailLaunchUri);
  }
}
