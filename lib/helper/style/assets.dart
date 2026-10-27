/// Central registry of every static asset bundled with the app.
///
/// Whenever a new file is dropped into /assets, add its key here so the
/// rest of the app never hardcodes a raw path string.
final class Assets {
  Assets._();

  // * Paths
  static const _iconPath = 'assets/icons';
  static const _imagePath = 'assets/images';
  static const _lottiePath = 'assets/lottie';
  static const _translationPath = 'assets/translations';
  static const _fontPath = 'assets/fonts';

  // * Images
  static const imageAppIcon = '$_imagePath/app_icon.png';

  // * Lottie (bundled)
  static const lottieInfo = '$_lottiePath/lt_info.json';
  static const lottieSuccess = '$_lottiePath/lt_success.json';

  // * Fonts / Icons — reserved paths for future custom font & icon drops.
  static const iconPath = _iconPath;
  static const fontPath = _fontPath;

  // * Translations
  static const translationPath = _translationPath;
}
