#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает имена блокруемых реквизитов для механизма блокирования реквизитов БСП
//
// Возвращаемое значание:
//	Массив - имена блокируемых реквизитов
//
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить("ВалютаДенежныхСредств");
	Результат.Добавить("Владелец");
	Результат.Добавить("ПризнакКассовойКнигиОбособленногоПодразделения; ПризнакКассовойКнигиОбособленногоПодразделения1, ПризнакКассовойКнигиОбособленногоПодразделения2, ОбособленноеПодразделениеОрганизации");
	Результат.Добавить("ИспользоватьВКассовойКниге");
	Возврат Результат;
	
КонецФункции

// Функция определяет кассу выбранной организации.
//
// Возвращает кассу организации, если найдена одна касса.
// Возвращает Неопределено, если касса не найдена или касс больше одной.
//
// Параметры:
//  Организация - СправочникСсылка.Организации - Ссылка на организацию
//	Валюта - СправочникСсылка.Валюты - Валюта кассы
//
// Возвращаемое значение:
//	СправочникСсылка.Кассы - Найденная касса организации
//
Функция ПолучитьКассуПоУмолчанию(Организация, Валюта = Неопределено, НаправлениеДеятельности = Неопределено) Экспорт
	
	ЭтоБазовая = ПолучитьФункциональнуюОпцию("БазоваяВерсия");
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 2
	|	Кассы.Ссылка КАК Касса
	|ИЗ
	|	Справочник.Кассы КАК Кассы
	|ГДЕ
	|	Не Кассы.ПометкаУдаления
	|	И (Кассы.Владелец = &Организация
	|		ИЛИ &Организация = Неопределено)
	|	И (Кассы.ВалютаДенежныхСредств = &Валюта
	|		ИЛИ &Валюта = Неопределено)
	|	И (Кассы.НаправлениеДеятельности = &НаправлениеДеятельности
  	|			ИЛИ &НаправлениеДеятельности = НЕОПРЕДЕЛЕНО);
	|
  	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 2
	|	Кассы.Ссылка КАК Касса
	|ИЗ
	|	Справочник.Кассы КАК Кассы
	|ГДЕ
	|	Не Кассы.ПометкаУдаления
	|	И (Кассы.Владелец = &Организация
	|		ИЛИ &Организация = Неопределено)
	|	И (Кассы.ВалютаДенежныхСредств = &Валюта
	|		ИЛИ &Валюта = Неопределено)
	|");	
		
	Запрос.УстановитьПараметр("Организация", ?(ЗначениеЗаполнено(Организация), Организация, Неопределено));
	Запрос.УстановитьПараметр("Валюта", ?(ЗначениеЗаполнено(Валюта), Валюта, Неопределено));
	Запрос.УстановитьПараметр("НаправлениеДеятельности", ?(ЗначениеЗаполнено(НаправлениеДеятельности), НаправлениеДеятельности, Неопределено));
	
	Результат = Запрос.ВыполнитьПакет();
	ВыборкаПоНаправлению  = Результат[0].Выбрать();
	ВыборкаБезНаправления = Результат[1].Выбрать();

	Если ВыборкаПоНаправлению.Количество() = 1 И ВыборкаПоНаправлению.Следующий() Тогда
		Касса = ВыборкаПоНаправлению.Касса;
	ИначеЕсли ВыборкаБезНаправления.Количество() = 1 И ВыборкаБезНаправления.Количество() = 0 Тогда
		Касса = ВыборкаБезНаправления.Касса;	
	ИначеЕсли ЭтоБазовая И ВыборкаБезНаправления.Количество() = 0 Тогда
		Касса = СоздатьПредопределеннуюКассу();
	Иначе
		Касса = Справочники.Кассы.ПустаяСсылка();
	КонецЕсли;
	
	Возврат Касса;

КонецФункции

// Функция определяет реквизиты выбранной кассы.
//
// Параметры:
//  Касса - СправочникСсылка.Кассы - Ссылка на кассу
//
// Возвращаемое значение:
//	Структура - Реквизиты выбранной кассы
//
Функция ПолучитьРеквизитыКассы(Касса) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	Кассы.Владелец КАК Организация,
	|	Кассы.ВалютаДенежныхСредств КАК Валюта,
	|	Кассы.РазрешитьПлатежиБезУказанияЗаявок КАК РазрешитьПлатежиБезУказанияЗаявок
	|ИЗ
	|	Справочник.Кассы КАК Кассы
	|ГДЕ
	|	Кассы.Ссылка = &Касса
	|");
	
	Запрос.УстановитьПараметр("Касса", Касса);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Организация = Выборка.Организация;
		Валюта = Выборка.Валюта;
		РазрешитьПлатежиБезУказанияЗаявок = Выборка.РазрешитьПлатежиБезУказанияЗаявок;
	Иначе
		Организация = Справочники.Организации.ПустаяСсылка();
		Валюта = Справочники.Валюты.ПустаяСсылка();
		РазрешитьПлатежиБезУказанияЗаявок = Ложь;
	КонецЕсли;
	
	СтруктураРеквизитов = Новый Структура("Организация, Валюта, РазрешитьПлатежиБезУказанияЗаявок",
		Организация,
		Валюта,
		РазрешитьПлатежиБезУказанияЗаявок);
	
	Если ПривилегированныйРежим() Тогда
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли; 
	
	Возврат СтруктураРеквизитов;

КонецФункции

//Возвращает имена реквизитов, которые не должны отображаться в списке реквизитов обработки ГрупповоеИзменениеОбъектов
//
//	Возвращаемое значение:
//		Массив - массив имен реквизитов
//
Функция РеквизитыНеРедактируемыеВГрупповойОбработке() Экспорт
	
	НеРедактируемыеРеквизиты = Новый Массив;
	НеРедактируемыеРеквизиты.Добавить("Владелец");
	НеРедактируемыеРеквизиты.Добавить("ОбособленноеПодразделениеОрганизации");
	НеРедактируемыеРеквизиты.Добавить("ПоОбособленномуПодразделению");
		
	Возврат НеРедактируемыеРеквизиты;
	
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ВыборКассГоловнойОрганизации") Тогда
		
		Если Не ПолучитьФункциональнуюОпцию("ИспользоватьОбособленныеПодразделенияВыделенныеНаБаланс") Тогда
			Возврат;
		КонецЕсли;
		
		Организация = Неопределено;
		Параметры.Отбор.Свойство("Владелец", Организация);
		
		Если Не ЗначениеЗаполнено(Организация)
			Или Не ОбщегоНазначенияУТВызовСервера.ЗначениеРеквизитаОбъекта(Организация, "ОбособленноеПодразделение") Тогда
			Возврат;
		КонецЕсли;
		
		ЕстьРасчетыСКлиентами = Параметры.Свойство("ЕстьРасчетыСКлиентами");
		ЕстьРасчетыСПоставщиками = Параметры.Свойство("ЕстьРасчетыСПоставщиками");
		
		СтандартнаяОбработка = Ложь;
		Запрос = Новый Запрос("ВЫБРАТЬ
		|	&Организация
		|ПОМЕСТИТЬ ДоступныеОрганизации
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	Организации.ГоловнаяОрганизация
		|ИЗ
		|	Справочник.Организации КАК Организации
		|ГДЕ
		|	Организации.Ссылка = &Организация
		|	И Организации.ДопускаютсяВзаиморасчетыЧерезГоловнуюОрганизацию
		|	И (&ЕстьРасчетыСКлиентами ИЛИ &ЕстьРасчетыСПоставщиками)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Кассы.Ссылка,
		|	Кассы.Наименование,
		|	Кассы.Владелец
		|ПОМЕСТИТЬ Данные
		|ИЗ
		|	ДоступныеОрганизации КАК ДоступныеОрганизации
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Кассы КАК Кассы
		|		ПО ДоступныеОрганизации.Организация = Кассы.Владелец
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Данные.Ссылка
		|ИЗ
		|	Данные КАК Данные
		|ГДЕ
		|	&УсловиеПоискаПоСтроке И &ПрочиеУсловия
		|
		|УПОРЯДОЧИТЬ ПО
		|	Данные.Владелец,
		|	Данные.Наименование
		|АВТОУПОРЯДОЧИВАНИЕ");
		Запрос.УстановитьПараметр("Организация", Организация);
		Запрос.УстановитьПараметр("ЕстьРасчетыСКлиентами", ЕстьРасчетыСКлиентами);
		Запрос.УстановитьПараметр("ЕстьРасчетыСПоставщиками", ЕстьРасчетыСПоставщиками);
		
	КонецЕсли;
	
	Если Не СтандартнаяОбработка Тогда
		
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеПоискаПоСтроке", "Данные.Наименование ПОДОБНО &СтрокаПоиска");
		Запрос.УстановитьПараметр("СтрокаПоиска", ?(Параметры.СтрокаПоиска = Неопределено, "", Параметры.СтрокаПоиска) + "%");
		
		ПрочиеУсловия = "";
		Для Каждого Элемент Из Параметры.Отбор Цикл
			
			Если Элемент.Ключ = "Владелец" И Параметры.Свойство("ВыборКассГоловнойОрганизации") Тогда
				Продолжить;
			Иначе
				
				ПрочиеУсловия = ПрочиеУсловия + "Данные.Ссылка." + Элемент.Ключ 
					+ ?(ТипЗнч(Элемент.Значение) = Тип("ФиксированныйМассив"), " В (&", " = (&") 
					+ Элемент.Ключ + ") И ";
				Запрос.УстановитьПараметр(Элемент.Ключ, Элемент.Значение);
				
			КонецЕсли;
			
		КонецЦикла;
		
		Если ПрочиеУсловия = "" Тогда
			ПрочиеУсловия = "Истина";
		Иначе
			ПрочиеУсловия = Лев(ПрочиеУсловия, СтрДлина(ПрочиеУсловия) - 3);
		КонецЕсли;
		
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ПрочиеУсловия", ПрочиеУсловия);
		
		ДанныеВыбора = Новый СписокЗначений;
		ДанныеВыбора.ЗагрузитьЗначения(Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка"));
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)

	Если ВидФормы = "ФормаСписка" И Не ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоКасс") Тогда
		
		Параметры.Вставить("Ключ", ОбщегоНазначенияУТВызовСервера.КассаОрганизацииПоУмолчанию());
		ВыбраннаяФорма = "ФормаЭлемента";
		СтандартнаяОбработка = Ложь;
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбновлениеИнформационнойБазы

// Создает единственную кассу, используемую по умолчанию
//
Функция СоздатьПредопределеннуюКассу()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	1
	|ИЗ
	|	Справочник.Кассы КАК Кассы");
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		
		СправочникОбъект = СоздатьЭлемент();
		ОрганизацияПоУмолчанию = Справочники.Организации.ОрганизацияПоУмолчанию();
		Если ЗначениеЗаполнено(ОрганизацияПоУмолчанию) Тогда
			СправочникОбъект.Владелец = ОрганизацияПоУмолчанию;
			СправочникОбъект.Наименование = НСтр("ru='Касса предприятия';uk='Каса підприємства'");
			СправочникОбъект.ВалютаДенежныхСредств = Константы.ВалютаУправленческогоУчета.Получить();
			СправочникОбъект.Записать();
		КонецЕсли;
		
		Возврат СправочникОбъект.Ссылка;
	КонецЕсли;
	
	Возврат Справочники.Кассы.ПустаяСсылка();
	
КонецФункции


#КонецОбласти

#КонецЕсли