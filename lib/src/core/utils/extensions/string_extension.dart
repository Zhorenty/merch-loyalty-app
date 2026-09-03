extension StringExtension on String {
  String limit(int length) =>
      length < this.length ? substring(0, length) : this;

  String initials() {
    final words = split(' ').where((e) => e.isNotEmpty).toList();
    if (words.length >= 2) {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    } else if (words.isNotEmpty) {
      if (words[0].length >= 2) {
        return '${words[0][0].toUpperCase()}${words[0][1].toLowerCase()}';
      }
      return words[0].toUpperCase();
    }
    return '';
  }
}
