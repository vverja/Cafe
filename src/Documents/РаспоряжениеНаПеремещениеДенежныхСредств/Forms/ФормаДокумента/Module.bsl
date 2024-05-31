
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);

	// Обработчик подсистемы "ВерсионированиеОбъектов"
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);

	// Обработчик подсистемы "Внешние обработки"
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриЧтенииСозданииНаСервере();
	КонецЕсли;
	
	УточнитьСписокХозяйственныхОпераций();
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма, Элементы.ПодменюПечать);
	// Конец СтандартныеПодсистемы.Печать
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

	// ВводНаОсновании
	ВводНаОсновании.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюСоздатьНаОсновании);
	// Конец ВводНаОсновании

	// МенюОтчеты
	МенюОтчеты.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюОтчеты);
	// Конец МенюОтчеты

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриЧтенииСозданииНаСервере();

	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	УстановитьДоступностьЭлементовПоСтатусу(Истина);

	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_РаспоряжениеНаПеремещениеДенежныхСредств", ПараметрыЗаписи, Объект.Ссылка); // Используется для автоматического обновления формы платежного календаря

	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)

	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ХозяйственнаяОперацияПриИзменении(Элемент)

	ХозяйственнаяОперацияПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура КассаПриИзменении(Элемент)
	
	СтруктураРеквизитов = ПолучитьРеквизитыКассы(Объект.Касса);
	
	Если НЕ ФинансыКлиент.НеобходимПересчетВВалюту(Объект, Объект.Валюта, СтруктураРеквизитов.Валюта) Тогда
		
		КассаПриИзмененииСервер(СтруктураРеквизитов, Ложь);
	Иначе
		
		ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Пересчитать суммы в документе в валюту %1?';uk='Перерахувати суми в документі у валюту %1?'"),
			СтруктураРеквизитов.Валюта);
		
		КнопкиДиалогаВопрос = Новый СписокЗначений;
		КнопкиДиалогаВопрос.Добавить(КодВозвратаДиалога.Да, НСтр("ru='Пересчитать';uk='Перерахувати'"));
		КнопкиДиалогаВопрос.Добавить(КодВозвратаДиалога.Отмена, НСтр("ru='Отменить';uk='Скасувати'"));
		
		ОписаниеОповещения = Новый ОписаниеОповещения("РазрешенПересчетВВалютуКасса", ЭтотОбъект, Новый Структура("СтруктураРеквизитов", СтруктураРеквизитов));
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, КнопкиДиалогаВопрос);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РазрешенПересчетВВалютуКасса(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		
		ТекущаяВалюта = Объект.Валюта;
		КассаПриИзмененииСервер(ДополнительныеПараметры.СтруктураРеквизитов, Истина);
		ЦенообразованиеКлиент.ОповеститьОбОкончанииПересчетаСуммВВалюту(ТекущаяВалюта, Объект.Валюта);
	Иначе
		
		Объект.Касса = ТекущаяКасса;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура БанковскийСчетПриИзменении(Элемент)
	
	СтруктураРеквизитов = ПолучитьРеквизитыБанковскогоСчета(Объект.БанковскийСчет);
	
	Если НЕ ФинансыКлиент.НеобходимПересчетВВалюту(Объект, Объект.Валюта, СтруктураРеквизитов.Валюта) Тогда
		
		БанковскийСчетПриИзмененииСервер(СтруктураРеквизитов, Ложь);
	Иначе
		
		ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Пересчитать суммы в документе в валюту %1?';uk='Перерахувати суми в документі у валюту %1?'"),
			СтруктураРеквизитов.Валюта);
		
		КнопкиДиалогаВопрос = Новый СписокЗначений;
		КнопкиДиалогаВопрос.Добавить(КодВозвратаДиалога.Да, НСтр("ru='Пересчитать';uk='Перерахувати'"));
		КнопкиДиалогаВопрос.Добавить(КодВозвратаДиалога.Отмена, НСтр("ru='Отменить';uk='Скасувати'"));
		
		ОписаниеОповещения = Новый ОписаниеОповещения("РазрешенПересчетВВалютуСчет", ЭтотОбъект, Новый Структура("СтруктураРеквизитов", СтруктураРеквизитов));
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, КнопкиДиалогаВопрос);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РазрешенПересчетВВалютуСчет(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		
		ТекущаяВалюта = Объект.Валюта;
		БанковскийСчетПриИзмененииСервер(ДополнительныеПараметры.СтруктураРеквизитов, Истина);
		ЦенообразованиеКлиент.ОповеститьОбОкончанииПересчетаСуммВВалюту(ТекущаяВалюта, Объект.Валюта);
	Иначе
		
		Объект.БанковскийСчет = ТекущийБанковскийСчет;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СтатусПриИзменении(Элемент)
	
	УправлениеЭлементамиФормы();
	УстановитьДоступностьЭлементовПоСтатусу(Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры
//Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПриИзмененииРеквизитов

&НаСервере
Процедура ХозяйственнаяОперацияПриИзмененииСервер()

	УправлениеЭлементамиФормы();
	ЗаполнитьРеквизитыДокументаПоХозяйственнойОперации();
	
КонецПроцедуры

&НаСервере
Процедура КассаПриИзмененииСервер(СтруктураРеквизитов, ПересчитыватьСуммы)
	
	ТекущаяКасса = Объект.Касса;
	
	Если ЗначениеЗаполнено(Объект.Касса) Тогда
		Объект.Организация = СтруктураРеквизитов.Организация;
	КонецЕсли;
	
	ТекущаяВалюта = Объект.Валюта;
	Объект.Валюта = СтруктураРеквизитов.Валюта;
	
	Если ПересчитыватьСуммы Тогда
		ПересчетСуммДокументаВВалюту(ТекущаяВалюта);
	КонецЕсли;
	
	Объект.БанковскийСчетПолучатель = Справочники.БанковскиеСчетаОрганизаций.ПустаяСсылка();
	Объект.КассаПолучатель          = Справочники.Кассы.ПустаяСсылка();
	
КонецПроцедуры

&НаСервере
Процедура БанковскийСчетПриИзмененииСервер(СтруктураРеквизитов, ПересчитыватьСуммы)
	
	ТекущийБанковскийСчет = Объект.БанковскийСчет;
	
	Если ЗначениеЗаполнено(Объект.БанковскийСчет) Тогда
		Объект.Организация = СтруктураРеквизитов.Организация;
	КонецЕсли;
	
	ТекущаяВалюта = Объект.Валюта;
	Объект.Валюта = СтруктураРеквизитов.Валюта;
	
	Если ПересчитыватьСуммы Тогда
		ПересчетСуммДокументаВВалюту(ТекущаяВалюта);
	КонецЕсли;
	
	Объект.БанковскийСчетПолучатель = Справочники.БанковскиеСчетаОрганизаций.ПустаяСсылка();
	Объект.КассаПолучатель          = Справочники.Кассы.ПустаяСсылка();
	
КонецПроцедуры

#КонецОбласти

#Область УправлениеЭлементамиФормы

&НаСервере
Процедура УправлениеЭлементамиФормы()
	
	Перем МассивВсехРеквизитов;
	Перем МассивРеквизитовОперации;
	
	Документы.РаспоряжениеНаПеремещениеДенежныхСредств.ЗаполнитьИменаРеквизитовПоХозяйственнойОперации(
		Объект.ХозяйственнаяОперация, 
		МассивВсехРеквизитов, 
		МассивРеквизитовОперации);
    ДенежныеСредстваСервер.УстановитьВидимостьЭлементовПоМассиву(
		Элементы,
		МассивВсехРеквизитов,
		МассивРеквизитовОперации);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступностьЭлементовПоСтатусу(УстанавливатьТолькоПросмотр)
	
	Если Объект.Статус = Перечисления.СтатусыРаспоряженийНаПеремещениеДенежныхСредств.Согласовано Тогда
		ТолькоПросмотрЭлементов = Объект.Проведен И УстанавливатьТолькоПросмотр;
		
	ИначеЕсли Объект.Статус = Перечисления.СтатусыРаспоряженийНаПеремещениеДенежныхСредств.КОплате Тогда
		ТолькоПросмотрЭлементов = Объект.Проведен;
		
	Иначе
		ТолькоПросмотрЭлементов = Ложь;
		
	КонецЕсли;
	
	Элементы.Номер.ТолькоПросмотр = ТолькоПросмотрЭлементов;
	Элементы.Дата.ТолькоПросмотр = ТолькоПросмотрЭлементов;
	Элементы.БанковскийСчет.ТолькоПросмотр = ТолькоПросмотрЭлементов;
	Элементы.Касса.ТолькоПросмотр = ТолькоПросмотрЭлементов;
	Элементы.СуммаДокумента.ТолькоПросмотр = ТолькоПросмотрЭлементов;
	Элементы.Валюта.ТолькоПросмотр = ТолькоПросмотрЭлементов;
	
	Элементы.ХозяйственнаяОперация.ТолькоПросмотр = ТолькоПросмотрЭлементов;
	Элементы.БанковскийСчетПолучатель.ТолькоПросмотр = ТолькоПросмотрЭлементов;
	Элементы.КассаПолучатель.ТолькоПросмотр = ТолькоПросмотрЭлементов;
	Элементы.ДатаПлатежа.ТолькоПросмотр = ТолькоПросмотрЭлементов;
	
	Если УстанавливатьТолькоПросмотр Тогда
		Элементы.КтоРешил.Видимость = (Объект.Статус = Перечисления.СтатусыРаспоряженийНаПеремещениеДенежныхСредств.Согласовано
		 Или Объект.Статус = Перечисления.СтатусыРаспоряженийНаПеремещениеДенежныхСредств.КОплате);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УточнитьСписокХозяйственныхОпераций()

	ИспользоватьНесколькоРасчетныхСчетов	= ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоРасчетныхСчетов");
	ИспользоватьНесколькоКасс				= ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоКасс");

	Если Не ИспользоватьНесколькоРасчетныхСчетов Тогда
	
		СписокВыбораХозяйственныхОпераций = Элементы.ХозяйственнаяОперация.СписокВыбора;	
		НайденныйЭлемент = СписокВыбораХозяйственныхОпераций.НайтиПоЗначению(Перечисления.ХозяйственныеОперации.ПеречислениеДенежныхСредствНаДругойСчет);
		Если НайденныйЭлемент <> Неопределено Тогда
			СписокВыбораХозяйственныхОпераций.Удалить(НайденныйЭлемент);
		КонецЕсли; 
	
	КонецЕсли; 

	Если Не ИспользоватьНесколькоКасс Тогда
	
		СписокВыбораХозяйственныхОпераций = Элементы.ХозяйственнаяОперация.СписокВыбора;	
		НайденныйЭлемент = СписокВыбораХозяйственныхОпераций.НайтиПоЗначению(Перечисления.ХозяйственныеОперации.ВыдачаДенежныхСредствВДругуюКассу);
		Если НайденныйЭлемент <> Неопределено Тогда
			СписокВыбораХозяйственныхОпераций.Удалить(НайденныйЭлемент);
		КонецЕсли; 
	
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	ТекущаяКасса = Объект.Касса;
	ТекущийБанковскийСчет = Объект.БанковскийСчет;
	УправлениеЭлементамиФормы();
	УстановитьДоступностьЭлементовПоСтатусу(Истина);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРеквизитыДокументаПоХозяйственнойОперации()
	
	Если Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.СдачаДенежныхСредствВБанк
		Или Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ИнкассацияДенежныхСредствВБанк Тогда
		
		СтруктураПараметров = ДенежныеСредстваСервер.ПараметрыЗаполненияКассыОрганизацииПоУмолчанию();
		СтруктураПараметров.Организация  = Объект.Организация;
		СтруктураПараметров.Касса		= Объект.Касса;

		Объект.Касса = ЗначениеНастроекПовтИсп.ПолучитьКассуОрганизацииПоУмолчанию(СтруктураПараметров);
		
		Объект.Валюта = Справочники.Кассы.ПолучитьРеквизитыКассы(Объект.Касса).Валюта;
		
	ИначеЕсли Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПоступлениеДенежныхСредствИзБанка
		Или Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.СнятиеНаличныхДенежныхСредств Тогда
		
		СтруктураПараметров = ДенежныеСредстваСервер.ПараметрыЗаполненияБанковскогоСчетаОрганизацииПоУмолчанию();
		СтруктураПараметров.Организация    		= Объект.Организация;
		СтруктураПараметров.БанковскийСчет		= Объект.БанковскийСчет;
		Объект.БанковскийСчет = ЗначениеНастроекПовтИсп.ПолучитьБанковскийСчетОрганизацииПоУмолчанию(СтруктураПараметров);
		
		Объект.Валюта = Справочники.БанковскиеСчетаОрганизаций.ПолучитьРеквизитыБанковскогоСчетаОрганизации(Объект.БанковскийСчет).Валюта;
		
	КонецЕсли;
	
	Если Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПоступлениеДенежныхСредствИзБанка
		Или Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.СнятиеНаличныхДенежныхСредств Тогда
		
		ОрганизацияПолучатель = Объект.Организация;
		
		КассаПолучатель = Справочники.Кассы.ПолучитьКассуПоУмолчанию(
			ОрганизацияПолучатель,
			Объект.Валюта);
		Если ЗначениеЗаполнено(КассаПолучатель) Тогда
			Объект.КассаПолучатель = КассаПолучатель;
		КонецЕсли;
		
	ИначеЕсли Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.СдачаДенежныхСредствВБанк
		Или Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ИнкассацияДенежныхСредствВБанк Тогда
		
		ОрганизацияПолучатель = Объект.Организация;

		БанковскийСчетПолучатель = Справочники.БанковскиеСчетаОрганизаций.ПолучитьБанковскийСчетОрганизацииПоУмолчанию(
			ОрганизацияПолучатель,
			Объект.Валюта);
		Если ЗначениеЗаполнено(БанковскийСчетПолучатель) Тогда
			Объект.БанковскийСчетПолучатель = БанковскийСчетПолучатель;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьРеквизитыКассы(Касса)
	
	Возврат Справочники.Кассы.ПолучитьРеквизитыКассы(Касса);
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьРеквизитыБанковскогоСчета(БанковскийСчет)
	
	Возврат Справочники.БанковскиеСчетаОрганизаций.ПолучитьРеквизитыБанковскогоСчетаОрганизации(БанковскийСчет);
	
КонецФункции

&НаСервере
Процедура ПересчетСуммДокументаВВалюту(ТекущаяВалюта)
	
	ДенежныеСредстваСервер.ПересчетСуммДокументаВВалюту(
		Объект,
		ТекущаяВалюта,
		Объект.Валюта);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиКомандФормы

// ВводНаОсновании
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуСоздатьНаОсновании(Команда)
	
	ВводНаОснованииКлиент.ВыполнитьПодключаемуюКомандуСоздатьНаОсновании(Команда, ЭтотОбъект, Объект);
	
КонецПроцедуры
// Конец ВводНаОсновании

// МенюОтчеты
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуОтчет(Команда)
	
	МенюОтчетыКлиент.ВыполнитьПодключаемуюКомандуОтчет(Команда, ЭтотОбъект, Объект);
	
КонецПроцедуры
// Конец МенюОтчеты


// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

&НаКлиенте
Процедура Подключаемый_ВыполнитьНазначаемуюКоманду(Команда)
	
	Если НЕ ДополнительныеОтчетыИОбработкиКлиент.ВыполнитьНазначаемуюКомандуНаКлиенте(ЭтаФорма, Команда.Имя) Тогда
		РезультатВыполнения = Неопределено;
		ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(Команда.Имя, РезультатВыполнения);
		ДополнительныеОтчетыИОбработкиКлиент.ПоказатьРезультатВыполненияКоманды(ЭтаФорма, РезультатВыполнения);
	КонецЕсли;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

&НаСервере
Процедура ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(ИмяЭлемента, РезультатВыполнения)
	
	ДополнительныеОтчетыИОбработки.ВыполнитьНазначаемуюКомандуНаСервере(ЭтаФорма, ИмяЭлемента, РезультатВыполнения);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

#КонецОбласти
