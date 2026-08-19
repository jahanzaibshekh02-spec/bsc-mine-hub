import 'package:flutter/material.dart';
import 'package:firebase_core/import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await MobileAds.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: const HomeScreen());
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double balance = 0.00045;
  final addressController = TextEditingController();
  BannerAd? bannerAd;
  InterstitialAd? interstitialAd;

  @override
  void initState() {
    super.initState();
    bannerAd = BannerAd(adUnitId: 'ca-app-pub-3940256099942544/6300978111', size: AdSize.banner, request: const AdRequest(), listener: BannerAdListener(onAdLoaded: (_) => setState(() {})))..load();
    InterstitialAd.load(adUnitId: 'ca-app-pub-3940256099942544/1033173712', request: const AdRequest(), adLoadCallback: InterstitialAdLoadCallback(onAdLoaded: (ad) => interstitialAd = ad, onAdFailedToLoad: (e) => print(e)));
  }

  void withdraw() async {
    if (interstitialAd != null) { await interstitialAd!.show(); }
    String addr = addressController.text.trim();
    if (!addr.startsWith('0x') || addr.length != 42) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ghalat Address! 0x se shuru hona chahiye')));
      return;
    }
    await FirebaseFirestore.instance.collection('withdrawals').add({'address': addr, 'balance': balance, 'time': FieldValue.serverTimestamp()});
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Request bhej di gayi! Ad se earning ho gayi')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BSC Mine Hub - Earn BNB'), backgroundColor: Colors.amber),
      body: Column(children: [
        Expanded(child: Padding(padding: const EdgeInsets.all(20), child: Column(children: [
          const Icon(Icons.currency_bitcoin, size: 80, color: Colors.amber),
          Text('${balance.toStringAsFixed(5)} BNB', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          ElevatedButton(onPressed: () => setState(() => balance += 0.00001), child: const Text('Start Mining')),
          const Divider(height: 30),
          TextField(controller: addressController, decoration: const InputDecoration(hintText: '0x... BNB (BEP20) Address', border: OutlineInputBorder(), prefixIcon: Icon(Icons.wallet))),
          const SizedBox(height: 10),
          SizedBox(width: double.infinity, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, padding: const EdgeInsets.symmetric(vertical: 14)), onPressed: withdraw, child: const Text('Withdraw - Watch Ad', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)))),
        ]))),
        if (bannerAd != null) SizedBox(height: 60, child: AdWidget(ad: bannerAd!)),
      ]),
    );
  }
}.dart';

void main() import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await MobileAds.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: const HomeScreen());
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double balance = 0.00045;
  final addressController = TextEditingController();
  BannerAd? bannerAd;
  InterstitialAd? interstitialAd;

  @override
  void initState() {
    super.initState();
    bannerAd = BannerAd(adUnitId: 'ca-app-pub-3940256099942544/6300978111', size: AdSize.banner, request: const AdRequest(), listener: BannerAdListener(onAdLoaded: (_) => setState(() {})))..load();
    InterstitialAd.load(adUnitId: 'ca-app-pub-3940256099942544/1033173712', request: const AdRequest(), adLoadCallback: InterstitialAdLoadCallback(onAdLoaded: (ad) => interstitialAd = ad, onAdFailedToLoad: (e) => print(e)));
  }

  void withdraw() async {
    if (interstitialAd != null) { await interstitialAd!.show(); }
    String addr = addressController.text.trim();
    if (!addr.startsWith('0x') || addr.length != 42) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ghalat Address! 0x se shuru hona chahiye')));
      return;
    }
    await FirebaseFirestore.instance.collection('withdrawals').add({'address': addr, 'balance': balance, 'time': FieldValue.serverTimestamp()});
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Request bhej di gayi! Ad se earning ho gayi')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BSC Mine Hub - Earn BNB'), backgroundColor: Colors.amber),
      body: Column(children: [
        Expanded(child: Padding(padding: const EdgeInsets.all(20), child: Column(children: [
          const Icon(Icons.currency_bitcoin, size: 80, color: Colors.amber),
          Text('${balance.toStringAsFixed(5)} BNB', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          ElevatedButton(onPressed: () => setState(() => balance += 0.00001), child: const Text('Start Mining')),
          const Divider(height: 30),
          TextField(controller: addressController, decoration: const InputDecoration(hintText: '0x... BNB (BEP20) Address', border: OutlineInputBorder(), prefixIcon: Icon(Icons.wallet))),
          const SizedBox(height: 10),
          SizedBox(width: double.infinity, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, padding: const EdgeInsets.symmetric(vertical: 14)), onPressed: withdraw, child: const Text('Withdraw - Watch Ad', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)))),
        ]))),
        if (bannerAd != null) SizedBox(height: 60, child: AdWidget(ad: bannerAd!)),
      ]),
    );
  }
} {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BSC Mine Hub',
      theme: ThemeData(primarySwatch: Colors.amber),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double balance = 0.00045;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BSC Mine Hub'), backgroundColor: Colors.amber),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.currency_bitcoin, size: 100, color: Colors.amber),
            const SizedBox(height: 20),
            const Text('Your Mining Balance', style: TextStyle(fontSize: 20)),
            Text('${balance.toStringAsFixed(5)} BNB', style: const TextStyle
