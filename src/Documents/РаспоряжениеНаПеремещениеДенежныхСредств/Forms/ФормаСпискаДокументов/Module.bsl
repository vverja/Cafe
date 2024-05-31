
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	// Обработчик подсистемы "Внешние обработки"
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	
	ИспользоватьНесколькоРасчетныхСчетов	= ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоРасчетныхСчетов");
	ИспользоватьНесколькоКасс				= ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоКасс");
	УправлениеЭлементамиФормы();
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма, Элементы.ПодменюПечать);
	// Конец СтандартныеПодсистемы.Печать

	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма, Элементы.ГруппаГлобальныеКоманды);
	// Конец ИнтеграцияС1СДокументооборотом

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

	// ВводНаОсновании
	ВводНаОсновании.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюСоздатьНаОсновании);
	// Конец ВводНаОсновании

	// МенюОтчеты
	МенюОтчеты.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюОтчеты);
	// Конец МенюОтчеты
	

	ОбщегоНазначенияУТ.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список", "СписокДокументовДата");


КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Организация = Настройки.Получить("Организация");
	ДатаОплаты = Настройки.Получить("ДатаОплаты");
	Статус = Настройки.Получить("Статус");
	УстановитьОтборДинамическогоСписка();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияОтборПриИзменении(Элемент)
	
	УстановитьОтборДинамическогоСписка();
	
КонецПроцедуры

&НаКлиенте
Процедура СтатусОтборПриИзменении(Элемент)
	
	УстановитьОтборДинамическогоСписка();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаПлатежаОтборПриИзменении(Элемент)
	
	УстановитьОтборДинамическогоСписка();
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// ВводНаОсновании
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуСоздатьНаОсновании(Команда)
	
	ВводНаОснованииКлиент.ВыполнитьПодключаемуюКомандуСоздатьНаОсновании(Команда, ЭтотОбъект, Элементы.Список);
	
КонецПроцедуры
// Конец ВводНаОсновании

// МенюОтчеты
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуОтчет(Команда)
	
	МенюОтчетыКлиент.ВыполнитьПодключаемуюКомандуОтчет(Команда, ЭтотОбъект, Элементы.Список);
	
КонецПроцедуры
// Конец МенюОтчеты


&НаКлиенте
Процедура СоздатьПоступлениеДенежныхСредствИзБанка(Команда)
	
	СоздатьРаспоряжениеНаПеремещениеДенежныхСредств(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПоступлениеДенежныхСредствИзБанка"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьВыдачаДенежныхСредствВДругуюКассу(Команда)
	
	СоздатьРаспоряжениеНаПеремещениеДенежныхСредств(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВыдачаДенежныхСредствВДругуюКассу"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПеречислениеДенежныхСредствНаДругойСчет(Команда)
	
	СоздатьРаспоряжениеНаПеремещениеДенежныхСредств(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПеречислениеДенежныхСредствНаДругойСчет"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьИнкассациюВБанк(Команда)
	
	СоздатьРаспоряжениеНаПеремещениеДенежныхСредств(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ИнкассацияДенежныхСредствВБанк"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьИнкассациюИзБанка(Команда)
	
	СоздатьРаспоряжениеНаПеремещениеДенежныхСредств(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.СнятиеНаличныхДенежныхСредств"));
	
КонецПроцедуры

// Функция используется в автотесте процесса продаж.
//
&НаКлиенте
Процедура АвтоТест_УстановитьСтатусКОплате(Команда) Экспорт
	
	ВыделелнныеСтроки = РаботаСДиалогамиКлиент.ПроверитьПолучитьВыделенныеВСпискеСсылки(Элементы.Список);
	Если ВыделелнныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ТекстВопроса = НСтр("ru='У выделенных в списке распоряжений будет установлен статус ""К оплате"". Продолжить?';uk='У виділених у списку розпоряджень буде встановлено статус ""До оплати"". Продовжити?'");
	Ответ = Неопределено;

	ПоказатьВопрос(Новый ОписаниеОповещения("АвтоТест_УстановитьСтатусКОплатеЗавершение", ЭтотОбъект, Новый Структура("ВыделелнныеСтроки", ВыделелнныеСтроки)), ТекстВопроса,РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура АвтоТест_УстановитьСтатусКОплатеЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    ВыделелнныеСтроки = ДополнительныеПараметры.ВыделелнныеСтроки;
    
    
    Ответ = РезультатВопроса;
    Если Ответ = КодВозвратаДиалога.Нет Тогда
        Возврат;
    КонецЕсли;
    
    ОчиститьСообщения();
    КоличествоОбработанных = ОбщегоНазначенияУТВызовСервера.УстановитьСтатусДокументов(ВыделелнныеСтроки, "КОплате");
    
    ОбщегоНазначенияУТКлиент.ОповеститьПользователяОбУстановкеСтатуса(Элементы.Список, КоличествоОбработанных, ВыделелнныеСтроки.Количество(), НСтр("ru='К оплате';uk='До оплати'"));

КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусСогласовано(Команда)
	
	ВыделелнныеСтроки = РаботаСДиалогамиКлиент.ПроверитьПолучитьВыделенныеВСпискеСсылки(Элементы.Список);
	Если ВыделелнныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ТекстВопроса = НСтр("ru='У выделенных в списке распоряжений будет установлен статус ""Cогласовано"". Продолжить?';uk='У виділених у списку розпоряджень буде встановлено статус ""Погоджено"". Продовжити?'");
	Ответ = Неопределено;

	ПоказатьВопрос(Новый ОписаниеОповещения("УстановитьСтатусСогласованоЗавершение", ЭтотОбъект, Новый Структура("ВыделелнныеСтроки", ВыделелнныеСтроки)), ТекстВопроса,РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусСогласованоЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    ВыделелнныеСтроки = ДополнительныеПараметры.ВыделелнныеСтроки;
    
    
    Ответ = РезультатВопроса;
    Если Ответ = КодВозвратаДиалога.Нет Тогда
        Возврат;
    КонецЕсли;
    
    ОчиститьСообщения();
    КоличествоОбработанных = ОбщегоНазначенияУТВызовСервера.УстановитьСтатусДокументов(ВыделелнныеСтроки, "Согласовано");
    
    ОбщегоНазначенияУТКлиент.ОповеститьПользователяОбУстановкеСтатуса(Элементы.Список, КоличествоОбработанных, ВыделелнныеСтроки.Количество(), НСтр("ru='Cогласовано';uk='Погоджено'"));

КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусНеСогласовано(Команда)
	
	ВыделелнныеСтроки = РаботаСДиалогамиКлиент.ПроверитьПолучитьВыделенныеВСпискеСсылки(Элементы.Список);
	Если ВыделелнныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ТекстВопроса = НСтр("ru='У выделенных в списке распоряжений будет установлен статус ""Не согласовано"". Продолжить?';uk='У виділених у списку розпоряджень буде встановлено статус ""Не погоджено"". Продовжити?'");
	Ответ = Неопределено;

	ПоказатьВопрос(Новый ОписаниеОповещения("УстановитьСтатусНеСогласованоЗавершение", ЭтотОбъект, Новый Структура("ВыделелнныеСтроки", ВыделелнныеСтроки)), ТекстВопроса,РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусНеСогласованоЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    ВыделелнныеСтроки = ДополнительныеПараметры.ВыделелнныеСтроки;
    
    
    Ответ = РезультатВопроса;
    Если Ответ = КодВозвратаДиалога.Нет Тогда
        Возврат;
    КонецЕсли;
    
    ОчиститьСообщения();
    КоличествоОбработанных = ОбщегоНазначенияУТВызовСервера.УстановитьСтатусДокументов(ВыделелнныеСтроки, "НеСогласовано");
    
    ОбщегоНазначенияУТКлиент.ОповеститьПользователяОбУстановкеСтатуса(Элементы.Список, КоличествоОбработанных, ВыделелнныеСтроки.Количество(), НСтр("ru='Не согласовано';uk='Не погоджено'"));

КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусОтклонено(Команда)
	
	ВыделелнныеСтроки = РаботаСДиалогамиКлиент.ПроверитьПолучитьВыделенныеВСпискеСсылки(Элементы.Список);
	Если ВыделелнныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ТекстВопроса = НСтр("ru='У выделенных в списке распоряжений будет установлен статус ""Отклонено"". Продолжить?';uk='У виділених у списку розпоряджень буде встановлено статус ""Відхилено"". Продовжити?'");
	Ответ = Неопределено;

	ПоказатьВопрос(Новый ОписаниеОповещения("УстановитьСтатусОтклоненоЗавершение", ЭтотОбъект, Новый Структура("ВыделелнныеСтроки", ВыделелнныеСтроки)), ТекстВопроса,РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусОтклоненоЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    ВыделелнныеСтроки = ДополнительныеПараметры.ВыделелнныеСтроки;
    
    
    Ответ = РезультатВопроса;
    Если Ответ = КодВозвратаДиалога.Нет Тогда
        Возврат;
    КонецЕсли;
    
    ОчиститьСообщения();
    КоличествоОбработанных = ОбщегоНазначенияУТВызовСервера.УстановитьСтатусДокументов(ВыделелнныеСтроки, "Отклонено");
    
    ОбщегоНазначенияУТКлиент.ОповеститьПользователяОбУстановкеСтатуса(Элементы.Список, КоличествоОбработанных, ВыделелнныеСтроки.Количество(), НСтр("ru='Отклонено';uk='Відхилено'"));

КонецПроцедуры

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры
//Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область УправлениеЭлементамиФормы

&НаСервере
Процедура УправлениеЭлементамиФормы()
	
	Элементы.ГруппаСоздать.ПодчиненныеЭлементы.СписокСоздатьПеречислениеДенежныхСредствНаДругойСчет.Видимость	= ИспользоватьНесколькоРасчетныхСчетов;
	Элементы.ГруппаСоздать.ПодчиненныеЭлементы.СписокСоздатьВыдачаДенежныхСредствВДругуюКассу.Видимость			= ИспользоватьНесколькоКасс;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьСписокОрганизаций()
	
	Элементы.СписокОрганизация.Видимость = Не ЗначениеЗаполнено(Организация);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборДинамическогоСписка()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"ДатаПлатежа",
		ДатаПлатежа.Дата,
		ВидСравненияКомпоновкиДанных.МеньшеИлиРавно,, ЗначениеЗаполнено(ДатаПлатежа.Дата));
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Организация", Организация, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Организация));
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Статус", Статус, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Статус));
	
	УстановитьВидимостьСписокОрганизаций();
	
КонецПроцедуры

#КонецОбласти

#Область СозданиеДокументов

&НаКлиенте
Процедура СоздатьРаспоряжениеНаПеремещениеДенежныхСредств(ХозяйственнаяОперация)

	СтруктураОснование = Новый Структура("ХозяйственнаяОперация, Организация", ХозяйственнаяОперация, Организация);
	СтруктураПараметры = Новый Структура("Основание", СтруктураОснование);
	ОткрытьФорму("Документ.РаспоряжениеНаПеремещениеДенежныхСредств.ФормаОбъекта", СтруктураПараметры, Элементы.Список);
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

#КонецОбласти

#КонецОбласти
