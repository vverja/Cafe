
#Область ПрограмныйИнтерфейс


#Область ПроцедурыИФункции_РаботыССКД


// Возвращает ссылку на элемент отбора в переданном отборе схемы компоновки данных
//
// Параметры:
//  ОтборКД - <ОтборКомпоновкиДанных> - отбор схемы компоновки в который необходимо добавить новый элемент
//  ИмяЭлемента - <Строка> - имя поля компоновки по которому необходимо найти элемент отбора 
//
// Возвращаемое значение:
//   <ЭлементОтбораКомпоновкиДанных> - ссылка на найденный элемент отбора схемы компоновки данных
//
Функция НайтиЭлементОтбора(ОтборКД, ИмяЭлемента) Экспорт
	
	Результат = Неопределено;
	Для Каждого ЭлементОтбора Из ОтборКД.Элементы Цикл
		Если ТипЗнч(ЭлементОтбора) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда
			Результат = НайтиЭлементОтбора(ЭлементОтбора, ИмяЭлемента);
			Если Результат <> Неопределено Тогда
				Прервать;
			КонецЕсли;
		ИначеЕсли ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(ИмяЭлемента) Тогда
			Результат = ЭлементОтбора;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	Возврат Результат;
	
КонецФункции

// Добавляет новый параметр в переданную коллекцию параметров настроек схемы компоновки данных
//
// Параметры:
//  Параметры - <КомпоновщикНастроекКомпоновкиДанных>, <НастройкиКомпоновкиДанных> - настройки схемы компоновки
//  ИмяПараметра - <ПараметрыДанных>, <ПараметрыВывода> - колллекция параметров компоновки данных
//  Значение  - <Произвольный> - значение параметра компоновки (необязательное)
//  Использование  - <Булево> - использование параметра данных (необязательное по умолчанию Истина)
//
Процедура УстановитьПараметр(Параметры, ИмяПараметра, Значение = Неопределено, Использование = Истина) Экспорт
	
	Параметр = Параметры.Элементы.Найти(ИмяПараметра);
	Если Параметр = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Параметр.Использование = Использование;
	Если Использование Тогда
		Параметр.Значение = Значение;
	КонецЕсли;
	
КонецПроцедуры

// Выполняет схему компоновки данных и возвращает таблицу результата
//
// Параметры:
//  СхемаКомпоновкиДанных  - <СхемаКомпоновкиДанных> - исполняемая схема компоновки данных
//  НастройкиКомпоновщика  - <КомпоновщикНастроекКомпоновкиДанных> - компоновщик настроек исполняемой схемы компоновки данных
//  ВнешниеНаборыДанных  - <Структура> - внешние наборы компоновки данных - ключ - наименование внешнего набора, значение - таблица значений внешнего набора
//  ВыводВДерево - <Булево> - если Истина выводить в дерево значений
//
// Возвращаемое значение:
//   <ТаблицаЗначений>, <ДеревоЗначений> - результат выполнения схемы компоновки данных
//
Функция ВыгрузитьРезультатСКД(СхемаКомпоновкиДанных, НастройкиКомпоновщика, ВнешниеНаборыДанных = Неопределено, ВыводВДерево = Ложь) Экспорт
	
	МакетКомпоновщика = ПодготовитьМакетКомпоновкиДляВыгрузкиСКД(СхемаКомпоновкиДанных, НастройкиКомпоновщика);
	Возврат ВыгрузитьРезультатСКДПоМакету(МакетКомпоновщика, ВнешниеНаборыДанных, ВыводВДерево);
	
КонецФункции

// Возвращает ссылку на новый элемент отбора в переданном отборе схемы компоновки данных
//
// Параметры:
//  Отбор - <ОтборКомпоновкиДанных> - отбор схемы компоновки в который необходимо добавить новый элемент
//  ЛевоеЗначение - <Строка>, <ПолеКомпоновкиДанных> - поле компоновки по которому необходимо установить отбор (необязательное)
//  ПравоеЗначение  - <Произвольный> - значение отбора (необязательное)
//  ТипОтбора  - <ЭлементОтбораКомпоновкиДанных>, <ГруппаЭлементовОтбораКомпоновкиДанных> - тип нового элемента отбора (необязательное)
//
// Возвращаемое значение:
//   <ЭлементОтбораКомпоновкиДанных> - ссылка на новый элемент отбора схемы компоновки данных
//
Функция НовыйОтбор(Отбор, ЛевоеЗначение = Неопределено, ПравоеЗначение = Неопределено, ТипОтбора = Неопределено, ВидСравнения = Неопределено) Экспорт
	
	Если ТипОтбора = Неопределено Тогда
		ТипОтбора = Тип("ЭлементОтбораКомпоновкиДанных");
	КонецЕсли;
	
	НовыйОтбор = Отбор.Элементы.Добавить(ТипОтбора);
	Если ЛевоеЗначение <> Неопределено Тогда
		Если ТипЗнч(ЛевоеЗначение) = Тип("ПолеКомпоновкиДанных") Тогда
			НовыйОтбор.ЛевоеЗначение = ЛевоеЗначение;
		Иначе
			НовыйОтбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(ЛевоеЗначение);
		КонецЕсли;
	КонецЕсли;
	
	Если ПравоеЗначение <> Неопределено Тогда
		НовыйОтбор.ПравоеЗначение = ПравоеЗначение;
	КонецЕсли;
	
	Если ТипОтбора = Тип("ЭлементОтбораКомпоновкиДанных") Тогда
		Если ВидСравнения = Неопределено Тогда
			НовыйОтбор.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
			Если ТипЗнч(ПравоеЗначение) = Тип("Массив") ИЛИ ТипЗнч(ПравоеЗначение) = Тип("СписокЗначений") Тогда
				НовыйОтбор.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
			КонецЕсли;
		Иначе
			НовыйОтбор.ВидСравнения = ВидСравнения;
		КонецЕсли;
	КонецЕсли;
	
	Возврат НовыйОтбор;
	
КонецФункции

// Устанавливает новый отбор в переданном отборе схемы компоновки данных
//
// Параметры:
//  ОтборКД - <ОтборКомпоновкиДанных> - отбор схемы компоновки в который необходимо добавить новый элемент
//  ЛевоеЗначение - <Строка>, <ПолеКомпоновкиДанных> - поле компоновки по которому необходимо установить отбор
//  ПравоеЗначение  - <Произвольный> - значение отбора (необязательное)
//  ВидСравнения  - <ВидСравненияКомпоновки> - вид сравнение компоновки данных (необязательное)
//  Использование  - <Булево> - использование нового элемента отбора (необязательное по умолчанию Истина)
//
Процедура УстановитьОтбор(ОтборКД, ЛевоеЗначение, ПравоеЗначение = Неопределено, ВидСравнения = Неопределено, Использование = Истина) Экспорт
	
	ЭлементОтбора = НайтиЭлементОтбора(ОтборКД, ЛевоеЗначение);
	Если ЭлементОтбора = Неопределено Тогда
		ЭлементОтбора = НовыйОтбор(ОтборКД, ЛевоеЗначение, ПравоеЗначение);
	КонецЕсли;
	ЭлементОтбора.Использование = Использование;
	Если ВидСравнения <> Неопределено Тогда
		ЭлементОтбора.ВидСравнения = ВидСравнения;
	КонецЕсли;
	Если Использование Тогда
		ЭлементОтбора.ПравоеЗначение = ПравоеЗначение;
	КонецЕсли;
	
КонецПроцедуры

// Устанавливает параметр данных в переданных настройках схемы компоновки данных
//
// Параметры:
//  НастройкиКомпоновщика - <КомпоновщикНастроекКомпоновкиДанных>, <НастройкиКомпоновкиДанных> - настройки схемы компоновки
//  ИмяПараметра - <Строка> - имя параметра компоновки данных
//  Значение  - <Произвольный> - значение параметра компоновки (необязательное)
//  Использование  - <Булево> - использование параметра данных (необязательное по умолчанию Истина)
//
Процедура УстановитьПараметрКомпоновки(НастройкиКомпоновщика, ИмяПараметра, Значение = Неопределено, Использование = Истина) Экспорт
	
	НастройкиКД = НастройкиКомпоновщика;
	Если ТипЗнч(НастройкиКомпоновщика) = Тип("КомпоновщикНастроекКомпоновкиДанных") Тогда
		НастройкиКД = НастройкиКомпоновщика.Настройки;
	КонецЕсли;
	УстановитьПараметр(НастройкиКД.ПараметрыДанных, ИмяПараметра, Значение, Использование);
	
КонецПроцедуры

// Возвращает компоновщик настроек для переданной схемы компоновки данных
//
// Параметры:
//  Схема - <СхемаКомпоновкиДанных> - схема компоновки данных для которой необходимо создать компоновщик настроек
//
// Возвращаемое значение:
//   <КомпоновщикНастроекКомпоновкиДанных> - <описание возвращаемого значения>
//
Функция КомпоновщикСхемы(Схема) Экспорт
	
	ИсточникДоступныхНастроек = Новый ИсточникДоступныхНастроекКомпоновкиДанных(Схема);
	Компоновщик = Новый КомпоновщикНастроекКомпоновкиДанных;
	Компоновщик.Инициализировать(ИсточникДоступныхНастроек);
	Компоновщик.ЗагрузитьНастройки(Схема.НастройкиПоУмолчанию);
	
	Возврат Компоновщик;
	
КонецФункции

// Возвращает макет компоновки данных
//
// Параметры:
//  СхемаКомпоновкиДанных  - <СхемаКомпоновкиДанных> - исполняемая схема компоновки данных
//  НастройкиКомпоновщика  - <КомпоновщикНастроекКомпоновкиДанных>, <НастройкиКомпоновкиДанных> - настройки исполняемой схемы компоновки данных
//
// Возвращаемое значение:
//   <МакетКомпоновкиДанных> - макет компоновки данных
//
Функция ПодготовитьМакетКомпоновкиДляВыгрузкиСКД(СхемаКомпоновкиДанных, НастройкиКомпоновщика) Экспорт
	
	НастройкиКД = НастройкиКомпоновщика;
	Если ТипЗнч(НастройкиКомпоновщика) = Тип("КомпоновщикНастроекКомпоновкиДанных") Тогда
		НастройкиКД = НастройкиКомпоновщика.ПолучитьНастройки();
	КонецЕсли;
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиКД,,,Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	
	Возврат МакетКомпоновки;
	
КонецФункции

// Выполняет схему компоновки данных и возвращает таблицу результата
//
// Параметры:
//  МакетКомпоновки  - <МакетКомпоновкиДанных> - макет компоновки данных
//  ВнешниеНаборыДанных  - <Структура> - внешние наборы компоновки данных - ключ - наименование внешнего набора, значение - таблица значений внешнего набора
//  ВыводВДерево - <Булево> - если Истина выводить в дерево значений
//
// Возвращаемое значение:
//   <ТаблицаЗначений>, <ДеревоЗначений> - результат выполнения схемы компоновки данных
//
Функция ВыгрузитьРезультатСКДПоМакету(МакетКомпоновки, ВнешниеНаборыДанных = Неопределено, ВыводВДерево = Ложь) Экспорт
	
	Результат = Новый ТаблицаЗначений;
	Если ВыводВДерево Тогда
		Результат = Новый ДеревоЗначений;
	КонецЕсли;
	
	//Создаем процессор компоновки
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	Если ВнешниеНаборыДанных = Неопределено Тогда
		ПроцессорКомпоновки.Инициализировать(МакетКомпоновки,,,Истина);
	Иначе
		ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, ВнешниеНаборыДанных,,Истина);
	КонецЕсли;
	
	//Выводим в таблицу значений
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	ПроцессорВывода.УстановитьОбъект(Результат);
	Результат = ПроцессорВывода.Вывести(ПроцессорКомпоновки, Истина);
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецОбласти

