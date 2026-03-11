import 'package:livest/features/breader/home/models/education_model.dart';

final List<EducationModel> dummyArtikel = [
  EducationModel(
    id: '1',
    title: 'Nutrisi untuk Ayam Petelur',
    category: 'Kesehatan',
    imageUrl:
        'https://images.unsplash.com/photo-1548550023-2bdb3c5beed7?w=800&auto=format&fit=crop',
    shortDesc: 'Nutrisi ayam penting untuk kualitas telur.',
    sections: [
      ArtikelSection(type: 'heading', heading: 'Pentingkah bagi ayam?'),
      ArtikelSection(
        type: 'paragraph',
        paragraph:
            'Sangat penting, karena nutrisi membantu pembentukan telur yang lebih baik!',
      ),
      ArtikelSection(type: 'heading', heading: 'Apa aja sih nutrisinya?'),
      ArtikelSection(
        type: 'chips',
        chips: ['Kalsium', 'Vitamin C', 'Fosfor', 'Protein'],
      ),
      ArtikelSection(type: 'heading', heading: 'Apa hasilnya bagi telur ayam?'),
      ArtikelSection(
        type: 'paragraph',
        paragraph:
            'Telur akan jauh lebih besar, berkualitas, dan tidak cepat busuk! Telur yang lebih berkualitas akan lebih diminati pembeli!',
      ),
      ArtikelSection(type: 'heading', heading: 'Cara dapetin nutrisinya?'),
      ArtikelSection(
        type: 'paragraph',
        paragraph: 'Berikan ayam pakan yang bernutrisi seperti:',
      ),
      ArtikelSection(
        type: 'chips',
        chips: ['Jagung', 'Sorghum', 'Dedak', 'Beras'],
      ),
    ],
  ),
  EducationModel(
    id: '2',
    title: 'Menjaga Kandang Bersih',
    category: 'Perawatan',
    imageUrl:
        'https://images.unsplash.com/photo-1593196698822-c5ab87c4d2cd?w=800&auto=format&fit=crop',
    shortDesc: 'Cara menjaga kandang tetap bersih!',
    sections: [
      ArtikelSection(type: 'heading', heading: 'Harus bersih banget emangnya?'),
      ArtikelSection(
        type: 'paragraph',
        paragraph:
            'Iya dong, biar ternak tetep sehat dan tidak stress. Ternak yang sehat dapat membuat pertumbuhan lebih baik',
      ),
      ArtikelSection(type: 'heading', heading: 'Resiko ga bersih apa?'),
      ArtikelSection(
        type: 'paragraph',
        paragraph:
            'Jelas banget akan membuat kandang bau, dan meningkatkan resiko ternak kamu jadi sakit! Tunggu apalagi? Yuk bersihin!',
      ),
      ArtikelSection(
        type: 'heading',
        heading: 'Yuk bersihin, ikuti ceklis dibawah!',
      ),
      ArtikelSection(
        type: 'checklist',
        checklist: [
          'Siapin dulu bahannya, bisa pakai spons, sikat, lap, dan lain-lain.',
          'Cari bagian yang sekiranya kotor, kemudian bersihkan menggunakan alat yang kamu punya',
          'Bilas sisa kotoran dengan air bersih mengalir',
          'Semprotkan disinfektan agar steril',
          'Bersihkan alat-alat yang kamu pake tadi',
        ],
      ),
    ],
  ),
  EducationModel(
    id: '3',
    title: 'Mengelola Usaha Ternak',
    category: 'Perawatan',
    imageUrl:
        'https://images.unsplash.com/photo-1592194996308-7b43878e84a6?w=800&auto=format&fit=crop',
    shortDesc: 'Cara menjaga kandang tetap bersih!',
    sections: [
      ArtikelSection(type: 'heading', heading: 'Biar apa sih?'),
      ArtikelSection(
        type: 'paragraph',
        paragraph:
            'Biar usaha ternak kamu lebih mudah diatur dan rapi dalam hal-hal seperti pencatatan, sistem manajemen, dan lainnya.',
      ),
      ArtikelSection(type: 'heading', heading: 'Apa aja yang dikelola?'),
      ArtikelSection(
        type: 'chips',
        chips: ['Keuangan', 'Pakan', 'Distribusi', 'Ternak'],
      ),
      ArtikelSection(type: 'heading', heading: 'Caranya gimana?'),
      ArtikelSection(
        type: 'checklist',
        checklist: [
          'Catat pengeluaran / pemasukan kamu secara rutin, bisa pakai buku besar atau aplikasi seperti Excel atau Spreadsheets',
          'Cari distributor yang terpercaya dan professional untuk menyalurkan ternakmu, bisa juga memakai fitur "Pasar" kami agar lebih cepat!',
          'Cari pakan berkualitas, dapat menggunakan bahan alami atau pakan industri yang bermerek!',
          'Carilah bibit ternak yang sehat, kalau bisa pastikan ternak kamu dirawat dan tidak stress.',
        ],
      ),
    ],
  ),
  EducationModel(
    id: '4',
    title: 'Cara Memerah Susu',
    category: 'Perawatan',
    imageUrl:
        'https://images.unsplash.com/photo-1516467508483-a7212febe31a?w=800&auto=format&fit=crop',
    shortDesc: 'Penting agar sapi kamu nyaman pas diperah.',
    sections: [
      ArtikelSection(type: 'heading', heading: 'Kenapa harus benar caranya?'),
      ArtikelSection(
        type: 'paragraph',
        paragraph:
            'Memerah susu dengan benar membuat sapi tidak stress dan produksi susu lebih optimal!',
      ),
      ArtikelSection(type: 'heading', heading: 'Kapan waktu terbaik?'),
      ArtikelSection(
        type: 'paragraph',
        paragraph:
            'Pagi hari sekitar pukul 05.00-07.00 adalah waktu terbaik karena sapi masih segar dan produksi susu sedang optimal.',
      ),
      ArtikelSection(type: 'heading', heading: 'Langkah-langkahnya:'),
      ArtikelSection(
        type: 'checklist',
        checklist: [
          'Bersihkan ambing sapi dengan air hangat dan lap bersih',
          'Lakukan pemijatan ringan selama 1-2 menit agar susu turun',
          'Perah dengan teknik 5 jari secara bergantian',
          'Tampung susu di wadah bersih dan steril',
          'Simpan susu di kulkas dalam 1 jam setelah pemerahan',
        ],
      ),
    ],
  ),
  EducationModel(
    id: '5',
    title: 'Cara Menyimpan Pakan Ternak',
    category: 'Pakan',
    imageUrl:
        'https://images.unsplash.com/photo-1500595046743-cd271d694d30?w=800&auto=format&fit=crop',
    shortDesc: 'Biar pakan kamu lebih awet dan bersih!',
    sections: [
      ArtikelSection(
        type: 'heading',
        heading: 'Kenapa harus disimpan dengan benar?',
      ),
      ArtikelSection(
        type: 'paragraph',
        paragraph:
            'Penyimpanan yang salah bisa membuat pakan berjamur, berbau, atau terkontaminasi dan berbahaya bagi ternak!',
      ),
      ArtikelSection(type: 'heading', heading: 'Jenis-jenis penyimpanan:'),
      ArtikelSection(
        type: 'chips',
        chips: ['Karung', 'Gudang Kering', 'Wadah Kedap', 'Rak Kayu'],
      ),
      ArtikelSection(type: 'heading', heading: 'Tips menyimpan pakan:'),
      ArtikelSection(
        type: 'checklist',
        checklist: [
          'Simpan di tempat yang kering dan tidak lembab',
          'Jauhkan dari sinar matahari langsung',
          'Gunakan wadah kedap udara untuk pakan halus',
          'Beri jarak antara pakan dan dinding/lantai',
          'Cek kondisi pakan setiap minggu',
        ],
      ),
    ],
  ),
];
