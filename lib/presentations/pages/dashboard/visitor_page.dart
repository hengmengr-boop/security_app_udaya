import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udaya_visitor/data/data_export.dart';
import 'package:udaya_visitor/helper/helper_export.dart';
import 'package:udaya_visitor/logic/logic_export.dart';
import 'package:udaya_visitor/presentations/presentation_export.dart';

/// Main screen: search + filter, Up-Coming / On-Site / Check-Out tabs and the
/// visitor list. Wide screens (laptop) use a sidebar + list; phones stack them.
final class VisitorPage extends StatefulWidget {
  const VisitorPage({super.key});

  @override
  State<VisitorPage> createState() => _VisitorPageState();
}

final class _VisitorPageState extends State<VisitorPage> {
  final _searchController = TextEditingController();
  final _debouncer = Debouncer();

  @override
  void dispose() {
    _searchController.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  // ── Actions ───────────────────────────────────────────────────────────────

  void _onSearchChanged(String value) {
    _debouncer.run(() {
      if (mounted)
        context.read<VisitorBloc>().add(SearchVisitorEvent(query: value));
    });
  }

  Future<void> _openFilter(VisitorLoadedState state) async {
    final result = await showFilterBottomSheet(
      context,
      rooms: state.rooms,
      room: state.room,
      todayOnly: state.todayOnly,
    );
    if (result == null || !mounted) return;
    context
        .read<VisitorBloc>()
        .add(ApplyFilterEvent(room: result.room, todayOnly: result.todayOnly));
  }

  Future<void> _logout() async {
    final ok = await context.confirm(
      title: tr(LocaleKeys.logout),
      message: tr(LocaleKeys.logout_confirm),
      confirmText: tr(LocaleKeys.logout),
      cancelText: tr(LocaleKeys.cancel),
      isDestructive: true,
    );
    if (ok == true && mounted) context.read<AuthBloc>().add(LogoutEvent());
  }

  void _checkIn(VisitorModel v) {
    context.read<VisitorBloc>().add(CheckInEvent(id: v.id));
    context.showSuccessSnackBar(
        msg: tr(LocaleKeys.msg_checked_in, namedArgs: {'name': v.name}));
  }

  void _checkOut(VisitorModel v) {
    context.read<VisitorBloc>().add(CheckOutEvent(id: v.id));
    context.showSuccessSnackBar(
        msg: tr(LocaleKeys.msg_checked_out, namedArgs: {'name': v.name}));
  }

  String _tabLabel(VisitorStatus status) => switch (status) {
        VisitorStatus.upcoming => tr(LocaleKeys.tab_upcoming),
        VisitorStatus.onSite => tr(LocaleKeys.tab_onsite),
        VisitorStatus.checkedOut => tr(LocaleKeys.tab_checkout),
      };

  Future<void> _openAddVisitor() async {
    await Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const AddVisitorPage()));
    if (!mounted) return;
    context.read<VisitorBloc>().add(LoadVisitorsEvent());
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final mobile = context.isMobile;
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoggedOut) context.go(destination: const LoginPage());
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(gradient: kBrandGradient),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(mobile ? 10 : 32),
              child: Container(
                padding: EdgeInsets.all(mobile ? 12 : 28),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(Dimen.defaultRadius + 3),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withValues(alpha: 0.10),
                        blurRadius: 24,
                        offset: const Offset(0, 8))
                  ],
                ),
                child: BlocBuilder<VisitorBloc, VisitorState>(
                  builder: (context, state) {
                    if (state is! VisitorLoadedState)
                      return const ProgressBar();
                    return context.isWide
                        ? _buildWide(context, state)
                        : _buildNarrow(context, state);
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Laptop / desktop / large tablet: sidebar (search, tabs, language) + list.
  Widget _buildWide(BuildContext context, VisitorLoadedState state) {
    final sidebarWidth =
        (context.screenWidth * 0.3).clamp(300.0, 400.0).toDouble();
    return Stack(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: sidebarWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildSearchRow(state, height: 56),
                  const SizedBox(height: Dimen.defaultSpace),
                  for (final tab in VisitorStatus.values) ...[
                    Expanded(
                      child: _TabButton(
                        label: _tabLabel(tab),
                        selected: state.tab == tab,
                        fontSize: 28,
                        onTap: () => context
                            .read<VisitorBloc>()
                            .add(ChangeTabEvent(tab: tab)),
                      ),
                    ),
                    const SizedBox(height: 14),
                  ],
                  Row(
                    children: [
                      const Expanded(
                          child: LanguageSwitcher(height: 64, expand: true)),
                      const SizedBox(width: 14),
                      _SquareIconButton(
                          size: 64, icon: Icons.logout, onTap: _logout),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 28),
            Expanded(child: _buildList(context, state)),
          ],
        ),
        Positioned(
          right: 4,
          bottom: 4,
          child: FloatingActionButton(
            heroTag: 'add-visitor-wide',
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 4,
            onPressed: _openAddVisitor,
            child: const Icon(Icons.add, size: 32),
          ),
        ),
      ],
    );
  }

  /// Phone / small tablet: everything stacked vertically.
  Widget _buildNarrow(BuildContext context, VisitorLoadedState state) {
    final tabs = VisitorStatus.values;
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const UdayaLogo(width: 92),
                const Spacer(),
                const LanguageSwitcher(height: 40),
                const SizedBox(width: 8),
                _SquareIconButton(size: 40, icon: Icons.logout, onTap: _logout),
              ],
            ),
            const SizedBox(height: 12),
            _buildSearchRow(state, height: 48),
            const SizedBox(height: 12),
            Row(
              children: [
                for (var i = 0; i < tabs.length; i++)
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: i == 0 ? 0 : 8),
                      child: SizedBox(
                        height: 48,
                        child: _TabButton(
                          label: _tabLabel(tabs[i]),
                          selected: state.tab == tabs[i],
                          fontSize: 14,
                          onTap: () => context
                              .read<VisitorBloc>()
                              .add(ChangeTabEvent(tab: tabs[i])),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(child: _buildList(context, state)),
          ],
        ),
        Positioned(
          right: 4,
          bottom: 4,
          child: FloatingActionButton(
            heroTag: 'add-visitor',
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 4,
            onPressed: _openAddVisitor,
            child: const Icon(Icons.add, size: 32),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchRow(VisitorLoadedState state, {required double height}) {
    OutlineInputBorder border(Color color) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: color),
        );
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _searchController,
            onChanged: _onSearchChanged,
            style: const TextStyle(fontSize: 16, color: AppColors.textBody),
            decoration: InputDecoration(
              hintText: tr(LocaleKeys.search_visitors),
              hintStyle: const TextStyle(color: AppColors.textMuted),
              prefixIcon: const Icon(Icons.search, color: AppColors.textBody),
              contentPadding: EdgeInsets.symmetric(
                  vertical: (height - 22) / 2, horizontal: 12),
              border: border(AppColors.border),
              enabledBorder: border(AppColors.border),
              focusedBorder: border(AppColors.primary),
            ),
          ),
        ),
        const SizedBox(width: 12),
        _SquareIconButton(
          size: height,
          icon: Icons.tune,
          showDot: state.hasFilter,
          tooltip: tr(LocaleKeys.filter),
          onTap: () => _openFilter(state),
        ),
      ],
    );
  }

  Widget _buildList(BuildContext context, VisitorLoadedState state) {
    final visible = state.visible;
    if (visible.isEmpty) return const _EmptyState();
    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: visible.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final v = visible[index];
        return ItemVisitor(
          visitor: v,
          onShowQr: () => showQrCodeDialog(context, v),
          onCheckIn:
              v.status == VisitorStatus.upcoming ? () => _checkIn(v) : null,
          onCheckOut:
              v.status == VisitorStatus.onSite ? () => _checkOut(v) : null,
        );
      },
    );
  }
}

// ── Private widgets ─────────────────────────────────────────────────────────

final class _TabButton extends StatelessWidget {
  const _TabButton(
      {required this.label,
      required this.selected,
      required this.fontSize,
      required this.onTap});

  final String label;
  final bool selected;
  final double fontSize;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.primary : AppColors.tabIdle,
      elevation: selected ? 3 : 1,
      shadowColor: Colors.black.withValues(alpha: 0.25),
      borderRadius: BorderRadius.circular(10),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                maxLines: 1,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w800,
                  color: selected ? Colors.white : AppColors.textBody,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

final class _SquareIconButton extends StatelessWidget {
  const _SquareIconButton(
      {required this.size,
      required this.icon,
      required this.onTap,
      this.showDot = false,
      this.tooltip});

  final double size;
  final IconData icon;
  final VoidCallback onTap;
  final bool showDot;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final button = Material(
      color: const Color(0xFFF8F9FC),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(icon, color: AppColors.textBody, size: size * 0.45),
              if (showDot)
                Positioned(
                  top: size * 0.2,
                  right: size * 0.2,
                  child: Container(
                    width: 9,
                    height: 9,
                    decoration: const BoxDecoration(
                        color: AppColors.accent, shape: BoxShape.circle),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
    return tooltip == null ? button : Tooltip(message: tooltip!, child: button);
  }
}

final class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.people_outline,
              size: 56, color: AppColors.textMuted),
          const SizedBox(height: Dimen.mediumSpace),
          Text(tr(LocaleKeys.no_visitors),
              style: CustomTextStyle.titleTextStyle(color: AppColors.textBody)),
          const SizedBox(height: 4),
          Text(
            tr(LocaleKeys.no_visitors_desc),
            textAlign: TextAlign.center,
            style: CustomTextStyle.captionTextStyle(color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}
