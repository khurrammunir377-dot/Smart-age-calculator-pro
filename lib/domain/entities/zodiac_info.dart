class WesternZodiac {
  final String signName;
  final String symbol;
  final String dateRange;
  final String personalitySummary;

  WesternZodiac({
    required this.signName,
    required this.symbol,
    required this.dateRange,
    required this.personalitySummary,
  });
}

class ChineseZodiac {
  final String animalSign;
  final String emoji;
  final int birthYear;
  final String characteristics;

  ChineseZodiac({
    required this.animalSign,
    required this.emoji,
    required this.birthYear,
    required this.characteristics,
  });
}

class ZodiacInfo {
  final WesternZodiac westernZodiac;
  final ChineseZodiac chineseZodiac;

  ZodiacInfo({
    required this.westernZodiac,
    required this.chineseZodiac,
  });
}
