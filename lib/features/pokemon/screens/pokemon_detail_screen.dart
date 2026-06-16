import 'package:flutter/material.dart';
import 'package:medilink_test/core/theme/app_theme.dart';
import 'package:medilink_test/core/extensions/string_extension.dart';
import 'package:medilink_test/features/pokemon/data/pokemon_repository.dart';
import 'package:medilink_test/features/pokemon/domain/pokemon_detail_model.dart';

class PokemonDetailScreen extends StatefulWidget {
  final String url;
  final String? name;

  const PokemonDetailScreen({super.key, required this.url, this.name});

  @override
  State<PokemonDetailScreen> createState() => _PokemonDetailScreenState();
}

class _PokemonDetailScreenState extends State<PokemonDetailScreen> {
  final _repository = PokemonRepository();

  PokemonDetailModel? _pokemon;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadDetail();
  }

  Future<void> _loadDetail() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await _repository.fetchPokemonDetail(widget.url);
      if (response == null) {
        throw Exception('Data tidak ditemukan');
      }
      setState(() {
        _pokemon = PokemonDetailModel.fromJson(response);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  String _formatResource(Firmness? resource) {
    if (resource?.name == null) return '-';
    return (resource!.name!).formatName();
  }

  @override
  Widget build(BuildContext context) {
    final title = _pokemon?.name?.formatName() ?? widget.name?.formatName() ?? 'Detail';

    return Scaffold(
      appBar: AppTheme.buildAppBar(title: title, showBackButton: true),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppTheme.primaryBlue),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: AppTheme.cardDecoration(context),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.cloud_off_rounded,
                  size: 48,
                  color: Colors.red.shade400,
                ),
                const SizedBox(height: 12),
                Text(_error!, textAlign: TextAlign.center),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: _loadDetail,
                  icon: const Icon(Icons.refresh_rounded, size: 18),
                  label: const Text('Coba lagi'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final pokemon = _pokemon!;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: AppTheme.heroGradient,
            child: Column(
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.eco_rounded,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  pokemon.name?.formatName() ?? '-',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (pokemon.id != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '#${pokemon.id!.toString().padLeft(3, '0')}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 20),
          _InfoSection(
            title: 'Informasi Umum',
            icon: Icons.info_outline_rounded,
            children: [
              _InfoRow(
                icon: Icons.grain_rounded,
                label: 'Firmness',
                value: _formatResource(pokemon.firmness),
              ),
              _InfoRow(
                icon: Icons.inventory_2_outlined,
                label: 'Item',
                value: _formatResource(pokemon.item),
              ),
              _InfoRow(
                icon: Icons.auto_awesome_outlined,
                label: 'Natural Gift Type',
                value: _formatResource(pokemon.naturalGiftType),
              ),
              _InfoRow(
                icon: Icons.schedule_rounded,
                label: 'Growth Time',
                value: '${pokemon.growthTime ?? '-'} jam',
              ),
              _InfoRow(
                icon: Icons.yard_outlined,
                label: 'Max Harvest',
                value: '${pokemon.maxHarvest ?? '-'}',
              ),
              _InfoRow(
                icon: Icons.straighten_rounded,
                label: 'Size',
                value: '${pokemon.size ?? '-'}',
              ),
              _InfoRow(
                icon: Icons.blur_on_rounded,
                label: 'Smoothness',
                value: '${pokemon.smoothness ?? '-'}',
              ),
              _InfoRow(
                icon: Icons.water_drop_outlined,
                label: 'Soil Dryness',
                value: '${pokemon.soilDryness ?? '-'}',
              ),
              _InfoRow(
                icon: Icons.bolt_rounded,
                label: 'Natural Gift Power',
                value: '${pokemon.naturalGiftPower ?? '-'}',
              ),
            ],
          ),
          if ((pokemon.flavors ?? []).isNotEmpty) ...[
            const SizedBox(height: 16),
            _InfoSection(
              title: 'Flavors',
              icon: Icons.local_dining_outlined,
              children: (pokemon.flavors ?? []).map((entry) {
                return _FlavorChip(
                  name: _formatResource(entry.flavor),
                  potency: entry.potency ?? 0,
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _InfoSection({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: AppTheme.primaryBlue),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A2E),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: AppTheme.primaryBlue),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FlavorChip extends StatelessWidget {
  final String name;
  final int potency;

  const _FlavorChip({required this.name, required this.potency});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Potency $potency',
              style: const TextStyle(
                color: AppTheme.primaryBlue,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
