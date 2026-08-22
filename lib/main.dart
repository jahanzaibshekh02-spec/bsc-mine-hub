import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:async';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (e) {
    print("Firebase already initialized");
  }
  runApp(BscMineHubApp());
}

class BscMineHubApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BSC Mine Hub Pro',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Color(0xFFF0B90B),
        scaffoldBackgroundColor: Color(0xFF0B0E11),
        fontFamily: 'Roboto',
      ),
      home: MiningDashboard(),
    );
  }
}

class MiningDashboard extends StatefulWidget {
  @override
  _MiningDashboardState createState() => _MiningDashboardState();
}

class _MiningDashboardState extends State<MiningDashboard> with TickerProviderStateMixin {
  double balance = 0.543882;
  bool isMining = false;
  Timer? _timer;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(vsync: this, duration: Duration(seconds: 1))..repeat(reverse: true);
  }

  void toggleMining() {
    setState(() => isMining = !isMining);
    if (isMining) {
      _timer = Timer.periodic(Duration(milliseconds: 800), (timer) {
        setState(() => balance += 0.000012);
      });
    } else {
      _timer?.cancel();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.hexagon, color: Color(0xFFF0B90B)),
            SizedBox(width: 8),
            Text("BSC MINE HUB", style: TextStyle(color: Color(0xFFF0B90B), fontWeight: FontWeight.w900, letterSpacing: 1.2)),
            Spacer(),
            Container(padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Color(0xFFF0B90B), borderRadius: BorderRadius.circular(5)), child: Text("PRO", style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold)))
          ],
        ),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            // BNB Coin Animation
            if (isMining) ScaleTransition(scale: Tween(begin: 0.95, end: 1.05).animate(_pulseController), child: Icon(Icons.currency_bitcoin, size: 80, color: Color(0xFFF0B90B))),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Color(0xFF1E2026), Color(0xFF2B2F36)]),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Color(0xFFF0B90B).withOpacity(0.5), width: 1.5),
                boxShadow: [BoxShadow(color: Color(0xFFF0B90B).withOpacity(0.1), blurRadius: 20)]
              ),
              child: Column(
                children: [
                  Text("MINING DASHBOARD • BEP20", style: TextStyle(color: Colors.grey, letterSpacing: 1.1, fontSize: 11)),
                  SizedBox(height: 12),
                  Text("${balance.toStringAsFixed(6)} BNB", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFFF0B90B))),
                  Text("~ \$${(balance * 605).toStringAsFixed(2)} USD", style: TextStyle(color: Colors.grey)),
                  SizedBox(height: 18),
                  LinearProgressIndicator(value: isMining ? null : 0.72, backgroundColor: Colors.black, color: Color(0xFFF0B90B)),
                  SizedBox(height: 8),
                  Text(isMining ? "Mining... Block #2847591" : "72% • Next Payout: ~2h 14m", style: TextStyle(fontSize: 11, color: Colors.grey)),
                  SizedBox(height: 18),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                    _statBox("HASHRATE", "1.24 TH/s", Icons.speed),
                    _statBox("24H EARNED", "+0.012 BNB", Icons.trending_up),
                    _statBox("STATUS", isMining ? "ACTIVE" : "IDLE", Icons.verified_user),
                  ])
                ],
              ),
            ),
            SizedBox(height: 25),
            SizedBox(
              width: double.infinity, height: 58,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: isMining ? Colors.redAccent : Color(0xFFF0B90B), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                onPressed: toggleMining,
                child: Text(isMining ? "⏹ STOP MINING" : "⛏ START MINING", style: TextStyle(color: isMining ? Colors.white : Colors.black, fontSize: 17, fontWeight: FontWeight.w900)),
              ),
            ),
            SizedBox(height: 15),
            Row(children: [
              Expanded(child: _actionBtn("Withdraw", Icons.account_balance_wallet)),
              SizedBox(width: 10),
              Expanded(child: _actionBtn("Refer & Earn", Icons.people)),
            ]),
            SizedBox(height: 20),
            Text("Network: BSC • Gas: Low • Secure Mining Protocol", style: TextStyle(color: Colors.grey, fontSize: 11))
          ],
        ),
      ),
    );
  }

  Widget _statBox(String title, String value, IconData icon) {
    return Column(children: [
      Icon(icon, size: 18, color: Color(0xFFF0B90B)),
      SizedBox(height: 4),
      Text(title, style: TextStyle(fontSize: 9, color: Colors.grey)),
      Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))
    ]);
  }

  Widget _actionBtn(String label, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(color: Color(0xFF1E2026), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white10)),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icon, size: 16, color: Colors.white70), SizedBox(width: 6), Text(label, style: TextStyle(fontSize: 13))]),
    );
  }
}
