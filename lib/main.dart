import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(BSCApp());

class BSCApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MineHome(),
    );
  }
}

class MineHome extends StatefulWidget {
  @override
  _MineHomeState createState() => _MineHomeState();
}

class _MineHomeState extends State<MineHome> {
  double balance = 0.00022375;
  double rate = 0.00000125;
  bool mining = false;
  Timer? timer;

  void startMining() {
    setState(() => mining = true);
    timer = Timer.periodic(Duration(seconds: 1), (t) {
      setState(() => balance += rate);
    });
  }

  void showRefer() {
    showDialog(context: context, builder: (_) => AlertDialog(
      title: Text("Refer & Earn"),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        Text("Apna referral link share karo aur 10% commission pao"),
        SizedBox(height: 10),
        SelectableText("https://bscminehub.com/ref/12345"),
      ]),
      actions: [TextButton(onPressed: ()=>Navigator.pop(context), child: Text("Close"))],
    ));
  }

  void showTasks() {
    showDialog(context: context, builder: (_) => AlertDialog(
      title: Text("Daily Tasks"),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        ListTile(title: Text("Daily Check-in"), trailing: ElevatedButton(onPressed: (){setState(()=>balance+=0.0001); Navigator.pop(context);}, child: Text("Claim"))),
        ListTile(title: Text("Watch Ad"), trailing: ElevatedButton(onPressed: (){setState(()=>balance+=0.0002); Navigator.pop(context);}, child: Text("Claim"))),
        ListTile(title: Text("Invite 1 Friend"), trailing: ElevatedButton(onPressed: (){setState(()=>balance+=0.001); Navigator.pop(context);}, child: Text("Claim"))),
      ]),
    ));
  }

  void showWithdraw() {
    TextEditingController ctrl = TextEditingController();
    showDialog(context: context, builder: (_) => AlertDialog(
      title: Text("Withdraw BSC"),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        Text("Min withdraw: 0.01 BSC\nCurrent: ${balance.toStringAsFixed(8)} BSC"),
        TextField(controller: ctrl, decoration: InputDecoration(hintText: "BEP20 Wallet Address")),
      ]),
      actions: [
        TextButton(onPressed: ()=>Navigator.pop(context), child: Text("Cancel")),
        ElevatedButton(onPressed: (){
          if(balance >= 0.01){
            setState(()=>balance-=0.01);
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Withdraw request sent!")));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Balance kam hai!")));
          }
        }, child: Text("Withdraw"))
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0F0A2A),
      appBar: AppBar(title: Text("BSC Mine Hub"), backgroundColor: Color(0xFF0F0A2A), centerTitle: true),
      body: Column(
        children: [
          SizedBox(height: 20),
          Container(
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.all(30),
            decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.purple, Colors.blue]), borderRadius: BorderRadius.circular(25)),
            child: Column(children: [
              Text("Total Balance", style: TextStyle(color: Colors.white70)),
              SizedBox(height: 10),
              Text("${balance.toStringAsFixed(8)} BSC", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
              Text("${rate.toStringAsFixed(8)}/s", style: TextStyle(color: Colors.amber)),
            ]),
          ),
          SizedBox(height: 30),
          GestureDetector(
            onTap: mining ? null : startMining,
            child: Container(
              width: 180, height: 180,
              decoration: BoxDecoration(shape: BoxShape.circle, gradient: LinearGradient(colors: [Colors.purple, Colors.blue])),
              child: Icon(Icons.bolt, size: 60, color: Colors.white),
            ),
          ),
          SizedBox(height: 15),
          Text(mining ? "MINING..." : "TAP TO START MINING", style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
          Spacer(),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            _btn(Icons.people, "Refer", showRefer),
            _btn(Icons.task, "Tasks", showTasks),
            _btn(Icons.upload, "Withdraw", showWithdraw),
          ]),
          SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _btn(IconData icon, String label, VoidCallback onTap){
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100, padding: EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(color: Color(0xFF2A234A), borderRadius: BorderRadius.circular(15)),
        child: Column(children: [Icon(icon, color: Colors.white70), SizedBox(height: 5), Text(label, style: TextStyle(color: Colors.white70))]),
      ),
    );
  }
}
