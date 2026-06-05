import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/journal_entry_model.dart';
import '../../services/journal_service.dart';
import 'journal_entry_screen.dart';

class JournalCalendarScreen extends StatefulWidget {
  const JournalCalendarScreen({
    super.key,
  });

  @override
  State<JournalCalendarScreen> createState() =>
      _JournalCalendarScreenState();
}

class _JournalCalendarScreenState
    extends State<JournalCalendarScreen> {
  DateTime selectedDate = DateTime.now();

  List<JournalEntryModel> get entries {
    return JournalService.instance.getEntries();
  }

  List<JournalEntryModel> get selectedEntries {
    return entries.where((entry) {
      return entry.createdAt.year ==
              selectedDate.year &&
          entry.createdAt.month ==
              selectedDate.month &&
          entry.createdAt.day ==
              selectedDate.day;
    }).toList();
  }

  bool _hasEntry(int day) {
    return entries.any((entry) {
      return entry.createdAt.year ==
              selectedDate.year &&
          entry.createdAt.month ==
              selectedDate.month &&
          entry.createdAt.day == day;
    });
  }

  void _previousMonth() {
    setState(() {
      selectedDate = DateTime(
        selectedDate.year,
        selectedDate.month - 1,
        selectedDate.day,
      );
    });
  }

  void _nextMonth() {
    setState(() {
      selectedDate = DateTime(
        selectedDate.year,
        selectedDate.month + 1,
        selectedDate.day,
      );
    });
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

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF4EFE8),
      body: SafeArea(
        child: SingleChildScrollView(
          physics:
              const BouncingScrollPhysics(),
          padding:
              const EdgeInsets.fromLTRB(
            20,
            18,
            20,
            90,
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
                  Expanded(
                    child: Text(
                      'Journal Calendar',
                      style: GoogleFonts
                          .cormorantGaramond(
                        fontSize: 34,
                        color:
                            const Color(
                          0xFF2D241E,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 20,
              ),

              Row(
                children: [
                  IconButton(
                    onPressed:
                        _previousMonth,
                    icon: const Icon(
                      Icons
                          .chevron_left_rounded,
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        _monthYear(
                          selectedDate,
                        ),
                        style:
                            GoogleFonts.inter(
                          fontSize: 17,
                          color:
                              const Color(
                            0xFF2D241E,
                          ),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed:
                        _nextMonth,
                    icon: const Icon(
                      Icons
                          .chevron_right_rounded,
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 16,
              ),

              _CalendarGrid(
                selectedDate:
                    selectedDate,
                hasEntry:
                    _hasEntry,
                onSelectedDate:
                    (date) {
                  setState(() {
                    selectedDate =
                        date;
                  });
                },
              ),

              const SizedBox(
                height: 24,
              ),

              Container(
                width:
                    double.infinity,
                padding:
                    const EdgeInsets
                        .fromLTRB(
                  18,
                  17,
                  18,
                  10,
                ),
                decoration:
                    BoxDecoration(
                  color:
                      const Color(
                    0xFFF8F2EA,
                  ).withOpacity(
                    .82,
                  ),
                  borderRadius:
                      BorderRadius
                          .circular(
                    20,
                  ),
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    Text(
                      _longDate(
                        selectedDate,
                      ),
                      style:
                          GoogleFonts.inter(
                        fontSize: 15,
                        color:
                            const Color(
                          0xFF2D241E,
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    if (selectedEntries
                        .isEmpty)
                      Padding(
                        padding:
                            const EdgeInsets
                                .only(
                          bottom: 10,
                        ),
                        child: Text(
                          'No entries for this date.',
                          style: GoogleFonts
                              .inter(
                            fontSize: 12,
                            color:
                                const Color(
                              0xFF84776C,
                            ),
                          ),
                        ),
                      )
                    else
                      ...selectedEntries.map(
                        (entry) =>
                            _CalendarEntryTile(
                          entry: entry,
                          onTap: () =>
                              _openEntry(
                            entry,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CalendarGrid extends StatelessWidget {
  final DateTime selectedDate;
  final bool Function(int day) hasEntry;
  final ValueChanged<DateTime> onSelectedDate;

  const _CalendarGrid({
    required this.selectedDate,
    required this.hasEntry,
    required this.onSelectedDate,
  });

  @override
  Widget build(BuildContext context) {
    final firstDayOfMonth = DateTime(
      selectedDate.year,
      selectedDate.month,
      1,
    );

    final daysInMonth = DateTime(
      selectedDate.year,
      selectedDate.month + 1,
      0,
    ).day;

    final previousMonthDays = DateTime(
      selectedDate.year,
      selectedDate.month,
      0,
    ).day;

    final startOffset =
        firstDayOfMonth.weekday % 7;

    final totalCells =
        ((startOffset + daysInMonth) / 7)
                .ceil() *
            7;

    final labels =
        List.generate(totalCells, (index) {
      final dayNumber =
          index - startOffset + 1;

      if (dayNumber < 1) {
        return _CalendarDay(
          label:
              '${previousMonthDays + dayNumber}',
          day:
              previousMonthDays +
                  dayNumber,
          isCurrentMonth: false,
        );
      }

      if (dayNumber > daysInMonth) {
        return _CalendarDay(
          label:
              '${dayNumber - daysInMonth}',
          day:
              dayNumber -
                  daysInMonth,
          isCurrentMonth: false,
        );
      }

      return _CalendarDay(
        label: '$dayNumber',
        day: dayNumber,
        isCurrentMonth: true,
      );
    });

    return Column(
      children: [
        Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceAround,
          children: [
            'S',
            'M',
            'T',
            'W',
            'T',
            'F',
            'S',
          ].map((day) {
            return SizedBox(
              width: 34,
              child: Center(
                child: Text(
                  day,
                  style:
                      GoogleFonts.inter(
                    fontSize: 12,
                    color: const Color(
                      0xFF6F6258,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(
          height: 12,
        ),

        GridView.builder(
          shrinkWrap: true,
          physics:
              const NeverScrollableScrollPhysics(),
          itemCount: labels.length,
          gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 7,
            crossAxisSpacing: 4,
          ),
          itemBuilder:
              (context, index) {
            final item = labels[index];

            final isSelected =
                item.isCurrentMonth &&
                    selectedDate.day ==
                        item.day;

            return GestureDetector(
              onTap: item.isCurrentMonth
                  ? () => onSelectedDate(
                        DateTime(
                          selectedDate.year,
                          selectedDate.month,
                          item.day,
                        ),
                      )
                  : null,
              child: Column(
                children: [
                  Container(
                    height: 34,
                    width: 34,
                    alignment:
                        Alignment.center,
                    decoration:
                        BoxDecoration(
                      shape:
                          BoxShape.circle,
                      color: isSelected
                          ? const Color(
                              0xFF9A8977,
                            )
                          : Colors
                              .transparent,
                    ),
                    child: Text(
                      item.label,
                      style:
                          GoogleFonts.inter(
                        fontSize: 14,
                        color: !item
                                .isCurrentMonth
                            ? const Color(
                                0xFFB8ADA3,
                              )
                            : isSelected
                                ? Colors
                                    .white
                                : const Color(
                                    0xFF2D241E,
                                  ),
                      ),
                    ),
                  ),

                  if (item.isCurrentMonth &&
                      hasEntry(
                        item.day,
                      ))
                    Container(
                      height: 3.5,
                      width: 3.5,
                      decoration:
                          const BoxDecoration(
                        color: Color(
                          0xFF9A8977,
                        ),
                        shape:
                            BoxShape.circle,
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _CalendarEntryTile extends StatelessWidget {
  final JournalEntryModel entry;
  final VoidCallback onTap;

  const _CalendarEntryTile({
    required this.entry,
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
            const EdgeInsets.symmetric(
          vertical: 12,
        ),
        decoration:
            BoxDecoration(
          border: Border(
            top: BorderSide(
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
        child: Row(
          children: [
            SizedBox(
              width: 58,
              child: Text(
                _formatTime(
                  entry.createdAt,
                ),
                style:
                    GoogleFonts.inter(
                  fontSize: 11,
                  color:
                      const Color(
                    0xFF4D4239,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                children: [
                  Text(
                    entry.title,
                    style: GoogleFonts
                        .inter(
                      fontSize: 14,
                      color:
                          const Color(
                        0xFF2D241E,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    entry.summary,
                    maxLines: 2,
                    overflow:
                        TextOverflow
                            .ellipsis,
                    style: GoogleFonts
                        .inter(
                      fontSize: 12,
                      height: 1.28,
                      color:
                          const Color(
                        0xFF5E5249,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons
                  .chevron_right_rounded,
              color: Color(
                0xFF8C8178,
              ),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class _CalendarDay {
  final String label;
  final int day;
  final bool isCurrentMonth;

  const _CalendarDay({
    required this.label,
    required this.day,
    required this.isCurrentMonth,
  });
}

String _monthYear(
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

  return '${months[date.month - 1]} ${date.year}';
}

String _longDate(
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
