import 'package:udaya_visitor/data/data_export.dart';
import 'package:udaya_visitor/helper/helper_export.dart';

/// Source of truth for visitors. Stored in SharedPreferences (seeded with demo
/// data on first launch). Swap the bodies for Dio calls to use a real backend.
final class VisitorRepo {
  List<VisitorModel> getVisitors() {
    if (!AppPreference.hasVisitors) {
      final seeded = _seed();
      AppPreference.saveVisitors(seeded);
      return seeded;
    }
    final visitors = AppPreference.getVisitors;
    final updated = visitors.map((v) {
      if (v.room == 'A') return v.copyWith(room: AppRooms.hogf);
      if (v.room == 'B') return v.copyWith(room: AppRooms.homf01);
      if (v.room == 'C') return v.copyWith(room: AppRooms.homf02);
      return v;
    }).toList();
    AppPreference.saveVisitors(updated);
    return updated;
  }

  Future<List<VisitorModel>> checkIn(String id) {
    return _update(id, (v) => v.copyWith(status: VisitorStatus.onSite, checkInAt: DateTime.now()));
  }

  Future<List<VisitorModel>> checkOut(String id) {
    return _update(id, (v) => v.copyWith(status: VisitorStatus.checkedOut, checkOutAt: DateTime.now()));
  }

  Future<List<VisitorModel>> _update(String id, VisitorModel Function(VisitorModel) change) async {
    final updated = getVisitors().map((v) => v.id == id ? change(v) : v).toList();
    await AppPreference.saveVisitors(updated);
    return updated;
  }

  List<VisitorModel> _seed() {
    final now = DateTime.now();
    DateTime at(int dayOffset, int hour, int minute) =>
        DateTime(now.year, now.month, now.day + dayOffset, hour, minute);

    return [
      VisitorModel(
        id: 'V001',
        name: 'Jonathan Simmons',
        startTime: at(0, 9, 30),
        endTime: at(0, 11, 30),
        room: AppRooms.hogf,
        purpose: 'Meeting discussing project timeline',
      ),
      VisitorModel(
        id: 'V002',
        name: 'Alisha Martinez',
        startTime: at(0, 9, 30),
        endTime: at(0, 11, 30),
        room: AppRooms.hogf,
        purpose: 'Meeting discussing project timeline',
      ),
      VisitorModel(
        id: 'V003',
        name: 'Dara Sok',
        startTime: at(0, 14, 0),
        endTime: at(0, 15, 30),
        room: AppRooms.homf01,
        purpose: 'Network equipment installation and demo',
      ),
      VisitorModel(
        id: 'V004',
        name: 'Maly Chea',
        startTime: at(1, 10, 0),
        endTime: at(1, 11, 0),
        room: AppRooms.homf02,
        purpose: 'Interview for software engineer position',
      ),
      VisitorModel(
        id: 'V005',
        name: 'David Kim',
        startTime: at(1, 15, 0),
        endTime: at(1, 16, 0),
        room: AppRooms.homf01,
        purpose: 'Contract review with the sales team',
      ),
      VisitorModel(
        id: 'V006',
        name: 'Sophea Lim',
        startTime: at(0, 8, 30),
        endTime: at(0, 9, 30),
        room: AppRooms.hogf,
        purpose: 'Vendor delivery and stock count',
        status: VisitorStatus.onSite,
        checkInAt: at(0, 8, 35),
      ),
      VisitorModel(
        id: 'V007',
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
