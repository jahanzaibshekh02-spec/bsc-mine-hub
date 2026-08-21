import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const SparkApp());
}

class SparkApp extends StatelessWidget {
  const SparkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SPARK Miner PRO',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Color(0xFF0A0E1A),
      ),
      home: const MinerScreen(),
    );
  }
}

class MinerScreen extends StatefulWidget {
  const MinerScreen({super.key});

  @override
  State<MinerScreen> createState() => _MinerScreenState();
}

class _MinerScreenState extends State<MinerScreen> {
  double balance = 1247.5000;
  double hashRate = 45.8;
  bool mining = false;
  Timer? timer;

  void toggleMining() {
    setState(() {
      mining = !mining;
      if (mining) {
        timer = Timer.periodic(Duration(seconds: 1), (t) {
          setState(() {
            balance += 0.0025;
            hashRate = 44 + (t.tick % 5);
          });
        });
      } else {
        timer?.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('⚡️ SPARK MINER PRO', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Color(0xFF0A0E1A),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Color(0xFF1A2332),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Color(0xFF00FF88).withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  Text('TOTAL BALANCE', style: TextStyle(color: Colors.white54, letterSpacing: 1)),
                  SizedBox(height: 10),
                  Text('${balance.toStringAsFixed(4)} BSC', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                  SizedBox(height: 10),
                  Text('≈ \$${(balance * 650).toStringAsFixed(2)}', style: TextStyle(color: Color(0xFF00FF88))),
                ],
              ),
            ),
            SizedBox(height: 30),
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(color: Color(0xFF1A2332), borderRadius: BorderRadius.circular(15)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(children: [Text('Hash Rate'), Text('$hashRate MH/s', style: TextStyle(color: Color(0xFF00FF88), fontWeight: FontWeight.bold))]),
                  Column(children: [Text('Miners'), Text('1,247 Active', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))]),
                ],
              ),
            ),
            Spacer(),
            Icon(Icons.memory, size: 100, color: mining ? Color(0xFF00FF88) : Colors.white24),
            SizedBox(height: 10),
            Text(mining ? 'MINING IS ACTIVE' : 'MINING STOPPED', style: TextStyle(color: mining ? Color(0xFF00FF88) : Colors.white38, letterSpacing: 2, fontWeight: FontWeight.bold)),
            Spacer(),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: toggleMining,
                style: ElevatedButton.styleFrom(
                  backgroundColor: mining ? Colors.redAccent : Color(0xFF00FF88),
                  foregroundColor: mining ? Colors.white : Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: Text(mining ? '🛑 STOP MINING' : '⚡️ START MINING', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
