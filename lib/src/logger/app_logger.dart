import 'dart:io';
import 'dart:isolate';

class _LogMessage {
  final String action;
  final String message;
  final String logPath;
  _LogMessage(this.action, this.message, this.logPath);
}

void _logIsolateEntry(SendPort readyPort) {
  final receivePort = ReceivePort();
  readyPort.send(receivePort.sendPort);

  receivePort.listen((msg) {
    if (msg is _LogMessage) {
      try {
        final now = DateTime.now();
        final ts =
            '${now.year.toString().padLeft(4, '0')}-'
            '${now.month.toString().padLeft(2, '0')}-'
            '${now.day.toString().padLeft(2, '0')} '
            '${now.hour.toString().padLeft(2, '0')}:'
            '${now.minute.toString().padLeft(2, '0')}:'
            '${now.second.toString().padLeft(2, '0')}';
        final line = '[$ts] [${msg.action}] ${msg.message}\n';
        File(msg.logPath).writeAsStringSync(line, mode: FileMode.append);
      } catch (e) {
        stderr.writeln('[LOGGER ERROR] $e');
      }
    } else if (msg == 'close') {
      receivePort.close();
    }
  });
}

class AppLogger {
  static AppLogger? _instance;
  static SendPort? _sendPort;
  static final String _logPath = () {
    return '${Directory.current.path}${Platform.pathSeparator}app.log';
  }();

  AppLogger._();

  factory AppLogger() {
    _instance ??= AppLogger._();
    return _instance!;
  }

  static Future<void> init() async {
    if (_sendPort != null) return;
    final ready = ReceivePort();
    await Isolate.spawn(_logIsolateEntry, ready.sendPort);
    _sendPort = await ready.first as SendPort;
    ready.close();
  }

  void _write(String action, String message) {
    try {
      _sendPort?.send(_LogMessage(action, message, _logPath));
    } catch (e) {
      stderr.writeln('[LOGGER ERROR] Could not send log: $e');
    }
  }

  void start(String message) => _write('START', message);
  void add(String message) => _write('ADD', message);
  void update(String message) => _write('UPDATE', message);
  void delete(String message) => _write('DELETE', message);
  void read(String message) => _write('READ', message);
  void report(String message) => _write('REPORT', message);
  void error(String message) => _write('ERROR', message);
  void exit_(String message) => _write('EXIT', message);

  Future<void> close() async {
    _sendPort?.send('close');
    await Future.delayed(const Duration(milliseconds: 200));
    _sendPort = null;
  }
}
