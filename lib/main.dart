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
  RewardedInterstitialAd? _rewardedAd;
  final String adUnitId = 'ca-app-pub-9184265616231271/7370879625';

  @override
  void initState() { super.initState(); _loadAd(); }

  void _loadAd() {
    RewardedInterstitialAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
        onAdLoaded: (ad) => _rewardedAd = ad,
        onAdFailedToLoad: (err) => print('Failed $err'),
      ),
    );
  }

  void _showAd() {
    if (_rewardedAd == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ad Loading... 5 sec baad try karo')));
      _loadAd(); return;
    }
    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) { ad.dispose(); _loadAd(); },
      onAdFailedToShowFullScreenContent: (ad, e) { ad.dispose(); _loadAd(); },
    );
    _rewardedAd!.show(onUserEarnedReward: (a, r) {
      setState(() => coins += 10);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('10 Coins Added!')));
    });
    _rewardedAd = null;
  }

  void _startMining() {
    setState(() => isMining = true);
    Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted || !isMining) { t.cancel(); return; }
      setState(() => coins += 0.001);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BSC Mine Hub'), backgroundColor: Colors.orange, centerTitle: true),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(Icons.currency_bitcoin, size: 100, color: Colors.orange),
          Text('${coins.toStringAsFixed(4)} BSC', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
          const SizedBox(height: 30),
          ElevatedButton(onPressed: isMining ? null : _startMining, child: Text(isMining ? 'MINING ON' : 'START MINING')),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: _showAd, style: ElevatedButton.styleFrom(backgroundColor: Colors.green), child: const Text('WATCH AD & WITHDRAW', style: TextStyle(color: Colors.white))),
        ]),
      ),
    );
  }
}
