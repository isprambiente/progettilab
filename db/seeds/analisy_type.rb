puts "TIPO ANALISI"

analisy_types = [
  "Concentrazione di attività di radon in aria (SSNTD's)",
  "Esposizione di radon in aria (SSNTD's)",
  "Concentrazione/esposizione di radon in aria (SSNTD's)",
  "Conteggio basso fondo contatore proporzionale flusso di gas",
  "Spettrometria gamma",
  "Spettrometria alfa",
  "Scintillazione liquida",
  "Spettrometria di massa",
  "Contaminazione superficiale",
  "Smear test",
  "Concentrazione di attività di radon in aria (monitore)",
  "Esposizione di radon in aria (monitore)",
  "Concentrazione/esposizione di radon in aria (monitore)",
  "Rateo di dose gamma in aria: camera a ionizzazione",
  "Rateo di dose gamma in aria: geiger muller",
  "Rateo di dose gamma in aria: scintillatore organico",
  "Rateo di dose gamma in aria a contatto: geiger muller",
  "Rateo di dose gamma in aria a contatto: scintillatore organico"
]

analisy_types.map{ |a| AnalisyType.create( title: a, author: 'System' ) }


AnalisyType.where( "title ilike ?", "%radon%" ).update_all( radon: true )