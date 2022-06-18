import 'package:flutter/material.dart';

class NoteFormWidget extends StatelessWidget {
  const NoteFormWidget({
    Key? key,
    this.isImportant,
    this.number,
    this.title,
    this.description,
    required this.onChangedTitle,
    required this.onChangedDescription,
  }) : super(key: key);
  final bool? isImportant;
  final int? number;
  final String? title;
  final String? description;

  final ValueChanged<String> onChangedTitle;
  final ValueChanged<String> onChangedDescription;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildTitle(),
            const SizedBox(height: 8),
            buildDescription(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget buildTitle() {
    return TextFormField(
      maxLines: 1,
      initialValue: title,
      style: const TextStyle(
        color: Colors.white70,
        fontWeight: FontWeight.bold,
        fontSize: 24,
      ),
      decoration: const InputDecoration(
        border: InputBorder.none,
        hintText: 'Title',
        hintStyle: TextStyle(color: Colors.white70),
      ),
      validator: (title) =>
          title != null && title.isEmpty ? 'Give your note a title' : null,
      onChanged: onChangedTitle,
    );
  }

  Widget buildDescription() {
    return TextFormField(
      maxLines: 5,
      initialValue: description,
      style: const TextStyle(color: Colors.white60, fontSize: 18),
      decoration: const InputDecoration(
        border: InputBorder.none,
        hintText: 'Type something...',
        hintStyle: TextStyle(color: Colors.white60),
      ),
      validator: (title) => title != null && title.isEmpty
          ? 'You\'re writting a note, right?'
          : null,
      onChanged: onChangedDescription,
    );
  }
}
