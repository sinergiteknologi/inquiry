import 'package:flutter/widgets.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class KeepScreenOn extends StatefulWidget {
  const KeepScreenOn({super.key, required this.child});

  final Widget child;

  @override
  State<KeepScreenOn> createState() => _KeepScreenOnState();
}

class _KeepScreenOnState extends State<KeepScreenOn> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _enableWakeLock();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _enableWakeLock();
    }
  }

  Future<void> _enableWakeLock() async {
    await WakelockPlus.enable();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
