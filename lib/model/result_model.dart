class ResultModel {
  final int netSpeed;
  final int grossSpeed;
  final int keystrokes;
  final int backspace;
  final int correctWords;
  final int wrongWords;
  final double accuracy;
  final String typedText;
  final String originalText;
  final String duration;
  final String mode;
  final String date;
  final String time;

  ResultModel({
    required this.netSpeed,
    required this.grossSpeed,
    required this.keystrokes,
    required this.backspace,
    required this.correctWords,
    required this.wrongWords,
    required this.accuracy,
    required this.typedText,
    required this.originalText,
    required this.duration,
    required this.mode,
    required this.date,
    required this.time,
  });

  factory ResultModel.fromMap(Map<String, dynamic> map) {
    return ResultModel(
      netSpeed: map['net_speed'],
      grossSpeed: map['gross_speed'],
      keystrokes: map['keystrokes'],
      backspace: map['backspace'],
      correctWords: map['correct_words'],
      wrongWords: map['wrong_words'],
      accuracy: map['accuracy'],
      typedText: map['typed_text'],
      originalText: map['original_text'],
      duration: map['duration'],
      mode: map['mode'],
      date: map['date'],
      time: map['time'],
    );
  }
}
