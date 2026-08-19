import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BSC Mine Hub',
      theme: ThemeData(primarySwatch: Colors.amber),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double balance = 0.00045;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BSC Mine Hub'), backgroundColor: Colors.amber),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.currency_bitcoin, size: 100, color: Colors.amber),
            const SizedBox(height: 20),
            const Text('Your Mining Balance', style: TextStyle(fontSize: 20)),
            Text('${balance.toStringAsFixed(5)} BNB', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15)),
              onPressed: () { setState(() { balance += 0.00001; }); },
              child: const Text('Start Mining', style: TextStyle(fontSize: 18, color: Colors.black)),
            ),
            const SizedBox(height: 20),
            const Text('Trusted Cloud Mining Simulator', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
