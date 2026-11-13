import 'package:flutter_test/flutter_test.dart';
import 'package:udaya_visitor/data/data_export.dart';

void main() {
  test('VisitorModel survives a JSON round trip', () {
    final visitor = VisitorModel(
      id: 'V001',
      name: 'Jonathan Simmons',
      startTime: DateTime(2026, 10, 12, 9, 30),
      endTime: DateTime(2026, 10, 12, 11, 30),
      room: 'A',
      purpose: 'Meeting',
    );
    final decoded =
        VisitorModel.decodeList(VisitorModel.encodeList([visitor])).single;
    expect(decoded.name, 'Jonathan Simmons');
    expect(decoded.initials, 'JS');
    expect(decoded.status, VisitorStatus.upcoming);
    expect(decoded.qrData, 'UDAYA-VISITOR:V001');
  });
}
