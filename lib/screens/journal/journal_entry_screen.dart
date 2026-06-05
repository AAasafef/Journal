import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/journal_entry_model.dart';
import '../../services/journal_service.dart';
import 'journal_editor_screen.dart';

class JournalEntryScreen extends StatefulWidget {
  final JournalEntryModel entry;

  const JournalEntryScreen({
    super.key,
    required this.entry,
  });

  @override
  State<JournalEntryScreen> createState() =>
      _JournalEntryScreenState();
}

class _JournalEntryScreenState
    extends State<JournalEntryScreen> {
  late JournalEntryModel entry;

  @override
  void initState() {
    super.initState();
    entry = widget.entry;
  }

  Future<void> _toggleFavorite() async {
    await JournalService.instance.toggleFavorite(
      entry.id,
    );

    final updated =
        JournalService.instance.getEntries().firstWhere(
              (e) => e.id == entry.id,
            );

    setState(() {
      entry = updated;
    });
  }

  Future<void> _editEntry() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => JournalEditorScreen(
          entry: entry,
        ),
      ),
    );

    if (result == true) {
      final updated =
          JournalService.instance.getEntries().firstWhere(
                (e) => e.id == entry.id,
              );

      setState(() {
        entry = updated;
      });
    }
  }

  Future<void> _deleteEntry() async {
    await JournalService.instance.deleteEntry(
      entry.id,
    );

    if (mounted) {
      Navigator.pop(
        context,
        true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF4EFE8),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              top: 255,
              child: CustomPaint(
                painter:
                    _NotebookPaperPainter(),
              ),
            ),

            SingleChildScrollView(
              physics:
                  const BouncingScrollPhysics(),
              padding:
                  const EdgeInsets.fromLTRB(
                24,
                24,
                24,
                110,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Row(
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
                      const Spacer(),
                      IconButton(
                        onPressed:
                            _toggleFavorite,
                        icon: Icon(
                          entry.isFavorite
                              ? Icons.star_rounded
                              : Icons
                                  .star_border_rounded,
                        ),
                      ),
                      IconButton(
                        onPressed: _editEntry,
                        icon: const Icon(
                          Icons.edit_outlined,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 34,
                  ),

                  Text(
                    entry.title,
                    style: GoogleFonts
                        .cormorantGaramond(
                      fontSize: 36,
                      height: 1,
                      color: const Color(
                        0xFF2D241E,
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  Text(
                    '${_formatDate(entry.createdAt)} at ${_formatTime(entry.createdAt)}',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: const Color(
                        0xFF6F6258,
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  Row(
                    children: [
                      Text(
                        '♧ ${entry.category}',
                        style:
                            GoogleFonts.inter(
                          fontSize: 12,
                          color: const Color(
                            0xFF7B6D62,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Text(
                        '•',
                        style:
                            GoogleFonts.inter(
                          color: const Color(
                            0xFF9E9187,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Text(
                        '☺ ${entry.mood}',
                        style:
                            GoogleFonts.inter(
                          fontSize: 12,
                          color: const Color(
                            0xFF7B6D62,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 56,
                  ),

                  Padding(
                    padding:
                        const EdgeInsets.only(
                      left: 34,
                      right: 4,
                    ),
                    child: Text(
                      entry.content,
                      style: GoogleFonts.caveat(
                        fontSize: 27,
                        height: 1.18,
                        color: const Color(
                          0xFF211A15,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 120,
                  ),

                  _SummaryBox(
                    title: 'AI Summary',
                    text: entry.summary,
                  ),

                  const SizedBox(
                    height: 12,
                  ),

                  _SummaryBox(
                    title: 'Keywords',
                    text: entry.keywords.isEmpty
                        ? 'No keywords yet.'
                        : entry.keywords.join(
                            ' • ',
                          ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  TextButton.icon(
                    onPressed: _deleteEntry,
                    icon: const Icon(
                      Icons.delete_outline,
                    ),
                    label: const Text(
                      'Delete Entry',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryBox extends StatelessWidget {
  final String title;
  final String text;

  const _SummaryBox({
    required this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(
        16,
      ),
      decoration: BoxDecoration(
        color: const Color(
          0xFFF8F2EA,
        ).withOpacity(.88),
        borderRadius:
            BorderRadius.circular(
          18,
        ),
        border: Border.all(
          color: const Color(
            0xFFD8CEC4,
          ),
          width: .7,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            '✧ $title',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: const Color(
                0xFF2D241E,
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 12,
              height: 1.4,
              color: const Color(
                0xFF3F352E,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotebookPaperPainter
    extends CustomPainter {
  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final linePaint = Paint()
      ..color =
          const Color(0xFFD3C7BD)
              .withOpacity(.52)
      ..strokeWidth = .55;

    for (
      double y = 0;
      y < size.height;
      y += 30
    ) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        linePaint,
      );
    }

    final marginPaint = Paint()
      ..color =
          const Color(0xFFE1A9A2)
              .withOpacity(.42)
      ..strokeWidth = .75;

    canvas.drawLine(
      const Offset(
        60,
        0,
      ),
      Offset(
        60,
        size.height,
      ),
      marginPaint,
    );
  }

  @override
  bool shouldRepaint(
    CustomPainter oldDelegate,
  ) {
    return false;
  }
}

String _formatDate(
  DateTime date,
) {
  final months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  return '${months[date.month - 1]} ${date.day}, ${date.year}';
}

String _formatTime(
  DateTime date,
) {
  final hour = date.hour == 0
      ? 12
      : date.hour > 12
          ? date.hour - 12
          : date.hour;

  final minute =
      date.minute.toString().padLeft(
            2,
            '0',
          );

  final suffix =
      date.hour >= 12 ? 'PM' : 'AM';

  return '$hour:$minute $suffix';
}
