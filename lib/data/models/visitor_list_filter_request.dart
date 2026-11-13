import 'package:equatable/equatable.dart';

/// Request body model for `POST /visitor/list`
/// TODO(verify): Confirm search/status/date/paging keys against Swagger.
final class VisitorListFilterRequest extends Equatable {
  const VisitorListFilterRequest({
    this.status,
    this.search,
    this.roomId,
    this.date,
    this.page = 1,
    this.limit = 20,
    this.orderBy,
    this.searchText,
    this.filterDueDate,
    this.dueDate,
    this.dateFrom,
    this.dateTo,
    this.isKiosk,
    this.createdBy,
  });

  /// UI status names are converted to the API's integer enum on serialization.
  final String? status;
  final String? search;
  final String? roomId;
  final String? date;
  final String? orderBy;
  final String? searchText;
  final int? filterDueDate;
  final String? dueDate;
  final String? dateFrom;
  final String? dateTo;
  final bool? isKiosk;
  final int? createdBy;
  final int page;
  final int limit;

  VisitorListFilterRequest copyWith({int? page}) => VisitorListFilterRequest(
        status: status,
        search: search,
        roomId: roomId,
        date: date,
        page: page ?? this.page,
        limit: limit,
        orderBy: orderBy,
        searchText: searchText,
        filterDueDate: filterDueDate,
        dueDate: dueDate,
        dateFrom: dateFrom,
        dateTo: dateTo,
        isKiosk: isKiosk,
        createdBy: createdBy,
      );

  @override
  List<Object?> get props => [
        status,
        search,
        roomId,
        date,
        orderBy,
        searchText,
        filterDueDate,
        dueDate,
        dateFrom,
        dateTo,
        isKiosk,
        createdBy,
        page,
        limit
      ];

  Map<String, dynamic> toJson() => {
        if (status != null)
          'status': status == 'upcoming'
              ? 1
              : (status == 'onSite' || status == 'on_site' ? 2 : 3),
        if (search != null && search!.isNotEmpty) 'search': search,
        if (date != null && date!.isNotEmpty) 'dateFrom': date,
        if (date != null && date!.isNotEmpty) 'dateTo': date,
        if (orderBy != null) 'orderBy': orderBy,
        if (searchText != null) 'searchText': searchText,
        if (filterDueDate != null) 'filterDueDate': filterDueDate,
        if (dueDate != null) 'dueDate': dueDate,
        if (dateFrom != null) 'dateFrom': dateFrom,
        if (dateTo != null) 'dateTo': dateTo,
        if (isKiosk != null) 'isKiosk': isKiosk,
        if (createdBy != null) 'createdBy': createdBy,
        'page': page,
        'rowsPerPage': limit,
      };

  factory VisitorListFilterRequest.fromJson(Map<String, dynamic> json) {
    return VisitorListFilterRequest(
      status: json['status'] is num
          ? (json['status'] == 1
              ? 'upcoming'
              : json['status'] == 2
                  ? 'onSite'
                  : 'checkedOut')
          : json['status'] as String?,
      search: json['search'] as String?,
      roomId: json['roomId'] as String?,
      date: json['date'] as String?,
      orderBy: json['orderBy'] as String?,
      searchText: json['searchText'] as String?,
      filterDueDate: (json['filterDueDate'] as num?)?.toInt(),
      dueDate: json['dueDate'] as String?,
      dateFrom: json['dateFrom'] as String?,
      dateTo: json['dateTo'] as String?,
      isKiosk: json['isKiosk'] as bool?,
      createdBy: (json['createdBy'] as num?)?.toInt(),
      page: (json['page'] as num?)?.toInt() ?? 1,
      limit: (json['rowsPerPage'] as num?)?.toInt() ??
          (json['limit'] as num?)?.toInt() ??
          20,
    );
  }
}
