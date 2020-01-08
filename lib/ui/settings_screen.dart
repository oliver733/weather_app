import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  static const routeName = "/settings";

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
          iconTheme: IconThemeData(color: Colors.black),
          title: Text(
            "Settings",
            style: TextStyle(color: Colors.black, fontSize: 16),
          ),
        ),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 30),
                    title: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Cryptocurrency Price Data provided by ",
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          ),
                          TextSpan(
                            text: 'BitcoinAverage',
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                const url = 'https://bitcoinaverage.com';
                                try {
                                  if (await canLaunch(url)) {
                                    await launch(url);
                                  } else {
                                    print('Could not launch $url');
                                  }
                                } catch (error) {
                                  print(error);
                                }
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(),
                ],
              ),
            ),
          ),
        ));
  }
}
