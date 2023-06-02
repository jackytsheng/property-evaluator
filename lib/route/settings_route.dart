import 'package:flutter/material.dart';
import 'package:house_evaluator/components/themed_app_bar.dart';

class SettingsRoute extends StatelessWidget {
  const SettingsRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ThemedAppBar(
        title: "Budget settings",
        helpMessage:
            "To enable highlight for score, and to enable flagging budget, currency",
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Go back!'),
        ),
      ),
    );
  }
}
