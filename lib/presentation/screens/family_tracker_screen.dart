import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_age_calculator_pro/domain/entities/family_member.dart';
import 'package:smart_age_calculator_pro/presentation/providers/family_provider.dart';
import 'package:smart_age_calculator_pro/presentation/screens/add_family_member_screen.dart';
import 'package:smart_age_calculator_pro/presentation/widgets/family_member_card.dart';

class FamilyTrackerScreen extends ConsumerWidget {
  const FamilyTrackerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final members = ref.watch(familyMembersProvider);
    final upcoming = ref.watch(upcomingFamilyBirthdaysProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Family Age Tracker')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddFamilyMemberScreen()),
        ),
        child: const Icon(Icons.add),
      ),
      body: members.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'No family members saved yet.\nTap + to add one.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (upcoming.isNotEmpty) ...[
                  const Text(
                    'Upcoming Birthdays (next 30 days)',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...upcoming.map(
                    (m) => FamilyMemberCard(
                      member: m,
                      onTap: () {},
                      onDelete: () => _confirmDelete(context, ref, m),
                    ),
                  ),
                  const Divider(height: 32),
                  const Text(
                    'All Family Members',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                ],
                ...members.map(
                  (m) => FamilyMemberCard(
                    member: m,
                    onTap: () {},
                    onDelete: () => _confirmDelete(context, ref, m),
                  ),
                ),
              ],
            ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, FamilyMember member) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Family Member'),
        content: Text('Are you sure you want to remove ${member.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(familyMembersProvider.notifier).deleteFamilyMember(member.id);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
