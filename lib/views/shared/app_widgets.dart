// ============================================================
// Các widget dùng chung: GroupTag, SectionHeader, AppCard,
// ArrowIcon, EmptyState
// ============================================================

import 'package:flutter/material.dart';
import '../../domain/enums/relative_group_enum.dart';
import 'app_theme.dart';

// ── Nhãn nhóm (Gia đình / Họ hàng / Thân quen) ───────────────
class GroupTag extends StatelessWidget {
  final RelativeGroup group;

  const GroupTag(this.group, {super.key});

  @override
  Widget build(BuildContext context) {
    Color bg, fg;
    switch (group) {
      case RelativeGroup.family:
        bg = AppTheme.familyTag; fg = AppTheme.familyText;
      case RelativeGroup.relatives:
        bg = AppTheme.relativesTag; fg = AppTheme.relativesText;
      case RelativeGroup.acquaintance:
        bg = AppTheme.acquaintTag; fg = AppTheme.acquaintText;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        group.value,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: fg,
        ),
      ),
    );
  }
}

// ── Card trắng với shadow nhẹ ─────────────────────────────────
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final double? radius;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(radius ?? AppTheme.radiusCard),
        boxShadow: AppTheme.cardShadow,
      ),
      padding: padding ?? const EdgeInsets.all(16),
      child: child,
    );
  }
}

// ── Icon mũi tên trong vòng tròn (thu vào / chi ra) ──────────
class ArrowIcon extends StatelessWidget {
  final bool isReceive;
  final double size;

  const ArrowIcon({super.key, required this.isReceive, this.size = 36});

  @override
  Widget build(BuildContext context) {
    final color = isReceive ? AppTheme.green : AppTheme.red;
    final bg    = isReceive ? AppTheme.greenLight : AppTheme.redLight;
    return Container(
      width: size, height: size,
      decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
      child: Icon(
        isReceive
            ? Icons.south_west_rounded  // mũi tên thu vào
            : Icons.north_east_rounded, // mũi tên chi ra
        color: color,
        size: size * 0.5,
      ),
    );
  }
}

// ── Header phần có tiêu đề ────────────────────────────────────
class SectionHeader extends StatelessWidget {
  final String title;
  final Widget? trailing;

  const SectionHeader(this.title, {super.key, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppTheme.textSecondary,
          ),
        ),
        const Spacer(),
        if (trailing != null) trailing!,
      ],
    );
  }
}

// ── Trạng thái trống ─────────────────────────────────────────
class EmptyState extends StatelessWidget {
  final String message;
  const EmptyState(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 48),
        child: Column(
          children: [
            Icon(Icons.inbox_outlined, size: 48, color: Colors.grey.shade300),
            const SizedBox(height: 12),
            Text(
              message,
              style: const TextStyle(color: AppTheme.textHint, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
