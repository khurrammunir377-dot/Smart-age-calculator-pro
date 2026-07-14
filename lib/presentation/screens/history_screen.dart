import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_age_calculator_pro/domain/entities/history_item.dart';
import 'package:smart_age_calculator_pro/presentation/providers/history_provider.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  final _searchController = TextEditingController();
  bool _favoritesOnly = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final history = ref.watch(historyProvider);
    final filtered = _filter(history);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculation History'),
        actions: [
          IconButton(
            icon: Icon(_favoritesOnly ? Icons.star : Icons.star_border),
            tooltip: 'Show favorites only',
            onPressed: () => setState(() => _favoritesOnly = !_favoritesOnly),
          ),
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            tooltip: 'Clear all history',
            onPressed: history.isEmpty ? null : () => _confirmClearAll(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search by name',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {});
                        },
                      )
                    : null,
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Text(
                      history.isEmpty
                          ? 'No calculations yet.\nCalculate an age from the home screen to see it here.'
                          : 'No matching results.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) => _HistoryTile(item: filtered[index]),
                  ),
          ),
        ],
      ),
    );
  }

  List<HistoryItem> _filter(List<HistoryItem> items) {
    var result = items;
    if (_favoritesOnly) {
      result = result.where((i) => i.isFavorite).toList();
    }
    final query = _searchController.text.trim().toLowerCase();
    if (query.isNotEmpty) {
      result = result
          .where((i) => (i.name ?? 'unknown').toLowerCase().contains(query))
          .toList();
    }
    return result;
  }

  void _confirmClearAll(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear History'),
        content: const Text('This will permanently delete all saved calculations.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(historyProvider.notifier).clearAll();
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }
}

class _HistoryTile extends ConsumerWidget {
  final HistoryItem item;

  const _HistoryTile({required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          child: Text((item.name?.isNotEmpty ?? false) ? item.name![0].toUpperCase() : '?'),
        ),
        title: Text(item.name ?? 'Unnamed'),
        subtitle: Text(
          'DOB: ${item.dob.day}/${item.dob.month}/${item.dob.year}\n${item.summary}',
        ),
        isThreeLine: true,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                item.isFavorite ? Icons.star : Icons.star_border,
                color: item.isFavorite ? Colors.amber : null,
              ),
              onPressed: () => ref.read(historyProvider.notifier).toggleFavorite(item.id),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () => ref.read(historyProvider.notifier).deleteEntry(item.id),
            ),
          ],
        ),
      ),
    );
  }
}
