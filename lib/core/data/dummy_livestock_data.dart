/// Data dummy untuk produk peternakan (Obat, Pakan, Vitamin, Layanan)
/// Skala Nasional: Mencakup berbagai kota besar di Seluruh Indonesia
final List<Map<String, dynamic>> dummyLivestockProducts = [
  // --- KATEGORI OBAT SAPI ---
  {
    "id": "prod_001",
    "name": "Wormectin Injeksi (Obat Cacing & Scabies Sapi)",
    "description":
        "Obat suntik ampuh untuk mengobati cacingan, scabies (kudis), dan kutu pada sapi dan kambing.",
    "price": 65000,
    "type": "obat",
    "animals": ["sapi", "kambing", "domba"],
    "location": "Toko Pakan & Obat Ternak Sejahtera, Kepanjen, Malang",
    "phone": "081234567890",
  },
  {
    "id": "prod_002",
    "name": "Super Tetra / Tetrasiklin Kapsul",
    "description":
        "Antibiotik spektrum luas untuk sapi mencret, infeksi saluran nafas, dan luka. Isi 100 kapsul.",
    "price": 45000,
    "type": "obat",
    "animals": ["sapi", "kambing", "ayam"],
    "location": "Apotek Hewan KUD Karangploso, Malang",
    "phone": "085678901234",
  },
  {
    "id": "prod_003",
    "name": "Genta-100 Injeksi",
    "description":
        "Obat suntik antibiotik untuk mengobati mastitis (radang ambing) dan diare parah pada sapi perah.",
    "price": 120000,
    "type": "obat",
    "animals": ["sapi perah", "kambing"],
    "location": "Puskeswan Pujon, Malang",
    "phone": "089876543210",
  },
  {
    "id": "prod_004",
    "name": "Colibact Bolus",
    "description":
        "Obat pil besar (bolus) khusus untuk sapi mencret (diare berdarah/scours) akibat bakteri E. coli.",
    "price": 85000,
    "type": "obat",
    "animals": ["sapi", "pedet"],
    "location": "Toko Ternak Makmur Jaya, Singosari, Malang",
    "phone": "082345678901",
  },
  {
    "id": "prod_005",
    "name": "Iodine Spray (Obat Luka/Myiasis)",
    "description":
        "Obat semprot untuk luka luar, mencegah infeksi lalat (belatungan) pada sapi dan kambing.",
    "price": 35000,
    "type": "obat",
    "animals": ["sapi", "kambing", "ayam"],
    "location": "Toko Pertanian Sahabat, Turen, Malang",
    "phone": "087654321098",
  },

  // --- KATEGORI PAKAN & VITAMIN SAPI ---
  {
    "id": "prod_006",
    "name": "Konsentrat Sapi Potong (Penggemukan) Bintang 5",
    "description":
        "Pakan konsentrat tinggi protein untuk penggemukan sapi potong. Kemasan karung 50kg.",
    "price": 185000,
    "type": "pakan",
    "animals": ["sapi potong"],
    "location": "Gudang Pakan KUD Dau, Malang",
    "phone": "083456789012",
  },
  {
    "id": "prod_007",
    "name": "Premix Mineral Sapi (Mineral Blok)",
    "description":
        "Vitamin dan mineral jilat (mineral block) untuk menambah nafsu makan sapi dan mencegah kelumpuhan.",
    "price": 25000,
    "type": "vitamin",
    "animals": ["sapi", "kambing"],
    "location": "Toko Pakan & Obat Ternak Sejahtera, Kepanjen, Malang",
    "phone": "081234567890",
  },
  {
    "id": "prod_008",
    "name": "Vitamin B-Kompleks Injeksi",
    "description":
        "Vitamin suntik untuk memulihkan stamina sapi yang lesu, kurus, atau pasca melahirkan.",
    "price": 55000,
    "type": "vitamin",
    "animals": ["sapi", "kambing", "domba"],
    "location": "Apotek Hewan KUD Karangploso, Malang",
    "phone": "085678901234",
  },

  // --- KATEGORI OBAT & PAKAN AYAM ---
  {
    "id": "prod_009",
    "name": "Tetra Chlor (Kapsul Merah)",
    "description":
        "Obat ampuh untuk ayam ngorok (CRD), snot, berak kapur, dan kolera.",
    "price": 15000,
    "type": "obat",
    "animals": ["ayam", "bebek", "unggas"],
    "location": "Poultry Shop Arema, Blimbing, Kota Malang",
    "phone": "084567890123",
  },
  {
    "id": "prod_010",
    "name": "Pakan Ayam Pedaging (Broiler) BR-1",
    "description":
        "Pakan komplit crumble untuk anak ayam (starter) usia 1-21 hari. Kemasan karung 50kg.",
    "price": 380000,
    "type": "pakan",
    "animals": ["ayam pedaging"],
    "location": "Distributor Pakan Comfeed, Jabung, Malang",
    "phone": "088765432109",
  },
  {
    "id": "prod_011",
    "name": "Vaksin ND-AI (Flu Burung & Tetelo)",
    "description":
        "Vaksin injeksi untuk pencegahan massal penyakit mematikan ND dan Flu Burung pada ayam petelur.",
    "price": 110000,
    "type": "obat",
    "animals": ["ayam petelur", "ayam pedaging"],
    "location": "Klinik Hewan Satwa Sehat, Lowokwaru, Malang",
    "phone": "081122334455",
  },
  {
    "id": "prod_012",
    "name": "Vita Chicks",
    "description":
        "Vitamin serbuk larut air untuk mengurangi stres anak ayam dan mempercepat pertumbuhan.",
    "price": 25000,
    "type": "vitamin",
    "animals": ["ayam", "DOC"],
    "location": "Poultry Shop Arema, Blimbing, Kota Malang",
    "phone": "084567890123",
  },

  // --- KATEGORI OBAT KAMBING & DOMBA ---
  {
    "id": "prod_013",
    "name": "Obat Kembung (Tympany) Kambing",
    "description":
        "Cairan antasida bentuk drench untuk mengatasi perut kembung (masuk angin parah) pada kambing akibat makan rumput basah.",
    "price": 30000,
    "type": "obat",
    "animals": ["kambing", "domba"],
    "location": "Klinik Ternak Poncokusumo, Malang",
    "phone": "085566778899",
  },
  {
    "id": "prod_014",
    "name": "Salep Mata Oxytetracycline",
    "description":
        "Salep mata untuk mengobati mata belekan (pink eye) merah dan berair pada kambing dan domba.",
    "price": 20000,
    "type": "obat",
    "animals": ["kambing", "domba", "sapi"],
    "location": "Toko Pertanian Sahabat, Turen, Malang",
    "phone": "087654321098",
  },

  // --- LAYANAN DOKTER HEWAN / VET (Bisa dipanggil AI juga) ---
  {
    "id": "prod_015",
    "name": "Layanan Kunjungan Dokter Hewan Panggilan",
    "description":
        "Drh. Anton melayani pemeriksaan ternak sakit, inseminasi buatan (IB), dan operasi langsung ke kandang. Wilayah Malang Raya.",
    "price": 100000, // Tarif dasar kunjungan
    "type": "jasa",
    "animals": ["sapi", "kambing", "domba", "kuda"],
    "location": "Praktek Mandiri Drh. Anton, Pakis, Malang",
    "phone": "081333444555",
  },

  // ============================================================================
  // --- EKSPANSI DATA NASIONAL (SELURUH INDONESIA) ---
  // ============================================================================

  // --- JAWA TIMUR (SURABAYA, PASURUAN, SIDOARJO) ---
  {
    "id": "prod_016",
    "name": "Biosan TP (Obat Kembung Sapi)",
    "description": "Obat kembung sapi dan pereda kejang lambung secara cepat.",
    "price": 45000,
    "type": "obat",
    "animals": ["sapi", "kambing"],
    "location": "Toko Tani Jaya Makmur, Wonokromo, Surabaya, Jawa Timur",
    "phone": "082211334455",
  },
  {
    "id": "prod_017",
    "name": "Pakan Bebek Petelur (Layer) Pur",
    "description":
        "Pur komplit khusus bebek petelur umur >20 minggu. Sangat bagus untuk meningkatkan kualitas telur.",
    "price": 360000,
    "type": "pakan",
    "animals": ["bebek"],
    "location":
        "Distributor Pakan Ternak Sidoarjo, Sedati, Sidoarjo, Jawa Timur",
    "phone": "081199887766",
  },
  {
    "id": "prod_018",
    "name": "Layanan Vaksinasi PMK",
    "description":
        "Tim medis hewan menyediakan layanan pemanggilan untuk vaksinasi Penyakit Mulut dan Kuku (PMK).",
    "price": 150000,
    "type": "jasa",
    "animals": ["sapi", "kambing", "domba"],
    "location": "Puskeswan Pandaan, Pasuruan, Jawa Timur",
    "phone": "085544332211",
  },

  // --- JAWA BARAT & DKI JAKARTA ---
  {
    "id": "prod_019",
    "name": "Amoxitin Injeksi",
    "description":
        "Antibiotik amoxicillin berspektrum luas, aman untuk ternak bunting.",
    "price": 135000,
    "type": "obat",
    "animals": ["sapi perah", "kuda", "kambing"],
    "location":
        "Koperasi Peternak Bandung Selatan (KPBS) Pangalengan, Kab. Bandung, Jawa Barat",
    "phone": "081223344556",
  },
  {
    "id": "prod_020",
    "name": "Konsentrat Sapi Perah Super",
    "description":
        "Pakan konsentrat hijauan fermentasi dengan penambahan molase untuk meningkatkan produksi susu harian hingga 20%.",
    "price": 210000,
    "type": "pakan",
    "animals": ["sapi perah"],
    "location": "Lembang Dairy Supply, Lembang, Bandung Barat, Jawa Barat",
    "phone": "087766554433",
  },
  {
    "id": "prod_021",
    "name": "Vitamin C (Ascorbic Acid) Bubuk",
    "description":
        "Antistres paling ampuh untuk ayam pedaging dan bebek di saat cuaca ekstrem (panas).",
    "price": 50000,
    "type": "vitamin",
    "animals": ["ayam", "bebek", "unggas"],
    "location": "Poultry Shop Cipinang Jaya, Jakarta Timur, DKI Jakarta",
    "phone": "081122112211",
  },
  {
    "id": "prod_022",
    "name": "Klinik Hewan Ternak drh. Iwan",
    "description":
        "Melayani operasi caesar sapi, bedah patah tulang cempe, dan konsultasi kesehatan peternakan terintegrasi.",
    "price": 250000,
    "type": "jasa",
    "animals": ["sapi", "kambing", "kuda"],
    "location": "Klinik Satwa Besar drh. Iwan, Cibinong, Bogor, Jawa Barat",
    "phone": "085522334455",
  },

  // --- JAWA TENGAH & DI YOGYAKARTA ---
  {
    "id": "prod_023",
    "name": "Antisep (Cairan Desinfektan)",
    "description":
        "Cairan desinfektan untuk sterilisasi kandang, alat tetas telur, dan membasmi virus flu burung.",
    "price": 40000,
    "type": "obat",
    "animals": ["semua hewan"],
    "location": "Toko Pertanian Bumi Mataram, Sleman, DI Yogyakarta",
    "phone": "082133445566",
  },
  {
    "id": "prod_024",
    "name": "Pakan Puyuh Petelur (Quail Layer)",
    "description":
        "Pakan komplit bentuk tepung untuk burung puyuh petelur dewasa. Protein 20%.",
    "price": 340000,
    "type": "pakan",
    "animals": ["burung puyuh"],
    "location": "Grosir Pakan Ternak Klaten, Klaten, Jawa Tengah",
    "phone": "081299887755",
  },
  {
    "id": "prod_025",
    "name": "Ivermectin Pour On",
    "description":
        "Obat kutu tetes punggung, praktis tanpa suntik untuk memberantas ektoparasit dan cacing pada sapi.",
    "price": 115000,
    "type": "obat",
    "animals": ["sapi", "kambing"],
    "location": "Apotek Veteriner Merapi, Boyolali, Jawa Tengah",
    "phone": "085877889900",
  },

  // --- SUMATERA (MEDAN, PALEMBANG, LAMPUNG, PADANG) ---
  {
    "id": "prod_026",
    "name": "Obat Kutu Babi (Mange)",
    "description": "Obat semprot untuk membasmi kutu (mange) pada ternak babi.",
    "price": 75000,
    "type": "obat",
    "animals": ["babi"],
    "location": "Toko Ternak Toba, Tarutung, Sumatera Utara",
    "phone": "082344556677",
  },
  {
    "id": "prod_027",
    "name": "Vaksin Antraks (Spore Vaccine)",
    "description":
        "Vaksin wajib untuk sapi di daerah endemis antraks. Penjualan diawasi oleh Dinas Peternakan.",
    "price": 150000,
    "type": "obat",
    "animals": ["sapi", "kerbau"],
    "location": "Dinas Peternakan Provinsi Lampung, Bandar Lampung",
    "phone": "081199002233",
  },
  {
    "id": "prod_028",
    "name": "Konsentrat Sapi Bali",
    "description":
        "Pakan khusus pendamping hijauan untuk penggemukan ras sapi bali & limousin silangan.",
    "price": 195000,
    "type": "pakan",
    "animals": ["sapi potong", "sapi bali"],
    "location": "Gudang Agrobisnis Sriwijaya, Palembang, Sumatera Selatan",
    "phone": "081233221100",
  },
  {
    "id": "prod_029",
    "name": "Klinik Hewan Drh. Anwar",
    "description":
        "Pengobatan ternak sapi sakit keras, demam tiga hari (BEF), dan potong kuku sapi perah.",
    "price": 150000,
    "type": "jasa",
    "animals": ["kerbau", "sapi", "kuda"],
    "location": "Klinik Veteriner Andalas, Padang, Sumatera Barat",
    "phone": "087766554411",
  },

  // --- SULAWESI (MAKASSAR, MANADO) ---
  {
    "id": "prod_030",
    "name": "Enrofloxacin Injeksi",
    "description":
        "Antibiotik andalan membasmi infeksi Mycoplasma dan saluran kemih pada ternak ruminansia.",
    "price": 85000,
    "type": "obat",
    "animals": ["sapi", "kambing", "babi"],
    "location": "Apotek Ternak Panakkukang, Makassar, Sulawesi Selatan",
    "phone": "085522334488",
  },
  {
    "id": "prod_031",
    "name": "Pakan Babi Starter (Piglet)",
    "description":
        "Pakan pre-starter super untuk anak babi (piglet) lepas sapih agar tidak diare.",
    "price": 280000,
    "type": "pakan",
    "animals": ["babi"],
    "location": "Minahasa Farm Supply, Tomohon, Sulawesi Utara",
    "phone": "082199887766",
  },

  // --- BALI & NUSA TENGGARA ---
  {
    "id": "prod_032",
    "name": "Sulfadimidine Bolus (Obat Mencret Berdarah)",
    "description":
        "Obat khusus untuk koksidiosis (berak darah) parah pada sapi dan cempe.",
    "price": 90000,
    "type": "obat",
    "animals": ["sapi", "kambing"],
    "location": "Toko Tani Sanglah, Denpasar, Bali",
    "phone": "081333222111",
  },
  {
    "id": "prod_033",
    "name": "Pakan Kuda Pacu",
    "description":
        "Pakan harian energi tinggi berbentuk pelet dan butiran jagung untuk kuda pacu/kuda tunggang.",
    "price": 450000,
    "type": "pakan",
    "animals": ["kuda"],
    "location": "Sumba Equine Supply, Waingapu, Sumba Timur, NTT",
    "phone": "085277889900",
  },
  {
    "id": "prod_034",
    "name": "Klinik Hewan Ternak Drh. Putu",
    "description":
        "Melayani pengobatan sapi Bali, atensi melahirkan sungsang (distokia), dan vaksin jembrana.",
    "price": 200000,
    "type": "jasa",
    "animals": ["sapi", "kerbau", "babi"],
    "location": "Klinik Drh. Putu, Gianyar, Bali",
    "phone": "081999888777",
  },

  // --- KALIMANTAN ---
  {
    "id": "prod_035",
    "name": "Multivitamin Unggas Cair (Amino)",
    "description":
        "Campuran asam amino esensial dan vitamin cair untuk mempercepat adaptasi DOC yang baru tiba di kandang (mencegah mati stress).",
    "price": 60000,
    "type": "vitamin",
    "animals": ["ayam", "bebek", "puyuh"],
    "location": "Borneo Poultry Center, Balikpapan, Kalimantan Timur",
    "phone": "081555666777",
  },
  {
    "id": "prod_036",
    "name": "Jasa Sedot WC Kandang / Biogas",
    "description":
        "Jasa pengelolaan limbah kotoran sapi skala besar untuk integrasi sumur biogas komunal perumahan swadaya ternak.",
    "price": 450000,
    "type": "jasa",
    "animals": ["sapi", "kerbau"],
    "location": "Koperasi Peternak Mandiri, Banjarbaru, Kalimantan Selatan",
    "phone": "082344558899",
  },

  // ============================================================================
  // --- EKSPANSI DATA BARU: MULTI-REGION & MULTI-KATEGORI ---
  // ============================================================================

  // --- WILAYAH JABODETABEK & BANTEN ---
  {
    "id": "prod_037",
    "name": "Kandang Kelinci Galvanis (Baterai)",
    "description":
        "Kandang kelinci pedaging bahan kawat galvanis anti karat. Sistem baterai susun 2 tingkat.",
    "price": 350000,
    "type": "perlengkapan",
    "animals": ["kelinci"],
    "location": "Toko Kandang Ternak Jaya, Ciputat, Tangerang Selatan, Banten",
    "phone": "081223344001",
  },
  {
    "id": "prod_038",
    "name": "Konsentrat Kuda Tunggang (Equestrian)",
    "description":
        "Pakan pelet premium impor untuk kuda equestrian, memaksimalkan performa otot dan stamina.",
    "price": 600000,
    "type": "pakan",
    "animals": ["kuda"],
    "location":
        "Pondok Cabe Stable Supply, Pamulang, Tangerang Selatan, Banten",
    "phone": "081223344002",
  },
  {
    "id": "prod_039",
    "name": "Vitamin E + Selenium (Injeksi)",
    "description":
        "Meningkatkan fertilitas (kesuburan) induk sapi dan domba, mencegah retensi plasenta.",
    "price": 125000,
    "type": "vitamin",
    "animals": ["sapi", "domba", "kambing"],
    "location": "Apotek Hewan Serang, Serang, Banten",
    "phone": "081223344003",
  },
  {
    "id": "prod_040",
    "name": "Jasa USG Kebuntingan Sapi & Kuda",
    "description":
        "Layanan deteksi dini kebuntingan dengan alat USG portabel langsung di kandang peternak.",
    "price": 300000,
    "type": "jasa",
    "animals": ["sapi", "kuda", "kerbau"],
    "location": "Klinik Satwa Drh. Rina, Depok, Jawa Barat",
    "phone": "081223344004",
  },

  // --- WILAYAH JAWA TENGAH & DIY ---
  {
    "id": "prod_041",
    "name": "Pakan Entok (Itik Manila) Starter",
    "description":
        "Pakan khusus anak entok (DOE) agar tumbuh cepat dan sehat. Tekstur halus mudah dicerna.",
    "price": 330000,
    "type": "pakan",
    "animals": ["entok", "bebek"],
    "location": "Toko Pakan Ternak Magelang, Magelang, Jawa Tengah",
    "phone": "081223344005",
  },
  {
    "id": "prod_042",
    "name": "Kalium Permanganat (PK) Obat Luka Air",
    "description":
        "Serbuk PK untuk campuran air mandi atau disinfektan kolam bebek/entok mencegah jamur.",
    "price": 10000,
    "type": "obat",
    "animals": ["bebek", "unggas air"],
    "location": "Apotek Tani Bantul, Bantul, DI Yogyakarta",
    "phone": "081223344006",
  },
  {
    "id": "prod_043",
    "name": "Obat Cacing Hati Sapi (Fasciolosis)",
    "description":
        "Kapsul Flukisida ampuh membasmi cacing hati pada sapi dan kerbau yang gembala di rawa.",
    "price": 55000,
    "type": "obat",
    "animals": ["sapi", "kerbau"],
    "location": "Salatiga Vet Center, Salatiga, Jawa Tengah",
    "phone": "081223344007",
  },
  {
    "id": "prod_044",
    "name": "Mesin Tetas Telur Otomatis (Kapasitas 100)",
    "description":
        "Incubator full otomatis putar telur untuk ayam, bebek, burung puyuh. Sangat hemat listrik.",
    "price": 850000,
    "type": "perlengkapan",
    "animals": ["ayam", "bebek", "burung puyuh"],
    "location": "Agen Perlengkapan Ternak Solo, Surakarta, Jawa Tengah",
    "phone": "081223344008",
  },

  // --- WILAYAH JAWA TIMUR (LUAR MALANG) ---
  {
    "id": "prod_045",
    "name": "Oxy L.A. (Long Acting) Injeksi",
    "description":
        "Antibiotik kerja panjang (tahan 3 hari) untuk infeksi pernafasan berat / Pneumonia sapi.",
    "price": 95000,
    "type": "obat",
    "animals": ["sapi", "kambing", "babi"],
    "location": "KUD Susu SAE, Pujon, Pasuruan, Jawa Timur",
    "phone": "081223344009",
  },
  {
    "id": "prod_046",
    "name": "Pakan Sapi Perah Pedet (Calf Starter)",
    "description":
        "Pakan pengenalan hijauan untuk pedet agar lambung ganda cepat berkembang sempurna.",
    "price": 175000,
    "type": "pakan",
    "animals": ["pedet", "sapi perah"],
    "location": "Toko Tani Makmur Kediri, Kediri, Jawa Timur",
    "phone": "081223344010",
  },
  {
    "id": "prod_047",
    "name": "Kapur Tohor (Disinfektan Kandang)",
    "description":
        "Kapur aktif (gamping) untuk ditabur di lantai kandang, membunuh bakteri dan mengurangi bau amonia.",
    "price": 15000,
    "type": "perlengkapan",
    "animals": ["semua hewan"],
    "location": "Material Pertanian Tulungagung, Tulungagung, Jawa Timur",
    "phone": "081223344011",
  },

  // --- WILAYAH SUMATERA (ACEH, RIAU, JAMBI) ---
  {
    "id": "prod_048",
    "name": "Vaksin SE (Septicemia Epizootica)",
    "description":
        "Vaksin wajib mencegah penyakit Ngorok (SE) yang sangat mematikan pada Sapi dan Kerbau.",
    "price": 120000,
    "type": "obat",
    "animals": ["kerbau", "sapi"],
    "location": "Dinas Peternakan Banda Aceh, Banda Aceh, Aceh",
    "phone": "081223344012",
  },
  {
    "id": "prod_049",
    "name": "Bungkil Kelapa Sawit (BIS)",
    "description":
        "Bahan pakan alternatif sumber protein & energi tinggi untuk sapi potong di areal perkebunan.",
    "price":
        2500, // Harga per kg, biasanya jual ton-an, kita buat per kg untuk simulasi
    "type": "pakan",
    "animals": ["sapi potong", "kambing"],
    "location": "Pabrik Sawit Riau Agro, Pekanbaru, Riau",
    "phone": "081223344013",
  },
  {
    "id": "prod_050",
    "name": "Klinik Inseminasi Buatan (IB) Sapi Brahman",
    "description":
        "Jasa suntik kawin buatan (IB) sperma sapi Brahman Cross ke indukan lokal.",
    "price": 150000,
    "type": "jasa",
    "animals": ["sapi"],
    "location": "Unit IB Jambi, Muaro Jambi, Jambi",
    "phone": "081223344014",
  },
  {
    "id": "prod_051",
    "name": "Obat Snot (Coryza) Puyuh",
    "description":
        "Serbuk antibiotik campur air minum khusus unggas puyuh mengobati bengkak mata / snot.",
    "price": 25000,
    "type": "obat",
    "animals": ["burung puyuh"],
    "location": "Toko Ternak Beringin, Bengkulu",
    "phone": "081223344015",
  },

  // --- WILAYAH KALIMANTAN (PONTIANAK, PALANGKARAYA) ---
  {
    "id": "prod_052",
    "name": "Pakan Ayam Pejantan (Joper)",
    "description":
        "Pakan khusus pembesaran ayam Jowo Super (Joper). Pertumbuhan daging cepat dan padat.",
    "price": 370000,
    "type": "pakan",
    "animals": ["ayam joper", "ayam kampung"],
    "location": "Distributor Pakan Borneo, Pontianak, Kalimantan Barat",
    "phone": "081223344016",
  },
  {
    "id": "prod_053",
    "name": "Penicillin Procaine Injeksi",
    "description":
        "Antibiotik murah meriah untuk infeksi tetanus atau luka parah akibat benda tajam pada ternak babi.",
    "price": 40000,
    "type": "obat",
    "animals": ["babi", "kuda", "sapi"],
    "location":
        "Apotek Veteriner Palangkaraya, Palangkaraya, Kalimantan Tengah",
    "phone": "081223344017",
  },
  {
    "id": "prod_054",
    "name": "Jasa Konsultan Pembuatan Kandang Close House",
    "description":
        "Konsultasi sistem ventilasi, blower, cooling pad untuk peternakan ayam broiler skala industri.",
    "price": 1500000,
    "type": "jasa",
    "animals": ["ayam pedaging", "ayam petelur"],
    "location": "PT Borneo Poultry Tekno, Samarinda, Kalimantan Timur",
    "phone": "081223344018",
  },

  // --- WILAYAH SULAWESI (PALU, KENDARI, GORONTALO) ---
  {
    "id": "prod_055",
    "name": "Garam Grasak (Garam Krosok)",
    "description":
        "Suplemen mineral dasar paling murah untuk campuran hijauan pakan sapi agar tidak kekurangan sodium.",
    "price": 5000,
    "type": "pakan",
    "animals": ["sapi", "kerbau", "kambing"],
    "location": "Grosir Tani Tadulako, Palu, Sulawesi Tengah",
    "phone": "081223344019",
  },
  {
    "id": "prod_056",
    "name": "Vaksin CSF (Hog Cholera)",
    "description":
        "Vaksin esensial mencegah wabah Kolera Babi (Classical Swine Fever) yang mematikan dan menular cepat.",
    "price": 200000,
    "type": "obat",
    "animals": ["babi"],
    "location": "Dokter Hewan Ternak Minahasa, Manado, Sulawesi Utara",
    "phone": "081223344020",
  },
  {
    "id": "prod_057",
    "name": "Molase (Tetes Tebu) Asli",
    "description":
        "Cairan manis penambah energi instan dan penambah palatabilitas (aroma) untuk pakan fermentasi ternak ruminansia. Jerigen 5 Liter.",
    "price": 60000,
    "type": "vitamin",
    "animals": ["sapi", "kambing", "domba"],
    "location": "Toko Pakan Anoa, Kendari, Sulawesi Tenggara",
    "phone": "081223344021",
  },

  // --- WILAYAH MALUKU & PAPUA ---
  {
    "id": "prod_058",
    "name": "Vitamin B12 Injeksi Unggas",
    "description":
        "Injeksi B12 khusus untuk babi dan ayam mengatasi anemia, lemas, dan merangsang pertumbuhan.",
    "price": 30000,
    "type": "vitamin",
    "animals": ["babi", "ayam"],
    "location": "Toko Ternak Mutiara, Ambon, Maluku",
    "phone": "081223344022",
  },
  {
    "id": "prod_059",
    "name": "Kapur Barus Kandang (Kamper Babi)",
    "description":
        "Pengusir lalat dan serangga efektif untuk area pembuangan kotoran kandang babi.",
    "price": 25000,
    "type": "perlengkapan",
    "animals": ["babi", "ayam"],
    "location": "Papua Vet & Feed Supply, Jayapura, Papua",
    "phone": "081223344023",
  },
  {
    "id": "prod_060",
    "name": "Pakan Sabi Bali Grower (Papua)",
    "description":
        "Pakan pendamping rumput padang gembala untuk penggemukan sapi bali di wilayah Indonesia Timur.",
    "price": 220000,
    "type": "pakan",
    "animals": ["sapi bali", "sapi potong"],
    "location": "Merauke Agro Makmur, Merauke, Papua Selatan",
    "phone": "081223344024",
  },
  {
    "id": "prod_061",
    "name": "Klinik Pelayanan Keswan Keliling",
    "description":
        "Pemeriksaan dan pengobatan ternak sapi sakit, potong kuku, dan konsultasi gizi.",
    "price": 200000,
    "type": "jasa",
    "animals": ["sapi", "babi"],
    "location": "Dinas Peternakan Sorong, Sorong, Papua Barat Daya",
    "phone": "081223344025",
  },
];
