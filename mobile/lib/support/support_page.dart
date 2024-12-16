import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mental_health_app/app_drawer.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportPage extends StatefulWidget {
  const SupportPage({super.key});

  @override
  State<StatefulWidget> createState() => _SupportState();
}

class _SupportState extends State<SupportPage> {
  final number = '+380000000000';
  final email = 'mentalhealthapp@gmail.com';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Support"),
      ),
      drawer: const AppDrawer(),
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.phoneVolume),
            title: Text(number),
            onTap: () async {
              await launchUrl(Uri(scheme: 'tel', path: number));
            },
          ),
          ListTile(
            leading: const Text(
              '@',
              style: TextStyle(fontSize: 30),
            ),
            title: Text(email),
            onTap: () async {
              await launchUrl(Uri(scheme: 'mailto', path: email));
            },
          )
        ],
      ),
    );
  }
}
