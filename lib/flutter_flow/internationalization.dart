import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kLocaleStorageKey = '__locale_key__';

class FFLocalizations {
  FFLocalizations(this.locale);

  final Locale locale;

  static FFLocalizations of(BuildContext context) =>
      Localizations.of<FFLocalizations>(context, FFLocalizations)!;

  static List<String> languages() => ['ja', 'en'];

  static late SharedPreferences _prefs;
  static Future initialize() async =>
      _prefs = await SharedPreferences.getInstance();
  static Future storeLocale(String locale) =>
      _prefs.setString(_kLocaleStorageKey, locale);
  static Locale? getStoredLocale() {
    final locale = _prefs.getString(_kLocaleStorageKey);
    return locale != null && locale.isNotEmpty ? createLocale(locale) : null;
  }

  String get languageCode => locale.toString();
  String? get languageShortCode =>
      _languagesWithShortCode.contains(locale.toString())
          ? '${locale.toString()}_short'
          : null;
  int get languageIndex => languages().contains(languageCode)
      ? languages().indexOf(languageCode)
      : 0;

  String getText(String key) =>
      (kTranslationsMap[key] ?? {})[locale.toString()] ?? '';

  String getVariableText({
    String? jaText = '',
    String? enText = '',
  }) =>
      [jaText, enText][languageIndex] ?? '';

  static const Set<String> _languagesWithShortCode = {
    'ar',
    'az',
    'ca',
    'cs',
    'da',
    'de',
    'dv',
    'en',
    'es',
    'et',
    'fi',
    'fr',
    'gr',
    'he',
    'hi',
    'hu',
    'it',
    'km',
    'ku',
    'mn',
    'ms',
    'no',
    'pt',
    'ro',
    'ru',
    'rw',
    'sv',
    'th',
    'uk',
    'vi',
  };
}

/// Used if the locale is not supported by GlobalMaterialLocalizations.
class FallbackMaterialLocalizationDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const FallbackMaterialLocalizationDelegate();

  @override
  bool isSupported(Locale locale) => _isSupportedLocale(locale);

  @override
  Future<MaterialLocalizations> load(Locale locale) async =>
      SynchronousFuture<MaterialLocalizations>(
        const DefaultMaterialLocalizations(),
      );

  @override
  bool shouldReload(FallbackMaterialLocalizationDelegate old) => false;
}

/// Used if the locale is not supported by GlobalCupertinoLocalizations.
class FallbackCupertinoLocalizationDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const FallbackCupertinoLocalizationDelegate();

  @override
  bool isSupported(Locale locale) => _isSupportedLocale(locale);

  @override
  Future<CupertinoLocalizations> load(Locale locale) =>
      SynchronousFuture<CupertinoLocalizations>(
        const DefaultCupertinoLocalizations(),
      );

  @override
  bool shouldReload(FallbackCupertinoLocalizationDelegate old) => false;
}

class FFLocalizationsDelegate extends LocalizationsDelegate<FFLocalizations> {
  const FFLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => _isSupportedLocale(locale);

  @override
  Future<FFLocalizations> load(Locale locale) =>
      SynchronousFuture<FFLocalizations>(FFLocalizations(locale));

  @override
  bool shouldReload(FFLocalizationsDelegate old) => false;
}

Locale createLocale(String language) => language.contains('_')
    ? Locale.fromSubtags(
        languageCode: language.split('_').first,
        scriptCode: language.split('_').last,
      )
    : Locale(language);

bool _isSupportedLocale(Locale locale) {
  final language = locale.toString();
  return FFLocalizations.languages().contains(
    language.endsWith('_')
        ? language.substring(0, language.length - 1)
        : language,
  );
}

final kTranslationsMap = <Map<String, Map<String, String>>>[
  // pokerPage
  {
    'aohgx1yf': {
      'ja': 'Home',
      'en': '',
    },
  },
  // Miscellaneous
  {
    'ng87wssm': {
      'ja': '',
      'en': '',
    },
    'kc0vtds3': {
      'ja': '',
      'en': '',
    },
    '1m3xsnc2': {
      'ja': '',
      'en': '',
    },
    '3gz5z3tp': {
      'ja': '',
      'en': '',
    },
    'idou9fgx': {
      'ja': '',
      'en': '',
    },
    'eem0sl3i': {
      'ja': '',
      'en': '',
    },
    'uue6jhc1': {
      'ja': '',
      'en': '',
    },
    '45nzm93s': {
      'ja': '',
      'en': '',
    },
    '38j0tcxj': {
      'ja': '',
      'en': '',
    },
    '5qq85829': {
      'ja': '',
      'en': '',
    },
    'z3kvkhmb': {
      'ja': '',
      'en': '',
    },
    'x7jvnfop': {
      'ja': '',
      'en': '',
    },
    'np6dzoo2': {
      'ja': '',
      'en': '',
    },
    'pucxnrx4': {
      'ja': '',
      'en': '',
    },
    'pgk10wq0': {
      'ja': '',
      'en': '',
    },
    '6c4ghkpe': {
      'ja': '',
      'en': '',
    },
    '2lmjz1v6': {
      'ja': '',
      'en': '',
    },
    '2f5pumxe': {
      'ja': '',
      'en': '',
    },
    '98d7157x': {
      'ja': '',
      'en': '',
    },
    '3zysb24k': {
      'ja': '',
      'en': '',
    },
    'ozvr9ysg': {
      'ja': '',
      'en': '',
    },
    'a1zjonk6': {
      'ja': '',
      'en': '',
    },
    '2vywxvwj': {
      'ja': '',
      'en': '',
    },
    'pkkint6c': {
      'ja': '',
      'en': '',
    },
    '6lu402lz': {
      'ja': '',
      'en': '',
    },
  },
].reduce((a, b) => a..addAll(b));
