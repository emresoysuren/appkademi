import 'package:akademi_etkinlik/models/announcement.dart';
import 'package:akademi_etkinlik/models/event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DataService {
  // Event Functions
  static Future<List<Event>> getEvents() async {
    final QuerySnapshot<Map<String, dynamic>> documentSnapshot =
        await FirebaseFirestore.instance
            .collection("events")
            .orderBy("date")
            .get();
    return documentSnapshot.docs.length > 25
        ? documentSnapshot.docs
            .sublist(0, 24)
            .map((e) => Event.fromMap(e.data()))
            .toList()
        : documentSnapshot.docs.map((e) {
            final m = e.data();
            m.addAll({"id": e.id});
            return Event.fromMap(m);
          }).toList();
  }

  static Future<void> createEvent(Event event) async {
    await FirebaseFirestore.instance.collection("events").add(event.toMap());
  }

  static Future<void> deleteEvent(Event event) async {
    await FirebaseFirestore.instance
        .collection("events")
        .doc(event.id)
        .delete();
  }

  static Future<void> editEvent(Event event) async {
    await FirebaseFirestore.instance
        .collection("events")
        .doc(event.id)
        .set(event.toMap());
  }

  // Event Functions
  static Future<List<Announcement>> getAnnouncements() async {
    final QuerySnapshot<Map<String, dynamic>> documentSnapshot =
        await FirebaseFirestore.instance
            .collection("announcement")
            .orderBy("date")
            .get();
    return documentSnapshot.docs.length > 25
        ? documentSnapshot.docs
            .sublist(0, 24)
            .map((e) => Announcement.fromMap(e.data()))
            .toList()
        : documentSnapshot.docs.map((e) {
            final m = e.data();
            m.addAll({"id": e.id});
            return Announcement.fromMap(m);
          }).toList();
  }

  static Future<void> createAnnouncement(Announcement announcement) async {
    await FirebaseFirestore.instance
        .collection("announcement")
        .add(announcement.toMap());
  }

  static Future<void> deleteAnnouncement(Announcement announcement) async {
    await FirebaseFirestore.instance
        .collection("announcement")
        .doc(announcement.id)
        .delete();
  }

  static Future<void> editAnnouncement(Announcement announcement) async {
    await FirebaseFirestore.instance
        .collection("announcement")
        .doc(announcement.id)
        .set(announcement.toMap());
  }
}