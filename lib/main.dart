import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(const SparkPro());

class SparkPro extends StatelessWidget {
  const SparkPro({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      home: const ProMiner(),
    );
  }
}

class ProMiner extends StatefulWidget {
  const ProMiner({super.key});
  @override
  State<ProMiner> createState() => _ProMinerState();
}

class _ProMinerState extends State<ProMiner> with TickerProviderStateMixin {
  double btc = 0.00892451;
  bool mining = true;
  Timer? timer;
  int uptime = 4523;
  double hashrate = 4.82;
  int shares = 2451;
  late AnimationController pulse;
  List<double> chart = List.generate(20, (i) => Random().nextDouble() * 5);

  @override
  void initState() {
    super.initState();
    pulse = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();
    startMining();
  }

  void startMining() {
    timer = Timer.periodic(const Duration(milliseconds: 800), (_) {
      if (!mining) return;
      setState(() {
        btc += 0.00000012 + Random().nextDouble() * 0.00000005;
        uptime++;
        hashrate = 4.5 + Random().nextDouble() * 0.8;
        chart.removeAt(0);
        chart.add(hashrate);
        if (Random().nextInt(4) == 0) shares++;
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF070708),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 90,
            backgroundColor: const Color(0xFF070708),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Row(children: [
                  Container(width: 38, height: 38, decoration: BoxDecoration(color: const Color(0xFFFF9900), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.bolt, color: Colors.black)),
                  const SizedBox(width: 10),
                  const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text("SPARK", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 1.5, color: Colors.white)),
                    Text("PRO MINER v2.0", style: TextStyle(fontSize: 9, color: Colors.orange, letterSpacing: 1)),
                  ])
                ]),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(color: const Color(0xFF1A1A1A), borderRadius: BorderRadius.circular(20), border: Border.all(color: mining ? Colors.green : Colors.grey)),
                  child: Row(children: [Container(width: 6, height: 6, decoration: BoxDecoration(color: mining ? Colors.green : Colors.grey, shape: BoxShape.circle)), const SizedBox(width: 6), Text(mining ? "LIVE" : "PAUSED", style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold))]),
                )
              ]),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(children: [
                // BALANCE CARD PRO
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFF1E1E1E), Color(0xFF121212)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.orange.withOpacity(0.3)),
                  ),
                  child: Column(children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      const Text("TOTAL BALANCE", style: TextStyle(color: Colors.white38, fontSize: 11, letterSpacing: 1.2)),
                      IconButton(onPressed: () {}, icon: const Icon(Icons.visibility, color: Colors.white24, size: 18))
                    ]),
                    const SizedBox(height: 8),
                    Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                      Text(btc.toStringAsFixed(8), style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                      const SizedBox(width: 8),
                      const Text("BTC", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                    ]),
                    const SizedBox(height: 4),
                    Row(children: [
                      Text("\$${(btc * 67890).toStringAsFixed(2)}", style: const TextStyle(color: Colors.white70, fontSize: 14)),
                      const SizedBox(width: 8),
                      Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: Colors.green.withOpacity(0.2), borderRadius: BorderRadius.circular(4)), child: const Text("+2.34%", style: TextStyle(color: Colors.green, fontSize: 11))),
                    ]),
                    const SizedBox(height: 20),
                    Row(children: [
                      Expanded(child: _miniStat("HASHRATE", "${hashrate.toStringAsFixed(2)} TH/s", Icons.speed)),
                      const SizedBox(width: 12),
                      Expanded(child: _miniStat("SHARES", "$shares", Icons.check_circle)),
                      const SizedBox(width: 12),
                      Expanded(child: _miniStat("UPTIME", "${uptime ~/ 
