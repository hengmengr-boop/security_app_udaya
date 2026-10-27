import 'package:udaya_visitor/helper/helper_export.dart';

bool get isSignedIn => AppPreference.getAccessToken != null;

String getErrorContent({required dynamic exception, required dynamic stackTrace}) {
  return '------------- Exception ---------------'
      '\n\n$exception\n\n'
      '------------- Stack Trace -------------'
      '\n\n$stackTrace\n\n'
          .trim();
}
