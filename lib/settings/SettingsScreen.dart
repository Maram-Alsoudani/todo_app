import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/providers/AppConfigProvider.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final appConfigProvider = Provider.of<AppConfigProvider>(context);
    final localization = AppLocalizations.of(context)!;
    var provider = Provider.of<AppConfigProvider>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localization.language,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: provider.appTheme == ThemeMode.light
                  ? Colors.black
                  : Colors.white,
            ),
          ),
          SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: appConfigProvider.appLanguage == "en"
                ? localization.english
                : localization.arabic,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.blue,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.blue,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.blue,
                ),
              ),
            ),
            onChanged: (String? newValue) {
              if (newValue != null) {
                appConfigProvider.changeAppLanguage(
                    newValue == localization.english ? 'en' : 'ar');
              }
            },
            items: [localization.english, localization.arabic]
                .map((String language) {
              return DropdownMenuItem<String>(
                value: language,
                child: Text(
                  language,
                  style: TextStyle(
                    color: appConfigProvider.appLanguage ==
                            (language == localization.english ? 'en' : 'ar')
                        ? Colors.blue
                        : Colors.black,
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 20),
          Text(
            localization.mode,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: provider.appTheme == ThemeMode.light
                  ? Colors.black
                  : Colors.white,
            ),
          ),
          SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: appConfigProvider.appTheme == ThemeMode.dark
                ? localization.dark
                : localization.light,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.blue,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.blue,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.blue,
                ),
              ),
            ),
            onChanged: (String? newValue) {
              if (newValue != null) {
                appConfigProvider.changeAppTheme(newValue == localization.dark
                    ? ThemeMode.dark
                    : ThemeMode.light);
              }
            },
            items: [localization.light, localization.dark].map((String theme) {
              return DropdownMenuItem<String>(
                value: theme,
                child: Text(
                  theme,
                  style: TextStyle(
                    color: appConfigProvider.appTheme ==
                            (theme == localization.dark
                                ? ThemeMode.dark
                                : ThemeMode.light)
                        ? Colors.blue
                        : Colors.black,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
