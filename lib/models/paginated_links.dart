import 'package:equatable/equatable.dart';

class PaginatedLinks extends Equatable {
  final Uri? first;
  final Uri? last;
  final Uri? prev;
  final Uri? next;

  const PaginatedLinks({this.first, this.last, this.prev, this.next});

  factory PaginatedLinks.fromJson(Map<String, dynamic> json) => PaginatedLinks(
        first:
            (json['first'] != null) ? Uri.parse(json['first'] as String) : null,
        last: (json['last'] != null) ? Uri.parse(json['last'] as String) : null,
        prev: (json['prev'] != null) ? Uri.parse(json['prev'] as String) : null,
        next: (json['next'] != null) ? Uri.parse(json['next'] as String) : null,
      );

  Map<String, dynamic> toJson() => {
        'first': first.toString(),
        'last': last.toString(),
        'prev': prev.toString(),
        'next': next.toString(),
      };

  @override
  List<Object?> get props => [first, last, prev, next];
}
