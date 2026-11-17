import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../app_lang.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets/card_face.dart';
import '../widgets/design.dart';

class CardEditScreen extends StatefulWidget {
  const CardEditScreen({super.key, this.card});

  final CardModel? card;

  @override
  State<CardEditScreen> createState() => _CardEditScreenState();
}

class _CardEditScreenState extends State<CardEditScreen> {
  late CardModel _original;
  late DateTime _expiryDate;
  late String _photo;

  bool get _isNew => widget.card == null;

  @override
  void initState() {
    super.initState();
    _original = widget.card ??
        CardModel(
          id: 'card-${DateTime.now().microsecondsSinceEpoch}',
          product: 'eTWASSEL Étudiant',
          lastName: 'APP',
          firstName: 'SETRAM',
          number: '0000 00',
          expiry: DateTime(2027, 2, 25),
          agency: "Tramway d'Alger",
          durationLabel: '90 Jours',
          remainingDays: 90,
          status: 'ACTIF',
          generatedAt: DateTime.now(),
          photoAsset: 'assets/images/card_photo.png',
          art: CardArt.blue,
        );
    _expiryDate = _original.expiry;
    _photo = _original.photoAsset;
  }

  CardModel _preview() => _original.copyWith(expiry: _expiryDate, photoAsset: _photo);

  Future<void> _pickExpiry() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _expiryDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked == null || !mounted) return;
    setState(() => _expiryDate = picked);
  }

  bool get _hasGalleryPhoto => !_photo.startsWith('assets/');

  Future<void> _pickGalleryPhoto() async {
    final lang = context.appLang;
    try {
      final picked = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 1600,
        maxHeight: 1600,
        imageQuality: 90,
      );
      if (picked == null) return;
      final docs = await getApplicationDocumentsDirectory();
      final folder = Directory('${docs.path}/card_photos');
      if (!await folder.exists()) {
        await folder.create(recursive: true);
      }
      final rawExt = picked.path.split('.').last.toLowerCase();
      final ext = RegExp(r'^[a-z0-9]{2,5}$').hasMatch(rawExt) ? rawExt : 'jpg';
      final target = '${folder.path}/${_original.id}_${DateTime.now().millisecondsSinceEpoch}.$ext';
      await File(picked.path).copy(target);
      if (!mounted) return;
      setState(() => _photo = target);
    } catch (_) {
      if (!mounted) return;
      showAppSnack(context, lang.t('gallery_error'), error: true);
    }
  }

  void _save() {
    final lang = context.appLang;
    context.app.upsertCard(_preview());
    showAppSnack(context, _isNew ? lang.t('card_added') : lang.t('card_updated'));
    Navigator.of(context).pop();
  }

  Future<void> _delete() async {
    final lang = context.appLang;
    final ok = await confirmDialog(
      context,
      title: lang.t('delete_card_confirm'),
      destructive: true,
      confirmLabel: lang.t('delete'),
      cancelLabel: lang.t('cancel'),
    );
    if (!ok || !mounted) return;
    context.app.deleteCard(_original.id);
    showAppSnack(context, lang.t('card_deleted'));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.appLang;
    final text = lang.t;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Column(
        children: [
          NavyHeader(
            title: text(_isNew ? 'new_card' : 'edit_card'),
            leading: CircleIconButton(
              icon: Icons.arrow_back_rounded,
              background: const Color(0x26FFFFFF),
              onTap: () => Navigator.of(context).pop(),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 30),
              children: [
                WhiteCard(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 4, bottom: 10),
                        child: Text(text('card_preview'), style: AppText.label.copyWith(color: AppColors.muted)),
                      ),
                      LayoutBuilder(
                        builder: (context, constraints) => ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: CardFace(card: _preview(), width: constraints.maxWidth),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                WhiteCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(text('expiry_date'), style: AppText.h3),
                      const SizedBox(height: 14),
                      GestureDetector(
                        onTap: _pickExpiry,
                        behavior: HitTestBehavior.opaque,
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: text('expiry_date'),
                            suffixIcon: const Icon(Icons.calendar_month_rounded, size: 20, color: AppColors.cyanDeep),
                          ),
                          child: Text(
                            fmtDate(_expiryDate),
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                WhiteCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(text('photo'), style: AppText.h3),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          _PhotoChoice(
                            asset: 'assets/images/card_photo.png',
                            selected: _photo == 'assets/images/card_photo.png',
                            onTap: () => setState(() => _photo = 'assets/images/card_photo.png'),
                          ),
                          const SizedBox(width: 12),
                          _PhotoChoice(
                            asset: 'assets/images/defaultImage.jpg',
                            selected: _photo == 'assets/images/defaultImage.jpg',
                            onTap: () => setState(() => _photo = 'assets/images/defaultImage.jpg'),
                          ),
                          const SizedBox(width: 12),
                          _GalleryChoice(
                            path: _hasGalleryPhoto ? _photo : null,
                            onTap: _pickGalleryPhoto,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _photo.split(RegExp(r'[\\/]')).last,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppText.bodyMuted.copyWith(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 48,
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: _pickGalleryPhoto,
                          icon: const Icon(Icons.photo_library_outlined, size: 20),
                          label: Text(
                            text('choose_gallery'),
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.cyanDeep,
                            side: const BorderSide(color: AppColors.cyanDeep),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                AppPrimaryButton(
                  label: text('save'),
                  icon: Icons.check_rounded,
                  onPressed: _save,
                  color: AppColors.navy,
                ),
                if (!_isNew) ...[
                  const SizedBox(height: 12),
                  TextButton.icon(
                    onPressed: _delete,
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.red,
                      minimumSize: const Size.fromHeight(48),
                    ),
                    icon: const Icon(Icons.delete_outline_rounded),
                    label: Text(
                      text('delete'),
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PhotoChoice extends StatelessWidget {
  const _PhotoChoice({required this.asset, required this.selected, required this.onTap});

  final String asset;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 64,
        height: 64,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: selected ? AppColors.cyanDeep : AppColors.line, width: 2),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(asset, fit: BoxFit.cover, errorBuilder: (context, error, stack) => const Icon(Icons.image_not_supported_outlined)),
        ),
      ),
    );
  }
}

class _GalleryChoice extends StatelessWidget {
  const _GalleryChoice({required this.path, required this.onTap});

  final String? path;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final selected = path != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 64,
        height: 64,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: selected ? AppColors.cyanDeep : AppColors.line, width: 2),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: selected
              ? Image.file(
                  File(path!),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stack) => const Icon(Icons.photo_library_outlined, color: AppColors.cyanDeep),
                )
              : const Icon(Icons.photo_library_outlined, color: AppColors.cyanDeep),
        ),
      ),
    );
  }
}
