#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Функция читает данные производственного календаря из регистра.
//
// Параметры:
//	ПроизводственныйКалендарь			- Ссылка на текущий элемент справочника.
//	НомерГода							- Номер года, за который необходимо прочитать производственный календарь.
//
// Возвращаемое значение
//	ДанныеПроизводственногоКалендаря	- таблица значений, в которой хранятся сведения о виде дня на каждую дату календаря.
//
Функция ДанныеПроизводственногоКалендаря(ПроизводственныйКалендарь, НомерГода) Экспорт
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("ПроизводственныйКалендарь",	ПроизводственныйКалендарь);
	Запрос.УстановитьПараметр("ТекущийГод",	НомерГода);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДанныеПроизводственногоКалендаря.Дата,
	|	ДанныеПроизводственногоКалендаря.ВидДня,
	|	ДанныеПроизводственногоКалендаря.ДатаПереноса
	|ИЗ
	|	РегистрСведений.ДанныеПроизводственногоКалендаря КАК ДанныеПроизводственногоКалендаря
	|ГДЕ
	|	ДанныеПроизводственногоКалендаря.Год = &ТекущийГод
	|	И ДанныеПроизводственногоКалендаря.ПроизводственныйКалендарь = &ПроизводственныйКалендарь";
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

// Функция подготавливает результат заполнения производственного календаря 
//  данными по умолчанию.
// При наличии в конфигурации макета с предопределенными данными 
//  производственного календаря на этот год, используются данные макета,
//  в противном случае данные производственного календаря формируются на основе 
//  сведений о праздниках, а также с учетом действующих правил переноса выходных дней.
//
Функция РезультатЗаполненияПроизводственногоКалендаряПоУмолчанию(КодПроизводственногоКалендаря, НомерГода) Экспорт
	
	ДлинаСуток = 24 * 3600;
	
	ДанныеПроизводственногоКалендаря = Новый ТаблицаЗначений;
	ДанныеПроизводственногоКалендаря.Колонки.Добавить("Дата", Новый ОписаниеТипов("Дата"));
	ДанныеПроизводственногоКалендаря.Колонки.Добавить("ВидДня", Новый ОписаниеТипов("ПеречислениеСсылка.ВидыДнейПроизводственногоКалендаря"));
	ДанныеПроизводственногоКалендаря.Колонки.Добавить("ДатаПереноса", Новый ОписаниеТипов("Дата"));
	
	// Если есть данные в макете - используем их.
	ПредопределенныеДанные = ДанныеПроизводственныхКалендарейИзМакета().НайтиСтроки(
								Новый Структура("КодПроизводственногоКалендаря, Год", КодПроизводственногоКалендаря, НомерГода));
	Если ПредопределенныеДанные.Количество() > 0 Тогда
		ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(ПредопределенныеДанные, ДанныеПроизводственногоКалендаря);
		Возврат ДанныеПроизводственногоКалендаря;
	КонецЕсли;
	
	// Если нет - заполняем праздники и переносы.
	ПраздничныеДни = ПраздничныеДниПроизводственногоКалендаря(КодПроизводственногоКалендаря, НомерГода);
	// Дополним таблицу также праздниками следующего года, 
	// т.к. они влияют на заполнение текущего года (31 декабря - предпраздничный, например).
	ПраздничныеДниСледующегоГода = ПраздничныеДниПроизводственногоКалендаря(КодПроизводственногоКалендаря, НомерГода + 1);
	ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(ПраздничныеДниСледующегоГода, ПраздничныеДни);
	
	ВидыДней = Новый Соответствие;
	
	ДатаДня = Дата(НомерГода, 1, 1);
	Пока ДатаДня <= Дата(НомерГода, 12, 31) Цикл
		// "Непраздничный" день - определяем в соответствии с днем недели.
		НомерДняНедели = ДеньНедели(ДатаДня);
		Если НомерДняНедели <= 5 Тогда
			ВидыДней.Вставить(ДатаДня, Перечисления.ВидыДнейПроизводственногоКалендаря.Рабочий);
		ИначеЕсли НомерДняНедели = 6 Тогда
			ВидыДней.Вставить(ДатаДня, Перечисления.ВидыДнейПроизводственногоКалендаря.Суббота);
		ИначеЕсли НомерДняНедели = 7 Тогда
			ВидыДней.Вставить(ДатаДня, Перечисления.ВидыДнейПроизводственногоКалендаря.Воскресенье);
		КонецЕсли;
		ДатаДня = ДатаДня + ДлинаСуток;
	КонецЦикла;
	
	// При совпадении выходного и нерабочего праздничного дней 
	// выходной день переносится на следующий после праздничного рабочий день 
	
	ПереносыДней = Новый Соответствие;
	Для Каждого СтрокаТаблицы Из ПраздничныеДни Цикл
		ПраздничныйДень = СтрокаТаблицы.Дата;
		// Отметим как предпраздничный день, 
		// рабочий день непосредственно предшествующий праздничному дню.
		ДатаПредпраздничногоДня = ПраздничныйДень - ДлинаСуток;
		Если Год(ДатаПредпраздничногоДня) = НомерГода Тогда
			Если ВидыДней[ДатаПредпраздничногоДня] = Перечисления.ВидыДнейПроизводственногоКалендаря.Рабочий 
				И ПраздничныеДни.Найти(ДатаПредпраздничногоДня, "Дата") = Неопределено Тогда
				ВидыДней.Вставить(ДатаПредпраздничногоДня, Перечисления.ВидыДнейПроизводственногоКалендаря.Предпраздничный);
			КонецЕсли;
		КонецЕсли;
		Если Год(ПраздничныйДень) <> НомерГода Тогда
			// Праздничные дни другого года далее также пропускаем.
			Продолжить;
		КонецЕсли;
		Если ВидыДней[ПраздничныйДень] <> Перечисления.ВидыДнейПроизводственногоКалендаря.Рабочий 
			И СтрокаТаблицы.ПереноситьВыходной Тогда
			// Если праздничный день выпадает на выходной, 
			// и выходной, на который выпадает этот праздник, переносится - 
			// переносим выходной на ближайший рабочий день.
			ДатаДня = ПраздничныйДень;
			Пока Истина Цикл
				ДатаДня = ДатаДня + ДлинаСуток;
				Если ВидыДней[ДатаДня] = Перечисления.ВидыДнейПроизводственногоКалендаря.Рабочий 
					И ПраздничныеДни.Найти(ДатаДня, "Дата") = Неопределено Тогда
					ВидыДней.Вставить(ДатаДня, ВидыДней[ПраздничныйДень]);
					ПереносыДней.Вставить(ДатаДня, ПраздничныйДень);
					ПереносыДней.Вставить(ПраздничныйДень, ДатаДня);
					Прервать;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		ВидыДней.Вставить(ПраздничныйДень, Перечисления.ВидыДнейПроизводственногоКалендаря.Праздник);
	КонецЦикла;
	
	Для Каждого КлючИЗначение Из ВидыДней Цикл
		НоваяСтрока = ДанныеПроизводственногоКалендаря.Добавить();
		НоваяСтрока.Дата = КлючИЗначение.Ключ;
		НоваяСтрока.ВидДня = КлючИЗначение.Значение;
		ДатаПереноса = ПереносыДней[НоваяСтрока.Дата];
		Если ДатаПереноса <> Неопределено Тогда
			НоваяСтрока.ДатаПереноса = ДатаПереноса;
		КонецЕсли;
	КонецЦикла;
	
	ДанныеПроизводственногоКалендаря.Сортировать("Дата");
	
	Возврат ДанныеПроизводственногоКалендаря;
	
КонецФункции

// Функция преобразовывает данные производственных календарей, 
//  поставляемые в виде макета в конфигурации.
//
// Параметры:
//	- нет
//
// Возвращаемое значение - таблица значений с колонками.
//	Подробнее см. комментарий к функции ДанныеПроизводственныхКалендарейИзXML.
//
Функция ДанныеПроизводственныхКалендарейИзМакета() Экспорт
	
	ТекстовыйДокумент = РегистрыСведений.ДанныеПроизводственногоКалендаря.ПолучитьМакет("ДанныеПроизводственныхКалендарей");
	
	Возврат ДанныеПроизводственныхКалендарейИзXML(ТекстовыйДокумент.ПолучитьТекст());
	
КонецФункции

// Функция преобразовывает данные производственных календарей, 
//  представленные в виде XML.
//
// Параметры:
//	- XML - документ с данными
//
// Возвращаемое значение - таблица значений с колонками:
//	- КодПроизводственногоКалендаря
//	- ВидДня
//	- Год
//	- Дата
//	- ДатаПереноса.
//
Функция ДанныеПроизводственныхКалендарейИзXML(Знач XML) Экспорт
	
	ТаблицаДанных = Новый ТаблицаЗначений;
	ТаблицаДанных.Колонки.Добавить("КодПроизводственногоКалендаря", Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(2)));
	ТаблицаДанных.Колонки.Добавить("ВидДня", Новый ОписаниеТипов("ПеречислениеСсылка.ВидыДнейПроизводственногоКалендаря"));
	ТаблицаДанных.Колонки.Добавить("Год", Новый ОписаниеТипов("Число"));
	ТаблицаДанных.Колонки.Добавить("Дата", Новый ОписаниеТипов("Дата"));
	ТаблицаДанных.Колонки.Добавить("ДатаПереноса", Новый ОписаниеТипов("Дата"));
	
	КлассификаторТаблица = ОбщегоНазначения.ПрочитатьXMLВТаблицу(XML).Данные;
	
	Для Каждого СтрокаКлассификатора Из КлассификаторТаблица Цикл
		НоваяСтрока = ТаблицаДанных.Добавить();
		НоваяСтрока.КодПроизводственногоКалендаря = СтрокаКлассификатора.Calendar;
		НоваяСтрока.ВидДня	= Перечисления.ВидыДнейПроизводственногоКалендаря[СтрокаКлассификатора.DayType];
		НоваяСтрока.Год		= Число(СтрокаКлассификатора.Year);
		НоваяСтрока.Дата	= Дата(СтрокаКлассификатора.Date);
		Если ЗначениеЗаполнено(СтрокаКлассификатора.SwapDate) Тогда
			НоваяСтрока.ДатаПереноса = Дата(СтрокаКлассификатора.SwapDate);
		КонецЕсли;
	КонецЦикла;
	
	Возврат ТаблицаДанных;
	
КонецФункции

// Обновляет справочник Производственные календари из XML файла.
//
// Параметры:
//	- ТаблицаКалендарей - таблица значений с описанием производственных календарей.
//
Процедура ОбновитьПроизводственныеКалендари(ТаблицаКалендарей) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВЫРАЗИТЬ(КлассификаторТаблица.Code КАК СТРОКА(2)) КАК Код,
	|	ВЫРАЗИТЬ(КлассификаторТаблица.Description КАК СТРОКА(100)) КАК Наименование
	|ПОМЕСТИТЬ КлассификаторТаблица
	|ИЗ
	|	&КлассификаторТаблица КАК КлассификаторТаблица
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КлассификаторТаблица.Код,
	|	КлассификаторТаблица.Наименование,
	|	ПроизводственныеКалендари.Ссылка КАК Ссылка,
	|	ЕСТЬNULL(ПроизводственныеКалендари.Код, """") КАК ПроизводственныйКалендарьКод,
	|	ЕСТЬNULL(ПроизводственныеКалендари.Наименование, """") КАК ПроизводственныйКалендарьНаименование
	|ИЗ
	|	КлассификаторТаблица КАК КлассификаторТаблица
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПроизводственныеКалендари КАК ПроизводственныеКалендари
	|		ПО КлассификаторТаблица.Код = ПроизводственныеКалендари.Код";
	
	Запрос.УстановитьПараметр("КлассификаторТаблица", ТаблицаКалендарей);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Если СокрЛП(Выборка.Код) = СокрЛП(Выборка.ПроизводственныйКалендарьКод)
			И Выборка.Наименование = Выборка.ПроизводственныйКалендарьНаименование Тогда
			Продолжить;
		КонецЕсли;
		Если ЗначениеЗаполнено(Выборка.Ссылка) Тогда
			СправочникОбъект = Выборка.Ссылка.ПолучитьОбъект();
		Иначе
			СправочникОбъект = Справочники.ПроизводственныеКалендари.СоздатьЭлемент();
		КонецЕсли;
		СправочникОбъект.Код = СокрЛП(Выборка.Код);
		СправочникОбъект.Наименование = СокрЛП(Выборка.Наименование);
		СправочникОбъект.Записать();
	КонецЦикла;
	
КонецПроцедуры

// Обновляет данные производственных календарей по таблице данных.
//
Процедура ОбновитьДанныеПроизводственныхКалендарей(ТаблицаДанных) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	КлассификаторТаблица.КодПроизводственногоКалендаря КАК КалендарьКод,
		|	КлассификаторТаблица.Дата,
		|	КлассификаторТаблица.Год,
		|	КлассификаторТаблица.ВидДня,
		|	КлассификаторТаблица.ДатаПереноса
		|ПОМЕСТИТЬ КлассификаторТаблица
		|ИЗ
		|	&КлассификаторТаблица КАК КлассификаторТаблица
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ПроизводственныеКалендари.Ссылка КАК ПроизводственныйКалендарь,
		|	КлассификаторТаблица.Год,
		|	КлассификаторТаблица.Дата,
		|	КлассификаторТаблица.ВидДня,
		|	КлассификаторТаблица.ДатаПереноса
		|ИЗ
		|	КлассификаторТаблица КАК КлассификаторТаблица
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ПроизводственныеКалендари КАК ПроизводственныеКалендари
		|		ПО КлассификаторТаблица.КалендарьКод = ПроизводственныеКалендари.Код
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДанныеПроизводственногоКалендаря КАК ДанныеПроизводственногоКалендаря
		|		ПО (ПроизводственныеКалендари.Ссылка = ДанныеПроизводственногоКалендаря.ПроизводственныйКалендарь)
		|			И КлассификаторТаблица.Год = ДанныеПроизводственногоКалендаря.Год
		|			И КлассификаторТаблица.Дата = ДанныеПроизводственногоКалендаря.Дата
		|			И КлассификаторТаблица.ВидДня = ДанныеПроизводственногоКалендаря.ВидДня
		|			И КлассификаторТаблица.ДатаПереноса = ДанныеПроизводственногоКалендаря.ДатаПереноса
		|ГДЕ
		|	ДанныеПроизводственногоКалендаря.ВидДня ЕСТЬ NULL ";
	
	Запрос.УстановитьПараметр("КлассификаторТаблица", ТаблицаДанных);
	
	НаборЗаписей = РегистрыСведений.ДанныеПроизводственногоКалендаря.СоздатьНаборЗаписей();
	
	КлючиРегистра = Новый Массив;
	КлючиРегистра.Добавить("ПроизводственныйКалендарь");
	КлючиРегистра.Добавить("Год");
	КлючиРегистра.Добавить("Дата");
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		НаборЗаписей.Очистить();
		ЗаполнитьЗначенияСвойств(НаборЗаписей.Добавить(), Выборка);
		Для Каждого Ключ Из КлючиРегистра Цикл 
			НаборЗаписей.Отбор[Ключ].Установить(Выборка[Ключ]);
		КонецЦикла;
		НаборЗаписей.Записать(Истина);
	КонецЦикла;
	
	ТаблицаДанных.Свернуть("КодПроизводственногоКалендаря, Год");
	РаспространитьИзмененияДанныхПроизводственныхКалендарей(ТаблицаДанных);
	
КонецПроцедуры

// Процедура записывает данные одного производственного календаря за 1 год.
//
// Параметры:
//	ПроизводственныйКалендарь			- Ссылка на текущий элемент справочника.
//	НомерГода							- Номер года, за который необходимо записать производственный календарь.
//	ДанныеПроизводственногоКалендаря	- таблица значений, в которой хранятся сведения о виде дня на каждую дату календаря.
//
// Возвращаемое значение
//	Нет
//
Процедура ЗаписатьДанныеПроизводственногоКалендаря(ПроизводственныйКалендарь, НомерГода, ДанныеПроизводственногоКалендаря) Экспорт
	
	НаборЗаписей = РегистрыСведений.ДанныеПроизводственногоКалендаря.СоздатьНаборЗаписей();
	
	Для Каждого КлючИЗначение Из ДанныеПроизводственногоКалендаря Цикл
		ЗаполнитьЗначенияСвойств(НаборЗаписей.Добавить(), КлючИЗначение);
	КонецЦикла;
	
	ЗначенияОтбора = Новый Структура("ПроизводственныйКалендарь, Год", ПроизводственныйКалендарь, НомерГода);
	
	Для Каждого КлючИЗначение Из ЗначенияОтбора Цикл
		НаборЗаписей.Отбор[КлючИЗначение.Ключ].Установить(КлючИЗначение.Значение);
	КонецЦикла;
	
	Для Каждого СтрокаНабора Из НаборЗаписей Цикл
		ЗаполнитьЗначенияСвойств(СтрокаНабора, ЗначенияОтбора);
	КонецЦикла;
	
	НаборЗаписей.Записать(Истина);
	
	УсловияОбновления = УсловийОбновленияГрафиковРаботы(ПроизводственныйКалендарь, НомерГода);
	РаспространитьИзмененияДанныхПроизводственныхКалендарей(УсловияОбновления);
	
КонецПроцедуры

// Предназначена для обновления связанных с производственным календарем элементов, 
// например, Графиков работы.
//
// Параметры:
//	ТаблицаИзменений - таблица с колонками.
//		- КодПроизводственногоКалендаря - код производственного календаря, данные которого изменились,
//		- Год - год, за который нужно обновить данные.
//
Процедура РаспространитьИзмененияДанныхПроизводственныхКалендарей(ТаблицаИзменений) Экспорт
	
	// Обновляем данные графиков работы, 
	// заполняемых автоматически на основании производственного календаря.
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ГрафикиРаботы") Тогда
		МодульГрафикиРаботы = ОбщегоНазначения.ОбщийМодуль("ГрафикиРаботы");
		Если ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
			МодульГрафикиРаботы.ЗапланироватьОбновлениеГрафиковРаботы(ТаблицаИзменений);
		Иначе
			МодульГрафикиРаботы.ОбновитьГрафикиРаботыПоДаннымПроизводственныхКалендарей(ТаблицаИзменений);
		КонецЕсли;
	КонецЕсли;
	
	ОбработчикиСобытия = ОбщегоНазначения.ОбработчикиСлужебногоСобытия(
		"СтандартныеПодсистемы.КалендарныеГрафики\ПриОбновленииПроизводственныхКалендарей");
	Для Каждого Обработчик Из ОбработчикиСобытия Цикл
		Обработчик.Модуль.ПриОбновленииПроизводственныхКалендарей(ТаблицаИзменений);
	КонецЦикла;
	
	КалендарныеГрафикиПереопределяемый.ПриОбновленииПроизводственныхКалендарей(ТаблицаИзменений);
	
КонецПроцедуры

// Функция определяет соответствие видов дня производственного календаря и цвета оформления
// этого дня в поле календаря.
//
// Возвращаемое значение
//	ЦветаОформления - соответствие видов дня и цветов оформления.
//
Функция ЦветаОформленияВидовДнейПроизводственногоКалендаря() Экспорт
	
	ЦветаОформления = Новый Соответствие;
	
	ЦветаОформления.Вставить(Перечисления.ВидыДнейПроизводственногоКалендаря.Рабочий,			ЦветаСтиля.ВидДняПроизводственногоКалендаряРабочийЦвет);
	ЦветаОформления.Вставить(Перечисления.ВидыДнейПроизводственногоКалендаря.Суббота,			ЦветаСтиля.ВидДняПроизводственногоКалендаряСубботаЦвет);
	ЦветаОформления.Вставить(Перечисления.ВидыДнейПроизводственногоКалендаря.Воскресенье,		ЦветаСтиля.ВидДняПроизводственногоКалендаряВоскресеньеЦвет);
	ЦветаОформления.Вставить(Перечисления.ВидыДнейПроизводственногоКалендаря.Предпраздничный,	ЦветаСтиля.ВидДняПроизводственногоКалендаряПредпраздничныйЦвет);
	ЦветаОформления.Вставить(Перечисления.ВидыДнейПроизводственногоКалендаря.Праздник,			ЦветаСтиля.ВидДняПроизводственногоКалендаряПраздникЦвет);
	
	Возврат ЦветаОформления;
	
КонецФункции

// Функция составляет список всевозможных видов дней производственного календаря 
// по метаданным перечисления ВидыДнейПроизводственногоКалендаря.
//
// Возвращаемое значение
//	СписокВидовДня - список значений, содержащий значение перечисления 
//  					и его синоним в качестве представления.
//
Функция СписокВидовДня() Экспорт
	
	СписокВидовДня = Новый СписокЗначений;
	
	Для Каждого МетаданныеВидаДней Из Метаданные.Перечисления.ВидыДнейПроизводственногоКалендаря.ЗначенияПеречисления Цикл
		СписокВидовДня.Добавить(Перечисления.ВидыДнейПроизводственногоКалендаря[МетаданныеВидаДней.Имя], МетаданныеВидаДней.Синоним);
	КонецЦикла;
	
	Возврат СписокВидовДня;
	
КонецФункции

// Функция составляет массив доступных производственных календарей
// для использования, например, в качестве шаблона.
//
Функция СписокПроизводственныхКалендарей() Экспорт

	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ПроизводственныеКалендари.Ссылка
	|ИЗ
	|	Справочник.ПроизводственныеКалендари КАК ПроизводственныеКалендари
	|ГДЕ
	|	(НЕ ПроизводственныеКалендари.ПометкаУдаления)");
		
	СписокПроизводственныхКалендарей = Новый Массив;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		СписокПроизводственныхКалендарей.Добавить(Выборка.Ссылка);
	КонецЦикла;
	
	Возврат СписокПроизводственныхКалендарей;
	
КонецФункции

// Функция выявляет последний день, за который заполнены данные 
// указанного производственного календаря.
//
// Параметры:
//	- ПроизводственныйКалендарь - тип СправочникСсылка.ПроизводственныеКалендари.
//
Функция ДатаОкончанияЗаполненияПроизводственногоКалендаря(ПроизводственныйКалендарь) Экспорт
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	МАКСИМУМ(ДанныеПроизводственногоКалендаря.Дата) КАК Дата
	|ИЗ
	|	РегистрСведений.ДанныеПроизводственногоКалендаря КАК ДанныеПроизводственногоКалендаря
	|ГДЕ
	|	ДанныеПроизводственногоКалендаря.ПроизводственныйКалендарь = &ПроизводственныйКалендарь
	|
	|ИМЕЮЩИЕ
	|	МАКСИМУМ(ДанныеПроизводственногоКалендаря.Дата) ЕСТЬ НЕ NULL ";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("ПроизводственныйКалендарь", ПроизводственныйКалендарь);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Дата;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

// Функция заполняет массив дат праздничных дней по производственному календарю 
// для конкретного календарного года.
//
Функция ПраздничныеДниПроизводственногоКалендаря(КодПроизводственногоКалендаря, НомерГода)
	
	ПраздничныеДни = Новый ТаблицаЗначений;
	ПраздничныеДни.Колонки.Добавить("Дата", Новый ОписаниеТипов("Дата"));
	ПраздничныеДни.Колонки.Добавить("ПереноситьВыходной", Новый ОписаниеТипов("Булево"));
	
	Если КодПроизводственногоКалендаря = "УК" Тогда		
		
		
		// 1 января - Новый год
		ДобавитьПраздничныйДень(ПраздничныеДни, "01.01", НомерГода);
		
		// 7 января - Рождество Христово (старый стиль)
		Если НомерГода <= 2023 Тогда
			ДобавитьПраздничныйДень(ПраздничныеДни, "07.01", НомерГода);
		КонецЕсли;	
		
		
		// 8 марта - Международный женский день.
		ДобавитьПраздничныйДень(ПраздничныеДни, "08.03", НомерГода);
		
		// 1,2 мая - День солидарности трудящихся
		ДобавитьПраздничныйДень(ПраздничныеДни, "01.05", НомерГода);
		Если НомерГода <= 2017 Тогда
			ДобавитьПраздничныйДень(ПраздничныеДни, "02.05", НомерГода);
		КонецЕсли;
		
		// 8(9) мая - День Победы
		Если НомерГода <= 2023 Тогда
			ДобавитьПраздничныйДень(ПраздничныеДни, "09.05", НомерГода);
		Иначе
			ДобавитьПраздничныйДень(ПраздничныеДни, "08.05", НомерГода);
		КонецЕсли;	
		
		
		// 28 июня - День Конституции
		ДобавитьПраздничныйДень(ПраздничныеДни, "28.06", НомерГода);
		
		// 15(28) июля - День Української Державності
		Если НомерГода >= 2024 Тогда
			ДобавитьПраздничныйДень(ПраздничныеДни, "15.07", НомерГода);
		ИначеЕсли НомерГода >= 2022 Тогда
			ДобавитьПраздничныйДень(ПраздничныеДни, "28.07", НомерГода);
        КонецЕсли;
			
		// 24 августа - День Независимости
		ДобавитьПраздничныйДень(ПраздничныеДни, "24.08", НомерГода);
		
		// 1(14) октября - День защитника Украины
		Если НомерГода >= 2023 Тогда
			ДобавитьПраздничныйДень(ПраздничныеДни, "01.10", НомерГода);
		Иначе	
			ДобавитьПраздничныйДень(ПраздничныеДни, "14.10", НомерГода);
		КонецЕсли;	
		
		// 25 декабря - Рождество (новый стиль)
		Если НомерГода >= 2017 Тогда
			ДобавитьПраздничныйДень(ПраздничныеДни, "25.12", НомерГода);
		КонецЕсли;
		
		//Переходящие религиозные праздники
		ДниПасхи = Новый Соответствие;
		ДниПасхи.Вставить(2004, "11.04");
		ДниПасхи.Вставить(2005, "01.05");
		ДниПасхи.Вставить(2006, "23.04");
		ДниПасхи.Вставить(2007, "08.04");
		ДниПасхи.Вставить(2008, "27.04");
		ДниПасхи.Вставить(2009, "20.04");
		ДниПасхи.Вставить(2010, "04.04");
		ДниПасхи.Вставить(2011, "24.04");
		ДниПасхи.Вставить(2012, "15.04");
		ДниПасхи.Вставить(2013, "05.05");
		ДниПасхи.Вставить(2014, "20.04");
		ДниПасхи.Вставить(2015, "12.04");
		ДниПасхи.Вставить(2016, "01.05");
		ДниПасхи.Вставить(2017, "16.04");
		ДниПасхи.Вставить(2018, "08.04");
		ДниПасхи.Вставить(2019, "28.04");
		ДниПасхи.Вставить(2020, "19.04");
		ДниПасхи.Вставить(2021, "02.05");
		ДниПасхи.Вставить(2022, "24.04");
		ДниПасхи.Вставить(2023, "16.04");
		ДниПасхи.Вставить(2024, "05.05");
		ДниПасхи.Вставить(2025, "20.04");
		
		ДобавитьПасхуТроицу(ПраздничныеДни, ДниПасхи[НомерГода], НомерГода);
		
	КонецЕсли;
	
	Возврат ПраздничныеДни;
	
КонецФункции

Процедура ДобавитьПраздничныйДень(ПраздничныеДни, ПраздничныйДень, НомерГода, ПереноситьВыходной = Истина)
	
	ДеньМесяц = СтрРазделить(ПраздничныйДень, ".");
	
	НоваяСтрока = ПраздничныеДни.Добавить();
	НоваяСтрока.Дата = Дата(НомерГода, ДеньМесяц[1], ДеньМесяц[0]);
	НоваяСтрока.ПереноситьВыходной = ПереноситьВыходной;
	
КонецПроцедуры

Процедура ДобавитьПасхуТроицу(ПраздничныеДни, ПраздничныйДень, НомерГода, ПереноситьВыходной = Истина)
	
	ДеньМесяц = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ПраздничныйДень, ".");
	
	Если ДеньМесяц.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Пасха = Дата(НомерГода, ДеньМесяц[1], ДеньМесяц[0]);
	Троица = Пасха + 49*86400;
	
	НоваяСтрока = ПраздничныеДни.Добавить();
	НоваяСтрока.Дата = Пасха;
	НоваяСтрока.ПереноситьВыходной = ПереноситьВыходной;
	НоваяСтрока = ПраздничныеДни.Добавить();
	НоваяСтрока.Дата = Троица;
	НоваяСтрока.ПереноситьВыходной = ПереноситьВыходной;
	
КонецПроцедуры

Функция УсловийОбновленияГрафиковРаботы(ПроизводственныйКалендарь, Год)
	
	УсловияОбновления = Новый ТаблицаЗначений;
	УсловияОбновления.Колонки.Добавить("КодПроизводственногоКалендаря", Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(3)));
	УсловияОбновления.Колонки.Добавить("Год", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(4)));
	
	НоваяСтрока = УсловияОбновления.Добавить();
	НоваяСтрока.КодПроизводственногоКалендаря = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПроизводственныйКалендарь, "Код");
	НоваяСтрока.Год = Год;

	Возврат УсловияОбновления;
	
КонецФункции

// Возвращает реквизиты справочника, которые образуют естественный ключ
//  для элементов справочника.
//
// Возвращаемое значение: Массив(Строка) - массив имен реквизитов, образующих
//  естественный ключ.
//
Функция ПоляЕстественногоКлюча() Экспорт
	
	Результат = Новый Массив();
	
	Результат.Добавить("Код");
	
	Возврат Результат;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Печатная форма производственного календаря.

// Формирует печатные формы
//
// Параметры:
//  (входные)
//    МассивОбъектов  - Массив    - ссылки на объекты, которые нужно распечатать;
//    ПараметрыПечати - Структура - дополнительные настройки печати;
//  (выходные)
//   КоллекцияПечатныхФорм - ТаблицаЗначений - сформированные табличные документы.
//   ОбъектыПечати         - СписокЗначений  - значение - ссылка на объект;
//                                             представление - имя области в которой был выведен объект;
//   ПараметрыВывода       - Структура       - дополнительные параметры сформированных табличных документов.
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Печать") Тогда
		МодульУправлениеПечатью = ОбщегоНазначения.ОбщийМодуль("УправлениеПечатью");
		МодульУправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
				КоллекцияПечатныхФорм,
				"ПроизводственныйКалендарь", НСтр("ru='Производственный календарь';uk='Виробничий календар'"),
				Справочники.ПроизводственныеКалендари.ПечатнаяФормаПроизводственногоКалендаря(ПараметрыПечати),
				,
				"Справочник.ПроизводственныеКалендари.ПФ_MXL_ПроизводственныйКалендарь");
	КонецЕсли;
	
КонецПроцедуры

Функция ПечатнаяФормаПроизводственногоКалендаря(ПараметрыПодготовкиПечатнойФормы) Экспорт
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ГОД(ДанныеКалендаря.Дата) КАК ГодКалендаря,
	|	КВАРТАЛ(ДанныеКалендаря.Дата) КАК КварталКалендаря,
	|	МЕСЯЦ(ДанныеКалендаря.Дата) КАК МесяцКалендаря,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ДанныеКалендаря.Дата) КАК КалендарныеДни,
	|	ДанныеКалендаря.ВидДня КАК ВидДня
	|ИЗ
	|	РегистрСведений.ДанныеПроизводственногоКалендаря КАК ДанныеКалендаря
	|ГДЕ
	|	ДанныеКалендаря.Год = &Год
	|	И ДанныеКалендаря.ПроизводственныйКалендарь = &ПроизводственныйКалендарь
	|
	|СГРУППИРОВАТЬ ПО
	|	ДанныеКалендаря.ВидДня,
	|	ГОД(ДанныеКалендаря.Дата),
	|	КВАРТАЛ(ДанныеКалендаря.Дата),
	|	МЕСЯЦ(ДанныеКалендаря.Дата)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ГодКалендаря,
	|	КварталКалендаря,
	|	МесяцКалендаря
	|ИТОГИ ПО
	|	ГодКалендаря,
	|	КварталКалендаря,
	|	МесяцКалендаря";
	
	ПроизводственныйКалендарь = ПараметрыПодготовкиПечатнойФормы.ПроизводственныйКалендарь;
	НомерГода = ПараметрыПодготовкиПечатнойФормы.НомерГода;
	
	Макет = Справочники.ПроизводственныеКалендари.ПолучитьМакет("ПФ_MXL_ПроизводственныйКалендарь");
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	
	ЗаголовокПечати = Макет.ПолучитьОбласть("Заголовок");
	ЗаголовокПечати.Параметры.ПроизводственныйКалендарь = ПроизводственныйКалендарь;
	ЗаголовокПечати.Параметры.Год = Формат(НомерГода, "ЧГ=");
	ТабличныйДокумент.Вывести(ЗаголовокПечати);
	
	// Начальные значения, независимо от результата выполнения запроса.
	РабочееВремя40Год = 0;
	РабочееВремя36Год = 0;
	РабочееВремя24Год = 0;
	
	ВидыНерабочихДней = Новый Массив;
	ВидыНерабочихДней.Добавить(Перечисления.ВидыДнейПроизводственногоКалендаря.Суббота);
	ВидыНерабочихДней.Добавить(Перечисления.ВидыДнейПроизводственногоКалендаря.Воскресенье);
	ВидыНерабочихДней.Добавить(Перечисления.ВидыДнейПроизводственногоКалендаря.Праздник);
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Год", НомерГода);
	Запрос.УстановитьПараметр("ПроизводственныйКалендарь", ПроизводственныйКалендарь);
	Результат = Запрос.Выполнить();
	
	ВыборкаПоГоду = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаПоГоду.Следующий() Цикл
		
		ВыборкаПоКварталу = ВыборкаПоГоду.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаПоКварталу.Следующий() Цикл
			НомерКвартала = Макет.ПолучитьОбласть("Квартал");
			НомерКвартала.Параметры.НомерКвартала = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='%1 квартал';uk='%1 квартал'"), ВыборкаПоКварталу.КварталКалендаря);
			ТабличныйДокумент.Вывести(НомерКвартала);
			
			ШапкаКвартала = Макет.ПолучитьОбласть("ШапкаКвартала");
			ТабличныйДокумент.Вывести(ШапкаКвартала);
			
			КалендарныеДниКв = 0;
			РабочееВремя40Кв = 0;
			РабочееВремя36Кв = 0;
			РабочееВремя24Кв = 0;
			РабочиеДниКв	 = 0;
			ВыходныеДниКв	 = 0;
			
			Если ВыборкаПоКварталу.КварталКалендаря = 1 
				Или ВыборкаПоКварталу.КварталКалендаря = 3 Тогда
				КалендарныеДниПолугодие1	= 0;
				РабочееВремя40Полугодие1	= 0;
				РабочееВремя36Полугодие1	= 0;
				РабочееВремя24Полугодие1	= 0;
				РабочиеДниПолугодие1		= 0;
				ВыходныеДниПолугодие1		= 0;
			КонецЕсли;
			
			Если ВыборкаПоКварталу.КварталКалендаря = 1 Тогда
				КалендарныеДниГод	= 0;
				РабочееВремя40Год	= 0;
				РабочееВремя36Год	= 0;
				РабочееВремя24Год	= 0;
				РабочиеДниГод		= 0;
				ВыходныеДниГод		= 0;
			КонецЕсли;
			
			ВыборкаПоМесяцу = ВыборкаПоКварталу.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			Пока ВыборкаПоМесяцу.Следующий() Цикл
				
				ВыходныеДни		= 0;
				РабочееВремя40	= 0;
				РабочееВремя36	= 0;
				РабочееВремя24	= 0;
				КалендарныеДни	= 0;
				РабочиеДни		= 0;
				ВыборкаПоВидуДня = ВыборкаПоМесяцу.Выбрать(ОбходРезультатаЗапроса.Прямой);
				
				Пока ВыборкаПоВидуДня.Следующий() Цикл
					Если ВыборкаПоВидуДня.ВидДня = Перечисления.ВидыДнейПроизводственногоКалендаря.Суббота 
						Или ВыборкаПоВидуДня.ВидДня = Перечисления.ВидыДнейПроизводственногоКалендаря.Воскресенье
						Или ВыборкаПоВидуДня.ВидДня = Перечисления.ВидыДнейПроизводственногоКалендаря.Праздник Тогда
						 ВыходныеДни = ВыходныеДни + ВыборкаПоВидуДня.КалендарныеДни
					 ИначеЕсли ВыборкаПоВидуДня.ВидДня = Перечисления.ВидыДнейПроизводственногоКалендаря.Рабочий Тогда 
						 РабочееВремя40 = РабочееВремя40 + ВыборкаПоВидуДня.КалендарныеДни * 8;
						 РабочееВремя36 = РабочееВремя36 + ВыборкаПоВидуДня.КалендарныеДни * 36 / 5;
						 РабочееВремя24 = РабочееВремя24 + ВыборкаПоВидуДня.КалендарныеДни * 24 / 5;
						 РабочиеДни 	= РабочиеДни + ВыборкаПоВидуДня.КалендарныеДни;
					 ИначеЕсли ВыборкаПоВидуДня.ВидДня = Перечисления.ВидыДнейПроизводственногоКалендаря.Предпраздничный Тогда
						 РабочееВремя40 = РабочееВремя40 + ВыборкаПоВидуДня.КалендарныеДни * 7;
						 РабочееВремя36 = РабочееВремя36 + ВыборкаПоВидуДня.КалендарныеДни * (36 / 5 - 1);
						 РабочееВремя24 = РабочееВремя24 + ВыборкаПоВидуДня.КалендарныеДни * (24 / 5 - 1);
						 РабочиеДни		= РабочиеДни + ВыборкаПоВидуДня.КалендарныеДни;
					 КонецЕсли;
					 КалендарныеДни = КалендарныеДни + ВыборкаПоВидуДня.КалендарныеДни;
				КонецЦикла;
				
				КалендарныеДниКв = КалендарныеДниКв + КалендарныеДни;
				РабочееВремя40Кв = РабочееВремя40Кв + РабочееВремя40;
				РабочееВремя36Кв = РабочееВремя36Кв + РабочееВремя36;
				РабочееВремя24Кв = РабочееВремя24Кв + РабочееВремя24;
				РабочиеДниКв	 = РабочиеДниКв 	+ РабочиеДни;
				ВыходныеДниКв	 = ВыходныеДниКв	+ ВыходныеДни;
				
				КалендарныеДниПолугодие1 = КалендарныеДниПолугодие1 + КалендарныеДни;
				РабочееВремя40Полугодие1 = РабочееВремя40Полугодие1 + РабочееВремя40;
				РабочееВремя36Полугодие1 = РабочееВремя36Полугодие1 + РабочееВремя36;
				РабочееВремя24Полугодие1 = РабочееВремя24Полугодие1 + РабочееВремя24;
				РабочиеДниПолугодие1	 = РабочиеДниПолугодие1 	+ РабочиеДни;
				ВыходныеДниПолугодие1	 = ВыходныеДниПолугодие1	+ ВыходныеДни;
				
				КалендарныеДниГод = КалендарныеДниГод + КалендарныеДни;
				РабочееВремя40Год = РабочееВремя40Год + РабочееВремя40;
				РабочееВремя36Год = РабочееВремя36Год + РабочееВремя36;
				РабочееВремя24Год = РабочееВремя24Год + РабочееВремя24;
				РабочиеДниГод	 = РабочиеДниГод 	+ РабочиеДни;
				ВыходныеДниГод	 = ВыходныеДниГод	+ ВыходныеДни;
				
				КолонкаМесяца = Макет.ПолучитьОбласть("КолонкаМесяца");
				КолонкаМесяца.Параметры.ВыходныеДни = ВыходныеДни;
				КолонкаМесяца.Параметры.РабочееВремя40 	= РабочееВремя40;
				КолонкаМесяца.Параметры.РабочееВремя36 	= РабочееВремя36;
				КолонкаМесяца.Параметры.РабочееВремя24 	= РабочееВремя24;
				КолонкаМесяца.Параметры.КалендарныеДни 	= КалендарныеДни;
				КолонкаМесяца.Параметры.РабочиеДни 		= РабочиеДни;
				КолонкаМесяца.Параметры.ИмяМесяца 		= Формат(Дата(НомерГода, ВыборкаПоМесяцу.МесяцКалендаря, 1), "ДФ='ММММ'");
				ТабличныйДокумент.Присоединить(КолонкаМесяца);
				
			КонецЦикла;
			КолонкаМесяца = Макет.ПолучитьОбласть("КолонкаМесяца");
			КолонкаМесяца.Параметры.ВыходныеДни 	= ВыходныеДниКв;
			КолонкаМесяца.Параметры.РабочееВремя40 	= РабочееВремя40Кв;
			КолонкаМесяца.Параметры.РабочееВремя36 	= РабочееВремя36Кв;
			КолонкаМесяца.Параметры.РабочееВремя24 	= РабочееВремя24Кв;
			КолонкаМесяца.Параметры.КалендарныеДни 	= КалендарныеДниКв;
			КолонкаМесяца.Параметры.РабочиеДни 		= РабочиеДниКв;
			КолонкаМесяца.Параметры.ИмяМесяца 		= СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='%1 квартал';uk='%1 квартал'"), ВыборкаПоКварталу.КварталКалендаря);
			ТабличныйДокумент.Присоединить(КолонкаМесяца);
			
			Если ВыборкаПоКварталу.КварталКалендаря = 2 
				Или ВыборкаПоКварталу.КварталКалендаря = 4 Тогда 
				КолонкаМесяца = Макет.ПолучитьОбласть("КолонкаМесяца");
				КолонкаМесяца.Параметры.ВыходныеДни 	= ВыходныеДниПолугодие1;
				КолонкаМесяца.Параметры.РабочееВремя40 	= РабочееВремя40Полугодие1;
				КолонкаМесяца.Параметры.РабочееВремя36 	= РабочееВремя36Полугодие1;
				КолонкаМесяца.Параметры.РабочееВремя24 	= РабочееВремя24Полугодие1;
				КолонкаМесяца.Параметры.КалендарныеДни 	= КалендарныеДниПолугодие1;
				КолонкаМесяца.Параметры.РабочиеДни 		= РабочиеДниПолугодие1;
				КолонкаМесяца.Параметры.ИмяМесяца 		= СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='%1 полугодие';uk='%1 півріччя'"), ВыборкаПоКварталу.КварталКалендаря / 2);
				ТабличныйДокумент.Присоединить(КолонкаМесяца);
			КонецЕсли;
			
		КонецЦикла;
		
		КолонкаМесяца = Макет.ПолучитьОбласть("КолонкаМесяца");
		КолонкаМесяца.Параметры.ВыходныеДни 	= ВыходныеДниГод;
		КолонкаМесяца.Параметры.РабочееВремя40 	= РабочееВремя40Год;
		КолонкаМесяца.Параметры.РабочееВремя36 	= РабочееВремя36Год;
		КолонкаМесяца.Параметры.РабочееВремя24 	= РабочееВремя24Год;
		КолонкаМесяца.Параметры.КалендарныеДни 	= КалендарныеДниГод;
		КолонкаМесяца.Параметры.РабочиеДни 		= РабочиеДниГод;
		КолонкаМесяца.Параметры.ИмяМесяца 		= СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='%1 год';uk='%1 рік'"), Формат(ВыборкаПоГоду.ГодКалендаря, "ЧГ="));
		ТабличныйДокумент.Присоединить(КолонкаМесяца);
		
	КонецЦикла;
	
	КолонкаМесяца = Макет.ПолучитьОбласть("Среднемесячный");
	КолонкаМесяца.Параметры.РабочееВремя40 	= РабочееВремя40Год;
	КолонкаМесяца.Параметры.РабочееВремя36 	= РабочееВремя36Год;
	КолонкаМесяца.Параметры.РабочееВремя24 	= РабочееВремя24Год;
	КолонкаМесяца.Параметры.ИмяМесяца 		= СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='%1 год';uk='%1 рік'"), Формат(НомерГода, "ЧГ="));
	ТабличныйДокумент.Вывести(КолонкаМесяца);
	
	КолонкаМесяца = Макет.ПолучитьОбласть("КолонкаМесяцаСр");
	КолонкаМесяца.Параметры.РабочееВремя40 	= Формат(РабочееВремя40Год / 12, "ЧДЦ=2; ЧГ=0");
	КолонкаМесяца.Параметры.РабочееВремя36 	= Формат(РабочееВремя36Год / 12, "ЧДЦ=2; ЧГ=0");
	КолонкаМесяца.Параметры.РабочееВремя24 	= Формат(РабочееВремя24Год / 12, "ЧДЦ=2; ЧГ=0");
	КолонкаМесяца.Параметры.ИмяМесяца 		= НСтр("ru='Среднемесячное количество';uk='Середньомісячна кількість'");
	ТабличныйДокумент.Присоединить(КолонкаМесяца);
	
	Возврат ТабличныйДокумент;
	
КонецФункции

#КонецОбласти

#КонецЕсли