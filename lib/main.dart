import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(const BSCMineApp());
}

class BSCMineApp extends StatelessWidget {
  const BSCMineApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BSC Mine Hub',
      home: const MiningScreen(),
    );
  }
}

class MiningScreen extends StatefulWidget {
  const MiningScreen({super.key});
  @override
  State<MiningScreen> createState() => _MiningScreenState();
}

class _MiningScreenState extends State<MiningScreen> {
  double bal = 0;
  bool mining = false;
  Timer? t;
  BannerAd? ad;

  @override
  void initState(){
    super.initState();
    ad = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/6300978111',
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(onAdFailedToLoad: (a,e)=>a.dispose()),
    )..load();
  }

  void startStop(){
    setState(()=> mining = !mining);
    if(mining){
      t = Timer.periodic(const Duration(seconds: 1), (_){
        setState(()=> bal += 0.00001);
      });
    } else { t?.cancel(); }
  }

  @override
  Widget build(BuildContext c){
    return Scaffold(
      appBar: AppBar(title: const Text('BSC Mine Hub'), backgroundColor: Colors.amber, centerTitle: true),
      body: Column(children: [
        const SizedBox(height:50),
        const Icon(Icons.currency_bitcoin, size:100, color: Colors.amber),
        Text(bal.toStringAsFixed(5), style: const TextStyle(fontSize:36, fontWeight: FontWeight.bold)),
        const Text('BSC Balance'),
        const SizedBox(height:40),
        ElevatedButton(onPressed: startStop, style: ElevatedButton.styleFrom(backgroundColor: mining? Colors.red:Colors.green, padding: const EdgeInsets.symmetric(horizontal:50, vertical:15)), child: Text(mining? 'STOP MINING':'START MINING', style: const TextStyle(color: Colors.white, fontSize:18))),
        const Spacer(),
        if(ad!=null) SizedBox(height: ad!.size.height.toDouble(), width: ad!.size.width.toDouble(), child: AdWidget(ad: ad!))
      ]),
    );
  }
}
