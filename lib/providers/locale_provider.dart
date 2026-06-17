import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppLanguage { en, es }

class LocaleNotifier extends StateNotifier<AppLanguage> {
  LocaleNotifier() : super(AppLanguage.en);

  void setLanguage(AppLanguage language) {
    state = language;
  }

  void toggleLanguage() {
    state = state == AppLanguage.en ? AppLanguage.es : AppLanguage.en;
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, AppLanguage>((ref) {
  return LocaleNotifier();
});

class Translations {
  static const Map<String, Map<AppLanguage, String>> _keys = {
    'app_title': {
      AppLanguage.en: 'MY LEAGUE',
      AppLanguage.es: 'MI LIGA',
    },
    'load_sample_data': {
      AppLanguage.en: 'Load Sample Data',
      AppLanguage.es: 'Cargar Datos de Ejemplo',
    },
    'sample_data_loaded': {
      AppLanguage.en: 'Sample leagues loaded!',
      AppLanguage.es: '¡Ligas de ejemplo cargadas!',
    },
    'new_league': {
      AppLanguage.en: 'New League',
      AppLanguage.es: 'Nueva Liga',
    },
    'dashboard': {
      AppLanguage.en: 'Dashboard',
      AppLanguage.es: 'Tablero',
    },
    'your_tournaments': {
      AppLanguage.en: 'Your Tournaments',
      AppLanguage.es: 'Tus Torneos',
    },
    'tournaments': {
      AppLanguage.en: 'Tournaments',
      AppLanguage.es: 'Torneos',
    },
    'delete_league_title': {
      AppLanguage.en: 'Delete League?',
      AppLanguage.es: '¿Eliminar Liga?',
    },
    'delete_league_confirm': {
      AppLanguage.en: 'Are you sure you want to delete "{name}"?',
      AppLanguage.es: '¿Estás seguro de que quieres eliminar "{name}"?',
    },
    'cancel': {
      AppLanguage.en: 'Cancel',
      AppLanguage.es: 'Cancelar',
    },
    'delete': {
      AppLanguage.en: 'Delete',
      AppLanguage.es: 'Eliminar',
    },
    'round_robin': {
      AppLanguage.en: 'Round Robin',
      AppLanguage.es: 'Todos contra Todos',
    },
    'single_elimination': {
      AppLanguage.en: 'Single Elimination',
      AppLanguage.es: 'Eliminación Directa',
    },
    'teams_count': {
      AppLanguage.en: '{count} Teams',
      AppLanguage.es: '{count} Equipos',
    },
    'finished': {
      AppLanguage.en: 'Finished',
      AppLanguage.es: 'Finalizado',
    },
    'active': {
      AppLanguage.en: 'Active',
      AppLanguage.es: 'Activo',
    },
    'total': {
      AppLanguage.en: 'Total',
      AppLanguage.es: 'Total',
    },
    'active_stats': {
      AppLanguage.en: 'Active',
      AppLanguage.es: 'Activos',
    },
    'finished_stats': {
      AppLanguage.en: 'Finished',
      AppLanguage.es: 'Finalizados',
    },
    'no_leagues_yet': {
      AppLanguage.en: 'No Leagues Yet',
      AppLanguage.es: 'No hay ligas aún',
    },
    'no_leagues_desc': {
      AppLanguage.en: 'Create a tournament and generate matches instantly, or load sample data to see how it works.',
      AppLanguage.es: 'Crea un torneo y genera partidos al instante, o carga datos de ejemplo para ver cómo funciona.',
    },
    'load_demo_data': {
      AppLanguage.en: 'Load Demo Data',
      AppLanguage.es: 'Cargar Demo',
    },
    'create_new': {
      AppLanguage.en: 'Create New',
      AppLanguage.es: 'Crear Nueva',
    },
    'soccer': {
      AppLanguage.en: 'Soccer',
      AppLanguage.es: 'Fútbol',
    },
    'basketball': {
      AppLanguage.en: 'Basketball',
      AppLanguage.es: 'Baloncesto',
    },
    'tennis': {
      AppLanguage.en: 'Tennis',
      AppLanguage.es: 'Tenis',
    },
    'create_league': {
      AppLanguage.en: 'CREATE LEAGUE',
      AppLanguage.es: 'CREAR LIGA',
    },
    'league_setup': {
      AppLanguage.en: 'League Setup',
      AppLanguage.es: 'Configuración de Liga',
    },
    'register_teams': {
      AppLanguage.en: 'Register Teams',
      AppLanguage.es: 'Registrar Equipos',
    },
    'back': {
      AppLanguage.en: 'Back',
      AppLanguage.es: 'Atrás',
    },
    'next': {
      AppLanguage.en: 'Next',
      AppLanguage.es: 'Siguiente',
    },
    'generate_fixtures': {
      AppLanguage.en: 'Generate Fixtures',
      AppLanguage.es: 'Generar Partidos',
    },
    'tournament_details': {
      AppLanguage.en: 'Tournament details',
      AppLanguage.es: 'Detalles del Torneo',
    },
    'tournament_details_desc': {
      AppLanguage.en: 'Fill in the tournament name, pick a sport ruleset, and choose your preferred tournament layout.',
      AppLanguage.es: 'Completa el nombre del torneo, elige una categoría de deporte y escoge tu formato preferido.',
    },
    'league_name_label': {
      AppLanguage.en: 'League / Tournament Name',
      AppLanguage.es: 'Nombre de la Liga / Torneo',
    },
    'league_name_hint': {
      AppLanguage.en: 'e.g., Copa America, Summer League',
      AppLanguage.es: 'ej., Copa América, Liga de Verano',
    },
    'enter_name_validation': {
      AppLanguage.en: 'Please enter a name.',
      AppLanguage.es: 'Por favor ingresa un nombre.',
    },
    'sport_category': {
      AppLanguage.en: 'Sport Category',
      AppLanguage.es: 'Categoría de Deporte',
    },
    'tournament_format': {
      AppLanguage.en: 'Tournament Format',
      AppLanguage.es: 'Formato del Torneo',
    },
    'round_robin_desc': {
      AppLanguage.en: 'Every team plays every other team once. Points are awarded for wins and draws. Best for standard leagues.',
      AppLanguage.es: 'Cada equipo juega contra todos una vez. Se otorgan puntos por victorias y empates. Ideal para ligas estándar.',
    },
    'single_elimination_desc': {
      AppLanguage.en: 'Teams are paired in knockout matches. Winners advance to the next round, losers are eliminated.',
      AppLanguage.es: 'Los equipos se emparejan en partidos de eliminación directa. Los ganadores avanzan, los perdedores son eliminados.',
    },
    'register_teams_desc': {
      AppLanguage.en: 'Input names for each competing team. We will auto-generate matchups based on the format selected.',
      AppLanguage.es: 'Ingresa los nombres de cada equipo. Generaremos automáticamente los partidos según el formato elegido.',
    },
    'team_name_hint': {
      AppLanguage.en: 'Team Name',
      AppLanguage.es: 'Nombre del Equipo',
    },
    'enter_team_name_validation': {
      AppLanguage.en: 'Enter team name.',
      AppLanguage.es: 'Ingresa el nombre.',
    },
    'max_teams_warning': {
      AppLanguage.en: 'Maximum 16 teams for this version.',
      AppLanguage.es: 'Máximo 16 equipos para esta versión.',
    },
    'min_teams_warning': {
      AppLanguage.en: 'At least 2 teams are required.',
      AppLanguage.es: 'Se requieren al menos 2 equipos.',
    },
    'empty_team_names_warning': {
      AppLanguage.en: 'Team names cannot be empty.',
      AppLanguage.es: 'Los nombres de los equipos no pueden estar vacíos.',
    },
    'duplicate_team_name_warning': {
      AppLanguage.en: 'Team name "{name}" is duplicated.',
      AppLanguage.es: 'El nombre de equipo "{name}" está duplicado.',
    },
    'generated_success': {
      AppLanguage.en: '"{name}" generated successfully!',
      AppLanguage.es: '¡"{name}" generado con éxito!',
    },
    'league_not_found': {
      AppLanguage.en: 'League not found.',
      AppLanguage.es: 'Liga no encontrada.',
    },
    'standings': {
      AppLanguage.en: 'STANDINGS',
      AppLanguage.es: 'POSICIONES',
    },
    'bracket': {
      AppLanguage.en: 'BRACKET',
      AppLanguage.es: 'ELIMINATORIA',
    },
    'matches': {
      AppLanguage.en: 'MATCHES',
      AppLanguage.es: 'PARTIDOS',
    },
    'teams': {
      AppLanguage.en: 'TEAMS',
      AppLanguage.es: 'EQUIPOS',
    },
    'league_standings': {
      AppLanguage.en: 'League Standings',
      AppLanguage.es: 'Tabla de Posiciones',
    },
    'season_finished': {
      AppLanguage.en: 'Season Finished',
      AppLanguage.es: 'Temporada Finalizada',
    },
    'played_header': {
      AppLanguage.en: 'P',
      AppLanguage.es: 'PJ',
    },
    'wins_header': {
      AppLanguage.en: 'W',
      AppLanguage.es: 'G',
    },
    'draws_header': {
      AppLanguage.en: 'D',
      AppLanguage.es: 'E',
    },
    'losses_header': {
      AppLanguage.en: 'L',
      AppLanguage.es: 'P',
    },
    'goal_diff_header': {
      AppLanguage.en: 'GD',
      AppLanguage.es: 'DG',
    },
    'points_header': {
      AppLanguage.en: 'PTS',
      AppLanguage.es: 'PTS',
    },
    'played_tooltip': {
      AppLanguage.en: 'Played',
      AppLanguage.es: 'Partidos Jugados',
    },
    'wins_tooltip': {
      AppLanguage.en: 'Wins',
      AppLanguage.es: 'Victorias',
    },
    'draws_tooltip': {
      AppLanguage.en: 'Draws',
      AppLanguage.es: 'Empates',
    },
    'losses_tooltip': {
      AppLanguage.en: 'Losses',
      AppLanguage.es: 'Derrotas',
    },
    'goal_diff_tooltip': {
      AppLanguage.en: 'Goal Difference',
      AppLanguage.es: 'Diferencia de Goles',
    },
    'points_tooltip': {
      AppLanguage.en: 'Points',
      AppLanguage.es: 'Puntos',
    },
    'finals': {
      AppLanguage.en: 'Finals',
      AppLanguage.es: 'Final',
    },
    'semifinals': {
      AppLanguage.en: 'Semifinals',
      AppLanguage.es: 'Semifinal',
    },
    'quarterfinals': {
      AppLanguage.en: 'Quarterfinals',
      AppLanguage.es: 'Cuartos de final',
    },
    'round_n': {
      AppLanguage.en: 'Round {n}',
      AppLanguage.es: 'Ronda {n}',
    },
    'match_count': {
      AppLanguage.en: '{count} Match',
      AppLanguage.es: '{count} Partido',
    },
    'matches_count': {
      AppLanguage.en: '{count} Matches',
      AppLanguage.es: '{count} Partidos',
    },
    'tbd_pending': {
      AppLanguage.en: 'TBD (Pending Results)',
      AppLanguage.es: 'Por definir (Pendiente)',
    },
    'tbd': {
      AppLanguage.en: 'TBD',
      AppLanguage.es: 'PD',
    },
    'vs': {
      AppLanguage.en: 'VS',
      AppLanguage.es: 'VS',
    },
    'roster_initials': {
      AppLanguage.en: 'Roster Initials: {initials}',
      AppLanguage.es: 'Iniciales: {initials}',
    },
    'played_stats': {
      AppLanguage.en: '{count} Played',
      AppLanguage.es: '{count} Jugados',
    },
    'win_stats': {
      AppLanguage.en: '{count} Win',
      AppLanguage.es: '{count} Victoria',
    },
    'wins_stats': {
      AppLanguage.en: '{count} Wins',
      AppLanguage.es: '{count} Victorias',
    },
    'update_match_score': {
      AppLanguage.en: 'Update Match Score',
      AppLanguage.es: 'Actualizar Marcador',
    },
    'faults': {
      AppLanguage.en: 'Faults',
      AppLanguage.es: 'Faltas',
    },
    'home_faults': {
      AppLanguage.en: 'Home Faults',
      AppLanguage.es: 'Faltas Local',
    },
    'away_faults': {
      AppLanguage.en: 'Away Faults',
      AppLanguage.es: 'Faltas Visitante',
    },
    'faults_short': {
      AppLanguage.en: 'Fls',
      AppLanguage.es: 'Fts',
    },
    'add_match': {
      AppLanguage.en: 'Add Match',
      AppLanguage.es: 'Agregar Partido',
    },
    'home_team': {
      AppLanguage.en: 'Home Team',
      AppLanguage.es: 'Equipo Local',
    },
    'away_team': {
      AppLanguage.en: 'Away Team',
      AppLanguage.es: 'Equipo Visitante',
    },
    'select_team': {
      AppLanguage.en: 'Select Team',
      AppLanguage.es: 'Seleccionar Equipo',
    },
    'round': {
      AppLanguage.en: 'Round',
      AppLanguage.es: 'Ronda',
    },
    'fixtures': {
      AppLanguage.en: 'Fixtures',
      AppLanguage.es: 'Partidos',
    },
    'match_added': {
      AppLanguage.en: 'Match added successfully!',
      AppLanguage.es: '¡Partido agregado con éxito!',
    },
    'select_different_teams': {
      AppLanguage.en: 'Please select two different teams.',
      AppLanguage.es: 'Por favor selecciona dos equipos diferentes.',
    },
    'save_score': {
      AppLanguage.en: 'Save Score',
      AppLanguage.es: 'Guardar',
    },
    'save': {
      AppLanguage.en: 'Save',
      AppLanguage.es: 'Guardar',
    },
    'scores_updated': {
      AppLanguage.en: 'Scores updated!',
      AppLanguage.es: '¡Marcador actualizado!',
    },
    'settings': {
      AppLanguage.en: 'Settings',
      AppLanguage.es: 'Configuración',
    },
    'language': {
      AppLanguage.en: 'Language',
      AppLanguage.es: 'Idioma',
    },
    'english': {
      AppLanguage.en: 'English',
      AppLanguage.es: 'Inglés',
    },
    'spanish': {
      AppLanguage.en: 'Spanish',
      AppLanguage.es: 'Español',
    },
    'select_language': {
      AppLanguage.en: 'Select Language',
      AppLanguage.es: 'Seleccionar Idioma',
    },
    'roster': {
      AppLanguage.en: 'Roster',
      AppLanguage.es: 'Plantilla',
    },
    'add_player': {
      AppLanguage.en: 'Add Player',
      AppLanguage.es: 'Añadir Jugador',
    },
    'player_name': {
      AppLanguage.en: 'Player Name',
      AppLanguage.es: 'Nombre del Jugador',
    },
    'jersey_number': {
      AppLanguage.en: 'Jersey Number',
      AppLanguage.es: 'Número de Camiseta',
    },
    'position': {
      AppLanguage.en: 'Position',
      AppLanguage.es: 'Posición',
    },
    'manage_roster': {
      AppLanguage.en: 'Manage Roster',
      AppLanguage.es: 'Gestionar Plantilla',
    },
    'no_players': {
      AppLanguage.en: 'No players registered.',
      AppLanguage.es: 'No hay jugadores registrados.',
    },
    'no_team': {
      AppLanguage.en: 'No Team',
      AppLanguage.es: 'Sin Equipo',
    },
    'no_tournament': {
      AppLanguage.en: 'No Tournament',
      AppLanguage.es: 'Sin Torneo',
    },
    'save_roster': {
      AppLanguage.en: 'Save Roster',
      AppLanguage.es: 'Guardar Plantilla',
    },
    'jersey_num_short': {
      AppLanguage.en: '#',
      AppLanguage.es: 'Nº',
    },
    'edit_player': {
      AppLanguage.en: 'Edit Player',
      AppLanguage.es: 'Editar Jugador',
    },
    'players': {
      AppLanguage.en: 'Players',
      AppLanguage.es: 'Jugadores',
    },
    'age': {
      AppLanguage.en: 'Age',
      AppLanguage.es: 'Edad',
    },
    'phone': {
      AppLanguage.en: 'Phone',
      AppLanguage.es: 'Teléfono',
    },
    'email': {
      AppLanguage.en: 'Email',
      AppLanguage.es: 'Correo',
    },
    'monthly_fee': {
      AppLanguage.en: 'Monthly Fee',
      AppLanguage.es: 'Cuota Mensual',
    },
    'default_monthly_fee': {
      AppLanguage.en: 'Default Monthly Fee',
      AppLanguage.es: 'Cuota Mensual Predeterminada',
    },
    'payments': {
      AppLanguage.en: 'Payments',
      AppLanguage.es: 'Pagos',
    },
    'payment_history': {
      AppLanguage.en: 'Payment History',
      AppLanguage.es: 'Historial de Pagos',
    },
    'record_payment': {
      AppLanguage.en: 'Record Payment',
      AppLanguage.es: 'Registrar Pago',
    },
    'amount': {
      AppLanguage.en: 'Amount',
      AppLanguage.es: 'Monto',
    },
    'notes': {
      AppLanguage.en: 'Notes',
      AppLanguage.es: 'Notas',
    },
    'paid': {
      AppLanguage.en: 'Paid',
      AppLanguage.es: 'Pagado',
    },
    'pending': {
      AppLanguage.en: 'Pending',
      AppLanguage.es: 'Pendiente',
    },
    'no_fee': {
      AppLanguage.en: 'No Fee',
      AppLanguage.es: 'Sin Cuota',
    },
    'payment_recorded': {
      AppLanguage.en: 'Payment recorded successfully!',
      AppLanguage.es: '¡Pago registrado con éxito!',
    },
    'player_updated': {
      AppLanguage.en: 'Player details updated!',
      AppLanguage.es: '¡Detalles del jugador actualizados!',
    },
    'player_created': {
      AppLanguage.en: 'Player created successfully!',
      AppLanguage.es: '¡Jugador creado con éxito!',
    },
    'delete_player': {
      AppLanguage.en: 'Delete Player?',
      AppLanguage.es: '¿Eliminar Jugador?',
    },
    'delete_player_confirm': {
      AppLanguage.en: 'Are you sure you want to delete this player?',
      AppLanguage.es: '¿Estás seguro de que quieres eliminar a este jugador?',
    },
    'select_player': {
      AppLanguage.en: 'Select Player',
      AppLanguage.es: 'Seleccionar Jugador',
    },
    'no_players_available': {
      AppLanguage.en: 'No available players.',
      AppLanguage.es: 'No hay jugadores disponibles.',
    },
    'search': {
      AppLanguage.en: 'Search',
      AppLanguage.es: 'Buscar',
    },
    'tournament_settings': {
      AppLanguage.en: 'Tournament Settings',
      AppLanguage.es: 'Configuración del Torneo',
    },
    'default_fee_updated': {
      AppLanguage.en: 'Default monthly fee updated!',
      AppLanguage.es: '¡Cuota mensual predeterminada actualizada!',
    },
    'finish_tournament': {
      AppLanguage.en: 'Finish Tournament',
      AppLanguage.es: 'Finalizar Torneo',
    },
    'reactivate_tournament': {
      AppLanguage.en: 'Reactivate Tournament',
      AppLanguage.es: 'Reactivar Torneo',
    },
    'tournament_finished': {
      AppLanguage.en: 'Tournament finished successfully!',
      AppLanguage.es: '¡Torneo finalizado con éxito!',
    },
    'tournament_reactivated': {
      AppLanguage.en: 'Tournament reactivated!',
      AppLanguage.es: '¡Torneo reactivado!',
    },
    'finish_tournament_confirm': {
      AppLanguage.en: 'Are you sure you want to finish this tournament?',
      AppLanguage.es: '¿Estás seguro de que deseas finalizar este torneo?',
    },
    'reactivate_tournament_confirm': {
      AppLanguage.en: 'Are you sure you want to reactivate this tournament?',
      AppLanguage.es: '¿Estás seguro de que deseas reactivar este torneo?',
    },
    'remove_tournament': {
      AppLanguage.en: 'Remove Tournament?',
      AppLanguage.es: '¿Eliminar Torneo?',
    },
    'remove_tournament_desc': {
      AppLanguage.en: 'Would you like to mark this tournament as finished (saving it in history) or delete it permanently?',
      AppLanguage.es: '¿Te gustaría marcar este torneo como finalizado (guardándolo en el historial) o eliminarlo permanentemente?',
    },
    'mark_as_finished': {
      AppLanguage.en: 'Mark as Finished',
      AppLanguage.es: 'Marcar como Finalizado',
    },
    'delete_permanently': {
      AppLanguage.en: 'Delete Permanently',
      AppLanguage.es: 'Eliminar Permanentemente',
    },
    'finished_tournaments': {
      AppLanguage.en: 'Finished Tournaments',
      AppLanguage.es: 'Torneos Finalizados',
    },
    'no_finished_tournaments': {
      AppLanguage.en: 'No finished tournaments yet.',
      AppLanguage.es: 'No hay torneos finalizados aún.',
    },
    'yes': {
      AppLanguage.en: 'Yes',
      AppLanguage.es: 'Sí',
    },
    'no': {
      AppLanguage.en: 'No',
      AppLanguage.es: 'No',
    },
    'theme': {
      AppLanguage.en: 'Theme Mode',
      AppLanguage.es: 'Modo de Tema',
    },
    'light_mode': {
      AppLanguage.en: 'Light Mode',
      AppLanguage.es: 'Modo Claro',
    },
    'dark_mode': {
      AppLanguage.en: 'Dark Mode',
      AppLanguage.es: 'Modo Oscuro',
    },
    'month': {
      AppLanguage.en: 'Month',
      AppLanguage.es: 'Mes',
    },
    'month_1': {
      AppLanguage.en: 'January',
      AppLanguage.es: 'Enero',
    },
    'month_2': {
      AppLanguage.en: 'February',
      AppLanguage.es: 'Febrero',
    },
    'month_3': {
      AppLanguage.en: 'March',
      AppLanguage.es: 'Marzo',
    },
    'month_4': {
      AppLanguage.en: 'April',
      AppLanguage.es: 'Abril',
    },
    'month_5': {
      AppLanguage.en: 'May',
      AppLanguage.es: 'Mayo',
    },
    'month_6': {
      AppLanguage.en: 'June',
      AppLanguage.es: 'Junio',
    },
    'month_7': {
      AppLanguage.en: 'July',
      AppLanguage.es: 'Julio',
    },
    'month_8': {
      AppLanguage.en: 'August',
      AppLanguage.es: 'Agosto',
    },
    'month_9': {
      AppLanguage.en: 'September',
      AppLanguage.es: 'Septiembre',
    },
    'month_10': {
      AppLanguage.en: 'October',
      AppLanguage.es: 'Octubre',
    },
    'month_11': {
      AppLanguage.en: 'November',
      AppLanguage.es: 'Noviembre',
    },
    'month_12': {
      AppLanguage.en: 'December',
      AppLanguage.es: 'Diciembre',
    },
    'finances': {
      AppLanguage.en: 'Finances',
      AppLanguage.es: 'Finanzas',
    },
    'paid_players': {
      AppLanguage.en: 'Paid',
      AppLanguage.es: 'Pagados',
    },
    'unpaid_players': {
      AppLanguage.en: 'Unpaid / Pending',
      AppLanguage.es: 'Pendientes',
    },
    'total_collected': {
      AppLanguage.en: 'Total Collected',
      AppLanguage.es: 'Total Recaudado',
    },
    'total_pending': {
      AppLanguage.en: 'Total Pending',
      AppLanguage.es: 'Total Pendiente',
    },
    'no_records_for_month': {
      AppLanguage.en: 'No records for this month.',
      AppLanguage.es: 'Sin registros para este mes.',
    },
    'create_password_title': {
      AppLanguage.en: 'Create Deletion Password',
      AppLanguage.es: 'Crear Contraseña de Eliminación',
    },
    'create_password_desc': {
      AppLanguage.en: 'Set a password to protect your data. You will need this password if you choose to delete all application data in the future.',
      AppLanguage.es: 'Crea una contraseña para proteger tus datos. La necesitarás si decides eliminar todos los datos de la aplicación en el futuro.',
    },
    'password_label': {
      AppLanguage.en: 'Password',
      AppLanguage.es: 'Contraseña',
    },
    'confirm_password_label': {
      AppLanguage.en: 'Confirm Password',
      AppLanguage.es: 'Confirmar Contraseña',
    },
    'save_and_continue': {
      AppLanguage.en: 'Save & Continue',
      AppLanguage.es: 'Guardar y Continuar',
    },
    'password_empty_error': {
      AppLanguage.en: 'Password cannot be empty',
      AppLanguage.es: 'La contraseña no puede estar vacía',
    },
    'password_length_error': {
      AppLanguage.en: 'Password must be at least 4 characters',
      AppLanguage.es: 'La contraseña debe tener al menos 4 caracteres',
    },
    'passwords_dont_match': {
      AppLanguage.en: 'Passwords do not match',
      AppLanguage.es: 'Las contraseñas no coinciden',
    },
    'danger_zone': {
      AppLanguage.en: 'Danger Zone',
      AppLanguage.es: 'Zona de Peligro',
    },
    'delete_all_data': {
      AppLanguage.en: 'Delete All Data',
      AppLanguage.es: 'Eliminar Todos los Datos',
    },
    'delete_all_data_confirm_title': {
      AppLanguage.en: 'Delete All Data?',
      AppLanguage.es: '¿Eliminar Todos los Datos?',
    },
    'delete_all_data_confirm_desc': {
      AppLanguage.en: 'This will permanently delete all leagues, teams, matches, roster players, and payment history. To proceed, please enter your deletion password.',
      AppLanguage.es: 'Esto eliminará permanentemente todas las ligas, equipos, partidos, jugadores e historial de pagos. Para proceder, por favor ingresa tu contraseña de eliminación.',
    },
    'incorrect_password': {
      AppLanguage.en: 'Incorrect password',
      AppLanguage.es: 'Contraseña incorrecta',
    },
    'deleting_data': {
      AppLanguage.en: 'Wiping all data and restarting...',
      AppLanguage.es: 'Borrando todos los datos y reiniciando...',
    },
  };


  static String get(String key, AppLanguage lang) {
    return _keys[key]?[lang] ?? key;
  }
}

extension LocalizationExtension on WidgetRef {
  String tr(String key) {
    final lang = watch(localeProvider);
    return Translations.get(key, lang);
  }
}
