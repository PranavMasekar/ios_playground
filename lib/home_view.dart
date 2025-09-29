import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'app_usage_api.dart' as app_usage;

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final app_usage.AppUsageApi _appUsageApi = app_usage.AppUsageApi();
  List<app_usage.UsedApp> _apps = [];
  String? _platformVersion;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final platformVersion = await _appUsageApi.getPlatformVersion();
      final apps = await _appUsageApi.getApps();

      setState(() {
        _platformVersion = platformVersion;
        _apps = apps;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _setTimeLimit(app_usage.UsedApp app, int minutes) async {
    try {
      final result = await _appUsageApi.setAppTimeLimit(app.id, minutes);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.message),
            backgroundColor: result.state == app_usage.State.success
                ? Colors.green
                : Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  String _formatMinutes(int minutes) {
    if (minutes < 60) {
      return '${minutes}m';
    } else {
      final hours = minutes ~/ 60;
      final remainingMinutes = minutes % 60;
      return remainingMinutes > 0
          ? '${hours}h ${remainingMinutes}m'
          : '${hours}h';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: Text(
          'App Usage Tracker',
          style: ShadTheme.of(context).textTheme.h2,
        ),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadData),
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading data',
                      style: ShadTheme.of(context).textTheme.h3,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _error!,
                      style: ShadTheme.of(context).textTheme.muted,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadData,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              )
            : Column(
                children: [
                  // Platform version card
                  if (_platformVersion != null)
                    Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Theme.of(
                            context,
                          ).colorScheme.outline.withOpacity(0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.phone_iphone,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'OS Version',
                                style: ShadTheme.of(context).textTheme.small,
                              ),
                              Text(
                                _platformVersion!,
                                style: ShadTheme.of(context).textTheme.large,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                  // Apps list
                  Expanded(
                    child: _apps.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.apps,
                                  size: 64,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No apps found',
                                  style: ShadTheme.of(context).textTheme.h3,
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: _apps.length,
                            itemBuilder: (context, index) {
                              final app = _apps[index];
                              return Card(
                                margin: const EdgeInsets.only(bottom: 8),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Theme.of(
                                      context,
                                    ).colorScheme.primary.withOpacity(0.1),
                                    child: Icon(
                                      Icons.apps,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                    ),
                                  ),
                                  title: Text(
                                    app.name,
                                    style: ShadTheme.of(
                                      context,
                                    ).textTheme.large,
                                  ),
                                  subtitle: Text(
                                    'Used: ${_formatMinutes(app.minutesUsed)}',
                                    style: ShadTheme.of(
                                      context,
                                    ).textTheme.muted,
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
      ),
    );
  }
}
