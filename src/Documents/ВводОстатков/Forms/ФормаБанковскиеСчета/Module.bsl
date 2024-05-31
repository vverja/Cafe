
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();
	ИспользуетсяНесколькоСчетов = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоРасчетныхСчетов");
	
	УстановитьЗаголовок();
	
	Если НЕ (ИспользуетсяНесколькоСчетов ИЛИ ВозможностьОткрытияДокументаОтУстановленныхФО()) Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ИспользуетсяНесколькоСчетов Тогда
		ЕдинственныйСчет = ЗначениеНастроекПовтИсп.ПолучитьБанковскийСчетОрганизацииПоУмолчанию();
		ВалютаСчета = ЕдинственныйСчет.ВалютаДенежныхСредств;
		Если Объект.БанковскиеСчета.Количество() > 0 Тогда
			ОстатокНаСчете = Объект.БанковскиеСчета[0].Сумма;
		КонецЕсли;
	КонецЕсли;
	УстановитьВидимость();

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	ВводНаОсновании.ПриСозданииНаСервере(ЭтаФорма, Элементы.ПодменюСоздатьНаОсновании);
	
	МенюОтчеты.ПриСозданииНаСервере(ЭтаФорма, Элементы.ПодменюОтчеты);


КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// Обработчик механизма "ДатыЗапретаИзменения"
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если Не ИспользуетсяНесколькоСчетов Тогда
		Если НЕ ЗначениеЗаполнено(ЕдинственныйСчет) Тогда
			ПодробноеПредставлениеОшибки =
				НСтр("ru='В информационной базе используется один банковский счет,
                |но его свойства не настроены разделе ""Казначейство"" - ""Настройки и справочники"" - ""Настройка банковского счета"".'
                |;uk='В інформаційній базі використовується один банківський рахунок,
                |але його властивості не настроєні у розділі ""Казначейство"" - ""Настройки і довідники"" - ""Настройка банківського рахунку"".'")
			;
			Отказ = Истина;
			ВызватьИсключение ПодробноеПредставлениеОшибки;
		КонецЕсли;
		Объект.БанковскиеСчета.Очистить();
		НоваяСтрока = Объект.БанковскиеСчета.Добавить();
		НоваяСтрока.БанковскийСчет = ЕдинственныйСчет;
		НоваяСтрока.Сумма = ОстатокНаСчете;
		ПриИзмененииРеквизитаСервер(
			НоваяСтрока.Сумма, 
			НоваяСтрока.БанковскийСчет,
			ВалютаРегламентированногоУчета,
			Объект.Дата,
			НоваяСтрока.СуммаРегл);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ПараметрыЗаписи.Вставить("ТипОперации", Объект.ТипОперации);
	Оповестить("Запись_ВводОстатков", ПараметрыЗаписи, Объект.Ссылка);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	УстановитьЗаголовок();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовПодвалаФормы

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(
		Элемент.ТекстРедактирования, 
		ЭтотОбъект, 
		"Объект.Комментарий");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыБанковскиеСчета

&НаКлиенте
Процедура БанковскиеСчетаПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	Если НоваяСтрока и НЕ ИспользуетсяНесколькоСчетов Тогда
	
		Элемент.ТекущиеДанные.БанковскийСчет = ЕдинственныйСчет;
	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура БанковскиеСчетаБанковскийСчетПриИзменении(Элемент)
	
	ПриИзмененииРеквизита();
	
КонецПроцедуры

&НаКлиенте
Процедура БанковскиеСчетаСуммаПриИзменении(Элемент)
	
	ПриИзмененииРеквизита();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуОтчет(Команда)
	
	МенюОтчетыКлиент.ВыполнитьПодключаемуюКомандуОтчет(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуСоздатьНаОсновании(Команда)
	
	ВводНаОснованииКлиент.ВыполнитьПодключаемуюКомандуСоздатьНаОсновании(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьЗаголовок()
	
	АвтоЗаголовок = Ложь;
	Заголовок = Документы.ВводОстатков.ЗаголовокДокументаПоТипуОперации(Объект.Ссылка,
																						  Объект.Номер,
																						  Объект.Дата,
																						  Объект.ТипОперации);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПриИзмененииРеквизитаСервер(Сумма, БанковскийСчет, ВалютаРегламентированногоУчета, ДатаДокумента, СуммаРегл)
	
	Валюта = Справочники.БанковскиеСчетаОрганизаций.ПолучитьРеквизитыБанковскогоСчетаОрганизации(БанковскийСчет).Валюта;
	Если Валюта = ВалютаРегламентированногоУчета Тогда
		СуммаРегл = Сумма;
	Иначе
		КоэффициентПересчета = РаботаСКурсамиВалютУТ.ПолучитьКоэффициентПересчетаИзВалютыВВалюту(Валюта, ВалютаРегламентированногоУчета, ДатаДокумента);
		СуммаРегл = Окр(Сумма * КоэффициентПересчета, 2, 1);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииРеквизита()
	
	СтрокаТаблицы = Элементы.БанковскиеСчета.ТекущиеДанные;
		ПриИзмененииРеквизитаСервер(
			СтрокаТаблицы.Сумма, 
			СтрокаТаблицы.БанковскийСчет,
			ВалютаРегламентированногоУчета,
			Объект.Дата,
			СтрокаТаблицы.СуммаРегл);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимость()
	
	Элементы.ГруппаОдинСчет.Видимость = Не ИспользуетсяНесколькоСчетов;
	Элементы.ГруппаБанковскиеСчета.Видимость = ИспользуетсяНесколькоСчетов;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ВозможностьОткрытияДокументаОтУстановленныхФО()
	
	Результат = Истина;
	
	БанковскийСчет = ЗначениеНастроекПовтИсп.ПолучитьБанковскийСчетОрганизацииПоУмолчанию();
	Если Не ЗначениеЗаполнено(БанковскийСчет) Тогда
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 2
		|	БанковскиеСчетаОрганизаций.Ссылка
		|ИЗ
		|	Справочник.БанковскиеСчетаОрганизаций КАК БанковскиеСчетаОрганизаций");
		
		Если Запрос.Выполнить().Выбрать().Количество() = 2 Тогда
			ВызватьИсключение НСтр("ru='Не удалось заполнить поле ""Банковский счет"". В информационной базе введено несколько банковских счетов организаций,
            |Включите функциональную опцию ""Использовать несколько банковских счетов""!'
            |;uk='Не вдалося заповнити поле ""Банківський рахунок"". В інформаційній базі введено кілька банківських рахунків організацій,
            |Увімкніть функціональну опцію ""Використовувати кілька банківських рахунків""!'");
		Иначе
			ВызватьИсключение НСтр("ru='Не удалось заполнить поле ""Банковский счет"". Возможно, в информационной базе не введено ни одного банковского счета организации!';uk='Не вдалося заповнити поле ""Банківський рахунок"". Можливо, в інформаційній базі не введено жодного банківського рахунку організації!'");
		КонецЕсли;
		Результат = Ложь;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти
