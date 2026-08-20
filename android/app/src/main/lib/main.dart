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
      theme: ThemeData(primarySwatch: Colors.amber, useMaterial3: true),
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
  double balance = 0.0;
  bool isMining = false;
  Timer? timer;
  BannerAd? bannerAd;
  InterstitialAd? interstitialAd;

  // Aap ka Real Ad Unit ID yahan lagayen, abhi Test ID hai
  final String bannerId = 'ca-app-pub-3940256099942544/6300978111';
  final String interstitialId = 'ca-app-pub-3940256099942544/1033173712';

  @override
  void initState() {
    super.initState();
    loadBanner();
    loadInterstitial();
  }

  void loadBanner() {
    bannerAd = BannerAd(
      adUnitId: bannerId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(onAdFailedToLoad: (ad, err) => ad.dispose()),
    )..load();
  }

  void loadInterstitial() {
    InterstitialAd.load(
      adUnitId: interstitialId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => interstitialAd = ad,
        onAdFailedToLoad: (err) => interstitialAd = null,
      ),
    );
  }

  void toggleMining() {
    setState(() => isMining =!isMining);
    if (isMining) {
      timer = Timer.periodic(const Duration(seconds: 1), (t) {
        setState(() => balance += 0.00001);
      });
    } else {
      timer?.cancel();
      interstitialAd?.show();
      loadInterstitial();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BSC Mine Hub'), centerTitle: true, backgroundColor: Colors.amber),
      body: Column(
        children: [
          const SizedBox(height: 40),
          Icon(Icons.currency_bitcoin, size: 100, color: Colors.amber[700]),
          const SizedBox(height: 20),
          Text(balance.toStringAsFixed(5), style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
          const Text('BSC Balance', style: TextStyle(fontSize: 18)),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: toggleMining,
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15), backgroundColor: isMining? Colors.red : Colors.green),
            child: Text(isMining? 'STOP MINING' : 'START MINING', style: const TextStyle(fontSize: 20, color: Colors.white)),
          ),
          const Spacer(),
          if (bannerAd!= null)
            SizedBox(height: bannerAd!.size.height.toDouble(), width: bannerAd!.size.width.toDouble(), child: AdWidget(ad: bannerAd!)),
        ],
      ),
    );
  }
}
