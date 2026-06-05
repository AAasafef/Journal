import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/journal_entry_model.dart';

class JournalService {
  JournalService._();

  static final JournalService instance =
      JournalService._();

  static const String _storageKey =
      'ciantis_journal_entries';

  final List<JournalEntryModel> _entries = [];

  List<JournalEntryModel> getEntries() {
    final sorted = [..._entries];

    sorted.sort(
      (a, b) => b.createdAt.compareTo(
        a.createdAt,
      ),
    );

    return sorted;
  }

  Future<void> initialize() async {
    final prefs =
        await SharedPreferences.getInstance();

    final data =
        prefs.getString(_storageKey);

    if (data == null || data.isEmpty) {
      return;
    }

    final decoded =
        jsonDecode(data) as List<dynamic>;

    _entries.clear();

    _entries.addAll(
      decoded.map(
        (e) => JournalEntryModel.fromJson(
          Map<String, dynamic>.from(e),
        ),
      ),
    );
  }

  Future<void> _saveToDisk() async {
    final prefs =
        await SharedPreferences.getInstance();

    final jsonString = jsonEncode(
      _entries
          .map((e) => e.toJson())
          .toList(),
    );

    await prefs.setString(
      _storageKey,
      jsonString,
    );
  }

  Future<void> addEntry(
    JournalEntryModel entry,
  ) async {
    _entries.add(entry);

    await _saveToDisk();
  }

  Future<void> updateEntry(
    JournalEntryModel updated,
  ) async {
    final index = _entries.indexWhere(
      (e) => e.id == updated.id,
    );

    if (index == -1) return;

    _entries[index] = updated;

    await _saveToDisk();
  }

  Future<void> deleteEntry(
    String id,
  ) async {
    _entries.removeWhere(
      (e) => e.id == id,
    );

    await _saveToDisk();
  }

  Future<void> toggleFavorite(
    String id,
  ) async {
    final index = _entries.indexWhere(
      (e) => e.id == id,
    );

    if (index == -1) return;

    final current = _entries[index];

    _entries[index] =
        current.copyWith(
      isFavorite:
          !current.isFavorite,
      updatedAt: DateTime.now(),
    );

    await _saveToDisk();
  }

  List<JournalEntryModel> search(
    String query,
  ) {
    if (query.trim().isEmpty) {
      return getEntries();
    }

    final q =
        query.toLowerCase().trim();

    return getEntries().where(
      (entry) {
        return entry.title
                .toLowerCase()
                .contains(q) ||
            entry.content
                .toLowerCase()
                .contains(q) ||
            entry.summary
                .toLowerCase()
                .contains(q) ||
            entry.category
                .toLowerCase()
                .contains(q) ||
            entry.mood
                .toLowerCase()
                .contains(q) ||
            entry.keywords.any(
              (keyword) => keyword
                  .toLowerCase()
                  .contains(q),
            );
      },
    ).toList();
  }

  String generateTitle(
    String content,
  ) {
    final clean = content
        .replaceAll('\n', ' ')
        .trim();

    if (clean.isEmpty) {
      return 'Journal Entry';
    }

    final words =
        clean.split(' ');

    if (words.length <= 4) {
      return clean;
    }

    return words
        .take(4)
        .join(' ');
  }

  String generateSummary(
    String content,
  ) {
    final clean = content
        .replaceAll('\n', ' ')
        .trim();

    if (clean.length <= 120) {
      return clean;
    }

    return '${clean.substring(0, 120)}...';
  }

  List<String> generateKeywords(
    String content,
  ) {
    final words = content
        .toLowerCase()
        .replaceAll(
          RegExp(
            r'[^a-zA-Z0-9 ]',
          ),
          '',
        )
        .split(' ');

    final unique =
        words.toSet().toList();

    unique.removeWhere(
      (word) =>
          word.length < 5,
    );

    return unique
        .take(8)
        .toList();
  }
}
