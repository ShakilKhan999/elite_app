// String formatDateTime(DateTime dateTime) {
//   DateTime now = DateTime.now();
//   Duration difference = now.difference(dateTime);

//   if (difference.inSeconds < 60) {
//     return 'Just now';
//   } else if (difference.inMinutes < 60) {
//     return '${difference.inMinutes} min ago';
//   } else if (difference.inHours < 24) {
//     return '${difference.inHours}h ${difference.inMinutes.remainder(60)}min ago';
//   } else if (difference.inDays == 1 && dateTime.day == now.day - 1) {
//     return 'Yesterday ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
//   } else if (dateTime.year == now.year) {
//     return '${_getMonthName(dateTime.month)} ${dateTime.day}, ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
//   } else {
//     return '${dateTime.day} ${_getMonthName(dateTime.month)} ${dateTime.year}, ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
//   }
// }

// String _getMonthName(int month) {
//   const monthNames = [
//     'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
//     'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
//   ];
//   return monthNames[month - 1];
// }

// String formatDateTime(DateTime dateTime) {
//   DateTime now = DateTime.now();
//   Duration difference = now.difference(dateTime);

//   if (difference.inSeconds < 60) {
//     return 'Just now';
//   } else if (difference.inMinutes < 60) {
//     return '${difference.inMinutes} min ago';
//   } else if (difference.inHours < 24) {
//     return '${difference.inHours}h ${difference.inMinutes.remainder(60)}min ago';
//   } else if (difference.inDays == 1 && dateTime.day == now.day - 1) {
//     return 'Yesterday ${_formatTime(dateTime)}';
//   } else if (dateTime.year == now.year) {
//     return '${_formatDate(dateTime)} ${_formatTime(dateTime)}';
//   } else {
//     return '${_formatDate(dateTime, includeYear: true)} ${_formatTime(dateTime)}';
//   }
// }

// String _formatDate(DateTime dateTime, {bool includeYear = false}) {
//   String month = _getMonthName(dateTime.month);
//   String day = dateTime.day.toString();
//   String year = includeYear ? ' ${dateTime.year}' : '';
//   return '$day $month$year';
// }

// String _formatTime(DateTime dateTime) {
//   return '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
// }

// String _getMonthName(int month) {
//   const monthNames = [
//     'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
//     'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
//   ];
//   return monthNames[month - 1];
// }

String formatDateTime(DateTime dateTime) {
  DateTime now = DateTime.now();
  Duration difference = now.difference(dateTime);
  // Check if the date is today
  if (dateTime.year == now.year &&
      dateTime.month == now.month &&
      dateTime.day == now.day) {
    // if (difference.inSeconds < 60) {
    //   return 'Just now';
    // } else if (difference.inMinutes < 60) {
    //   return '${difference.inMinutes} min';
    // }
    // return 'Today ${_formatTime(dateTime)}';
    return _formatTime(dateTime);
    // return _formatTime(dateTime);
  } else if (dateTime.year == now.year) {
    // Check if the date is in the current year
    return '${_formatDate(dateTime)} ${_formatTime(dateTime)}';
  } else {
    // Date is in a previous year
    return '${_formatDate(dateTime, includeYear: true)} ${_formatTime(dateTime)}';
  }
}

String _formatDate(DateTime dateTime, {bool includeYear = false}) {
  String month = _getMonthName(dateTime.month);
  String day = dateTime.day.toString();
  String year = includeYear ? ' ${dateTime.year}' : '';
  return '$day $month$year';
}

String _formatTime(DateTime dateTime) {
  return '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
}

String _getMonthName(int month) {
  const monthNames = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return monthNames[month - 1];
}
