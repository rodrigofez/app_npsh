import 'package:flutter/material.dart';
import 'package:npsh/providers/npsh.dart';
import 'package:npsh/screens/spreadsheet.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    size: Size(1000, 600),
    center: true,
    backgroundColor: Colors.transparent,
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
    await windowManager.setMaximumSize(const Size(1000, 600));
  });

  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (_) => NpshProvider())],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NPSH3',
      home: SpreadSheetScreen(),
    );
  }
}
