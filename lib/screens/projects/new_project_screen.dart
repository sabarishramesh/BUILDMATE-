import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../routes/app_routes.dart';
import '../../services/project_service.dart';
import '../../widgets/common_widgets.dart';

class NewProjectScreen extends StatefulWidget {
  const NewProjectScreen({super.key});

  @override
  State<NewProjectScreen> createState() => _NewProjectScreenState();
}

class _NewProjectScreenState extends State<NewProjectScreen> {
  int _step = 0;
  final _form1 = GlobalKey<FormState>();
  final _form2 = GlobalKey<FormState>();

  // Step 1 fields
  final _nameCtrl     = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _clientCtrl   = TextEditingController();
  final _notesCtrl    = TextEditingController();
  String _projectType = 'Residential';
  DateTime? _startDate;

  // Step 2 fields
  final _areaCtrl  = TextEditingController(text: '1000');
  int _floors = 1;
  double _floorHeight = 3.0;
  final _slabCtrl  = TextEditingController(text: '150');
  final _wallCtrl  = TextEditingController(text: '230');

  bool _loading = false;

  static const _types = ['Residential', 'Commercial', 'Industrial', 'Villa'];

  @override
  void dispose() {
    _nameCtrl.dispose(); _locationCtrl.dispose(); _clientCtrl.dispose();
    _notesCtrl.dispose(); _areaCtrl.dispose(); _slabCtrl.dispose();
    _wallCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _loading = true);
    final project = await ProjectService.createProject(
      name: _nameCtrl.text.trim(),
      projectType: _projectType,
      location: _locationCtrl.text.trim(),
      clientName: _clientCtrl.text.trim(),
      startDate: _startDate,
      notes: _notesCtrl.text.trim(),
    );
    project.builtUpAreaSqft = double.tryParse(_areaCtrl.text) ?? 0;
    project.numberOfFloors  = _floors;
    project.floorHeightM    = _floorHeight;
    project.slabThicknessMm = double.tryParse(_slabCtrl.text) ?? 150;
    project.wallThicknessMm = double.tryParse(_wallCtrl.text) ?? 230;
    await ProjectService.saveCalculation(project);
    if (!mounted) return;
    setState(() => _loading = false);
    Navigator.pushReplacementNamed(context, AppRoutes.projectDetail,
        arguments: project.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBarWidget(
        title: 'New Project',
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Save Draft',
                style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
      body: Column(
        children: [
          _StepIndicator(current: _step),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: _step == 0
                  ? _buildStep1()
                  : _step == 1
                      ? _buildStep2()
                      : _buildStep3(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: PrimaryButton(
              text: _step < 2 ? 'Continue' : 'Create Project',
              isLoading: _loading,
              onPressed: () {
                if (_step == 0) {
                  if (_form1.currentState!.validate()) setState(() => _step = 1);
                } else if (_step == 1) {
                  if (_form2.currentState!.validate()) setState(() => _step = 2);
                } else {
                  _save();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep1() {
    return Form(
      key: _form1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Project Basics',
              style: AppTextStyles.heading3.copyWith(color: AppColors.primary)),
          const SizedBox(height: 20),
          AppTextField(
            label: 'Project Name',
            hint: 'e.g. Skyline Apartments',
            controller: _nameCtrl,
            validator: (v) => v == null || v.isEmpty ? 'Enter a project name' : null,
          ),
          const SizedBox(height: 16),
          Text('PROJECT TYPE', style: AppTextStyles.label),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            value: _projectType,
            items: _types.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
            onChanged: (v) => setState(() => _projectType = v ?? 'Residential'),
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.background,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
            ),
          ),
          const SizedBox(height: 16),
          AppTextField(label: 'Location/City', hint: 'Enter city name', controller: _locationCtrl),
          const SizedBox(height: 16),
          AppTextField(label: 'Client Name', hint: 'Full name or company', controller: _clientCtrl),
          const SizedBox(height: 16),
          Text('START DATE', style: AppTextStyles.label),
          const SizedBox(height: 6),
          GestureDetector(
            onTap: () async {
              final d = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime(2035),
              );
              if (d != null) setState(() => _startDate = d);
            },
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _startDate == null
                        ? 'Select date'
                        : '${_startDate!.day}/${_startDate!.month}/${_startDate!.year}',
                    style: TextStyle(
                      color: _startDate == null ? AppColors.textLight : AppColors.textDark,
                    ),
                  ),
                  const Icon(Icons.calendar_today_outlined, size: 18, color: AppColors.textLight),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: 'Notes',
            hint: 'Additional project details...',
            controller: _notesCtrl,
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildStep2() {
    return Form(
      key: _form2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Structural Details',
              style: AppTextStyles.heading3.copyWith(color: AppColors.primary)),
          const SizedBox(height: 20),
          AppTextField(
            label: 'Built-Up Area (sq.ft)',
            hint: '1000',
            controller: _areaCtrl,
            keyboardType: TextInputType.number,
            validator: (v) {
              if (v == null || v.isEmpty) return 'Enter area';
              if (double.tryParse(v) == null) return 'Enter a number';
              return null;
            },
          ),
          const SizedBox(height: 16),
          Text('NUMBER OF FLOORS', style: AppTextStyles.label),
          const SizedBox(height: 8),
          Row(
            children: [
              _Counter(
                value: _floors,
                onDecrement: () { if (_floors > 1) setState(() => _floors--); },
                onIncrement: () => setState(() => _floors++),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text('FLOOR HEIGHT  ${_floorHeight.toStringAsFixed(1)} m', style: AppTextStyles.label),
          Slider(
            value: _floorHeight,
            min: 2.5,
            max: 5.0,
            divisions: 10,
            activeColor: AppColors.primary,
            onChanged: (v) => setState(() => _floorHeight = v),
          ),
          const SizedBox(height: 8),
          AppTextField(
            label: 'Slab Thickness (mm)',
            hint: '150',
            controller: _slabCtrl,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: 'Wall Thickness (mm)',
            hint: '230',
            controller: _wallCtrl,
            keyboardType: TextInputType.number,
          ),
        ],
      ),
    );
  }

  Widget _buildStep3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Review & Costs',
            style: AppTextStyles.heading3.copyWith(color: AppColors.primary)),
        const SizedBox(height: 20),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Project Summary', style: AppTextStyles.heading3),
              const Divider(height: 20),
              _Row('Name', _nameCtrl.text),
              _Row('Type', _projectType),
              _Row('Area', '${_areaCtrl.text} sq.ft'),
              _Row('Floors', '$_floors'),
              _Row('Slab', '${_slabCtrl.text} mm'),
              _Row('Wall', '${_wallCtrl.text} mm'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        AppCard(
          child: Row(
            children: [
              const Icon(Icons.info_outline, color: AppColors.info, size: 18),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Costs will be calculated using current material rates. You can edit them in Settings → Material Rates.',
                  style: TextStyle(fontSize: 13, color: AppColors.textMedium),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Row extends StatelessWidget {
  final String label, value;
  const _Row(this.label, this.value);
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTextStyles.subtitle),
            Text(value,
                style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
          ],
        ),
      );
}

class _Counter extends StatelessWidget {
  final int value;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;
  const _Counter({required this.value, required this.onDecrement, required this.onIncrement});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _Btn(icon: Icons.remove, onTap: onDecrement),
        Container(
          width: 60,
          alignment: Alignment.center,
          child: Text('$value',
              style: AppTextStyles.heading3),
        ),
        _Btn(icon: Icons.add, onTap: onIncrement),
      ],
    );
  }
}

class _Btn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _Btn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: AppColors.primary),
        ),
      );
}

class _StepIndicator extends StatelessWidget {
  final int current;
  const _StepIndicator({required this.current});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: List.generate(3, (i) {
          final done = i < current;
          final active = i == current;
          return Expanded(
            child: Row(
              children: [
                _Circle(i + 1, done: done, active: active),
                if (i < 2)
                  Expanded(
                    child: Container(
                      height: 2,
                      color: done ? AppColors.primary : AppColors.border,
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _Circle extends StatelessWidget {
  final int n;
  final bool done, active;
  const _Circle(this.n, {required this.done, required this.active});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: done || active ? AppColors.primary : AppColors.border,
          ),
          child: Center(
            child: done
                ? const Icon(Icons.check, color: Colors.white, size: 16)
                : Text('$n',
                    style: TextStyle(
                      color: active ? Colors.white : AppColors.textMedium,
                      fontWeight: FontWeight.w700,
                    )),
          ),
        ),
      ],
    );
  }
}
