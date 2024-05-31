////////////////////////////////////////////////////////////////////////////////
// Подсистема "Префиксация объектов".
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Экспортные служебные процедуры и функции.

// Возвращает признак изменения организации или даты объекта.
//
// Параметры:
//  Ссылка - ссылка на объект ИБ.
//  ДатаПослеИзменения - дата объекта после изменения.
//  ОрганизацияПослеИзменения - организация объекта после изменения.
// 
//  Возвращаемое значение:
//   Истина - организация объекта была изменена или новая дата объекта
//            задана в другом интервале периодичности по сравнению с предыдущим значением даты.
//   Ложь - организация и дата документа не были изменены.
//
Функция ДатаИлиОрганизацияОбъектаИзменена(Ссылка, Знач ДатаПослеИзменения, Знач ОрганизацияПослеИзменения) Экспорт
	
	ПолноеИмяТаблицы = Ссылка.Метаданные().ПолноеИмя();
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	ШапкаОбъекта.Дата                                КАК Дата,
	|	ЕСТЬNULL(ШапкаОбъекта.[ИмяРеквизитаОрганизация].Префикс, """") КАК ПрефиксОрганизацииДоИзменения
	|ИЗ
	|	" + ПолноеИмяТаблицы + " КАК ШапкаОбъекта
	|ГДЕ
	|	ШапкаОбъекта.Ссылка = &Ссылка
	|";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "[ИмяРеквизитаОрганизация]", ПрефиксацияОбъектовСобытия.ИмяРеквизитаОрганизация(ПолноеИмяТаблицы));
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	УстановитьПривилегированныйРежим(Истина);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	ПрефиксОрганизацииПослеИзменения = Неопределено;
	ПерепрефиксацияОбъектов.ПриОпределенииПрефиксаОрганизации(ОрганизацияПослеИзменения, ПрефиксОрганизацииПослеИзменения);
	
	// Если задана пустая ссылка на организацию.
	ПрефиксОрганизацииПослеИзменения = ?(ПрефиксОрганизацииПослеИзменения = Ложь, "", ПрефиксОрганизацииПослеИзменения);
	
	Возврат Выборка.ПрефиксОрганизацииДоИзменения <> ПрефиксОрганизацииПослеИзменения
		ИЛИ Не ДатыОбъектаОдногоПериода(Выборка.Дата, ДатаПослеИзменения, Ссылка);
	//
КонецФункции

// Возвращает признак изменения организации объекта.
//
// Параметры:
//  Ссылка - ссылка на объект ИБ.
//  ОрганизацияПослеИзменения - организация объекта после изменения.
//
//  Возвращаемое значение:
//   Истина - организация объекта была изменена. Ложь - организация не была изменена.
//
Функция ОрганизацияОбъектаИзменена(Ссылка, Знач ОрганизацияПослеИзменения) Экспорт
	
	ПолноеИмяТаблицы = Ссылка.Метаданные().ПолноеИмя();
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	ЕСТЬNULL(ШапкаОбъекта.[ИмяРеквизитаОрганизация].Префикс, """") КАК ПрефиксОрганизацииДоИзменения
	|ИЗ
	|	" + ПолноеИмяТаблицы + " КАК ШапкаОбъекта
	|ГДЕ
	|	ШапкаОбъекта.Ссылка = &Ссылка
	|";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "[ИмяРеквизитаОрганизация]", ПрефиксацияОбъектовСобытия.ИмяРеквизитаОрганизация(ПолноеИмяТаблицы));
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	УстановитьПривилегированныйРежим(Истина);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	ПрефиксОрганизацииПослеИзменения = Неопределено;
	ПерепрефиксацияОбъектов.ПриОпределенииПрефиксаОрганизации(ОрганизацияПослеИзменения, ПрефиксОрганизацииПослеИзменения);
	
	// Если задана пустая ссылка на организацию.
	ПрефиксОрганизацииПослеИзменения = ?(ПрефиксОрганизацииПослеИзменения = Ложь, "", ПрефиксОрганизацииПослеИзменения);
	
	Возврат Выборка.ПрефиксОрганизацииДоИзменения <> ПрефиксОрганизацииПослеИзменения;
	
КонецФункции

// Определяет признак равенства двух дат для объекта метаданных.
// Даты считаются равными, если они принадлежат одному периоду времени: Год, Месяц, День и пр.
//
// Параметры:
// Дата1 - первая дата для сравнения;
// Дата2 - вторая дата для сравнения;
// МетаданныеОбъекта - метаданные объекта, для которого необходимо получить значение функции.
// 
//  Возвращаемое значение:
//   Истина - даты объекта одного периода; Ложь - даты объекта разных периодов.
//
Функция ДатыОбъектаОдногоПериода(Знач Дата1, Знач Дата2, Ссылка) Экспорт
	
	МетаданныеОбъекта = Ссылка.Метаданные();
	
	Если ПериодичностьНомераДокументаГод(МетаданныеОбъекта) Тогда
		
		РазностьДат = НачалоГода(Дата1) - НачалоГода(Дата2);
		
	ИначеЕсли ПериодичностьНомераДокументаКвартал(МетаданныеОбъекта) Тогда
		
		РазностьДат = НачалоКвартала(Дата1) - НачалоКвартала(Дата2);
		
	ИначеЕсли ПериодичностьНомераДокументаМесяц(МетаданныеОбъекта) Тогда
		
		РазностьДат = НачалоМесяца(Дата1) - НачалоМесяца(Дата2);
		
	ИначеЕсли ПериодичностьНомераДокументаДень(МетаданныеОбъекта) Тогда
		
		РазностьДат = НачалоДня(Дата1) - НачалоДня(Дата2);
		
	Иначе // ПериодичностьНомераДокументаНеопределено
		
		РазностьДат = 0;
		
	КонецЕсли;
	
	Возврат РазностьДат = 0;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Локальные служебные процедуры и функции.

Функция ПериодичностьНомераДокументаГод(МетаданныеОбъекта)
	
	Возврат МетаданныеОбъекта.ПериодичностьНомера = Метаданные.СвойстваОбъектов.ПериодичностьНомераДокумента.Год;
	
КонецФункции

Функция ПериодичностьНомераДокументаКвартал(МетаданныеОбъекта)
	
	Возврат МетаданныеОбъекта.ПериодичностьНомера = Метаданные.СвойстваОбъектов.ПериодичностьНомераДокумента.Квартал;
	
КонецФункции

Функция ПериодичностьНомераДокументаМесяц(МетаданныеОбъекта)
	
	Возврат МетаданныеОбъекта.ПериодичностьНомера = Метаданные.СвойстваОбъектов.ПериодичностьНомераДокумента.Месяц;
	
КонецФункции

Функция ПериодичностьНомераДокументаДень(МетаданныеОбъекта)
	
	Возврат МетаданныеОбъекта.ПериодичностьНомера = Метаданные.СвойстваОбъектов.ПериодичностьНомераДокумента.День;
	
КонецФункции

#КонецОбласти
