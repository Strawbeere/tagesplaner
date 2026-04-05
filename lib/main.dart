import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'dart:math';

void main() {
  initializeDateFormatting('de_DE', null).then((_) {
    runApp(const TagesplanerApp());
  });
}

// --- Farben ---
class AppColors {
  static const primary = Color(0xFF1E40AF);
  static const primaryLight = Color(0xFF3B82F6);
  static const background = Color(0xFFF8FAFC);
  static const surface = Colors.white;
  static const textPrimary = Color(0xFF1E293B);
  static const textSecondary = Color(0xFF64748B);
  static const statusDone = Color(0xFF1E40AF);
  static const statusPartial = Color(0xFF3B82F6);
  static const statusMoved = Color(0xFF93C5FD);
  static const statusBlocked = Color(0xFF94A3B8);
  static const statusPlanned = Color(0xFFCBD5E1);
  static const statusFail = Color(0xFFDC2626);
}

// --- Status ---
enum TaskStatus {
  geplant('Geplant', AppColors.statusPlanned),
  erledigt('Erledigt', AppColors.statusDone),
  teilweise('Teilweise erledigt', AppColors.statusPartial),
  verschoben('Verschoben', AppColors.statusMoved),
  nichtErledigt('Nicht erledigt', AppColors.statusFail),
  fremdverschoben('Fremdverschoben', AppColors.statusBlocked);

  final String label;
  final Color color;
  const TaskStatus(this.label, this.color);
}

// --- Aufgabe ---
class Task {
  String title;
  String? description;
  int startHour;
  int startMinute;
  int endHour;
  int endMinute;
  TaskStatus status;

  Task({
    required this.title,
    this.description,
    required this.startHour,
    this.startMinute = 0,
    int? endHour,
    this.endMinute = 0,
    this.status = TaskStatus.geplant,
  }) : endHour = endHour ?? (startHour + 1).clamp(0, 23);

  int get durationSlots {
    final startSlots = startHour * 2 + (startMinute >= 30 ? 1 : 0);
    final endSlots = endHour * 2 + (endMinute >= 30 ? 1 : 0);
    return (endSlots - startSlots).clamp(1, 48);
  }

  String get timeString {
    final start = '${startHour.toString().padLeft(2, '0')}:${startMinute.toString().padLeft(2, '0')}';
    final end = '${endHour.toString().padLeft(2, '0')}:${endMinute.toString().padLeft(2, '0')}';
    return '$start - $end';
  }
}

// --- Tagesbewertung ---
class DayReflection {
  String note;
  int motivation;
  int mood;
  String? whatWentWell;
  String? whatDidntWork;
  String? tomorrowBetter;

  DayReflection({
    this.note = '',
    this.motivation = 5,
    this.mood = 5,
    this.whatWentWell,
    this.whatDidntWork,
    this.tomorrowBetter,
  });
}

// --- App ---
class TagesplanerApp extends StatelessWidget {
  const TagesplanerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tagesplaner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.surface,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
        ),
      ),
      home: const MainScreen(),
    );
  }
}

// --- Hauptbildschirm mit Navigation ---
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const TagPage(),
    const WochePage(),
    const MonatPage(),
    const MehrPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) {
            setState(() => _currentIndex = index);
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          indicatorColor: AppColors.primary.withValues(alpha: 0.1),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.today_outlined),
              selectedIcon: Icon(Icons.today, color: AppColors.primary),
              label: 'Tag',
            ),
            NavigationDestination(
              icon: Icon(Icons.view_week_outlined),
              selectedIcon: Icon(Icons.view_week, color: AppColors.primary),
              label: 'Woche',
            ),
            NavigationDestination(
              icon: Icon(Icons.calendar_month_outlined),
              selectedIcon: Icon(Icons.calendar_month, color: AppColors.primary),
              label: 'Monat',
            ),
            NavigationDestination(
              icon: Icon(Icons.more_horiz_outlined),
              selectedIcon: Icon(Icons.more_horiz, color: AppColors.primary),
              label: 'Mehr',
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// TAG-SEITE mit Zeitachse
// ============================================================
class TagPage extends StatefulWidget {
  const TagPage({super.key});

  @override
  State<TagPage> createState() => _TagPageState();
}

class _TagPageState extends State<TagPage> {
  static const double _hourHeight = 60.0;
  static const int _startHour = 6;
  static const int _endHour = 23;

  DateTime _selectedDate = DateTime.now();
  final ScrollController _scrollController = ScrollController();

  final List<Task> _tasks = [
    Task(title: 'Aufstehen', startHour: 7, endHour: 7, endMinute: 30, status: TaskStatus.erledigt),
    Task(title: 'Lernen', startHour: 8, endHour: 10, status: TaskStatus.teilweise),
    Task(title: 'Sport', startHour: 10, startMinute: 30, endHour: 11, endMinute: 30, status: TaskStatus.geplant),
    Task(title: 'Mittagessen', startHour: 12, endHour: 13, status: TaskStatus.geplant),
    Task(title: 'Arzttermin', startHour: 14, endHour: 15, status: TaskStatus.geplant),
    Task(title: 'Haushalt', startHour: 16, endHour: 17, status: TaskStatus.geplant),
  ];

  DayReflection _reflection = DayReflection();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _wellController = TextEditingController();
  final TextEditingController _didntWorkController = TextEditingController();
  final TextEditingController _betterController = TextEditingController();
  bool _showGuideQuestions = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Scrolle zur aktuellen Stunde
      final now = DateTime.now();
      final offset = ((now.hour - _startHour) * _hourHeight).clamp(0.0, double.infinity);
      _scrollController.jumpTo(offset);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _noteController.dispose();
    _wellController.dispose();
    _didntWorkController.dispose();
    _betterController.dispose();
    super.dispose();
  }

  void _previousDay() {
    _autoMarkUnfinished();
    setState(() {
      _selectedDate = _selectedDate.subtract(const Duration(days: 1));
    });
  }

  void _nextDay() {
    _autoMarkUnfinished();
    setState(() {
      _selectedDate = _selectedDate.add(const Duration(days: 1));
    });
  }

  // Beim Tageswechsel: geplante Aufgaben automatisch als nicht erledigt markieren
  void _autoMarkUnfinished() {
    final now = DateTime.now();
    final isViewingPast = _selectedDate.isBefore(DateTime(now.year, now.month, now.day));
    if (isViewingPast) {
      setState(() {
        for (final task in _tasks) {
          if (task.status == TaskStatus.geplant) {
            task.status = TaskStatus.nichtErledigt;
          }
        }
      });
    }
  }

  // Status-Menü anzeigen
  void _showStatusMenu(Task task) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 36, height: 4,
                  decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
                ),
                const SizedBox(height: 12),
                Text(task.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                const SizedBox(height: 8),
                ListTile(
                  leading: Icon(Icons.check_circle, color: AppColors.statusDone),
                  title: const Text('Erledigt'),
                  trailing: task.status == TaskStatus.erledigt ? const Icon(Icons.check, color: AppColors.primary) : null,
                  onTap: () {
                    setState(() => task.status = task.status == TaskStatus.erledigt ? TaskStatus.geplant : TaskStatus.erledigt);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.radio_button_checked, color: AppColors.statusPartial),
                  title: const Text('Teilweise erledigt'),
                  trailing: task.status == TaskStatus.teilweise ? const Icon(Icons.check, color: AppColors.primary) : null,
                  onTap: () {
                    setState(() => task.status = task.status == TaskStatus.teilweise ? TaskStatus.geplant : TaskStatus.teilweise);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.radio_button_unchecked, color: AppColors.statusPlanned),
                  title: const Text('Geplant'),
                  trailing: task.status == TaskStatus.geplant ? const Icon(Icons.check, color: AppColors.primary) : null,
                  onTap: () {
                    setState(() => task.status = TaskStatus.geplant);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Tap auf leeren Zeitslot: Aufgabe hinzufuegen
  void _addTaskAtHour(int hour) {
    _showTaskEditor(null, null, prefillHour: hour);
  }

  void _editTask(Task task, int index) {
    _showTaskEditor(task, index);
  }

  void _deleteTask(int index) {
    final deletedTask = _tasks[index];
    final deletedIndex = index;
    setState(() => _tasks.removeAt(index));
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('"${deletedTask.title}" geloescht'),
        action: SnackBarAction(
          label: 'Rueckgaengig',
          textColor: Colors.white,
          onPressed: () {
            setState(() {
              _tasks.insert(deletedIndex.clamp(0, _tasks.length), deletedTask);
            });
          },
        ),
        duration: const Duration(seconds: 4),
        backgroundColor: AppColors.textPrimary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showTaskEditor(Task? existing, int? index, {int? prefillHour}) {
    final titleController = TextEditingController(text: existing?.title ?? '');
    final descController = TextEditingController(text: existing?.description ?? '');
    int startHour = existing?.startHour ?? prefillHour ?? 8;
    int startMinute = existing?.startMinute ?? 0;
    int endHour = existing?.endHour ?? ((prefillHour ?? 8) + 1).clamp(0, 23);
    int endMinute = existing?.endMinute ?? 0;
    final isEditing = existing != null;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20, right: 20, top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isEditing ? 'Aufgabe bearbeiten' : 'Neue Aufgabe',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: titleController,
                    autofocus: !isEditing,
                    decoration: InputDecoration(
                      hintText: 'Was steht an?',
                      filled: true,
                      fillColor: AppColors.background,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: descController,
                    decoration: InputDecoration(
                      hintText: 'Beschreibung (optional)',
                      filled: true,
                      fillColor: AppColors.background,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTimePickerButton(
                          context,
                          label: 'Von',
                          hour: startHour,
                          minute: startMinute,
                          onPicked: (h, m) => setModalState(() { startHour = h; startMinute = m; }),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Icon(Icons.arrow_forward, size: 16, color: AppColors.textSecondary),
                      ),
                      Expanded(
                        child: _buildTimePickerButton(
                          context,
                          label: 'Bis',
                          hour: endHour,
                          minute: endMinute,
                          onPicked: (h, m) => setModalState(() { endHour = h; endMinute = m; }),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      if (isEditing)
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _deleteTask(index!);
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.statusFail,
                              side: const BorderSide(color: AppColors.statusFail),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text('Loeschen'),
                          ),
                        ),
                      if (isEditing) const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (titleController.text.isNotEmpty) {
                              setState(() {
                                if (isEditing) {
                                  _tasks[index!].title = titleController.text;
                                  _tasks[index].description = descController.text.isEmpty ? null : descController.text;
                                  _tasks[index].startHour = startHour;
                                  _tasks[index].startMinute = startMinute;
                                  _tasks[index].endHour = endHour;
                                  _tasks[index].endMinute = endMinute;
                                } else {
                                  _tasks.add(Task(
                                    title: titleController.text,
                                    description: descController.text.isEmpty ? null : descController.text,
                                    startHour: startHour,
                                    startMinute: startMinute,
                                    endHour: endHour,
                                    endMinute: endMinute,
                                  ));
                                }
                              });
                              Navigator.pop(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text(isEditing ? 'Speichern' : 'Hinzufuegen', style: const TextStyle(fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTimePickerButton(
    BuildContext context, {
    required String label,
    required int hour,
    required int minute,
    required void Function(int hour, int minute) onPicked,
  }) {
    return GestureDetector(
      onTap: () async {
        final picked = await showTimePicker(
          context: context,
          initialTime: TimeOfDay(hour: hour, minute: minute),
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
              child: child!,
            );
          },
        );
        if (picked != null) onPicked(picked.hour, picked.minute);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.access_time, size: 18, color: AppColors.textSecondary),
            const SizedBox(width: 8),
            Text(
              '$label: ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}',
              style: const TextStyle(color: AppColors.textPrimary),
            ),
          ],
        ),
      ),
    );
  }

  // Statistik
  int get _doneCount => _tasks.where((t) => t.status == TaskStatus.erledigt).length;
  int get _partialCount => _tasks.where((t) => t.status == TaskStatus.teilweise).length;
  int get _failCount => _tasks.where((t) => t.status == TaskStatus.nichtErledigt).length;
  int get _movedCount => _tasks.where((t) => t.status == TaskStatus.verschoben).length;
  int get _blockedCount => _tasks.where((t) => t.status == TaskStatus.fremdverschoben).length;
  int get _plannedCount => _tasks.where((t) => t.status == TaskStatus.geplant).length;

  double get _completionRate {
    if (_tasks.isEmpty) return 0;
    final countable = _tasks.where((t) =>
        t.status != TaskStatus.verschoben &&
        t.status != TaskStatus.fremdverschoben &&
        t.status != TaskStatus.geplant).length;
    if (countable == 0) return 0;
    final done = _doneCount + (_partialCount * 0.5);
    return done / countable;
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('EEEE, d. MMMM', 'de_DE');
    final isToday = DateUtils.isSameDay(_selectedDate, DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tagesplaner', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: const Icon(Icons.menu), onPressed: () => _showHamburgerMenu(context)),
        ],
      ),
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity != null) {
            if (details.primaryVelocity! > 300) _previousDay();
            else if (details.primaryVelocity! < -300) _nextDay();
          }
        },
        child: Column(
          children: [
            // Datum-Navigation
            Container(
              color: AppColors.surface,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(icon: const Icon(Icons.chevron_left), onPressed: _previousDay),
                  GestureDetector(
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );
                      if (date != null) setState(() => _selectedDate = date);
                    },
                    child: Column(
                      children: [
                        Text(
                          isToday ? 'Heute' : dateFormat.format(_selectedDate),
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                        ),
                        if (isToday)
                          Text(dateFormat.format(_selectedDate),
                              style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                  IconButton(icon: const Icon(Icons.chevron_right), onPressed: _nextDay),
                ],
              ),
            ),

            // Zeitachse + Statistik + Reflexion
            Expanded(
              child: ListView(
                controller: _scrollController,
                padding: const EdgeInsets.only(bottom: 100),
                children: [
                  // Zeitachse
                  _buildTimeline(),

                  const SizedBox(height: 24),

                  // Tagesstatistik
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionHeader('Tagesstatistik'),
                        const SizedBox(height: 12),
                        _buildStatsSection(),
                        const SizedBox(height: 24),
                        _buildSectionHeader('Reflexion'),
                        const SizedBox(height: 12),
                        _buildReflectionSection(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTaskEditor(null, null),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  // --- Zeitachse ---
  Widget _buildTimeline() {
    final totalHours = _endHour - _startHour + 1;

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
      child: SizedBox(
        height: totalHours * _hourHeight,
        child: Stack(
          children: [
            // Stundenlinien + Labels (DragTarget mit 30-Min-Raster)
            for (int h = _startHour; h <= _endHour; h++)
              for (int half = 0; half < 2; half++)
                Positioned(
                  top: (h - _startHour) * _hourHeight + half * (_hourHeight / 2),
                  left: 0,
                  right: 0,
                  child: DragTarget<int>(
                    onAcceptWithDetails: (details) {
                      final taskIndex = details.data;
                      final task = _tasks[taskIndex];
                      final duration = (task.endHour + task.endMinute / 60.0) - (task.startHour + task.startMinute / 60.0);
                      setState(() {
                        task.startHour = h;
                        task.startMinute = half * 30;
                        final endTotal = h + half * 0.5 + duration;
                        task.endHour = endTotal.floor().clamp(0, 23);
                        task.endMinute = ((endTotal - endTotal.floor()) * 60).round();
                      });
                    },
                    builder: (context, candidateData, rejectedData) {
                      final isFullHour = half == 0;
                      return GestureDetector(
                        onTap: () => _addTaskAtHour(h),
                        child: SizedBox(
                          height: _hourHeight / 2,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 45,
                                child: isFullHour
                                    ? Text(
                                        '${h.toString().padLeft(2, '0')}:00',
                                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                      )
                                    : null,
                              ),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: isFullHour
                                        ? const Border(top: BorderSide(color: Color(0xFFE2E8F0), width: 0.5))
                                        : const Border(top: BorderSide(color: Color(0xFFF1F5F9), width: 0.5)),
                                    color: candidateData.isNotEmpty ? AppColors.primary.withValues(alpha: 0.1) : null,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

            // Aktuelle Zeit-Linie (nur heute)
            if (DateUtils.isSameDay(_selectedDate, DateTime.now()))
              _buildNowIndicator(),

            // Aufgaben als Bloecke
            ..._tasks.asMap().entries.map((entry) {
              return _buildTaskBlock(entry.value, entry.key);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildNowIndicator() {
    final now = DateTime.now();
    final top = (now.hour - _startHour + now.minute / 60.0) * _hourHeight;
    if (top < 0) return const SizedBox.shrink();

    return Positioned(
      top: top,
      left: 40,
      right: 0,
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(color: AppColors.statusFail, shape: BoxShape.circle),
          ),
          Expanded(child: Container(height: 1.5, color: AppColors.statusFail)),
        ],
      ),
    );
  }

  Widget _buildTaskBlock(Task task, int index) {
    final top = (task.startHour - _startHour + task.startMinute / 60.0) * _hourHeight;
    final duration = ((task.endHour + task.endMinute / 60.0) - (task.startHour + task.startMinute / 60.0));
    final height = (duration * _hourHeight).clamp(30.0, double.infinity);

    // Status-Icon
    IconData statusIcon;
    switch (task.status) {
      case TaskStatus.erledigt:
        statusIcon = Icons.check_circle;
        break;
      case TaskStatus.teilweise:
        statusIcon = Icons.radio_button_checked;
        break;
      default:
        statusIcon = Icons.radio_button_unchecked;
    }

    Widget buildTaskContent({double? fixedHeight}) {
      return SizedBox(
        height: fixedHeight,
        child: Container(
        margin: const EdgeInsets.symmetric(vertical: 1),
        decoration: BoxDecoration(
          color: task.status == TaskStatus.erledigt
              ? AppColors.statusDone.withValues(alpha: 0.1)
              : task.status == TaskStatus.teilweise
                  ? AppColors.statusPartial.withValues(alpha: 0.1)
                  : AppColors.primary.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(8),
          border: Border(
            left: BorderSide(color: task.status.color, width: 3),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    task.title,
                    style: TextStyle(
                      fontSize: height < 40 ? 12 : 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                      decoration: task.status == TaskStatus.erledigt ? TextDecoration.lineThrough : null,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  if (height > 50 && task.description != null && task.description!.isNotEmpty)
                    Text(
                      task.description!,
                      style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                ],
              ),
            ),
            Text(
              task.timeString,
              style: TextStyle(fontSize: height < 40 ? 10 : 11, color: AppColors.textSecondary),
            ),
            const SizedBox(width: 6),
            Icon(statusIcon, size: height < 40 ? 20 : 24, color: task.status.color),
          ],
        ),
      ),
      );
    }

    return Positioned(
      top: top,
      left: 50,
      right: 4,
      height: height,
      child: Draggable<int>(
        data: index,
        axis: Axis.vertical,
        feedback: Material(
          color: Colors.transparent,
          child: SizedBox(
            width: MediaQuery.of(context).size.width - 70,
            child: Opacity(opacity: 0.8, child: buildTaskContent(fixedHeight: height)),
          ),
        ),
        childWhenDragging: Opacity(opacity: 0.3, child: buildTaskContent(fixedHeight: height)),
        child: Dismissible(
          key: ValueKey('task_${task.title}_${task.startHour}_$index'),
          direction: DismissDirection.endToStart,
          onDismissed: (_) => _deleteTask(index),
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: AppColors.statusFail.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.delete_outline, color: AppColors.statusFail),
          ),
          child: GestureDetector(
            onTap: () => _showStatusMenu(task),
            onLongPress: () => _editTask(task, index),
            child: buildTaskContent(fixedHeight: height),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
    );
  }

  // --- Statistik ---
  Widget _buildStatsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 100, height: 100,
                child: CustomPaint(
                  painter: DonutPainter(completionRate: _completionRate, color: AppColors.primary),
                  child: Center(
                    child: Text(
                      '${(_completionRate * 100).round()}%',
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('$_doneCount von ${_tasks.length} erledigt',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                    const SizedBox(height: 4),
                    const Text('Erfuellungsquote', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildStatusBar('Erledigt', _doneCount, AppColors.statusDone),
          const SizedBox(height: 8),
          _buildStatusBar('Teilweise', _partialCount, AppColors.statusPartial),
          const SizedBox(height: 8),
          _buildStatusBar('Geplant', _plannedCount, AppColors.statusPlanned),
          const SizedBox(height: 8),
          _buildStatusBar('Verschoben', _movedCount, AppColors.statusMoved),
          const SizedBox(height: 8),
          _buildStatusBar('Nicht erledigt', _failCount, AppColors.statusFail),
          const SizedBox(height: 8),
          _buildStatusBar('Fremdversch.', _blockedCount, AppColors.statusBlocked),
        ],
      ),
    );
  }

  Widget _buildStatusBar(String label, int count, Color color) {
    final maxCount = _tasks.length;
    final ratio = maxCount > 0 ? count / maxCount : 0.0;
    return Row(
      children: [
        SizedBox(width: 100, child: Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary))),
        Expanded(
          child: Container(
            height: 8,
            decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(4)),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: ratio,
              child: Container(decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4))),
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(width: 20, child: Text('$count', textAlign: TextAlign.right, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary))),
      ],
    );
  }

  // --- Reflexion ---
  Widget _buildReflectionSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Tagesnotiz', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          const SizedBox(height: 8),
          TextField(
            controller: _noteController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Wie war dein Tag?',
              hintStyle: const TextStyle(color: AppColors.textSecondary),
              filled: true, fillColor: AppColors.background,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
            onChanged: (value) => _reflection.note = value,
          ),
          const SizedBox(height: 20),
          _buildSlider(label: 'Motivation', value: _reflection.motivation, icon: Icons.bolt,
              onChanged: (v) => setState(() => _reflection.motivation = v.round())),
          const SizedBox(height: 16),
          _buildSlider(label: 'Gefuehlslage', value: _reflection.mood, icon: Icons.favorite_border,
              onChanged: (v) => setState(() => _reflection.mood = v.round())),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => setState(() => _showGuideQuestions = !_showGuideQuestions),
            child: Row(
              children: [
                Icon(_showGuideQuestions ? Icons.expand_less : Icons.expand_more, color: AppColors.primaryLight),
                const SizedBox(width: 8),
                const Text('Leitfragen', style: TextStyle(color: AppColors.primaryLight, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          if (_showGuideQuestions) ...[
            const SizedBox(height: 12),
            _buildGuideQuestion('Was lief heute gut?', _wellController, (v) => _reflection.whatWentWell = v),
            const SizedBox(height: 10),
            _buildGuideQuestion('Was lief nicht so gut?', _didntWorkController, (v) => _reflection.whatDidntWork = v),
            const SizedBox(height: 10),
            _buildGuideQuestion('Was moechte ich morgen besser machen?', _betterController, (v) => _reflection.tomorrowBetter = v),
          ],
        ],
      ),
    );
  }

  Widget _buildSlider({required String label, required int value, required IconData icon, required ValueChanged<double> onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: AppColors.primaryLight),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
              child: Text('$value / 10', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primary)),
            ),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: AppColors.primary,
            inactiveTrackColor: AppColors.statusPlanned,
            thumbColor: AppColors.primary,
            overlayColor: AppColors.primary.withValues(alpha: 0.1),
          ),
          child: Slider(value: value.toDouble(), min: 1, max: 10, divisions: 9, onChanged: onChanged),
        ),
      ],
    );
  }

  Widget _buildGuideQuestion(String question, TextEditingController controller, ValueChanged<String> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(question, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: 2,
          decoration: InputDecoration(
            hintText: 'Deine Antwort...',
            hintStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
            filled: true, fillColor: AppColors.background,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }
}

// --- Donut-Painter ---
class DonutPainter extends CustomPainter {
  final double completionRate;
  final Color color;
  DonutPainter({required this.completionRate, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;
    const strokeWidth = 10.0;
    final bgPaint = Paint()..color = AppColors.background..style = PaintingStyle.stroke..strokeWidth = strokeWidth..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, bgPaint);
    final fgPaint = Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = strokeWidth..strokeCap = StrokeCap.round;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2, 2 * pi * completionRate, false, fgPaint);
  }

  @override
  bool shouldRepaint(covariant DonutPainter oldDelegate) => oldDelegate.completionRate != completionRate;
}

// --- Hamburger-Menue ---
void _showHamburgerMenu(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(leading: const Icon(Icons.person_outline, color: AppColors.primary), title: const Text('Profil'), onTap: () => Navigator.pop(context)),
            ListTile(leading: const Icon(Icons.settings_outlined, color: AppColors.primary), title: const Text('Einstellungen'), onTap: () => Navigator.pop(context)),
            ListTile(leading: const Icon(Icons.help_outline, color: AppColors.primary), title: const Text('Hilfe'), onTap: () => Navigator.pop(context)),
          ],
        ),
      );
    },
  );
}

// ============================================================
// WOCHE-SEITE
// ============================================================
class WochePage extends StatelessWidget {
  const WochePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Woche', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [IconButton(icon: const Icon(Icons.menu), onPressed: () => _showHamburgerMenu(context))]),
      body: const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.view_week, size: 64, color: AppColors.statusPlanned), SizedBox(height: 16),
        Text('Wochenansicht', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        SizedBox(height: 8), Text('Kommt als naechstes', style: TextStyle(color: AppColors.textSecondary)),
      ])),
    );
  }
}

// ============================================================
// MONAT-SEITE
// ============================================================
class MonatPage extends StatelessWidget {
  const MonatPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Monat', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [IconButton(icon: const Icon(Icons.menu), onPressed: () => _showHamburgerMenu(context))]),
      body: const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.calendar_month, size: 64, color: AppColors.statusPlanned), SizedBox(height: 16),
        Text('Monatsansicht', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        SizedBox(height: 8), Text('Kommt als naechstes', style: TextStyle(color: AppColors.textSecondary)),
      ])),
    );
  }
}

// ============================================================
// MEHR-SEITE
// ============================================================
class MehrPage extends StatelessWidget {
  const MehrPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mehr', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [IconButton(icon: const Icon(Icons.menu), onPressed: () => _showHamburgerMenu(context))]),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        _buildMehrCard(Icons.category_outlined, 'Kategorien', 'Erfuellungsquote pro Kategorie'),
        _buildMehrCard(Icons.lightbulb_outline, 'Aktivitaetsvorschlaege', 'Was du als naechstes machen koenntest'),
        _buildMehrCard(Icons.flag_outlined, 'Ziele & Gewohnheiten', 'Deine aktiven Ziele und Fortschritt'),
        _buildMehrCard(Icons.local_fire_department_outlined, 'Streak', 'Deine Planungsserie'),
        _buildMehrCard(Icons.bar_chart_outlined, 'Gesamtstatistik', 'Langfristige Trends und Entwicklung'),
        _buildMehrCard(Icons.timer_outlined, 'Pomodoro', 'Fokuszeit-Uebersicht'),
      ]),
    );
  }

  Widget _buildMehrCard(IconData icon, String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.surface, borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: AppColors.primary),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        subtitle: Text(subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
        trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
      ),
    );
  }
}
