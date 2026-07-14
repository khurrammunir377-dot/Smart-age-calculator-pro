import 'package:smart_age_calculator_pro/domain/entities/zodiac_info.dart';

class ZodiacCalculator {
  static ZodiacInfo calculate(DateTime date) {
    return ZodiacInfo(
      westernZodiac: _getWesternZodiac(date.month, date.day),
      chineseZodiac: _getChineseZodiac(date.year),
    );
  }

  static WesternZodiac _getWesternZodiac(int month, int day) {
    if (_inRange(month, day, 3, 21, 4, 19)) {
      return WesternZodiac(
        signName: 'Aries',
        symbol: '♈',
        dateRange: 'March 21 - April 19',
        personalitySummary:
            'Courageous, determined, confident, and enthusiastic. Natural-born leaders who are passionate and love a challenge.',
      );
    } else if (_inRange(month, day, 4, 20, 5, 20)) {
      return WesternZodiac(
        signName: 'Taurus',
        symbol: '♉',
        dateRange: 'April 20 - May 20',
        personalitySummary:
            'Reliable, patient, practical, and devoted. Values stability and comfort, with a strong appreciation for the finer things in life.',
      );
    } else if (_inRange(month, day, 5, 21, 6, 20)) {
      return WesternZodiac(
        signName: 'Gemini',
        symbol: '♊',
        dateRange: 'May 21 - June 20',
        personalitySummary:
            'Curious, adaptable, and expressive. A great communicator who loves learning and juggling multiple interests at once.',
      );
    } else if (_inRange(month, day, 6, 21, 7, 22)) {
      return WesternZodiac(
        signName: 'Cancer',
        symbol: '♋',
        dateRange: 'June 21 - July 22',
        personalitySummary:
            'Emotional, intuitive, and deeply loyal. Highly protective of loved ones and guided strongly by feelings and memory.',
      );
    } else if (_inRange(month, day, 7, 23, 8, 22)) {
      return WesternZodiac(
        signName: 'Leo',
        symbol: '♌',
        dateRange: 'July 23 - August 22',
        personalitySummary:
            'Confident, generous, and warm-hearted. A natural performer who loves to be at the center of attention and inspire others.',
      );
    } else if (_inRange(month, day, 8, 23, 9, 22)) {
      return WesternZodiac(
        signName: 'Virgo',
        symbol: '♍',
        dateRange: 'August 23 - September 22',
        personalitySummary:
            'Analytical, hardworking, and detail-oriented. A practical perfectionist who takes pride in helping others.',
      );
    } else if (_inRange(month, day, 9, 23, 10, 22)) {
      return WesternZodiac(
        signName: 'Libra',
        symbol: '♎',
        dateRange: 'September 23 - October 22',
        personalitySummary:
            'Diplomatic, fair-minded, and sociable. Seeks harmony and balance, with a strong sense of justice and appreciation for beauty.',
      );
    } else if (_inRange(month, day, 10, 23, 11, 21)) {
      return WesternZodiac(
        signName: 'Scorpio',
        symbol: '♏',
        dateRange: 'October 23 - November 21',
        personalitySummary:
            'Passionate, resourceful, and intensely loyal. Deeply perceptive with strong willpower and a magnetic presence.',
      );
    } else if (_inRange(month, day, 11, 22, 12, 21)) {
      return WesternZodiac(
        signName: 'Sagittarius',
        symbol: '♐',
        dateRange: 'November 22 - December 21',
        personalitySummary:
            'Adventurous, optimistic, and freedom-loving. An honest philosopher at heart who is always chasing the next big idea.',
      );
    } else if (_inRange(month, day, 12, 22, 1, 19)) {
      return WesternZodiac(
        signName: 'Capricorn',
        symbol: '♑',
        dateRange: 'December 22 - January 19',
        personalitySummary:
            'Disciplined, responsible, and ambitious. Excellent at long-term planning with strong self-control and managerial skill.',
      );
    } else if (_inRange(month, day, 1, 20, 2, 18)) {
      return WesternZodiac(
        signName: 'Aquarius',
        symbol: '♒',
        dateRange: 'January 20 - February 18',
        personalitySummary:
            'Independent, original, and humanitarian. A deep thinker who values intellectual freedom and progressive ideas.',
      );
    } else {
      // Feb 19 - Mar 20
      return WesternZodiac(
        signName: 'Pisces',
        symbol: '♓',
        dateRange: 'February 19 - March 20',
        personalitySummary:
            'Compassionate, artistic, and intuitive. A gentle dreamer with a rich inner world and deep empathy for others.',
      );
    }
  }

  /// Checks whether (month, day) falls within a range that may wrap
  /// across the new year (e.g. Dec 22 - Jan 19 for Capricorn).
  static bool _inRange(
    int month,
    int day,
    int startMonth,
    int startDay,
    int endMonth,
    int endDay,
  ) {
    final current = month * 100 + day;
    final start = startMonth * 100 + startDay;
    final end = endMonth * 100 + endDay;

    if (start <= end) {
      return current >= start && current <= end;
    } else {
      // Range wraps around the year end.
      return current >= start || current <= end;
    }
  }

  static ChineseZodiac _getChineseZodiac(int year) {
    // 1900 was the Year of the Rat in the traditional 12-year cycle.
    final index = (year - 1900) % 12;
    final normalizedIndex = index < 0 ? index + 12 : index;

    const animals = [
      'Rat', 'Ox', 'Tiger', 'Rabbit', 'Dragon', 'Snake',
      'Horse', 'Goat', 'Monkey', 'Rooster', 'Dog', 'Pig',
    ];
    const emojis = [
      '🐀', '🐂', '🐅', '🐇', '🐉', '🐍',
      '🐎', '🐐', '🐒', '🐓', '🐶', '🐷',
    ];
    const characteristics = [
      'Quick-witted, resourceful, and adaptable, with natural charm and a sharp eye for opportunity.',
      'Dependable, strong, and methodical. Values hard work and follows through with quiet determination.',
      'Brave, confident, and competitive, with a strong sense of justice and natural leadership.',
      'Gentle, kind, and sensitive, valued for tact, discretion, and a calm, thoughtful nature.',
      'Powerful, ambitious, and charismatic. A natural-born leader who inspires confidence in others.',
      'Wise, intuitive, and a touch mysterious, with sharp instincts and a calm, calculating mind.',
      'Energetic, independent, and free-spirited, always drawn to adventure and new experiences.',
      'Creative, gentle, and compassionate, with a strong artistic sense and a peacemaking spirit.',
      'Clever, playful, and inventive, with quick wit and a talent for solving problems.',
      'Honest, punctual, and hardworking, with a strong sense of responsibility and observation.',
      'Loyal, honest, and protective of loved ones, guided by a strong sense of fairness.',
      'Generous, warm-hearted, and optimistic, known for enjoying life and caring deeply for others.',
    ];

    return ChineseZodiac(
      animalSign: animals[normalizedIndex],
      emoji: emojis[normalizedIndex],
      birthYear: year,
      characteristics: characteristics[normalizedIndex],
    );
  }
}
