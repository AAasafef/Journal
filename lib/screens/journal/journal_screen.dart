import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/journal_entry_model.dart';
import '../../services/journal_service.dart';
import 'journal_calendar_screen.dart';
import 'journal_editor_screen.dart';
import 'journal_entry_screen.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({
    super.key,
  });

  @override
  State<JournalScreen> createState() =>
      _JournalScreenState();
}

class _JournalScreenState
    extends State<JournalScreen> {
  final ScrollController scrollController =
      ScrollController();

  final TextEditingController searchController =
      TextEditingController();

  bool showBottomNav = true;

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      final direction =
          scrollController.position.userScrollDirection;

      if (direction == ScrollDirection.reverse &&
          showBottomNav) {
        setState(() {
          showBottomNav = false;
        });
      }

      if (direction == ScrollDirection.forward &&
          !showBottomNav) {
        setState(() {
          showBottomNav = true;
        });
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    searchController.dispose();
    super.dispose();
  }

  List<JournalEntryModel> get entries {
    return JournalService.instance.search(
      searchController.text,
    );
  }

  Future<void> _openEditor() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const JournalEditorScreen(),
      ),
    );

    if (result == true && mounted) {
      setState(() {});
    }
  }

  Future<void> _openEntry(
    JournalEntryModel entry,
  ) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => JournalEntryScreen(
          entry: entry,
        ),
      ),
    );

    if (result == true && mounted) {
      setState(() {});
    }
  }

  Future<void> _openCalendar() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const JournalCalendarScreen(),
      ),
    );

    if (result == true && mounted) {
      setState(() {});
    }
  }

  List<JournalEntryModel> get demoEntries {
    return [
      JournalEntryModel(
        id: 'demo_1',
        title: 'App Reflection',
        content:
            'Fixed notes layout and organized uploads. Happy with the progress.',
        summary:
            'Fixed the journal layout and organized app progress.',
        keywords: const [
          'journal',
          'layout',
          'uploads',
        ],
        category: 'General',
        mood: 'Motivated',
        isFavorite: false,
        createdAt: DateTime(2026, 6, 1, 7, 42),
        updatedAt: DateTime(2026, 6, 1, 7, 42),
      ),
      JournalEntryModel(
        id: 'demo_2',
        title: 'Prayer Reflection',
        content:
            'Felt peaceful after devotional study. Grateful for today’s blessings.',
        summary:
            'Felt peaceful and grateful after devotional time.',
        keywords: const [
          'prayer',
          'peace',
          'devotional',
        ],
        category: 'Spiritual',
        mood: 'Grateful',
        isFavorite: true,
        createdAt: DateTime(2026, 5, 31, 20, 16),
        updatedAt: DateTime(2026, 5, 31, 20, 16),
      ),
      JournalEntryModel(
        id: 'demo_3',
        title: 'Wellness Check-In',
        content:
            'Needed more rest and hydration today. Tomorrow I’ll plan my meals better.',
        summary:
            'Needed rest, hydration, and better meal planning.',
        keywords: const [
          'rest',
          'hydration',
          'meals',
        ],
        category: 'Wellness',
        mood: 'Tired',
        isFavorite: false,
        createdAt: DateTime(2026, 5, 30, 21, 22),
        updatedAt: DateTime(2026, 5, 30, 21, 22),
      ),
    ];
  }

  List<JournalEntryModel> get visibleEntries {
    final realEntries = entries;

    if (realEntries.isEmpty &&
        searchController.text.trim().isEmpty) {
      return demoEntries;
    }

    return realEntries;
  }

  bool get showingDemo {
    return JournalService.instance.getEntries().isEmpty &&
        searchController.text.trim().isEmpty;
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF4EFE8),
      extendBody: true,
      bottomNavigationBar: AnimatedSlide(
        duration:
            const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
        offset: showBottomNav
            ? Offset.zero
            : const Offset(0, 1.35),
        child: AnimatedOpacity(
          duration:
              const Duration(milliseconds: 220),
          opacity: showBottomNav ? 1 : 0,
          child: _IconBottomNav(
            onJournal: () {},
            onCalendar: _openCalendar,
            onAdd: _openEditor,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: scrollController,
          physics:
              const BouncingScrollPhysics(),
          padding:
              const EdgeInsets.fromLTRB(
            20,
            18,
            20,
            92,
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Journal',
                      style: GoogleFonts
                          .cormorantGaramond(
                        fontSize: 34,
                        height: 1,
                        color:
                            const Color(
                          0xFF2D241E,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _openEditor,
                    child: Container(
                      height: 44,
                      width: 44,
                      decoration:
                          const BoxDecoration(
                        color:
                            Color(0xFF74624F),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add_rounded,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 18,
              ),

              _SearchField(
                controller:
                    searchController,
                onChanged: () {
                  setState(() {});
                },
              ),

              const SizedBox(
                height: 16,
              ),

              Row(
                children: [
                  Text(
                    'Recent Entries',
                    style:
                        GoogleFonts.inter(
                      fontSize: 12,
                      color:
                          const Color(
                        0xFF4D4239,
                      ),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: _openCalendar,
                    child: Text(
                      'Calendar',
                      style:
                          GoogleFonts.inter(
                        fontSize: 12,
                        color:
                            const Color(
                          0xFF74624F,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 8,
              ),

              if (visibleEntries.isEmpty)
                _EmptyJournalState(
                  onAdd: _openEditor,
                )
              else
                ...visibleEntries.map(
                  (entry) => _JournalTile(
                    entry: entry,
                    isDemo: showingDemo,
                    onTap: () {
                      if (showingDemo) {
                        _openEditor();
                      } else {
                        _openEntry(entry);
                      }
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onChanged;

  const _SearchField({
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: const Color(0xFFF8F2EA),
        borderRadius:
            BorderRadius.circular(
          16,
        ),
        border: Border.all(
          color:
              const Color(0xFFD8CEC4)
                  .withOpacity(.75),
          width: .7,
        ),
      ),
      child: TextField(
        controller: controller,
        onChanged: (_) =>
            onChanged(),
        cursorColor:
            const Color(0xFF74624F),
        decoration:
            InputDecoration(
          border: InputBorder.none,
          prefixIcon: const Icon(
            Icons.search_rounded,
            color:
                Color(0xFF6C5E53),
            size: 20,
          ),
          hintText:
              'Search your thoughts...',
          hintStyle:
              GoogleFonts.inter(
            color:
                const Color(0xFF8C8178),
            fontSize: 13,
          ),
        ),
        style: GoogleFonts.inter(
          fontSize: 13,
          color:
              const Color(0xFF2D241E),
        ),
      ),
    );
  }
}

class _JournalTile extends StatelessWidget {
  final JournalEntryModel entry;
  final bool isDemo;
  final VoidCallback onTap;

  const _JournalTile({
    required this.entry,
    required this.isDemo,
    required this.onTap,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.only(
          bottom: 12,
          top: 0,
        ),
        margin:
            const EdgeInsets.only(
          bottom: 8,
        ),
        decoration:
            BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color:
                  const Color(
                0xFFD8CEC4,
              ).withOpacity(
                .72,
              ),
              width: .7,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    entry.title,
                    style: GoogleFonts
                        .cormorantGaramond(
                      fontSize: 20,
                      height: 1.02,
                      color:
                          const Color(
                        0xFF2D241E,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                Text(
                  _formatTime(
                    entry.createdAt,
                  ),
                  style:
                      GoogleFonts.inter(
                    fontSize: 12,
                    color:
                        const Color(
                      0xFF2D241E,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 5,
            ),

            Text(
              entry.summary,
              maxLines: 2,
              overflow:
                  TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: 12.5,
                height: 1.28,
                color:
                    const Color(
                  0xFF332B25,
                ),
              ),
            ),

            const SizedBox(
              height: 5,
            ),

            Row(
              children: [
                Text(
                  _formatDate(
                    entry.createdAt,
                  ),
                  style:
                      GoogleFonts.inter(
                    fontSize: 10.5,
                    color:
                        const Color(
                      0xFF7F7268,
                    ),
                  ),
                ),
                if (isDemo) ...[
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    'Preview',
                    style:
                        GoogleFonts.inter(
                      fontSize: 10.5,
                      color:
                          const Color(
                        0xFFB08D6D,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyJournalState extends StatelessWidget {
  final VoidCallback onAdd;

  const _EmptyJournalState({
    required this.onAdd,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return GestureDetector(
      onTap: onAdd,
      child: Container(
        width: double.infinity,
        padding:
            const EdgeInsets.symmetric(
          vertical: 34,
        ),
        child: Column(
          children: [
            Text(
              'Welcome to your Journal',
              style: GoogleFonts
                  .cormorantGaramond(
                fontSize: 25,
                color:
                    const Color(
                  0xFF2D241E,
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              'Write freely. CIANTIS will organize it.',
              textAlign:
                  TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 12,
                color:
                    const Color(
                  0xFF7F7268,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IconBottomNav extends StatelessWidget {
  final VoidCallback onJournal;
  final VoidCallback onCalendar;
  final VoidCallback onAdd;

  const _IconBottomNav({
    required this.onJournal,
    required this.onCalendar,
    required this.onAdd,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return SafeArea(
      top: false,
      child: Padding(
        padding:
            const EdgeInsets.fromLTRB(
          54,
          0,
          54,
          12,
        ),
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
          children: [
            _NavIcon(
              icon: Icons.notes_rounded,
              onTap: onJournal,
            ),
            _NavIcon(
              icon: Icons
                  .calendar_month_outlined,
              onTap: onCalendar,
            ),
            _NavIcon(
              icon: Icons.add_rounded,
              onTap: onAdd,
            ),
          ],
        ),
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _NavIcon({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return GestureDetector(
      behavior:
          HitTestBehavior.translucent,
      onTap: onTap,
      child: SizedBox(
        height: 46,
        width: 46,
        child: Icon(
          icon,
          size: 23,
          color:
              const Color(0xFF4A3F37),
        ),
      ),
    );
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
