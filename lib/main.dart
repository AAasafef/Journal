import 'package:flutter/material.dart';

import 'theme/app_theme.dart';
import 'screens/journal/journal_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const CiantisJournalsApp(),
  );
}

class CiantisJournalsApp extends StatelessWidget {
  const CiantisJournalsApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ciantis Journals',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(),
      home: const JournalScreen(),
    );
  }
}
