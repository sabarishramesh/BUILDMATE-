import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../routes/app_routes.dart';
import '../../services/project_service.dart';
import '../../widgets/common_widgets.dart';

class EditProjectScreen extends StatefulWidget {
  final String projectId;
  const EditProjectScreen({super.key, required this.projectId});

  @override
  State<EditProjectScreen> createState() => _EditProjectScreenState();
}

class _EditProjectScreenState extends State<EditProjectScreen> {
  late final _nameCtrl, _locationCtrl, _clientCtrl, _notesCtrl,
      _areaCtrl, _slabCtrl, _wallCtrl;
  late String _projectType;
  late int _floors;
  late double _floorHeight;


  @override
  void initState() {
    super.initState();
    final p = ProjectService.getActiveProjects()
        .firstWhere((p) => p.id == widget.projectId);
    _nameCtrl     = TextEditingController(text: p.name);
    _locationCtrl = TextEditingController(text: p.location);
    _clientCtrl   = TextEditingController(text: p.clientName);
    _notesCtrl    = TextEditingController(text: p.notes);
    _areaCtrl     = TextEditingController(text: p.builtUpAreaSqft.toStringAsFixed(0));
    _slabCtrl     = TextEditingController(text: p.slabThicknessMm.toStringAsFixed(0));
    _wallCtrl     = TextEditingController(text: p.wallThicknessMm.toStringAsFixed(0));
    _projectType  = p.projectType;
    _floors       = p.numberOfFloors;
    _floorHeight  = p.floorHeightM;
  }

  @override
  void dispose() {
    _nameCtrl.dispose(); _locationCtrl.dispose(); _clientCtrl.dispose();
    _notesCtrl.dispose(); _areaCtrl.dispose(); _slabCtrl.dispose();
    _wallCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {

    final projects = [
      ...ProjectService.getActiveProjects(),
      ...ProjectService.getArchivedProjects(),
    ];
    final p = projects.firstWhere((p) => p.id == widget.projectId);
    p.name             = _nameCtrl.text.trim();
    p.projectType      = _projectType;
    p.location         = _locationCtrl.text.trim();
    p.clientName       = _clientCtrl.text.trim();
    p.notes            = _notesCtrl.text.trim();
    p.builtUpAreaSqft  = double.tryParse(_areaCtrl.text) ?? p.builtUpAreaSqft;
    p.numberOfFloors   = _floors;
    p.floorHeightM     = _floorHeight;
    p.slabThicknessMm  = double.tryParse(_slabCtrl.text) ?? p.slabThicknessMm;
    p.wallThicknessMm  = double.tryParse(_wallCtrl.text) ?? p.wallThicknessMm;
    await ProjectService.saveCalculation(p);
    if (!mounted) return;

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBarWidget(
        title: 'Edit Project',
        actions: [
          TextButton(
            onPressed: _save,
            child: const Text('SAVE',
                style: TextStyle(
                    color: AppColors.primary, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionTitle('GENERAL INFORMATION'),
            AppTextField(label: 'Project Name', hint: '', controller: _nameCtrl),
            const SizedBox(height: 16),
            Text('PROJECT TYPE', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.8, color: AppColors.textMedium)),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              value: _projectType,
              items: ['Residential', 'Commercial', 'Industrial', 'Villa']
                  .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                  .toList(),
              onChanged: (v) => setState(() => _projectType = v ?? _projectType),
              decoration: InputDecoration(
                filled: true, fillColor: AppColors.background,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
              ),
            ),
            const SizedBox(height: 16),
            AppTextField(label: 'Location', hint: '', controller: _locationCtrl),
            const SizedBox(height: 16),
            AppTextField(label: 'Client', hint: '', controller: _clientCtrl),
            const SizedBox(height: 16),
            AppTextField(label: 'Notes', hint: '', controller: _notesCtrl, maxLines: 3),
            const SizedBox(height: 24),
            const SectionTitle('STRUCTURAL DETAILS'),
            AppTextField(label: 'Built-Up Area (sq.ft)', hint: '', controller: _areaCtrl, keyboardType: TextInputType.number),
            const SizedBox(height: 16),
            Text('NUMBER OF FLOORS', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.8, color: AppColors.textMedium)),
            const SizedBox(height: 8),
            Row(
              children: [
                _Btn(Icons.remove, () { if (_floors > 1) setState(() => _floors--); }),
                Container(width: 60, alignment: Alignment.center,
                    child: Text('G + ${_floors - 1}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16))),
                _Btn(Icons.add, () => setState(() => _floors++)),
              ],
            ),
            const SizedBox(height: 16),
            Text('FLOOR HEIGHT  ${_floorHeight.toStringAsFixed(2)} m', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.8, color: AppColors.textMedium)),
            Slider(
              value: _floorHeight,
              min: 2.5, max: 5.0, divisions: 10,
              activeColor: AppColors.primary,
              onChanged: (v) => setState(() => _floorHeight = v),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: AppTextField(label: 'Slab Thickness (mm)', hint: '', controller: _slabCtrl, keyboardType: TextInputType.number)),
                const SizedBox(width: 12),
                Expanded(child: AppTextField(label: 'Wall Thickness (mm)', hint: '', controller: _wallCtrl, keyboardType: TextInputType.number)),
              ],
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () async {
                  final ok = await showDialog<bool>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Delete Project?'),
                      content: const Text('This cannot be undone.'),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                        TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete', style: TextStyle(color: Colors.red))),
                      ],
                    ),
                  );
                  if (ok == true) {
                    await ProjectService.deleteProject(widget.projectId);
                    if (mounted) {
                      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (_) => false);
                    }
                  }
                },
                child: const Text('Delete Project',
                    style: TextStyle(color: AppColors.error, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Btn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _Btn(this.icon, this.onTap);
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 36, height: 36,
          decoration: BoxDecoration(border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, size: 18, color: AppColors.primary),
        ),
      );
}
