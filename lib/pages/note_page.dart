import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:notestaking_app/helper/ad_helper.dart';
import 'package:notestaking_app/model/note.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../database/notes_database.dart';
import '../widget/note_card_widget.dart';
import 'edit_note_page.dart';
import 'note_detail_page.dart';

class NotePage extends StatefulWidget {
  const NotePage({Key? key}) : super(key: key);

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  late BannerAd _bottomBannerAd;
  late List<Note> notes;
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

  @override
  void initState() {
    super.initState();

    refreshNotes();
    _createBottomBannerAd();
  }

  @override
  void dispose() {
    NotesDatabase.instance.close();
    _bottomBannerAd.dispose();

    super.dispose();
  }

  Future refreshNotes() async {
    setState(() => isLoading = true);

    notes = await NotesDatabase.instance.readAllNotes();

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notes',
          style: TextStyle(fontSize: 24),
        ),
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : notes.isEmpty
                ? const Text(
                    'No Notes',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  )
                : buildNotes(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddEditNotePage()),
          );

          refreshNotes();
        },
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

  Widget buildNotes() {
    return StaggeredGridView.countBuilder(
      padding: const EdgeInsets.all(8),
      itemCount: notes.length,
      staggeredTileBuilder: (index) => const StaggeredTile.fit(2),
      crossAxisCount: 4,
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      itemBuilder: (context, index) {
        final note = notes[index];

        return GestureDetector(
          onTap: () async {
            await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => NoteDetail(noteId: note.id!),
            ));

            refreshNotes();
          },
          child: NoteCardWidget(note: note, index: index),
        );
      },
    );
  }
}
