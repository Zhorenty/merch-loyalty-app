// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class AppLocalizations {
  AppLocalizations();

  static AppLocalizations? _current;

  static AppLocalizations get current {
    assert(
      _current != null,
      'No instance of AppLocalizations was loaded. Try to initialize the AppLocalizations delegate before accessing AppLocalizations.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<AppLocalizations> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = AppLocalizations();
      AppLocalizations._current = instance;

      return instance;
    });
  }

  static AppLocalizations of(BuildContext context) {
    final instance = AppLocalizations.maybeOf(context);
    assert(
      instance != null,
      'No instance of AppLocalizations present in the widget tree. Did you add AppLocalizations.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static AppLocalizations? maybeOf(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  /// `MERCH Касса`
  String get appTitle {
    return Intl.message('MERCH Касса', name: 'appTitle', desc: '', args: []);
  }

  /// `Логин`
  String get loginHint {
    return Intl.message('Логин', name: 'loginHint', desc: '', args: []);
  }

  /// `Пароль или PIN`
  String get passwordOrPinHint {
    return Intl.message(
      'Пароль или PIN',
      name: 'passwordOrPinHint',
      desc: '',
      args: [],
    );
  }

  /// `Войти`
  String get signIn {
    return Intl.message('Войти', name: 'signIn', desc: '', args: []);
  }

  /// `Введи логин и пароль`
  String get enterLoginAndPassword {
    return Intl.message(
      'Введи логин и пароль',
      name: 'enterLoginAndPassword',
      desc: '',
      args: [],
    );
  }

  /// `Наведи на QR карты MERCH`
  String get scanHint {
    return Intl.message(
      'Наведи на QR карты MERCH',
      name: 'scanHint',
      desc: '',
      args: [],
    );
  }

  /// `Карта не найдена`
  String get cardNotFound {
    return Intl.message(
      'Карта не найдена',
      name: 'cardNotFound',
      desc: '',
      args: [],
    );
  }

  /// `Понятно`
  String get gotIt {
    return Intl.message('Понятно', name: 'gotIt', desc: '', args: []);
  }

  /// `Ввести код`
  String get enterCode {
    return Intl.message('Ввести код', name: 'enterCode', desc: '', args: []);
  }

  /// `MCH-… или UUID`
  String get barcodeOrUuidHint {
    return Intl.message(
      'MCH-… или UUID',
      name: 'barcodeOrUuidHint',
      desc: '',
      args: [],
    );
  }

  /// `Отмена`
  String get cancel {
    return Intl.message('Отмена', name: 'cancel', desc: '', args: []);
  }

  /// `Найти`
  String get find {
    return Intl.message('Найти', name: 'find', desc: '', args: []);
  }

  /// `Клиент`
  String get customer {
    return Intl.message('Клиент', name: 'customer', desc: '', args: []);
  }

  /// `Гость`
  String get guest {
    return Intl.message('Гость', name: 'guest', desc: '', args: []);
  }

  /// `баллов`
  String get points {
    return Intl.message('баллов', name: 'points', desc: '', args: []);
  }

  /// `Можно списать от {min} баллов`
  String canRedeemFrom(int min) {
    return Intl.message(
      'Можно списать от $min баллов',
      name: 'canRedeemFrom',
      desc: '',
      args: [min],
    );
  }

  /// `Списание от {min} баллов`
  String redeemFrom(int min) {
    return Intl.message(
      'Списание от $min баллов',
      name: 'redeemFrom',
      desc: '',
      args: [min],
    );
  }

  /// `Чек`
  String get receipt {
    return Intl.message('Чек', name: 'receipt', desc: '', args: []);
  }

  /// `Закрыть`
  String get close {
    return Intl.message('Закрыть', name: 'close', desc: '', args: []);
  }

  /// `Введи сумму чека`
  String get enterAmount {
    return Intl.message(
      'Введи сумму чека',
      name: 'enterAmount',
      desc: '',
      args: [],
    );
  }

  /// `Списать можно от {min} баллов`
  String redeemBelowMin(int min) {
    return Intl.message(
      'Списать можно от $min баллов',
      name: 'redeemBelowMin',
      desc: '',
      args: [min],
    );
  }

  /// `Списать: {points} б. = {points} ₽`
  String redeemLine(int points) {
    return Intl.message(
      'Списать: $points б. = $points ₽',
      name: 'redeemLine',
      desc: '',
      args: [points],
    );
  }

  /// `К оплате: {amount} ₽`
  String payableLine(int amount) {
    return Intl.message(
      'К оплате: $amount ₽',
      name: 'payableLine',
      desc: '',
      args: [amount],
    );
  }

  /// `Начислим: {points} б.`
  String earnLine(int points) {
    return Intl.message(
      'Начислим: $points б.',
      name: 'earnLine',
      desc: '',
      args: [points],
    );
  }

  /// `Назад`
  String get back {
    return Intl.message('Назад', name: 'back', desc: '', args: []);
  }

  /// `Подтвердить`
  String get confirm {
    return Intl.message('Подтвердить', name: 'confirm', desc: '', args: []);
  }

  /// `На карте {points} б.`
  String onCardPoints(int points) {
    return Intl.message(
      'На карте $points б.',
      name: 'onCardPoints',
      desc: '',
      args: [points],
    );
  }

  /// `Сумма чека, ₽`
  String get amountHint {
    return Intl.message(
      'Сумма чека, ₽',
      name: 'amountHint',
      desc: '',
      args: [],
    );
  }

  /// `Рассчитать`
  String get calculate {
    return Intl.message('Рассчитать', name: 'calculate', desc: '', args: []);
  }

  /// `Списать баллы`
  String get redeemPointsLabel {
    return Intl.message(
      'Списать баллы',
      name: 'redeemPointsLabel',
      desc: '',
      args: [],
    );
  }

  /// `Минимум для списания — {min} б.`
  String redeemMinHint(int min) {
    return Intl.message(
      'Минимум для списания — $min б.',
      name: 'redeemMinHint',
      desc: '',
      args: [min],
    );
  }

  /// `К оплате`
  String get payable {
    return Intl.message('К оплате', name: 'payable', desc: '', args: []);
  }

  /// `Начислим`
  String get willEarn {
    return Intl.message('Начислим', name: 'willEarn', desc: '', args: []);
  }

  /// `Нет связи — чек не отправится`
  String get offlineCommitDisabled {
    return Intl.message(
      'Нет связи — чек не отправится',
      name: 'offlineCommitDisabled',
      desc: '',
      args: [],
    );
  }

  /// `Провести чек`
  String get commitReceipt {
    return Intl.message(
      'Провести чек',
      name: 'commitReceipt',
      desc: '',
      args: [],
    );
  }

  /// `Готово`
  String get done {
    return Intl.message('Готово', name: 'done', desc: '', args: []);
  }

  /// `баллов на карте`
  String get pointsOnCard {
    return Intl.message(
      'баллов на карте',
      name: 'pointsOnCard',
      desc: '',
      args: [],
    );
  }

  /// `Списано {points} б.`
  String redeemedPoints(int points) {
    return Intl.message(
      'Списано $points б.',
      name: 'redeemedPoints',
      desc: '',
      args: [points],
    );
  }

  /// `Начислено {points} б.`
  String earnedPoints(int points) {
    return Intl.message(
      'Начислено $points б.',
      name: 'earnedPoints',
      desc: '',
      args: [points],
    );
  }

  /// `Чек уже был проведён — баллы не менялись`
  String get idempotentReplay {
    return Intl.message(
      'Чек уже был проведён — баллы не менялись',
      name: 'idempotentReplay',
      desc: '',
      args: [],
    );
  }

  /// `Выдать карту`
  String get issueCard {
    return Intl.message('Выдать карту', name: 'issueCard', desc: '', args: []);
  }

  /// `Имя (необязательно)`
  String get nameOptional {
    return Intl.message(
      'Имя (необязательно)',
      name: 'nameOptional',
      desc: '',
      args: [],
    );
  }

  /// `Телефон (необязательно)`
  String get phoneOptional {
    return Intl.message(
      'Телефон (необязательно)',
      name: 'phoneOptional',
      desc: '',
      args: [],
    );
  }

  /// `Клиент согласен на обработку телефона`
  String get phoneConsent {
    return Intl.message(
      'Клиент согласен на обработку телефона',
      name: 'phoneConsent',
      desc: '',
      args: [],
    );
  }

  /// `Нужно согласие, чтобы сохранить телефон`
  String get phoneConsentRequired {
    return Intl.message(
      'Нужно согласие, чтобы сохранить телефон',
      name: 'phoneConsentRequired',
      desc: '',
      args: [],
    );
  }

  /// `Карта уже есть`
  String get cardAlreadyExists {
    return Intl.message(
      'Карта уже есть',
      name: 'cardAlreadyExists',
      desc: '',
      args: [],
    );
  }

  /// `Покажи QR клиенту`
  String get showQrToCustomer {
    return Intl.message(
      'Покажи QR клиенту',
      name: 'showQrToCustomer',
      desc: '',
      args: [],
    );
  }

  /// `Сразу к чеку`
  String get goToReceipt {
    return Intl.message(
      'Сразу к чеку',
      name: 'goToReceipt',
      desc: '',
      args: [],
    );
  }

  /// `Ещё карту`
  String get anotherCard {
    return Intl.message('Ещё карту', name: 'anotherCard', desc: '', args: []);
  }

  /// `Смена`
  String get shift {
    return Intl.message('Смена', name: 'shift', desc: '', args: []);
  }

  /// `История смены появится после выкладки API`
  String get shiftHistoryLater {
    return Intl.message(
      'История смены появится после выкладки API',
      name: 'shiftHistoryLater',
      desc: '',
      args: [],
    );
  }

  /// `Список чеков не фейкаем с телефона`
  String get shiftHistoryNotCached {
    return Intl.message(
      'Список чеков не фейкаем с телефона',
      name: 'shiftHistoryNotCached',
      desc: '',
      args: [],
    );
  }

  /// `Пока пусто`
  String get emptyTitle {
    return Intl.message('Пока пусто', name: 'emptyTitle', desc: '', args: []);
  }

  /// `Отсканируй карту на кассе`
  String get emptyScanHint {
    return Intl.message(
      'Отсканируй карту на кассе',
      name: 'emptyScanHint',
      desc: '',
      args: [],
    );
  }

  /// `{time} · списано {redeem} · начислено {earn}`
  String receiptSubtitle(String time, int redeem, int earn) {
    return Intl.message(
      '$time · списано $redeem · начислено $earn',
      name: 'receiptSubtitle',
      desc: '',
      args: [time, redeem, earn],
    );
  }

  /// `возврат`
  String get statusRefunded {
    return Intl.message('возврат', name: 'statusRefunded', desc: '', args: []);
  }

  /// `проведён`
  String get statusCommitted {
    return Intl.message(
      'проведён',
      name: 'statusCommitted',
      desc: '',
      args: [],
    );
  }

  /// `Вернуть чек?`
  String get refundReceiptTitle {
    return Intl.message(
      'Вернуть чек?',
      name: 'refundReceiptTitle',
      desc: '',
      args: [],
    );
  }

  /// `Сервер сторнирует начисление и вернёт списанные баллы.`
  String get refundReceiptBody {
    return Intl.message(
      'Сервер сторнирует начисление и вернёт списанные баллы.',
      name: 'refundReceiptBody',
      desc: '',
      args: [],
    );
  }

  /// `Возврат`
  String get refund {
    return Intl.message('Возврат', name: 'refund', desc: '', args: []);
  }

  /// `Сумма {amount} ₽`
  String amountRub(int amount) {
    return Intl.message(
      'Сумма $amount ₽',
      name: 'amountRub',
      desc: '',
      args: [amount],
    );
  }

  /// `Баланс после {points} б.`
  String pointsAfter(int points) {
    return Intl.message(
      'Баланс после $points б.',
      name: 'pointsAfter',
      desc: '',
      args: [points],
    );
  }

  /// `Клиенты`
  String get customers {
    return Intl.message('Клиенты', name: 'customers', desc: '', args: []);
  }

  /// `Barcode, телефон, имя`
  String get customerSearchHint {
    return Intl.message(
      'Barcode, телефон, имя',
      name: 'customerSearchHint',
      desc: '',
      args: [],
    );
  }

  /// `Никого не нашли`
  String get customersEmpty {
    return Intl.message(
      'Никого не нашли',
      name: 'customersEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Попробуй barcode или телефон`
  String get customersEmptyHint {
    return Intl.message(
      'Попробуй barcode или телефон',
      name: 'customersEmptyHint',
      desc: '',
      args: [],
    );
  }

  /// `блок`
  String get blocked {
    return Intl.message('блок', name: 'blocked', desc: '', args: []);
  }

  /// `Укажи причину правки`
  String get adjustReasonRequired {
    return Intl.message(
      'Укажи причину правки',
      name: 'adjustReasonRequired',
      desc: '',
      args: [],
    );
  }

  /// `Укажи ненулевую дельту`
  String get adjustDeltaRequired {
    return Intl.message(
      'Укажи ненулевую дельту',
      name: 'adjustDeltaRequired',
      desc: '',
      args: [],
    );
  }

  /// `Разблокировать`
  String get unblock {
    return Intl.message('Разблокировать', name: 'unblock', desc: '', args: []);
  }

  /// `Заблокировать`
  String get block {
    return Intl.message('Заблокировать', name: 'block', desc: '', args: []);
  }

  /// `Ручная правка`
  String get manualAdjust {
    return Intl.message(
      'Ручная правка',
      name: 'manualAdjust',
      desc: '',
      args: [],
    );
  }

  /// `Дельта, можно минус`
  String get deltaHint {
    return Intl.message(
      'Дельта, можно минус',
      name: 'deltaHint',
      desc: '',
      args: [],
    );
  }

  /// `Причина`
  String get reasonHint {
    return Intl.message('Причина', name: 'reasonHint', desc: '', args: []);
  }

  /// `Изменить баллы`
  String get changePoints {
    return Intl.message(
      'Изменить баллы',
      name: 'changePoints',
      desc: '',
      args: [],
    );
  }

  /// `Сотрудники`
  String get staff {
    return Intl.message('Сотрудники', name: 'staff', desc: '', args: []);
  }

  /// `Нет сотрудников`
  String get staffEmpty {
    return Intl.message(
      'Нет сотрудников',
      name: 'staffEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Добавь менеджера или админа`
  String get staffEmptyHint {
    return Intl.message(
      'Добавь менеджера или админа',
      name: 'staffEmptyHint',
      desc: '',
      args: [],
    );
  }

  /// `активен`
  String get active {
    return Intl.message('активен', name: 'active', desc: '', args: []);
  }

  /// `выкл`
  String get inactive {
    return Intl.message('выкл', name: 'inactive', desc: '', args: []);
  }

  /// `Логин и имя обязательны`
  String get loginAndNameRequired {
    return Intl.message(
      'Логин и имя обязательны',
      name: 'loginAndNameRequired',
      desc: '',
      args: [],
    );
  }

  /// `Задай пароль`
  String get passwordRequired {
    return Intl.message(
      'Задай пароль',
      name: 'passwordRequired',
      desc: '',
      args: [],
    );
  }

  /// `Новый сотрудник`
  String get newStaff {
    return Intl.message(
      'Новый сотрудник',
      name: 'newStaff',
      desc: '',
      args: [],
    );
  }

  /// `Сотрудник`
  String get staffMember {
    return Intl.message('Сотрудник', name: 'staffMember', desc: '', args: []);
  }

  /// `Имя`
  String get nameHint {
    return Intl.message('Имя', name: 'nameHint', desc: '', args: []);
  }

  /// `Новый пароль (необязательно)`
  String get newPasswordOptional {
    return Intl.message(
      'Новый пароль (необязательно)',
      name: 'newPasswordOptional',
      desc: '',
      args: [],
    );
  }

  /// `Пароль`
  String get passwordHint {
    return Intl.message('Пароль', name: 'passwordHint', desc: '', args: []);
  }

  /// `Роль`
  String get role {
    return Intl.message('Роль', name: 'role', desc: '', args: []);
  }

  /// `Менеджер`
  String get roleManager {
    return Intl.message('Менеджер', name: 'roleManager', desc: '', args: []);
  }

  /// `Админ`
  String get roleAdmin {
    return Intl.message('Админ', name: 'roleAdmin', desc: '', args: []);
  }

  /// `Активен`
  String get staffActive {
    return Intl.message('Активен', name: 'staffActive', desc: '', args: []);
  }

  /// `Создать`
  String get create {
    return Intl.message('Создать', name: 'create', desc: '', args: []);
  }

  /// `Сохранить`
  String get save {
    return Intl.message('Сохранить', name: 'save', desc: '', args: []);
  }

  /// `Точки`
  String get stores {
    return Intl.message('Точки', name: 'stores', desc: '', args: []);
  }

  /// `Нет точек`
  String get storesEmpty {
    return Intl.message('Нет точек', name: 'storesEmpty', desc: '', args: []);
  }

  /// `Добавь магазин, чтобы бить чеки`
  String get storesEmptyHint {
    return Intl.message(
      'Добавь магазин, чтобы бить чеки',
      name: 'storesEmptyHint',
      desc: '',
      args: [],
    );
  }

  /// `Адрес не указан`
  String get addressMissing {
    return Intl.message(
      'Адрес не указан',
      name: 'addressMissing',
      desc: '',
      args: [],
    );
  }

  /// `Название обязательно`
  String get storeNameRequired {
    return Intl.message(
      'Название обязательно',
      name: 'storeNameRequired',
      desc: '',
      args: [],
    );
  }

  /// `Удалить точку?`
  String get deleteStoreTitle {
    return Intl.message(
      'Удалить точку?',
      name: 'deleteStoreTitle',
      desc: '',
      args: [],
    );
  }

  /// `Удалить`
  String get delete {
    return Intl.message('Удалить', name: 'delete', desc: '', args: []);
  }

  /// `Новая точка`
  String get newStore {
    return Intl.message('Новая точка', name: 'newStore', desc: '', args: []);
  }

  /// `Точка`
  String get store {
    return Intl.message('Точка', name: 'store', desc: '', args: []);
  }

  /// `Название`
  String get storeNameHint {
    return Intl.message('Название', name: 'storeNameHint', desc: '', args: []);
  }

  /// `Адрес`
  String get addressHint {
    return Intl.message('Адрес', name: 'addressHint', desc: '', args: []);
  }

  /// `Ещё`
  String get more {
    return Intl.message('Ещё', name: 'more', desc: '', args: []);
  }

  /// `Правила лояльности`
  String get loyaltyRules {
    return Intl.message(
      'Правила лояльности',
      name: 'loyaltyRules',
      desc: '',
      args: [],
    );
  }

  /// `Правила сохранены`
  String get settingsSaved {
    return Intl.message(
      'Правила сохранены',
      name: 'settingsSaved',
      desc: '',
      args: [],
    );
  }

  /// `Процент начисления`
  String get settingEarnPercent {
    return Intl.message(
      'Процент начисления',
      name: 'settingEarnPercent',
      desc: '',
      args: [],
    );
  }

  /// `Минимум списания, б.`
  String get settingRedeemMin {
    return Intl.message(
      'Минимум списания, б.',
      name: 'settingRedeemMin',
      desc: '',
      args: [],
    );
  }

  /// `Макс. доля чека, %`
  String get settingRedeemMaxShare {
    return Intl.message(
      'Макс. доля чека, %',
      name: 'settingRedeemMaxShare',
      desc: '',
      args: [],
    );
  }

  /// `Курс списания, ₽ за балл`
  String get settingRedeemRate {
    return Intl.message(
      'Курс списания, ₽ за балл',
      name: 'settingRedeemRate',
      desc: '',
      args: [],
    );
  }

  /// `Минимум чека для начисления, ₽`
  String get settingEarnMinReceipt {
    return Intl.message(
      'Минимум чека для начисления, ₽',
      name: 'settingEarnMinReceipt',
      desc: '',
      args: [],
    );
  }

  /// `Профиль`
  String get profile {
    return Intl.message('Профиль', name: 'profile', desc: '', args: []);
  }

  /// `Сотрудник`
  String get employee {
    return Intl.message('Сотрудник', name: 'employee', desc: '', args: []);
  }

  /// `Точка {id}`
  String storeIdLabel(String id) {
    return Intl.message(
      'Точка $id',
      name: 'storeIdLabel',
      desc: '',
      args: [id],
    );
  }

  /// `Версия {version}+1`
  String appVersion(String version) {
    return Intl.message(
      'Версия $version+1',
      name: 'appVersion',
      desc: '',
      args: [version],
    );
  }

  /// `Закрыть смену`
  String get closeShift {
    return Intl.message(
      'Закрыть смену',
      name: 'closeShift',
      desc: '',
      args: [],
    );
  }

  /// `Обнови приложение`
  String get updateApp {
    return Intl.message(
      'Обнови приложение',
      name: 'updateApp',
      desc: '',
      args: [],
    );
  }

  /// `Минимальная версия {version}. Сканер закрыт, пока не поставишь новую сборку.`
  String updateAppBody(String version) {
    return Intl.message(
      'Минимальная версия $version. Сканер закрыт, пока не поставишь новую сборку.',
      name: 'updateAppBody',
      desc: '',
      args: [version],
    );
  }

  /// `Скачать APK`
  String get downloadApk {
    return Intl.message('Скачать APK', name: 'downloadApk', desc: '', args: []);
  }

  /// `Не удалось запустить приложение`
  String get initFailed {
    return Intl.message(
      'Не удалось запустить приложение',
      name: 'initFailed',
      desc: '',
      args: [],
    );
  }

  /// `Повторить`
  String get retry {
    return Intl.message('Повторить', name: 'retry', desc: '', args: []);
  }

  /// `Нет связи. Проверь интернет и попробуй снова.`
  String get offlineRetry {
    return Intl.message(
      'Нет связи. Проверь интернет и попробуй снова.',
      name: 'offlineRetry',
      desc: '',
      args: [],
    );
  }

  /// `Нет связи. Чек без сети провести нельзя.`
  String get offlineBanner {
    return Intl.message(
      'Нет связи. Чек без сети провести нельзя.',
      name: 'offlineBanner',
      desc: '',
      args: [],
    );
  }

  /// `Что-то пошло не так. Попробуй ещё раз.`
  String get genericError {
    return Intl.message(
      'Что-то пошло не так. Попробуй ещё раз.',
      name: 'genericError',
      desc: '',
      args: [],
    );
  }

  /// `Клиенты`
  String get tabCustomers {
    return Intl.message('Клиенты', name: 'tabCustomers', desc: '', args: []);
  }

  /// `Команда`
  String get tabTeam {
    return Intl.message('Команда', name: 'tabTeam', desc: '', args: []);
  }

  /// `Скан`
  String get tabScan {
    return Intl.message('Скан', name: 'tabScan', desc: '', args: []);
  }

  /// `Точки`
  String get tabStores {
    return Intl.message('Точки', name: 'tabStores', desc: '', args: []);
  }

  /// `Ещё`
  String get tabMore {
    return Intl.message('Ещё', name: 'tabMore', desc: '', args: []);
  }

  /// `Смена`
  String get tabShift {
    return Intl.message('Смена', name: 'tabShift', desc: '', args: []);
  }

  /// `Карта`
  String get tabCard {
    return Intl.message('Карта', name: 'tabCard', desc: '', args: []);
  }

  /// `Чеки`
  String get tabReceipts {
    return Intl.message('Чеки', name: 'tabReceipts', desc: '', args: []);
  }

  /// `Профиль`
  String get tabProfile {
    return Intl.message('Профиль', name: 'tabProfile', desc: '', args: []);
  }

  /// `Карта`
  String get card {
    return Intl.message('Карта', name: 'card', desc: '', args: []);
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[Locale.fromSubtags(languageCode: 'ru')];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<AppLocalizations> load(Locale locale) => AppLocalizations.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
