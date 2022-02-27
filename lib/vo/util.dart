double toDouble(dynamic v) {
  return double.tryParse((v ?? "0").toString()) ?? 0;
}
