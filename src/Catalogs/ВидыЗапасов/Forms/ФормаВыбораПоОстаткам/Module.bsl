
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	Если Параметры.Свойство("Отбор") Тогда
		
		ИспользуетсяСкладОтгрузки = Неопределено;
		Если Параметры.Отбор.Свойство("ИспользуетсяСкладОтгрузки", ИспользуетсяСкладОтгрузки) Тогда
			
			Если Не ИспользуетсяСкладОтгрузки Тогда
				Параметры.Отбор.Удалить("СкладОтгрузки");
			КонецЕсли;
			Параметры.Отбор.Удалить("ИспользуетсяСкладОтгрузки");
			
		КонецЕсли;
		
		Если Параметры.Отбор.Свойство("СкладОтгрузки") Тогда
			Параметры.Отбор.Склад = Параметры.Отбор.СкладОтгрузки;
		КонецЕсли;
		
		Если Параметры.Отбор.Свойство("ДокументРеализации") Тогда
			Если Параметры.Отбор.ДокументРеализации = Неопределено Тогда
				Параметры.Отбор.Удалить("ДокументРеализации");
				ПоДокументуРеализации = Ложь;
			Иначе
				ПоДокументуРеализации = Истина;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	УстановитьПараметрыДинамическогоСписка();
	
	Элементы.Остаток.Видимость = Не ПоДокументуРеализации;
	Элементы.Продано.Видимость = ПоДокументуРеализации;

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	СтрокаТаблицы = Элемент.ТекущиеДанные;
	Если СтрокаТаблицы <> Неопределено Тогда
		ОповеститьОВыборе(СтрокаТаблицы.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

&НаСервере
Процедура УстановитьПараметрыДинамическогоСписка()
	
	Список.Параметры.УстановитьЗначениеПараметра("ПоДокументуРеализации", ПоДокументуРеализации);
	Если ЗначениеЗаполнено(ДокументРеализации) Тогда
		МоментВремени = ДокументРеализации.МоментВремени();
	Иначе
		МоментВремени = Дата(1, 1, 1);
	КонецЕсли;
	Список.Параметры.УстановитьЗначениеПараметра("МоментВремени", МоментВремени);
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
