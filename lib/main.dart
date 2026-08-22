import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const MaterialApp(debugShowCheckedModeBanner: false, home: SparkMiner()));

class SparkMiner extends StatefulWidget {
  const SparkMiner({super.key});
  @override State<SparkMiner> createState() => _SparkMinerState();
}

class _SparkMinerState extends State<SparkMiner> {
  double balance = 5.75123;
  double hashRate = 125.0;
  bool isMining = true;
  int selectedIndex = 0;
  Timer? timer;
  bool isBoosted = false;
  int boostSeconds = 0;
  bool canClaimDaily = true;
  String referralCode = "SPARK-JAHAN-88";

  @override
  void initState() {
    super.initState();
    checkDaily();
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (isMining) {
        setState(() {
          balance += isBoosted? 0.00050 : 0.00025;
          hashRate = isBoosted? 250 + (DateTime.now().second % 20) : 125 + (DateTime.now().second % 10);
          if(isBoosted){ boostSeconds--; if(boostSeconds<=0) isBoosted=false; }
        });
      }
    });
  }
  checkDaily() async {
    var p = await SharedPreferences.getInstance();
    String today = DateTime.now().toString().split(' ')[0];
    setState(()=> canClaimDaily = (p.getString('lastClaim')??'')!= today);
  }
  claimDaily() async {
    var p = await SharedPreferences.getInstance();
    await p.setString('lastClaim', DateTime.now().toString().split(' ')[0]);
    setState((){ balance+=0.01000; canClaimDaily=false; });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Daily Bonus 0.01000 BSC Claimed!")));
  }
  startBoost() => setState((){ isBoosted=true; boostSeconds=60; });

  @override void dispose() { timer?.cancel(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF080A0F),
      body: selectedIndex==0? buildMine() : selectedIndex==1? buildRefer() : buildWallet(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF11161F), selectedItemColor: Color(0xFFFFD700), unselectedItemColor: Colors.white54,
        currentIndex: selectedIndex, onTap: (i)=> setState(()=>selectedIndex=i),
        items: [BottomNavigationBarItem(icon: Icon(Icons.memory), label: 'MINE'), BottomNavigationBarItem(icon: Icon(Icons.group_add), label: 'REFER'), BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: 'WALLET')],
      ),
    );
  }

  Widget buildMine() {
    return SafeArea(child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text('SPARK MINER PRO', style: TextStyle(color: Color(0xFFFFD700), fontSize: 26, fontWeight: FontWeight.bold, letterSpacing: 2)),
      SizedBox(height: 15),
      if(canClaimDaily) Padding(padding: EdgeInsets.symmetric(horizontal: 20), child: ElevatedButton.icon(icon: Icon(Icons.card_giftcard), label: Text("CLAIM DAILY BONUS 0.01000 BSC"), onPressed: claimDaily, style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black, minimumSize: Size(double.infinity, 45)))),
      SizedBox(height: 20),
      Container(padding: EdgeInsets.all(20), decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Color(0xFFFFD700), width: 3), boxShadow: [BoxShadow(color: Color(0x4DFFD700), blurRadius: 30)]), child: Icon(Icons.bolt, size: 80, color: isMining? Color(0xFFFFD700) : Colors.grey)),
      SizedBox(height: 15),
      Text('${balance.toStringAsFixed(5)} BSC', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
      Text(isBoosted? 'BOOSTED 2x - ${boostSeconds}s | ${hashRate.toStringAsFixed(1)} H/s' : '${hashRate.toStringAsFixed(1)} H/s', style: TextStyle(color: isBoosted? Colors.greenAccent : Colors.white54)),
      SizedBox(height: 20),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFFFD700), foregroundColor: Colors.black, padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15)), onPressed: ()=> setState(()=>isMining=!isMining), child: Text(isMining? 'STOP' : 'START', style: TextStyle(fontWeight: FontWeight.bold))),
        SizedBox(width: 15),
        ElevatedButton.icon(icon: Icon(Icons.rocket_launch), label: Text(isBoosted? '${boostSeconds}s' : 'BOOST 2x'), onPressed: isBoosted? null : startBoost, style: ElevatedButton.styleFrom(backgroundColor: Colors.purple, foregroundColor: Colors.white, padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15))),
      ]),
    ])));
  }

  Widget buildRefer() {
    return Center(child: Padding(padding: EdgeInsets.all(20), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text('Refer & Earn 10%', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
      SizedBox(height: 20),
      Container(padding: EdgeInsets.all(12), color: Color(0xFF1C222E), child: Row(children: [Expanded(child: Text(referralCode, style: TextStyle(color: Color(0xFFFFD700), fontSize: 18, fontWeight: FontWeight.bold))), IconButton(icon: Icon(Icons.copy, color: Colors.white), onPressed: (){ Clipboard.setData(ClipboardData(text: referralCode)); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Copied!")));})])),
      SizedBox(height: 20),
      ElevatedButton.icon(onPressed: (){ Share.share("Join SPARK Miner PRO! Code: $referralCode - https://...");}, icon: Icon(Icons.share), label: Text("Share on WhatsApp"), style: ElevatedButton.styleFrom(backgroundColor: Colors.green, minimumSize: Size(double.infinity, 50)))
    ])));
  }

  Widget buildWallet() {
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text('${balance.toStringAsFixed(5)} BSC', style: TextStyle(color: Color(0xFFFFD700), fontSize: 30, fontWeight: FontWeight.bold)),
      SizedBox(height: 20),
      ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFFFD700), foregroundColor: Colors.black, padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15)), onPressed: (){
        showDialog(context: context, builder: (c)=> AlertDialog(title: Text("Withdraw BSC"), content: Column(mainAxisSize: MainAxisSize.min, children: [Text("Balance: ${balance.toStringAsFixed(5)} BSC"), SizedBox(height: 10), TextField(decoration: InputDecoration(labelText: "JazzCash/Easypaisa No", border: OutlineInputBorder())), SizedBox(height: 10), TextField(decoration: InputDecoration(labelText: "BSC Address", border: OutlineInputBorder()))]), actions: [TextButton(onPressed: ()=>Navigator.pop(c), child: Text("Cancel")), ElevatedButton(onPressed: (){ Navigator.pop(c); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Request Sent! 24h me ayega")));}, child: Text("Submit"), style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFFFD700)))]));
      }, child: Text('WITHDRAW', style: TextStyle(fontWeight: FontWeight.bold))),
      SizedBox(height: 10), Text(isBoosted? "Boost Active: 2x Speed" : "Mining at ${hashRate.toStringAsFixed(1)} H/s", style: TextStyle(color: Colors.white54))
    ]));
  }
}
