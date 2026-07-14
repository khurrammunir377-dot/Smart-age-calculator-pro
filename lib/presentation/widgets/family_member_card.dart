import 'dart:io';
import 'package:flutter/material.dart';
import 'package:smart_age_calculator_pro/domain/entities/family_member.dart';

class FamilyMemberCard extends StatelessWidget {
  final FamilyMember member;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const FamilyMemberCard({
    super.key,
    required this.member,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final daysUntil = member.daysUntilNextBirthday();
    final isToday = daysUntil == 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          radius: 26,
          backgroundImage: member.photoPath != null
              ? FileImage(File(member.photoPath!))
              : null,
          child: member.photoPath == null
              ? Text(member.name.isNotEmpty ? member.name[0].toUpperCase() : '?')
              : null,
        ),
        title: Text(member.name),
        subtitle: Text(
          '${member.relationship} • ${member.ageInYears} years old\n'
          'DOB: ${member.dob.day}/${member.dob.month}/${member.dob.year}',
        ),
        isThreeLine: true,
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              isToday ? '🎉 Today!' : '$daysUntil day${daysUntil == 1 ? '' : 's'}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isToday ? Colors.green : Theme.of(context).colorScheme.primary,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 20),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
