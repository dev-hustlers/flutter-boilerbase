import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boilerbase/services/revenue_cat_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // After logging in successfully, this page is shown.
    // We immediately check and show the paywall if needed!
    _checkAndShowPaywall();
  }

  void _checkAndShowPaywall() async {
    // This will only show if they don't have the "careerbridge Pro" entitlement
    await RevenueCatService.presentPaywall();
  }

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: signUserOut,
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("LOGGED IN!"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                RevenueCatService.presentCustomerCenter();
              },
              child: const Text("Manage Subscription"),
            )
          ],
        ),
      ),
    );
  }
}
