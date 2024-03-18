// ignore_for_file: unnecessary_this

extension StringExtension on String {
  bool containsAll(String other) {
    final words = other.split(' ');

    for (final word in words) {
      if (!this.contains(word)) {
        return false;
      }
    }

    return true;
  }
}
