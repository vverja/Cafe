#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ИнициализироватьДокумент(ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)

	Если Кассы.Количество() > 0 Тогда
		Кассы.Очистить();
	КонецЕсли;
	ПоследнийНомерПКО = "";
	ПоследнийНомерРКО = "";
	
	ИнициализироватьДокумент();
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	ПланыВидовХарактеристик.СтатьиДоходов.ПроверитьЗаполнениеАналитик(
		ЭтотОбъект, Новый Структура("Кассы", "СтатьяДоходовРасходов, АналитикаДоходов"), МассивНепроверяемыхРеквизитов, Отказ);
	ПланыВидовХарактеристик.СтатьиРасходов.ПроверитьЗаполнениеАналитик(
		ЭтотОбъект, Новый Структура("Кассы", "СтатьяДоходовРасходов, АналитикаРасходов"), МассивНепроверяемыхРеквизитов, Отказ);
		
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(
		ПроверяемыеРеквизиты,
		МассивНепроверяемыхРеквизитов);
		
	ПроверитьЗаполнениеТабличнойЧасти(Отказ);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ПроведениеСервер.УстановитьРежимПроведения(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	ВалютаРеглУчета = Константы.ВалютаРегламентированногоУчета.Получить();
	
	ТаблицаДокумента = Кассы.Выгрузить(,"Касса, СуммаПоУчету, СуммаПоФакту");
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ТаблицаДокумента.Касса КАК Касса,
	|	ТаблицаДокумента.СуммаПоУчету,
	|	ТаблицаДокумента.СуммаПоФакту
	|ПОМЕСТИТЬ ТаблицаДокумента
	|ИЗ
	|	&ТаблицаДокумента КАК ТаблицаДокумента
	|;
	|/////////////////////////////////////////////////////
	|
	|ВЫБРАТЬ
	|	КурсВалюты.Валюта КАК Валюта,
	|	КурсВалюты.Курс * КурсВалютыРегл.Кратность / (КурсВалюты.Кратность * КурсВалютыРегл.Курс) КАК КоэффициентПересчета
	|ПОМЕСТИТЬ ТаблицаКурсыВалютРегл
	|ИЗ РегистрСведений.КурсыВалют.СрезПоследних(&ДатаДокумента, ) КАК КурсВалюты
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалют.СрезПоследних(&ДатаДокумента, Валюта = &ВалютаРеглУчета) КАК КурсВалютыРегл
	|	ПО (ИСТИНА)
	|ГДЕ
	|	КурсВалюты.Кратность <> 0
	|	И КурсВалютыРегл.Курс <> 0
	|;
	|/////////////////////////////////////////////////////////////////////////////
	|
	|ВЫБРАТЬ
	|	ЕСТЬNULL(СУММА(ТаблицаДокумента.СуммаПоУчету
	|		* ТаблицаКурсыВалютРегл.КоэффициентПересчета), 0) КАК СуммаПоУчетуВсего,
	|	ЕСТЬNULL(СУММА(ТаблицаДокумента.СуммаПоФакту
	|		* ТаблицаКурсыВалютРегл.КоэффициентПересчета), 0) КАК СуммаПоФактуВсего
	|ИЗ
	|	ТаблицаДокумента
	|	
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Справочник.Кассы КАК Кассы
	|	ПО
	|		Кассы.Ссылка = ТаблицаДокумента.Касса
	|	
	|		ЛЕВОЕ СОЕДИНЕНИЕ
	|			ТаблицаКурсыВалютРегл
	|		ПО
	|			ТаблицаКурсыВалютРегл.Валюта = Кассы.ВалютаДенежныхСредств
	|";
	
	Запрос.УстановитьПараметр("ТаблицаДокумента", ТаблицаДокумента);
	Запрос.УстановитьПараметр("ВалютаРеглУчета", ВалютаРеглУчета);
	Запрос.УстановитьПараметр("ДатаДокумента", Дата);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Выборка);
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		ВзаиморасчетыСервер.ЗаполнитьИдентификаторыСтрокВТабличнойЧасти(Кассы);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	// Инициализация данных документа
	Документы.ИнвентаризацияНаличныхДенежныхСредств.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Движения
	ДоходыИРасходыСервер.ОтразитьПрочиеДоходы(ДополнительныеСвойства, Движения, Отказ);
	ДоходыИРасходыСервер.ОтразитьПрочиеРасходы(ДополнительныеСвойства, Движения, Отказ);
	ДоходыИРасходыСервер.ОтразитьПартииПрочихРасходов(ДополнительныеСвойства, Движения, Отказ);
	
	ДенежныеСредстваСервер.ОтразитьДенежныеСредстваНаличные(ДополнительныеСвойства, Движения, Отказ);
	
	// Движения по оборотным регистрам управленческого учета
	УправленческийУчетПроведениеСервер.ОтразитьДвиженияДенежныеСредстваДоходыРасходы(ДополнительныеСвойства, Движения, Отказ);
	
	
	СформироватьСписокРегистровДляКонтроля();
	
	// Запись наборов записей
	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ПроведениеСервер.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);
	
	ПроведениеСервер.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Инициализация дополнительных свойств для проведения документа
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	СформироватьСписокРегистровДляКонтроля();

	// Запись наборов записей
	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ПроведениеСервер.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);
	
	ПроведениеСервер.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)
	
	Организация   = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	Ответственный = Пользователи.ТекущийПользователь();
	
КонецПроцедуры

Процедура ПроверитьЗаполнениеТабличнойЧасти(Отказ)
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	Таблица.НомерСтроки КАК НомерСтроки,
	|	Таблица.Касса КАК Касса,
	|	Таблица.СуммаРасхождения КАК СуммаРасхождения,
	|	Таблица.СтатьяДвиженияДенежныхСредств КАК СтатьяДвиженияДенежныхСредств,
	|	Таблица.Подразделение КАК Подразделение,
	|	Таблица.СтатьяДоходовРасходов КАК СтатьяДоходовРасходов,
	|	Таблица.АналитикаДоходов КАК АналитикаДоходов,
	|	Таблица.АналитикаРасходов КАК АналитикаРасходов
	|	
	|ПОМЕСТИТЬ ТаблицаДокумента
	|ИЗ
	|	&ТаблицаДокумента КАК Таблица
	|ГДЕ
	|	Таблица.Касса <> НЕОПРЕДЕЛЕНО
	|;
	|/////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МАКСИМУМ(ТаблицаДокумента.НомерСтроки) КАК НомерСтроки,
	|	ТаблицаДокумента.Касса КАК Касса
	|ИЗ
	|	ТаблицаДокумента КАК ТаблицаДокумента
	|	
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаДокумента.Касса
	|ИМЕЮЩИЕ 
	|	КОЛИЧЕСТВО(*) > 1
	|;
	|/////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаДокумента.НомерСтроки КАК НомерСтроки,
	|	ТаблицаДокумента.Касса КАК Касса,
	|	ВЫБОР КОГДА Кассы.Владелец <> &Организация ТОГДА
	|		Истина
	|	ИНАЧЕ
	|		Ложь
	|	КОНЕЦ КАК ОтличаетсяОрганизация,
	|	ВЫБОР КОГДА Кассы.ОбособленноеПодразделениеОрганизации <> &ОбособленноеПодразделениеОрганизации ТОГДА
	|		Истина
	|	ИНАЧЕ
	|		Ложь
	|	КОНЕЦ КАК ОтличаетсяОбособленноеПодразделение
	|ИЗ
	|	ТаблицаДокумента КАК ТаблицаДокумента
	|	
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Справочник.Кассы КАК Кассы
	|	ПО
	|		Кассы.Ссылка = ТаблицаДокумента.Касса
	|;
	|/////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаДокумента.НомерСтроки КАК НомерСтроки,
	|	ВЫБОР КОГДА ТаблицаДокумента.СтатьяДвиженияДенежныхСредств = ЗНАЧЕНИЕ(Справочник.СтатьиДвиженияДенежныхСредств.ПустаяСсылка) ТОГДА
	|		Истина
	|	ИНАЧЕ
	|		Ложь
	|	КОНЕЦ НеЗаполненаСтатьяДДС,
	|	ВЫБОР КОГДА ТаблицаДокумента.Подразделение = ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка) ТОГДА
	|		Истина
	|	ИНАЧЕ
	|		Ложь
	|	КОНЕЦ НеЗаполненоПодразделение
	|ИЗ
	|	ТаблицаДокумента
	|ГДЕ
	|	ТаблицаДокумента.СуммаРасхождения <> 0
	|");
	
	ТаблицаДокумента = Кассы.Выгрузить();
	Запрос.УстановитьПараметр("ТаблицаДокумента", ТаблицаДокумента);
	Запрос.УстановитьПараметр("Организация", Организация);
	Если ИспользованиеОбособленногоПодразделения() Тогда
		Запрос.УстановитьПараметр("ОбособленноеПодразделениеОрганизации", ОбособленноеПодразделениеОрганизации);
	Иначе
		Запрос.УстановитьПараметр("ОбособленноеПодразделениеОрганизации", Справочники.ОбособленныеПодразделенияОрганизаций.ПустаяСсылка());
	КонецЕсли;	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	РезультатЗапросаДубли = МассивРезультатов[1];
	РезультатЗапросаКассы = МассивРезультатов[2];
	РезультатЗапросаТЧ = МассивРезультатов[3];
	
	// Проверяем дубли строк в документе
	Выборка = РезультатЗапросаДубли.Выбрать();
	Пока Выборка.Следующий() Цикл
		Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Касса %1 повторяется в табличной части';uk='Каса %1 повторюється в табличній частині'"),
			Выборка.Касса);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			Текст,
			ЭтотОбъект,
			"Кассы[" + (Выборка.НомерСтроки - 1) + "].Касса",
			,
			Отказ);
	КонецЦикла;
	
	ИспользоватьПодразделения = ПолучитьФункциональнуюОпцию("ИспользоватьПодразделения");
	
	Выборка = РезультатЗапросаКассы.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		// Проверяем соответствие организации документа и организации кассы
		Если Выборка.ОтличаетсяОрганизация Тогда
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Организация документа %1 отличается от организации %2';uk='Організація документа %1 відрізняється від організації %2'"),
				Выборка.Документ,
				Организация);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				Текст,
				ЭтотОбъект,
				"Кассы[" + (Выборка.НомерСтроки - 1) + "].Касса",
				,
				Отказ);
		КонецЕсли;
		
		// Проверяем соответствие обособленного подразделения документа и обособленного подразделения кассы
		Если Выборка.ОтличаетсяОбособленноеПодразделение Тогда
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Обособленное подразделение организации документа %1 отличается от обособленного подразделения организации %2';uk='Відокремлений підрозділ організації документа %1 відрізняється від відокремленого підрозділу організації %2'"),
				Выборка.Документ,
				?(ЗначениеЗаполнено(ОбособленноеПодразделениеОрганизации), ОбособленноеПодразделениеОрганизации, НСтр("ru='<Основная кассовая книга организации>';uk='<Основна касова книга організації>'"))
			);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				Текст,
				ЭтотОбъект,
				"Кассы[" + (Выборка.НомерСтроки - 1) + "].Касса",
				,
				Отказ
			);
		КонецЕсли;
	КонецЦикла;
	
	// Проверка заполнения реквизитов табл. части
	Выборка = РезультатЗапросаТЧ.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.НеЗаполненаСтатьяДДС Тогда
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Не указана ""Статья движения денежных средств"" в строке %1';uk='Не зазначена ""Стаття руху грошових коштів"" в рядку %1'"), Выборка.НомерСтроки);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				Текст,
				ЭтотОбъект,
				"Кассы[" + (Выборка.НомерСтроки - 1) + "].СтатьяДвиженияДенежныхСредств",
				,
				Отказ);
		КонецЕсли;
		
		Если Выборка.НеЗаполненоПодразделение И ИспользоватьПодразделения Тогда
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Не указано ""Подразделение"" в строке %1';uk='Не зазначено ""Підрозділ"" в рядку %1'"), Выборка.НомерСтроки);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				Текст,
				ЭтотОбъект,
				"Кассы[" + (Выборка.НомерСтроки - 1) + "].Подразделение",
				,
				Отказ);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура СформироватьСписокРегистровДляКонтроля()
	
	Массив = Новый Массив;
	
	Если Не ДополнительныеСвойства.ЭтоНовый Тогда
		Массив.Добавить(Движения.ПрочиеДоходы);
		Массив.Добавить(Движения.ПрочиеРасходы);
		Массив.Добавить(Движения.ПартииПрочихРасходов);
	КонецЕсли;
	
	ДополнительныеСвойства.ДляПроведения.Вставить("РегистрыДляКонтроля", Массив);
	
КонецПроцедуры

Функция ИспользованиеОбособленногоПодразделения()
	Возврат ПолучитьФункциональнуюОпцию("ИспользоватьУчетДенежныхСредствПоОбособленнымПодразделениямОрганизация", Новый Структура("Организация", Организация));
КонецФункции

#КонецОбласти

#КонецЕсли