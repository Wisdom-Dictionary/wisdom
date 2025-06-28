import 'package:flutter/material.dart';

class AppDemoPage extends StatefulWidget {
  const AppDemoPage({super.key});

  @override
  State<AppDemoPage> createState() => _AppDemoPageState();
}

class _AppDemoPageState extends State<AppDemoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextFormField(),
      ),
    );
  }
}
