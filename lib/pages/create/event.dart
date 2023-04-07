import 'package:akademi_etkinlik/config/config.dart';
import 'package:akademi_etkinlik/models/event.dart';
import 'package:akademi_etkinlik/services/data_service.dart';
import 'package:akademi_etkinlik/widgets/appbar.dart';
import 'package:akademi_etkinlik/widgets/base.dart';
import 'package:akademi_etkinlik/widgets/buttons/configured/primary_button.dart';
import 'package:akademi_etkinlik/widgets/buttons/configured/secondary_button.dart';
import 'package:akademi_etkinlik/widgets/fields/info_field.dart';
import 'package:akademi_etkinlik/widgets/fields/paragraph_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

class CreateEventPage extends StatefulWidget {
  final Event? event;

  const CreateEventPage({super.key, this.event});

  @override
  State<CreateEventPage> createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  String? _link;
  String? _title;
  String? _content;
  DateTime? _dateTime;

  @override
  Widget build(BuildContext context) {
    return Base(
      appBar: Bar(
        title: "Etkinlik",
        subTitle: widget.event == null ? "Oluştur" : "Düzenle",
        popButton: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Başlık:",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: ColorPalette.primaryText,
              ),
            ),
            const SizedBox(height: 8),
            InfoField(
              isSecondary: true,
              initialValue: widget.event?.title,
              onChanged: (value) {
                _title = value;
              },
            ),
            const SizedBox(height: 16),
            const Text(
              "Tarih ve Saat:",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: ColorPalette.primaryText,
              ),
            ),
            const SizedBox(height: 8),
            // const InfoField(isSecondary: true),
            SizedBox(
              width: double.infinity,
              child: SecondaryButton(
                color: ColorPalette.primaryItem,
                textColor: _dateTime == null ? null : ColorPalette.primaryText,
                label: _dateTime != null
                    ? "${_dateTime!.day}/${_dateTime!.month}/${_dateTime!.year} ${_dateTime!.hour}:${_dateTime!.minute.toString().padLeft(2, "0")}"
                    : "Etkinlik Zamanını Belirle",
                radius: 16,
                borderWidth: 1.6,
                onPressed: () async {
                  final dateTime =
                      await showOmniDateTimePicker(context: context);
                  if (dateTime == null) return;
                  _dateTime = dateTime;
                  if (mounted) setState(() {});
                },
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Açıklama:",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: ColorPalette.primaryText,
              ),
            ),
            const SizedBox(height: 8),
            ParagraphField(
              initialValue: widget.event?.content,
              onChanged: (value) {
                _content = value;
              },
            ),
            const SizedBox(height: 16),
            const Text(
              "Etkinlik Linki:",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: ColorPalette.primaryText,
              ),
            ),
            const SizedBox(height: 8),
            InfoField(
              isSecondary: true,
              initialValue: widget.event?.link,
              onChanged: (value) {
                _link = value;
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      bottom: SizedBox(
        width: double.infinity,
        child: BaseCore(
          backgroundColor: ColorPalette.primaryBackground,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: PrimaryButton(
              onPressed: () {
                if (_content != null ||
                    _title != null ||
                    _link != null ||
                    _dateTime != null) {
                  if (widget.event == null) {
                    if (_content != null &&
                        _title != null &&
                        _dateTime != null) {
                      DataService.createEvent(
                        Event(
                          content: _content!,
                          title: _title!,
                          date: Timestamp.fromDate(_dateTime!),
                          link: _link,
                        ),
                      );
                      Navigator.pop(context);
                    } else {
                      // TODO: Throw an error. Because some fields are empty
                    }
                  } else {
                    DataService.editEvent(
                      Event(
                        content: _content ?? widget.event!.content,
                        title: _title ?? widget.event!.title,
                        date: _dateTime != null
                            ? Timestamp.fromDate(_dateTime!)
                            : widget.event!.date,
                        link: _link ?? widget.event?.link,
                        id: widget.event?.id,
                      ),
                    );
                    Navigator.pop(context);
                  }
                } else {
                  // TODO: Show an error because the user haven't changed anything yet
                }
              },
              label: widget.event == null ? "Oluştur" : "Düzenle",
            ),
          ),
        ),
      ),
    );
  }
}
