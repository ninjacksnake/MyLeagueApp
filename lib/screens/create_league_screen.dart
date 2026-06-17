import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../providers/league_provider.dart';
import '../providers/locale_provider.dart';
import '../models/player.dart';
import '../theme/theme.dart';
import '../widgets/glass_card.dart';

class CreateLeagueScreen extends ConsumerStatefulWidget {
  const CreateLeagueScreen({super.key});

  @override
  ConsumerState<CreateLeagueScreen> createState() => _CreateLeagueScreenState();
}

class _CreateLeagueScreenState extends ConsumerState<CreateLeagueScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _defaultMonthlyFeeController = TextEditingController();
  final _defaultFeeFocusNode = FocusNode();
  
  String _selectedSport = 'Soccer';
  String _selectedFormat = 'round_robin'; // 'round_robin' or 'single_elimination'
  
  // Dynamic list of team controllers
  final List<TextEditingController> _teamControllers = [
    TextEditingController(text: 'Team Alpha'),
    TextEditingController(text: 'Team Beta'),
  ];

  Map<int, List<Player>> _teamRosters = {};

  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    _defaultFeeFocusNode.addListener(() {
      if (_defaultFeeFocusNode.hasFocus) {
        if (_defaultMonthlyFeeController.text == '0.0' || _defaultMonthlyFeeController.text == '0') {
          _defaultMonthlyFeeController.clear();
        }
      }
    });
    // Pre-populate empty rosters for the default 2 teams
    for (int i = 0; i < 2; i++) {
      _teamRosters[i] = [];
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _defaultMonthlyFeeController.dispose();
    _defaultFeeFocusNode.dispose();
    for (var controller in _teamControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addTeamField() {
    if (_teamControllers.length >= 16) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(ref.read(localeProvider) == AppLanguage.en
              ? 'Maximum 16 teams for this version.'
              : 'Máximo 16 equipos para esta versión.'),
          backgroundColor: Colors.amber,
        ),
      );
      return;
    }
    setState(() {
      final index = _teamControllers.length;
      final newController = TextEditingController(text: 'Team ${index + 1}');
      _teamControllers.add(newController);
      _teamRosters[index] = [];
    });
  }

  void _removeTeamField(int index) {
    if (_teamControllers.length <= 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(ref.read(localeProvider) == AppLanguage.en
              ? 'At least 2 teams are required.'
              : 'Se requieren al menos 2 equipos.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }
    setState(() {
      _teamControllers.removeAt(index);
      // Re-map rosters:
      final Map<int, List<Player>> newRosters = {};
      for (int i = 0; i < _teamControllers.length; i++) {
        if (i < index) {
          newRosters[i] = _teamRosters[i] ?? [];
        } else {
          newRosters[i] = _teamRosters[i + 1] ?? [];
        }
      }
      _teamRosters = newRosters;
    });
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    // Validate team names
    final List<String> teamNames = [];
    final Set<String> uniqueNames = {};
    
    for (var controller in _teamControllers) {
      final name = controller.text.trim();
      if (name.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(ref.read(localeProvider) == AppLanguage.en
                ? 'Team names cannot be empty.'
                : 'Los nombres de los equipos no pueden estar vacíos.'),
            backgroundColor: Colors.redAccent,
          ),
        );
        return;
      }
      if (uniqueNames.contains(name.toLowerCase())) {
        final warningText = ref.read(localeProvider) == AppLanguage.en
            ? 'Team name "$name" is duplicated.'
            : 'El nombre de equipo "$name" está duplicado.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(warningText),
            backgroundColor: Colors.redAccent,
          ),
        );
        return;
      }
      uniqueNames.add(name.toLowerCase());
      teamNames.add(name);
    }

    // Map rosters using team name keys
    final Map<String, List<Player>> teamRosters = {};
    for (int i = 0; i < teamNames.length; i++) {
      teamRosters[teamNames[i]] = _teamRosters[i] ?? [];
    }

    // Call provider to create league
    ref.read(leaguesProvider.notifier).createLeague(
      name: _nameController.text.trim(),
      sportType: _selectedSport,
      format: _selectedFormat,
      teamNames: teamNames,
      defaultMonthlyFee: double.tryParse(_defaultMonthlyFeeController.text),
      teamRosters: teamRosters,
    );

    // Go back to dashboard
    Navigator.of(context).pop();
    final successText = ref.read(localeProvider) == AppLanguage.en
        ? '"${_nameController.text.trim()}" generated successfully!'
        : '¡"${_nameController.text.trim()}" generado con éxito!';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(successText),
        backgroundColor: Colors.green,
      ),
    );
  }

  // Bottom Sheet to manage player roster during setup
  void _openRosterManager(int index) {
    final teamName = _teamControllers[index].text.trim();
    final List<Player> currentRoster = List.from(_teamRosters[index] ?? []);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return DraggableScrollableSheet(
              initialChildSize: 0.75,
              minChildSize: 0.5,
              maxChildSize: 0.95,
              expand: false,
              builder: (context, scrollController) {
                return Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ref.tr('manage_roster'),
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                        color: AppTheme.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  teamName,
                                  style: TextStyle(
                                    color: AppTheme.textSecondary,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline, color: AppTheme.accent, size: 28),
                            onPressed: () {
                              _showPlayerDialog(context, null, (newPlayer) {
                                setModalState(() {
                                  currentRoster.add(newPlayer);
                                });
                              });
                            },
                          ),
                        ],
                      ),
                      const Divider(color: Color(0xFF222F47), height: 32),

                      // Player List
                      Expanded(
                        child: currentRoster.isEmpty
                            ? Center(
                                child: Text(
                                  ref.tr('no_players'),
                                  style: TextStyle(color: AppTheme.textMuted),
                                ),
                              )
                            : ListView.builder(
                                controller: scrollController,
                                itemCount: currentRoster.length,
                                itemBuilder: (context, pIdx) {
                                  final player = currentRoster[pIdx];
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: GlassCard(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 18,
                                            backgroundColor: AppTheme.surfaceLight,
                                            child: Text(
                                              player.jerseyNumber != null ? '${player.jerseyNumber}' : '-',
                                              style: const TextStyle(
                                                color: AppTheme.primary,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  player.name,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: AppTheme.textPrimary,
                                                  ),
                                                ),
                                                if (player.position != null && player.position!.isNotEmpty)
                                                  Text(
                                                    player.position!,
                                                    style: TextStyle(
                                                      color: AppTheme.textSecondary,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.edit_outlined, color: AppTheme.highlight, size: 20),
                                            onPressed: () {
                                              _showPlayerDialog(context, player, (updatedPlayer) {
                                                setModalState(() {
                                                  currentRoster[pIdx] = updatedPlayer;
                                                });
                                              });
                                            },
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                                            onPressed: () {
                                              setModalState(() {
                                                currentRoster.removeAt(pIdx);
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),

                      // Save button
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _teamRosters[index] = currentRoster;
                            });
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primary,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            ref.tr('save_roster'),
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  List<String> _getPositionsForSport(String sport) {
    switch (sport.toLowerCase()) {
      case 'soccer':
        return ['Goalkeeper', 'Defender', 'Midfielder', 'Forward'];
      case 'basketball':
        return ['Point Guard', 'Shooting Guard', 'Small Forward', 'Power Forward', 'Center'];
      case 'tennis':
        return ['Singles', 'Doubles'];
      default:
        return ['Forward', 'Defender', 'Guard', 'Center', 'Player'];
    }
  }

  // Dialog to Add/Edit Player
  void _showPlayerDialog(BuildContext context, Player? player, Function(Player) onSave) {
    final nameController = TextEditingController(text: player?.name ?? '');
    final jerseyController = TextEditingController(text: player?.jerseyNumber?.toString() ?? '');
    final ageController = TextEditingController(text: player?.age?.toString() ?? '');
    final phoneController = TextEditingController(text: player?.phone ?? '');
    final emailController = TextEditingController(text: player?.email ?? '');
    final feeController = TextEditingController(text: player?.monthlyFee?.toString() ?? '');

    final FocusNode feeFocusNode = FocusNode();
    feeFocusNode.addListener(() {
      if (feeFocusNode.hasFocus) {
        if (feeController.text == '0.0' || feeController.text == '0') {
          feeController.clear();
        }
      }
    });

    final defaultFeeStr = _defaultMonthlyFeeController.text.trim();
    final hintFee = defaultFeeStr.isNotEmpty ? '\$$defaultFeeStr' : null;

    final positions = _getPositionsForSport(_selectedSport);
    String? selectedPosition = player?.position;
    if (selectedPosition == null || selectedPosition.isEmpty) {
      selectedPosition = positions.first;
    } else if (!positions.contains(selectedPosition)) {
      positions.add(selectedPosition);
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: AppTheme.surface,
              title: Text(
                player == null ? ref.tr('add_player') : ref.tr('edit_player'),
                style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primary),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: ref.tr('player_name'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: jerseyController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: ref.tr('jersey_number'),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            dropdownColor: AppTheme.surface,
                            value: selectedPosition,
                            decoration: InputDecoration(
                              labelText: ref.tr('position'),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            ),
                            items: positions.map((pos) {
                              return DropdownMenuItem<String>(
                                value: pos,
                                child: Text(pos, style: const TextStyle(fontSize: 13)),
                              );
                            }).toList(),
                            onChanged: (val) {
                              setDialogState(() {
                                selectedPosition = val;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: ageController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: ref.tr('age'),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: feeController,
                            focusNode: feeFocusNode,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            decoration: InputDecoration(
                              labelText: ref.tr('monthly_fee'),
                              hintText: hintFee,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: ref.tr('phone'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: ref.tr('email'),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    feeFocusNode.dispose();
                    Navigator.of(context).pop();
                  },
                  child: Text(ref.tr('cancel'), style: TextStyle(color: AppTheme.textSecondary)),
                ),
                ElevatedButton(
                  onPressed: () {
                    final name = nameController.text.trim();
                    if (name.isEmpty) return;

                    final jersey = int.tryParse(jerseyController.text);
                    final age = int.tryParse(ageController.text);
                    final fee = double.tryParse(feeController.text);

                    final updatedPlayer = Player(
                      id: player?.id ?? const Uuid().v4(),
                      name: name,
                      jerseyNumber: jersey,
                      position: selectedPosition != null && selectedPosition!.isNotEmpty ? selectedPosition : null,
                      age: age,
                      phone: phoneController.text.trim().isEmpty ? null : phoneController.text.trim(),
                      email: emailController.text.trim().isEmpty ? null : emailController.text.trim(),
                      monthlyFee: fee,
                      payments: player?.payments ?? const [],
                    );

                    onSave(updatedPlayer);
                    feeFocusNode.dispose();
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary),
                  child: Text(
                    ref.tr('save'),
                    style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ref.tr('create_league')),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Step Indicator Header
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    _buildStepIndicator(0, ref.tr('league_setup')),
                    Expanded(
                      child: Container(
                        height: 2,
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        color: _currentStep > 0 ? AppTheme.primary : AppTheme.surfaceLight,
                      ),
                    ),
                    _buildStepIndicator(1, ref.tr('register_teams')),
                  ],
                ),
              ),

              // Step Content
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _currentStep == 0 ? _buildStep1() : _buildStep2(),
                ),
              ),

              // Bottom Navigation Buttons
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    if (_currentStep > 0)
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              _currentStep--;
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: AppTheme.textSecondary),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(ref.tr('back'), style: TextStyle(color: AppTheme.textPrimary)),
                        ),
                      )
                    else
                      const Spacer(),
                    
                    const SizedBox(width: 16),
                    
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: AppTheme.primaryGradient,
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            if (_currentStep == 0) {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  _currentStep++;
                                });
                              }
                            } else {
                              _submit();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            _currentStep == 0 ? ref.tr('next') : ref.tr('generate_fixtures'),
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepIndicator(int stepIndex, String title) {
    final isActive = _currentStep == stepIndex;
    final isCompleted = _currentStep > stepIndex;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted
                ? AppTheme.accent
                : isActive
                    ? AppTheme.primary
                    : AppTheme.surfaceLight,
            border: Border.all(
              color: isActive || isCompleted ? Colors.transparent : const Color(0xFF222F47),
              width: 1.5,
            ),
          ),
          child: Center(
            child: isCompleted
                ? const Icon(Icons.check, size: 18, color: Colors.black)
                : Text(
                    '${stepIndex + 1}',
                    style: TextStyle(
                      color: isActive ? Colors.black : AppTheme.textSecondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            color: isActive ? AppTheme.textPrimary : AppTheme.textSecondary,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text(
          ref.tr('tournament_details'),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          ref.tr('tournament_details_desc'),
          style: TextStyle(color: AppTheme.textSecondary, fontSize: 13, height: 1.4),
        ),
        const SizedBox(height: 24),
        
        // League Name Input
        TextFormField(
          controller: _nameController,
          decoration: InputDecoration(
            labelText: ref.tr('league_name_label'),
            hintText: ref.tr('league_name_hint'),
            prefixIcon: Icon(Icons.emoji_events, color: AppTheme.highlight),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return ref.tr('enter_name_validation');
            }
            return null;
          },
        ),
        const SizedBox(height: 24),

        // Default Monthly Fee Input
        TextFormField(
          controller: _defaultMonthlyFeeController,
          focusNode: _defaultFeeFocusNode,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: ref.tr('default_monthly_fee'),
            hintText: 'e.g., 50.0',
            prefixIcon: Icon(Icons.monetization_on_outlined, color: AppTheme.highlight),
          ),
        ),
        const SizedBox(height: 24),

        // Sport Selector Card
        Text(ref.tr('sport_category'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 10),
        Row(
          children: [
            _buildSportOption('Soccer', ref.tr('soccer'), Icons.sports_soccer),
            const SizedBox(width: 10),
            _buildSportOption('Basketball', ref.tr('basketball'), Icons.sports_basketball),
            const SizedBox(width: 10),
            _buildSportOption('Tennis', ref.tr('tennis'), Icons.sports_tennis),
          ],
        ),
        const SizedBox(height: 24),

        // Tournament Format Selector
        Text(ref.tr('tournament_format'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 10),
        Column(
          children: [
            _buildFormatOption(
              'round_robin',
              ref.tr('round_robin'),
              ref.tr('round_robin_desc'),
              Icons.grid_view,
            ),
            const SizedBox(height: 12),
            _buildFormatOption(
              'single_elimination',
              ref.tr('single_elimination'),
              ref.tr('single_elimination_desc'),
              Icons.account_tree_outlined,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              ref.tr('register_teams'),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            IconButton(
              onPressed: _addTeamField,
              icon: Icon(Icons.add_circle_outline, color: AppTheme.highlight, size: 28),
              tooltip: 'Add Team',
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          ref.tr('register_teams_desc'),
          style: TextStyle(color: AppTheme.textSecondary, fontSize: 13, height: 1.4),
        ),
        const SizedBox(height: 20),

        // Team list
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _teamControllers.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: GlassCard(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Column(
                  children: [
                    Row(
                      children: [
                        // Visual color bubble representing team
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.white.withOpacity(0.05),
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _teamControllers[index],
                            decoration: InputDecoration(
                              hintText: ref.tr('team_name_hint'),
                              filled: true,
                              fillColor: Colors.transparent,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: AppTheme.primary.withOpacity(0.7), width: 1.5),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return ref.tr('enter_team_name_validation');
                              }
                              return null;
                            },
                          ),
                        ),
                        IconButton(
                          onPressed: () => _removeTeamField(index),
                          icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 22),
                          tooltip: 'Remove',
                        ),
                      ],
                    ),
                    const Divider(color: Color(0xFF222F47), height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${_teamRosters[index]?.length ?? 0} ${ref.tr('players').toLowerCase()}',
                          style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                        ),
                        TextButton.icon(
                          onPressed: () => _openRosterManager(index),
                          icon: Icon(Icons.people_outline, size: 16, color: AppTheme.highlight),
                          label: Text(
                            ref.tr('manage_roster'),
                            style: TextStyle(color: AppTheme.highlight, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        
        // Dynamic bottom spacing
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildSportOption(String sportId, String displayName, IconData icon) {
    final isSelected = _selectedSport == sportId;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedSport = sportId;
          });
        },
        child: GlassCard(
          padding: const EdgeInsets.symmetric(vertical: 16),
          borderColor: isSelected ? AppTheme.highlight.withOpacity(0.6) : null,
          gradientColors: isSelected
              ? [
                  AppTheme.highlight.withOpacity(0.15),
                  AppTheme.secondary.withOpacity(0.15),
                ]
              : null,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected ? AppTheme.highlight : AppTheme.textSecondary,
                size: 28,
              ),
              const SizedBox(height: 8),
              Text(
                displayName,
                style: TextStyle(
                  color: isSelected ? AppTheme.textPrimary : AppTheme.textSecondary,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormatOption(String format, String title, String description, IconData icon) {
    final isSelected = _selectedFormat == format;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFormat = format;
        });
      },
      child: GlassCard(
        borderColor: isSelected ? AppTheme.highlight.withOpacity(0.6) : null,
        gradientColors: isSelected
            ? [
                AppTheme.highlight.withOpacity(0.1),
                AppTheme.secondary.withOpacity(0.1),
              ]
            : null,
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: isSelected ? AppTheme.highlight : AppTheme.textSecondary,
              size: 24,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: isSelected ? AppTheme.textPrimary : AppTheme.textSecondary,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 11,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
