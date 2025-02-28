import 'dart:typed_data';

class NoteItem {
  final Uint8List nonce;
  final Uint8List encrypted;
  final DateTime date;
  final String title;
  final List<String> tags;

  NoteItem({
    required this.nonce,
    required this.encrypted,
    required this.date,
    required this.title,
    required this.tags,
  });

  Map<String, dynamic> toJson() => {
        'nonce': nonce.toList(),
        'encrypted': encrypted.toList(),
        'date': date.toIso8601String(),
        'title': title,
        'tags': tags,
      };

  static NoteItem fromJson(Map<String, dynamic> json) => NoteItem(
        nonce: Uint8List.fromList(List<int>.from(json['nonce'])),
        encrypted: Uint8List.fromList(List<int>.from(json['encrypted'])),
        date: DateTime.parse(json['date']),
        title: json['title'],
        tags: List<String>.from(json['tags'] ?? []),
      );
}