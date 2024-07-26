// ignore_for_file: unused_field

import 'dart:isolate';
import 'dart:math';

class Task {
  final int id;
  late ReceivePort _receivePort;
  late Isolate _isolate;
  late SendPort _sendPort;
  bool _isRunning = false;
  bool _isComplete = false;
  final Function onComplete;

  Task(this.id, this.onComplete);

  bool get isRunning => _isRunning;
  bool get isComplete => _isComplete;

  String get status {
    if (_isComplete) {
      return 'Task $id is done $_executionTime seconds';
    } else if (_isRunning) {
      return 'Task $id is running';
    } else {
      return 'Task $id is waiting';
    }
  }

  int _executionTime = 0;

  void start() async {
    _receivePort = ReceivePort();

    _isolate = await Isolate.spawn(_calculation, _receivePort.sendPort);

    _receivePort.listen((message) {
      if (message is SendPort) {
        _sendPort = message;
        _sendPort.send('start');
        _isRunning = true;
        onComplete();
      } else if (message is int) {
        _executionTime = message;
        _isComplete = true;
        _isRunning = false;
        _receivePort.close();
        onComplete();
      }
    });
  }

  static void _calculation(SendPort sendPort) {
    final receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);

    receivePort.listen((message) async {
      if (message == 'start') {
        final Random random = Random();
        final int time = random.nextInt(5) + 1;
        await Future.delayed(Duration(seconds: time));
        sendPort.send(time);
      }
    });
  }
}
