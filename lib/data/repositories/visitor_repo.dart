import 'package:udaya_visitor/data/data_export.dart';
import 'package:udaya_visitor/helper/helper_export.dart';

/// Repository for managing visitors through the company API with local fallback.
final class VisitorRepo {
  VisitorRepo({VisitorRepository? repository})
      : _repository = repository ?? VisitorRepository();

  final VisitorRepository _repository;

  /// Fetch the visitor list from API, with fallback to local cached visitors if server is unreachable.
  Future<List<VisitorModel>> fetchVisitors() async {
    try {
      final remoteList =
          await _repository.getVisitors(const VisitorListFilterRequest());
      if (remoteList.isNotEmpty) {
        await AppPreference.saveVisitors(remoteList);
        return remoteList;
      }
    } catch (_) {}

    return getLocalVisitors();
  }

  /// Create a visitor through the company API with fallback.
  Future<List<VisitorModel>> addVisitor(VisitorModel visitor) async {
    try {
      await _repository.addVisitor(visitor);
      return await fetchVisitors();
    } catch (_) {
      final current = getLocalVisitors();
      final updated = [visitor, ...current];
      await AppPreference.saveVisitors(updated);
      return updated;
    }
  }

  /// Check in a visitor through the company API with fallback.
  Future<List<VisitorModel>> checkIn(String id) async {
    try {
      await _repository.checkIn(id);
      return await fetchVisitors();
    } catch (_) {
      return _updateLocally(
          id,
          (v) => v.copyWith(
              status: VisitorStatus.onSite, checkInAt: DateTime.now()));
    }
  }

  /// Check out a visitor through the company API with fallback.
  Future<List<VisitorModel>> checkOut(String id) async {
    try {
      await _repository.checkOut(id);
      return await fetchVisitors();
    } catch (_) {
      return _updateLocally(
          id,
          (v) => v.copyWith(
              status: VisitorStatus.checkedOut, checkOutAt: DateTime.now()));
    }
  }

  /// Local SharedPreferences cached visitors
  List<VisitorModel> getLocalVisitors() {
    if (!AppPreference.hasVisitors) {
      final seeded = _seed();
      AppPreference.saveVisitors(seeded);
      return seeded;
    }
    return AppPreference.getVisitors;
  }

  Future<List<VisitorModel>> _updateLocally(
      String id, VisitorModel Function(VisitorModel) change) async {
    final updated =
        getLocalVisitors().map((v) => v.id == id ? change(v) : v).toList();
    await AppPreference.saveVisitors(updated);
    return updated;
  }

  List<VisitorModel> _seed() {
    final now = DateTime.now();
    DateTime at(int dayOffset, int hour, int minute) =>
        DateTime(now.year, now.month, now.day + dayOffset, hour, minute);

    return [
      VisitorModel(
        id: '1',
        name: 'Jonathan Simmons',
        startTime: at(0, 9, 30),
        endTime: at(0, 11, 30),
        room: AppRooms.hogf,
        purpose: 'Meeting discussing project timeline',
      ),
      VisitorModel(
        id: '2',
        name: 'Alisha Martinez',
        startTime: at(0, 9, 30),
        endTime: at(0, 11, 30),
        room: AppRooms.hogf,
        purpose: 'Meeting discussing project timeline',
      ),
      VisitorModel(
        id: '3',
        name: 'Dara Sok',
        startTime: at(0, 14, 0),
        endTime: at(0, 15, 30),
        room: AppRooms.homf01,
        purpose: 'Network equipment installation and demo',
      ),
      VisitorModel(
        id: '4',
        name: 'Maly Chea',
        startTime: at(1, 10, 0),
        endTime: at(1, 11, 0),
        room: AppRooms.homf02,
        purpose: 'Interview for software engineer position',
      ),
      VisitorModel(
        id: '5',
        name: 'David Kim',
        startTime: at(1, 15, 0),
        endTime: at(1, 16, 0),
        room: AppRooms.homf01,
        purpose: 'Contract review with the sales team',
      ),
      VisitorModel(
        id: '6',
        name: 'Sophea Lim',
        startTime: at(0, 8, 30),
        endTime: at(0, 9, 30),
        room: AppRooms.hogf,
        purpose: 'Vendor delivery and stock count',
        status: VisitorStatus.onSite,
        checkInAt: at(0, 8, 35),
      ),
      VisitorModel(
        id: '7',
        name: 'Michael Brown',
        startTime: at(-1, 13, 0),
        endTime: at(-1, 14, 0),
        room: AppRooms.homf02,
        purpose: 'Quarterly business review',
        status: VisitorStatus.checkedOut,
        checkInAt: at(-1, 13, 5),
        checkOutAt: at(-1, 13, 55),
      ),
    ];
  }
}
