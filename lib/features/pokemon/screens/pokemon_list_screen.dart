// import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:medilink_test/core/theme/app_theme.dart';
import 'package:medilink_test/core/extensions/string_extension.dart';
import 'package:medilink_test/features/pokemon/data/pokemon_repository.dart';
import 'package:medilink_test/features/pokemon/domain/pokemon_model.dart';
import 'package:medilink_test/features/pokemon/screens/pokemon_detail_screen.dart';

class PokemonListScreen extends StatefulWidget {
  const PokemonListScreen({super.key});

  @override
  State<PokemonListScreen> createState() => _PokemonListScreenState();
}

class _PokemonListScreenState extends State<PokemonListScreen> {
  static const _pageSize = 20;
  final _repository = PokemonRepository();

  late final _pagingController = PagingController<int, PokemonList>(
    getNextPageKey: (state) {
      if (state.lastPageIsEmpty) return null;
      final lastOffset = state.keys?.lastOrNull ?? -_pageSize;
      // log('last offset: $lastOffset');
      return lastOffset + _pageSize;
    },
    fetchPage: (pageKey) async {
      final response = await _repository.fetchPokemon(pageKey, _pageSize);
      // log('pageKey: $pageKey');
      if (response == null) {
        throw Exception('Gagal memuat data pokemon');
      }
      final data = PokemonModel.fromJson(response);
      return data.results ?? [];
    },
  );

  @override
  void initState() {
    super.initState();
    _pagingController.addListener(_showError);
  }

  void _showError() {
    // log('error');
    if (_pagingController.value.status == PagingStatus.subsequentPageError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Gagal memuat halaman berikutnya'),
          action: SnackBarAction(
            label: 'Coba lagi',
            textColor: Colors.white,
            onPressed: _pagingController.fetchNextPage,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _pagingController
      ..removeListener(_showError)
      ..dispose();
    // log('dispose');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTheme.buildAppBar(title: 'Daftar Pokemon'),
      body: RefreshIndicator(
        color: AppTheme.primaryBlue,
        onRefresh: () => Future.sync(_pagingController.refresh),
        child: PagingListener(
          controller: _pagingController,
          builder: (context, state, fetchNextPage) =>
              PagedListView<int, PokemonList>(
                state: state,
                fetchNextPage: fetchNextPage,
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                builderDelegate: PagedChildBuilderDelegate(
                  itemBuilder: (context, pokemon, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _PokemonListCard(
                        no: (index + 1),
                        name: pokemon.name?.formatName() ?? '-',
                        onTap: () {
                          final url = pokemon.url;
                          if (url == null || url.isEmpty) return;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PokemonDetailScreen(
                                url: url,
                                name: pokemon.name,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                  firstPageErrorIndicatorBuilder: (context) => _ErrorView(
                    message: 'Gagal memuat daftar pokemon',
                    onRetry: _pagingController.refresh,
                  ),
                  newPageErrorIndicatorBuilder: (context) => _ErrorView(
                    message: 'Gagal memuat halaman berikutnya',
                    onRetry: _pagingController.fetchNextPage,
                  ),
                  noItemsFoundIndicatorBuilder: (context) => const _EmptyView(),
                ),
              ),
        ),
      ),
    );
  }
}

class _PokemonListCard extends StatelessWidget {
  final int no;
  final String name;
  final VoidCallback onTap;

  const _PokemonListCard({
    required this.no,
    required this.name,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: AppTheme.cardDecoration(context),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    gradient: AppTheme.heroGradient.gradient,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '#${no.toString().padLeft(3, '0')}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1A2E),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Lihat detail',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: AppTheme.primaryBlue.withValues(alpha: 0.7),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 56, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          Text(
            'Tidak ada pokemon ditemukan',
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
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
                Icons.error_outline_rounded,
                size: 48,
                color: Colors.red.shade400,
              ),
              const SizedBox(height: 12),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('Coba lagi'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
