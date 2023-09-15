import 'dart:async';
import 'package:admin_ecommerce_app/common_widgets/my_icon.dart';
import 'package:admin_ecommerce_app/constants/app_assets.dart';
import 'package:admin_ecommerce_app/constants/app_colors.dart';
import 'package:admin_ecommerce_app/constants/app_styles.dart';
import 'package:admin_ecommerce_app/models/chat_room.dart';
import 'package:admin_ecommerce_app/services/chat_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound_record/flutter_sound_record.dart';
import 'package:lottie/lottie.dart';

class RecordVoiceScreen extends StatefulWidget {
  const RecordVoiceScreen({super.key, required this.chatRoom});
  static const String routeName = '/record-voice-screen';
  final ChatRoom chatRoom;
  @override
  State<RecordVoiceScreen> createState() => _RecordVoiceScreenState();
}

class _RecordVoiceScreenState extends State<RecordVoiceScreen> {
  final FlutterSoundRecord _flutterSoundRecorder = FlutterSoundRecord();
  bool _isRecording = false;
  bool _isAnimated = false;
  String _filePath = '';
  int _recordDuration = 0;
  Timer? _timer;
  Timer? _ampTimer;

  @override
  void dispose() {
    _timer?.cancel();
    _ampTimer?.cancel();
    _flutterSoundRecorder.dispose();
    super.dispose();
  }

  void startRecording() async {
    // final path = await getTemporaryDirectory();
    await _flutterSoundRecorder.start(
      path: '${DateTime.now().millisecondsSinceEpoch}.m4a', // required
      encoder: AudioEncoder.AAC, // by default
      bitRate: 128000, // by default
      samplingRate: 44100, // by default
    );
    setState(() {
      _isRecording = true;
      _isAnimated = true;
      _recordDuration = 0;
    });
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _ampTimer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() => _recordDuration++);
    });

    _ampTimer =
        Timer.periodic(const Duration(milliseconds: 200), (Timer t) async {
      setState(() {});
    });
  }

  void stopRecording() async {
    _filePath = (await _flutterSoundRecorder.stop())!;
    setState(() {
      _isRecording = false;
      _isAnimated = false;
    });
    _timer?.cancel();
    _ampTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const MyIcon(
          icon: AppAssets.icMic,
          height: 150,
        ),
        _buildTimer(),
        LottieBuilder.asset(
          AppAssets.lottieAudio,
          animate: _isAnimated,
          width: 120,
          fit: BoxFit.cover,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text(
              'Reset',
              style: TextStyle(color: AppColors.backgroundColor),
            ),
            GestureDetector(
              onTap: () {
                if (!_isRecording) {
                  startRecording();
                } else {
                  stopRecording();
                }
              },
              child: CircleAvatar(
                backgroundColor: AppColors.primaryColor,
                radius: 30,
                child: Icon(
                  _isRecording ? Icons.pause : Icons.play_arrow,
                  color: AppColors.whiteColor,
                  size: 30,
                ),
              ),
            ),
            GestureDetector(
                onTap: () => _sendVoiceMessage(),
                child: const MyIcon(
                  icon: AppAssets.icSend,
                  colorFilter:
                      ColorFilter.mode(AppColors.primaryColor, BlendMode.srcIn),
                  height: 35,
                )),
          ],
        ),
      ],
    );
  }

  Future<void> _sendVoiceMessage() async {
    if (_filePath.isNotEmpty) {
      Navigator.of(context).pop();
      await ChatService().sendVoiceMessage(_filePath, widget.chatRoom);
    }
  }

  Widget _buildTimer() {
    final String minutes = _formatNumber(_recordDuration ~/ 60);
    final String seconds = _formatNumber(_recordDuration % 60);

    return Text(
      '$minutes : $seconds',
      style: AppStyles.displayLarge,
    );
  }

  String _formatNumber(int number) {
    String numberStr = number.toString();
    if (number < 10) {
      numberStr = '0$numberStr';
    }

    return numberStr;
  }
}
