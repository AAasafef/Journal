import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/journal_entry_model.dart';
import '../../services/journal_service.dart';

class JournalEditorScreen extends StatefulWidget {
  final JournalEntryModel? entry;

  const JournalEditorScreen({
    super.key,
    this.entry,
  });

  @override
  State<JournalEditorScreen> createState() =>
      _JournalEditorScreenState();
}

class _JournalEditorScreenState
    extends State<JournalEditorScreen> {
  final TextEditingController _controller =
      TextEditingController();

  String _selectedMood = 'Neutral';

  String _selectedCategory = 'General';

  final List<String> moods = [
    'Happy',
    'Calm',
    'Excited',
    'Neutral',
    'Sad',
    'Frustrated',
    'Anxious',
    'Grateful',
    'Motivated',
    'Tired',
  ];

  final List<String> categories = [
    'General',
    'Spiritual',
    'Wellness',
    'Family',
    'School',
    'Work',
    'Business',
    'Beauty',
    'Money',
    'Health',
  ];

  @override
  void initState() {
    super.initState();

    if (widget.entry != null) {
      _controller.text =
          widget.entry!.content;

      _selectedMood =
          widget.entry!.mood;

      _selectedCategory =
          widget.entry!.category;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final text =
        _controller.text.trim();

    if (text.isEmpty) {
      Navigator.pop(context);
      return;
    }

    final service =
        JournalService.instance;

    final title =
        service.generateTitle(text);

    final summary =
        service.generateSummary(text);

    final keywords =
        service.generateKeywords(text);

    if (widget.entry == null) {
      final entry =
          JournalEntryModel(
        id: DateTime.now()
            .millisecondsSinceEpoch
            .toString(),
        title: title,
        content: text,
        summary: summary,
        keywords: keywords,
        category:
            _selectedCategory,
        mood: _selectedMood,
        isFavorite: false,
        createdAt:
            DateTime.now(),
        updatedAt:
            DateTime.now(),
      );

      await service.addEntry(
        entry,
      );
    } else {
      await service.updateEntry(
        widget.entry!.copyWith(
          title: title,
          content: text,
          summary: summary,
          keywords: keywords,
          category:
              _selectedCategory,
          mood:
              _selectedMood,
          updatedAt:
              DateTime.now(),
        ),
      );
    }

    if (mounted) {
      Navigator.pop(
        context,
        true,
      );
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF4EFE8),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.all(
                20,
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () =>
                        Navigator.pop(
                      context,
                    ),
                    icon: const Icon(
                      Icons
                          .arrow_back_ios_new_rounded,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      widget.entry ==
                              null
                          ? 'New Entry'
                          : 'Edit Entry',
                      style: GoogleFonts
                          .cormorantGaramond(
                        fontSize: 32,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: _save,
                    child: const Text(
                      'Save',
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Row(
                children: [
                  Expanded(
                    child:
                        DropdownButtonFormField<
                            String>(
                      value:
                          _selectedMood,
                      items: moods
                          .map(
                            (e) =>
                                DropdownMenuItem(
                              value: e,
                              child:
                                  Text(
                                e,
                              ),
                            ),
                          )
                          .toList(),
                      onChanged:
                          (value) {
                        if (value ==
                            null)
                          return;

                        setState(
                          () {
                            _selectedMood =
                                value;
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child:
                        DropdownButtonFormField<
                            String>(
                      value:
                          _selectedCategory,
                      items: categories
                          .map(
                            (e) =>
                                DropdownMenuItem(
                              value: e,
                              child:
                                  Text(
                                e,
                              ),
                            ),
                          )
                          .toList(),
                      onChanged:
                          (value) {
                        if (value ==
                            null)
                          return;

                        setState(
                          () {
                            _selectedCategory =
                                value;
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            Expanded(
              child: Container(
                width:
                    double.infinity,
                margin:
                    const EdgeInsets
                        .symmetric(
                  horizontal: 20,
                ),
                decoration:
                    BoxDecoration(
                  color:
                      const Color(
                    0xFFF8F2EA,
                  ),
                  borderRadius:
                      BorderRadius
                          .circular(
                    24,
                  ),
                ),
                child: TextField(
                  controller:
                      _controller,
                  expands: true,
                  maxLines: null,
                  keyboardType:
                      TextInputType
                          .multiline,
                  decoration:
                      InputDecoration(
                    hintText:
                        'Write freely...',
                    border:
                        InputBorder
                            .none,
                    contentPadding:
                        const EdgeInsets
                            .all(
                      24,
                    ),
                  ),
                  style: GoogleFonts
                      .caveat(
                    fontSize: 28,
                    height: 1.3,
                  ),
                ),
              ),
            ),

            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
