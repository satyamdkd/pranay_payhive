capitalizeFirstCharacter(String? text) {
  return text != null && text.isNotEmpty
      ? "${text[0].toUpperCase()}${text.substring(1).toLowerCase()}"
      : "";
}

/// --------------------------------- acronym ----------------------------------

String makeAcronym(String sentence) {
  /// Split sentence into words
  List<String> words = sentence.trim().split(RegExp(r'\s+'));

  /// Take first letter of each word, make it uppercase, then join them
  String acronym = words.map((word) => word[0].toUpperCase()).join();

  return acronym;
}


String generateIdTimestampBased() {
  final now = DateTime.now().toUtc();
  final yy = (now.year % 100).toString().padLeft(2, '0'); // 00-99
  final MM = now.month.toString().padLeft(2, '0');        // 01-12
  final dd = now.day.toString().padLeft(2, '0');          // 01-31
  final HH = now.hour.toString().padLeft(2, '0');         // 00-23
  final mm = now.minute.toString().padLeft(2, '0');       // 00-59
  final ss = now.second.toString().padLeft(2, '0');       // 00-59
  final SS = (now.millisecond ~/ 10).toString().padLeft(2, '0'); // 00-99 (hundredths)

  return 'N$yy$MM$dd$HH$mm$ss$SS'; // e.g., N25081703451234
}