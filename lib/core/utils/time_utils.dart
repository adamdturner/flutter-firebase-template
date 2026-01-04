import 'package:intl/intl.dart';

// This class contains a list of functions that take a DateTime object as a parameter and return a formatted String for 
// display in the UI. Formats are based on the user's local timezone or the universal time zone (UTC London)
class TimeUtils {
  // Local timezone abbreviation, e.g., 'PST', 'MST', 'UTC+2'
  static final String localTimeZoneName = DateTime.now().timeZoneName;

  // Convert to UTC or Local time
  static DateTime toUtc(DateTime dt) => dt.toUtc();
  static DateTime toLocal(DateTime dt) => dt.toLocal();


  // ─────────────────────────────────────────────────────────────
  // UTC Formats
  // ─────────────────────────────────────────────────────────────

  /// e.g., 'July 28, 2025 UTC'
  static String formatDateOnlyUtc(DateTime dt) => '${DateFormat.yMMMMd().format(toUtc(dt))} UTC';

  /// e.g., '2025-07-28' (ISO date format for UTC)
  static String formatIsoDateUtc(DateTime dt) => DateFormat('yyyy-MM-dd').format(toUtc(dt));

  /// e.g., '7/28/2025 5:50 PM UTC'
  static String formatDateTimeUtcCompact(DateTime dt) => '${DateFormat.yMd().add_jm().format(toUtc(dt))} UTC';

  /// e.g., 'Mon, Jul 28, 2025 at 5:50 PM UTC'
  static String formatFullUtc(DateTime dt) => '${DateFormat('EEE, MMM d, y').format(toUtc(dt))} at ${DateFormat.jm().format(toUtc(dt))} UTC';


  // ─────────────────────────────────────────────────────────────
  // Local Formats
  // ─────────────────────────────────────────────────────────────

  /// e.g., 'July 28, 2025'
  static String formatDateOnlyLocal(DateTime dt) => DateFormat.yMMMMd().format(toLocal(dt));

  /// e.g., '7/28/2025 11:50 AM'
  static String formatDateTimeLocalCompact(DateTime dt) => DateFormat.yMd().add_jm().format(toLocal(dt));

  /// e.g., 'Jul 28, 2025 11:50 AM'
  static String formatMediumLocal(DateTime dt) => '${DateFormat('MMM d, y').format(toLocal(dt))} ${DateFormat.jm().format(toLocal(dt))}';

  /// e.g., 'Mon, Jul 28, 2025 at 11:50 AM [MST]'
  static String formatFullLocal(DateTime dt) => '${DateFormat('EEE, MMM d, y').format(toLocal(dt))} at ${DateFormat.jm().format(toLocal(dt))} $localTimeZoneName';


  // ─────────────────────────────────────────────────────────────
  // Raw ISO Formats (if needed)
  // ─────────────────────────────────────────────────────────────

  /// e.g., '2025-07-28T17:50:00Z'
  static String formatIsoUtc(DateTime dt) => toUtc(dt).toIso8601String();

  /// e.g., '2025-07-28T11:50:00-06:00'
  static String formatIsoLocal(DateTime dt) => toLocal(dt).toIso8601String();
}

