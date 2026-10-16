// =============================================================================
//  MAFIA — Local pass-and-play party game (Bara Al-Salfa inspired UI)
//  Single-file Flutter app. Bilingual: Arabic (RTL) / English (LTR).
// =============================================================================

import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(const MafiaApp());

// -----------------------------------------------------------------------------
//  THEME / DESIGN TOKENS
// -----------------------------------------------------------------------------
class AppColors { 
  static const bg = Color(0xFF0B0B14);
  static const surface = Color(0xFF161626);
  static const surfaceHi = Color(0xFF20203A);
  static const accent = Color(0xFFFFC23D); // gold
  static const accent2 = Color(0xFF3DDCFF); // cyan
  static const danger = Color(0xFFFF4D6D);
  static const success = Color(0xFF3DFFA2);
  static const text = Color(0xFFF4F4FA);
  static const muted = Color(0xFF8C8CA8);
}

// -----------------------------------------------------------------------------
//  LOCALIZATION
// -----------------------------------------------------------------------------
enum Lang { en, ar }

class L10n {
  static const Map<String, Map<Lang, String>> _s = {
    'title': {Lang.en: 'MAFIA', Lang.ar: 'المافيا'},
    'subtitle': {Lang.en: 'Who is out of the story?', Lang.ar: 'مين برا السالفة؟'},
    'players': {Lang.en: 'Players', Lang.ar: 'اللاعبين'},
    'mafiaCount': {Lang.en: 'Mafia members', Lang.ar: 'عدد المافيا'},
    'specialRoles': {Lang.en: 'Special roles', Lang.ar: 'الأدوار الخاصة'},
    'playerNames': {Lang.en: 'Player names', Lang.ar: 'أسماء اللاعبين'},
    'player': {Lang.en: 'Player', Lang.ar: 'لاعب'},
    'start': {Lang.en: 'Start Game', Lang.ar: 'ابدأ اللعبة'},
    'tooManyRoles': {
      Lang.en: 'Too many roles for this many players.',
      Lang.ar: 'عدد الأدوار أكبر من عدد اللاعبين.'
    },
    'passTo': {Lang.en: 'Pass the phone to', Lang.ar: 'مرر الجوال إلى'},
    'reveal': {Lang.en: 'Reveal Role', Lang.ar: 'اكشف الدور'},
    'hideNext': {Lang.en: 'Hide & Pass', Lang.ar: 'أخفِ ومرر'},
    'yourRole': {Lang.en: 'Your role', Lang.ar: 'دورك'},
    'yourTeam': {Lang.en: 'Your fellow Mafia', Lang.ar: 'زملاؤك في المافيا'},
    'roleReveal': {Lang.en: 'Role Reveal', Lang.ar: 'كشف الأدوار'},
    'night': {Lang.en: 'Night', Lang.ar: 'الليل'},
    'day': {Lang.en: 'Day', Lang.ar: 'النهار'},
    'vote': {Lang.en: 'Vote', Lang.ar: 'التصويت'},
    'nightFalls': {Lang.en: 'Night falls… everyone close your eyes.', Lang.ar: 'حل الليل… الكل يغمض عينه.'},
    'beginNight': {Lang.en: 'Begin Night', Lang.ar: 'ابدأ الليل'},
    'confirm': {Lang.en: 'Confirm', Lang.ar: 'تأكيد'},
    'skip': {Lang.en: 'Skip', Lang.ar: 'تخطي'},
    'continue': {Lang.en: 'Continue', Lang.ar: 'متابعة'},
    'noAction': {
      Lang.en: 'You have no night action. Tap continue and pass the phone.',
      Lang.ar: 'ما عندك مهمة بالليل. اضغط متابعة ومرر الجوال.'
    },
    'chooseKill': {Lang.en: 'Choose a target to eliminate', Lang.ar: 'اختر ضحية'},
    'chooseSave': {Lang.en: 'Choose someone to protect', Lang.ar: 'اختر شخصاً لحمايته'},
    'chooseInspect': {Lang.en: 'Choose someone to inspect', Lang.ar: 'اختر شخصاً للتحقيق'},
    'chooseShoot': {Lang.en: 'Use your only bullet? (or skip)', Lang.ar: 'تستخدم رصاصتك الوحيدة؟ (أو تخطَّ)'},
    'noBullet': {Lang.en: 'You already used your bullet.', Lang.ar: 'استخدمت رصاصتك من قبل.'},
    'isMafia': {Lang.en: 'is MAFIA', Lang.ar: 'من المافيا'},
    'notMafia': {Lang.en: 'is NOT Mafia', Lang.ar: 'مو من المافيا'},
    'morning': {Lang.en: 'Good morning, town', Lang.ar: 'صباح الخير يا أهل البلد'},
    'wasKilled': {Lang.en: 'was eliminated tonight', Lang.ar: 'تم قتله الليلة'},
    'quietNight': {Lang.en: 'Nobody died tonight!', Lang.ar: 'ما مات أحد الليلة!'},
    'discuss': {Lang.en: 'Discuss & Vote', Lang.ar: 'ناقشوا وصوتوا'},
    'whoOut': {Lang.en: 'Who do you vote out?', Lang.ar: 'مين تطلعونه؟'},
    'noElim': {Lang.en: 'No elimination', Lang.ar: 'بدون إقصاء'},
    'votedOut': {Lang.en: 'was voted out. They were', Lang.ar: 'تم إقصاؤه. كان دوره'},
    'nobodyOut': {Lang.en: 'The town spared everyone today.', Lang.ar: 'البلد ما طلّع أحد اليوم.'},
    'gameOver': {Lang.en: 'Game Over', Lang.ar: 'انتهت اللعبة'},
    'winMafia': {Lang.en: 'The Mafia wins!', Lang.ar: 'المافيا فازت!'},
    'winTown': {Lang.en: 'The Villagers win!', Lang.ar: 'أهل البلد فازوا!'},
    'winJoker': {Lang.en: 'The Joker wins!', Lang.ar: 'الجوكر فاز!'},
    'playAgain': {Lang.en: 'Play Again', Lang.ar: 'العب مرة ثانية'},
    'roles': {Lang.en: 'Roles', Lang.ar: 'الأدوار'},
    'round': {Lang.en: 'Round', Lang.ar: 'الجولة'},
    'dead': {Lang.en: 'Out', Lang.ar: 'خارج'},
  };

  static String t(String key, Lang l) => _s[key]?[l] ?? key;
}

// -----------------------------------------------------------------------------
//  ROLES
// -----------------------------------------------------------------------------
enum Role { mafia, doctor, investigator, sniper, joker, villager }

extension RoleInfo on Role {
  String name(Lang l) {
    switch (this) {
      case Role.mafia:
        return l == Lang.ar ? 'مافيا' : 'Mafia';
      case Role.doctor:
        return l == Lang.ar ? 'دكتور' : 'Doctor';
      case Role.investigator:
        return l == Lang.ar ? 'محقق' : 'Investigator';
      case Role.sniper:
        return l == Lang.ar ? 'قناص' : 'Sniper';
      case Role.joker:
        return l == Lang.ar ? 'جوكر' : 'Joker';
      case Role.villager:
        return l == Lang.ar ? 'مواطن' : 'Villager';
    }
  }

  String desc(Lang l) {
    switch (this) {
      case Role.mafia:
        return l == Lang.ar ? 'كل ليلة، اتفق مع فريقك على لاعب واحد لقتله.' : 'Each night, agree with your team on one player to eliminate.';
      case Role.doctor:
        return l == Lang.ar ? 'كل ليلة، احمِ لاعباً واحداً (حتى نفسك) من الموت.' : 'Each night, protect one player (yourself included) from death.';
      case Role.investigator:
        return l == Lang.ar ? 'كل ليلة، تحقق من لاعب لتعرف إذا كان من المافيا.' : 'Each night, inspect one player to learn if they are Mafia.';
      case Role.sniper:
        return l == Lang.ar 
            ? 'عندك رصاصة وحدة. إذا صبت المافيا يموت، بس إذا صبت شخص بريء تموتون أنتوا الاثنين!' 
            : 'You have ONE bullet. If you hit Mafia they die, but if you hit an innocent, BOTH of you die!';
      case Role.joker:
        return l == Lang.ar ? 'تفوز فوراً إذا طلّعك أهل البلد بالتصويت في النهار!' : 'You win instantly if the town votes you out during the day!';
      case Role.villager:
        return l == Lang.ar ? 'ما عندك قدرة بالليل. ناقش واستنتج وصوّت ضد المافيا.' : 'No night power. Discuss, deduce, and vote out the Mafia.';
    }
  }

  IconData get icon {
    switch (this) {
      case Role.mafia:
        return Icons.local_fire_department;
      case Role.doctor:
        return Icons.medical_services;
      case Role.investigator:
        return Icons.search;
      case Role.sniper:
        return Icons.gps_fixed;
      case Role.joker:
        return Icons.theater_comedy;
      case Role.villager:
        return Icons.home;
    }
  }

  Color get color {
    switch (this) {
      case Role.mafia:
        return AppColors.danger;
      case Role.doctor:
        return AppColors.success;
      case Role.investigator:
        return AppColors.accent2;
      case Role.sniper:
        return const Color(0xFFFF8A3D);
      case Role.joker:
        return const Color(0xFFC77DFF);
      case Role.villager:
        return AppColors.accent;
    }
  }
}

class Player {
  final String name;
  final Role role;
  bool alive = true;
  Player(this.name, this.role);
}

// -----------------------------------------------------------------------------
//  GAME STATE
// -----------------------------------------------------------------------------
enum Phase { setup, reveal, nightIntro, night, dayResult, voting, voteResult, gameOver }
enum Winner { mafia, town, joker }

class GameState extends ChangeNotifier {
  Lang lang = Lang.ar;

  int playerCount = 8;
  int mafiaCount = 2;
  final Map<Role, bool> enabled = {
    Role.doctor: true,
    Role.investigator: true,
    Role.sniper: false,
    Role.joker: false,
  };
  final List<TextEditingController> nameCtrls =
      List.generate(15, (i) => TextEditingController());

  Phase phase = Phase.setup;
  List<Player> players = [];
  int turnIndex = 0;
  bool revealed = false;
  int round = 1;
  bool sniperBulletUsed = false;
  Winner? winner;

  final Map<int, int> mafiaVotes = {};
  int? doctorTarget;
  int? sniperTarget;
  int? inspectResultFor;

  List<int> nightDeaths = [];
  int? votedOutIdx;

  String t(String k) => L10n.t(k, lang);
  bool get isRtl => lang == Lang.ar;

  void toggleLang() {
    lang = lang == Lang.ar ? Lang.en : Lang.ar;
    notifyListeners();
  }

  int get specialCount => enabled.values.where((v) => v).length;
  bool get configValid => mafiaCount + specialCount <= playerCount;

  void setPlayerCount(int n) {
    playerCount = n.clamp(6, 15);
    notifyListeners();
  }

  void setMafiaCount(int n) {
    mafiaCount = n.clamp(1, 3);
    notifyListeners();
  }

  void toggleRole(Role r) {
    enabled[r] = !(enabled[r] ?? false);
    notifyListeners();
  }

  void startGame() {
    if (!configValid) return;
    final roles = <Role>[
      ...List.filled(mafiaCount, Role.mafia),
      ...enabled.entries.where((e) => e.value).map((e) => e.key),
    ];
    while (roles.length < playerCount) {
      roles.add(Role.villager);
    }
    roles.shuffle(Random());
    players = List.generate(playerCount, (i) {
      final raw = nameCtrls[i].text.trim();
      return Player(raw.isEmpty ? '${t('player')} ${i + 1}' : raw, roles[i]);
    });
    round = 1;
    sniperBulletUsed = false;
    winner = null;
    turnIndex = 0;
    revealed = false;
    phase = Phase.reveal;
    notifyListeners();
  }

  List<int> get aliveIdx =>
      [for (int i = 0; i < players.length; i++) if (players[i].alive) i];

  Player get current => players[turnIndex];

  void reveal() {
    revealed = true;
    notifyListeners();
  }

  bool _advanceTurn() {
    revealed = false;
    inspectResultFor = null;
    for (int i = turnIndex + 1; i < players.length; i++) {
      if (players[i].alive) {
        turnIndex = i;
        return true;
      }
    }
    return false;
  }

  void nextReveal() {
    if (!_advanceTurn()) phase = Phase.nightIntro;
    notifyListeners();
  }

  void beginNight() {
    mafiaVotes.clear();
    doctorTarget = null;
    sniperTarget = null;
    if (aliveIdx.isNotEmpty) {
      turnIndex = aliveIdx.first;
    }
    revealed = false;
    phase = Phase.night;
    notifyListeners();
  }

  void submitNightAction(int? target) {
    final role = current.role;
    switch (role) {
      case Role.mafia:
        if (target != null) mafiaVotes[turnIndex] = target;
        break;
      case Role.doctor:
        doctorTarget = target;
        break;
      case Role.sniper:
        if (target != null && !sniperBulletUsed) {
          sniperTarget = target;
          sniperBulletUsed = true;
        }
        break;
      default:
        break;
    }
    if (!_advanceTurn()) _resolveNight();
    notifyListeners();
  }

  void inspect(int target) {
    inspectResultFor = target;
    notifyListeners();
  }

  void _resolveNight() {
    nightDeaths = [];
    
    // 1. Resolve Mafia Vote
    int? mafiaKill;
    if (mafiaVotes.isNotEmpty) {
      final tally = <int, int>{};
      for (final v in mafiaVotes.values) {
        tally[v] = (tally[v] ?? 0) + 1;
      }
      final top = tally.values.reduce(max);
      final candidates = tally.keys.where((k) => tally[k] == top).toList()..shuffle();
      mafiaKill = candidates.first;
      
      if (mafiaKill != doctorTarget) {
        nightDeaths.add(mafiaKill);
      }
    }

    // 2. Resolve Sniper Action
    if (sniperTarget != null) {
      final targetRole = players[sniperTarget!].role;
      final sniperIdx = players.indexWhere((p) => p.role == Role.sniper && p.alive);

      if (targetRole == Role.mafia) {
        // Successful shot on Mafia
        if (sniperTarget != doctorTarget && !nightDeaths.contains(sniperTarget)) {
          nightDeaths.add(sniperTarget!);
        }
      } else {
        // Wrong shot: BOTH target and Sniper die!
        if (sniperTarget != doctorTarget && !nightDeaths.contains(sniperTarget)) {
          nightDeaths.add(sniperTarget!);
        }
        if (sniperIdx != -1 && !nightDeaths.contains(sniperIdx)) {
          nightDeaths.add(sniperIdx);
        }
      }
    }

    // Apply deaths
    for (final d in nightDeaths) {
      players[d].alive = false;
    }
    
    phase = _checkWin() ? Phase.gameOver : Phase.dayResult;
  }

  void startVoting() {
    phase = Phase.voting;
    notifyListeners();
  }

  void submitVote(int? idx) {
    votedOutIdx = idx;
    if (idx != null) {
      players[idx].alive = false;
      if (players[idx].role == Role.joker) {
        winner = Winner.joker;
        phase = Phase.gameOver;
        notifyListeners();
        return;
      }
    }
    phase = Phase.voteResult;
    notifyListeners();
  }

  void afterVote() {
    if (_checkWin()) {
      phase = Phase.gameOver;
    } else {
      round++;
      phase = Phase.nightIntro;
    }
    notifyListeners();
  }

  bool _checkWin() {
    final alive = players.where((p) => p.alive).toList();
    final m = alive.where((p) => p.role == Role.mafia).length;
    final others = alive.length - m;
    if (m == 0) {
      winner = Winner.town;
      return true;
    }
    if (m >= others) {
      winner = Winner.mafia;
      return true;
    }
    return false;
  }

  void reset() {
    phase = Phase.setup;
    players = [];
    notifyListeners();
  }
}

// -----------------------------------------------------------------------------
//  APP ROOT & SHELL
// -----------------------------------------------------------------------------
class MafiaApp extends StatefulWidget {
  const MafiaApp({super.key});
  @override
  State<MafiaApp> createState() => _MafiaAppState();
}

class _MafiaAppState extends State<MafiaApp> {
  final game = GameState();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: game,
      builder: (context, _) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Mafia',
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: AppColors.bg,
          colorScheme: const ColorScheme.dark(
            primary: AppColors.accent,
            secondary: AppColors.accent2,
            surface: AppColors.surface,
          ),
          useMaterial3: true,
        ),
        builder: (context, child) => Directionality(
          textDirection: game.isRtl ? TextDirection.rtl : TextDirection.ltr,
          child: child!,
        ),
        home: GameShell(game: game),
      ),
    );
  }
}

class GameShell extends StatelessWidget {
  final GameState game;
  const GameShell({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    Widget screen;
    switch (game.phase) {
      case Phase.setup:
        screen = SetupScreen(game: game);
        break;
      case Phase.reveal:
        screen = RevealScreen(game: game);
        break;
      case Phase.nightIntro:
        screen = NightIntroScreen(game: game);
        break;
      case Phase.night:
        screen = NightScreen(game: game);
        break;
      case Phase.dayResult:
        screen = DayResultScreen(game: game);
        break;
      case Phase.voting:
        screen = VotingScreen(game: game);
        break;
      case Phase.voteResult:
        screen = VoteResultScreen(game: game);
        break;
      case Phase.gameOver:
        screen = GameOverScreen(game: game);
        break;
    }
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -1.1),
            radius: 1.4,
            colors: [Color(0xFF241A3A), AppColors.bg],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              TopBar(game: game),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 380),
                  transitionBuilder: (c, a) => FadeTransition(
                    opacity: a,
                    child: ScaleTransition(
                        scale: Tween(begin: 0.96, end: 1.0).animate(a), child: c),
                  ),
                  child: KeyedSubtree(
                    key: ValueKey('${game.phase}-${game.turnIndex}-${game.round}'),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 520),
                        child: screen,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
//  WIDGETS & SCREENS
// -----------------------------------------------------------------------------
class TopBar extends StatelessWidget {
  final GameState game;
  const TopBar({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Row(
        children: [
          if (game.phase != Phase.setup) PhaseTracker(game: game) else const Spacer(),
          if (game.phase != Phase.setup) const Spacer(),
          GestureDetector(
            onTap: game.toggleLang,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.surfaceHi,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.accent2.withValues(alpha: .5)),
              ),
              child: Text(game.lang == Lang.ar ? 'EN' : 'ع',
                  style: const TextStyle(
                      color: AppColors.accent2, fontWeight: FontWeight.w800)),
            ),
          ),
        ],
      ),
    );
  }
}

class PhaseTracker extends StatelessWidget {
  final GameState game;
  const PhaseTracker({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final p = game.phase;
    int active;
    if (p == Phase.reveal) {
      active = -1;
    } else if (p == Phase.nightIntro || p == Phase.night) {
      active = 0;
    } else if (p == Phase.dayResult) {
      active = 1;
    } else if (p == Phase.voting || p == Phase.voteResult) {
      active = 2;
    } else {
      active = 3;
    }
    final labels = [game.t('night'), game.t('day'), game.t('vote')];
    final icons = [Icons.nightlight_round, Icons.wb_sunny, Icons.how_to_vote];
    return Row(children: [
      Text('${game.t('round')} ${game.round}',
          style: const TextStyle(color: AppColors.muted, fontSize: 12)),
      const SizedBox(width: 8),
      for (int i = 0; i < 3; i++)
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsetsDirectional.only(end: 6),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: i == active ? AppColors.accent.withValues(alpha: .15) : AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
                color: i == active ? AppColors.accent : Colors.transparent),
            boxShadow: i == active
                ? [BoxShadow(color: AppColors.accent.withValues(alpha: .4), blurRadius: 12)]
                : null,
          ),
          child: Row(children: [
            Icon(icons[i],
                size: 14, color: i == active ? AppColors.accent : AppColors.muted),
            const SizedBox(width: 4),
            Text(labels[i],
                style: TextStyle(
                    fontSize: 12,
                    color: i == active ? AppColors.accent : AppColors.muted)),
          ]),
        ),
    ]);
  }
}

class GlowButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final Color color;
  final IconData? icon;
  final bool outlined;
  const GlowButton(
      {super.key,
      required this.label,
      this.onTap,
      this.color = AppColors.accent,
      this.icon,
      this.outlined = false});

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null;
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: disabled ? .4 : 1,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 18),
            decoration: BoxDecoration(
              color: outlined ? Colors.transparent : color,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: color, width: 2),
              boxShadow: outlined || disabled
                  ? null
                  : [BoxShadow(color: color.withValues(alpha: .45), blurRadius: 22)],
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              if (icon != null) ...[
                Icon(icon, color: outlined ? color : AppColors.bg),
                const SizedBox(width: 8),
              ],
              Text(label,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: outlined ? color : AppColors.bg)),
            ]),
          ),
        ),
      ),
    );
  }
}

class GlassCard extends StatelessWidget {
  final Widget child;
  final Color glow;
  final EdgeInsets padding;
  const GlassCard(
      {super.key,
      required this.child,
      this.glow = AppColors.accent2,
      this.padding = const EdgeInsets.all(18)});

  @override
  Widget build(BuildContext context) => Container(
        padding: padding,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: glow.withValues(alpha: .35), width: 1.5),
          boxShadow: [BoxShadow(color: glow.withValues(alpha: .12), blurRadius: 24)],
        ),
        child: child,
      );
}

class SectionTitle extends StatelessWidget {
  final String text;
  const SectionTitle(this.text, {super.key});
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 10, top: 6),
        child: Text(text,
            style: const TextStyle(
                color: AppColors.muted,
                fontSize: 13,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w700)),
      );
}

class Stepper2 extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;
  const Stepper2({super.key, required this.value, required this.onChanged});

  Widget _btn(IconData i, VoidCallback f) => InkWell(
        onTap: f,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
              color: AppColors.surfaceHi, borderRadius: BorderRadius.circular(12)),
          child: Icon(i, color: AppColors.accent),
        ),
      );

  @override
  Widget build(BuildContext context) => Row(mainAxisSize: MainAxisSize.min, children: [
        _btn(Icons.remove, () => onChanged(value - 1)),
        SizedBox(
            width: 44,
            child: Text('$value',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900))),
        _btn(Icons.add, () => onChanged(value + 1)),
      ]);
}

class PlayerTile extends StatelessWidget {
  final Player player;
  final bool selected;
  final Color color;
  final VoidCallback? onTap;
  const PlayerTile(
      {super.key,
      required this.player,
      required this.selected,
      this.color = AppColors.accent,
      this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: selected ? color.withValues(alpha: .18) : AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color: selected ? color : AppColors.surfaceHi, width: 2),
            boxShadow: selected
                ? [BoxShadow(color: color.withValues(alpha: .4), blurRadius: 16)]
                : null,
          ),
          child: Row(children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: selected ? color : AppColors.surfaceHi,
              child: Text(player.name.characters.first.toUpperCase(),
                  style: TextStyle(
                      color: selected ? AppColors.bg : AppColors.text,
                      fontWeight: FontWeight.w800)),
            ),
            const SizedBox(width: 10),
            Expanded(
                child: Text(player.name,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w700))),
          ]),
        ),
      );
}

class TargetGrid extends StatelessWidget {
  final List<Player> all;
  final List<int> options;
  final int? selected;
  final Color color;
  final ValueChanged<int> onSelect;
  const TargetGrid(
      {super.key,
      required this.all,
      required this.options,
      required this.selected,
      required this.onSelect,
      this.color = AppColors.accent});

  @override
  Widget build(BuildContext context) => GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 3.0,
        children: [
          for (final i in options)
            PlayerTile(
                player: all[i],
                selected: selected == i,
                color: color,
                onTap: () => onSelect(i)),
        ],
      );
}

class PassGate extends StatelessWidget {
  final GameState game;
  const PassGate({super.key, required this.game});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(Icons.smartphone, size: 72, color: AppColors.accent2),
          const SizedBox(height: 20),
          Text(game.t('passTo'),
              style: const TextStyle(color: AppColors.muted, fontSize: 18)),
          const SizedBox(height: 8),
          Text(game.current.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                  color: AppColors.accent,
                  shadows: [Shadow(color: AppColors.accent, blurRadius: 24)])),
          const SizedBox(height: 40),
          GlowButton(
              label: game.t('reveal'),
              icon: Icons.visibility,
              onTap: game.reveal),
        ]),
      );
}

class RoleCard extends StatelessWidget {
  final Role role;
  final Lang lang;
  const RoleCard({super.key, required this.role, required this.lang});

  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutBack,
        builder: (c, v, child) => Transform.scale(scale: .8 + .2 * v, child: child),
        child: GlassCard(
          glow: role.color,
          padding: const EdgeInsets.all(28),
          child: Column(children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: role.color.withValues(alpha: .15),
                boxShadow: [BoxShadow(color: role.color.withValues(alpha: .5), blurRadius: 30)],
              ),
              child: Icon(role.icon, size: 56, color: role.color),
            ),
            const SizedBox(height: 18),
            Text(role.name(lang),
                style: TextStyle(
                    fontSize: 34, fontWeight: FontWeight.w900, color: role.color)),
            const SizedBox(height: 10),
            Text(role.desc(lang),
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.text, height: 1.5)),
          ]),
        ),
      );
}

class SetupScreen extends StatelessWidget {
  final GameState game;
  const SetupScreen({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return ListView(padding: const EdgeInsets.all(20), children: [
      Text(game.t('title'),
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontSize: 52,
              fontWeight: FontWeight.w900,
              letterSpacing: 4,
              color: AppColors.accent,
              shadows: [Shadow(color: AppColors.accent, blurRadius: 30)])),
      Text(game.t('subtitle'),
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.muted, fontSize: 16)),
      const SizedBox(height: 24),
      GlassCard(
        child: Column(children: [
          Row(children: [
            Expanded(
                child: Text(game.t('players'),
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16))),
            Stepper2(value: game.playerCount, onChanged: game.setPlayerCount),
          ]),
          const Divider(color: AppColors.surfaceHi, height: 28),
          Row(children: [
            Expanded(
                child: Text(game.t('mafiaCount'),
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16))),
            Stepper2(value: game.mafiaCount, onChanged: game.setMafiaCount),
          ]),
        ]),
      ),
      const SizedBox(height: 16),
      SectionTitle(game.t('specialRoles')),
      Wrap(spacing: 10, runSpacing: 10, children: [
        for (final r in game.enabled.keys)
          FilterChip(
            selected: game.enabled[r]!,
            onSelected: (_) => game.toggleRole(r),
            avatar: Icon(r.icon,
                size: 18, color: game.enabled[r]! ? AppColors.bg : r.color),
            label: Text(r.name(game.lang)),
            showCheckmark: false,
            selectedColor: r.color,
            backgroundColor: AppColors.surface,
            labelStyle: TextStyle(
                fontWeight: FontWeight.w700,
                color: game.enabled[r]! ? AppColors.bg : AppColors.text),
            side: BorderSide(color: r.color.withValues(alpha: .6)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
      ]),
      const SizedBox(height: 16),
      SectionTitle(game.t('playerNames')),
      for (int i = 0; i < game.playerCount; i++)
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: TextField(
            controller: game.nameCtrls[i],
            decoration: InputDecoration(
              hintText: '${game.t('player')} ${i + 1}',
              filled: true,
              fillColor: AppColors.surface,
              prefixIcon: const Icon(Icons.person, color: AppColors.muted),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppColors.accent2)),
            ),
          ),
        ),
      const SizedBox(height: 12),
      if (!game.configValid)
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(game.t('tooManyRoles'),
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.danger)),
        ),
      GlowButton(
          label: game.t('start'),
          icon: Icons.play_arrow,
          onTap: game.configValid ? game.startGame : null),
      const SizedBox(height: 24),
    ]);
  }
}

class RevealScreen extends StatelessWidget {
  final GameState game;
  const RevealScreen({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    if (!game.revealed) return PassGate(game: game);
    final me = game.current;
    final team = me.role == Role.mafia
        ? game.players.where((p) => p.role == Role.mafia && p != me).map((p) => p.name)
        : const Iterable<String>.empty();
    return ListView(padding: const EdgeInsets.all(24), children: [
      Center(
          child: Text(game.t('yourRole'),
              style: const TextStyle(color: AppColors.muted, fontSize: 16))),
      const SizedBox(height: 12),
      RoleCard(role: me.role, lang: game.lang),
      if (team.isNotEmpty) ...[
        const SizedBox(height: 16),
        GlassCard(
          glow: AppColors.danger,
          child: Column(children: [
            Text(game.t('yourTeam'),
                style: const TextStyle(color: AppColors.danger, fontWeight: FontWeight.w800)),
            const SizedBox(height: 6),
            Text(team.join('  •  '), style: const TextStyle(fontSize: 18)),
          ]),
        ),
      ],
      const SizedBox(height: 28),
      GlowButton(
          label: game.t('hideNext'),
          icon: Icons.visibility_off,
          color: AppColors.accent2,
          onTap: game.nextReveal),
    ]);
  }
}

class NightIntroScreen extends StatelessWidget {
  final GameState game;
  const NightIntroScreen({super.key, required this.game});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(Icons.nightlight_round,
              size: 96,
              color: AppColors.accent2,
              shadows: [Shadow(color: AppColors.accent2, blurRadius: 40)]),
          const SizedBox(height: 24),
          Text('${game.t('night')} ${game.round}',
              style: const TextStyle(fontSize: 38, fontWeight: FontWeight.w900)),
          const SizedBox(height: 10),
          Text(game.t('nightFalls'),
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.muted, fontSize: 16)),
          const SizedBox(height: 40),
          GlowButton(
              label: game.t('beginNight'),
              color: AppColors.accent2,
              onTap: game.beginNight),
        ]),
      );
}

class NightScreen extends StatefulWidget {
  final GameState game;
  const NightScreen({super.key, required this.game});
  @override
  State<NightScreen> createState() => _NightScreenState();
}

class _NightScreenState extends State<NightScreen> {
  int? selected;

  @override
  Widget build(BuildContext context) {
    final g = widget.game;
    if (!g.revealed) return PassGate(game: g);
    final me = g.current;
    final role = me.role;
    final alive = g.aliveIdx;

    String? prompt;
    List<int> options = alive;
    bool canSkip = false;
    switch (role) {
      case Role.mafia:
        prompt = g.t('chooseKill');
        options = alive.where((i) => g.players[i].role != Role.mafia).toList();
        break;
      case Role.doctor:
        prompt = g.t('chooseSave');
        break;
      case Role.investigator:
        prompt = g.t('chooseInspect');
        options = alive.where((i) => i != g.turnIndex).toList();
        break;
      case Role.sniper:
        if (!g.sniperBulletUsed) {
          prompt = g.t('chooseShoot');
          options = alive.where((i) => i != g.turnIndex).toList();
          canSkip = true;
        }
        break;
      default:
        break;
    }

    final header = Row(children: [
      Icon(role.icon, color: role.color),
      const SizedBox(width: 8),
      Text('${me.name} • ${role.name(g.lang)}',
          style: TextStyle(color: role.color, fontWeight: FontWeight.w800, fontSize: 18)),
    ]);

    if (prompt == null) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          header,
          const SizedBox(height: 24),
          GlassCard(
            glow: role.color,
            child: Text(
                role == Role.sniper ? g.t('noBullet') : g.t('noAction'),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, height: 1.5)),
          ),
          const SizedBox(height: 28),
          GlowButton(
              label: g.t('continue'),
              color: AppColors.accent2,
              onTap: () => g.submitNightAction(null)),
        ]),
      );
    }

    final inspected = g.inspectResultFor;
    return ListView(padding: const EdgeInsets.all(20), children: [
      header,
      const SizedBox(height: 14),
      Text(prompt, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
      const SizedBox(height: 14),
      if (role == Role.investigator && inspected != null)
        GlassCard(
          glow: g.players[inspected].role == Role.mafia
              ? AppColors.danger
              : AppColors.success,
          child: Text(
            '${g.players[inspected].name} ${g.players[inspected].role == Role.mafia ? g.t('isMafia') : g.t('notMafia')}',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: g.players[inspected].role == Role.mafia
                    ? AppColors.danger
                    : AppColors.success),
          ),
        )
      else
        TargetGrid(
            all: g.players,
            options: options,
            selected: selected,
            color: role.color,
            onSelect: (i) => setState(() => selected = i)),
      const SizedBox(height: 22),
      if (role == Role.investigator && inspected == null)
        GlowButton(
            label: g.t('confirm'),
            color: role.color,
            onTap: selected == null ? null : () => g.inspect(selected!))
      else if (role == Role.investigator)
        GlowButton(
            label: g.t('hideNext'),
            color: AppColors.accent2,
            onTap: () => g.submitNightAction(null))
      else ...[
        GlowButton(
            label: g.t('confirm'),
            color: role.color,
            onTap: selected == null ? null : () => g.submitNightAction(selected)),
        if (canSkip) ...[
          const SizedBox(height: 10),
          GlowButton(
              label: g.t('skip'),
              outlined: true,
              color: AppColors.muted,
              onTap: () => g.submitNightAction(null)),
        ],
      ],
    ]);
  }
}

class DayResultScreen extends StatelessWidget {
  final GameState game;
  const DayResultScreen({super.key, required this.game});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(Icons.wb_sunny,
              size: 90,
              color: AppColors.accent,
              shadows: [Shadow(color: AppColors.accent, blurRadius: 40)]),
          const SizedBox(height: 16),
          Text(game.t('morning'),
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900)),
          const SizedBox(height: 24),
          if (game.nightDeaths.isEmpty)
            GlassCard(
                glow: AppColors.success,
                child: Text(game.t('quietNight'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 20,
                        color: AppColors.success,
                        fontWeight: FontWeight.w800)))
          else
            for (final d in game.nightDeaths)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: GlassCard(
                  glow: AppColors.danger,
                  child: Text('💀 ${game.players[d].name} ${game.t('wasKilled')}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 20,
                          color: AppColors.danger,
                          fontWeight: FontWeight.w800)),
                ),
              ),
          const SizedBox(height: 36),
          GlowButton(
              label: game.t('discuss'),
              icon: Icons.forum,
              onTap: game.startVoting),
        ]),
      );
}

class VotingScreen extends StatefulWidget {
  final GameState game;
  const VotingScreen({super.key, required this.game});
  @override
  State<VotingScreen> createState() => _VotingScreenState();
}

class _VotingScreenState extends State<VotingScreen> {
  int? selected;

  @override
  Widget build(BuildContext context) {
    final g = widget.game;
    return ListView(padding: const EdgeInsets.all(20), children: [
      Text(g.t('whoOut'),
          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900)),
      const SizedBox(height: 16),
      TargetGrid(
          all: g.players,
          options: g.aliveIdx,
          selected: selected,
          color: AppColors.danger,
          onSelect: (i) => setState(() => selected = i)),
      const SizedBox(height: 22),
      GlowButton(
          label: g.t('confirm'),
          icon: Icons.how_to_vote,
          color: AppColors.danger,
          onTap: selected == null
              ? null
              : () => _confirm(context, g, selected!)),
      const SizedBox(height: 10),
      GlowButton(
          label: g.t('noElim'),
          outlined: true,
          color: AppColors.muted,
          onTap: () => g.submitVote(null)),
    ]);
  }

  void _confirm(BuildContext context, GameState g, int idx) {
    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: g.isRtl ? TextDirection.rtl : TextDirection.ltr,
        child: Dialog(
          backgroundColor: Colors.transparent,
          child: GlassCard(
            glow: AppColors.danger,
            padding: const EdgeInsets.all(24),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.gavel, size: 48, color: AppColors.danger),
              const SizedBox(height: 12),
              Text(g.players[idx].name,
                  style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900)),
              const SizedBox(height: 20),
              GlowButton(
                  label: g.t('confirm'),
                  color: AppColors.danger,
                  onTap: () {
                    Navigator.pop(ctx);
                    g.submitVote(idx);
                  }),
              const SizedBox(height: 8),
              GlowButton(
                  label: g.t('skip'),
                  outlined: true,
                  color: AppColors.muted,
                  onTap: () => Navigator.pop(ctx)),
            ]),
          ),
        ),
      ),
    );
  }
}

class VoteResultScreen extends StatelessWidget {
  final GameState game;
  const VoteResultScreen({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final idx = game.votedOutIdx;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        if (idx == null)
          GlassCard(
              child: Text(game.t('nobodyOut'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)))
        else ...[
          Text('${game.players[idx].name} ${game.t('votedOut')}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, color: AppColors.muted)),
          const SizedBox(height: 16),
          RoleCard(role: game.players[idx].role, lang: game.lang),
        ],
        const SizedBox(height: 32),
        GlowButton(label: game.t('continue'), onTap: game.afterVote),
      ]),
    );
  }
}

class GameOverScreen extends StatelessWidget {
  final GameState game;
  const GameOverScreen({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final w = game.winner ?? Winner.town;
    String label = '';
    Color color = AppColors.success;
    IconData icon = Icons.emoji_events;

    if (w == Winner.mafia) {
      label = game.t('winMafia');
      color = AppColors.danger;
      icon = Role.mafia.icon;
    } else if (w == Winner.town) {
      label = game.t('winTown');
      color = AppColors.success;
      icon = Icons.emoji_events;
    } else if (w == Winner.joker) {
      label = game.t('winJoker');
      color = Role.joker.color;
      icon = Role.joker.icon;
    }

    return ListView(padding: const EdgeInsets.all(24), children: [
      const SizedBox(height: 10),
      Icon(icon, size: 96, color: color, shadows: [Shadow(color: color, blurRadius: 40)]),
      const SizedBox(height: 12),
      Center(
          child: Text(game.t('gameOver'),
              style: const TextStyle(color: AppColors.muted, fontSize: 16))),
      Center(
          child: Text(label,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 34, fontWeight: FontWeight.w900, color: color))),
      const SizedBox(height: 24),
      SectionTitle(game.t('roles')),
      for (final p in game.players)
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: GlassCard(
            glow: p.role.color,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(children: [
              Icon(p.role.icon, color: p.role.color),
              const SizedBox(width: 12),
              Expanded(
                  child: Text(p.name,
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          decoration: p.alive ? null : TextDecoration.lineThrough,
                          color: p.alive ? AppColors.text : AppColors.muted))),
              Text(p.role.name(game.lang),
                  style: TextStyle(color: p.role.color, fontWeight: FontWeight.w800)),
              if (!p.alive) ...[
                const SizedBox(width: 8),
                Text('(${game.t('dead')})',
                    style: const TextStyle(color: AppColors.muted, fontSize: 12)),
              ],
            ]),
          ),
        ),
      const SizedBox(height: 20),
      GlowButton(label: game.t('playAgain'), icon: Icons.replay, onTap: game.reset),
    ]);
  }
}