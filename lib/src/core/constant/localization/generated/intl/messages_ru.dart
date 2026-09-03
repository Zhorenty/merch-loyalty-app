// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ru locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'ru';

  static String m0(amount) => "Сумма ${amount} ₽";

  static String m1(version) => "Версия ${version}+1";

  static String m2(min) => "Можно списать от ${min} баллов";

  static String m3(points) => "Начислим: ${points} б.";

  static String m4(points) => "Начислено ${points} б.";

  static String m5(points) => "На карте ${points} б.";

  static String m6(amount) => "К оплате: ${amount} ₽";

  static String m7(points) => "Баланс после ${points} б.";

  static String m8(time, redeem, earn) =>
      "${time} · списано ${redeem} · начислено ${earn}";

  static String m9(min) => "Списать можно от ${min} баллов";

  static String m10(min) => "Списание от ${min} баллов";

  static String m11(points) => "Списать: ${points} б. = ${points} ₽";

  static String m12(min) => "Минимум для списания — ${min} б.";

  static String m13(points) => "Списано ${points} б.";

  static String m14(id) => "Точка ${id}";

  static String m15(version) =>
      "Минимальная версия ${version}. Сканер закрыт, пока не поставишь новую сборку.";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "active": MessageLookupByLibrary.simpleMessage("активен"),
    "addressHint": MessageLookupByLibrary.simpleMessage("Адрес"),
    "addressMissing": MessageLookupByLibrary.simpleMessage("Адрес не указан"),
    "adjustDeltaRequired": MessageLookupByLibrary.simpleMessage(
      "Укажи ненулевую дельту",
    ),
    "adjustReasonRequired": MessageLookupByLibrary.simpleMessage(
      "Укажи причину правки",
    ),
    "amountHint": MessageLookupByLibrary.simpleMessage("Сумма чека, ₽"),
    "amountRub": m0,
    "anotherCard": MessageLookupByLibrary.simpleMessage("Ещё карту"),
    "appTitle": MessageLookupByLibrary.simpleMessage("MERCH Касса"),
    "appVersion": m1,
    "back": MessageLookupByLibrary.simpleMessage("Назад"),
    "barcodeOrUuidHint": MessageLookupByLibrary.simpleMessage("MCH-… или UUID"),
    "block": MessageLookupByLibrary.simpleMessage("Заблокировать"),
    "blocked": MessageLookupByLibrary.simpleMessage("блок"),
    "calculate": MessageLookupByLibrary.simpleMessage("Рассчитать"),
    "canRedeemFrom": m2,
    "cancel": MessageLookupByLibrary.simpleMessage("Отмена"),
    "card": MessageLookupByLibrary.simpleMessage("Карта"),
    "cardAlreadyExists": MessageLookupByLibrary.simpleMessage("Карта уже есть"),
    "cardNotFound": MessageLookupByLibrary.simpleMessage("Карта не найдена"),
    "changePoints": MessageLookupByLibrary.simpleMessage("Изменить баллы"),
    "close": MessageLookupByLibrary.simpleMessage("Закрыть"),
    "closeShift": MessageLookupByLibrary.simpleMessage("Закрыть смену"),
    "commitReceipt": MessageLookupByLibrary.simpleMessage("Провести чек"),
    "confirm": MessageLookupByLibrary.simpleMessage("Подтвердить"),
    "create": MessageLookupByLibrary.simpleMessage("Создать"),
    "customer": MessageLookupByLibrary.simpleMessage("Клиент"),
    "customerSearchHint": MessageLookupByLibrary.simpleMessage(
      "Barcode, телефон, имя",
    ),
    "customers": MessageLookupByLibrary.simpleMessage("Клиенты"),
    "customersEmpty": MessageLookupByLibrary.simpleMessage("Никого не нашли"),
    "customersEmptyHint": MessageLookupByLibrary.simpleMessage(
      "Попробуй barcode или телефон",
    ),
    "delete": MessageLookupByLibrary.simpleMessage("Удалить"),
    "deleteStoreTitle": MessageLookupByLibrary.simpleMessage("Удалить точку?"),
    "deltaHint": MessageLookupByLibrary.simpleMessage("Дельта, можно минус"),
    "done": MessageLookupByLibrary.simpleMessage("Готово"),
    "downloadApk": MessageLookupByLibrary.simpleMessage("Скачать APK"),
    "earnLine": m3,
    "earnedPoints": m4,
    "employee": MessageLookupByLibrary.simpleMessage("Сотрудник"),
    "emptyScanHint": MessageLookupByLibrary.simpleMessage(
      "Отсканируй карту на кассе",
    ),
    "emptyTitle": MessageLookupByLibrary.simpleMessage("Пока пусто"),
    "enterAmount": MessageLookupByLibrary.simpleMessage("Введи сумму чека"),
    "enterCode": MessageLookupByLibrary.simpleMessage("Ввести код"),
    "enterLoginAndPassword": MessageLookupByLibrary.simpleMessage(
      "Введи логин и пароль",
    ),
    "find": MessageLookupByLibrary.simpleMessage("Найти"),
    "genericError": MessageLookupByLibrary.simpleMessage(
      "Что-то пошло не так. Попробуй ещё раз.",
    ),
    "goToReceipt": MessageLookupByLibrary.simpleMessage("Сразу к чеку"),
    "gotIt": MessageLookupByLibrary.simpleMessage("Понятно"),
    "guest": MessageLookupByLibrary.simpleMessage("Гость"),
    "idempotentReplay": MessageLookupByLibrary.simpleMessage(
      "Чек уже был проведён — баллы не менялись",
    ),
    "inactive": MessageLookupByLibrary.simpleMessage("выкл"),
    "initFailed": MessageLookupByLibrary.simpleMessage(
      "Не удалось запустить приложение",
    ),
    "issueCard": MessageLookupByLibrary.simpleMessage("Выдать карту"),
    "loginAndNameRequired": MessageLookupByLibrary.simpleMessage(
      "Логин и имя обязательны",
    ),
    "loginHint": MessageLookupByLibrary.simpleMessage("Логин"),
    "loyaltyRules": MessageLookupByLibrary.simpleMessage("Правила лояльности"),
    "manualAdjust": MessageLookupByLibrary.simpleMessage("Ручная правка"),
    "more": MessageLookupByLibrary.simpleMessage("Ещё"),
    "nameHint": MessageLookupByLibrary.simpleMessage("Имя"),
    "nameOptional": MessageLookupByLibrary.simpleMessage("Имя (необязательно)"),
    "newPasswordOptional": MessageLookupByLibrary.simpleMessage(
      "Новый пароль (необязательно)",
    ),
    "newStaff": MessageLookupByLibrary.simpleMessage("Новый сотрудник"),
    "newStore": MessageLookupByLibrary.simpleMessage("Новая точка"),
    "offlineBanner": MessageLookupByLibrary.simpleMessage(
      "Нет связи. Чек без сети провести нельзя.",
    ),
    "offlineCommitDisabled": MessageLookupByLibrary.simpleMessage(
      "Нет связи — чек не отправится",
    ),
    "offlineRetry": MessageLookupByLibrary.simpleMessage(
      "Нет связи. Проверь интернет и попробуй снова.",
    ),
    "onCardPoints": m5,
    "passwordHint": MessageLookupByLibrary.simpleMessage("Пароль"),
    "passwordOrPinHint": MessageLookupByLibrary.simpleMessage("Пароль или PIN"),
    "passwordRequired": MessageLookupByLibrary.simpleMessage("Задай пароль"),
    "payable": MessageLookupByLibrary.simpleMessage("К оплате"),
    "payableLine": m6,
    "phoneConsent": MessageLookupByLibrary.simpleMessage(
      "Клиент согласен на обработку телефона",
    ),
    "phoneConsentRequired": MessageLookupByLibrary.simpleMessage(
      "Нужно согласие, чтобы сохранить телефон",
    ),
    "phoneOptional": MessageLookupByLibrary.simpleMessage(
      "Телефон (необязательно)",
    ),
    "points": MessageLookupByLibrary.simpleMessage("баллов"),
    "pointsAfter": m7,
    "pointsOnCard": MessageLookupByLibrary.simpleMessage("баллов на карте"),
    "profile": MessageLookupByLibrary.simpleMessage("Профиль"),
    "reasonHint": MessageLookupByLibrary.simpleMessage("Причина"),
    "receipt": MessageLookupByLibrary.simpleMessage("Чек"),
    "receiptSubtitle": m8,
    "redeemBelowMin": m9,
    "redeemFrom": m10,
    "redeemLine": m11,
    "redeemMinHint": m12,
    "redeemPointsLabel": MessageLookupByLibrary.simpleMessage("Списать баллы"),
    "redeemedPoints": m13,
    "refund": MessageLookupByLibrary.simpleMessage("Возврат"),
    "refundReceiptBody": MessageLookupByLibrary.simpleMessage(
      "Сервер сторнирует начисление и вернёт списанные баллы.",
    ),
    "refundReceiptTitle": MessageLookupByLibrary.simpleMessage("Вернуть чек?"),
    "retry": MessageLookupByLibrary.simpleMessage("Повторить"),
    "role": MessageLookupByLibrary.simpleMessage("Роль"),
    "roleAdmin": MessageLookupByLibrary.simpleMessage("Админ"),
    "roleManager": MessageLookupByLibrary.simpleMessage("Менеджер"),
    "save": MessageLookupByLibrary.simpleMessage("Сохранить"),
    "scanHint": MessageLookupByLibrary.simpleMessage(
      "Наведи на QR карты MERCH",
    ),
    "settingEarnMinReceipt": MessageLookupByLibrary.simpleMessage(
      "Минимум чека для начисления, ₽",
    ),
    "settingEarnPercent": MessageLookupByLibrary.simpleMessage(
      "Процент начисления",
    ),
    "settingRedeemMaxShare": MessageLookupByLibrary.simpleMessage(
      "Макс. доля чека, %",
    ),
    "settingRedeemMin": MessageLookupByLibrary.simpleMessage(
      "Минимум списания, б.",
    ),
    "settingRedeemRate": MessageLookupByLibrary.simpleMessage(
      "Курс списания, ₽ за балл",
    ),
    "settingsSaved": MessageLookupByLibrary.simpleMessage("Правила сохранены"),
    "shift": MessageLookupByLibrary.simpleMessage("Смена"),
    "shiftHistoryLater": MessageLookupByLibrary.simpleMessage(
      "История смены появится после выкладки API",
    ),
    "shiftHistoryNotCached": MessageLookupByLibrary.simpleMessage(
      "Список чеков не фейкаем с телефона",
    ),
    "showQrToCustomer": MessageLookupByLibrary.simpleMessage(
      "Покажи QR клиенту",
    ),
    "signIn": MessageLookupByLibrary.simpleMessage("Войти"),
    "staff": MessageLookupByLibrary.simpleMessage("Сотрудники"),
    "staffActive": MessageLookupByLibrary.simpleMessage("Активен"),
    "staffEmpty": MessageLookupByLibrary.simpleMessage("Нет сотрудников"),
    "staffEmptyHint": MessageLookupByLibrary.simpleMessage(
      "Добавь менеджера или админа",
    ),
    "staffMember": MessageLookupByLibrary.simpleMessage("Сотрудник"),
    "statusCommitted": MessageLookupByLibrary.simpleMessage("проведён"),
    "statusRefunded": MessageLookupByLibrary.simpleMessage("возврат"),
    "store": MessageLookupByLibrary.simpleMessage("Точка"),
    "storeIdLabel": m14,
    "storeNameHint": MessageLookupByLibrary.simpleMessage("Название"),
    "storeNameRequired": MessageLookupByLibrary.simpleMessage(
      "Название обязательно",
    ),
    "stores": MessageLookupByLibrary.simpleMessage("Точки"),
    "storesEmpty": MessageLookupByLibrary.simpleMessage("Нет точек"),
    "storesEmptyHint": MessageLookupByLibrary.simpleMessage(
      "Добавь магазин, чтобы бить чеки",
    ),
    "tabCard": MessageLookupByLibrary.simpleMessage("Карта"),
    "tabCustomers": MessageLookupByLibrary.simpleMessage("Клиенты"),
    "tabMore": MessageLookupByLibrary.simpleMessage("Ещё"),
    "tabProfile": MessageLookupByLibrary.simpleMessage("Профиль"),
    "tabReceipts": MessageLookupByLibrary.simpleMessage("Чеки"),
    "tabScan": MessageLookupByLibrary.simpleMessage("Скан"),
    "tabShift": MessageLookupByLibrary.simpleMessage("Смена"),
    "tabStores": MessageLookupByLibrary.simpleMessage("Точки"),
    "tabTeam": MessageLookupByLibrary.simpleMessage("Команда"),
    "unblock": MessageLookupByLibrary.simpleMessage("Разблокировать"),
    "updateApp": MessageLookupByLibrary.simpleMessage("Обнови приложение"),
    "updateAppBody": m15,
    "willEarn": MessageLookupByLibrary.simpleMessage("Начислим"),
  };
}
