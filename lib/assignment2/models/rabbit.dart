// ============================================================
// Rabbit — the MAIN ENTITY of the Rabbit Track project.
//
// Assignment 2 (Unit 3): these are the 6 fields of the entity.
// All data below is DUMMY data only — no database is connected
// yet (databases and APIs arrive in Assignment 4).
// ============================================================
class Rabbit {
  final String name; // 1. Rabbit's given name, e.g. "Snowy"
  final String tagNumber; // 2. Unique farm tag, e.g. "RT-001"
  final String breed; // 3. Breed, e.g. "New Zealand White"
  final String gender; // 4. "Male" or "Female"
  final String cageNumber; // 5. Cage location, e.g. "A-03"
  final String dateOfBirth; // 6. Birth date, e.g. "12 Mar 2025"

  const Rabbit({
    required this.name,
    required this.tagNumber,
    required this.breed,
    required this.gender,
    required this.cageNumber,
    required this.dateOfBirth,
  });
}

// Dummy rabbits shown on the Home screen inside RabbitCards.
// Each one has DIFFERENT data, as required by the assignment.
const List<Rabbit> dummyRabbits = [
  Rabbit(
    name: 'Snowy',
    tagNumber: 'RT-001',
    breed: 'New Zealand White',
    gender: 'Female',
    cageNumber: 'A-03',
    dateOfBirth: '12 Mar 2025',
  ),
  Rabbit(
    name: 'Coco',
    tagNumber: 'RT-002',
    breed: 'Dutch',
    gender: 'Male',
    cageNumber: 'A-05',
    dateOfBirth: '28 Apr 2025',
  ),
  Rabbit(
    name: 'Shadow',
    tagNumber: 'RT-003',
    breed: 'Rex',
    gender: 'Male',
    cageNumber: 'B-01',
    dateOfBirth: '10 Jun 2025',
  ),
  Rabbit(
    name: 'Brownie',
    tagNumber: 'RT-004',
    breed: 'Lop',
    gender: 'Female',
    cageNumber: 'B-04',
    dateOfBirth: '22 Jul 2025',
  ),
  Rabbit(
    name: 'Pearl',
    tagNumber: 'RT-005',
    breed: 'Californian',
    gender: 'Female',
    cageNumber: 'B-07',
    dateOfBirth: '05 Sep 2025',
  ),
];
