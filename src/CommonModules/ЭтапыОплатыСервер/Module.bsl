
////////////////////////////////////////////////////////////////////////////////
// Модуль "ЭтапыОплатыСервер" содержит процедуры и функции для 
// работы с механизмом этапов оплаты,
// в первую очередь заполнение этапов оплаты различных объектов
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает структуру с параметрами выбора реквизитов оплаты для передачи во внешние формы.
//
// Параметры:
// 		ОбъектМетаданных - ОбъектМетаданных - объект метаданных, по которому нужно определить параметры
//
// Возвращаемое значение:
// 		Структура - использует в качестве ключа имя реквизита оплаты, а в значении содержит фиксированный массив с параметрами выбора
//
Функция ПараметрыВыбораРеквизитовОплаты(ОбъектМетаданных) Экспорт
	
	РеквизитыОбъекта = ОбъектМетаданных.Реквизиты;
	ПараметрыВыбораРеквизитов = Новый Структура;
	
	ПараметрыВыбораРеквизитов.Вставить("ФормаОплаты", РеквизитыОбъекта.ФормаОплаты.ПараметрыВыбора);
	
	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("Касса", ОбъектМетаданных) Тогда
		ПараметрыВыбораРеквизитов.Вставить("Касса", РеквизитыОбъекта.Касса.ПараметрыВыбора);
	КонецЕсли;
	
	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("БанковскийСчет", ОбъектМетаданных) Тогда
		ПараметрыВыбораРеквизитов.Вставить("БанковскийСчет", РеквизитыОбъекта.БанковскийСчет.ПараметрыВыбора);
	ИначеЕсли ОбщегоНазначения.ЕстьРеквизитОбъекта("БанковскийСчетОрганизации", ОбъектМетаданных) Тогда
		ПараметрыВыбораРеквизитов.Вставить("БанковскийСчет", РеквизитыОбъекта.БанковскийСчетОрганизации.ПараметрыВыбора);
	КонецЕсли;
	
	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("ГрафикОплаты", ОбъектМетаданных) Тогда
		ПараметрыВыбораРеквизитов.Вставить("ГрафикОплаты", РеквизитыОбъекта.ГрафикОплаты.ПараметрыВыбора);
	КонецЕсли;
	
	Возврат ПараметрыВыбораРеквизитов;
	
КонецФункции

#Область ЗаполнениеДокументовПродажи

// Заполняет этапы графика оплаты или распределяет уже заполненную сумму в документах продажи.
//
// Параметры:
//
// 		Объект - ДокументОбъект - документ, для которого заполняются этапы графика оплаты
// 		ГрафикСоглашенияЗаполнен - Булево - флаг возможности заполнения по графику указанном в соглашении
// 		ГрафикЗаполнен - Булево - флаг возможности заполнения по шаблону графика оплаты, указанном в документе
// 		СуммаОплаты - Число - сумма, распределяющаяся по этапам графика оплаты
// 		СуммаЗалога - Число - сумма залога, распределяющаяся по этапам графика оплаты
// 		ЗаполнятьФормуОплаты - Булево - признак, указывающий на необходимость заполнения формы оплаты из соглашения или графика
// 		ЗаполнятьСНулевойСуммой - Булево - признак, позволяющий заполнить этапы, если не задана суммы к распределению
//
Процедура ЗаполнитьЭтапыОплатыДокументаПродажи(Объект,
	                                      ГрафикСоглашенияЗаполнен, ГрафикЗаполнен,
	                                      СуммаОплаты, СуммаЗалога = 0,
	                                      ЗаполнятьФормуОплаты = Ложь, ЗаполнятьСНулевойСуммой = Ложь) Экспорт
	
	Если ГрафикСоглашенияЗаполнен Тогда
		ЗаполнитьЭтапыОплатыДокументаПродажиПоСоглашению(
			Объект,
			СуммаОплаты,
			СуммаЗалога,
			ЗаполнятьФормуОплаты,
			ЗаполнятьСНулевойСуммой);
	ИначеЕсли ГрафикЗаполнен Тогда
		ЗаполнитьЭтапыОплатыДокументаПродажиПоГрафикуОплаты(
			Объект,
			СуммаОплаты,
			СуммаЗалога,
			ЗаполнятьФормуОплаты,
			ЗаполнятьСНулевойСуммой);
	ИначеЕсли Объект.ЭтапыГрафикаОплаты.Количество() > 0 Тогда
		ЭтапыОплатыКлиентСервер.РаспределитьСуммуПоЭтапамГрафикаОплаты(
			Объект.ЭтапыГрафикаОплаты,
			СуммаОплаты,
			СуммаЗалога);
	КонецЕсли;
	
Конецпроцедуры

// Заполняет этапы графика оплаты в документе продажи по графику указанном в соглашении.
//
// Параметры:
// 		Объект - ДокументОбъект - документ, в котором необходимо заполнить этапы оплаты
// 		СуммаКРаспределениюОплаты - Число, сумма платежей, распределяющаяся по этапам графика оплаты
// 		СуммаКРаспределениюЗалога - Число, сумма залога за тару, распределяющаяся по этапам графика оплаты
// 		ЗаполнятьФормуОплаты - Булево - признак, указывающий на необходимость заполнения формы оплаты
// 			в документе формой оплаты по графику, указанной в соглашении
//
Процедура ЗаполнитьЭтапыОплатыДокументаПродажиПоСоглашению(Объект,
	                                              Знач СуммаКРаспределениюОплаты,
	                                              Знач СуммаКРаспределениюЗалога = 0,
	                                              ЗаполнятьФормуОплаты = Ложь,
	                                              ЗаполнятьСНулевойСуммой = Ложь) Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	СоглашенияСКлиентамиЭтапыГрафикаОплаты.НомерСтроки КАК НомерСтроки,
	|	СоглашенияСКлиентамиЭтапыГрафикаОплаты.ВариантОплаты КАК ВариантОплаты,
	|	СоглашенияСКлиентамиЭтапыГрафикаОплаты.Сдвиг КАК Сдвиг,
	|	СоглашенияСКлиентамиЭтапыГрафикаОплаты.ПроцентПлатежа КАК ПроцентПлатежа,
	|	СоглашенияСКлиентамиЭтапыГрафикаОплаты.ПроцентЗалогаЗаТару КАК ПроцентЗалогаЗаТару,
	|	СоглашенияСКлиентамиЭтапыГрафикаОплаты.Ссылка.ФормаОплаты КАК ФормаОплаты,
	|	СоглашенияСКлиентамиЭтапыГрафикаОплаты.Ссылка.Календарь КАК Календарь
	|ИЗ
	|	Справочник.СоглашенияСКлиентами.ЭтапыГрафикаОплаты КАК СоглашенияСКлиентамиЭтапыГрафикаОплаты
	|ГДЕ
	|	СоглашенияСКлиентамиЭтапыГрафикаОплаты.Ссылка = &Соглашение
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки");
		
	Запрос.УстановитьПараметр("Соглашение", Объект.Соглашение);
	
	РезультатЗапроса = Запрос.Выполнить();
	Выгрузка         = РезультатЗапроса.Выгрузить();
	
	Если (СуммаКРаспределениюОплаты = 0 И СуммаКРаспределениюЗалога = 0 И НЕ ЗаполнятьСНулевойСуммой)
		ИЛИ Выгрузка.Количество() = 0 Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Если ЗаполнятьФормуОплаты Тогда
		
		ФормаОплаты = Выгрузка[0].ФормаОплаты;
		
		Если ЗначениеЗаполнено(ФормаОплаты) И Объект.ФормаОплаты <> ФормаОплаты Тогда
			Объект.ФормаОплаты = ФормаОплаты;
		КонецЕсли;
		
	КонецЕсли;
	
	ЗаполнитьЭтапыОплатыДокументаПродажиПоШаблону(Объект,
		СуммаКРаспределениюОплаты,
		СуммаКРаспределениюЗалога,
		Выгрузка,
		Выгрузка[0].Календарь);
	
КонецПроцедуры

// Заполняет авансовые этапы графика оплаты в документе ЗаказКлиента
//
// Параметры:
//
// 		Объект - ДокументОбъект - документ, в котором необходимо заполнить этапы оплаты
// 		СуммаКРаспределениюОплаты - Число - сумма документа, в котором необходимо осуществить проверку
// 		СуммаКРаспределениюЗалога - Число - сумма залога по документу, в котором необходимо осуществить проверку
// 		ЗаполнятьФормуОплаты - Булево - признак, указывающий на необходимость заполнения формы оплаты
// 			в документе формой оплаты по графику
//
Процедура ЗаполнитьЭтапыОплатыДокументаПродажиПоГрафикуОплаты(Объект,
	                                  Знач СуммаКРаспределениюОплаты,
	                                  Знач СуммаКРаспределениюЗалога = 0,
	                                  ЗаполнятьФормуОплаты = Ложь,
	                                  ЗаполнятьСНулевойСуммой = Ложь) Экспорт
	
	Запрос = Новый Запрос("
		|ВЫБРАТЬ
		|	ГрафикиОплатыЭтапы.НомерСтроки         КАК НомерСтроки,
		|	ГрафикиОплатыЭтапы.ВариантОплаты       КАК ВариантОплаты,
		|	ГрафикиОплатыЭтапы.Сдвиг               КАК Сдвиг,
		|	ГрафикиОплатыЭтапы.ПроцентПлатежа      КАК ПроцентПлатежа,
		|	ГрафикиОплатыЭтапы.ПроцентЗалогаЗаТару КАК ПроцентЗалогаЗаТару,
		|	ГрафикиОплатыЭтапы.Ссылка.Календарь    КАК Календарь,
		|	ГрафикиОплатыЭтапы.Ссылка.ФормаОплаты  КАК ФормаОплаты
		|ИЗ
		|	Справочник.ГрафикиОплаты.Этапы КАК ГрафикиОплатыЭтапы
		|ГДЕ
		|	ГрафикиОплатыЭтапы.Ссылка = &ГрафикОплаты
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки ВОЗР
		|");
		
	Запрос.УстановитьПараметр("ГрафикОплаты",Объект.ГрафикОплаты);
	
	РезультатЗапроса = Запрос.Выполнить();
	Выгрузка         = РезультатЗапроса.Выгрузить();
	
	Если Выгрузка.Количество() = 0 Тогда
		
		Объект.ЭтапыГрафикаОплаты.Очистить();
		Возврат;
		
	КонецЕсли;
	
	Если ЗаполнятьФормуОплаты Тогда
		
		ФормаОплаты = Выгрузка[0].ФормаОплаты;
		
		Если ЗначениеЗаполнено(ФормаОплаты) И Объект.ФормаОплаты <> ФормаОплаты Тогда
			Объект.ФормаОплаты = ФормаОплаты;
		КонецЕсли;
		
	КонецЕсли;
	
	Если СуммаКРаспределениюОплаты = 0 И СуммаКРаспределениюЗалога = 0 И Не ЗаполнятьСНулевойСуммой Тогда
		
		Объект.ЭтапыГрафикаОплаты.Очистить();
		Возврат;
		
	КонецЕсли;
	
	ЗаполнитьЭтапыОплатыДокументаПродажиПоШаблону(
		Объект,
		СуммаКРаспределениюОплаты,
		СуммаКРаспределениюЗалога,
		Выгрузка,
		Выгрузка[0].Календарь);
	
КонецПроцедуры

// Заполняет этапы графика оплаты в документе продажи по таблице значений
//
// Параметры:
//		Объект - ДокументОбъект - документ,  в котором необходимо заполнить этапы оплаты
//		СуммаКРаспределениюОплаты - Число, сумма платежей, распределяющаяся по этапам графика оплаты
//		СуммаКРаспределениюЗалога - Число, сумма залога за тару, распределяющаяся по этапам графика оплаты
//		ШаблонГрафика - ТаблицаЗначений, по которой необходимо заполнить этапы графика оплаты
//		Календарь - СправочникСсылка.Календари, по которому вычисляются даты
//
Процедура ЗаполнитьЭтапыОплатыДокументаПродажиПоШаблону(Объект,
	                                           Знач СуммаКРаспределениюОплаты,
	                                           Знач СуммаКРаспределениюЗалога = 0,
	                                           ШаблонГрафика,
	                                           Знач Календарь) Экспорт
	
	ЭтапыГрафикаОплаты = Новый ТаблицаЗначений();
	
	ЭтапыГрафикаОплаты.Колонки.Добавить("ВариантОплаты");
	ЭтапыГрафикаОплаты.Колонки.Добавить("ДатаПлатежа");
	ЭтапыГрафикаОплаты.Колонки.Добавить("ПроцентПлатежа");
	ЭтапыГрафикаОплаты.Колонки.Добавить("СуммаПлатежа");
	ЭтапыГрафикаОплаты.Колонки.Добавить("ПроцентЗалогаЗаТару");
	ЭтапыГрафикаОплаты.Колонки.Добавить("СуммаЗалогаЗаТару");

	РаспределеннаяСуммаОплаты = 0;
	РаспределеннаяСуммаЗалога = 0;
	ТекущийЭтап               = 0;
	ОдинДень                  = 86400;
	
	КоличествоЭтапов = ШаблонГрафика.Количество();
	
	ДатаДокумента = ?(ЗначениеЗаполнено(Объект.Дата), Объект.Дата, ТекущаяДатаСеанса());
	ЖелаемаяДатаОтгрузки = ?(ОбщегоНазначенияУТКлиентСервер.ЕстьРеквизитОбъекта(Объект, "ЖелаемаяДатаОтгрузки"), 
		Объект.ЖелаемаяДатаОтгрузки, Неопределено);
	ДатаРеализации = ЖелаемаяДатаОтгрузки;
	
	// Определим календарную дату для каждого этапа графика оплаты
	УчитыватьКалендарь = Ложь;
	
	Если ЗначениеЗаполнено(Календарь) Тогда
		
		УчитыватьКалендарь = Истина;
		
		СдвигиАвансовыхЭтапов = Новый Массив();
		СдвигиКредитныхЭтапов = Новый Массив();
		МассивДатПоКалендарю  = Новый Массив();
		
		Для Каждого Этап Из ШаблонГрафика Цикл
			
			Если Этап.ВариантОплаты = Перечисления.ВариантыОплатыКлиентом.ПредоплатаДоОтгрузки Или
				Этап.ВариантОплаты = Перечисления.ВариантыОплатыКлиентом.АвансДоОбеспечения Тогда
				СдвигиАвансовыхЭтапов.Добавить(Этап.Сдвиг);
			Иначе
				СдвигиКредитныхЭтапов.Добавить(Этап.Сдвиг);
			КонецЕсли;
			
		КонецЦикла;
		
		Если СдвигиАвансовыхЭтапов.Количество() > 0 Тогда
			
			МассивДатПоКалендарюАвансовыхЭтапов = КалендарныеГрафики.ПолучитьМассивДатПоКалендарю(Календарь, ДатаДокумента, СдвигиАвансовыхЭтапов);
			
			Для Каждого ДатаПоКалендарю Из МассивДатПоКалендарюАвансовыхЭтапов Цикл
				МассивДатПоКалендарю.Добавить(ДатаПоКалендарю);
			КонецЦикла;
			
		КонецЕсли;
		
		Если СдвигиКредитныхЭтапов.Количество() > 0 Тогда
			
			Если Не ЗначениеЗаполнено(ДатаРеализации) Тогда
				
				Если СдвигиАвансовыхЭтапов.Количество() > 0 Тогда
					Если МассивДатПоКалендарюАвансовыхЭтапов.Количество() > 0 Тогда
						ДатаРеализации = МассивДатПоКалендарюАвансовыхЭтапов[МассивДатПоКалендарюАвансовыхЭтапов.Количество()-1];
					КонецЕсли;
				Иначе
					ДатаРеализации = ДатаДокумента;
				КонецЕсли;
				
			КонецЕсли;
			
			МассивДатПоКалендарюКредитныхЭтапов = КалендарныеГрафики.ПолучитьМассивДатПоКалендарю(Календарь, ДатаРеализации, СдвигиКредитныхЭтапов);
			
			Для Каждого ДатаПоКалендарю Из МассивДатПоКалендарюКредитныхЭтапов Цикл
				МассивДатПоКалендарю.Добавить(ДатаПоКалендарю);
			КонецЦикла;
			
		КонецЕсли;
		
	Иначе
		
		Если Не ЗначениеЗаполнено(ДатаРеализации) Тогда
			
			МаксСдвигАванса = 0;
		
			Для Каждого ТекЭтап Из ШаблонГрафика Цикл
				
				Если ТекЭтап.ВариантОплаты = Перечисления.ВариантыОплатыКлиентом.ПредоплатаДоОтгрузки Или
					ТекЭтап.ВариантОплаты = Перечисления.ВариантыОплатыКлиентом.АвансДоОбеспечения Тогда
					
					МаксСдвигАванса = Макс(МаксСдвигАванса, ТекЭтап.Сдвиг);
					
				КонецЕсли;
				
			КонецЦикла;
			
			ДатаРеализации = ДатаДокумента + МаксСдвигАванса * ОдинДень;
			
		КонецЕсли;
		
	КонецЕсли;
	
	// Определим последний незалоговый этап
	ПоследнийНезалоговыйЭтап = КоличествоЭтапов;
	Пока ПоследнийНезалоговыйЭтап <> 0 И ШаблонГрафика[ПоследнийНезалоговыйЭтап-1].ПроцентПлатежа = 0 Цикл
		ПоследнийНезалоговыйЭтап = ПоследнийНезалоговыйЭтап - 1;
	КонецЦикла;
	
	// Определим последний залоговый этап
	ПоследнийЗалоговыйЭтап = КоличествоЭтапов;
	Пока ПоследнийЗалоговыйЭтап <> 0 И ШаблонГрафика[ПоследнийЗалоговыйЭтап-1].ПроцентЗалогаЗаТару = 0 Цикл
		ПоследнийЗалоговыйЭтап = ПоследнийЗалоговыйЭтап - 1;
	КонецЦикла;
	
	// Заполним этапы в соответствии с графиком оплаты
	Объект.ЭтапыГрафикаОплаты.Очистить();
	Для Каждого Этап Из ШаблонГрафика Цикл
		
		ТекущийЭтап                     = ТекущийЭтап + 1;
		ЭтапГрафикаОплаты               = ЭтапыГрафикаОплаты.Добавить();
		ЭтапГрафикаОплаты.ВариантОплаты = Этап.ВариантОплаты;
		
		Если УчитыватьКалендарь Тогда
			ДатаПлатежа = МассивДатПоКалендарю[ТекущийЭтап-1];
		Иначе
			ДатаПлатежа = ?(ЭтапГрафикаОплаты.ВариантОплаты = Перечисления.ВариантыОплатыКлиентом.КредитПослеОтгрузки, ДатаРеализации, ДатаДокумента) + Этап.Сдвиг * ОдинДень;
		КонецЕсли;
		
		Если (ЭтапГрафикаОплаты.ВариантОплаты = Перечисления.ВариантыОплатыКлиентом.ПредоплатаДоОтгрузки
			Или ЭтапГрафикаОплаты.ВариантОплаты = Перечисления.ВариантыОплатыКлиентом.АвансДоОбеспечения)
			И ЗначениеЗаполнено(ЖелаемаяДатаОтгрузки)
			И ДатаПлатежа > ЖелаемаяДатаОтгрузки Тогда
			ДатаПлатежа = ЖелаемаяДатаОтгрузки;
		КонецЕсли;
		
		ЭтапГрафикаОплаты.ДатаПлатежа         = ДатаПлатежа;
		ЭтапГрафикаОплаты.ПроцентПлатежа      = Этап.ПроцентПлатежа;
		СуммаОплатыПоЭтапу                    = Окр(СуммаКРаспределениюОплаты * Этап.ПроцентПлатежа / 100, 2, РежимОкругления.Окр15как20);
		ЭтапГрафикаОплаты.СуммаПлатежа        = ?(ТекущийЭтап = ПоследнийНезалоговыйЭтап, СуммаКРаспределениюОплаты - РаспределеннаяСуммаОплаты, СуммаОплатыПоЭтапу);
		РаспределеннаяСуммаОплаты             = РаспределеннаяСуммаОплаты + ЭтапГрафикаОплаты.СуммаПлатежа;
		ЭтапГрафикаОплаты.ПроцентЗалогаЗаТару = Этап.ПроцентЗалогаЗаТару;
		СуммаЗалогаПоЭтапу                    = Окр(СуммаКРаспределениюЗалога * Этап.ПроцентЗалогаЗаТару / 100, 2, РежимОкругления.Окр15как20);
		ЭтапГрафикаОплаты.СуммаЗалогаЗаТару   = ?(ТекущийЭтап = ПоследнийЗалоговыйЭтап, СуммаКРаспределениюЗалога - РаспределеннаяСуммаЗалога, СуммаЗалогаПоЭтапу);
		РаспределеннаяСуммаЗалога             = РаспределеннаяСуммаЗалога + ЭтапГрафикаОплаты.СуммаЗалогаЗаТару;
		
	КонецЦикла;
	
	Объект.ЭтапыГрафикаОплаты.Загрузить(ЭтапыГрафикаОплаты);

КонецПроцедуры

// Заполняет дату платежа по условиям из соглашения или подставляет текущую дату сеанса.
//
// Параметры:
//		Объект - ДокументОбъект - документ, в котором необходимо заполнить дату платежа
//		ГрафикОплаты - СправочникСсылка.ГрафикиОплаты - график оплаты из условий продаж,
//                     если не задан, то определяется в функции по соглашению документа
//		ПерезаполнитьДату - Булево - заполнить дату, в независимости, заполнена ли она
//
Процедура ЗаполнитьДатуПлатежаПоУмолчанию(Объект, ГрафикОплаты = Неопределено, ПерезаполнитьДату = Ложь) Экспорт
	
	ДатаПлатежаДоЗаполнения = Объект.ДатаПлатежа;
	
	Если (Не ЗначениеЗаполнено(Объект.ДатаПлатежа) Или ПерезаполнитьДату)
		И ПолучитьФункциональнуюОпцию("ИспользоватьСоглашенияСКлиентами") И ЗначениеЗаполнено(Объект.Соглашение) Тогда
		
		ГрафикСоглашенияЗаполнен = ПродажиВызовСервера.ГрафикСоглашенияЗаполнен(Объект.Соглашение);
		
		ИспользоватьГрафикиОплаты = ПолучитьФункциональнуюОпцию("ИспользоватьГрафикиОплаты");
		Если ГрафикСоглашенияЗаполнен Или Не ИспользоватьГрафикиОплаты Тогда
			ГрафикОплаты = Неопределено;
		ИначеЕсли Не ЗначениеЗаполнено(ГрафикОплаты) Тогда
			ГрафикОплаты = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Соглашение, "ГрафикОплаты")
		КонецЕсли;
		
		Объект.ДатаПлатежа = ПродажиСервер.ПолучитьПоследнююДатуПоГрафику(
			Объект.Дата,
			ГрафикОплаты,
			Объект.Соглашение
		);
		
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.ДатаПлатежа) Тогда
		Если ПерезаполнитьДату Тогда
			Объект.ДатаПлатежа = ДатаПлатежаДоЗаполнения;
		Иначе
			Объект.ДатаПлатежа = ТекущаяДатаСеанса();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Заполняет дату платежа по условиям из соглашения или подставляет текущую дату сеанса.
//
// Параметры:
//		Объект - ДокументОбъект - документ, в котором необходимо заполнить дату платежа
//		ГрафикОплаты - СправочникСсылка.ГрафикиОплаты - график оплаты из условий продаж,
//			если не задан, то определяется в функции по соглашению документа
//		ПерезаполнитьДату - Булево - заполнить дату, в независимости, заполнена ли она
//
Процедура ЗаполнитьДатуПлатежаВЗакупкахПоУмолчанию(Объект, ГрафикОплаты = Неопределено, ПерезаполнитьДату = Ложь) Экспорт
	
	ДатаПлатежаДоЗаполнения = Объект.ДатаПлатежа;
	
	Если (Не ЗначениеЗаполнено(Объект.ДатаПлатежа) Или ПерезаполнитьДату)
		И ПолучитьФункциональнуюОпцию("ИспользоватьСоглашенияСПоставщиками") И ЗначениеЗаполнено(Объект.Соглашение) Тогда
		
		Объект.ДатаПлатежа = ЗакупкиСервер.ПолучитьПоследнююДатуПоГрафику(
			Объект.Дата,
			Объект.Соглашение);
		
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.ДатаПлатежа) Тогда
		Если ПерезаполнитьДату Тогда
			Объект.ДатаПлатежа = ДатаПлатежаДоЗаполнения;
		Иначе
			Объект.ДатаПлатежа = ТекущаяДатаСеанса();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Процедура проверяет заполнение и корректность даты платежа в документе.
//
// Параметры:
//		ДатаПлатежа - Дата - дата платежа проверяемого документа
//		ДатаДокумента - Дата - дата проверяемого документа 
//		Отказ - Булево - Признак отказа от продолжения работы
//
Процедура ПроверитьЗаполнениеКорректностьДатыПлатежа(ДатаПлатежа, ДатаДокумента, Отказ) Экспорт
	
	Если Не ЗначениеЗаполнено(ДатаПлатежа) Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru='Поле ""Дата платежа"" не заполнено';uk='Поле ""Дата платежу"" не заповнено'"),
			,
			"НадписьЭтапыОплаты",
			,
			Отказ);
		
	ИначеЕсли ДатаПлатежа < НачалоДня(ДатаДокумента) Тогда
		
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Дата платежа должна быть не меньше даты документа %1';uk='Дата платежу повинна бути не менше дати документа %1'"),
			Формат(ДатаДокумента, "ДЛФ=DD"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстОшибки,
			,
			"НадписьЭтапыОплаты",
			,
			Отказ);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ЗаполнениеДокументовЗакупки

// Заполняет этапы графика оплаты или распределяет уже заполненную сумму в документах закупки.
//
// Параметры:
//
// 		Объект - ДокументОбъект - документ, для которого заполняются этапы графика оплаты
// 		ГрафикСоглашенияЗаполнен - Булево - флаг возможности заполнения по графику указанном в соглашении
// 		СуммаОплаты - Число - сумма, распределяющаяся по этапам графика оплаты
// 		СуммаЗалога - Число - сумма залога, распределяющаяся по этапам графика оплаты
// 		ЗаполнятьФормуОплаты - Булево - признак, указывающий на необходимость заполнения формы оплаты из соглашения или графика
// 		ШаблонГрафика - ТаблицаЗначений - таблица, по которой необходимо заполнить этапы графика оплаты
//
Процедура ЗаполнитьЭтапыОплатыДокументаЗакупки(Объект, ГрафикСоглашенияЗаполнен, СуммаОплаты, СуммаЗалога = 0, ЗаполнятьФормуОплаты = Ложь, ШаблонГрафика = Неопределено) Экспорт
	
	Если ГрафикСоглашенияЗаполнен Тогда
		ЗаполнитьЭтапыОплатыДокументаЗакупкиПоСоглашению(
			Объект,
			СуммаОплаты,
			СуммаЗалога,
			ЗаполнятьФормуОплаты);
	ИначеЕсли ЗначениеЗаполнено(ШаблонГрафика) Тогда
		ЗаполнитьЭтапыОплатыДокументаЗакупкиПоШаблону(
			Объект,
			СуммаОплаты,
			СуммаЗалога,
			ШаблонГрафика,
			Объект.Соглашение.Календарь);
	ИначеЕсли Объект.ЭтапыГрафикаОплаты.Количество() > 0 Тогда
		ЭтапыОплатыКлиентСервер.РаспределитьСуммуПоЭтапамГрафикаОплаты(
			Объект.ЭтапыГрафикаОплаты,
			СуммаОплаты,
			СуммаЗалога);
	КонецЕсли;
	
КонецПроцедуры

// Заполняет этапы графика оплаты в документе закупки по графику соглашения
//
// Параметры:
// 		Объект - ДокументОбъект - документ, в котором необходимо заполнить авансовые этапы оплаты
// 		СуммаОплатыКРаспределению - Число, сумма, распределяющаяся по этапам графика оплаты
// 		СуммаЗалогаКРаспределению - Число, сумма залога, распределяющаяся по этапам графика оплаты
// 		ЗаполнятьФормуОплаты - Булево - признак, указывающий на необходимость заполнения формы оплаты
// 			в документе формой оплаты по графику, указанной в соглашении
//
Процедура ЗаполнитьЭтапыОплатыДокументаЗакупкиПоСоглашению(Объект,
	                                              Знач СуммаОплатыКРаспределению,
	                                              Знач СуммаЗалогаКРаспределению = 0,
	                                              ЗаполнятьФормуОплаты = Ложь) Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	СоглашенияСПоставщикамиЭтапыГрафикаОплаты.НомерСтроки КАК НомерСтроки,
	|	СоглашенияСПоставщикамиЭтапыГрафикаОплаты.ВариантОплаты КАК ВариантОплаты,
	|	СоглашенияСПоставщикамиЭтапыГрафикаОплаты.Сдвиг КАК Сдвиг,
	|	СоглашенияСПоставщикамиЭтапыГрафикаОплаты.ПроцентПлатежа КАК ПроцентПлатежа,
	|	СоглашенияСПоставщикамиЭтапыГрафикаОплаты.ПроцентЗалогаЗаТару КАК ПроцентЗалогаЗаТару,
	|	СоглашенияСПоставщикамиЭтапыГрафикаОплаты.Ссылка.ФормаОплаты КАК ФормаОплаты,
	|	СоглашенияСПоставщикамиЭтапыГрафикаОплаты.Ссылка.Календарь КАК Календарь
	|ИЗ
	|	Справочник.СоглашенияСПоставщиками.ЭтапыГрафикаОплаты КАК СоглашенияСПоставщикамиЭтапыГрафикаОплаты
	|ГДЕ
	|	СоглашенияСПоставщикамиЭтапыГрафикаОплаты.Ссылка = &Соглашение
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки");
		
	Запрос.УстановитьПараметр("Соглашение", Объект.Соглашение);
	
	РезультатЗапроса = Запрос.Выполнить();
	Выгрузка         = РезультатЗапроса.Выгрузить();
	
	Если (СуммаОплатыКРаспределению = 0 И СуммаЗалогаКРаспределению = 0) ИЛИ Выгрузка.Количество() = 0 Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Если ЗаполнятьФормуОплаты Тогда
		
		ФормаОплаты = Выгрузка[0].ФормаОплаты;
		
		Если ЗначениеЗаполнено(ФормаОплаты) И Объект.ФормаОплаты <> ФормаОплаты Тогда
			Объект.ФормаОплаты = ФормаОплаты;
		КонецЕсли;
		
	КонецЕсли;
	
	ЗаполнитьЭтапыОплатыДокументаЗакупкиПоШаблону(
		Объект,
		СуммаОплатыКРаспределению,
		СуммаЗалогаКРаспределению,
		Выгрузка,
		Выгрузка[0].Календарь);
	
КонецПроцедуры

// Заполняет этапы графика оплаты в документе закупки по таблице значений
//
// Параметры:
// 		Объект - ДокументОбъект - документ, в котором необходимо заполнить авансовые этапы оплаты
// 		СуммаОплатыКРаспределению - Число, сумма, распределяющаяся по этапам графика оплаты
// 		СуммаЗалогаКРаспределению - Число, сумма залога, распределяющаяся по этапам графика оплаты
// 		ШаблонГрафика - ТаблицаЗначений, по которой необходимо заполнить этапы графика оплаты
// 		Календарь - СправочникСсылка.Календари, по которому вычисляются даты
//
Процедура ЗаполнитьЭтапыОплатыДокументаЗакупкиПоШаблону(Объект,
	                                  Знач СуммаОплатыКРаспределению,
	                                  Знач СуммаЗалогаКРаспределению,
	                                  ШаблонГрафика,
	                                  Знач Календарь) Экспорт
	
	ЭтапыГрафикаОплаты = Новый ТаблицаЗначений();
	
	ЭтапыГрафикаОплаты.Колонки.Добавить("ВариантОплаты");
	ЭтапыГрафикаОплаты.Колонки.Добавить("ДатаПлатежа");
	ЭтапыГрафикаОплаты.Колонки.Добавить("ПроцентПлатежа");
	ЭтапыГрафикаОплаты.Колонки.Добавить("СуммаПлатежа");
	ЭтапыГрафикаОплаты.Колонки.Добавить("ПроцентЗалогаЗаТару");
	ЭтапыГрафикаОплаты.Колонки.Добавить("СуммаЗалогаЗаТару");

	РаспределеннаяСуммаОплаты = 0;
	РаспределеннаяСуммаЗалога = 0;
	ТекущийЭтап               = 0;
	ОдинДень                  = 86400;
	
	КоличествоЭтапов = ШаблонГрафика.Количество();

	ДатаДокумента = ?(ЗначениеЗаполнено(Объект.Дата), Объект.Дата, ТекущаяДатаСеанса());
	ЖелаемаяДатаПоступления = ?(ОбщегоНазначенияУТКлиентСервер.ЕстьРеквизитОбъекта(Объект, "ЖелаемаяДатаПоступления"),
		Объект.ЖелаемаяДатаПоступления, Неопределено);
	ДатаПоступления = ЖелаемаяДатаПоступления;
	
	// Определим календарную дату для каждого этапа графика оплаты
	УчитыватьКалендарь = Ложь;
	
	Если ЗначениеЗаполнено(Календарь) Тогда
		
		УчитыватьКалендарь = Истина;
		
		СдвигиАвансовыхЭтапов = Новый Массив();
		СдвигиКредитныхЭтапов = Новый Массив();
		МассивДатПоКалендарю  = Новый Массив();
		
		Для Каждого Этап Из ШаблонГрафика Цикл
			
			Если Этап.ВариантОплаты = Перечисления.ВариантыОплатыПоставщику.ПредоплатаДоПоступления Или
				Этап.ВариантОплаты = Перечисления.ВариантыОплатыПоставщику.АвансДоПодтверждения Тогда
				СдвигиАвансовыхЭтапов.Добавить(Этап.Сдвиг);
			Иначе
				СдвигиКредитныхЭтапов.Добавить(Этап.Сдвиг);
			КонецЕсли;
			
		КонецЦикла;
		
		Если СдвигиАвансовыхЭтапов.Количество() > 0 Тогда
			
			МассивДатПоКалендарюАвансовыхЭтапов = КалендарныеГрафики.ПолучитьМассивДатПоКалендарю(Календарь, ДатаДокумента, СдвигиАвансовыхЭтапов);
			
			Для Каждого ДатаПоКалендарю Из МассивДатПоКалендарюАвансовыхЭтапов Цикл
				МассивДатПоКалендарю.Добавить(ДатаПоКалендарю);
			КонецЦикла;
			
		КонецЕсли;
		
		Если СдвигиКредитныхЭтапов.Количество() > 0 Тогда
			
			Если Не ЗначениеЗаполнено(ДатаПоступления) Тогда
				
				Если СдвигиАвансовыхЭтапов.Количество() > 0 Тогда
					Если МассивДатПоКалендарюАвансовыхЭтапов.Количество() > 0 Тогда
						ДатаПоступления = МассивДатПоКалендарюАвансовыхЭтапов[МассивДатПоКалендарюАвансовыхЭтапов.Количество()-1];
					КонецЕсли;
				Иначе
					ДатаПоступления = ДатаДокумента;
				КонецЕсли;
				
			КонецЕсли;
			
			МассивДатПоКалендарюКредитныхЭтапов = КалендарныеГрафики.ПолучитьМассивДатПоКалендарю(Календарь, ДатаПоступления, СдвигиКредитныхЭтапов);
			
			Для Каждого ДатаПоКалендарю Из МассивДатПоКалендарюКредитныхЭтапов Цикл
				МассивДатПоКалендарю.Добавить(ДатаПоКалендарю);
			КонецЦикла;
			
		КонецЕсли;
		
	Иначе
		
		Если Не ЗначениеЗаполнено(ДатаПоступления) Тогда
			
			МаксСдвигАванса = 0;
		
			Для Каждого ТекЭтап Из ШаблонГрафика Цикл
				
				Если ТекЭтап.ВариантОплаты = Перечисления.ВариантыОплатыПоставщику.ПредоплатаДоПоступления Или
					ТекЭтап.ВариантОплаты = Перечисления.ВариантыОплатыПоставщику.АвансДоПодтверждения Тогда
					
					МаксСдвигАванса = Макс(МаксСдвигАванса, ТекЭтап.Сдвиг);
					
				КонецЕсли;
				
			КонецЦикла;
			
			ДатаПоступления = ДатаДокумента + МаксСдвигАванса * ОдинДень;
			
		КонецЕсли;
		
	КонецЕсли;
	
	// Определим последний незалоговый этап
	ПоследнийНезалоговыйЭтап = КоличествоЭтапов;
	Пока ПоследнийНезалоговыйЭтап <> 0 И ШаблонГрафика[ПоследнийНезалоговыйЭтап-1].ПроцентПлатежа = 0 Цикл
		ПоследнийНезалоговыйЭтап = ПоследнийНезалоговыйЭтап - 1;
	КонецЦикла;
	
	// Определим последний залоговый этап
	ПоследнийЗалоговыйЭтап = КоличествоЭтапов;
	Пока ПоследнийЗалоговыйЭтап <> 0 И ШаблонГрафика[ПоследнийЗалоговыйЭтап-1].ПроцентЗалогаЗаТару = 0 Цикл
		ПоследнийЗалоговыйЭтап = ПоследнийЗалоговыйЭтап - 1;
	КонецЦикла;
	
	// Заполним этапы в соответствии с графиком оплаты	
	Объект.ЭтапыГрафикаОплаты.Очистить();
	Для Каждого Этап Из ШаблонГрафика Цикл
		
		ТекущийЭтап                     = ТекущийЭтап + 1;
		ЭтапГрафикаОплаты               = ЭтапыГрафикаОплаты.Добавить();
		ЭтапГрафикаОплаты.ВариантОплаты = Этап.ВариантОплаты;
		
		Если УчитыватьКалендарь Тогда
			ДатаПлатежа = МассивДатПоКалендарю[ТекущийЭтап-1];
		Иначе
			ДатаПлатежа = ?(ЭтапГрафикаОплаты.ВариантОплаты = Перечисления.ВариантыОплатыПоставщику.КредитПослеПоступления, ДатаПоступления, ДатаДокумента) + Этап.Сдвиг * ОдинДень;
		КонецЕсли;
		
		Если (ЭтапГрафикаОплаты.ВариантОплаты = Перечисления.ВариантыОплатыПоставщику.АвансДоПодтверждения
			Или ЭтапГрафикаОплаты.ВариантОплаты = Перечисления.ВариантыОплатыПоставщику.ПредоплатаДоПоступления)
			И ЗначениеЗаполнено(ЖелаемаяДатаПоступления)
			И ДатаПлатежа > ЖелаемаяДатаПоступления Тогда
			ДатаПлатежа = ЖелаемаяДатаПоступления;
		КонецЕсли;
		
		ЭтапГрафикаОплаты.ДатаПлатежа         = ДатаПлатежа;
		СуммаЭтапаОплаты                      = Окр(СуммаОплатыКРаспределению * Этап.ПроцентПлатежа / 100, 2, РежимОкругления.Окр15как20);
		ЭтапГрафикаОплаты.СуммаПлатежа        = ?(ТекущийЭтап = ПоследнийНезалоговыйЭтап, СуммаОплатыКРаспределению - РаспределеннаяСуммаОплаты, СуммаЭтапаОплаты);
		ЭтапГрафикаОплаты.ПроцентПлатежа      = ?(СуммаЭтапаОплаты <> 0, Этап.ПроцентПлатежа, 0);
		РаспределеннаяСуммаОплаты             = РаспределеннаяСуммаОплаты + ЭтапГрафикаОплаты.СуммаПлатежа;
		СуммаЭтапаЗалога                      = Окр(СуммаЗалогаКРаспределению * Этап.ПроцентЗалогаЗаТару / 100, 2, РежимОкругления.Окр15как20);
		ЭтапГрафикаОплаты.СуммаЗалогаЗаТару   = ?(ТекущийЭтап = ПоследнийЗалоговыйЭтап, СуммаЗалогаКРаспределению - РаспределеннаяСуммаЗалога, СуммаЭтапаЗалога);
		ЭтапГрафикаОплаты.ПроцентЗалогаЗаТару = ?(Этап.ПроцентЗалогаЗаТару > 0,Этап.ПроцентЗалогаЗаТару, 
			?(СуммаЗалогаКРаспределению<>0 И ЭтапГрафикаОплаты.СуммаЗалогаЗаТару <> 0,
			(Окр(ЭтапГрафикаОплаты.СуммаЗалогаЗаТару/СуммаЗалогаКРаспределению,2,РежимОкругления.Окр15как20))*100,
			0));
		РаспределеннаяСуммаЗалога             = РаспределеннаяСуммаЗалога + ЭтапГрафикаОплаты.СуммаЗалогаЗаТару;
		
	КонецЦикла;
	
	Объект.ЭтапыГрафикаОплаты.Загрузить(ЭтапыГрафикаОплаты);

КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти
