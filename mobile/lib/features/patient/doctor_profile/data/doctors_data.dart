import '../models/doctor.dart';

const List<Doctor> demoDoctors = [
  Doctor(
    id: '1',
    fullName: 'Dr. Amira Ben Salem',
    specialty: 'Cardiologue',
    bio:
        'Médecin cardiologue spécialisée dans la prévention et le suivi des maladies cardiovasculaires. Elle accompagne ses patients avec une approche attentive et personnalisée.',
    experienceYears: 12,
    rating: 4.9,
    reviewCount: 128,
    clinicName: 'Clinique Les Jasmins',
    address: 'Avenue Habib Bourguiba',
    city: 'Tunis',
    phone: '+216 71 123 456',
    consultationFee: 80,
    workingHours: '08:00 - 17:00',
    availableDays: ['Lundi', 'Mardi', 'Mercredi', 'Vendredi'],
    languages: ['Arabe', 'Français', 'Anglais'],
    services: [
      'Consultation cardiologique',
      'Électrocardiogramme',
      'Suivi cardiaque',
      'Bilan cardiovasculaire',
    ],
    reviews: [
      DoctorReview(
        patientName: 'Sarra K.',
        rating: 5.0,
        comment:
            'Médecin très professionnelle et attentive. Elle prend le temps de bien expliquer.',
        date: '12 octobre 2026',
      ),
      DoctorReview(
        patientName: 'Ahmed M.',
        rating: 4.8,
        comment:
            'Très bonne expérience. Accueil agréable et consultation complète.',
        date: '5 octobre 2026',
      ),
      DoctorReview(
        patientName: 'Meriem B.',
        rating: 4.9,
        comment: 'Je recommande vivement cette cardiologue pour son sérieux.',
        date: '28 septembre 2026',
      ),
    ],
  ),
  Doctor(
    id: '2',
    fullName: 'Dr. Youssef Trabelsi',
    specialty: 'Dermatologue',
    bio:
        'Dermatologue spécialisé dans le diagnostic et le suivi des problèmes de peau. Il propose une prise en charge adaptée aux besoins de chaque patient.',
    experienceYears: 8,
    rating: 4.7,
    reviewCount: 94,
    clinicName: 'Centre Médical El Manar',
    address: 'Avenue du 7 Novembre',
    city: 'Tunis',
    phone: '+216 71 654 321',
    consultationFee: 65,
    workingHours: '09:00 - 16:00',
    availableDays: ['Lundi', 'Mercredi', 'Jeudi', 'Samedi'],
    languages: ['Arabe', 'Français'],
    services: [
      'Consultation dermatologique',
      'Suivi cutané',
      'Conseil dermatologique',
    ],
    reviews: [
      DoctorReview(
        patientName: 'Nour A.',
        rating: 4.8,
        comment: 'Très bon médecin, professionnel et à l’écoute.',
        date: '15 octobre 2026',
      ),
      DoctorReview(
        patientName: 'Sami R.',
        rating: 4.6,
        comment: 'Consultation sérieuse et explications claires.',
        date: '2 octobre 2026',
      ),
    ],
  ),
];
