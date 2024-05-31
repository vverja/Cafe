#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ Параметры.Свойство("Рассылка") 
		ИЛИ НЕ ТипЗнч(Параметры.Рассылка) = Тип("ДокументСсылка.РассылкаКлиентам")
		ИЛИ Параметры.Рассылка.Пустая() Тогда
		
		Отказ = Истина;
		Возврат;
		
	КонецЕсли;
	
	//Если нет права доступа к подсистеме "Взаимодействия" то показывать нечего.
	Если Не ПравоДоступа("Просмотр", Метаданные.ЖурналыДокументов.Взаимодействия) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='У вас нет прав на просмотр отчета по созданным документам рассылки.';uk='У вас немає прав на перегляд звіту за створеними документам розсилки.'"));
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Рассылка = Параметры.Рассылка;

	СформироватьОтчет();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Обновить(Команда)
	
	СформироватьОтчет();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбработатьТекстЗапросаАдресатыРассылки(ДанныеРассылки, Запрос, ЕстьОтборПоКомпоновке)

	ТекстОбъединить =" 
	|
	|ОБЪЕДИНИТЬ
	|";
		
	ТекстПоместить = "ПОМЕСТИТЬ Адресаты";
		
	Если ДанныеРассылки.Принудительная Тогда
		
		ТекстЗапросаПартнеры = "";
		ТекстЗапросаКонактныеЛица = "";
		
		Если ДанныеРассылки.ОтправлятьПартнеру Тогда
			
			ТекстЗапросаПартнеры = "
			|ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	Партнеры.Ссылка КАК Получатель,
			|	ЕСТЬNULL(ПартнерыКонтактнаяИнформация.Представление, """") КАК ПредставлениеКонтактнойИнформации,
			|	&ВидКонтактнойИнформацииПартнера КАК ВидКонтактнойИнформации,
			|	Партнеры.НаименованиеПолное КАК ПредставлениеПолучателя
			|	%ПОМЕСТИТЬ%
			|ИЗ
			|	Справочник.Партнеры КАК Партнеры
			|		%СоединениеПоОтбору%
			|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Партнеры.КонтактнаяИнформация КАК ПартнерыКонтактнаяИнформация
			|		ПО (ПартнерыКонтактнаяИнформация.Ссылка = Партнеры.Ссылка)
			|			И (ПартнерыКонтактнаяИнформация.Вид = &ВидКонтактнойИнформацииПартнера)
			|ГДЕ
			|	НЕ Партнеры.ПометкаУдаления";
			
			Если ЕстьОтборПоКомпоновке Тогда
				ТекстСоединениеПоОтбору ="ВНУТРЕННЕЕ СОЕДИНЕНИЕ ОтборПартнеров КАК ОтборПартнеров
				                         |ПО Партнеры.Ссылка = ОтборПартнеров.Партнер";
			Иначе
				ТекстСоединениеПоОтбору = "";
			КонецЕсли;
			
			ТекстЗапросаПартнеры = СтрЗаменить(ТекстЗапросаПартнеры, "%СоединениеПоОтбору%", ТекстСоединениеПоОтбору);
			ТекстЗапросаПартнеры = СтрЗаменить(ТекстЗапросаПартнеры, "%ПОМЕСТИТЬ%", ТекстПоместить);
			
			Запрос.УстановитьПараметр("ВидКонтактнойИнформацииПартнера",
			                           ?(ДанныеРассылки.ПредназначенаДляЭлектронныхПисем,
			                             ДанныеРассылки.ВидКонтактнойИнформацииПартнераДляПисем,
			                             ДанныеРассылки.ВидКонтактнойИнформацииПартнераДляSMS));
			
		КонецЕсли;
		
		Если ДанныеРассылки.ОтправлятьКонтактнымЛицамРоли Тогда
			
			ТекстЗапросаКонтактныеЛица ="
			|ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	КонтактныеЛицаПартнеров.Ссылка КАК Получатель,
			|	ЕСТЬNULL(КонтактныеЛицаПартнеровКонтактнаяИнформация.Представление, """") КАК ПредставлениеКонтактнойИнформации,
			|	&ВидКонтактнойИнформацииКонтаткногоЛица КАК ВидКонтактнойИнформации,
			|	КонтактныеЛицаПартнеров.Наименование КАК ПредставлениеПолучателя
			|	%ПОМЕСТИТЬ%
			|ИЗ
			|	Справочник.КонтактныеЛицаПартнеров КАК КонтактныеЛицаПартнеров
			|		%СоединениеПоОтбору%
			|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КонтактныеЛицаПартнеров.КонтактнаяИнформация КАК КонтактныеЛицаПартнеровКонтактнаяИнформация
			|		ПО (КонтактныеЛицаПартнеровКонтактнаяИнформация.Ссылка = КонтактныеЛицаПартнеров.Ссылка)
			|			И (КонтактныеЛицаПартнеровКонтактнаяИнформация.Вид = &ВидКонтактнойИнформацииКонтаткногоЛица)
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.КонтактныеЛицаПартнеров.РолиКонтактногоЛица КАК КонтактныеЛицаПартнеровРолиКонтактногоЛица
			|		ПО КонтактныеЛицаПартнеров.Ссылка = КонтактныеЛицаПартнеровРолиКонтактногоЛица.Ссылка
			|			И (КонтактныеЛицаПартнеровРолиКонтактногоЛица.РольКонтактногоЛица = &РольКонтактногоЛица)
			|ГДЕ
			|	НЕ КонтактныеЛицаПартнеров.ПометкаУдаления";
			
			Если ЕстьОтборПоКомпоновке Тогда
				ТекстСоединениеПоОтбору ="ВНУТРЕННЕЕ СОЕДИНЕНИЕ ОтборПартнеров КАК ОтборПартнеров
				                         |ПО КонтактныеЛицаПартнеров.Владелец = ОтборПартнеров.Партнер";
			Иначе
				ТекстСоединениеПоОтбору = "";
			КонецЕсли;
			
			ТекстЗапросаКонтактныеЛица = СтрЗаменить(ТекстЗапросаКонтактныеЛица, "%СоединениеПоОтбору%", ТекстСоединениеПоОтбору);
			Если ДанныеРассылки.ОтправлятьПартнеру Тогда
				ТекстЗапросаКонтактныеЛица = СтрЗаменить(ТекстЗапросаКонтактныеЛица, "%ПОМЕСТИТЬ%", "");
			Иначе
				ТекстЗапросаКонтактныеЛица = СтрЗаменить(ТекстЗапросаКонтактныеЛица, "%ПОМЕСТИТЬ%", ТекстПоместить);
			КонецЕсли;
			
			Запрос.УстановитьПараметр("ВидКонтактнойИнформацииКонтаткногоЛица",
			                          ?(ДанныеРассылки.ПредназначенаДляЭлектронныхПисем,
			                            ДанныеРассылки.ВидКонтактнойИнформацииКонтактногоЛицаДляПисем,
			                            ДанныеРассылки.ВидКонтактнойИнформацииКонтактногоЛицаДляSMS));
			Запрос.УстановитьПараметр("РольКонтактногоЛица", ДанныеРассылки.РольКонтактногоЛица);
			
		КонецЕсли;
		
		Если (НЕ ДанныеРассылки.ОтправлятьПартнеру) И (НЕ ДанныеРассылки.ОтправлятьКонтактнымЛицамРоли) Тогда
			Запрос.Текст = "";
		Иначе
			НеобходимТекстОбъединить = ДанныеРассылки.ОтправлятьПартнеру И ДанныеРассылки.ОтправлятьКонтактнымЛицамРоли;
			Запрос.Текст = Запрос.Текст + ТекстЗапросаПартнеры + ?(НеобходимТекстОбъединить, ТекстОбъединить, "") + ТекстЗапросаКонтактныеЛица;
		КонецЕсли;
		
	Иначе // По подпискам
		
		ТекстЗапросаПодписчики = "
		|ВЫБРАТЬ
		|	ПодпискиНаРассылкиИОповещенияКлиентам.Владелец КАК Получатель,
		|	ЕСТЬNULL(ПартнерыКонтактнаяИнформация.Представление, """") КАК ПредставлениеКонтактнойИнформации,
		|	ВЫБОР
		|		КОГДА &ПредназначенаДляПисем
		|			ТОГДА ПодпискиНаРассылкиИОповещенияКлиентам.ВидКИПартнераДляПисем
		|			ИНАЧЕ ПодпискиНаРассылкиИОповещенияКлиентам.ВидКИПартнераДляSMS
		|	КОНЕЦ КАК ВидКонтактнойИнформации,
		|	Партнеры.НаименованиеПолное КАК ПредставлениеПолучателя
		|ПОМЕСТИТЬ Адресаты
		|ИЗ
		|	Справочник.ПодпискиНаРассылкиИОповещенияКлиентам КАК ПодпискиНаРассылкиИОповещенияКлиентам
		|		%СоединениеПоОтбору%
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Партнеры КАК Партнеры
		|		ПО ПодпискиНаРассылкиИОповещенияКлиентам.Владелец = Партнеры.Ссылка
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Партнеры.КонтактнаяИнформация КАК ПартнерыКонтактнаяИнформация
		|		ПО ПодпискиНаРассылкиИОповещенияКлиентам.Владелец = ПартнерыКонтактнаяИнформация.Ссылка
		|			И (ВЫБОР
		|				КОГДА &ПредназначенаДляПисем
		|					ТОГДА ПодпискиНаРассылкиИОповещенияКлиентам.ВидКИПартнераДляПисем = ПартнерыКонтактнаяИнформация.Вид
		|				ИНАЧЕ ПодпискиНаРассылкиИОповещенияКлиентам.ВидКИПартнераДляSMS = ПартнерыКонтактнаяИнформация.Вид
		|			КОНЕЦ)
		|ГДЕ
		|	ПодпискиНаРассылкиИОповещенияКлиентам.ПодпискаДействует
		|	И ПодпискиНаРассылкиИОповещенияКлиентам.ОтправлятьПартнеру
		|	И НЕ ПодпискиНаРассылкиИОповещенияКлиентам.ПометкаУдаления
		|	И ПодпискиНаРассылкиИОповещенияКлиентам.ГруппаРассылокИОповещений = &ГруппаРассылокИОповещений
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ПодпискиНаРассылкиИОповещенияКлиентамКонтактныеЛица.КонтактноеЛицо,
		|	ЕСТЬNULL(КонтактныеЛицаПартнеровКонтактнаяИнформация.Представление, """"),
		|	ВЫБОР
		|		КОГДА &ПредназначенаДляПисем
		|		ТОГДА ПодпискиНаРассылкиИОповещенияКлиентамКонтактныеЛица.ВидКИДляПисем
		|			ИНАЧЕ ПодпискиНаРассылкиИОповещенияКлиентамКонтактныеЛица.ВидКИДляSMS
		|	КОНЕЦ КАК ВидКонтактнойИнформации,
		|	КонтактныеЛицаПартнеров.Наименование
		|ИЗ
		|	Справочник.ПодпискиНаРассылкиИОповещенияКлиентам.КонтактныеЛица КАК ПодпискиНаРассылкиИОповещенияКлиентамКонтактныеЛица
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПодпискиНаРассылкиИОповещенияКлиентам КАК ПодпискиНаРассылкиИОповещенияКлиентам
		|		ПО ПодпискиНаРассылкиИОповещенияКлиентамКонтактныеЛица.Ссылка = ПодпискиНаРассылкиИОповещенияКлиентам.Ссылка
		|		%СоединениеПоОтбору%
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КонтактныеЛицаПартнеров.КонтактнаяИнформация КАК КонтактныеЛицаПартнеровКонтактнаяИнформация
		|		ПО ПодпискиНаРассылкиИОповещенияКлиентамКонтактныеЛица.КонтактноеЛицо = КонтактныеЛицаПартнеровКонтактнаяИнформация.Ссылка
		|			И (ВЫБОР
		|				КОГДА &ПредназначенаДляПисем
		|					ТОГДА ПодпискиНаРассылкиИОповещенияКлиентамКонтактныеЛица.ВидКИДляПисем = КонтактныеЛицаПартнеровКонтактнаяИнформация.Вид
		|				ИНАЧЕ ПодпискиНаРассылкиИОповещенияКлиентамКонтактныеЛица.ВидКИДляSMS = КонтактныеЛицаПартнеровКонтактнаяИнформация.Вид
		|			КОНЕЦ)
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.КонтактныеЛицаПартнеров КАК КонтактныеЛицаПартнеров
		|		ПО ПодпискиНаРассылкиИОповещенияКлиентамКонтактныеЛица.КонтактноеЛицо = КонтактныеЛицаПартнеров.Ссылка
		|ГДЕ
		|	НЕ ПодпискиНаРассылкиИОповещенияКлиентам.ПометкаУдаления
		|	И ПодпискиНаРассылкиИОповещенияКлиентам.ПодпискаДействует
		|	И ПодпискиНаРассылкиИОповещенияКлиентам.ГруппаРассылокИОповещений = &ГруппаРассылокИОповещений";
		
		Запрос.УстановитьПараметр("ГруппаРассылокИОповещений", ДанныеРассылки.ГруппаРассылокИОповещений);
		
		Если ЕстьОтборПоКомпоновке Тогда
			ТекстСоединениеПоОтбору ="ВНУТРЕННЕЕ СОЕДИНЕНИЕ ОтборПартнеров КАК ОтборПартнеров
			                         |ПО ПодпискиНаРассылкиИОповещенияКлиентам.Владелец = ОтборПартнеров.Партнер";
		Иначе
			ТекстСоединениеПоОтборуПартнеры = "";
		КонецЕсли;
		
		ТекстЗапросаПодписчики = СтрЗаменить(ТекстЗапросаПодписчики, "%СоединениеПоОтбору%", ТекстСоединениеПоОтбору);
		Запрос.Текст = Запрос.Текст + ТекстЗапросаПодписчики;
		
	КонецЕсли;
	
	ТекстЗапросаДополнительныеПолучатели = "
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	РассылкаКлиентамДополнительныеПолучатели.Контакт КАК Получатель,
	|	РассылкаКлиентамДополнительныеПолучатели.КонтактнаяИнформация КАК ПредставлениеКонтактнойИнформации,
	|	Значение(Справочник.ВидыКонтактнойИнформации.ПустаяСсылка) КАК ВидКонтактнойИнформации,
	|	ВЫБОР
	|		КОГДА РассылкаКлиентамДополнительныеПолучатели.Контакт ССЫЛКА Справочник.Партнеры
	|			ТОГДА ЕСТЬNULL(Партнеры.НаименованиеПолное, """")
	|		ИНАЧЕ ЕСТЬNULL(КонтактныеЛицаПартнеров.Наименование, """")
	|	КОНЕЦ КАК ПредставлениеПолучателя
	|	%ПОМЕСТИТЬ%
	|ИЗ
	|	Документ.РассылкаКлиентам.ДополнительныеПолучатели КАК РассылкаКлиентамДополнительныеПолучатели
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Партнеры КАК Партнеры
	|		ПО РассылкаКлиентамДополнительныеПолучатели.Контакт = Партнеры.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КонтактныеЛицаПартнеров КАК КонтактныеЛицаПартнеров
	|		ПО РассылкаКлиентамДополнительныеПолучатели.Контакт = КонтактныеЛицаПартнеров.Ссылка
	|ГДЕ
	|	РассылкаКлиентамДополнительныеПолучатели.Ссылка = &РассылкаКлиентам
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////";
	
	Если ПустаяСтрока(Запрос.Текст) Тогда
		ТекстЗапросаДополнительныеПолучатели = СтрЗаменить(ТекстЗапросаДополнительныеПолучатели, "%ПОМЕСТИТЬ%", ТекстПоместить);
	Иначе
		ТекстЗапросаДополнительныеПолучатели = СтрЗаменить(ТекстЗапросаДополнительныеПолучатели, "%ПОМЕСТИТЬ%", "");
	КонецЕсли;
	
	Запрос.Текст = Запрос.Текст + ?(ПустаяСтрока(Запрос.Текст), "", ТекстОбъединить) + ТекстЗапросаДополнительныеПолучатели;
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьТекстЗапросаАдресатыРассылкиНазначениеОпросов(Данные, ДанныеОснования, Запрос, ЕстьОтборПоКомпоновке)
	
	Если Данные.Принудительная Тогда
		
		Если ТипЗнч(ДанныеОснования.ТипРеспондентов) = Тип("СправочникСсылка.Партнеры") И Данные.ОтправлятьПартнеру Тогда
			
			Если ДанныеОснования.СвободныйОпрос Тогда
				
				ТекстЗапросаРеспонденты = "
				|ВЫБРАТЬ РАЗЛИЧНЫЕ РАЗРЕШЕННЫЕ
				|	Партнеры.Ссылка КАК Получатель,
				|	ЕСТЬNULL(ПартнерыКонтактнаяИнформация.Представление, """") КАК ПредставлениеКонтактнойИнформации,
				|	&ВидКонтактнойИнформацииПартнера КАК ВидКонтактнойИнформации,
				|	Партнеры.НаименованиеПолное КАК ПредставлениеПолучателя
				|ПОМЕСТИТЬ Адресаты
				|ИЗ
				|	Справочник.Партнеры КАК Партнеры 
				|		%СоединениеПоОтбору%
				|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Партнеры.КонтактнаяИнформация КАК ПартнерыКонтактнаяИнформация
				|		ПО ПартнерыКонтактнаяИнформация.Ссылка = Партнеры.Ссылка
				|			И (ПартнерыКонтактнаяИнформация.Вид = &ВидКонтактнойИнформацииПартнера)
				|			И (НЕ Партнеры.ПометкаУдаления)";
				
			Иначе
				
				ТекстЗапросаРеспонденты = "
				|ВЫБРАТЬ РАЗЛИЧНЫЕ РАЗРЕШЕННЫЕ
				|	НазначениеОпросовРеспонденты.Респондент КАК Получатель,
				|	ЕСТЬNULL(ПартнерыКонтактнаяИнформация.Представление, """") КАК ПредставлениеКонтактнойИнформации,
				|	&ВидКонтактнойИнформацииПартнера КАК ВидКонтактнойИнформации,
				|	Партнеры.НаименованиеПолное КАК ПредставлениеПолучателя
				|ПОМЕСТИТЬ Адресаты
				|ИЗ
				|	Документ.НазначениеОпросов.Респонденты КАК НазначениеОпросовРеспонденты
				|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Партнеры.КонтактнаяИнформация КАК ПартнерыКонтактнаяИнформация
				|		ПО НазначениеОпросовРеспонденты.Респондент = ПартнерыКонтактнаяИнформация.Ссылка
				|			И (ПартнерыКонтактнаяИнформация.Вид = &ВидКонтактнойИнформацииПартнера)
				|		%СоединениеПоОтбору%
				|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Партнеры КАК Партнеры
				|		ПО НазначениеОпросовРеспонденты.Респондент = Партнеры.Ссылка
				|ГДЕ
				|	НазначениеОпросовРеспонденты.Ссылка = &НазначениеОпросов"
				
			КонецЕсли;
			
			РассылкиИОповещенияКлиентам.ОбработатьТекстЗапросаПоПартнерамРассылки(Запрос, ТекстЗапросаРеспонденты, Данные, ЕстьОтборПоКомпоновке);
			
		ИначеЕсли ТипЗнч(ДанныеОснования.ТипРеспондентов) = Тип("СправочникСсылка.КонтактныеЛицаПартнеров") И Данные.ОтправлятьКонтактномуЛицуОбъектаОповещения Тогда
			
			Если ДанныеОснования.СвободныйОпрос Тогда
				
				ТекстЗапросаРеспонденты ="
				|ВЫБРАТЬ РАЗЛИЧНЫЕ РАЗРЕШЕННЫЕ
				|	КонтактныеЛицаПартнеров.Ссылка КАК Получатель,
				|	ЕСТЬNULL(КонтактныеЛицаПартнеровКонтактнаяИнформация.Представление, """") КАК ПредставлениеКонтактнойИнформации,
				|	&ВидКонтактнойИнформацииКонтаткногоЛица КАК ВидКонтактнойИнформации,
				|	КонтактныеЛицаПартнеров.Наименование КАК ПредставлениеПолучателя
				|ПОМЕСТИТЬ Адресаты
				|ИЗ
				|	Справочник.КонтактныеЛицаПартнеров КАК КонтактныеЛицаПартнеров
				|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КонтактныеЛицаПартнеров.КонтактнаяИнформация КАК КонтактныеЛицаПартнеровКонтактнаяИнформация
				|		ПО КонтактныеЛицаПартнеровКонтактнаяИнформация.Ссылка = КонтактныеЛицаПартнеров.Ссылка
				|			И (КонтактныеЛицаПартнеровКонтактнаяИнформация.Вид = &ВидКонтактнойИнформацииКонтаткногоЛица)
				|			И (НЕ КонтактныеЛицаПартнеров.ПометкаУдаления)
				|		%СоединениеПоОтбору%
				|";
				
			Иначе
				
				ТекстЗапросаРеспонденты = "
				|ВЫБРАТЬ РАЗЛИЧНЫЕ РАЗРЕШЕННЫЕ
				|	НазначениеОпросовРеспонденты.Респондент КАК Получатель,
				|	ЕСТЬNULL(КонтактныеЛицаПартнеровКонтактнаяИнформация.Представление, """") КАК ПредставлениеКонтактнойИнформации,
				|	&ВидКонтактнойИнформацииКонтаткногоЛица КАК ВидКонтактнойИнформации,
				|	КонтактныеЛицаПартнеров.Наименование КАК ПредставлениеПолучателя
				|ПОМЕСТИТЬ Адресаты
				|ИЗ
				|	Документ.НазначениеОпросов.Респонденты КАК НазначениеОпросовРеспонденты
				|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КонтактныеЛицаПартнеров.КонтактнаяИнформация КАК КонтактныеЛицаПартнеровКонтактнаяИнформация
				|		ПО НазначениеОпросовРеспонденты.Респондент = КонтактныеЛицаПартнеровКонтактнаяИнформация.Ссылка
				|			И (КонтактныеЛицаПартнеровКонтактнаяИнформация.Вид = &ВидКонтактнойИнформацииКонтаткногоЛица)
				|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.КонтактныеЛицаПартнеров КАК КонтактныеЛицаПартнеров
				|		ПО НазначениеОпросовРеспонденты.Респондент = КонтактныеЛицаПартнеров.Ссылка
				|		%СоединениеПоОтбору%
				|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Партнеры КАК Партнеры
				|		ПО КонтактныеЛицаПартнеров.Владелец = Партнеры.Ссылка
				|ГДЕ
				|	НазначениеОпросовРеспонденты.Ссылка = &НазначениеОпросов";
				
			КонецЕсли;
			
			РассылкиИОповещенияКлиентам.ОбработатьТекстЗапросаПоКонтактнымЛицамРассылки(Запрос, ТекстЗапросаРеспонденты, Данные, ЕстьОтборПоКомпоновке);
			
		КонецЕсли;
		
	Иначе
		
		Запрос.УстановитьПараметр("ГруппаРассылокИОповещений", Данные.ГруппаРассылокИОповещений);
		
		Если ТипЗнч(ДанныеОснования.ТипРеспондентов) = Тип("СправочникСсылка.Партнеры")  Тогда
			
			Если ДанныеОснования.СвободныйОпрос Тогда
				
				ТекстЗапросаРеспонденты = "
				|ВЫБРАТЬ РАЗЛИЧНЫЕ РАЗРЕШЕННЫЕ
				|	ПодпискиНаРассылкиИОповещенияКлиентам.Владелец КАК Получатель,
				|	ЕСТЬNULL(ПартнерыКонтактнаяИнформация.Представление, """") КАК ПредставлениеКонтактнойИнформации,
				|	ВЫБОР
				|		КОГДА &ПредназначенаДляПисем
				|			ТОГДА ПодпискиНаРассылкиИОповещенияКлиентам.ВидКИПартнераДляПисем 
				|			ИНАЧЕ ПодпискиНаРассылкиИОповещенияКлиентам.ВидКИПартнераДляSMS 
				|	КОНЕЦ КАК ВидКонтактнойИнформации,
				|	Партнеры.НаименованиеПолное КАК ПредставлениеПолучателя
				|ПОМЕСТИТЬ Адресаты
				|ИЗ
				|	Справочник.ПодпискиНаРассылкиИОповещенияКлиентам КАК ПодпискиНаРассылкиИОповещенияКлиентам
				|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Партнеры КАК Партнеры
				|		ПО ПодпискиНаРассылкиИОповещенияКлиентам.Владелец = Партнеры.Ссылка
				|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Партнеры.КонтактнаяИнформация КАК ПартнерыКонтактнаяИнформация
				|		ПО ПодпискиНаРассылкиИОповещенияКлиентам.Владелец = ПартнерыКонтактнаяИнформация.Ссылка
				|			И (ВЫБОР
				|				КОГДА &ПредназначенаДляПисем
				|					ТОГДА ПодпискиНаРассылкиИОповещенияКлиентам.ВидКИПартнераДляПисем = ПартнерыКонтактнаяИнформация.Вид
				|				ИНАЧЕ ПодпискиНаРассылкиИОповещенияКлиентам.ВидКИПартнераДляSMS = ПартнерыКонтактнаяИнформация.Вид
				|			КОНЕЦ)
				|		%СоединениеПоОтбору%
				|ГДЕ
				|	ПодпискиНаРассылкиИОповещенияКлиентам.ПодпискаДействует
				|	И ПодпискиНаРассылкиИОповещенияКлиентам.ОтправлятьПартнеру
				|	И НЕ ПодпискиНаРассылкиИОповещенияКлиентам.ПометкаУдаления
				|	И ПодпискиНаРассылкиИОповещенияКлиентам.ГруппаРассылокИОповещений = &ГруппаРассылокИОповещений";
				
			Иначе
				
				ТекстЗапросаРеспонденты = "
				|ВЫБРАТЬ РАЗЛИЧНЫЕ РАЗРЕШЕННЫЕ
				|	НазначениеОпросовРеспонденты.Респондент КАК Получатель,
				|	ЕСТЬNULL(ПартнерыКонтактнаяИнформация.Представление, """") КАК ПредставлениеКонтактнойИнформации,
				|	ВЫБОР
				|		КОГДА &ПредназначенаДляПисем
				|			ТОГДА ПодпискиНаРассылкиИОповещенияКлиентам.ВидКИПартнераДляПисем 
				|			ИНАЧЕ ПодпискиНаРассылкиИОповещенияКлиентам.ВидКИПартнераДляSMS 
				|	КОНЕЦ КАК ВидКонтактнойИнформации,
				|	Партнеры.НаименованиеПолное КАК ПредставлениеПолучателя
				|ПОМЕСТИТЬ Адресаты
				|ИЗ
				|	Документ.НазначениеОпросов.Респонденты КАК НазначениеОпросовРеспонденты
				|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ПодпискиНаРассылкиИОповещенияКлиентам КАК ПодпискиНаРассылкиИОповещенияКлиентам
				|			ПО НазначениеОпросовРеспонденты.Респондент = ПодпискиНаРассылкиИОповещенияКлиентам.Владелец
				|				И ПодпискиНаРассылкиИОповещенияКлиентам.ПодпискаДействует
				|				И ПодпискиНаРассылкиИОповещенияКлиентам.ОтправлятьПартнеру
				|				И НЕ ПодпискиНаРассылкиИОповещенияКлиентам.ПометкаУдаления
				|				И ПодпискиНаРассылкиИОповещенияКлиентам.ГруппаРассылокИОповещений = &ГруппаРассылокИОповещений			
				|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Партнеры.КонтактнаяИнформация КАК ПартнерыКонтактнаяИнформация
				|		ПО НазначениеОпросовРеспонденты.Респондент = ПартнерыКонтактнаяИнформация.Ссылка
				|			И (ВЫБОР
				|				КОГДА &ПредназначенаДляПисем
				|					ТОГДА ПодпискиНаРассылкиИОповещенияКлиентам.ВидКИПартнераДляПисем = ПартнерыКонтактнаяИнформация.Вид
				|				ИНАЧЕ ПодпискиНаРассылкиИОповещенияКлиентам.ВидКИПартнераДляSMS = ПартнерыКонтактнаяИнформация.Вид
				|			КОНЕЦ)
				|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Партнеры КАК Партнеры
				|		ПО НазначениеОпросовРеспонденты.Респондент = Партнеры.Ссылка
				|		%СоединениеПоОтбору%
				|ГДЕ
				|	НазначениеОпросовРеспонденты.Ссылка = &НазначениеОпросов"
				
			КонецЕсли;
			
			РассылкиИОповещенияКлиентам.ОбработатьТекстЗапросаПоПартнерамРассылки(Запрос, ТекстЗапросаРеспонденты, Данные, ЕстьОтборПоКомпоновке);
			
		ИначеЕсли ТипЗнч(ДанныеОснования.ТипРеспондентов) = Тип("СправочникСсылка.КонтактныеЛицаПартнеров") Тогда
			
			Если ДанныеОснования.СвободныйОпрос Тогда
				
				ТекстЗапросаРеспонденты = "
				|ВЫБРАТЬ РАЗЛИЧНЫЕ РАЗРЕШЕННЫЕ
				|	КонтактныеЛицаПартнеров.Ссылка КАК Получатель,
				|	ЕСТЬNULL(КонтактныеЛицаПартнеровКонтактнаяИнформация.Представление, """") КАК ПредставлениеКонтактнойИнформации,
				|	ВЫБОР
				|		КОГДА &ПредназначенаДляПисем
				|			ТОГДА ПодпискиНаРассылкиИОповещенияКлиентам.ВидКИКонтактногоЛицаОбъектаОповещенияДляПисем
				|			ИНАЧЕ ПодпискиНаРассылкиИОповещенияКлиентам.ВидКИКонтактногоЛицаОбъектаОповещенияДляSMS
				|	КОНЕЦ КАК ВидКонтактнойИнформации,
				|	КонтактныеЛицаПартнеров.Наименование КАК ПредставлениеПолучателя
				|ПОМЕСТИТЬ Адресаты
				|ИЗ
				|	Справочник.ПодпискиНаРассылкиИОповещенияКлиентам КАК ПодпискиНаРассылкиИОповещенияКлиентам
				|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Партнеры КАК СправочникПартнеры
				|		ПО ПодпискиНаРассылкиИОповещенияКлиентам.Владелец = СправочникПартнеры.Ссылка
				|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.КонтактныеЛицаПартнеров КАК КонтактныеЛицаПартнеров
				|		ПО (СправочникПартнеры.Ссылка = КонтактныеЛицаПартнеров.Владелец)
				|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КонтактныеЛицаПартнеров.КонтактнаяИнформация КАК КонтактныеЛицаПартнеровКонтактнаяИнформация
				|		ПО (КонтактныеЛицаПартнеров.Ссылка = КонтактныеЛицаПартнеровКонтактнаяИнформация.Ссылка)
				|			И (ВЫБОР
				|				КОГДА &ПредназначенаДляПисем
				|					ТОГДА ПодпискиНаРассылкиИОповещенияКлиентам.ВидКИКонтактногоЛицаОбъектаОповещенияДляПисем = КонтактныеЛицаПартнеровКонтактнаяИнформация.Вид
				|				ИНАЧЕ ПодпискиНаРассылкиИОповещенияКлиентам.ВидКИКонтактногоЛицаОбъектаОповещенияДляSMS = КонтактныеЛицаПартнеровКонтактнаяИнформация.Вид
				|			КОНЕЦ)
				|		%СоединениеПоОтбору%
				|ГДЕ
				|	НЕ ПодпискиНаРассылкиИОповещенияКлиентам.ПометкаУдаления
				|	И ПодпискиНаРассылкиИОповещенияКлиентам.ПодпискаДействует
				|	И ПодпискиНаРассылкиИОповещенияКлиентам.ОтправлятьКонтактномуЛицуОбъектаОповещения
				|	И ПодпискиНаРассылкиИОповещенияКлиентам.ГруппаРассылокИОповещений = &ГруппаРассылокИОповещений";

			Иначе
				
				ТекстЗапросаРеспонденты = "
				|ВЫБРАТЬ РАЗЛИЧНЫЕ РАЗРЕШЕННЫЕ
				|	НазначениеОпросовРеспонденты.Респондент КАК Получатель,
				|	ЕСТЬNULL(КонтактныеЛицаПартнеровКонтактнаяИнформация.Представление, """") КАК ПредставлениеКонтактнойИнформации,
				|	ВЫБОР
				|		КОГДА &ПредназначенаДляПисем
				|			ТОГДА ПодпискиНаРассылкиИОповещенияКлиентам.ВидКИКонтактногоЛицаОбъектаОповещенияДляПисем
				|			ИНАЧЕ ПодпискиНаРассылкиИОповещенияКлиентам.ВидКИКонтактногоЛицаОбъектаОповещенияДляSMS
				|	КОНЕЦ КАК ВидКонтактнойИнформации,
				|	КонтактныеЛицаПартнеров.Наименование КАК ПредставлениеПолучателя
				|ПОМЕСТИТЬ Адресаты
				|ИЗ
				|	Документ.НазначениеОпросов.Респонденты КАК НазначениеОпросовРеспонденты
				|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.КонтактныеЛицаПартнеров КАК КонтактныеЛицаПартнеров
				|		ПО НазначениеОпросовРеспонденты.Респондент = КонтактныеЛицаПартнеров.Ссылка
				|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Партнеры КАК Партнеры
				|		ПО КонтактныеЛицаПартнеров.Владелец = Партнеры.Ссылка
				|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ПодпискиНаРассылкиИОповещенияКлиентам КАК ПодпискиНаРассылкиИОповещенияКлиентам
				|			ПО Партнеры.Ссылка = ПодпискиНаРассылкиИОповещенияКлиентам.Владелец
				|				И ПодпискиНаРассылкиИОповещенияКлиентам.ПодпискаДействует
				|				И ПодпискиНаРассылкиИОповещенияКлиентам.ОтправлятьКонтактномуЛицуОбъектаОповещения
				|				И НЕ ПодпискиНаРассылкиИОповещенияКлиентам.ПометкаУдаления
				|				И ПодпискиНаРассылкиИОповещенияКлиентам.ГруппаРассылокИОповещений = &ГруппаРассылокИОповещений
				|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КонтактныеЛицаПартнеров.КонтактнаяИнформация КАК КонтактныеЛицаПартнеровКонтактнаяИнформация
				|		ПО КонтактныеЛицаПартнеров.Ссылка = КонтактныеЛицаПартнеровКонтактнаяИнформация.Ссылка
				|			И (ВЫБОР
				|				КОГДА &ПредназначенаДляПисем
				|					ТОГДА ПодпискиНаРассылкиИОповещенияКлиентам.ВидКИКонтактногоЛицаОбъектаОповещенияДляПисем = КонтактныеЛицаПартнеровКонтактнаяИнформация.Вид
				|				ИНАЧЕ ПодпискиНаРассылкиИОповещенияКлиентам.ВидКИКонтактногоЛицаОбъектаОповещенияДляSMS = КонтактныеЛицаПартнеровКонтактнаяИнформация.Вид
				|			КОНЕЦ)
				|		%СоединениеПоОтбору%
				|ГДЕ
				|	НазначениеОпросовРеспонденты.Ссылка = &НазначениеОпросов"
				
			КонецЕсли;
			
			РассылкиИОповещенияКлиентам.ОбработатьТекстЗапросаПоКонтактнымЛицамРассылки(Запрос, ТекстЗапросаРеспонденты, Данные, ЕстьОтборПоКомпоновке);
		
		КонецЕсли;
		
	КонецЕсли;
	
	Запрос.Текст = Запрос.Текст + ТекстЗапросаРеспонденты;
	Запрос.Текст = Запрос.Текст + "
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////";
	
	Запрос.УстановитьПараметр("НазначениеОпросов", ДанныеОснования.Ссылка); 
	
КонецПроцедуры

&НаСервере
Процедура СформироватьОтчет()
	
	ДанныеРассылки = ДанныеРассылкиКлиентам(Рассылка);
	
	ТаблицаОтчета.Очистить();
	ТаблицаОтчета.АвтоМасштаб = Истина;
	Макет = Документы.РассылкаКлиентам.ПолучитьМакет("СостояниеРассылки");
	
	ОбластьПустаяСтрока = Макет.ПолучитьОбласть("ПустаяСтрока");
	ТаблицаОтчета.Вывести(ОбластьПустаяСтрока);
	
	ТаблицаОтчета.НачатьГруппуСтрок("Легенда");
	
	//Вывод легенды
	ОбластьЛегенда = Макет.ПолучитьОбласть("СтрокаЛегенда");
	ОбластьЛегенда.Параметры.ТекстЛегенды = ТекстЛегенды(ДанныеРассылки);
	ТаблицаОтчета.Вывести(ОбластьЛегенда);
	
	ТаблицаОтчета.ЗакончитьГруппуСтрок();
	
	//Вывод шапки
	ОбластьШапка = Макет.ПолучитьОбласть("СтрокаШапка");
	Если ДанныеРассылки.ПредназначенаДляЭлектронныхПисем Тогда
		ОбластьШапка.Параметры.КонтактнаяИнформация = НСтр("ru='Адреса электронной почты';uk='Адреси електронної пошти'");
	Иначе
		ОбластьШапка.Параметры.КонтактнаяИнформация = НСтр("ru='Телефоны';uk='Телефони'");
	КонецЕсли;
	
	ТаблицаОтчета.Вывести(ОбластьШапка);
	
	Если ТипЗнч(ДанныеРассылки.Основание) = Тип("ДокументСсылка.НазначениеОпросов") И ЗначениеЗаполнено(ДанныеРассылки.Основание) Тогда
		ДанныеОснования = РассылкиИОповещенияКлиентам.ДанныеОснованияНазначениеОпросов(ДанныеРассылки.Основание);
	Иначе
		ДанныеОснования = Неопределено;
	КонецЕсли;
	
	//Формирование запроса
	УстановленОтборПоОснованию = Ложь;
	Запрос = РассылкиИОповещенияКлиентам.ЗапросОтборПоКомпоновке(ДанныеРассылки, УстановленОтборПоОснованию);
	ЕстьОтборПоКомпоновке = Не ПустаяСтрока(Запрос.Текст);
	
	Если ДанныеОснования <> Неопределено И УстановленОтборПоОснованию Тогда
		
		Если ТипЗнч(ДанныеОснования.Ссылка) = Тип("ДокументСсылка.НазначениеОпросов") Тогда
			
			ОбработатьТекстЗапросаАдресатыРассылкиНазначениеОпросов(ДанныеРассылки, ДанныеОснования, Запрос, ЕстьОтборПоКомпоновке);
			
		КонецЕсли;
		
	Иначе
		
		ОбработатьТекстЗапросаАдресатыРассылки(ДанныеРассылки, Запрос, ЕстьОтборПоКомпоновке);
		
	КонецЕсли;
	
	Запрос.УстановитьПараметр("ПредназначенаДляПисем", ДанныеРассылки.ПредназначенаДляЭлектронныхПисем);
	Запрос.УстановитьПараметр("РассылкаКлиентам", ДанныеРассылки.Рассылка);
	
	Если ДанныеРассылки.ПредназначенаДляЭлектронныхПисем Тогда
		
		ТекстЗапросаДокументыВзаимодействий = "
		|ВЫБРАТЬ
		|	Адресаты.Получатель КАК Получатель,
		|	Адресаты.ПредставлениеКонтактнойИнформации,
		|	Адресаты.ВидКонтактнойИнформации,
		|	Адресаты.ПредставлениеПолучателя,
		|	ЕСТЬNULL(КонтактыВзаимодействий.Взаимодействие, НЕОПРЕДЕЛЕНО) КАК Взаимодействие,
		|	ЕСТЬNULL(Взаимодействия.СтатусИсходящегоПисьма, НЕОПРЕДЕЛЕНО) КАК Состояние,
		|	ЕСТЬNULL(Взаимодействия.Дата, НЕОПРЕДЕЛЕНО) КАК ДатаДокумента,
		|	ЕСТЬNULL(Взаимодействия.Номер, НЕОПРЕДЕЛЕНО) КАК НомерДокумента
		|ИЗ
		|	Адресаты КАК Адресаты
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КонтактыВзаимодействий КАК КонтактыВзаимодействий
		|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ ЖурналДокументов.Взаимодействия КАК Взаимодействия
		|			ПО КонтактыВзаимодействий.Взаимодействие = Взаимодействия.Ссылка
		|				И (Взаимодействия.ВзаимодействиеОснование = &РассылкаКлиентам)
		|				И (НЕ Взаимодействия.ПометкаУдаления)
		|		ПО Адресаты.Получатель = КонтактыВзаимодействий.Контакт
		|ИТОГИ ПО
		|	Получатель";
		
	Иначе
		
		ТекстЗапросаДокументыВзаимодействий = "
		|ВЫБРАТЬ
		|	АдресатыРассылки.Получатель КАК Получатель,
		|	АдресатыРассылки.ПредставлениеКонтактнойИнформации,
		|	АдресатыРассылки.ВидКонтактнойИнформации,
		|	АдресатыРассылки.ПредставлениеПолучателя,
		|	ЕСТЬNULL(СообщениеSMSАдресаты.Ссылка, НЕОПРЕДЕЛЕНО) КАК Взаимодействие,
		|	ЕСТЬNULL(СообщениеSMSАдресаты.СостояниеСообщения, НЕОПРЕДЕЛЕНО) КАК Состояние,
		|	ЕСТЬNULL(СообщениеSMSАдресаты.Ссылка.Дата, НЕОПРЕДЕЛЕНО) КАК ДатаДокумента,
		|	ЕСТЬNULL(СообщениеSMSАдресаты.Ссылка.Номер, НЕОПРЕДЕЛЕНО) КАК НомерДокумента
		|ИЗ
		|	Адресаты КАК АдресатыРассылки
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.СообщениеSMS.Адресаты КАК СообщениеSMSАдресаты
		|		ПО АдресатыРассылки.Получатель = СообщениеSMSАдресаты.Контакт
		|			И АдресатыРассылки.ПредставлениеКонтактнойИнформации = СообщениеSMSАдресаты.КакСвязаться
		|			И СообщениеSMSАдресаты.Ссылка.ВзаимодействиеОснование = &РассылкаКлиентам
		|ИТОГИ ПО
		|	Получатель"
		
	КонецЕсли;
		
	Запрос.Текст = Запрос.Текст + ТекстЗапросаДокументыВзаимодействий;
		
	ВыборкаАдресат = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	НомерСтроки = 1;
	
	МассивКИ      = Новый Массив;
	МассивВидовКИ = Новый Массив;
	ОбластьПодписчик = Макет.ПолучитьОбласть("СтрокаПодписчик");

	Пока ВыборкаАдресат.Следующий() Цикл
		
		МассивКИ.Очистить();
		МассивВидовКИ.Очистить();
		
		ВыборкаДетали = ВыборкаАдресат.Выбрать();
		Пока ВыборкаДетали.Следующий() Цикл
			
			РассылкиИОповещенияКлиентам.ДобавитьВМассив(МассивКИ, ВыборкаДетали.ПредставлениеКонтактнойИнформации);
			РассылкиИОповещенияКлиентам.ДобавитьВМассив(МассивВидовКИ, ВыборкаДетали.ВидКонтактнойИнформации);
			Взаимодействие = ?(ЗначениеЗаполнено(Взаимодействие), Взаимодействие,ВыборкаДетали.Взаимодействие);
			ДатаДокумента  = ?(ЗначениеЗаполнено(ДатаДокумента), ДатаДокумента, ВыборкаДетали.ДатаДокумента);
			НомерДокумента = ?(ЗначениеЗаполнено(НомерДокумента), НомерДокумента, ВыборкаДетали.НомерДокумента);
			Состояние      = ВыборкаДетали.Состояние;
			
		КонецЦикла;
		
		ОбластьПодписчик.Параметры.НомерСтроки                 = НомерСтроки;
		ОбластьПодписчик.Параметры.Подписчик                   = ВыборкаАдресат.Получатель;
		ОбластьПодписчик.Параметры.ВидКонтактнойИнформации     = РассылкиИОповещенияКлиентам.СтрокаАдресовИзМассива(МассивВидовКИ, Символы.ПС);;
		ОбластьПодписчик.Параметры.ДокументВзаимодействий      = Взаимодействие;
		ОбластьПодписчик.Параметры.ПредставлениеВзаимодействия = ПредставлениеВзаимодействия(Взаимодействие, НомерДокумента, ДатаДокумента);
		ОбластьПодписчик.Параметры.Состояние                   = Состояние;
		
		КонтактнаяИнформация  = РассылкиИОповещенияКлиентам.СтрокаАдресовИзМассива(МассивКИ, Символы.ПС);
		Если ПустаяСтрока(КонтактнаяИнформация) Тогда
			ОбластьПодписчик.Области.ПодписчикКонтактнаяИнформация.ЦветТекста = ЦветаСтиля.ПоясняющийОшибкуТекст;
			КонтактнаяИнформация = НСтр("ru='не указан';uk='не зазначений'");
		Иначе
			ОбластьПодписчик.Области.ПодписчикКонтактнаяИнформация.ЦветТекста = ОбластьПодписчик.Области.Подписчик.ЦветТекста;
		КонецЕсли;
		
		ОбластьПодписчик.Параметры.КонтактнаяИнформация    = КонтактнаяИнформация;
		ТаблицаОтчета.Вывести(ОбластьПодписчик);
		
		НомерСтроки    = НомерСтроки + 1;
		Взаимодействие = Неопределено;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ДанныеРассылкиКлиентам(РассылкаКлиентам)

	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	РассылкаКлиентам.Ссылка КАК Рассылка,
	|	РассылкаКлиентам.ДатаРассылки,
	|	РассылкаКлиентам.ДатаАктуальности,
	|	РассылкаКлиентам.Основание,
	|	РассылкаКлиентам.ГруппаРассылокИОповещений,
	|	РассылкаКлиентам.ПредназначенаДляЭлектронныхПисем,
	|	РассылкаКлиентам.ПредназначенаДляSMS,
	|	РассылкаКлиентам.ОтборАдресатов,
	|	РассылкаКлиентам.Статус,
	|	РассылкаКлиентам.Ответственный,
	|	ГруппыРассылокИОповещений.ВидКонтактнойИнформацииПартнераДляПисем,
	|	ГруппыРассылокИОповещений.ВидКонтактнойИнформацииПартнераДляSMS,
	|	ГруппыРассылокИОповещений.ВидКонтактнойИнформацииКонтактногоЛицаДляПисем,
	|	ГруппыРассылокИОповещений.ВидКонтактнойИнформацииКонтактногоЛицаДляSMS,
	|	ГруппыРассылокИОповещений.ОтправлятьПартнеру,
	|	ГруппыРассылокИОповещений.ОтправлятьКонтактнымЛицамРоли,
	|	ГруппыРассылокИОповещений.РольКонтактногоЛица,
	|	ГруппыРассылокИОповещений.Принудительная,
	|	ГруппыРассылокИОповещений.ОтправлятьКонтактномуЛицуОбъектаОповещения
	|ИЗ
	|	Документ.РассылкаКлиентам КАК РассылкаКлиентам
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ГруппыРассылокИОповещений КАК ГруппыРассылокИОповещений
	|		ПО РассылкаКлиентам.ГруппаРассылокИОповещений = ГруппыРассылокИОповещений.Ссылка
	|ГДЕ
	|	РассылкаКлиентам.Ссылка = &Рассылка";
	
	Запрос.УстановитьПараметр("Рассылка", РассылкаКлиентам);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	Возврат Выборка;

КонецФункции

&НаСервереБезКонтекста
Функция ПредставлениеВзаимодействия(Взаимодействие, НомерДокумента, ДатаДокумента)
	
	Если Взаимодействие = Неопределено Тогда
		Возврат "";
	КонецЕсли;

	Представление = НСтр("ru='%1 № %2 от %3.';uk='%1 № %2 від %3.'");
	Представление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
	                Представление,
	                ?(ТипЗнч(Взаимодействие) = Тип("ДокументСсылка.СообщениеSMS"), 
	                                                 НСтр("ru='Сообщение SMS';uk='Повідомлення SMS'"),
	                                                 НСтр("ru='Исходящее письмо';uk='Вихідний лист'")),
	                ПрефиксацияОбъектовКлиентСервер.ПолучитьНомерНаПечать(НомерДокумента),
	                Формат(ДатаДокумента, "ДЛФ=DDT"));
	
	Возврат Представление;

КонецФункции

&НаСервереБезКонтекста
Функция ТекстЛегенды(ДанныеРассылки)

	ТекстЛегенды = "";
	
	Если ДанныеРассылки.Статус = Перечисления.СтатусыРассылокКлиентам.Черновик Тогда
		
		ТекстЛегенды = НСтр("ru='Рассылка находится в статусе ""Черновик"". В отчет выведены возможные адресаты рассылки и их контактная информация.
                                   |В случае если контактная информация не указана или указана в некорректном формате, рассылка данным адресатам 
                                   |выполнена не будет. Вы может изменить необходимую контактную информацию, выполнив ""двойной клик"" на получателе рассылки.'
                                   |;uk='Розсилка перебуває в статусі ""Чернетка"". У звіт виведені можливі адресати розсилки і їх контактна інформація.
                                   |У випадку, якщо контактна інформація не зазначена або зазначена в некоректному форматі, розсилка даним адресатам 
                                   |виконана не буде. Ви може змінити контактну інформацію, виконавши ""подвійний клік"" на одержувачі розсилки.'");
		
	ИначеЕсли ДанныеРассылки.Статус = Перечисления.СтатусыРассылокКлиентам.КОтправке Тогда
		
		ТекстЛегенды = НСтр("ru='Рассылка находится в статусе ""К отправке"" и будет выполнена %1
                                  |В отчет выведены возможные адресаты рассылки и их контактная информация.
                                  |В случае если контактная информация не указана или указана в некорректном формате, рассылка данным адресатам 
                                  |выполнена не будет. Вы еще можете изменить  контактную информацию необходимого вида, выполнив ""двойной клик"" на получателе рассылки.'
                                  |;uk='Розсилка перебуває в статусі ""До відправки"" і буде виконана %1
                                  |У звіт виведені можливі адресати розсилки і їх контактна інформація.
                                  |У випадку, якщо контактна інформація не зазначена або зазначена в некоректному форматі, розсилка даним адресатам 
                                  |виконана не буде. Ви ще можете змінити контактну інформацію необхідного виду, виконавши ""подвійний клік"" на одержувачі розсилки.'");
								  
		КодЯзыкаИнтерфейса = Локализация.КодЯзыкаИнтерфейса(); 
		КодЯзыкаДляФормат = Локализация.ОпределитьКодЯзыкаДляФормат(КодЯзыкаИнтерфейса);
								  
		Если ДанныеРассылки.ДатаАктуальности = Дата(1, 1, 1) Тогда
			ТекстПериод = Формат(ДанныеРассылки.ДатаРассылки,"ДЛФ=DD;Л="+КодЯзыкаДляФормат);
		Иначе
			ТекстПериод = НСтр("ru='В период с %1 по %2';uk='У період з %1 по %2'");
			ТекстПериод = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстПериод, 
		                                                                          Формат(ДанныеРассылки.ДатаРассылки,"ДЛФ=DD;Л="+КодЯзыкаДляФормат),
		                                                                          Формат(ДанныеРассылки.ДатаАктуальности,"ДЛФ=DD;Л="+КодЯзыкаДляФормат));
		КонецЕсли;
		
		ТекстЛегенды = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстЛегенды, ТекстПериод);
		
	ИначеЕсли ДанныеРассылки.Статус = Перечисления.СтатусыРассылокКлиентам.Обрабатывается Тогда
		
		ТекстЛегенды = НСтр("ru='Рассылка находится в статусе ""Обрабатывается"". В данный момент создаются сообщения адресатам рассылки.
                                   |В отчет выведены возможные адресаты рассылки и их контактная информация. В случае если контактная информация не
                                   |указана или указана в некорректном формате, сообщения данным адресатам созданы не будут.'
                                   |;uk='Розсилка перебуває в статусі ""Обробляється"". У даний момент створюються повідомлення адресатам розсилки.
                                   |У звіт виведені можливі адресати розсилки і їх контактна інформація. У випадку, якщо контактна інформація не
                                   |зазначена або зазначена в некоректному форматі, повідомлення даними адресатам створені не будуть.'");
		
	ИначеЕсли ДанныеРассылки.Статус = Перечисления.СтатусыРассылокКлиентам.Выполнена Тогда
		
		ТекстЛегенды = НСтр("ru='Рассылка находится в статусе ""Выполнена"". Все возможные сообщения созданы.
                                   |Сообщения не создавались если контактная информация была не указана или указана в некорректном формате.
                                   |Созданные сообщения могут отсутствовать в данном отчете, если истек срок хранения данных сообщений.'
                                   |;uk='Розсилка перебуває в статусі ""Виконана"". Всі можливі повідомлення створені.
                                   |Повідомлення не створювалися, якщо контактна інформація була не зазначена або зазначена в некоректному форматі.
                                   |Створені повідомлення можуть бути в даному звіті, якщо закінчився строк зберігання даних повідомлень.'");
		
	КонецЕсли;
	
	Возврат ТекстЛегенды;

КонецФункции 

#КонецОбласти


