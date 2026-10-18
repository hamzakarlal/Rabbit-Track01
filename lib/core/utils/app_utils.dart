import 'package:intl/intl.dart';

class AppUtils {
  static String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  static String formatDateTime(DateTime date) {
    return DateFormat('dd MMM yyyy, HH:mm').format(date);
  }

  static String formatMonth(DateTime date) {
    return DateFormat('MMM yyyy').format(date);
  }

  static String formatCurrency(double amount) {
    if (amount >= 1000000) {
      return 'PKR ${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return 'PKR ${(amount / 1000).toStringAsFixed(1)}K';
    }
    return 'PKR ${amount.toStringAsFixed(0)}';
  }

  static String formatCurrencyFull(double amount) {
    return NumberFormat.currency(
      symbol: 'PKR ',
      decimalDigits: 0,
    ).format(amount);
  }

  static String formatWeight(double weight) {
    return '${weight.toStringAsFixed(2)} kg';
  }

  static String formatPercentage(double value) {
    return '${value.toStringAsFixed(1)}%';
  }

  static String formatNumber(int value) {
    return NumberFormat.compact().format(value);
  }

  static String ageFromDob(DateTime dob) {
    final now = DateTime.now();
    final diff = now.difference(dob);
    final days = diff.inDays;

    if (days < 30) return '${days}d';
    if (days < 365) return '${(days / 30.44).floor()}mo';

    final years = (days / 365.25).floor();
    final remMonths = ((days - years * 365.25) / 30.44).floor();
    return remMonths > 0 ? '${years}yr ${remMonths}mo' : '${years}yr';
  }

  static String timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    if (diff.inDays < 30) return '${(diff.inDays / 7).floor()}w ago';
    if (diff.inDays < 365) return '${(diff.inDays / 30).floor()}mo ago';
    return '${(diff.inDays / 365).floor()}yr ago';
  }

  static String generateRabbitId(int count) {
    return 'RT-${count.toString().padLeft(4, '0')}';
  }

  static String daysUntil(DateTime date) {
    final diff = date.difference(DateTime.now()).inDays;
    if (diff < 0) return 'Overdue by ${diff.abs()}d';
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Tomorrow';
    return 'In ${diff}d';
  }

  static bool isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(email);
  }

  static bool isValidPhone(String phone) {
    return RegExp(r'^\+?[0-9]{10,15}$').hasMatch(phone);
  }

  static String capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

  static List<DateTime> getLast12Months() {
    final now = DateTime.now();
    return List.generate(
      12,
      (i) => DateTime(now.year, now.month - 11 + i, 1),
    );
  }

  static bool isSameMonth(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month;

  static bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}
