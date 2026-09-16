/// Runtime endpoint configuration for the Doxary product API.
///
/// Supply `--dart-define=DOXARY_API_BASE_URL=https://…/api/v1` for a device
/// or non-default environment. The development default is Android-emulator
/// loopback; it is deliberately not a LAN address or a production endpoint.
class DoxaryApiConfig {
  const DoxaryApiConfig({required this.baseUri});

  factory DoxaryApiConfig.fromEnvironment() {
    const configured = String.fromEnvironment(
      'DOXARY_API_BASE_URL',
      defaultValue: 'http://10.0.2.2:5000/api/v1',
    );
    return DoxaryApiConfig(baseUri: Uri.parse(configured));
  }

  final Uri baseUri;

  Uri resolve(String path) {
    final configuredPath = baseUri.path.replaceFirst(RegExp(r'/+$'), '');
    final apiPath = configuredPath.isEmpty || configuredPath == '/'
        ? '/api/v1'
        : configuredPath.endsWith('/api/v1')
        ? configuredPath
        : '$configuredPath/api/v1';
    final normalized = baseUri.replace(path: '$apiPath/');
    return normalized.resolve(path);
  }
}
