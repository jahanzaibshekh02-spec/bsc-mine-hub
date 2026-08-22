import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(SPARKMinerApp());
}

class SPARKMinerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: Color(0xFF0A0A0A)),
      home: MinerScreen(),
    );
  }
}

class MinerScreen extends StatefulWidget {
  @override
  _MinerScreenState createState() => _MinerScreenState();
}

class _MinerScreenState extends State<MinerScreen> with TickerProviderStateMixin {
  double balance = 5.77298;
  bool isMining = true;
  double hashRate = 255.0;
  int boostSec = 40;
  double multiplier = 2.0;
  late AnimationController _controller;
  Timer? _timer;
  
  // ADS
  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 2))..repeat();
    loadBalance();
    startMining();
    loadBanner();
    loadInterstitial();
    loadRewarded();
  }

  void loadBanner() {
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/6300978111', // Test ID - Buyer will change
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(),
    )..load();
  }
  void loadInterstitial() {
    InterstitialAd.load(adUnitId: 'ca-app-pub-3940256099942544/1033173712', request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(onAdLoaded: (ad) => _interstitialAd = ad, onAdFailedToLoad: (e) {}));
  }
  void loadRewarded() {
    RewardedAd.load(adUnitId: 'ca-app-pub-3940256099942544/5224354917', request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(onAdLoaded: (ad) => _rewardedAd = ad, onAdFailedToLoad: (e) {}));
  }

  void loadBalance() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => balance = prefs.getDouble('balance') ?? 5.77298);
  }

  void startMining() {
    _timer = Timer.periodic(Duration(milliseconds: 100), (t) {
      if(isMining){
        setState(() {
          balance += 0.00001 * multiplier;
          hashRate = 200 + Random().nextInt(100) + Random().nextDouble();
          if(boostSec > 0) boostSec--; else multiplier = 1.0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _bannerAd != null ? Container(height: 50, child: AdWidget(ad: _bannerAd!)) : null,
      body: Column(
        children: [
          SizedBox(height: 80),
          Text("SPARK MINER PRO", style: TextStyle(color: Colors.amber, fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: 2)),
          SizedBox(height: 50),
          RotationTransition(
            turns: _controller,
            child: Container(
              width: 200, height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [Color(0xFFFFD700), Color(0xFFB8860B)]),
                boxShadow: [BoxShadow(color: Colors.amber.withOpacity(0.6), blurRadius: 30, spreadRadius: 5)],
                border: Border.all(color: Colors.amberAccent, width: 3),
              ),
              child: Center(child: Text("S", style: TextStyle(fontSize: 100, fontWeight: FontWeight.bold, color: Colors.black87))),
            ),
          ),
          SizedBox(height: 30),
          Text("${balance.toStringAsFixed(5)} BSC", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
          Text("BOOSTED ${multiplier}x - ${boostSec}s | ${hashRate.toStringAsFixed(1)} H/s", style: TextStyle(color: Colors.greenAccent)),
          SizedBox(height: 20),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            ElevatedButton(
              onPressed: () => setState(() => isMining = !isMining),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black, padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15), shape: StadiumBorder()),
              child: Text(isMining ? "STOP" : "START", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            SizedBox(width: 10),
            ElevatedButton(
              onPressed: () {
                _interstitialAd?.show();
                setState(() { multiplier = 2.0; boostSec = 40; });
                loadInterstitial();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white10),
              child: Text("🚀 BOOST"),
            ),
            SizedBox(width: 10),
            ElevatedButton(
              onPressed: () {
                _rewardedAd?.show(onUserEarnedReward: (ad, reward) {
                  setState(() { multiplier = 5.0; boostSec = 60; balance += 0.5; });
                });
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: Text("AD 5x"),
            ),
          ]),
          Spacer(),
          Padding(
            padding: EdgeInsets.all(10),
            child: Text("AdMob Ready | Buyer just change Ad IDs in main.dart", style: TextStyle(color: Colors.grey, fontSize: 10)),
          )
        ],
      ),
    );
  }
}
