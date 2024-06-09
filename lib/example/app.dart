import 'package:flutter/material.dart';
import 'package:package_atomic_design/package_atomic_design.dart';
import 'package:wo_form/example/dynamic_form/dynamic_form_page.dart';
import 'package:wo_form/example/edit_event/event_page.dart';
import 'package:wo_form/example/form_creator/form_creator_page.dart';
import 'package:wo_form/example/from_json/from_json_page.dart';
import 'package:wo_form/example/profile_creation/profile_creation.dart';
import 'package:wo_form/example/report/report_page.dart';
import 'package:wo_form/wo_form.dart';

class WoFormExamplesApp extends StatelessWidget {
  const WoFormExamplesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WoForm Examples',
      theme: WoTheme.getThemeData(
        brightness: Brightness.light,
        primary: const Color.fromARGB(255, 5, 197, 69),
      ),
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(
      //     // seedColor: const Color.fromARGB(255, 197, 5, 181),
      //     seedColor: Color.fromARGB(255, 5, 197, 69),
      //     // brightness: Brightness.dark,
      //   ),
      // ),
      supportedLocales: FormLocalizations.supportedLocales,
      localizationsDelegates: FormLocalizations.localizationsDelegates,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.contrastedBackground,
      body: WoPadding.allMedium(
        child: ListView(
          children: [
            WoGap.xxxlarge,
            WoPadding.allMedium(
              child: Text(
                "Exemples d'utilisation du package wo_form",
                style: context.textTheme.titleCard,
              ),
            ),
            WoGap.small,
            ListTile(
              onTap: () => context.pushPage(const ReportPage()),
              leading: const Icon(Icons.quiz),
              title: const Text(
                'Poser des questions',
                style: TextStyleExt.bold,
              ),
              subtitle: const Text('Ex : Formulaire de signalement'),
              trailing: const Icon(Icons.chevron_right),
            ),
            ListTile(
              onTap: () => context.pushPage(const EventsPage()),
              leading: const Icon(Icons.edit),
              title: const Text(
                'Éditer un objet',
                style: TextStyleExt.bold,
              ),
              subtitle: const Text('En quelques lignes'),
              trailing: const Icon(Icons.chevron_right),
            ),
            ListTile(
              onTap: () => context.pushPage(const DynamicFormPage()),
              leading: const Icon(Icons.electric_bolt),
              title: const Text(
                'Dynamiser un formulaire',
                style: TextStyleExt.bold,
              ),
              subtitle: const Text("C'est sympa ça"),
              trailing: const Icon(Icons.chevron_right),
            ),
            ListTile(
              onTap: () => context.pushPage(const ProfileCreationPage()),
              leading: const Icon(Icons.local_shipping),
              title: const Text(
                "Fluidifier l'UX grâce à plusieurs pages",
                style: TextStyleExt.bold,
              ),
              subtitle: const Text('Ex : Formulaire de création de profil'),
              trailing: const Icon(Icons.chevron_right),
            ),
            ListTile(
              onTap: () => context.pushPage(const StringInputPage()),
              leading: const Icon(Icons.edit_note),
              title: const Text(
                'Créer un formulaire en quelques clics...',
                style: TextStyleExt.bold,
              ),
              subtitle: const Text('Via un formulaire'),
              trailing: const Icon(Icons.chevron_right),
            ),
            ListTile(
              onTap: () => context.pushPage(const FromJsonPage()),
              leading: const Icon(Icons.download),
              title: const Text(
                "... et l'importer ailleurs",
                style: TextStyleExt.bold,
              ),
              subtitle: const Text('Via un fichier JSON'),
              trailing: const Icon(Icons.chevron_right),
            ),
          ],
        ),
      ),
    );
  }
}
