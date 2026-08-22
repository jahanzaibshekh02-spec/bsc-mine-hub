import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(const BscMineHubApp());
}

class BscMineHubApp extends StatelessWidget {
  const BscMineHubApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BSC Mine Hub',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MineHomePage(),
    );
  }
}

class MineHomePage extends StatefulWidget {
  const MineHomePage({super.key});
  @override
  State<MineHomePage> createState() => _MineHomePageState();
}

class _MineHomePageState extends State<MineHomePage> with TickerProviderStateMixin {
  double balance = 0.00000000;
  double miningRate = 0.00000125;
  bool isMining = false;
  Timer? timer;
  late AnimationController sparkController;

  @override
  void initState() {
    super.initState();
    sparkController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  void startMining() {
    if (isMining) return;
    setState(() => isMining = true);
    timer = Timer.periodic(const Duration(milliseconds: 100), (t) {
      setState(() {
        balance += miningRate;
      });
    });
  }

  void stopMining() {
    timer?.cancel();
    setState(() => isMining = false);
  }

  @override
  void dispose() {
    timer?.cancel();
    sparkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0B1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1033),
        title: const Text('BSC Mine Hub', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){}, icon: const Icon(Icons.wallet, color: Colors.amber))
        ],
      ),
      body: Stack(
        children: [
          // Spark Background
          if (isMining) 
            AnimatedBuilder(
              animation: sparkController,
              builder: (context, child) {
                return CustomPaint(
                  size: Size.infinite,
                  painter: SparkPainter(sparkController.value),
                );
              },
            ),
          Column(
            children: [
              const SizedBox(height: 30),
              // Balance Card
              Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF6A11CB), Color(0xFF2575FC)]),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [BoxShadow(color: Colors.deepPurple.withOpacity(0.5), blurRadius: 20, spreadRadius: 2)],
                ),
                child: Column(
                  children: [
                    const Text('Total Balance', style: TextStyle(color: Colors.white70, fontSize: 16)),
                    const SizedBox(height: 8),
                    Text('${balance.toStringAsFixed(8)} BSC', style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text('${miningRate.toStringAsFixed(8)}/s', style: const TextStyle(color: Colors.amber, fontSize: 14)),
                  ],
                ),
              ),
              const Spacer(),
              // Mine Button
              GestureDetector(
                onTap: () {
                  if (isMining) stopMining(); else startMining();
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: isMining ? [Colors.amber, Colors.orange] : [Color(0xFF6A11CB), Color(0xFF2575FC)],
                    ),
                    boxShadow: [
                      BoxShadow(color: (isMining ? Colors.amber : Colors.deepPurple).withOpacity(0.6), blurRadius: 30, spreadRadius: 5)
                    ],
                  ),
                  child: Icon(isMining ? Icons.stop : Icons.bolt, size: 70, color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              Text(isMining ? 'MINING...' : 'TAP TO START MINING', style: TextStyle(color: isMining ? Colors.amber : Colors.white70, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
              const Spacer(),
              // Bottom Buttons
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(child: _bottomBtn(Icons.people, 'Refer')),
                    const SizedBox(width: 12),
                    Expanded(child: _bottomBtn(Icons.task, 'Tasks')),
                    const SizedBox(width: 12),
                    Expanded(child: _bottomBtn(Icons.outbox, 'Withdraw')),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ],
      ),
    );
  }

  Widget _bottomBtn(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(color: Color(0xFF1A1033), borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.white12)),
      child: Column(children: [Icon(icon, color: Colors.white70), const SizedBox(height: 4), Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12))]),
    );
  }
}

class SparkPainter extends CustomPainter {
  final double progress;
  SparkPainter(this.progress);
  @override
  void paint(Canvas canvas, Size size) {
    final random = Random();
    final paint = Paint()..color = Colors.white.withOpacity(0.8);
    for (int i = 0; i < 15; i++) {
      double x = random.nextDouble() * size.width;
      double y = (progress * size.height * 2) % size.height + random.nextDouble() * 100;
      double r = random.nextDouble() * 3 + 1;
      canvas.drawCircle(Offset(x, y), r, paint..color = Colors.amber.withOpacity(random.nextDouble()));
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
