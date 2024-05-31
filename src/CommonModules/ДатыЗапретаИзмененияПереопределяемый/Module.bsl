////////////////////////////////////////////////////////////////////////////////
// Подсистема "Даты запрета изменения".
// 
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Позволяет изменить работу интерфейса при встраивании.
//
// Параметры:
//  НастройкиРаботыИнтерфейса - Структура - содержит свойство:
//   * ИспользоватьВнешнихПользователей - Булево - (начальное значение Ложь),
//     если установить Истина, тогда даты запрета можно будет настраивать для внешних пользователей.
//
Процедура НастройкаИнтерфейса(НастройкиРаботыИнтерфейса) Экспорт
	
	ДатыЗапретаИзмененияУТ.НастройкаИнтерфейса(НастройкиРаботыИнтерфейса);
	
КонецПроцедуры

// Содержит описание таблиц и полей объектов для проверки запретов изменения данных.
//   Вызывается из процедуры ИзменениеЗапрещено общего модуля ДатыЗапретаИзменения,
//   используемой в подписке на событие ПередЗаписью объекта для проверки наличия
//   запретов и отказа от изменений запрещенного объекта.
//
// Параметры:
//  ИсточникиДанных - ТаблицаЗначений - с колонками:
//   * Таблица     - Строка - полное имя объекта метаданных,
//                   например, Метаданные.Документы.ПриходнаяНакладная.ПолноеИмя().
//   * ПолеДаты    - Строка - имя реквизита объекта или табличной части,
//                   например "Дата", "Товары.ДатаОтгрузки".
//   * Раздел      - Строка - имя предопределенного элемента
//                   "ПланВидовХарактеристикСсылка.РазделыДатЗапрета".
//   * ПолеОбъекта - Строка - имя реквизита объекта или реквизита табличной части,
//                   например "Организация", "Товары.Склад".
//
//  Для добавления строки имеется процедура ДобавитьСтроку в общем модуле ДатыЗапретаИзменения.
//
Процедура ЗаполнитьИсточникиДанныхДляПроверкиЗапретаИзменения(ИсточникиДанных) Экспорт
	
	ДатыЗапретаИзмененияУТ.ЗаполнитьИсточникиДанныхДляПроверкиЗапретаИзменения(ИсточникиДанных);
	
КонецПроцедуры

// Позволяет переопределить выполнение проверок запретов по произвольному условию.
//
// Параметры:
//  Объект       - СправочникОбъект,
//                 ДокументОбъект,
//                 ПланВидовХарактеристикОбъект,
//                 ПланСчетовОбъект,
//                 ПланВидовРасчетаОбъект,
//                 БизнесПроцессОбъект,
//                 ЗадачаОбъект,
//                 ПланОбменаОбъект - объект данных (ПередЗаписью или ПриЧтенииНаСервере).
//               - РегистрСведенийНаборЗаписей,
//                 РегистрНакопленияНаборЗаписей,
//                 РегистрБухгалтерииНаборЗаписей,
//                 РегистрРасчетаНаборЗаписей - набор записей (ПередЗаписью или ПриЧтенииНаСервере).
//
//                 Для документов в свойство ДополнительныеСвойства вставляется свойство РежимЗаписи,
//                 если вызов делается в процессе записи документа.
//  
//  ПроверкаЗапретаИзменения    - Булево - когда Истина, тогда проверка изменения выполняется.
//                                Если установить Ложь, тогда проверка запрета изменения будет пропущена.
//
//  УзелПроверкиЗапретаЗагрузки - Неопределено - проверка запрета загрузки не выполняется.
//                              - ПланыОбменаСсылка - проверка запрета загрузки выполняется. Если
//                                установить Неопределено, проверка запрета загрузки будет пропущена.
//
//  ВерсияОбъекта               - Строка - начальное значение "". Проверяются обе версии объекта.
//                                Если установить "СтараяВерсия" или "НоваяВерсия", тогда будет
//                                выполнена проверка только старой или только новой версии объекта.
//
Процедура ПередПроверкойЗапретаИзменения(Объект,
                                         ПроверкаЗапретаИзменения,
                                         УзелПроверкиЗапретаЗагрузки,
                                         ВерсияОбъекта) Экспорт
	
	ДатыЗапретаИзмененияУТ.ПередПроверкойЗапретаИзменения(
		Объект,
		ПроверкаЗапретаИзменения,
		УзелПроверкиЗапретаЗагрузки,
		ВерсияОбъекта);
		
	
КонецПроцедуры

#КонецОбласти
