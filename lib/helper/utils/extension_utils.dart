import 'package:easy_localization/easy_localization.dart';
import 'package:udaya_visitor/helper/helper_export.dart';

extension ListUtilsExtension<E> on List<E> {
  E? firstWhereOrNull(bool Function(E element) test) {
    for (final element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}

extension DateTimeExtensionUtils on DateTime {
  String get locale => globalContext.locale.languageCode;

  /// 'EEE, dd MMM yyyy'
  String get eDMy => DateFormat('EEE, dd MMM yyyy', locale).format(this);

  /// 'dd MMM yyyy'
  String get dMy => DateFormat('dd MMM yyyy', locale).format(this);

  /// ISO format 'yyyy-MM-dd'
  String get yMd => DateFormat('yyyy-MM-dd', locale).format(this);

  bool isSameDayAs(DateTime other) =>
      year == other.year && month == other.month && day == other.day;
}
