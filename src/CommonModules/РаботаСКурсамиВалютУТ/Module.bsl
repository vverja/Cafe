
#Область ПрограммныйИнтерфейс

#Область ПроцедурыИФункцииРаботыСВалютами

// Функция получает коэффициент пересчета из текущей валюты в новую валюту.
//
Функция ПолучитьКоэффициентПересчетаИзВалютыВВалюту(ТекущаяВалюта, НоваяВалюта, Дата) Экспорт
	
	Если ТекущаяВалюта <> НоваяВалюта Тогда
		КурсТекущейВалюты = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ТекущаяВалюта, Дата);
		КурсНовойВалюты = РаботаСКурсамиВалют.ПолучитьКурсВалюты(НоваяВалюта, Дата);
		Если КурсНовойВалюты.Курс * КурсТекущейВалюты.Кратность <> 0 Тогда
			КоэффициентПересчета = (КурсТекущейВалюты.Курс * КурсНовойВалюты.Кратность) / (КурсНовойВалюты.Курс * КурсТекущейВалюты.Кратность);
		Иначе
			КоэффициентПересчета = 0;
		КонецЕсли;
	Иначе
		КоэффициентПересчета = 1;
	КонецЕсли;
	
	Возврат КоэффициентПересчета;
	
КонецФункции // ПолучитьКоэффициентПересчетаИзВалютыВВалюту()

// Функция получает коэффициенты пересчета сумм из валюты документа в валюту взаиморасчетов,
// в валюты управленческого и регламентированного учета.
//
Функция ПолучитьКоэффициентыПересчетаВалюты(ВалютаДокумента, ВалютаВзаиморасчетов, Период)Экспорт

	ВалютаУпр  = Константы.ВалютаУправленческогоУчета.Получить();
	ВалютаРегл = Константы.ВалютаРегламентированногоУчета.Получить();

	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	КурсыВалют.Валюта    КАК Валюта,
	|	КурсыВалют.Курс      КАК Курс,
	|	КурсыВалют.Кратность КАК Кратность
	|ИЗ
	|	РегистрСведений.КурсыВалют.СрезПоследних(&Период,
	|		Валюта = &ВалютаУпр ИЛИ Валюта = &ВалютаРегл ИЛИ Валюта = &ВалютаВзаиморасчетов ИЛИ Валюта = &ВалютаДокумента
	|	) КАК КурсыВалют
	|");
	Запрос.УстановитьПараметр("Период",               Период);
	Запрос.УстановитьПараметр("ВалютаУпр",            ВалютаУпр);
	Запрос.УстановитьПараметр("ВалютаРегл",           ВалютаРегл);
	Запрос.УстановитьПараметр("ВалютаДокумента",      ВалютаДокумента);
	Запрос.УстановитьПараметр("ВалютаВзаиморасчетов", ВалютаВзаиморасчетов);

	КурсВалютыУпр            = 1;
	КратностьВалютыУпр       = 1;

	КурсВалютыРегл           = 1;
	КратностьВалютыРегл      = 1;

	КурсВзаиморасчетов       = 1;
	КратностьВзаиморасчетов  = 1;

	КурсВалютыДокумента      = 1;
	КратностьВалютыДокумента = 1;

	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл

		Если Выборка.Валюта = ВалютаУпр Тогда

			КурсВалютыУпр      = Выборка.Курс;
			КратностьВалютыУпр = Выборка.Кратность;

		КонецЕсли;

		Если Выборка.Валюта = ВалютаРегл Тогда

			КурсВалютыРегл      = Выборка.Курс;
			КратностьВалютыРегл = Выборка.Кратность;

		КонецЕсли;

		Если Выборка.Валюта = ВалютаВзаиморасчетов Тогда

			КурсВзаиморасчетов      = Выборка.Курс;
			КратностьВзаиморасчетов = Выборка.Кратность;

		КонецЕсли;

		Если Выборка.Валюта = ВалютаДокумента Тогда

			КурсВалютыДокумента      = Выборка.Курс;
			КратностьВалютыДокумента = Выборка.Кратность;

		КонецЕсли;
	КонецЦикла;

	Результат = Новый Структура("КоэффициентПересчетаВВалютуВзаиморасчетов, КоэффициентПересчетаВВалютуУПР, КоэффициентПересчетаВВалютуРегл");

	Результат.КоэффициентПересчетаВВалютуУпр  = КурсВалютыДокумента * КратностьВалютыУпр / (КратностьВалютыДокумента * КурсВалютыУпр); 
	Результат.КоэффициентПересчетаВВалютуРегл = КурсВалютыДокумента * КратностьВалютыРегл / (КратностьВалютыДокумента * КурсВалютыРегл);
	Результат.КоэффициентПересчетаВВалютуВзаиморасчетов = КурсВалютыДокумента * КратностьВзаиморасчетов / (КратностьВалютыДокумента * КурсВзаиморасчетов);

	Возврат Результат;

КонецФункции

// Функция пересчитывает сумму документа из текущей валюты в новую валюту.
//
// Параметры:
//	СуммаДокумента - Число - Текущая сумма документа
//	ТекущаяВалюта - СправочникСсылка.Валюты - Текущая валюта документа
//	НоваяВалюта - СправочникСсылка.Валюты - Новая валюта документа
//	Дата - Дата - Дата документа
//
// Возвращаемое значение:
//	Число - Новая сумма документа
//
Функция ПересчитатьСуммуДокументаВВалюту(СуммаДокумента, ТекущаяВалюта, НоваяВалюта, Дата) Экспорт
	
	СтруктураКурсовТекущейВалюты = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ТекущаяВалюта, Дата);
	СтруктураКурсовНовойВалюты = РаботаСКурсамиВалют.ПолучитьКурсВалюты(НоваяВалюта, Дата);
	
	НоваяСуммаДокумента = РаботаСКурсамиВалютКлиентСервер.ПересчитатьИзВалютыВВалюту(СуммаДокумента,
		ТекущаяВалюта,
		НоваяВалюта,
		СтруктураКурсовТекущейВалюты.Курс,
		СтруктураКурсовНовойВалюты.Курс,
		СтруктураКурсовТекущейВалюты.Кратность,
		СтруктураКурсовНовойВалюты.Кратность);
	
	Возврат НоваяСуммаДокумента;
	
КонецФункции // ПересчитатьСуммуДокументаВВалюту()

//Функция ПолучитьКурсВалютыУправленческогоУчета возвращает курс валюты управленческого учета с учетом ее кратности.
//
// Параметры:
//  Дата - Дата - Дата на которую необходимо получить курс валюты.
//
// Возвращаемое значение:
//  Число - Коэффициент пересчета в валюту управленческого учета.
//
Функция ПолучитьКурсВалютыУправленческогоУчета(Дата) Экспорт

	Отбор                   = Новый Структура("Валюта", Константы.ВалютаУправленческогоУчета.Получить());
	СтруктураКурса          = РегистрыСведений.КурсыВалют.ПолучитьПоследнее(Дата, Отбор);
	КоэффициентПересчета    = СтруктураКурса.Курс * СтруктураКурса.Кратность;
	Возврат КоэффициентПересчета;

КонецФункции

#КонецОбласти

#Область КэшКурсовВалют

// Функция возвращает таблицу - кэш курсов валют
//
// Возвращаемое значение: 
//  Таблица, содержащая колонки:
//  	Валюта,
//		ДатаКурса,
//		Курс,
//		Кратность.
//
Функция ИнициализироватьКэшКурсовВалют() Экспорт
	
	КэшКурсов = Новый ТаблицаЗначений;
	КэшКурсов.Колонки.Добавить("Валюта");
	КэшКурсов.Колонки.Добавить("ДатаКурса");
	КэшКурсов.Колонки.Добавить("Курс");
	КэшКурсов.Колонки.Добавить("Кратность");
	
	КэшКурсов.Индексы.Добавить("Валюта, ДатаКурса");
	
	Возврат КэшКурсов;
	
КонецФункции // ИнициализироватьКэшКурсовВалют()

// Функция возвращает отношение курса к кратности курса валюты на дату
//
// Параметры:
//  Валюта     - Валюта (элемент справочника "Валюты")
//  ДатаКурса  - Дата, на которую следует получить курс
//  КэшКурсов  - Таблица значений со следующими колонками:
//					Валюта	  - элемент справочника "Валюты"
//					ДатаКурса - дата
//					Курс	  - число
//					Кратность - число
//
// Возвращаемое значение: Число
//
Функция ПолучитьКурсВалютыИзКэша(Знач Валюта, Знач ДатаКурса, КэшКурсов) Экспорт
	
	ДатаКурса = НачалоДня(ДатаКурса);
	
	СтруктураПоиска = Новый Структура("Валюта, ДатаКурса",
									   Валюта, ДатаКурса);
	РезультатПоиска = КэшКурсов.НайтиСтроки(СтруктураПоиска);
	
	Если РезультатПоиска.Количество() = 0 Тогда
		СтруктураКурса = РаботаСКурсамиВалют.ПолучитьКурсВалюты(Валюта, ДатаКурса);
		ЗаписьКэша			 = КэшКурсов.Добавить();
		ЗаписьКэша.Валюта	 = СтруктураПоиска.Валюта;
		ЗаписьКэша.ДатаКурса = СтруктураПоиска.ДатаКурса;
		ЗаписьКэша.Курс		 = СтруктураКурса.Курс;
		ЗаписьКэша.Кратность = СтруктураКурса.Кратность;
	Иначе
		СтруктураКурса		 = РезультатПоиска[0];
	КонецЕсли;
	
	Если СтруктураКурса.Курс      = 0 
	 Или СтруктураКурса.Кратность = 0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='ПолучитьКурсВалюты(): обнаружен нулевой курс валюты.';uk='ПолучитьКурсВалюты(): виявлений нульовий курс валюти.'"));
		Возврат 0;
	КонецЕсли;
	
	Возврат СтруктураКурса.Курс / СтруктураКурса.Кратность;
	
КонецФункции // ПолучитьКурсВалютыИзКэша()

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти
