#Область ПрограммныйИнтерфейс

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

// Функция возвращает структуру с данными драйвера оборудования
// (со значениями реквизитов элемента справочника).
//
Функция ПолучитьДанныеДрайвера(Идентификатор) Экспорт

	ДанныеДрайвера = Новый Структура();

	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	СпрДрайверыОборудования.Ссылка,
	|	СпрДрайверыОборудования.ИмяПредопределенныхДанных КАК Имя,
	|	СпрДрайверыОборудования.ТипОборудования КАК ТипОборудования,
	|	СпрДрайверыОборудования.Предопределенный КАК ВСоставеКонфигурации,
	|	СпрДрайверыОборудования.ИдентификаторОбъекта КАК ИдентификаторОбъекта, 
	|	СпрДрайверыОборудования.ОбработчикДрайвера КАК ОбработчикДрайвера,
	|	СпрДрайверыОборудования.ПоставляетсяДистрибутивом КАК ПоставляетсяДистрибутивом, 
	|	СпрДрайверыОборудования.ЗагруженныйДрайвер КАК ЗагруженныйДрайвер,  
	|	СпрДрайверыОборудования.ИмяФайлаДрайвера  КАК ИмяФайлаДрайвера,  
	|	СпрДрайверыОборудования.ИмяМакетаДрайвера КАК ИмяМакетаДрайвера,
	|	СпрДрайверыОборудования.ВерсияДрайвера    КАК ВерсияДрайвера
	|ИЗ
	|	Справочник.ДрайверыОборудования КАК СпрДрайверыОборудования
	|ГДЕ
	|	 СпрДрайверыОборудования.Ссылка = &Идентификатор");
	
	Запрос.УстановитьПараметр("Идентификатор", Идентификатор);
	
	Выборка = Запрос.Выполнить().Выбрать();
	                                                           
	Если Выборка.Следующий() Тогда
		// Заполним структуру данных устройства.
		ДанныеДрайвера.Вставить("ДрайверОборудования"       , Выборка.Ссылка);
		ДанныеДрайвера.Вставить("ДрайверОборудованияИмя"    , Выборка.Имя);
		ДанныеДрайвера.Вставить("ТипОборудования"           , Выборка.ТипОборудования);
		ДанныеДрайвера.Вставить("ВСоставеКонфигурации"      , Выборка.ВСоставеКонфигурации);
		ДанныеДрайвера.Вставить("ИдентификаторОбъекта"      , Выборка.ИдентификаторОбъекта);
		ДанныеДрайвера.Вставить("ОбработчикДрайвера"        , Выборка.ОбработчикДрайвера);
		ДанныеДрайвера.Вставить("ПоставляетсяДистрибутивом" , Выборка.ПоставляетсяДистрибутивом);
		ДанныеДрайвера.Вставить("ИмяМакетаДрайвера"         , Выборка.ИмяМакетаДрайвера);
		ДанныеДрайвера.Вставить("ИмяФайлаДрайвера"          , Выборка.ИмяФайлаДрайвера);
		ДанныеДрайвера.Вставить("ВерсияДрайвера"            , Выборка.ВерсияДрайвера);
	КонецЕсли;
	
	Возврат ДанныеДрайвера;
	
	
КонецФункции

Процедура ЗаполнитьПредопределенныйЭлемент(ОбработчикДрайвера, ИдентификаторОбъекта = Неопределено, ИмяМакетаДрайвера = Неопределено, 
	ПоставляетсяДистрибутивом = Ложь, ВерсияДрайвера = Неопределено, СнятСПоддержки = Ложь) Экспорт
	
	Параметры = МенеджерОборудованияВызовСервера.ПолучитьПараметрыДрайвераПоОбработчику(Строка(ОбработчикДрайвера));
	
	ВремИмяЭлемента = СтрЗаменить(Параметры.Имя, "Обработчик", "Драйвер");
	
	Попытка
		Драйвер = МенеджерОборудованияВызовСервера.ПредопределенныйЭлемент("Справочник.ДрайверыОборудования." + ВремИмяЭлемента);
	Исключение
		Сообщение = НСтр("ru='Предопределенный элемент ""%Параметр%"" не найден.';uk='Напередвизначений елемент ""%Параметр%"" не знайдено.'");
		Сообщение = СтрЗаменить(Сообщение, "%Параметр%", "Справочник.ДрайверыОборудования." + ВремИмяЭлемента);
		ВызватьИсключение Сообщение;
	КонецПопытки;
		
	Если Драйвер = Неопределено Тогда  
		Драйвер = Справочники.ДрайверыОборудования.СоздатьЭлемент();
		Драйвер.ИмяПредопределенныхДанных = ВремИмяЭлемента;     
		Драйвер.ТипОборудования           = Параметры.ТипОборудования;
		Драйвер.ОбработчикДрайвера        = ОбработчикДрайвера;
	Иначе 
		Драйвер = Драйвер.ПолучитьОбъект();
	КонецЕсли;
	
	Драйвер.Наименование              = Параметры.Наименование;
	Драйвер.ИдентификаторОбъекта      = ИдентификаторОбъекта;
	Драйвер.ИмяМакетаДрайвера         = ИмяМакетаДрайвера; 
	Драйвер.ПоставляетсяДистрибутивом = ПоставляетсяДистрибутивом;
	Драйвер.ВерсияДрайвера            = ВерсияДрайвера;
	Драйвер.СнятСПоддержки            = СнятСПоддержки;
	Драйвер.Записать();
	
КонецПроцедуры

Процедура СнятьСПоддержкиУстаревшееОборудование(ИмяПредопределенного) 
	
	ПолноеИмяОбъектаМетаданных = "СПРАВОЧНИК.ДРАЙВЕРЫОБОРУДОВАНИЯ";
	
	ПредопределенныеЗначения = СтандартныеПодсистемыПовтИсп.СсылкиПоИменамПредопределенных(ПолноеИмяОбъектаМетаданных);
		
	// Получение результата из кэша.
	ПредопределенноеЗначение = ПредопределенныеЗначения.Получить(ИмяПредопределенного);

	Если НЕ ((ПредопределенноеЗначение = Неопределено) 
				ИЛИ (ПредопределенноеЗначение = Null))  Тогда

		СправочникОбъект = Справочники.ДрайверыОборудования.ДрайверПриватбанкЭквайринговыеТерминалы.ПолучитьОбъект();
	
		НужноЗаписать = Ложь;
	
		Если НЕ СправочникОбъект.СнятСПоддержки Тогда
			СправочникОбъект.СнятСПоддержки = Истина;
			НужноЗаписать = Истина;
		КонецЕсли;
		
		Если НужноЗаписать Тогда
			СправочникОбъект.Записать();
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры

Процедура СнятьСПоддержкиДрайверПриватбанкЭквайринговыеТерминалы() Экспорт
	СнятьСПоддержкиУстаревшееОборудование("ДрайверПриватбанкЭквайринговыеТерминалы");
КонецПроцедуры 

Процедура АктуализироватьОборудование_3_2_29() Экспорт

	СписокНеактуальногоОборудования = Новый СписокЗначений;
	
	СписокНеактуальногоОборудования.Добавить("Драйвер1СWebСервисОборудование");
	СписокНеактуальногоОборудования.Добавить("ДрайверACOMВесыСПечатьюЭтикеток");
	СписокНеактуальногоОборудования.Добавить("ДрайверCASВесыСПечатьюЭтикеток");
	СписокНеактуальногоОборудования.Добавить("ДрайверCASЭлектронныеВесы");
	СписокНеактуальногоОборудования.Добавить("ДрайверScaleCASВесыСПечатьюЭтикеток");
	СписокНеактуальногоОборудования.Добавить("ДрайверАтолДисплеиПокупателя");
	СписокНеактуальногоОборудования.Добавить("ДрайверАтолСканерыШтрихкода");
	СписокНеактуальногоОборудования.Добавить("ДрайверАтолСчитывателиМагнитныхКарт");
	СписокНеактуальногоОборудования.Добавить("ДрайверАтолТерминалыСбораДанных");
	СписокНеактуальногоОборудования.Добавить("ДрайверАтолТерминалыСбораДанныхMobileLogistics");
	СписокНеактуальногоОборудования.Добавить("ДрайверАтолЭлектронныеВесы");
	СписокНеактуальногоОборудования.Добавить("ДрайверАтолЭлектронныеВесы8X");
	СписокНеактуальногоОборудования.Добавить("ДрайверГексагонПринтераЭтикеток");
	СписокНеактуальногоОборудования.Добавить("ДрайверГексагонСканерыШтрихкода");
	СписокНеактуальногоОборудования.Добавить("ДрайверГексагонТерминалыСбораДанных");
	СписокНеактуальногоОборудования.Добавить("ДрайверККСДисплеиПокупателя");
	СписокНеактуальногоОборудования.Добавить("ДрайверКлеверенсТерминалыСбораДанных");
	СписокНеактуальногоОборудования.Добавить("ДрайверКристаллСервисДисплеиПокупателяVikiVision");
	СписокНеактуальногоОборудования.Добавить("ДрайверСканкодДисплеиПокупателя");
	СписокНеактуальногоОборудования.Добавить("ДрайверСканкодСканерыШтрихкода");
	СписокНеактуальногоОборудования.Добавить("ДрайверСканкодТерминалыСбораДанных");
	СписокНеактуальногоОборудования.Добавить("ДрайверСканкодТерминалыСбораДанныхNative");
	СписокНеактуальногоОборудования.Добавить("ДрайверСканситиПринтераЭтикеток");
	СписокНеактуальногоОборудования.Добавить("ДрайверСканситиТерминалыСбораДанных");
	СписокНеактуальногоОборудования.Добавить("ДрайверШтрихМВесыСПечатьюЭтикеток");
	СписокНеактуальногоОборудования.Добавить("ДрайверШтрихМДисплеиПокупателя");
	СписокНеактуальногоОборудования.Добавить("ДрайверШтрихМТерминалыСбораДанных");
	СписокНеактуальногоОборудования.Добавить("ДрайверШтрихМЭлектронныеВесы");
                   
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ДрайверыОборудования.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.ДрайверыОборудования КАК ДрайверыОборудования
		|ГДЕ
		|	ДрайверыОборудования.ИмяПредопределенныхДанных В(&ИмяПредопределенныхДанных)";
	
	Запрос.УстановитьПараметр("ИмяПредопределенныхДанных", СписокНеактуальногоОборудования);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		СправочникОбъект = ВыборкаДетальныеЗаписи.Ссылка.ПолучитьОбъект();
		СправочникОбъект.СнятСПоддержки = Истина;
		СправочникОбъект.ИмяПредопределенныхДанных = ""; 
		СправочникОбъект.ПометкаУдаления = Истина; 
		СправочникОбъект.Записать();
		
	КонецЦикла;

КонецПроцедуры

#КонецЕсли

#КонецОбласти