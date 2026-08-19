import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:async';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BSC Mine Hub',
      theme: ThemeData(primarySwatch: Colors.orange, useMaterial3: true),
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
  double coins = 0.0;
  bool isMining = false;
  RewardedAd? _rewardedAd;
  final String adUnitId = 'ca-app-pub-9184265616231271/8413031387';

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  void _loadAd() {
    RewardedAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) => _rewardedAd = ad,
        onAdFailedToLoad: (err) => print('Ad Failed: $err'),
      ),
    );
  }

  void _showAdAndWithdraw() {
    if (_rewardedAd == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ad loading... Try again in 5 sec'))); 
      _loadAd();
      return;
    }
    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) { ad.dispose(); _loadAd(); },
      onAdFailedToShowFullScreenContent: (ad, err) { ad.dispose(); _loadAd(); },
    );
    _rewardedAd!.show(onUserEarnedReward: (ad, reward) {
      setState(() { coins += 10; });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Withdraw Success! 10 Coins Added'))); 
    });
    _rewardedAd = null;
  }

  void _startMining() {
    setState(() => isMining = true);
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!isMining) { timer.cancel(); return; }
      setState(() => coins += 0.001);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BSC Mine Hub'), centerTitle: true, backgroundColor: Colors.orange),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.currency_bitcoin, size: 100, color: Colors.orange),
            const SizedBox(height: 20),
            Text('${coins.toStringAsFixed(4)} BSC', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(isMining ? 'Mining...' : 'Tap to Start Mining', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 30),
            ElevatedButton(onPressed: isMining ? null : _startMining, style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15)), child: Text(isMining ? 'MINING ON' : 'START MINING')),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _showAdAndWithdraw, style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15)), child: const Text('WATCH AD & WITHDRAW', style: TextStyle(color: Colors.white))),
          ],
        ),
      ),
    );
  }
}
