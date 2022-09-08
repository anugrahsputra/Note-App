import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';

import '../database/notes_database.dart';
import '../helper/ad_helper.dart';
import '../model/note.dart';
import 'edit_note_page.dart';

class NoteDetail extends StatefulWidget {
  const NoteDetail({
    Key? key,
    required this.noteId,
  }) : super(key: key);

  final int noteId;

  @override
  State<NoteDetail> createState() => _NoteDetailState();
}

class _NoteDetailState extends State<NoteDetail> {
  int _interstitialLoadAttempt = 0;
  InterstitialAd? _interstitialAd;
  late Note note;
  late BannerAd _bottomBannerAd;
  bool isLoading = false;
  bool _isBottomBannerAdLoaded = false;

  void _createBottomBannerAd() {
    _bottomBannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: AdHelper.bannerUnitId,
      listener: BannerAdListener(onAdLoaded: (_) {
        setState(() {
          _isBottomBannerAdLoaded = true;
        });
      }, onAdFailedToLoad: (ad, error) {
        ad.dispose();
      }),
      request: const AdRequest(),
    );
    _bottomBannerAd.load();
  }

  void _createInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _interstitialLoadAttempt = 0;
        },
        onAdFailedToLoad: (LoadAdError error) {
          _interstitialLoadAttempt = 1;
          _interstitialAd = null;
        },
      ),
    );
  }

  void _showInterstitialAd() {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
          onAdDismissedFullScreenContent: (InterstitialAd ad) {
        ad.dispose();
        _createInterstitialAd();
      }, onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        ad.dispose();
        _createInterstitialAd();
      });
      _interstitialAd!.show();
    }
  }

  @override
  void initState() {
    super.initState();

    refreshNote();
    _createBottomBannerAd();
    _createInterstitialAd();
  }

  @override
  void dispose() {
    _bottomBannerAd.dispose();
    _interstitialAd?.dispose();

    super.dispose();
  }

  Future refreshNote() async {
    setState(() => isLoading = true);

    note = await NotesDatabase.instance.readNote(widget.noteId);

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          editButton(),
          deleteButton(),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(12),
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  Text(
                    note.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    DateFormat.yMMMd().format(note.createdTime),
                    style: const TextStyle(color: Colors.white38),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    note.description,
                    style: const TextStyle(color: Colors.white70, fontSize: 18),
                  )
                ],
              ),
            ),
      bottomNavigationBar: _isBottomBannerAdLoaded
          ? SizedBox(
              height: _bottomBannerAd.size.height.toDouble(),
              width: _bottomBannerAd.size.width.toDouble(),
              child: AdWidget(
                ad: _bottomBannerAd,
              ),
            )
          : null,
    );
  }

  Widget editButton() {
    return IconButton(
      icon: const Icon(Icons.edit_outlined),
      onPressed: () async {
        _showInterstitialAd();
        if (isLoading) return;

        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => AddEditNotePage(note: note),
          ),
        );

        refreshNote();
      },
    );
  }

  Widget deleteButton() {
    return IconButton(
      icon: const Icon(Icons.delete),
      onPressed: () {
        NotesDatabase.instance.delete(widget.noteId);

        Navigator.of(context).pop();
      },
    );
  }
}
