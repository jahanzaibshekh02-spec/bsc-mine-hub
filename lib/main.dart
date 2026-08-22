import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(debugShowCheckedModeBanner: false, home: SparkMiner()));
}

class SparkMiner extends StatefulWidget {
  const SparkMiner({super.key});
  @override
  State<SparkMiner> createState() => _SparkMinerState();
}

class _SparkMinerState extends State<SparkMiner> {
  double balance = 5.75;
  double hashRate = 125.0;
  bool isMining = true;
  int selectedIndex = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (isMining) {
        setState(() {
          balance += 0.00025;
        });
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080A0F),
      body: selectedIndex == 0 ? buildMine() : selectedIndex == 1 ? buildRefer() : buildWallet(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF11161F),
        selectedItemColor: const Color(0xFFFFD700),
        unselectedItemColor: Colors.white54,
        currentIndex: selectedIndex,
        onTap: (i) => setState(() => selectedIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.memory), label: 'MINE'),
          BottomNavigationBarItem(icon: Icon(Icons.group_add), label: 'REFER'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: 'WALLET'),
        ],
      ),
    );
  }

  Widget buildMine() {
    return SafeArea(
      child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text('SPARK MINER PRO', style: TextStyle(color: Color(0xFFFFD700), fontSize: 26, fontWeight: FontWeight.bold, letterSpacing: 2)),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: const Color(0xFFFFD700), width: 3), boxShadow: [BoxShadow(color: Color(0x4DFFD700), blurRadius: 30)]),
            child: Icon(Icons.bolt, size: 80, color: isMining ? const Color(0xFFFFD700) : Colors.grey),
          ),
          const SizedBox(height: 20),
          Text('${balance.toStringAsFixed(5)} BSC', style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
          Text('${hashRate.toStringAsFixed(1)} H/s', style: const TextStyle(color: Colors.white54)),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFD700), foregroundColor: Colors.black, padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15)),
            onPressed: () => setState(() => isMining = !isMining),
            child: Text(isMining ? 'STOP MINING' : 'START MINING', style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ]),
      ),
    );
  }

  Widget buildRefer() {
    return const Center(child: Text('Refer & Earn 10%', style: TextStyle(color: Colors.white, fontSize: 22)));
  }

  Widget buildWallet() {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text('${balance.toStringAsFixed(5)} BSC', style: const TextStyle(color: Color(0xFFFFD700), fontSize: 30, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFD700), foregroundColor: Colors.black),
          onPressed: () {},
          child: const Text('WITHDRAW'),
        )
      ]),
    );
  }
}
