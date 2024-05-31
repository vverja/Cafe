#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Функция формирует временные таблицы "ТаблицаДанныхДокумента", "ТаблицаТоваров", "ТаблицаВидыЗапасов"  
// для заполнения табличной части "Виды запасов".
//
// Возвращаемое значение:
//	МенеджерВременныхТаблиц - менеджер временных таблиц
//
Функция ВременныеТаблицыДанныхДокумента() Экспорт
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	&Дата КАК Дата,
	|	&Организация КАК Организация,
	|	ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка) КАК Подразделение,
	|	ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка) КАК Менеджер,
	|	ЗНАЧЕНИЕ(Справочник.СделкиСКлиентами.ПустаяСсылка) КАК Сделка,
	|
	|	Неопределено КАК Партнер,
	|	Неопределено КАК Контрагент,
	|	ЗНАЧЕНИЕ(Справочник.СоглашенияСПоставщиками.ПустаяСсылка) КАК Соглашение,
	|	ЗНАЧЕНИЕ(Справочник.ДоговорыКонтрагентов.ПустаяСсылка) КАК Договор,
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК Валюта,
	|	ЗНАЧЕНИЕ(Справочник.НалоговыеНазначенияАктивовИЗатрат.ПустаяСсылка) КАК НалоговоеНазначение,
	|	&НалоговоеНазначениеОрганизации КАК НалоговоеНазначениеОрганизации,
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.КорректировкаОбособленногоУчета) КАК ХозяйственнаяОперация,
	|	Ложь КАК ЕстьСделкиВТабличнойЧасти
	|	
	|ПОМЕСТИТЬ ТаблицаДанныхДокумента
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаТоваров.НомерСтроки КАК НомерСтроки,
	|	ТаблицаТоваров.Номенклатура КАК Номенклатура,
	|	ТаблицаТоваров.Характеристика КАК Характеристика,
	|	ТаблицаТоваров.Серия КАК Серия,
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаТоваров.Количество КАК Количество,
	|	ТаблицаТоваров.Склад КАК Склад,
	|	ТаблицаТоваров.ДокументРеализации КАК ДокументРеализации,
	|	ЗНАЧЕНИЕ(Справочник.СделкиСКлиентами.ПустаяСсылка) КАК Сделка,
	|	ТаблицаТоваров.ИсходноеНазначение КАК Назначение,
	|	ТаблицаТоваров.НовоеНазначение КАК НовоеНазначение,
	|	ЗНАЧЕНИЕ(Перечисление.СтавкиНДС.ПустаяСсылка) КАК СтавкаНДС,
	|	ЗНАЧЕНИЕ(Справочник.НалоговыеНазначенияАктивовИЗатрат.ПустаяСсылка) КАК ЦелевоеНалоговоеНазначение,
	|	0 КАК СуммаСНДС,
	|	0 КАК СуммаНДС,
	|	0 КАК СуммаВознаграждения,
	|	0 КАК СуммаНДСВознаграждения,
	|	ИСТИНА КАК ПодбиратьВидыЗапасов
	|
	|ПОМЕСТИТЬ ТаблицаТоваров
	|ИЗ
	|	&ТаблицаТоваров КАК ТаблицаТоваров
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаВидыЗапасов.НомерСтроки КАК НомерСтроки,
	|	ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаВидыЗапасов.ДокументРеализации КАК ДокументРеализации,
	|	ТаблицаВидыЗапасов.ВидЗапасов КАК ВидЗапасов,
	|	ТаблицаВидыЗапасов.НомерГТД КАК НомерГТД,
	|	ТаблицаВидыЗапасов.Количество КАК Количество,
	|	ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка) КАК СкладОтгрузки,
	|	ЗНАЧЕНИЕ(Справочник.СделкиСКлиентами.ПустаяСсылка) КАК Сделка,
	|	ТаблицаВидыЗапасов.НовоеНазначение КАК НовоеНазначение,
	|	&ВидыЗапасовУказаныВручную КАК ВидыЗапасовУказаныВручную
	|	
	|ПОМЕСТИТЬ ВтВидыЗапасов
	|ИЗ
	|	&ТаблицаВидыЗапасов КАК ТаблицаВидыЗапасов
	|;
	|///////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаВидыЗапасов.НомерСтроки КАК НомерСтроки,
	|	ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	Аналитика.Номенклатура КАК Номенклатура,
	|	Аналитика.Характеристика КАК Характеристика,
	|	Аналитика.Серия КАК Серия,
	|	ТаблицаВидыЗапасов.ДокументРеализации КАК ДокументРеализации,
	|	ТаблицаВидыЗапасов.ВидЗапасов КАК ВидЗапасов,
	|	ТаблицаВидыЗапасов.НомерГТД КАК НомерГТД,
	|	ТаблицаВидыЗапасов.Количество КАК Количество,
	|	ТаблицаВидыЗапасов.СкладОтгрузки КАК СкладОтгрузки,
	|	Аналитика.Склад КАК Склад,
	|	ТаблицаВидыЗапасов.Сделка КАК Сделка,
	|	ТаблицаВидыЗапасов.НовоеНазначение КАК НовоеНазначение,
	|	ТаблицаВидыЗапасов.ВидыЗапасовУказаныВручную КАК ВидыЗапасовУказаныВручную
	|	
	|ПОМЕСТИТЬ ТаблицаВидыЗапасов
	|ИЗ
	|	ВтВидыЗапасов КАК ТаблицаВидыЗапасов
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.АналитикаУчетаНоменклатуры КАК Аналитика
	|	ПО ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры = Аналитика.КлючАналитики
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	АналитикаУчетаНоменклатуры
	|");
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Дата", Дата);
	Запрос.УстановитьПараметр("ВидыЗапасовУказаныВручную", ВидыЗапасовУказаныВручную);
	Запрос.УстановитьПараметр("ТаблицаВидыЗапасов", ЗапасыСервер.ТаблицаДополненнаяОбязательнымиКолонками(ВидыЗапасов.Выгрузить()));
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("НалоговоеНазначениеОрганизации", Справочники.Организации.НалоговоеНазначениеНДС(Организация, Дата));
	Запрос.УстановитьПараметр("ТаблицаТоваров", ЗапасыСервер.ТаблицаДополненнаяОбязательнымиКолонками(Товары.Выгрузить()));
	
	Запрос.Выполнить();
	
	Если ВидыЗапасовУказаныВручную Тогда
		ДополнительныеСвойства.Вставить("ИгнорироватьОперативныеОстатки", Истина);
	КонецЕсли;
	
	Возврат МенеджерВременныхТаблиц;
	
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") И ЗначениеЗаполнено(ДанныеЗаполнения.ВидОперации) Тогда
		ВидОперации = ДанныеЗаполнения.ВидОперации;
	Иначе
		ВидОперации = Перечисления.ВидыОперацийКорректировкиНазначения.СнятьРезерв;
	КонецЕсли;
	
	Заказ = ДанныеЗаполнения;
	
	ДокументПоРаспоряжению = ЗначениеЗаполнено(Заказ);
	
	Если ЗначениеЗаполнено(Заказ) Тогда
		Назначение = Документы.КорректировкаНазначенияТоваров.ПолучитьНазначениеЗаказа(Заказ);
		
		Документы.КорректировкаНазначенияТоваров.ЗаполнитьПоОснованию(Назначение, Ссылка, ВидОперации, Товары);
		
		Организация = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Заказ, "Организация");
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	ОбщегоНазначенияУТ.ПроверитьЗаполнениеКоличества(ЭтотОбъект, ПроверяемыеРеквизиты, Отказ);
	НоменклатураСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект,МассивНепроверяемыхРеквизитов,Отказ);
	
	НоменклатураСервер.ПроверитьЗаполнениеСерий(ЭтотОбъект,
												НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.КорректировкаНазначенияТоваров),
												Отказ,
												МассивНепроверяемыхРеквизитов);
												
	СкладыСервер.ПроверитьЗаполнениеЯчеек(ЭтотОбъект, МассивНепроверяемыхРеквизитов, Отказ);
	СкладыСервер.ПроверитьЗаполнениеПомещений(ЭтотОбъект, МассивНепроверяемыхРеквизитов, Отказ);
	
	МассивНепроверяемыхРеквизитов.Добавить("Товары.НовоеНазначение");
	МассивНепроверяемыхРеквизитов.Добавить("Товары.ИсходноеНазначение");
	
	Если ВидОперации = Перечисления.ВидыОперацийКорректировкиНазначения.СнятьРезервПоМногимНазначениям Или
		ВидОперации = Перечисления.ВидыОперацийКорректировкиНазначения.ПроизвольнаяКорректировкаНазначений Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Заказ");
		МассивНепроверяемыхРеквизитов.Добавить("Организация");
	КонецЕсли;
	
	ПоверитьЗаполнениеНовогоНазначения(Отказ);
	
	// Проверка заполнения упаковок номенклатуры на адресных складах
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Товары.Склад,
	|	Товары.Помещение
	|ПОМЕСТИТЬ СкладыИПомещения
	|ИЗ
	|	&Товары КАК Товары
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СкладыИПомещения.Склад,
	|	СкладыИПомещения.Помещение
	|ИЗ
	|	СкладыИПомещения КАК СкладыИПомещения
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.НастройкиАдресныхСкладов КАК НастройкиАдресныхСкладов
	|		ПО (НастройкиАдресныхСкладов.ИспользоватьАдресноеХранение)
	|			И (НастройкиАдресныхСкладов.ДатаНачалаАдресногоХраненияОстатков <= &Дата)
	|			И (НастройкиАдресныхСкладов.Склад = СкладыИПомещения.Склад)
	|			И (НастройкиАдресныхСкладов.Помещение = СкладыИПомещения.Помещение)
	|			И (НЕ СкладыИПомещения.Помещение = ЗНАЧЕНИЕ(Справочник.СкладскиеПомещения.ПустаяСсылка)
	|				ИЛИ (НЕ НастройкиАдресныхСкладов.Склад.ИспользоватьСкладскиеПомещения
	|					ИЛИ &Дата < НастройкиАдресныхСкладов.Склад.ДатаНачалаИспользованияСкладскихПомещений))";
	Запрос.УстановитьПараметр("Товары", Товары.Выгрузить(,"Склад, Помещение"));
	Запрос.УстановитьПараметр("Дата",
		?(ЗначениеЗаполнено(Дата),Дата,ТекущаяДатаСеанса()));
	
	ВыборкаСкладПомещение = Запрос.Выполнить().Выбрать();
	
	Пока ВыборкаСкладПомещение.Следующий() Цикл
		ПараметрыПроверки = НоменклатураСервер.ПараметрыПроверкиЗаполненияУпаковок();
		ПараметрыПроверки.ОтборПроверяемыхСтрок.Вставить("Склад", ВыборкаСкладПомещение.Склад);
		ПараметрыПроверки.ОтборПроверяемыхСтрок.Вставить("Помещение", ВыборкаСкладПомещение.Помещение);
		НоменклатураСервер.ПроверитьЗаполнениеУпаковок(ЭтотОбъект,МассивНепроверяемыхРеквизитов,Отказ,ПараметрыПроверки);
	КонецЦикла;
	
	// Проверка на то, что одно из двух полей назначения заполнено
	ПустоеНазначение = Справочники.Назначения.ПустаяСсылка();
	СтруктураПоиска = Новый Структура("ИсходноеНазначение, НовоеНазначение", ПустоеНазначение, ПустоеНазначение);
	НайденныеСтроки = Товары.НайтиСтроки(СтруктураПоиска);
	Если НайденныеСтроки.Количество() > 0 Тогда
		
		ШаблонСообщения = НСтр("ru='Не заполнено назначение в колонках ""Исходное назначение"" и ""Новое назначение"" в строке %НомерСтроки%. 
            |Необходимо заполнить одну из колонок (либо обе).'
            |;uk='Не заповнено призначення у колонках ""Початкове призначення"" і ""Нове призначення"" в рядку %НомерСтроки%. 
            |Необхідно заповнити одну з колонок (або обидві).'");
		
		Для Каждого Строка Из НайденныеСтроки Цикл
			ТекстСообщения = СтрЗаменить(ШаблонСообщения, "%НомерСтроки%", Строка.НомерСтроки);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , , "Объект", Отказ)
		КонецЦикла;
		
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроверитьПравоПроведенияДокумента(Отказ);

	ПроведениеСервер.УстановитьРежимПроведения(ЭтотОбъект, РежимЗаписи, РежимПроведения);

	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	ОбщегоНазначенияУТ.ОкруглитьКоличествоШтучныхТоваров(ЭтотОбъект, РежимЗаписи);
    
	СформироватьСписокЗависимыхЗаказов();
	
	НоменклатураСервер.ОчиститьНеиспользуемыеСерии(ЭтотОбъект,
														НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.КорректировкаНазначенияТоваров));
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		
		МестаУчета = РегистрыСведений.АналитикаУчетаНоменклатуры.МестаУчета(Перечисления.ХозяйственныеОперации.КорректировкаОбособленногоУчета, Неопределено, Неопределено, Неопределено);
		ИменаПолей = РегистрыСведений.АналитикаУчетаНоменклатуры.ИменаПолейКоллекцииПоУмолчанию();
		ИменаПолей.Произвольный = "Склад";
		РегистрыСведений.АналитикаУчетаНоменклатуры.ЗаполнитьВКоллекции(Товары, МестаУчета, ИменаПолей);

		ЗаполнитьВидыЗапасов(Отказ);
		
	ИначеЕсли РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения Тогда
		Если Не ВидыЗапасовУказаныВручную Тогда
			ВидыЗапасов.Очистить();
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	Документы.КорректировкаНазначенияТоваров.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	//
	ЗапасыСервер.ОтразитьОбеспечениеЗаказов(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьСвободныеОстатки(ДополнительныеСвойства, Движения, Отказ);
	//
	ЗапасыСервер.ОтразитьТоварыОрганизаций(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьДатыПоступленияТоваровОрганизаций(ДополнительныеСвойства, Отказ);
	ДоходыИРасходыСервер.ОтразитьСебестоимостьТоваров(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьТоварыНаСкладах(ДополнительныеСвойства, Движения, Отказ);
	СкладыСервер.ОтразитьТоварыВЯчейках(ДополнительныеСвойства, Движения, Отказ);
	// Движения по оборотным регистрам управленческого учета 
	УправленческийУчетПроведениеСервер.ОтразитьДвиженияНоменклатураНоменклатура(ДополнительныеСвойства, Движения, Отказ);
	

	СформироватьСписокРегистровДляКонтроля();
	
	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ПроведениеСервер.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);
    
	РегистрыСведений.СостоянияЗаказовКлиентов.ОтразитьСостояниеЗаказа(ЭтотОбъект, Отказ);
	
	ПроведениеСервер.ЗаписатьПодчиненныеНаборамЗаписейДанные(ЭтотОбъект, Отказ);
	
	ПроведениеСервер.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);

КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)

	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);

	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);

	СформироватьСписокРегистровДляКонтроля();

	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);

	ПроведениеСервер.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);
    
	РегистрыСведений.СостоянияЗаказовКлиентов.ОтразитьСостояниеЗаказа(ЭтотОбъект, Отказ);
	
	ПроведениеСервер.ЗаписатьПодчиненныеНаборамЗаписейДанные(ЭтотОбъект, Отказ);

	ПроведениеСервер.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПроверитьПравоПроведенияДокумента(Отказ)
	
	Если Не Документы.КорректировкаНазначенияТоваров.ДоступнаВозможностьИзменения(Ссылка) Тогда
		СтрокаИсключения = НСтр("ru='Недостаточно прав доступа для записи документа с действием ""%1"".';uk='Недостатньо прав для запису документа з дією ""%1"".'");
		СтрокаИсключения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаИсключения, ВидОперации);
		ВызватьИсключение СтрокаИсключения;
	КонецЕсли;
	
КонецПроцедуры

#Область ИнициализацияИЗаполнение

Процедура СформироватьСписокРегистровДляКонтроля()

	Массив = Новый Массив;
	Массив.Добавить(Движения.ОбеспечениеЗаказов);
	Массив.Добавить(Движения.СвободныеОстатки);
	// Приходы в регистр (сторно расхода из регистра) контролируем при перепроведении и отмене проведения
	Если Не ДополнительныеСвойства.ЭтоНовый Тогда
		Массив.Добавить(Движения.ТоварыОрганизаций);
	КонецЕсли;
	ДополнительныеСвойства.ДляПроведения.Вставить("РегистрыДляКонтроля", Массив);

КонецПроцедуры

#КонецОбласти

#Область ПроверкаЗаполнения

Процедура ПоверитьЗаполнениеНовогоНазначения(Отказ)
	
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#Область ВидыЗапасов

Процедура СформироватьВременнуюТаблицуТоваровИАналитики(МенеджерВременныхТаблиц) Экспорт
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры,
	|	ТаблицаТоваров.Номенклатура,
	|	ТаблицаТоваров.Характеристика,
	|	ТаблицаТоваров.Серия,
	|	ТаблицаТоваров.Склад,
	|
	|	ТаблицаДанныхДокумента.Подразделение,
	|	ТаблицаДанныхДокумента.Менеджер,
	|	ТаблицаДанныхДокумента.Сделка,
	|	ТаблицаТоваров.Назначение КАК Назначение,
	|
	|	ЗНАЧЕНИЕ(Справочник.Партнеры.ПустаяСсылка) КАК Партнер,
	|	ЗНАЧЕНИЕ(Справочник.СоглашенияСПоставщиками.ПустаяСсылка) КАК Соглашение,
	|	ЗНАЧЕНИЕ(Справочник.НалоговыеНазначенияАктивовИЗатрат.ПустаяСсылка) КАК НалоговоеНазначение,
	|
	|	ТаблицаТоваров.Количество КАК Количество
	|	
	|ПОМЕСТИТЬ ТаблицаТоваровИАналитики
	|ИЗ
	|	ТаблицаТоваров КАК ТаблицаТоваров
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		ТаблицаДанныхДокумента КАК ТаблицаДанныхДокумента
	|	ПО
	|		Истина
	|ГДЕ
	|	ТаблицаТоваров.Номенклатура.ТипНоменклатуры <> ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Услуга)
	|;
	|");
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.Выполнить();
	
КонецПроцедуры

Функция РеквизитыДокументаИзменились(МенеджерВременныхТаблиц)
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ДанныеДокумента.Организация КАК Организация,
	|	ДанныеДокумента.Дата КАК Дата
	|
	|ПОМЕСТИТЬ СохраненныеДанныеДокумента
	|ИЗ
	|	Документ.КорректировкаНазначенияТоваров КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВЫБОР КОГДА ДанныеДокумента.Организация <> СохраненныеДанные.Организация ТОГДА
	|		Истина
	|	КОГДА ДанныеДокумента.Дата <> СохраненныеДанные.Дата ТОГДА
	|		Истина
	|	ИНАЧЕ
	|		Ложь
	|	КОНЕЦ КАК РеквизитыИзменены
	|ИЗ
	|	ТаблицаДанныхДокумента КАК ДанныеДокумента
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		СохраненныеДанныеДокумента КАК СохраненныеДанные
	|	ПО
	|		Истина
	|");
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		РеквизитыИзменены = Выборка.РеквизитыИзменены;
	Иначе
		РеквизитыИзменены = Ложь;
	КонецЕсли;
	
	Возврат РеквизитыИзменены;
	
КонецФункции

Функция ТабличнаяЧастьТоварыИзменилась(МенеджерВременныхТаблиц)
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры
	|ИЗ (
	|	ВЫБРАТЬ
	|		ТаблицаТоваров.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|		ТаблицаТоваров.Назначение КАК Назначение,
	|		ТаблицаТоваров.НовоеНазначение КАК НовоеНазначение,
	|		ТаблицаТоваров.Количество КАК Количество
	|	ИЗ
	|		ТаблицаТоваров КАК ТаблицаТоваров
	|
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|		ТаблицаВидыЗапасов.ВидЗапасов.Назначение КАК Назначение,
	|		ТаблицаВидыЗапасов.НовоеНазначение КАК НовоеНазначение,
	|		-ТаблицаВидыЗапасов.Количество КАК Количество
	|	ИЗ
	|		ТаблицаВидыЗапасов КАК ТаблицаВидыЗапасов
	|
	|	) КАК ТаблицаТоваров
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры,
	|	ТаблицаТоваров.Назначение,
	|	ТаблицаТоваров.НовоеНазначение
	|
	|ИМЕЮЩИЕ
	|	СУММА(ТаблицаТоваров.Количество) <> 0
	|");
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;

	РезультатЗапрос = Запрос.Выполнить();
	
	Возврат (Не РезультатЗапрос.Пустой());
	
КонецФункции

Процедура СформироватьДоступныеВидыЗапасов(МенеджерВременныхТаблиц) Экспорт
	
	Запрос = Новый Запрос();
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ВидыЗапасов.Ссылка КАК ВидЗапасов,
		|	ВидыЗапасов.Ссылка КАК ВидЗапасовПродавца,
		|	ВидыЗапасов.Предназначение КАК Предназначение,
		|	ВидыЗапасов.Сделка КАК Сделка,
		|	ВидыЗапасов.Менеджер КАК Менеджер,
		|	ВидыЗапасов.Подразделение КАК Подразделение,
		|	ВидыЗапасов.Назначение КАК Назначение
		|
		|ПОМЕСТИТЬ ДоступныеВидыЗапасов
		|ИЗ
		|	Справочник.ВидыЗапасов КАК ВидыЗапасов
		|ГДЕ
		|	Не ВидыЗапасов.РеализацияЗапасовДругойОрганизации
		|	И Не ВидыЗапасов.ПометкаУдаления
		|	И(ВидыЗапасов.Предназначение = ЗНАЧЕНИЕ(Перечисление.ТипыПредназначенияВидовЗапасов.ПредназначениеНеОграничено)
		|		ИЛИ ВидыЗапасов.Предназначение = ЗНАЧЕНИЕ(Перечисление.ТипыПредназначенияВидовЗапасов.ПредназначенДляЗаказа)
		|			И ВидыЗапасов.Назначение В (
		|				ВЫБРАТЬ
		|					Таблица.Назначение КАК Назначение
		|				ИЗ
		|					ТаблицаТоваров КАК Таблица))";
	
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.Выполнить();
	
КонецПроцедуры

Процедура СообщитьОбОшибкахЗаполненияВидовЗапасов(ТаблицаОшибок, МенеджерВременныхТаблиц)
	
	Если ТаблицаОшибок.Количество() > 0 Тогда
		
	 	СтруктураАналитики = ЗапасыСервер.АналитикаОбособленноУчетаДокумента(МенеджерВременныхТаблиц);
		
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Корректировка превышает остаток товара организации %1 %2 %3';uk='Коригування перевищує залишок товару організації %1 %2 %3'"),
			Организация,
			СтруктураАналитики.СтрокаАналитики,
			СтруктураАналитики.Аналитика);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстСообщения,
			Ссылка);
		
		Для Каждого СтрокаТаблицы Из ТаблицаОшибок Цикл
			
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Номенклатура: %1, на складе %2 недостаточно %3 %4';uk='Номенклатура: %1, на складі %2 недостатньо %3 %4'"),
				НоменклатураКлиентСервер.ПредставлениеНоменклатуры(СтрокаТаблицы.Номенклатура, СтрокаТаблицы.Характеристика),
				СтрокаТаблицы.Склад,
				СтрокаТаблицы.Количество,
				СтрокаТаблицы.ЕдиницаИзмерения);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстСообщения,
				Ссылка);
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьНовоеНазначениеВидовЗапасов()
	
	СтруктураПоиска = Новый Структура("АналитикаУчетаНоменклатуры, Назначение");
	Для Каждого СтрокаТоваров Из Товары Цикл
		
		КоличествоТоваров = СтрокаТоваров.Количество;
		
		ЗаполнитьЗначенияСвойств(СтруктураПоиска, СтрокаТоваров);
		СтруктураПоиска.Назначение = СтрокаТоваров.ИсходноеНазначение;
		
		Для Каждого СтрокаЗапасов Из ВидыЗапасов.НайтиСтроки(СтруктураПоиска) Цикл
			
			Если СтрокаЗапасов.Количество = 0 Тогда
				Продолжить;
			КонецЕсли;
			
			Количество = Мин(КоличествоТоваров, СтрокаЗапасов.Количество);
			
			НоваяСтрока = ВидыЗапасов.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаЗапасов);
			
			НоваяСтрока.НовоеНазначение = СтрокаТоваров.НовоеНазначение;
			НоваяСтрока.Количество = Количество;
			
			СтрокаЗапасов.Количество = СтрокаЗапасов.Количество - НоваяСтрока.Количество;
			
			КоличествоТоваров = КоличествоТоваров - НоваяСтрока.Количество;
			
			Если КоличествоТоваров = 0 Тогда
				Прервать;
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
	МассивУдаляемыхСтрок = ВидыЗапасов.НайтиСтроки(Новый Структура("Количество", 0));
	Для Каждого СтрокаТаблицы Из МассивУдаляемыхСтрок Цикл
		ВидыЗапасов.Удалить(СтрокаТаблицы);
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьВидыЗапасов(Отказ)
	
	УстановитьПривилегированныйРежим(Истина);
	
	МенеджерВременныхТаблиц = ВременныеТаблицыДанныхДокумента();
	ПерезаполнитьВидыЗапасов = ДополнительныеСвойства.Свойство("ПерезаполнитьВидыЗапасов");
	
	Если Не Проведен
		Или ПерезаполнитьВидыЗапасов
		Или РеквизитыДокументаИзменились(МенеджерВременныхТаблиц)
		Или ТабличнаяЧастьТоварыИзменилась(МенеджерВременныхТаблиц) Тогда
		
		СформироватьДоступныеВидыЗапасов(МенеджерВременныхТаблиц);
		ЗапасыСервер.УстановитьБлокировкуОстатковТоваровОрганизаций(МенеджерВременныхТаблиц);
		ЗапасыСервер.ТаблицаОстатковТоваровОрганизаций(Ссылка, Организация, Дата, ДополнительныеСвойства, МенеджерВременныхТаблиц);
		ТаблицаОшибок = ЗапасыСервер.ТаблицаОшибокЗаполненияВидовЗапасов();
		
		ЗапасыСервер.ЗаполнитьВидыЗапасовДокумента(
			МенеджерВременныхТаблиц,
			ДополнительныеСвойства,
			ВидыЗапасов,
			ТаблицаОшибок,
			Отказ);
		ВидыЗапасов.Свернуть("АналитикаУчетаНоменклатуры, ВидЗапасов, НомерГТД, Назначение", "Количество");
		СообщитьОбОшибкахЗаполненияВидовЗапасов(ТаблицаОшибок, МенеджерВременныхТаблиц);
		
	КонецЕсли;
	
	ЗаполнитьНовоеНазначениеВидовЗапасов();
	
КонецПроцедуры

#КонецОбласти

Процедура СформироватьСписокЗависимыхЗаказов()
	
	Запрос = Новый Запрос;
	
	Запрос.Текст = ТекстЗапросаЗависимыеЗаказыКлиентов();
	
	МассивНазначений = ЭтотОбъект.Товары.ВыгрузитьКолонку("ИсходноеНазначение");
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(МассивНазначений, ЭтотОбъект.Товары.ВыгрузитьКолонку("НовоеНазначение"));
	
	Запрос.УстановитьПараметр("МассивЗаказов", ЭтотОбъект.Товары.ВыгрузитьКолонку("Заказ"));
	Запрос.УстановитьПараметр("МассивНазначений", МассивНазначений);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	УстановитьПривилегированныйРежим(Истина);
	
	Результат = Запрос.Выполнить();
	
	МассивЗависимыхЗаказов = Результат.Выгрузить().ВыгрузитьКолонку("Заказ");
	ЭтотОбъект.ДополнительныеСвойства.Вставить("МассивЗависимыхЗаказовКлиентов", Новый ФиксированныйМассив(МассивЗависимыхЗаказов));
	
КонецПроцедуры

Функция ТекстЗапросаЗависимыеЗаказыКлиентов()
	
	ТекстЗапроса =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТаблицаЗапроса.Заказ КАК Заказ
	|ИЗ
	|	(ВЫБРАТЬ
	|		ТаблицаДокумента.Ссылка КАК Заказ
	|	ИЗ
	|		Документ.ЗаказКлиента КАК ТаблицаДокумента
	|	ГДЕ
	|		ТаблицаДокумента.Ссылка В(&МассивЗаказов)
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ТаблицаДокумента.Ссылка
	|	ИЗ
	|		Документ.ЗаявкаНаВозвратТоваровОтКлиента КАК ТаблицаДокумента
	|	ГДЕ
	|		ТаблицаДокумента.Ссылка В(&МассивЗаказов)
	|
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		Назначения.Заказ
	|	ИЗ
	|		Справочник.Назначения КАК Назначения
	|	ГДЕ
	|		Назначения.Ссылка В(&МассивНазначений)
	|		И (Назначения.Заказ ССЫЛКА Документ.ЗаказКлиента
	|				ИЛИ Назначения.Заказ ССЫЛКА Документ.ЗаявкаНаВозвратТоваровОтКлиента
	|)) КАК ТаблицаЗапроса";
	
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти

#КонецЕсли