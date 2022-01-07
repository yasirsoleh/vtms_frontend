import 'package:equatable/equatable.dart';

class PaginatedLinks extends Equatable {
  final Uri? first;
  final Uri? last;
  final Uri? prev;
  final Uri? next;

  const PaginatedLinks({this.first, this.last, this.prev, this.next});

  factory PaginatedLinks.fromJson(Map<String, dynamic> json) => PaginatedLinks(
      first: Uri.parse(json['first'].toString()),
      last: Uri.parse(json['last'].toString()),
      prev: Uri.parse(json['prev'].toString()),
      next: Uri.parse(json['next'].toString()));

  Map<String, dynamic> toJson() => {
        'first': first.toString(),
        'last': last.toString(),
        'prev': prev.toString(),
        'next': next.toString(),
      };

  @override
  List<Object?> get props => [first, last, prev, next];
}
