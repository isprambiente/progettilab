puts "NUCLIDI"

nuclides = [
  "(BA+LA)140",
  "(NB+ZR)95",
  "(RU+RH)106",
  "(TE+I)132",
  "AC-228",
  "AG-110",
  "AG-110M",
  "AM-241",
  "AS-76",
  "BA-133",
  "BA-140",
  "BE-7",
  "BI-212",
  "BI-214",
  "C-14",
  "CD-109",
  "CE-139",
  "CE-141",
  "CE-142",
  "CE-143",
  "CE-144",
  "CM-242",
  "CM-244",
  "CO-57",
  "CO-58",
  "CO-60",
  "CR-51",
  "CS(134+137)",
  "CS-131",
  "CS-132",
  "CS-134",
  "CS-136",
  "CS-137",
  "EU-152",
  "EU-154",
  "EU-155",
  "FE-59",
  "FL-18",
  "H-3",
  "HF-181",
  "HG-203",
  "I-123",
  "I-125",
  "I-129",
  "I-131",
  "I-131(G)",
  "I-131(P)",
  "I-131(P+G)",
  "I-132",
  "I-133",
  "I-135",
  "IN-111",
  "K-40",
  "K-42",
  "KR-85",
  "LA-140",
  "LA-141",
  "MN-54",
  "MO-99",
  "MO99+TC99M",
  "NA-22",
  "NA-24",
  "NB-95",
  "NB-97",
  "NP-237",
  "NP-239",
  "PA-233",
  "PA-234",
  "PB-210",
  "PB-212",
  "PB-214",
  "PO-210",
  "PU(239+240)",
  "PU-238",
  "PU-239",
  "PU-240",
  "RA-224",
  "RA-226",
  "RA-238",
  "Rateo dose gamma in aria",
  "Beta residuo",
  "RN-222",
  "RU-103",
  "RU-104",
  "RU-105",
  "RU-106",
  "SB-124",
  "SB-125",
  "SB-127",
  "SB-129",
  "SR(89+90)",
  "SR-85",
  "SR-89",
  "SR-90",
  "SR-91",
  "SR-92",
  "Alfa totale",
  "Beta totale",
  "TC-99",
  "TC-99M",
  "TH-228",
  "TH-230",
  "TH-232",
  "TH-234",
  "TL-201",
  "TL-208",
  "T-U",
  "U-234",
  "U-235",
  "U-238",
  "XE-127",
  "XE-131M",
  "XE-133",
  "XE-135",
  "Y-88",
  "Y-90",
  "Y-91",
  "Y-92",
  "Y-93",
  "ZR-95",
  "ZR-97",
  "Contaminazione superficiale",
  "Contaminazione superficiale (beta /gamma)",
  "Contaminazione superficiale (alfa)",
  "Contaminazione superficiale (beta)",
  "Contaminazione superficiale (gamma)"
]

nuclides.map{ |a| Nuclide.create( title: a, author: 'System' ) }