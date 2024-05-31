#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов


// Заполняет список команд создания на основании.
// 
// Параметры:
//   КомандыСоздатьНаОсновании - ТаблицаЗначений - состав полей см. в функции ВводНаОсновании.СоздатьКоллекциюКомандСоздатьНаОсновании
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСоздатьНаОсновании) Экспорт


	ВводНаОснованииПереопределяемый.ДобавитьКомандуСоздатьНаОснованииБизнесПроцессЗадание(КомандыСоздатьНаОсновании);


КонецПроцедуры

Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСоздатьНаОсновании) Экспорт

	 
	Если ПравоДоступа("Добавление", Метаданные.Документы.РегистрацияЦенНоменклатурыПоставщика) Тогда
		КомандаСоздатьНаОсновании = КомандыСоздатьНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Идентификатор = Метаданные.Документы.РегистрацияЦенНоменклатурыПоставщика.ПолноеИмя();
		КомандаСоздатьНаОсновании.Представление = ВводНаОсновании.ПредставлениеОбъекта(Метаданные.Документы.РегистрацияЦенНоменклатурыПоставщика);
		КомандаСоздатьНаОсновании.ПроверкаПроведенияПередСозданиемНаОсновании = Истина;
		
	

		Возврат КомандаСоздатьНаОсновании;
	КонецЕсли;

	Возврат Неопределено;
КонецФункции

// Заполняет регистрацию цен номенклатуры поставщика на основании поступления или заказа поставщику
//
// Параметры:
//  Основание - Ссылка на поступление или заказ поставщику.
//
Процедура ЗаполнитьРегистрациюЦенПоДокументуЗакупки(Основание, ДокументОбъект) Экспорт
	
	ИмяТаблицы = Основание.Метаданные().Имя;
	
	Запрос = Новый Запрос("
		|ВЫБРАТЬ
		|	ДокументЗакупки.Дата                         КАК Дата,
		|	ДокументЗакупки.Валюта                       КАК Валюта,
		|	ДокументЗакупки.Партнер                      КАК Партнер,
		|	ДокументЗакупки.ЦенаВключаетНДС              КАК ЦенаВключаетНДС,
		|	ДокументЗакупки.Ссылка                       КАК ДокументОснование,
		|	НЕ ДокументЗакупки.Проведен                  КАК ЕстьОшибкиПроведен,
		|	ДокументЗакупки.РегистрироватьЦеныПоставщика КАК РегистрироватьЦеныПоставщика
		|ИЗ
		|	Документ." + ИмяТаблицы + " КАК ДокументЗакупки
		|ГДЕ
		|	ДокументЗакупки.Ссылка = &Ссылка
		|");
		
	Запрос.УстановитьПараметр("Ссылка", Основание);
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаШапка = РезультатЗапроса.Выбрать();
	ВыборкаШапка.Следующий();
	
	ОбщегоНазначенияУТ.ПроверитьВозможностьВводаНаОсновании(
		ВыборкаШапка.ДокументОснование,
		,
		ВыборкаШапка.ЕстьОшибкиПроведен,);
	
	СообщитьОбОшибкахРегистрацииЦенОснованием(ВыборкаШапка.РегистрироватьЦеныПоставщика, ВыборкаШапка.ДокументОснование);
	ЗаполнитьЗначенияСвойств(ДокументОбъект, ВыборкаШапка);
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	КурсыВалютСрезПоследних.Валюта    КАК Валюта,
	|	КурсыВалютСрезПоследних.Курс      КАК Курс,
	|	КурсыВалютСрезПоследних.Кратность КАК Кратность
	|ПОМЕСТИТЬ
	|	ВременнаяТаблицаКурсыВалют
	|ИЗ
	|	РегистрСведений.КурсыВалют.СрезПоследних(&Дата, Валюта=&Валюта ИЛИ Валюта В (ВЫБРАТЬ РАЗЛИЧНЫЕ Т.ВидЦеныПоставщика.Валюта ИЗ Документ." + ИмяТаблицы + ".Товары КАК Т ГДЕ Т.Ссылка = &Ссылка)) КАК КурсыВалютСрезПоследних
	|ИНДЕКСИРОВАТЬ ПО
	|	Валюта
	|;
	|ВЫБРАТЬ
	|	Товары.НоменклатураПоставщика КАК НоменклатураПоставщика,
	|	Товары.Номенклатура           КАК Номенклатура,
	|	Товары.Характеристика         КАК Характеристика,
	|	Товары.ВидЦеныПоставщика      КАК ВидЦеныПоставщика,
	|	Товары.Упаковка               КАК Упаковка,
	|	ВЫРАЗИТЬ(Товары.Цена 
	|				* ВЫБОР
	|					КОГДА
	|						&ЦенаВключаетНДС И НЕ Товары.ВидЦеныПоставщика.ЦенаВключаетНДС
	|					ТОГДА
	|						ВЫБОР
	|							КОГДА
	|								Товары.СтавкаНДС = ЗНАЧЕНИЕ(Перечисление.СтавкиНДС.БезНДС)
	|								ИЛИ Товары.СтавкаНДС = ЗНАЧЕНИЕ(Перечисление.СтавкиНДС.НеНДС)
	|								ИЛИ Товары.СтавкаНДС = ЗНАЧЕНИЕ(Перечисление.СтавкиНДС.НДС0)
	|							ТОГДА
	|								1
	|							КОГДА
	|								Товары.СтавкаНДС = ЗНАЧЕНИЕ(Перечисление.СтавкиНДС.НДС20)
	|							ТОГДА
	|								100/120
    |							КОГДА
    |								Товары.СтавкаНДС = ЗНАЧЕНИЕ(Перечисление.СтавкиНДС.НДС14)
    |							ТОГДА
    |								100/114
	|							КОГДА
	|								Товары.СтавкаНДС = ЗНАЧЕНИЕ(Перечисление.СтавкиНДС.НДС7)
	|							ТОГДА
	|								100/107
	|						КОНЕЦ
	|					КОГДА
	|						НЕ &ЦенаВключаетНДС И Товары.ВидЦеныПоставщика.ЦенаВключаетНДС
	|					ТОГДА
	|						ВЫБОР
	|							КОГДА
	|								Товары.СтавкаНДС = ЗНАЧЕНИЕ(Перечисление.СтавкиНДС.БезНДС)
	|								ИЛИ Товары.СтавкаНДС = ЗНАЧЕНИЕ(Перечисление.СтавкиНДС.НеНДС)
	|								ИЛИ Товары.СтавкаНДС = ЗНАЧЕНИЕ(Перечисление.СтавкиНДС.НДС0)
	|							ТОГДА
	|								1
	|							КОГДА
	|								Товары.СтавкаНДС = ЗНАЧЕНИЕ(Перечисление.СтавкиНДС.НДС20)
	|							ТОГДА
	|								1.20
    |							КОГДА
    |								Товары.СтавкаНДС = ЗНАЧЕНИЕ(Перечисление.СтавкиНДС.НДС14)
    |							ТОГДА
    |								1.14
	|							КОГДА
	|								Товары.СтавкаНДС = ЗНАЧЕНИЕ(Перечисление.СтавкиНДС.НДС7)
	|							ТОГДА
	|								1.07
	|						КОНЕЦ
	|					ИНАЧЕ
	|						1
	|				КОНЕЦ
	|				* ВЫБОР
	|					КОГДА
	|						&Валюта <> Товары.ВидЦеныПоставщика.Валюта
	|					ТОГДА
	|						ВЫБОР
	|							КОГДА ЕСТЬNULL(КурсыВалютыСоглашения.Кратность, 0) > 0
	|								И ЕСТЬNULL(КурсыВалютыСоглашения.Курс, 0) > 0
	|								И ЕСТЬNULL(КурсыВалюты.Кратность, 0) > 0
	|								И ЕСТЬNULL(КурсыВалюты.Курс, 0) > 0
	|							ТОГДА 
	|								(КурсыВалюты.Курс * КурсыВалютыСоглашения.Кратность)
	|								/ (КурсыВалютыСоглашения.Курс * КурсыВалюты.Кратность)
	|							ИНАЧЕ
	|								0
	|						КОНЕЦ
	|					ИНАЧЕ 
	|						1
	|				КОНЕЦ КАК ЧИСЛО(15, 2))
	|	КАК Цена
	|ПОМЕСТИТЬ
	|	Товары
	|ИЗ
	|	Документ." + ИмяТаблицы + ".Товары КАК Товары
	|ЛЕВОЕ СОЕДИНЕНИЕ
	|	ВременнаяТаблицаКурсыВалют КАК КурсыВалюты
	|ПО
	|	КурсыВалюты.Валюта = &Валюта
	|ЛЕВОЕ СОЕДИНЕНИЕ
	|	ВременнаяТаблицаКурсыВалют КАК КурсыВалютыСоглашения
	|ПО
	|	КурсыВалютыСоглашения.Валюта = Товары.ВидЦеныПоставщика.Валюта
	|ГДЕ
	|	Товары.Ссылка = &Ссылка
	|	И Товары.ВидЦеныПоставщика <> ЗНАЧЕНИЕ(Справочник.ВидыЦенПоставщиков.ПустаяСсылка)
	|;
	|ВЫБРАТЬ
	|	Товары.Номенклатура                    КАК Номенклатура,
	|	Товары.Характеристика                  КАК Характеристика,
	|	Товары.ВидЦеныПоставщика               КАК ВидЦеныПоставщика,
	|	СРЕДНЕЕ(
	|		Товары.Цена / ВЫБОР
	|				КОГДА
	|					Товары.Упаковка <> ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка)
	|				ТОГДА
	|					&ТекстЗапросаКоэффициентУпаковки
	|				ИНАЧЕ
	|					1
	|			КОНЕЦ
	|	) КАК ЦенаЗаБазовуюЕдиницу,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Товары.Упаковка)  КАК КоличествоРазличныхУпаковок
	|ПОМЕСТИТЬ
	|	ТоварыСРазличнымиУпаковкамиЦенами
	|ИЗ
	|	Товары КАК Товары
	|СГРУППИРОВАТЬ ПО
	|	Номенклатура,
	|	Характеристика,
	|	ВидЦеныПоставщика
	|;
	|ВЫБРАТЬ
	|	МАКСИМУМ(Товары.НоменклатураПоставщика) КАК НоменклатураПоставщика,
	|	Товары.Номенклатура                     КАК Номенклатура,
	|	Товары.Характеристика                   КАК Характеристика,
	|	Товары.ВидЦеныПоставщика                КАК ВидЦеныПоставщика,
	|	МИНИМУМ(ВЫБОР
	|				КОГДА
	|					ТоварыСРазличнымиУпаковкамиЦенами.КоличествоРазличныхУпаковок > 1
	|				ТОГДА
	|					ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка)
	|				ИНАЧЕ
	|					Товары.Упаковка
	|				КОНЕЦ
	|			) КАК Упаковка,
	|	СРЕДНЕЕ(ВЫБОР
	|				КОГДА
	|					ТоварыСРазличнымиУпаковкамиЦенами.КоличествоРазличныхУпаковок > 1
	|				ТОГДА
	|					ТоварыСРазличнымиУпаковкамиЦенами.ЦенаЗаБазовуюЕдиницу
	|				ИНАЧЕ
	|					Товары.Цена
	|				КОНЕЦ
	|			) КАК Цена
	|ИЗ
	|	Товары КАК Товары
	|ЛЕВОЕ СОЕДИНЕНИЕ
	|	ТоварыСРазличнымиУпаковкамиЦенами КАК ТоварыСРазличнымиУпаковкамиЦенами
	|ПО
	|	Товары.Номенклатура = ТоварыСРазличнымиУпаковкамиЦенами.Номенклатура
	|	И Товары.Характеристика = ТоварыСРазличнымиУпаковкамиЦенами.Характеристика
	|	И Товары.ВидЦеныПоставщика = ТоварыСРазличнымиУпаковкамиЦенами.ВидЦеныПоставщика
	|СГРУППИРОВАТЬ ПО
	|	Товары.Номенклатура,
	|	Товары.Характеристика,
	|	Товары.ВидЦеныПоставщика
	|";
			
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,
		"&ТекстЗапросаКоэффициентУпаковки",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаКоэффициентаУпаковки(
		"Товары.Упаковка",
		"Товары.Номенклатура"));
		
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
		
	Запрос.УстановитьПараметр("Ссылка",                    Основание);
	Запрос.УстановитьПараметр("Дата",                      ВыборкаШапка.Дата);
	Запрос.УстановитьПараметр("Валюта",                    ВыборкаШапка.Валюта);
	Запрос.УстановитьПараметр("ЦенаВключаетНДС",           ВыборкаШапка.ЦенаВключаетНДС);
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	ДокументОбъект.Товары.Загрузить(РезультатЗапроса[3].Выгрузить());
	
КонецПроцедуры

// Заполняет список команд отчетов.
// 
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - состав полей см. в функции МенюОтчеты.СоздатьКоллекциюКомандОтчетов
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов) Экспорт

	ВариантыОтчетовУТПереопределяемый.ДобавитьКомандуСтруктураПодчиненности(КомандыОтчетов);

	ВариантыОтчетовУТПереопределяемый.ДобавитьКомандуДвиженияДокумента(КомандыОтчетов);

КонецПроцедуры

#КонецОбласти
// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт

КонецПроцедуры

#Область Проведение

// Инициализирует таблицы значений, содержащие данные табличных частей документа
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства"

Функция ДополнительныеИсточникиДанныхДляДвижений(ИмяРегистра) Экспорт

	ИсточникиДанных = Новый Соответствие;

	Возврат ИсточникиДанных; 

КонецФункции

Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, ДополнительныеСвойства, Регистры = Неопределено) Экспорт

	////////////////////////////////////////////////////////////////////////////
	// Создадим запрос инициализации движений
	
	Запрос = Новый Запрос;
	ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка);
	
	////////////////////////////////////////////////////////////////////////////
	// Сформируем текст запроса
	ТекстыЗапроса = Новый СписокЗначений;
	ТекстЗапросаЦеныНоменклатурыПоставщиков(Запрос, ТекстыЗапроса, Регистры);
	
	ПроведениеСервер.ИницализироватьТаблицыДляДвижений(Запрос, ТекстыЗапроса, ДополнительныеСвойства.ТаблицыДляДвижений, Истина);
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка)
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
КонецПроцедуры

Функция ТекстЗапросаЦеныНоменклатурыПоставщиков(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ЦеныНоменклатурыПоставщиков";
	
	Если НЕ ПроведениеСервер.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли; 
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ТаблицаТовары.НоменклатураПоставщика   КАК НоменклатураПоставщика,
	|	ТаблицаТовары.Номенклатура             КАК Номенклатура,
	|	ТаблицаТовары.Характеристика           КАК Характеристика,
	|	ТаблицаТовары.Упаковка                 КАК Упаковка,
	|	ТаблицаТовары.ВидЦеныПоставщика        КАК ВидЦеныПоставщика,
	|	ТаблицаТовары.Цена                     КАК Цена,
	|	ТаблицаТовары.ВидЦеныПоставщика.Валюта КАК Валюта,
	|	ТаблицаТовары.Ссылка.Партнер           КАК Партнер,
	|	ТаблицаТовары.Ссылка.Дата              КАК ПЕРИОД
	|ИЗ
	|	Документ.РегистрацияЦенНоменклатурыПоставщика.Товары КАК ТаблицаТовары
	|ГДЕ
	|	ТаблицаТовары.Ссылка = &Ссылка
	|	И ТаблицаТовары.Номенклатура <> ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
	|";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура СообщитьОбОшибкахРегистрацииЦенОснованием(РегистрироватьЦеныПоставщикаОснованием, ДокументРегистрацииЦенПоставщика)
	
	Если РегистрироватьЦеныПоставщикаОснованием Тогда
		
		ТекстОшибки = НСтр("ru='Цены уже зарегистрированы документом %Документ%. Ввод на основании не требуется.';uk='Ціни вже зареєстровані документом %Документ%. Введення на підставі не потрібне.'");
		ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Документ%", ДокументРегистрацииЦенПоставщика);
		
		ВызватьИсключение ТекстОшибки;
		
	КонецЕсли;
	
КонецПроцедуры

#Область ОбновлениеИнформационнойБазы


Процедура ЗаполнитьВидЦеныПоставщикаВТабличнойЧастиТовары_ДанныеДляОбновления(Параметры) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Т.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.РегистрацияЦенНоменклатурыПоставщика.Товары КАК Т
	|ГДЕ
	|	Т.Ссылка.Проведен
	|	И (Т.ВидЦеныПоставщика = ЗНАЧЕНИЕ(Справочник.ВидыЦенПоставщиков.ПустаяСсылка)
	|	    И ЕСТЬNULL(Т.Ссылка.УдалитьСоглашение, ЗНАЧЕНИЕ(Справочник.СоглашенияСПоставщиками.ПустаяСсылка)) <> ЗНАЧЕНИЕ(Справочник.СоглашенияСПоставщиками.ПустаяСсылка)
    |   )
    |";
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(
        Параметры, 
        Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка")
    );	

КонецПроцедуры

// Обработчик обновления BAS УТ 3.2.1
// Заполняет "ВидЦеныПоставщика" в табличных частях документа и обновляет движения по регистру сведений ЦеныНоменклатурыПоставщиков
Процедура ЗаполнитьВидЦеныПоставщикаВТабличнойЧастиТовары(Параметры) Экспорт
    
    ПолноеИмяОбъекта = "Документ.РегистрацияЦенНоменклатурыПоставщика"; 
    
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Результат = ОбновлениеИнформационнойБазы.СоздатьВременнуюТаблицуСсылокДляОбработки(
        Параметры.Очередь, 
        ПолноеИмяОбъекта, 
        МенеджерВременныхТаблиц
    );
    
    Если НЕ Результат.ЕстьДанныеДляОбработки Тогда
		Параметры.ОбработкаЗавершена = Истина;
		Возврат;
    КонецЕсли;
    
	Если НЕ Результат.ЕстьЗаписиВоВременнойТаблице Тогда
		Параметры.ОбработкаЗавершена = Ложь;
		Возврат;
	КонецЕсли;
    
	ЗапросПоДокументам = Новый Запрос;
    ЗапросПоДокументам.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	ЗапросПоДокументам.Текст = "
	|ВЫБРАТЬ 
	|	Т.Ссылка                                     КАК Ссылка,
	|	Т.Ссылка.Партнер                             КАК Партнер,
	|	Т.Ссылка.УдалитьСоглашение                   КАК Соглашение,
	|	Т.Ссылка.УдалитьСоглашение.ВидЦеныПоставщика КАК ВидЦеныПоставщика
	|ИЗ
	|	Документ.РегистрацияЦенНоменклатурыПоставщика.Товары КАК Т
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТДляОбработки КАК ДокументыКОбработке
	|		    ПО Т.Ссылка = ДокументыКОбработке.Ссылка
	|ГДЕ
	|	Т.Ссылка.Проведен
	|	И (Т.ВидЦеныПоставщика = ЗНАЧЕНИЕ(Справочник.ВидыЦенПоставщиков.ПустаяСсылка)
	|		И ЕСТЬNULL(Т.Ссылка.УдалитьСоглашение, ЗНАЧЕНИЕ(Справочник.СоглашенияСПоставщиками.ПустаяСсылка)) <> ЗНАЧЕНИЕ(Справочник.СоглашенияСПоставщиками.ПустаяСсылка))
	|";
    
    ЗапросПоДокументам.Текст = СтрЗаменить(ЗапросПоДокументам.Текст, "ВТДляОбработки", Результат.ИмяВременнойТаблицы);
    
    Выборка = ЗапросПоДокументам.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		НачатьТранзакцию();
		
		Попытка	
			
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяОбъекта);
			ЭлементБлокировки.УстановитьЗначение("Ссылка", Выборка.Ссылка);
			ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ЦеныНоменклатурыПоставщиков.НаборЗаписей");
			ЭлементБлокировки.УстановитьЗначение("Регистратор", Выборка.Ссылка);
			Блокировка.Заблокировать();
			
			ДокументОбъект = Выборка.Ссылка.ПолучитьОбъект();
            
            // Если объект ранее был удален или обработан другими сеансами, пропускаем его
			Если ДокументОбъект = Неопределено Тогда 
				ОтменитьТранзакцию();
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(Выборка.Ссылка);
				Продолжить;
            КонецЕсли;
            
    		Для Каждого СтрокаТовары Из ДокументОбъект.Товары Цикл
    			Если Не ЗначениеЗаполнено(СтрокаТовары.ВидЦеныПоставщика) Тогда
    				СтрокаТовары.ВидЦеныПоставщика = Выборка.ВидЦеныПоставщика;
    			КонецЕсли;
    		КонецЦикла;
    		
    		ДокументОбъект.УдалитьСоглашение = Неопределено;
            
			ОбновлениеИнформационнойБазы.ЗаписатьДанные(ДокументОбъект);
            
			НаборЗаписей = РегистрыСведений.ЦеныНоменклатурыПоставщиков.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.Регистратор.Значение = ДокументОбъект.Ссылка;
			НаборЗаписей.Отбор.Регистратор.Использование = Истина;
			НаборЗаписей.Прочитать();
			Если НаборЗаписей.Выбран() Тогда
				
				Для Каждого СтрокаНабора Из НаборЗаписей Цикл
					
					Если НЕ ЗначениеЗаполнено(СтрокаНабора.ВидЦеныПоставщика) Тогда
						СтрокаНабора.ВидЦеныПоставщика = Выборка.ВидЦеныПоставщика;
					КонецЕсли;
					
					СтрокаНабора.Соглашение = Неопределено;
					СтрокаНабора.Партнер = Выборка.Партнер;
					
				КонецЦикла;
				
				ОбновлениеИнформационнойБазы.ЗаписатьДанные(НаборЗаписей);
				
			КонецЕсли;
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
            ОбновлениеИнформационнойБазыУТ.СообщитьОНеудачнойОбработке(Выборка.Ссылка);
										
		КонецПопытки;
		
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(
        Параметры.Очередь, 
        ПолноеИмяОбъекта
    );
    
КонецПроцедуры


#КонецОбласти

#КонецОбласти

#КонецЕсли
