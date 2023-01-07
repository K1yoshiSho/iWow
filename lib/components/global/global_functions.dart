import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';
export 'dart:math' show min, max;
export 'dart:typed_data' show Uint8List;
export 'dart:convert' show jsonEncode, jsonDecode;
export 'package:intl/intl.dart';
export 'package:page_transition/page_transition.dart';

void _setTimeagoLocales() {
  timeago.setLocaleMessages('ru', timeago.RuMessages());
}

DateTime stringToDateTime(String dateString) {
  DateTime date = DateTime.parse(dateString);
  return date;
}

String dateTimeFormat(String format, DateTime? dateTime, {String? locale}) {
  if (dateTime == null) {
    return '';
  }
  if (format == 'relative') {
    _setTimeagoLocales();
    return timeago.format(dateTime, locale: locale, clock: DateTime.now());
  }
  return DateFormat(format).format(dateTime);
}

Future launchURL(String url) async {
  Uri uri = Uri.parse(url);
  try {
    await launchUrl(uri);
  } catch (e) {
    throw "Couldn't launch $uri: $e";
  }
}
