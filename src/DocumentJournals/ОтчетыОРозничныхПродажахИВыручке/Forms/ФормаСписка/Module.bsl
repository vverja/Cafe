#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ОбщегоНазначенияУТ.НастроитьПодключаемоеОборудование(ЭтаФорма);
	
	КассаККМЗаполнена = ЗначениеЗаполнено(КассаККМ);
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ОтчетыОРозничныхПродажахИВыручкеСоздать", "Доступность", НЕ ЗапрещеноДобавлятьНовыеДокументы И КассаККМЗаполнена);
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ОтчетыОРозничныхПродажахИВыручкеСкопировать", "Доступность", НЕ ЗапрещеноДобавлятьНовыеДокументы И КассаККМЗаполнена);
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "КонтекстноеМенюОтчетыОРозничныхПродажахИВыручкеСоздать", "Доступность", НЕ ЗапрещеноДобавлятьНовыеДокументы И КассаККМЗаполнена);
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "КонтекстноеМенюОтчетыОРозничныхПродажахИВыручкеСкопировать", "Доступность", НЕ ЗапрещеноДобавлятьНовыеДокументы И КассаККМЗаполнена);
	
	// Скрываем колонку СтатусКассовойСмены для автономных ККМ
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СтатусКассовойСмены", "Видимость", ЗапрещеноДобавлятьНовыеДокументы ИЛИ НЕ КассаККМЗаполнена);
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма, Элементы.ПодменюПечать);
	// Конец СтандартныеПодсистемы.Печать
	
	// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма, ДополнительныеОтчетыИОбработкиКлиентСервер.ТипФормыСписка());
	// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма, Элементы.ОтчетыОРозничныхПродажахИВыручкеКоманднаяПанель);
	// Конец ИнтеграцияС1СДокументооборотом
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	// ВводНаОсновании
	ВводНаОсновании.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюСоздатьНаОсновании);
	// Конец ВводНаОсновании

	// МенюОтчеты
	МенюОтчеты.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюОтчеты);
	// Конец МенюОтчеты
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	МенеджерОборудованияКлиент.ПодключитьОборудованиеПриОткрытииФормы(ЭтаФорма, "СканерШтрихкода");
	
	УстановитьДоступностьКнопокСозданияНовыхДокументов();

КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	МенеджерОборудованияКлиент.ОтключитьОборудованиеПриЗакрытииФормы(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование" И ВводДоступен() Тогда
		Если ИмяСобытия = "ScanData" Тогда
			ОбработатьШтрихкоды(МенеджерОборудованияКлиент.ПреобразоватьДанныеСоСканераВСтруктуру(Параметр));
		КонецЕсли;
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
	Если ИмяСобытия = "Запись_ОтчетОРозничныхПродажах" 
	 ИЛИ ИмяСобытия = "ЗаписьВФорме_ОтчетОРозничныхПродажах"	
	 ИЛИ ИмяСобытия = "ЗаписьВФорме_ОтчетОРозничнойВыручке" Тогда	
		Элементы.ОтчетыОРозничныхПродажахИВыручке.Обновить();		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	КассаККМ = Настройки.Получить("КассаККМ");
	УстановитьОтборДинамическихСписков();
	
	ЗапрещеноДобавлятьНовыеДокументы = ЗапрещеноДобавлятьНовыеДокументы(КассаККМ);
	
	КассаККМЗаполнена = ЗначениеЗаполнено(КассаККМ);
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ОтчетыОРозничныхПродажахИВыручкеСоздать", "Доступность", НЕ ЗапрещеноДобавлятьНовыеДокументы И КассаККМЗаполнена);
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ОтчетыОРозничныхПродажахИВыручкеСкопировать", "Доступность", НЕ ЗапрещеноДобавлятьНовыеДокументы И КассаККМЗаполнена);
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "КонтекстноеМенюОтчетыОРозничныхПродажахИВыручкеСоздать", "Доступность", НЕ ЗапрещеноДобавлятьНовыеДокументы И КассаККМЗаполнена);
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "КонтекстноеМенюОтчетыОРозничныхПродажахИВыручкеСкопировать", "Доступность", НЕ ЗапрещеноДобавлятьНовыеДокументы И КассаККМЗаполнена);
	
	// Скрываем колонку СтатусКассовойСмены для автономных ККМ
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СтатусКассовойСмены", "Видимость", ЗапрещеноДобавлятьНовыеДокументы ИЛИ НЕ КассаККМЗаполнена);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КассаОтборПриИзменении(Элемент)
	
	УстановитьОтборДинамическихСписковНаКлиенте();
	УстановитьДоступностьКнопокСозданияНовыхДокументов();
	
КонецПроцедуры

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Элементы.ОтчетыОРозничныхПродажахИВыручке);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

// МенюОтчеты
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуОтчет(Команда)
	
	МенюОтчетыКлиент.ВыполнитьПодключаемуюКомандуОтчет(Команда, ЭтотОбъект, Элементы.ОтчетыОРозничныхПродажахИВыручке);
	
КонецПроцедуры
// Конец МенюОтчеты

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуСоздатьНаОсновании(Команда)
	
	ВводНаОснованииКлиент.ВыполнитьПодключаемуюКомандуСоздатьНаОсновании(Команда, ЭтаФорма, Элементы.ОтчетыОРозничныхПродажахИВыручке);
	
КонецПроцедуры

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Элементы.ОтчетыОРозничныхПродажахИВыручке);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыОтчетыОРозничныхПродажахИВыручке

&НаКлиенте
Процедура ОтчетыОРозничныхПродажахИВыручкеПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	КассаККМЗаполнена = ЗначениеЗаполнено(КассаККМ);
	Отказ = Не(Не ЗапрещеноДобавлятьНовыеДокументы И КассаККМЗаполнена);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ШтрихкодыИТорговоеОборудование


&НаКлиенте
Функция СсылкаНаЭлементСпискаПоШтрихкоду(Штрихкод)
	
	Менеджеры = Новый Массив();
	Менеджеры.Добавить(ПредопределенноеЗначение("Документ.ОтчетОРозничныхПродажах.ПустаяСсылка"));
	Менеджеры.Добавить(ПредопределенноеЗначение("Документ.ОтчетОРозничнойВыручке.ПустаяСсылка"));
	Возврат ШтрихкодированиеПечатныхФормКлиент.ПолучитьСсылкуПоШтрихкодуТабличногоДокумента(Штрихкод, Менеджеры);
	
КонецФункции

&НаКлиенте
Процедура ОбработатьШтрихкоды(Данные)
	
	МассивСсылок = СсылкаНаЭлементСпискаПоШтрихкоду(Данные.Штрихкод);
	Если МассивСсылок.Количество() > 0 Тогда
		Ссылка = МассивСсылок[0];
		Элементы.Список.ТекущаяСтрока = Ссылка;
		ОткрытьЗначение(Ссылка);
	Иначе
		ШтрихкодированиеПечатныхФормКлиент.ОбъектНеНайден(Данные.Штрихкод);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервереБезКонтекста
Функция ЗапрещеноДобавлятьНовыеДокументы(КассаККМ)
	
	Реквизиты = Справочники.КассыККМ.РеквизитыКассыККМ(КассаККМ);
	Возврат Реквизиты.ТипКассы = Перечисления.ТипыКассККМ.ФискальныйРегистратор
	    ИЛИ Реквизиты.ТипКассы = Перечисления.ТипыКассККМ.ККМOffline;
	
КонецФункции

// Так же вызывается ПриЗагрузкеДанныхИзНастроекНаСервере
&НаКлиенте
Процедура УстановитьДоступностьКнопокСозданияНовыхДокументов()
	
	ЗапрещеноДобавлятьНовыеДокументы = ЗапрещеноДобавлятьНовыеДокументы(КассаККМ);
	
	КассаККМЗаполнена = ЗначениеЗаполнено(КассаККМ);
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СписокСоздатьОтчетОРозничныхПродажах", "Доступность", НЕ ЗапрещеноДобавлятьНовыеДокументы И КассаККМЗаполнена);
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СписокСоздатьОтчетОРозничнойВыручке", "Доступность", НЕ ЗапрещеноДобавлятьНовыеДокументы И КассаККМЗаполнена);
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СписокСкопировать", "Доступность", НЕ ЗапрещеноДобавлятьНовыеДокументы И КассаККМЗаполнена);
	
	// Скрываем колонку СтатусКассовойСмены для автономных ККМ
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СтатусКассовойСмены", "Видимость", ЗапрещеноДобавлятьНовыеДокументы ИЛИ НЕ КассаККМЗаполнена);
	
КонецПроцедуры

// Процедура устанавливает отбор динамических списков формы.
//
&НаСервере
Процедура УстановитьОтборДинамическихСписков()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ОтчетыОРозничныхПродажахИВыручке.Отбор, "КассаККМ", КассаККМ, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(КассаККМ));
	
КонецПроцедуры

// Процедура устанавливает отбор динамических списков формы.
//
&НаКлиенте
Процедура УстановитьОтборДинамическихСписковНаКлиенте()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ОтчетыОРозничныхПродажахИВыручке.Отбор, "КассаККМ", КассаККМ, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(КассаККМ));
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти