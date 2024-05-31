
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ОбменДаннымиСервер.ФормаНастройкиУзлаПриСозданииНаСервере(ЭтаФорма, "ОбменУправлениеТорговлейРозница");
	
	ПолучитьЗначенияФильтров();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьВидимость();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	ОбменДаннымиКлиент.ФормаНастройкиПередЗакрытием(Отказ, ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИспользоватьОтборПриИзменении(Элемент)
	УстановитьВидимость();	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьОтборПоОрганизациямПриИзменении(Элемент)
	
	ПриИзмененииИспользоватьОтборПоОрганизациям();
	УстановитьВидимость();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыОрганизации

&НаКлиенте
Процедура ОрганизацииВыбранПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Организации.ТекущиеДанные;
	СтруктураДанных = Новый Структура;
	СтруктураДанных.Вставить("Организация", ТекущаяСтрока.Организация);
	СтруктураДанных.Вставить("Выбран", ТекущаяСтрока.Выбран);
	
	ВыбранОрганизацияПриИзмененииСервер(СтруктураДанных);
	
КонецПроцедуры

&НаКлиенте
Процедура МагазиныВыбранПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Магазины.ТекущиеДанные;
	СтруктураДанных = Новый Структура;
	СтруктураДанных.Вставить("Магазин", ТекущаяСтрока.Магазин);
	СтруктураДанных.Вставить("Выбран", ТекущаяСтрока.Выбран);	
	
	ВыбранМагазинПриИзмененииСервер(СтруктураДанных);
	 
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	
	ПодготовитьДанныеДляЗакрытияФормы();	
	ОбменДаннымиКлиент.ФормаНастройкиУзлаКомандаЗакрытьФорму(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПриИзмененииРеквизитов

&НаСервере
Процедура ВыбранМагазинПриИзмененииСервер(СтруктураДанных)
	
	Если СтруктураДанных.Выбран Тогда
		СтрокаАналитики = СоответствияАналитикиОбмена.Добавить();
		СтрокаАналитики.Магазин  = СтруктураДанных.Магазин;
	Иначе
		МассивСтрок = СоответствияАналитикиОбмена.НайтиСтроки(Новый Структура("Магазин",СтруктураДанных.Магазин));
		Для каждого СтрокаТЧ Из МассивСтрок Цикл
			СоответствияАналитикиОбмена.Удалить(СтрокаТЧ);
		КонецЦикла;	
	КонецЕсли;	
	
	СоответствияАналитикиОбмена.Сортировать("Магазин");
	
КонецПроцедуры

&НаСервере
Процедура ВыбранОрганизацияПриИзмененииСервер(СтруктураДанных)
		
	МассивСтрок = Кассы.НайтиСтроки(Новый Структура("Организация", СтруктураДанных.Организация));
	Для каждого СтрокаТЧ Из МассивСтрок Цикл 
		СтрокаТЧ.ДоступнаДляВыбора = СтруктураДанных.Выбран;
		Если НЕ СтруктураДанных.Выбран Тогда
			СтрокаТЧ.Выбран = Ложь;
		КонецЕсли;	
	КонецЦикла;		
	
КонецПроцедуры	

&НаСервере
Процедура ПриИзмененииИспользоватьОтборПоОрганизациям()
	
	Если ИспользоватьОтборПоОрганизациям Тогда
		Для каждого СтрокаТЧ Из Кассы Цикл
			СтрокаТЧ.ДоступнаДляВыбора = Ложь;
			СтрокаТЧ.Выбран = Ложь;
		КонецЦикла;	 		
	Иначе
		Для каждого СтрокаТЧ Из Организации Цикл
			СтрокаТЧ.Выбран = Ложь;
		КонецЦикла;	
		Для каждого СтрокаТЧ Из Кассы Цикл
			СтрокаТЧ.ДоступнаДляВыбора = Истина;
		КонецЦикла;	
	КонецЕсли;	
	
КонецПроцедуры	

#КонецОбласти

#Область Прочее

&НаСервере
Процедура ПолучитьЗначенияФильтров()
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	Магазины.Магазин
	                      |ПОМЕСТИТЬ Магазины
	                      |ИЗ
	                      |	&Магазины КАК Магазины
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	Организации.Организация
	                      |ПОМЕСТИТЬ Организации
	                      |ИЗ
	                      |	&Организации КАК Организации
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	ВидыЦен.ВидЦен
	                      |ПОМЕСТИТЬ ВидыЦен
	                      |ИЗ
	                      |	&ВидыЦен КАК ВидыЦен
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	КассыМагазинов.Касса
	                      |ПОМЕСТИТЬ КассыМагазинов
	                      |ИЗ
	                      |	&КассыМагазинов КАК КассыМагазинов
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	Кассы.Касса
	                      |ПОМЕСТИТЬ Кассы
	                      |ИЗ
	                      |	&Кассы КАК Кассы
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	Склады.Ссылка КАК Магазин,
	                      |	ВЫБОР
	                      |		КОГДА Магазины.Магазин ЕСТЬ NULL 
	                      |			ТОГДА ЛОЖЬ
	                      |		ИНАЧЕ ИСТИНА
	                      |	КОНЕЦ КАК Выбран
	                      |ИЗ
	                      |	Справочник.Склады КАК Склады
	                      |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ВидыЦен КАК ВидыЦен
	                      |		ПО Склады.РозничныйВидЦены = ВидыЦен.Ссылка
	                      |			И (ВидыЦен.ВалютаЦены = &ВалютаРегламентированногоУчета)
	                      |		ЛЕВОЕ СОЕДИНЕНИЕ Магазины КАК Магазины
	                      |		ПО (Магазины.Магазин = Склады.Ссылка)
	                      |ГДЕ
	                      |	НЕ Склады.ЭтоГруппа
	                      |	И НЕ Склады.ПометкаУдаления
	                      |	И Склады.ТипСклада = ЗНАЧЕНИЕ(Перечисление.ТипыСкладов.РозничныйМагазин)
	                      |	И Склады.ВыборГруппы = ЗНАЧЕНИЕ(Перечисление.ВыборГруппыСкладов.Запретить)
	                      |	И (Склады.Родитель = ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)
	                      |			ИЛИ Склады.Родитель.ВыборГруппы = ЗНАЧЕНИЕ(Перечисление.ВыборГруппыСкладов.Запретить))
	                      |	И НЕ Склады.ИспользоватьАдресноеХранение
	                      |	И НЕ Склады.ИспользоватьАдресноеХранениеСправочно
	                      |	И Склады.НастройкаАдресногоХранения = ЗНАЧЕНИЕ(Перечисление.НастройкиАдресногоХранения.НеИспользовать)
	                      |	И НЕ Склады.ИспользоватьСкладскиеПомещения
	                      |	И НЕ Склады.КонтролироватьОперативныеОстатки
	                      |	И НЕ Склады.ИспользоватьСерииНоменклатуры
	                      |
	                      |УПОРЯДОЧИТЬ ПО
	                      |	Склады.Наименование
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	СправочникКассы.Ссылка КАК Касса,
	                      |	СправочникКассы.Владелец КАК Организация,
	                      |	ВЫБОР
	                      |		КОГДА &ИспользоватьОтборПоОрганизациям
	                      |			ТОГДА ВЫБОР
	                      |					КОГДА Организации.Организация ЕСТЬ NULL 
	                      |						ТОГДА ЛОЖЬ
	                      |					ИНАЧЕ ИСТИНА
	                      |				КОНЕЦ
	                      |		ИНАЧЕ ИСТИНА
	                      |	КОНЕЦ КАК ДоступнаДляВыбора,
	                      |	ВЫБОР
	                      |		КОГДА Кассы.Касса ЕСТЬ NULL 
	                      |			ТОГДА ЛОЖЬ
	                      |		ИНАЧЕ ИСТИНА
	                      |	КОНЕЦ КАК Выбран
	                      |ИЗ
	                      |	Справочник.Кассы КАК СправочникКассы
	                      |		ЛЕВОЕ СОЕДИНЕНИЕ Кассы КАК Кассы
	                      |		ПО (Кассы.Касса = СправочникКассы.Ссылка)
	                      |		ЛЕВОЕ СОЕДИНЕНИЕ Организации КАК Организации
	                      |		ПО (Организации.Организация = СправочникКассы.Владелец)
	                      |ГДЕ
	                      |	НЕ СправочникКассы.ПометкаУдаления
	                      |	И СправочникКассы.ВалютаДенежныхСредств = &ВалютаРегламентированногоУчета
	                      |
	                      |УПОРЯДОЧИТЬ ПО
	                      |	СправочникКассы.Наименование
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	СправочникКассы.Ссылка КАК Касса,
	                      |	СправочникКассы.Владелец КАК Организация,
	                      |	ВЫБОР
	                      |		КОГДА КассыМагазинов.Касса ЕСТЬ NULL 
	                      |			ТОГДА ЛОЖЬ
	                      |		ИНАЧЕ ИСТИНА
	                      |	КОНЕЦ КАК Выбран
	                      |ИЗ
	                      |	Справочник.Кассы КАК СправочникКассы
	                      |		ЛЕВОЕ СОЕДИНЕНИЕ КассыМагазинов КАК КассыМагазинов
	                      |		ПО (КассыМагазинов.Касса = СправочникКассы.Ссылка)
	                      |ГДЕ
	                      |	НЕ СправочникКассы.ПометкаУдаления
	                      |	И СправочникКассы.ВалютаДенежныхСредств = &ВалютаРегламентированногоУчета
	                      |
	                      |УПОРЯДОЧИТЬ ПО
	                      |	СправочникКассы.Наименование
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	СправочникВидыЦен.Ссылка КАК ВидЦен,
	                      |	ВЫБОР
	                      |		КОГДА ВидыЦен.ВидЦен ЕСТЬ NULL 
	                      |			ТОГДА ЛОЖЬ
	                      |		ИНАЧЕ ИСТИНА
	                      |	КОНЕЦ КАК Выбран
	                      |ИЗ
	                      |	Справочник.ВидыЦен КАК СправочникВидыЦен
	                      |		ЛЕВОЕ СОЕДИНЕНИЕ ВидыЦен КАК ВидыЦен
	                      |		ПО (ВидыЦен.ВидЦен = СправочникВидыЦен.Ссылка)
	                      |ГДЕ
	                      |	НЕ СправочникВидыЦен.ПометкаУдаления
	                      |	И СправочникВидыЦен.ВалютаЦены = &ВалютаРегламентированногоУчета
	                      |
	                      |УПОРЯДОЧИТЬ ПО
	                      |	СправочникВидыЦен.Наименование
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	СправочникОрганизации.Ссылка КАК Организация,
	                      |	ВЫБОР
	                      |		КОГДА Организации.Организация ЕСТЬ NULL 
	                      |			ТОГДА ЛОЖЬ
	                      |		ИНАЧЕ ИСТИНА
	                      |	КОНЕЦ КАК Выбран
	                      |ИЗ
	                      |	Справочник.Организации КАК СправочникОрганизации
	                      |		ЛЕВОЕ СОЕДИНЕНИЕ Организации КАК Организации
	                      |		ПО (Организации.Организация = СправочникОрганизации.Ссылка)
	                      |ГДЕ
	                      |	НЕ СправочникОрганизации.ПометкаУдаления
	                      |
	                      |УПОРЯДОЧИТЬ ПО
	                      |	СправочникОрганизации.Наименование");
	Запрос.УстановитьПараметр("ВалютаРегламентированногоУчета", Константы.ВалютаРегламентированногоУчета.Получить());
	Запрос.УстановитьПараметр("Магазины", Магазины.Выгрузить());
	Запрос.УстановитьПараметр("Кассы", Кассы.Выгрузить());
	Запрос.УстановитьПараметр("КассыМагазинов", КассыМагазинов.Выгрузить());
	Запрос.УстановитьПараметр("Организации", Организации.Выгрузить());
	Запрос.УстановитьПараметр("ВидыЦен", ВидыЦен.Выгрузить());
	Запрос.УстановитьПараметр("ИспользоватьОтборПоОрганизациям",ИспользоватьОтборПоОрганизациям);
	РезультатыЗапроса = Запрос.ВыполнитьПакет();
	Магазины.Загрузить(РезультатыЗапроса[5].Выгрузить());
	Кассы.Загрузить(РезультатыЗапроса[6].Выгрузить());
	КассыМагазинов.Загрузить(РезультатыЗапроса[7].Выгрузить());
	ВидыЦен.Загрузить(РезультатыЗапроса[8].Выгрузить());	
	Организации.Загрузить(РезультатыЗапроса[9].Выгрузить());	
		
КонецПроцедуры	

&НаКлиенте
Процедура УстановитьВидимость()
	
	Элементы.Кассы.Видимость = ИспользоватьОтборПоКассам;
	Элементы.ВидыЦен.Видимость = ИспользоватьОтборПоВидамЦен;
	Элементы.Организации.Видимость = ИспользоватьОтборПоОрганизациям;
	
КонецПроцедуры

&НаСервере
Процедура ПодготовитьДанныеДляЗакрытияФормы()
	
	Если ИспользоватьОтборПоОрганизациям Тогда
		УдалитьСтрокиИзТЧ("Организации");
	Иначе
		Организации.Очистить();
	КонецЕсли;
	
	Если ИспользоватьОтборПоКассам Тогда
		УдалитьСтрокиИзТЧ("Кассы");
	Иначе
		Кассы.Очистить();
	КонецЕсли;
	
	Если ИспользоватьОтборПоВидамЦен Тогда
		УдалитьСтрокиИзТЧ("ВидыЦен");
	Иначе
		ВидыЦен.Очистить();
	КонецЕсли;	
	
	УдалитьСтрокиИзТЧ("КассыМагазинов");
	УдалитьСтрокиИзТЧ("Магазины");
	
КонецПроцедуры	

&НаСервере
Процедура УдалитьСтрокиИзТЧ(ИмяТЧ)
	
	МассивСтрок = ЭтаФорма[ИмяТЧ].НайтиСтроки(Новый Структура("Выбран", Ложь));
	Для каждого СтрокаТЧ Из МассивСтрок Цикл
		ЭтаФорма[ИмяТЧ].Удалить(СтрокаТЧ);
	КонецЦикла;	
	
КонецПроцедуры	

#КонецОбласти

#КонецОбласти
