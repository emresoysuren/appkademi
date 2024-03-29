import 'package:akademi_etkinlik/config/config.dart';
import 'package:akademi_etkinlik/models/answer.dart';
import 'package:akademi_etkinlik/models/event.dart';
import 'package:akademi_etkinlik/pages/create/create_event_form.dart';
import 'package:akademi_etkinlik/pages/utils/form_code_generator.dart';
import 'package:akademi_etkinlik/services/data_service.dart';
import 'package:akademi_etkinlik/widgets/appbar.dart';
import 'package:akademi_etkinlik/widgets/base.dart';
import 'package:akademi_etkinlik/widgets/buttons/configured/primary_button.dart';
import 'package:akademi_etkinlik/widgets/disable_scroll_behavior.dart';
import 'package:akademi_etkinlik/widgets/fields/paragraph_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class EventRatePage extends StatefulWidget {
  final FormType formType;
  final Event event;

  const EventRatePage({super.key, required this.event, required this.formType});

  @override
  State<EventRatePage> createState() => _EventRatePageState();
}

class _EventRatePageState extends State<EventRatePage> {
  late final EventForm eventForm = (widget.formType == FormType.rate
          ? widget.event.rateForm
          : widget.event.joinForm) ??
      EventForm();

  @override
  Widget build(BuildContext context) {
    return Base(
      appBar: Bar(
        title: "Etkinlik",
        subTitle: widget.formType == FormType.rate ? "Değerlendir" : "Katıl",
        popButton: true,
      ),
      body: DisableScrollBehavior(
        child: ListView.separated(
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          padding: const EdgeInsets.all(16),
          itemCount: eventForm.formData.length,
          itemBuilder: (context, index) {
            final uuid = eventForm.formIds[index];
            if (eventForm.uuidTypeAt(uuid) == FormInput.question) {
              return Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  eventForm.uuidContentAt(uuid) ?? "",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: ColorPalette.primaryText,
                  ),
                ),
              );
            }
            if (eventForm.uuidTypeAt(uuid) == FormInput.text) {
              return ParagraphField(
                onChanged: (value) {
                  eventForm.editItemAt(index, value);
                },
              );
            }
            if (eventForm.uuidTypeAt(uuid) == FormInput.star) {
              return Center(
                child: RatingBar.builder(
                  initialRating: 3,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4),
                  glow: false,
                  itemBuilder: (context, _) => const Icon(
                    Icons.star_rounded,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    eventForm.editItemAt(index, rating);
                  },
                ),
              );
            }
            if (eventForm.uuidTypeAt(uuid) == FormInput.checkBox) {
              return const ParagraphField();
            }
            return const SizedBox();
          },
        ),
      ),
      bottom: BaseCore(
        backgroundColor: ColorPalette.primaryBackground,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: PrimaryButton(
              onPressed: () => _okay(context),
              label:
                  widget.formType == FormType.rate ? "Değerlendir" : "Gönder",
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _okay(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final email = user.email;
    if (email == null) return;
    final answer = Answer(
      form: eventForm,
      username: email.split("@").first,
      uid: user.uid,
      date: Timestamp.now(),
    );
    if (widget.formType == FormType.rate) {
      await DataService.setRateAnswer(
        widget.event,
        answer,
      );
    } else if (widget.formType == FormType.join) {
      await DataService.setJoinAnswer(
        widget.event,
        answer,
      );
    }
    if (context.mounted) Navigator.pop(context);
  }
}
