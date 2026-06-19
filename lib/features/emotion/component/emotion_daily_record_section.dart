// lib/features/emotion/component/emotion_daily_record_section.dart

import 'package:flutter/material.dart';

import '../model/emotion_record.dart';

class EmotionDailyRecordSection extends StatefulWidget {
  final List<EmotionRecord> records;

  const EmotionDailyRecordSection({super.key, required this.records});

  @override
  State<EmotionDailyRecordSection> createState() =>
      _EmotionDailyRecordSectionState();
}

class _EmotionDailyRecordSectionState extends State<EmotionDailyRecordSection> {
  late DateTime _selectedDate;
  late List<EmotionRecord> _records;

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();
    _selectedDate = DateTime(now.year, now.month, now.day);
    _records = [...widget.records];
  }

  List<DateTime> get _dateList {
    final today = DateTime.now();

    return List.generate(7, (index) {
      return DateTime(today.year, today.month, today.day - 3 + index);
    });
  }

  List<EmotionRecord> get _selectedRecords {
    return _records
        .where((record) => _isSameDate(record.date, _selectedDate))
        .toList()
      ..sort((a, b) => a.time.compareTo(b.time));
  }

  bool get _isToday {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return _isSameDate(today, _selectedDate);
  }

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  double get _averageLevel {
    if (_selectedRecords.isEmpty) return 0;

    final total = _selectedRecords.fold<int>(
      0,
      (sum, record) => sum + record.level,
    );

    return total / _selectedRecords.length;
  }

  EmotionRecord? get _mostSelectedEmotion {
    if (_selectedRecords.isEmpty) return null;

    final Map<String, int> countMap = {};

    for (final record in _selectedRecords) {
      countMap[record.emotionName] = (countMap[record.emotionName] ?? 0) + 1;
    }

    final mostEmotionName = countMap.entries
        .reduce((a, b) => a.value >= b.value ? a : b)
        .key;

    return _selectedRecords.firstWhere(
      (record) => record.emotionName == mostEmotionName,
    );
  }

  Future<void> _openRecordDialog({EmotionRecord? record}) async {
    final result = await showDialog<EmotionRecord>(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.55),
      builder: (_) {
        return _EmotionRecordDialog(
          selectedDate: _selectedDate,
          record: record,
        );
      },
    );

    if (result == null) return;

    setState(() {
      if (record == null) {
        _records.add(result);
      } else {
        final index = _records.indexWhere((item) => item.id == record.id);
        if (index != -1) {
          _records[index] = result;
        }
      }
    });
  }

  void _deleteRecord(EmotionRecord record) {
    setState(() {
      _records.removeWhere((item) => item.id == record.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedRecords = _selectedRecords;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '감정 타임라인',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),

        const SizedBox(height: 12),

        _DateSelector(
          dates: _dateList,
          selectedDate: _selectedDate,
          onChanged: (date) {
            setState(() {
              _selectedDate = date;
            });
          },
        ),

        const SizedBox(height: 16),

        // 날짜 선택 시 바로 보이도록 요약 영역을 위로 이동
        _EmotionSummaryCard(
          count: selectedRecords.length,
          averageLevel: _averageLevel,
          mostEmotion: _mostSelectedEmotion,
        ),

        const SizedBox(height: 16),

        if (_isToday)
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () => _openRecordDialog(),
              icon: const Icon(Icons.add),
              label: const Text('오늘 감정 기록하기'),
            ),
          ),

        if (_isToday) const SizedBox(height: 16),

        if (selectedRecords.isEmpty)
          _EmptyRecordCard(isToday: _isToday)
        else
          _EmotionTimeline(
            records: selectedRecords,
            editable: _isToday,
            onEdit: (record) => _openRecordDialog(record: record),
            onDelete: _deleteRecord,
          ),
      ],
    );
  }
}

class _DateSelector extends StatelessWidget {
  final List<DateTime> dates;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onChanged;

  const _DateSelector({
    required this.dates,
    required this.selectedDate,
    required this.onChanged,
  });

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _weekDayText(DateTime date) {
    switch (date.weekday) {
      case DateTime.monday:
        return '월';
      case DateTime.tuesday:
        return '화';
      case DateTime.wednesday:
        return '수';
      case DateTime.thursday:
        return '목';
      case DateTime.friday:
        return '금';
      case DateTime.saturday:
        return '토';
      case DateTime.sunday:
        return '일';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 82,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: dates.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final date = dates[index];
          final selected = _isSameDate(date, selectedDate);

          return GestureDetector(
            onTap: () => onChanged(date),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 64,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: selected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: selected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).dividerColor,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _weekDayText(date),
                    style: TextStyle(
                      color: selected ? Colors.white : Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${date.month}/${date.day}',
                    style: TextStyle(
                      color: selected ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _EmotionSummaryCard extends StatelessWidget {
  final int count;
  final double averageLevel;
  final EmotionRecord? mostEmotion;

  const _EmotionSummaryCard({
    required this.count,
    required this.averageLevel,
    required this.mostEmotion,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Expanded(
              child: _SummaryItem(title: '기록 횟수', value: '$count회'),
            ),
            Expanded(
              child: _SummaryItem(
                title: '평균 단계',
                value: count == 0
                    ? '-'
                    : 'Lv.${averageLevel.toStringAsFixed(1)}',
              ),
            ),
            Expanded(
              child: _SummaryItem(
                title: '많은 감정',
                value: mostEmotion == null
                    ? '-'
                    : '${mostEmotion!.emoji} ${mostEmotion!.emotionName}',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String title;
  final String value;

  const _SummaryItem({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.grey),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

class _EmotionTimeline extends StatelessWidget {
  final List<EmotionRecord> records;
  final bool editable;
  final ValueChanged<EmotionRecord> onEdit;
  final ValueChanged<EmotionRecord> onDelete;

  const _EmotionTimeline({
    required this.records,
    required this.editable,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: List.generate(records.length, (index) {
            final record = records[index];
            final isLast = index == records.length - 1;

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    if (!isLast)
                      Container(
                        width: 2,
                        height: 80,
                        color: Theme.of(context).dividerColor,
                      ),
                  ],
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: isLast ? 0 : 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(record.time),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Text(
                              record.emoji,
                              style: const TextStyle(fontSize: 24),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '${record.emotionName} Lv.${record.level}',
                                style: Theme.of(context).textTheme.titleSmall
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                            ),
                            if (editable) ...[
                              IconButton(
                                onPressed: () => onEdit(record),
                                icon: const Icon(Icons.edit_outlined),
                              ),
                              IconButton(
                                onPressed: () => onDelete(record),
                                icon: const Icon(Icons.delete_outline),
                              ),
                            ],
                          ],
                        ),
                        Text(record.description),
                        if (record.memo != null && record.memo!.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(
                            '"${record.memo}"',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: Colors.grey.shade600),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

class _EmptyRecordCard extends StatelessWidget {
  final bool isToday;

  const _EmptyRecordCard({required this.isToday});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(
              Icons.sentiment_neutral,
              size: 36,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 12),
            Text(isToday ? '오늘의 감정을 기록해봐요' : '선택한 날짜의 감정 기록이 없어요'),
            const SizedBox(height: 4),
            Text(
              isToday ? '지금 느끼는 감정을 남겨보세요.' : '감정 기록이 있는 날짜를 선택해보세요.',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmotionRecordDialog extends StatefulWidget {
  final DateTime selectedDate;
  final EmotionRecord? record;

  const _EmotionRecordDialog({required this.selectedDate, this.record});

  @override
  State<_EmotionRecordDialog> createState() => _EmotionRecordDialogState();
}

class _EmotionRecordDialogState extends State<_EmotionRecordDialog> {
  late String _emotionName;
  late String _emoji;
  late int _level;
  late TextEditingController _memoController;

  final List<Map<String, String>> _emotions = const [
    {'name': '행복', 'emoji': '😊'},
    {'name': '보통', 'emoji': '😐'},
    {'name': '슬픔', 'emoji': '😢'},
    {'name': '화남', 'emoji': '😡'},
    {'name': '불안', 'emoji': '😟'},
  ];

  @override
  void initState() {
    super.initState();

    _emotionName = widget.record?.emotionName ?? '행복';
    _emoji = widget.record?.emoji ?? '😊';
    _level = widget.record?.level ?? 3;
    _memoController = TextEditingController(text: widget.record?.memo ?? '');
  }

  @override
  void dispose() {
    _memoController.dispose();
    super.dispose();
  }

  String get _description {
    switch (_level) {
      case 1:
        return '조금 약하게 느껴져요';
      case 2:
        return '약간 느껴져요';
      case 3:
        return '보통이에요';
      case 4:
        return '많이 느껴져요';
      case 5:
        return '아주 많이 느껴져요';
      default:
        return '보통이에요';
    }
  }

  void _submit() {
    final now = DateTime.now();

    final result = EmotionRecord(
      id: widget.record?.id ?? now.millisecondsSinceEpoch,
      date: widget.selectedDate,
      time:
          widget.record?.time ??
          '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
      emoji: _emoji,
      emotionName: _emotionName,
      level: _level,
      description: _description,
      memo: _memoController.text.trim().isEmpty
          ? null
          : _memoController.text.trim(),
    );

    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.record != null;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isEdit ? '감정 수정하기' : '감정 기록하기',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 20),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _emotions.map((emotion) {
                final selected = emotion['name'] == _emotionName;

                return ChoiceChip(
                  label: Text('${emotion['emoji']} ${emotion['name']}'),
                  selected: selected,
                  onSelected: (_) {
                    setState(() {
                      _emotionName = emotion['name']!;
                      _emoji = emotion['emoji']!;
                    });
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                const Text('감정 단계'),
                Expanded(
                  child: Slider(
                    value: _level.toDouble(),
                    min: 1,
                    max: 5,
                    divisions: 4,
                    label: 'Lv.$_level',
                    onChanged: (value) {
                      setState(() {
                        _level = value.toInt();
                      });
                    },
                  ),
                ),
                Text('Lv.$_level'),
              ],
            ),

            const SizedBox(height: 12),

            TextField(
              controller: _memoController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: '메모를 입력해보세요',
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('취소'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: _submit,
                    child: Text(isEdit ? '수정' : '등록'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
