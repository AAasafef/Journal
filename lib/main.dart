import 'package:flutter/material.dart';

import 'screens/journal/journal_screen.dart';
import 'services/journal_service.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await JournalService.instance.initialize();

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
