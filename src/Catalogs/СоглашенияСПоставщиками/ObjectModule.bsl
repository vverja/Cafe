#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Заполняет реквизиты документа по умолчанию
//
Процедура ЗаполнитьРеквизитыПоУмолчанию() Экспорт
	
	ПартнерыИКонтрагенты.ЗаполнитьКонтрагентаПартнераПоУмолчанию(Партнер, Контрагент);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	
	Если ТипДанныхЗаполнения = Тип("Структура") Тогда
		ЗаполнитьДокументПоОтбору(ДанныеЗаполнения);
	ИначеЕсли ТипДанныхЗаполнения = Тип("СправочникСсылка.Партнеры") Тогда
		ЗаполнитьДокументНаОснованииПартнера(ДанныеЗаполнения);
	КонецЕсли;

	ИнициализироватьСправочник();
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьПоступлениеПоНесколькимЗаказам") Тогда
		ВариантПриемкиТоваров = Перечисления.ВариантыПриемкиТоваров.НеРазделенаПоЗаказамИНакладным;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	// Дата начала действия соглашения должна быть не меньше, чем дата документа.
	Если ЗначениеЗаполнено(Дата) И ЗначениеЗаполнено(ДатаНачалаДействия) Тогда	
			
		Если НачалоДня(Дата) > ДатаНачалаДействия Тогда
				
			ТекстОшибки = НСтр("ru='Дата начала действия соглашения должна быть не меньше даты соглашения';uk='Дата початку дії оферти повинна бути не менше дати оферти'");

			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				ЭтотОбъект,
				"ДатаНачалаДействия",
				,
				Отказ);

		Конецесли;

	КонецЕсли;

	// Дата окончания действия соглашения должна быть не меньше, чем дата документа.
	Если ЗначениеЗаполнено(Дата) И ЗначениеЗаполнено(ДатаОкончанияДействия) Тогда	
			
		Если НачалоДня(Дата) > ДатаОкончанияДействия Тогда
				
			ТекстОшибки = НСтр("ru='Дата окончания действия соглашения должна быть не меньше даты соглашения';uk='Дата закінчення дії оферти повинна бути не менше дати оферти'");

			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				ЭтотОбъект,
				"ДатаОкончанияДействия",
				,
				Отказ);

		Конецесли;

	КонецЕсли;

	// Дата окончания действия соглашения должна быть не меньше, чем дата начала действия.
	Если ЗначениеЗаполнено(ДатаНачалаДействия) И ЗначениеЗаполнено(ДатаОкончанияДействия) Тогда
				
		Если ДатаНачалаДействия > ДатаОкончанияДействия Тогда
			
			ТекстОшибки = НСтр("ru='Дата окончания действия соглашения должна быть не меньше даты начала действия';uk='Дата закінчення дії оферти повинна бути не менше дати початку дії'");

			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				ЭтотОбъект,
				"ДатаОкончанияДействия",
				,
				Отказ);
		
		Конецесли;

	КонецЕсли;

	Если РассчитыватьДатуВозвратаТарыПоКалендарю И ВозвращатьМногооборотнуюТару И Не ЗначениеЗаполнено(КалендарьВозвратаТары) Тогда
		
		ТекстОшибки = НСтр("ru='Не указан календарь для учета возврата тары по рабочим дням.';uk='Не зазначений календар для обліку повернення тари по робочих днях.'");
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстОшибки,
			,
			"Объект.КалендарьВозвратаТары",
			,
			Отказ);
		
	КонецЕсли;
		
	Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ОказаниеАгентскихУслуг
		И ИспользоватьУказанныеАгентскиеУслуги
		И АгентскиеУслуги.Количество() = 0 
	Тогда
		ТекстОшибки = НСтр("ru='Не выбраны агентские услуги.';uk='Не вибрані агентські послуги.'");
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстОшибки,
			,
			"Объект.ИспользоватьУказанныеАгентскиеУслуги",
			,
			Отказ);
	КонецЕсли;

	МассивВсехРеквизитов = Новый Массив;
	МассивРеквизитовОперации = Новый Массив;
	
	Справочники.СоглашенияСПоставщиками.ЗаполнитьИменаРеквизитовПоХозяйственнойОперации(
		ХозяйственнаяОперация,
		МассивВсехРеквизитов,
		МассивРеквизитовОперации);
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	ОбщегоНазначенияУТКлиентСервер.ЗаполнитьМассивНепроверяемыхРеквизитов(
		МассивВсехРеквизитов,
		МассивРеквизитовОперации,
		МассивНепроверяемыхРеквизитов);
	
	Если ИспользуютсяДоговорыКонтрагентов Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ПорядокРасчетов");
	КонецЕсли;
	
	МассивНепроверяемыхРеквизитов.Добавить("ЭтапыГрафикаОплаты.ПроцентЗалогаЗаТару");
	Если ТребуетсяЗалогЗаТару Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ЭтапыГрафикаОплаты.ПроцентПлатежа");
		Для Каждого ЭтапОплаты Из ЭтапыГрафикаОплаты Цикл
			Если Не ЗначениеЗаполнено(ЭтапОплаты.ПроцентПлатежа) И Не ЗначениеЗаполнено(ЭтапОплаты.ПроцентЗалогаЗаТару) Тогда
				ТекстОшибки = НСтр("ru='Для этапа должен быть указан процент платежа или процент залога за тару в строке %НомерСтроки% списка ""Этапы графика оплаты""';uk='Для етапу повинен бути вказаний відсоток платежу або відсоток застави за тару в рядку %НомерСтроки% списку ""Етапи графіка оплати""'");
				ТекстОшибки = СтрЗаменить(ТекстОшибки, "%НомерСтроки%", ЭтапОплаты.НомерСтроки);
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					ТекстОшибки,
					ЭтотОбъект,
					ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ЭтапыГрафикаОплаты", ЭтапОплаты.НомерСтроки, "ПроцентПлатежа"),
					,
					Отказ);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(
		ПроверяемыеРеквизиты,
		МассивНепроверяемыхРеквизитов);
	
	ВзаиморасчетыСервер.ПроверитьПорядокОплаты(ЭтотОбъект, Отказ);
	
	ПроверитьАгентскиеУслуги(Отказ);
	
	Если Не Отказ И ОбщегоНазначенияУТ.ПроверитьЗаполнениеРеквизитовОбъекта(ЭтотОбъект, ПроверяемыеРеквизиты) Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры // ОбработкаПроверкиЗаполнения()

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ОбщегоНазначенияУТ.ИзменитьПризнакСогласованностиСправочника(
		ЭтотОбъект,
		Перечисления.СтатусыСоглашенийСПоставщиками.НеСогласовано);
	
	Если ЗначениеЗаполнено(Склад) Тогда
		
		СкладГруппа = Справочники.Склады.ЭтоГруппаИСкладыИспользуютсяВТЧДокументовЗакупки(Склад);
		
		Если Не СкладГруппа
			И (Не ПолучитьФункциональнуюОпцию("ИспользоватьОрдернуюСхемуПриПоступлении", Новый Структура("Склад", Склад))
				ИЛИ ЗначениеЗаполнено(ДатаОкончанияДействия)
					И ДатаОкончанияДействия < ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Склад,"ДатаНачалаОрдернойСхемыПриПоступлении")) Тогда
			ВариантПриемкиТоваров = Перечисления.ВариантыПриемкиТоваров.РазделенаПоЗаказамИНакладным;
		КонецЕсли;
		
	КонецЕсли;
	
	// Очистим реквизиты документа не используемые для хозяйственной операции.
	МассивВсехРеквизитов = Новый Массив;
	МассивРеквизитовОперации = Новый Массив;
	Справочники.СоглашенияСПоставщиками.ЗаполнитьИменаРеквизитовПоХозяйственнойОперации(
		ХозяйственнаяОперация,
		МассивВсехРеквизитов,
		МассивРеквизитовОперации);
	ДенежныеСредстваСервер.ОчиститьНеиспользуемыеРеквизиты(
		ЭтотОбъект,
		МассивВсехРеквизитов,
		МассивРеквизитовОперации);
	
	Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ЗакупкаПоИмпорту 
			ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПриемНаКомиссиюИмпорт Тогда
		НалогообложениеНДС = Перечисления.ТипыНалогообложенияНДС.ПродажаНеОблагаетсяНДС;
	КонецЕсли;

	// Отработка смены пометки удаления
	Если Не ЭтоНовый() И ПометкаУдаления <> ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "ПометкаУдаления") Тогда
		Документы.СоглашениеСПоставщиком.УстановитьПометкуУдаления(Ссылка, ПометкаУдаления);
		Справочники.ВидыЗапасов.УстановитьПометкуУдаления(Новый Структура("Соглашение", Ссылка), ПометкаУдаления);
	КонецЕсли;
	
	Если ИспользуютсяДоговорыКонтрагентов Тогда
		ПорядокРасчетов = Перечисления.ПорядокРасчетов.ПустаяСсылка();
	КонецЕсли;
	
	Если ПометкаУдаления Тогда
		Статус = Перечисления.СтатусыСоглашенийСПоставщиками.Закрыто;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Валюта) 
	   И НЕ ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоВалют") Тогда
		Валюта = Константы.ВалютаРегламентированногоУчета.Получить();
	КонецЕсли; 
 	
	
	Если ЗначениеЗаполнено(Организация) И УдержатьВознаграждение Тогда
		Если НДСОбщегоНазначенияПовтИсп.ОрганизацияПлательщикНДС(Организация, Дата) Тогда
			УдержатьВознаграждение = Ложь;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры // ПередЗаписью()

Процедура ПриКопировании(ОбъектКопирования)

	Статус                  = Перечисления.СтатусыСоглашенийСПоставщиками.НеСогласовано;
	Согласован              = Ложь;
	ДатаНачалаДействия      = '00010101';
	ДатаОкончанияДействия   = '00010101';

	ИнициализироватьСправочник(Ложь);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// См. описание в комментарии к одноименной процедуре в модуле УправлениеДоступом.
//
Процедура ЗаполнитьНаборыЗначенийДоступа(Таблица) Экспорт
	
	СтрокаТаб = Таблица.Добавить();
	СтрокаТаб.ЗначениеДоступа = Партнер;

	Если ЗначениеЗаполнено(Организация) Тогда
		СтрокаТаб = Таблица.Добавить();
		СтрокаТаб.ЗначениеДоступа = Организация;
	КонецЕсли;

	Если ЗначениеЗаполнено(Склад) Тогда
		СтрокаТаб = Таблица.Добавить();
		СтрокаТаб.ЗначениеДоступа = Склад;
	КонецЕсли;
	
КонецПроцедуры

#Область ИнициализацияИЗаполнение

// Заполняет соглашение с поставщиком на основании партнера
//
// Параметры:
//	Основание - СправочникСсылка.Партнеры - ссылка на партнера
//
Процедура ЗаполнитьДокументНаОснованииПартнера(Знач Основание)
	
	Партнер = Основание;
	ЗакупкиСервер.ПроверитьВозможностьВводаНаОснованииПартнераПоставщикаКонкурента(Партнер);
	ЗаполнитьРеквизитыПоУмолчанию();
	
КонецПроцедуры

// Заполняет соглашение с поставщиком в соответствии с отбором.
//
// Параметры:
//	ДанныеЗаполнения - Структура - Структура со значениями заполнения
//
Процедура ЗаполнитьДокументПоОтбору(Знач ДанныеЗаполнения)
	
	Если ДанныеЗаполнения.Свойство("Партнер") Тогда
		
		Партнер = ДанныеЗаполнения.Партнер;
		ЗакупкиСервер.ПроверитьВозможностьВводаНаОснованииПартнераПоставщикаКонкурента(Партнер);
		ЗаполнитьРеквизитыПоУмолчанию();
		
	КонецЕсли;
	
	Если ДанныеЗаполнения.Свойство("Организация") Тогда
		Организация = ДанныеЗаполнения.Организация;
	КонецЕсли;
	
КонецПроцедуры

// Инициализирует соглашение с поставщиком
//
Процедура ИнициализироватьСправочник(ЗаполнятьВсеРеквизиты = Истина)

	Менеджер = Пользователи.ТекущийПользователь();
	Статус = Метаданные().Реквизиты.Статус.ЗначениеЗаполнения;
	
	Если ЗаполнятьВсеРеквизиты Тогда
		
		Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
		Склад = ЗначениеНастроекПовтИсп.ПолучитьСкладПоУмолчанию(Склад, ПолучитьФункциональнуюОпцию("ИспользоватьСкладыВТабличнойЧастиДокументовЗакупки"));
		ПорядокОплаты = Перечисления.ПорядокОплатыПоСоглашениям.ПолучитьПорядокОплатыПоУмолчанию(Валюта, Неопределено);
		ГруппаФинансовогоУчета = Справочники.ГруппыФинансовогоУчетаРасчетов.ПолучитьГруппуФинансовогоУчетаПоУмолчанию(ПорядокОплаты);
		НалогообложениеНДС     = НДСОбщегоНазначенияСервер.ПолучитьНалогообложениеНДСПоУмолчанию(Организация, Контрагент, Неопределено, Дата, Ложь);
	
		Если Не ИспользуютсяДоговорыКонтрагентов Тогда
			Если ПолучитьФункциональнуюОпцию("ИспользоватьЗаказыПоставщикам")
				ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПриемНаКомиссию Тогда
				ПорядокРасчетов = Перечисления.ПорядокРасчетов.ПоЗаказамНакладным;
			Иначе
				ПорядокРасчетов = Перечисления.ПорядокРасчетов.ПоНакладным;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

// Проверяет на отсутствие совпадающих по сроку и реализуемым услугам
// агентские соглашения
Процедура ПроверитьАгентскиеУслуги(Отказ)
	
	Если ХозяйственнаяОперация <> Перечисления.ХозяйственныеОперации.ОказаниеАгентскихУслуг
		ИЛИ Статус <> Перечисления.СтатусыСоглашенийСПоставщиками.Действует
	Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Организация) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Для данной хозяйственной операции необходимо указание организации';uk='Для даної господарської операції необхідно зазначення організації'"),,,"Организация",Отказ);
	КонецЕсли;
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Услуги.Номенклатура КАК Номенклатура,
	|	Услуги.Характеристика КАК Характеристика
	|ПОМЕСТИТЬ ВыбранныеУслуги
	|ИЗ
	|	&Услуги КАК Услуги
	|;
	|///////////////////////////////////////////////
	|// По всем услугам принципала
	|ВЫБРАТЬ
	|	ДубльСоглашения.Наименование КАК Наименование,
	|	НЕОПРЕДЕЛЕНО КАК Номенклатура,
	|	НЕОПРЕДЕЛЕНО КАК Характеристика
	|ИЗ
	|	Справочник.СоглашенияСПоставщиками КАК ДубльСоглашения
	|ГДЕ
	|	ДубльСоглашения.Ссылка <> &Ссылка
	|	И ДубльСоглашения.Организация = &Организация
	|	И ДубльСоглашения.Партнер = &Партнер
	|	И ДубльСоглашения.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ОказаниеАгентскихУслуг)
	|	И ДубльСоглашения.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыСоглашенийСПоставщиками.Действует)
	|	И (НЕ ДубльСоглашения.ИспользоватьУказанныеАгентскиеУслуги
	|		ИЛИ &ПоВсемУслугам)
	|	И ((&ДатаНачалаДействия >= ДубльСоглашения.ДатаНачалаДействия
	|		И (&ДатаНачалаДействия <= ДубльСоглашения.ДатаОкончанияДействия
	|				ИЛИ ДубльСоглашения.ДатаОкончанияДействия = ДАТАВРЕМЯ(1,1,1))
	|		И &ДатаНачалаДействия <> ДАТАВРЕМЯ(1,1,1))
	|		ИЛИ (&ДатаОкончанияДействия >=ДубльСоглашения.ДатаНачалаДействия
	|			И (&ДатаОкончанияДействия <= ДубльСоглашения.ДатаОкончанияДействия
	|				ИЛИ ДубльСоглашения.ДатаОкончанияДействия = ДАТАВРЕМЯ(1,1,1))
	|		) ИЛИ (&ДатаНачалаДействия = ДАТАВРЕМЯ(1,1,1) И &ДатаОкончанияДействия = ДАТАВРЕМЯ(1,1,1))
	|	)
	|
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|// По указанным агентским услугам принципала
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДубльСоглашения.Наименование КАК Наименование,
	|	ВыбранныеУслуги.Номенклатура КАК Номенклатура,
	|	ВыбранныеУслуги.Характеристика КАК Характеристика
	|ИЗ
	|	Справочник.СоглашенияСПоставщиками КАК ДубльСоглашения
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВыбранныеУслуги КАК ВыбранныеУслуги
	|	ПО ИСТИНА
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СоглашенияСПоставщиками.АгентскиеУслуги КАК ДублиУслуг
	|	ПО ДубльСоглашения.Ссылка = ДублиУслуг.Ссылка
	|		И ВыбранныеУслуги.Номенклатура = ДублиУслуг.Номенклатура
	|		И ВыбранныеУслуги.Характеристика = ДублиУслуг.Характеристика
	|ГДЕ
	|	ДубльСоглашения.Ссылка <> &Ссылка
	|	И ДубльСоглашения.Организация = &Организация
	|	И ДубльСоглашения.Партнер = &Партнер
	|	И ДубльСоглашения.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ОказаниеАгентскихУслуг)
	|	И ДубльСоглашения.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыСоглашенийСПоставщиками.Действует)
	|	И (НЕ (ДублиУслуг.Номенклатура ЕСТЬ NULL)
	|		ИЛИ НЕ ДубльСоглашения.ИспользоватьУказанныеАгентскиеУслуги
	|	)
	|	И ((&ДатаНачалаДействия >= ДубльСоглашения.ДатаНачалаДействия
	|		И (&ДатаНачалаДействия <= ДубльСоглашения.ДатаОкончанияДействия
	|				ИЛИ ДубльСоглашения.ДатаОкончанияДействия = ДАТАВРЕМЯ(1,1,1))
	|		И &ДатаНачалаДействия <> ДАТАВРЕМЯ(1,1,1))
	|		ИЛИ (&ДатаОкончанияДействия >=ДубльСоглашения.ДатаНачалаДействия
	|			И (&ДатаОкончанияДействия <= ДубльСоглашения.ДатаОкончанияДействия
	|				ИЛИ ДубльСоглашения.ДатаОкончанияДействия = ДАТАВРЕМЯ(1,1,1))
	|		) ИЛИ (&ДатаНачалаДействия = ДАТАВРЕМЯ(1,1,1) И &ДатаОкончанияДействия = ДАТАВРЕМЯ(1,1,1))
	|	)
	|");
	
	Запрос.УстановитьПараметр("Ссылка",Ссылка);
	Запрос.УстановитьПараметр("Организация",Организация);
	Запрос.УстановитьПараметр("Партнер",Партнер);
	Запрос.УстановитьПараметр("Услуги",АгентскиеУслуги.Выгрузить(,"Номенклатура, Характеристика"));
	Запрос.УстановитьПараметр("ПоВсемУслугам",НЕ ИспользоватьУказанныеАгентскиеУслуги);
	Запрос.УстановитьПараметр("ДатаНачалаДействия",ДатаНачалаДействия);
	Запрос.УстановитьПараметр("ДатаОкончанияДействия",ДатаОкончанияДействия);
	
	ШаблонСообщения = НСтр("ru='Обнаружено действующее соглашение %Наименование% %ДляУслуги%';uk='Виявлена діюча оферта %Наименование% %ДляУслуги%'");
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ТекстСообщения = СтрЗаменить(ШаблонСообщения, "%Наименование%", Строка(Выборка.Наименование));
		Если ЗначениеЗаполнено(Выборка.Номенклатура) Тогда
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ДляУслуги%", " " + НСтр("ru='для услуги';uk='для послуги'") + " " +Выборка.Номенклатура + ","+Выборка.Характеристика);
		Иначе
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ДляУслуги%", "");
		КонецЕсли;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,"Объект",Отказ);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
