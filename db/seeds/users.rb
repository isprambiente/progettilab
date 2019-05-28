puts "UTENTI"
@system = User.unscoped.find_or_create_by(username: 'system')
@system.update(locked_at: nil, label: 'System') unless @system.blank?
@torri = User.unscoped.find_or_create_by(username: 'giancarlo.torri', label: 'Torri Giancarlo')
@torri.update(headtest: true, chief: true, locked_at: nil) unless @torri.blank?
@bidolli = User.unscoped.find_or_create_by(username: 'gentilina.bidolli', label: 'Bidolli Gentilina')
@bidolli.update(locked_at: nil)
@blasi = User.unscoped.find_or_create_by(username: 'massimo.blasi', label: 'Blasi Massimo')
@blasi.update(technic: true, locked_at: nil)
@buchetti = User.unscoped.find_or_create_by(username: 'monica.buchetti', label: 'Buchetti Monica')
@buchetti.update(technic: true, locked_at: nil)
@cavaioli = User.unscoped.find_or_create_by(username: 'marco.cavaioli', label: 'Cavaioli Marco')
@cavaioli.update(technic: true, locked_at: nil)
@dilullo = User.unscoped.find_or_create_by(username: 'antonio.dilullo', label: 'Di Lullo Antonio')
@dilullo.update(technic: true, locked_at: nil)
@fontani = User.unscoped.find_or_create_by(username: 'sonia.fontani', label: 'Fontani Sonia')
@fontani.update(locked_at: nil)
@guogang = User.unscoped.find_or_create_by(username: 'jia.guogang')
@guogang.unlock_access!
@guogang.update(headtest: true, locked_at: nil, label: 'Guogang Jia')
@innocenzip = User.unscoped.find_or_create_by(username: 'piera.innocenzi', label: 'Innocenzi Piera')
@innocenzip.update(technic: true, headtest: true, locked_at: nil)
@innocenziv = User.unscoped.find_or_create_by(username: 'valeria.innocenzi', label: 'Innocenzi Valeria')
@innocenziv.update(locked_at: nil)
@leone = User.unscoped.find_or_create_by(username: 'patrizia.leone', label: 'Leone Patrizia')
@leone.update(locked_at: nil)
@magro = User.unscoped.find_or_create_by(username: 'leandro.magro', label: 'Magro Leandro')
@magro.update(headtest: true, locked_at: nil)
@mariani = User.unscoped.find_or_create_by(username: 'sara.mariani', label: 'Mariani Sara')
@mariani.update(headtest: true, locked_at: nil)
@menna = User.unscoped.find_or_create_by(username: 'giuseppe.menna', label: 'Menna Giuseppe')
@menna.update(chief: true, locked_at: nil)
@salvi = User.unscoped.find_or_create_by(username: 'francesco.salvi', label: 'Salvi Francesco')
@salvi.update(locked_at: nil)
@sotgiu = User.unscoped.find_or_create_by(headtest: true, username: 'anna.sotgiu', label: 'Sotgiu Anna')
@sotgiu.update(locked_at: nil)