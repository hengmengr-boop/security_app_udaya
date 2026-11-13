import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udaya_visitor/data/data_export.dart';
import 'package:udaya_visitor/helper/helper_export.dart';
import 'package:udaya_visitor/logic/logic_export.dart';

/// Add visitor form matching the supplied mobile Figma screen.
final class AddVisitorPage extends StatefulWidget {
  const AddVisitorPage({super.key});

  @override
  State<AddVisitorPage> createState() => _AddVisitorPageState();
}

final class _AddVisitorPageState extends State<AddVisitorPage> {
  final _name = TextEditingController();
  final _member = TextEditingController();
  final _phone = TextEditingController();
  final _license = TextEditingController();
  final _purpose = TextEditingController();
  String? _gender;
  String? _selectedRoom;
  DateTime? _date;
  TimeOfDay? _from;
  TimeOfDay? _to;

  @override
  void dispose() {
    _name.dispose();
    _member.dispose();
    _phone.dispose();
    _license.dispose();
    _purpose.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final value = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDate: _date ?? DateTime.now(),
    );
    if (value != null) setState(() => _date = value);
  }

  Future<void> _pickTime({required bool start}) async {
    final value = await showTimePicker(
      context: context,
      initialTime:
          start ? (_from ?? TimeOfDay.now()) : (_to ?? TimeOfDay.now()),
    );
    if (value != null) setState(() => start ? _from = value : _to = value);
  }

  Future<void> _save() async {
    final roomName = _selectedRoom;
    if (_name.text.trim().isEmpty ||
        _gender == null ||
        (int.tryParse(_member.text.trim()) ?? 1) < 1 ||
        roomName == null ||
        _purpose.text.trim().isEmpty ||
        _date == null ||
        _from == null ||
        _to == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please complete all required fields')));
      return;
    }
    final start = DateTime(
        _date!.year, _date!.month, _date!.day, _from!.hour, _from!.minute);
    final end =
        DateTime(_date!.year, _date!.month, _date!.day, _to!.hour, _to!.minute);
    final visitor = VisitorModel(
      id: 'V${DateTime.now().microsecondsSinceEpoch}',
      name: _name.text.trim(),
      startTime: start,
      endTime: end,
      room: roomName,
      purpose: _purpose.text.trim(),
      phone: _phone.text.trim().isNotEmpty ? _phone.text.trim() : null,
      gender: _gender == 'Female' ? 2 : 1,
      member: int.tryParse(_member.text.trim()) ?? 1,
      licensePlate:
          _license.text.trim().isNotEmpty ? _license.text.trim() : null,
    );
    context.read<VisitorActionBloc>().add(AddVisitorActionEvent(visitor));
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text('Add New Visitor',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 26, 22, 32),
          child: Column(children: [
            _section('VISITOR INFORMATION', [
              _field('Visitor Name', _name, required: true),
              _dropdown(),
              _roomDropdown(),
              _field('Member', _member),
              _field('Phone Number', _phone),
              _field('License Plate', _license),
            ]),
            const SizedBox(height: 26),
            _section('VISIT DETAILS', [
              _dateField(),
              Row(children: [
                Expanded(
                    child: _timeField(
                        'Time From', _from, () => _pickTime(start: true))),
                const SizedBox(width: 18),
                Expanded(
                    child: _timeField(
                        'Time To', _to, () => _pickTime(start: false))),
              ]),
              _field('Purpose', _purpose, required: true, maxLines: 4),
            ]),
            const SizedBox(height: 26),
            SizedBox(
                width: double.infinity,
                height: 54,
                child: FilledButton(
                    onPressed: _save,
                    style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8))),
                    child: const Text('Save', style: TextStyle(fontSize: 20)))),
          ]),
        ),
      ),
    );
  }

  Widget _section(String title, List<Widget> children) => Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(22, 24, 22, 22),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: const Color(0xFFD5D6DE))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 18,
                  color: Color(0xFF454652),
                  fontWeight: FontWeight.w500)),
          const SizedBox(height: 22),
          ...children,
        ]),
      );

  Widget _field(String label, TextEditingController controller,
          {bool required = false, int maxLines = 1}) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 18),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _label(label, required),
          const SizedBox(height: 8),
          TextField(
              controller: controller,
              maxLines: maxLines,
              decoration: _decoration()),
        ]),
      );

  Widget _dropdown() => Padding(
        padding: const EdgeInsets.only(bottom: 18),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _label('Gender', true),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
              initialValue: _gender,
              hint: const Text('Select'),
              decoration: _decoration(),
              items: const [
                DropdownMenuItem(value: 'Male', child: Text('Male')),
                DropdownMenuItem(value: 'Female', child: Text('Female'))
              ],
              onChanged: (value) => setState(() => _gender = value)),
        ]),
      );

  Widget _roomDropdown() => Padding(
        padding: const EdgeInsets.only(bottom: 18),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _label('Meeting Room', true),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
              initialValue: _selectedRoom,
              isExpanded: true,
              hint: const Text('Select Meeting Room'),
              decoration: _decoration(),
              items: AppRooms.all
                  .map((r) => DropdownMenuItem(
                        value: r,
                        child: Text(
                          r,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ))
                  .toList(),
              onChanged: (value) => setState(() => _selectedRoom = value)),
        ]),
      );

  Widget _dateField() => Padding(
        padding: const EdgeInsets.only(bottom: 18),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _label('Date', true),
          const SizedBox(height: 8),
          TextField(
              readOnly: true,
              onTap: _pickDate,
              controller: TextEditingController(
                  text: _date == null
                      ? ''
                      : '${_date!.day}/${_date!.month}/${_date!.year}'),
              decoration: _decoration(icon: Icons.calendar_month_outlined)),
        ]),
      );

  Widget _timeField(String label, TimeOfDay? value, VoidCallback onTap) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _label(label, true),
        const SizedBox(height: 8),
        TextField(
            readOnly: true,
            onTap: onTap,
            controller:
                TextEditingController(text: value?.format(context) ?? ''),
            decoration: _decoration(icon: Icons.schedule_outlined)),
      ]);

  Widget _label(String label, bool required) => RichText(
          text: TextSpan(
              text: label,
              style: const TextStyle(fontSize: 16, color: Color(0xFF69758F)),
              children: [
            if (required)
              const TextSpan(text: ' *', style: TextStyle(color: Colors.red))
          ]));

  InputDecoration _decoration({IconData? icon}) => InputDecoration(
      hintText: 'Enter',
      suffixIcon: icon == null
          ? null
          : Icon(icon, size: 29, color: const Color(0xFF69758F)),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFD5D6DE))),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFD5D6DE))),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14));
}
