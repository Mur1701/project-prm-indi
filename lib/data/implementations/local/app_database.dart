import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._init();
  static Database? _database;
  AppDatabase._init();

  Future<Database> get database async {
    _database ??= await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'li_xi_tracker.db');
    return openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // ── Tạo bảng ─────────────────────────────────────────
    await db.execute('''
      CREATE TABLE relatives (
        id         INTEGER PRIMARY KEY AUTOINCREMENT,
        name       TEXT NOT NULL,
        group_type TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE transactions (
        id          INTEGER PRIMARY KEY AUTOINCREMENT,
        amount      REAL    NOT NULL,
        type        TEXT    NOT NULL,
        relative_id INTEGER NOT NULL,
        date        TEXT    NOT NULL,
        note        TEXT    DEFAULT ""
      )
    ''');

    await db.execute('''
      CREATE TABLE wishes (
        id       INTEGER PRIMARY KEY AUTOINCREMENT,
        title    TEXT NOT NULL,
        subtitle TEXT NOT NULL
      )
    ''');

    await _seedRelatives(db);
    await _seedTransactions(db);
    await _seedWishes(db);
  }

  // Chạy khi DB version cũ hơn app version
  // v1→v2: thêm bảng wishes + seed data
  Future<void> _onUpgrade(Database db, int oldV, int newV) async {
    if (oldV < 2) {
      // Tạo bảng wishes nếu chưa có
      await db.execute('''
        CREATE TABLE IF NOT EXISTS wishes (
          id       INTEGER PRIMARY KEY AUTOINCREMENT,
          title    TEXT NOT NULL,
          subtitle TEXT NOT NULL
        )
      ''');
      // Seed 36 câu chúc
      await _seedWishes(db);
    }
  }

  // ════════════════════════════════════════════════════════
  // SEED: Người thân (đa dạng, thực tế & vui)
  // ════════════════════════════════════════════════════════
  Future<void> _seedRelatives(Database db) async {
    final data = [
      // ── Gia đình ──────────────────────────────────────
      {'name': 'Ông bà nội',   'group_type': 'family'},
      {'name': 'Ông bà ngoại', 'group_type': 'family'},
      {'name': 'Bố mẹ',        'group_type': 'family'},
      {'name': 'Anh cả',       'group_type': 'family'},
      {'name': 'Em gái Linh',  'group_type': 'family'},

      // ── Họ hàng ───────────────────────────────────────
      {'name': 'Cô Hương',     'group_type': 'relatives'},
      {'name': 'Chú Minh',     'group_type': 'relatives'},
      {'name': 'Bác Lan',      'group_type': 'relatives'},
      {'name': 'Dì Thảo',      'group_type': 'relatives'},
      {'name': 'Cậu Hùng',     'group_type': 'relatives'},
      {'name': 'Chị họ Mai',   'group_type': 'relatives'},

      // ── Thân quen (và... đặc biệt 😄) ─────────────────
      {'name': 'Người yêu Hà Nội 🌸',    'group_type': 'acquaintance'},
      {'name': 'Người yêu Sài Gòn 🌺',   'group_type': 'acquaintance'},
      {'name': 'Người yêu Đà Nẵng 🐠',   'group_type': 'acquaintance'},
      {'name': 'Bạn thân Tuấn',          'group_type': 'acquaintance'},
      {'name': 'Sếp cũ Phương',          'group_type': 'acquaintance'},
      {'name': 'Đồng nghiệp An',         'group_type': 'acquaintance'},
      {'name': 'Hàng xóm Bà Tư',         'group_type': 'acquaintance'},
    ];
    for (final r in data) await db.insert('relatives', r);
  }

  // ════════════════════════════════════════════════════════
  // SEED: Giao dịch (1 lần / người, trải Mùng 1–5)
  // ════════════════════════════════════════════════════════
  Future<void> _seedTransactions(Database db) async {
    // id relative theo thứ tự insert: 1=Ông bà nội...18=Hàng xóm Bà Tư
    final txs = [
      // Mùng 1 (17/02) - Thăm ông bà, bố mẹ
      _tx(500000,  'receive', 1, '2026-02-17 08:00', 'Mùng 1 thăm ông bà nội'),
      _tx(700000,  'receive', 2, '2026-02-17 09:30', 'Ông bà ngoại lì xì đầu năm'),
      _tx(2000000, 'receive', 3, '2026-02-17 10:00', 'Bố mẹ lì xì to nhất 😍'),
      _tx(200000,  'give',    4, '2026-02-17 11:00', 'Lì xì con anh cả'),
      _tx(150000,  'give',    5, '2026-02-17 11:30', 'Lì xì em Linh'),

      // Mùng 2 (18/02) - Thăm họ hàng
      _tx(300000,  'receive', 6,  '2026-02-18 08:30', 'Cô Hương mừng tuổi'),
      _tx(500000,  'receive', 7,  '2026-02-18 10:00', 'Chú Minh lì xì hào phóng'),
      _tx(200000,  'receive', 8,  '2026-02-18 11:15', 'Bác Lan cho ít thôi nhưng quý'),
      _tx(300000,  'receive', 9,  '2026-02-18 14:00', 'Dì Thảo ở quê lên'),
      _tx(200000,  'receive', 10, '2026-02-18 15:30', 'Cậu Hùng vừa trúng số 😄'),
      _tx(150000,  'receive', 11, '2026-02-18 16:00', 'Chị họ Mai mừng tuổi'),

      // Mùng 3 (19/02) - Gặp bạn bè, "người đặc biệt"
      _tx(1000000, 'receive', 12, '2026-02-19 09:00', 'Người yêu HN lì xì nhiều nhất 🌸'),
      _tx(800000,  'receive', 13, '2026-02-19 11:00', 'Người yêu SG bay ra chúc Tết 🌺'),
      _tx(500000,  'give',    14, '2026-02-19 14:00', 'Lì xì người yêu ĐN ngoan nhất 🐠'),
      _tx(100000,  'give',    15, '2026-02-19 16:30', 'Lì xì Tuấn bạn thân cũng nghèo như nhau'),

      // Mùng 4 (20/02) - Gặp đồng nghiệp, sếp
      _tx(500000,  'receive', 16, '2026-02-20 10:00', 'Sếp cũ vẫn nhớ mình 🥹'),
      _tx(100000,  'give',    17, '2026-02-20 11:30', 'Lì xì An đồng nghiệp tốt bụng'),
      _tx(50000,   'receive', 18, '2026-02-20 15:00', 'Bà Tư hàng xóm cho ít nhưng tình'),
    ];
    for (final t in txs) await db.insert('transactions', t);
  }

  Map<String, dynamic> _tx(double amount, String type, int relId,
      String date, String note) => {
    'amount': amount, 'type': type,
    'relative_id': relId, 'date': date, 'note': note,
  };

  // ════════════════════════════════════════════════════════
  // SEED: 36 câu chúc Tết (truyền thống + hiện đại + hài)
  // ════════════════════════════════════════════════════════
  Future<void> _seedWishes(Database db) async {
    final wishes = [
      // ── Truyền thống (12) ─────────────────────────────
      ('Vạn sự như ý',         'Chúc mừng năm mới, vạn sự như ý, sức khỏe dồi dào!'),
      ('An khang thịnh vượng', 'Năm mới an khang thịnh vượng, phúc lộc đầy nhà.'),
      ('Tứ quý bình an',       'Xuân hạ thu đông đều bình an, mọi điều tốt đẹp.'),
      ('Phát tài phát lộc',    'Năm mới phát tài phát lộc, cát tường như ý.'),
      ('Thân tâm an lạc',      'Thân khỏe, tâm bình, mọi điều kiết tường.'),
      ('Sức khỏe như sơn hà',  'Sức khỏe như sơn hà, tiền tài như nước chảy.'),
      ('Bách sự hanh thông',   'Trăm việc hanh thông, nghìn điều thuận lợi.'),
      ('Phúc thọ khang ninh',  'Chúc phúc thọ vô cương, khang ninh mãi mãi.'),
      ('Tâm tưởng sự thành',   'Hễ tâm tưởng thì sự thành — năm mới mọi ước đều đạt.'),
      ('Dư dả sung túc',       'Năm mới dư dả sung túc, không lo thiếu thốn.'),
      ('Hạnh phúc viên mãn',   'Gia đình hạnh phúc, tình duyên viên mãn.'),
      ('Niên niên hữu dư',     'Năm nào cũng dư dả — chúc bạn niên niên hữu dư!'),

      // ── Hiện đại & vui (12) ───────────────────────────
      ('Lì xì phải cân ký!',   'Chúc bạn giàu đến mức lì xì phải cân ký thay vì đếm tờ! 😂'),
      ('Pin đầy, mạng 5G',     'Năm mới sạc đầy pin, mạng 5G không giật lag, ví không bao giờ cạn!'),
      ('Tiền vào nhiều hơn ra','Tiền vào như nước, tiền ra... thôi đừng ra thì hơn! 💸'),
      ('OKE hơn năm cũ',       'Chúc năm mới OKE hơn năm cũ — mà năm cũ cũng ổn lắm rồi!'),
      ('Tăng lương, không tăng cân', 'Năm mới tăng lương, không tăng cân, tăng chiều cao thì bonus! 💪'),
      ('Deal hời, ít bill đau tim', 'Chúc nhiều deal hời, ít bill đau tim, sale 100% thì càng tốt!'),
      ('5G đầy bar, ví đầy tiền', 'Mạng 5G luôn đầy bar, ví luôn đầy tiền — chúc bạn cả hai!'),
      ('Crush không block',    'Chúc năm mới crush không block, boss không cắt thưởng, app không crash!'),
      ('Số dư tăng khi mở app','Đầu năm mở app thấy số dư tăng — năm mới chúc điều đó thành hiện thực!'),
      ('Tăng lương trước khi xin', 'Chúc bạn được sếp tăng lương trước khi kịp mở miệng xin! 😎'),
      ('Ngủ đủ giấc, lì xì đầy', 'Năm mới ngủ đủ giấc, ăn ngon, lì xì đầy túi — tam đại phúc đó!'),
      ('Luôn là version tốt nhất', 'Chúc bạn luôn là phiên bản tốt nhất của chính mình!'),

      // ── Lãng mạn (6) ──────────────────────────────────
      ('Người thương vạn an',  'Chúc người thương năm mới vạn điều may mắn, luôn tươi tắn rạng ngời!'),
      ('Yêu xa tình gần',      'Yêu xa mà tình gần — chúc mình luôn bên nhau dù cách bao xa! 🌹'),
      ('Luôn làm em cười',     'Năm mới chúc em luôn vui, anh luôn là người làm em cười nhiều nhất! ❤️'),
      ('Bên nhau mãi mãi',     'Chúc đôi mình bên nhau mãi mãi, mọi ngày đều là ngày Tết!'),
      ('Hẹn hò trăm năm',      'Năm mới chúc chúng mình từ hẹn hò đến trăm năm hạnh phúc! 💍'),
      ('Nhớ nhau là lì xì rồi', 'Xa nhau mà vẫn nhớ nhau — đó là lì xì quý giá nhất! 🥰'),

      // ── Tài lộc (6) ───────────────────────────────────
      ('Lì xì nhiều như lời chúc', 'Chúc tiền vào nhiều như lời chúc, phước lành đầy như bao lì xì!'),
      ('Cổ phiếu xanh, crypto tăng', 'Năm mới đầu tư thắng, cổ phiếu xanh, crypto tăng không ngừng! 📈'),
      ('Không nợ ai',          'Chúc năm mới tài chính tự do — hoặc ít nhất là không nợ ai! 🎉'),
      ('Bình an là báu vật',   'Bình an là báu vật, sức khỏe là vàng — chúc bạn cả hai thứ!'),
      ('Inbox nhiều tin vui',   'Năm mới inbox nhiều tin vui, ít tin buồn, hộp thư đầy lì xì!'),
      ('Vạn sự khởi đầu thuận','Năm mới vạn sự khởi đầu thuận lợi, mọi ước mơ đều thành hiện thực! 🌟'),
    ];

    for (final w in wishes) {
      await db.insert('wishes', {'title': w.$1, 'subtitle': w.$2});
    }
  }
}
