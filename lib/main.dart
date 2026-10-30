import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

void main() {
  runApp(const StudentInfoApp());
}

class StudentInfoApp extends StatelessWidget {
  const StudentInfoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CSS3344 Lab 02',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      home: const StudentProfileScreen(),
    );
  }
}

class StudentProfileScreen extends StatefulWidget {
  const StudentProfileScreen({super.key});

  @override
  State<StudentProfileScreen> createState() =>
      _StudentProfileScreenState();
}

class _StudentProfileScreenState extends State<StudentProfileScreen> {

  DateTime? _selectedDate;

  String _selectedRole = 'Student';

  static const _roles = ['Student', 'Developer', 'Designer', 'Gravedigger', 'Cemeterian'];

  Future<void> _selectMaterialDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (!mounted || picked == null) return;

    setState(() {
      _selectedDate = picked;
    });
  }

  void _showCupertinoDatePicker() {
    final now = DateTime.now();

    showCupertinoModalPopup<void>(
      context: context,
      builder: (sheetContext) => Container(
        height: 280,
        color: CupertinoColors.systemBackground.resolveFrom(sheetContext),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: CupertinoButton(
                  onPressed: () => Navigator.of(sheetContext).pop(),
                  child: const Text('Done'),
                ),
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: _selectedDate ?? now,
                  minimumDate: DateTime(1950),
                  maximumDate: now,
                  onDateTimeChanged: (DateTime newDate) {
                    if (!mounted) return;

                    setState(() {
                      _selectedDate = newDate;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showCupertinoRolePicker() async {
    final controller = FixedExtentScrollController(
      initialItem: _roles.indexOf(_selectedRole),
    );

    try {
      await showCupertinoModalPopup<void>(
        context: context,
        semanticsDismissible: true,
        builder: (sheetContext) => Container(
          height: 240,
          color: CupertinoColors.systemBackground.resolveFrom(sheetContext),
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: CupertinoButton(
                    onPressed: () => Navigator.of(sheetContext).pop(),
                    child: const Text('Done'),
                  ),
                ),
                Expanded(
                  child: CupertinoPicker(
                    scrollController: controller,
                    itemExtent: 32,
                    onSelectedItemChanged: (int index) {
                      if (!mounted) return;

                      setState(() {
                        _selectedRole = _roles[index];
                      });
                    },
                    children: _roles.map((role) {
                      return Center(child: Text(role));
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } finally {
      controller.dispose();
    }
  }

  Widget _buildDatePickerSection() {
    final date = _selectedDate;
    final label = date == null
        ? 'No date chosen yet'
        : 'Selected: ${date.day}/${date.month}/${date.year}';

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: _selectMaterialDate,
            child: const Text('Open Material Date Picker'),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: _showCupertinoDatePicker,
            child: const Text('Open Cupertino Date Picker'),
          ),

          const SizedBox(height: 16),
          Text('Selected role: $_selectedRole'),
          const SizedBox(height: 8),
          DropdownButton<String>(
            value: _selectedRole,
            isExpanded: true,
            items: _roles.map((String role) {
              return DropdownMenuItem<String>(
                value: role,
                child: Text(role),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue == null) return;

              setState(() {
                _selectedRole = newValue;
              });
            },
          ),

          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: _showCupertinoRolePicker,
            child: const Text('Open Cupertino Role Picker'),
          ),

        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CSS3344 Mobile App Dev - Lab 02'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: SafeArea(
        child: OrientationBuilder(
          builder: (context, orientation) {
            return orientation == Orientation.portrait
                ? _buildPortraitView()
                : _buildLandscapeView();
          },
        ),
      ),
    );
  }

  // Upright: stack both sections.
  Widget _buildPortraitView() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const StudentDetailsSection(),
        const TitleSection(
          name: 'Tanah Kubur',
          location: 'Sibu, Sarawak',
          starCount: 999,
        ),
        const ImageSection(imagePath: 'assets/images/graveyard.jpg'),
        _buildDatePickerSection(),
      ],
    );
  }

  // Sideways: put both sections beside each other.
  Widget _buildLandscapeView() {
    return Row(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: const [
              StudentDetailsSection(),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const TitleSection(
                name: 'Tanah Kubur',
                location: 'Sibu, Sarawak',
                starCount: 999,
              ),
              const ImageSection(imagePath: 'assets/images/graveyard.jpg'),
              _buildDatePickerSection(),
            ],
          ),
        ),
      ],
    );
  }
}

class StudentDetailsSection extends StatelessWidget {
  const StudentDetailsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.indigo,
              backgroundImage: AssetImage('assets/images/profile.png'),
            ),
            SizedBox(height: 20),
            Text(
              'ALEEF DANIAL BIN ABDUL RAHMAN',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Student ID: BCS24090018',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            Divider(height: 32, thickness: 1),
            Text(
              'Personal Life Goal / Quote:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '"Build what you love"',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontStyle: FontStyle.italic,
                color: Colors.indigo,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ImageSection extends StatelessWidget {
  final String imagePath;

  const ImageSection({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Image.asset(imagePath, fit: BoxFit.cover),
        ),
      ),
    );
  }
}

class TitleSection extends StatelessWidget {
  final String name;
  final String location;
  final int starCount;

  const TitleSection({
    super.key,
    required this.name,
    required this.location,
    required this.starCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  location,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Icon(Icons.star, color: Colors.red[500]),
          const SizedBox(width: 4),
          Text('$starCount'),
        ],
      ),
    );
  }
}
