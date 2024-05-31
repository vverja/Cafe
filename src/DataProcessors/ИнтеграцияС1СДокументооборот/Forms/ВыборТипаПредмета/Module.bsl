#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Дерево = РеквизитФормыВЗначение("ДеревоВариантов");
	
	// Самостоятельные типы предметов.
	ДобавитьСтроку(Дерево, "ФайлСДиска", НСтр("ru='Файл с диска';uk='Файл із диска'"));
	
	// Предметы в ИС.
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ТипОбъектаПотребителя КАК ТипОбъекта,
		|	МАКСИМУМ(Ссылка) КАК Вариант
		|ИЗ
		|	Справочник.ПравилаИнтеграцииС1СДокументооборотом
		|ГДЕ
		|	НЕ ПометкаУдаления
		|СГРУППИРОВАТЬ ПО
		|	ТипОбъектаПотребителя
		|УПОРЯДОЧИТЬ ПО
		|	Вариант
		|");
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Количество() <> 0 Тогда
		НаименованиеИС = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='В %1';uk='У %1'"),
			ИнтеграцияС1СДокументооборот.СокращенноеНаименованиеКонфигурации());
		ЗаголовокИС = ДобавитьСтроку(Дерево,, НаименованиеИС, Истина);
		Пока Выборка.Следующий() Цикл
			ДобавитьСтроку(ЗаголовокИС, Выборка.ТипОбъекта, Выборка.Вариант);
		КонецЦикла;
	КонецЕсли;
	
	// Предметы в ДО.
	ЗаголовокДО = ДобавитьСтроку(Дерево,, НСтр("ru='В Документообороте';uk='У Документообігу'"), Истина);
	ДобавитьСтроку(ЗаголовокДО, "DMFile", НСтр("ru='Файл';uk='Файл'"));
	ДобавитьСтроку(ЗаголовокДО, "DMInternalDocument", НСтр("ru='Внутренний документ';uk='Внутрішній документ'"));
	ДобавитьСтроку(ЗаголовокДО, "DMIncomingDocument", НСтр("ru='Входящий документ';uk='Вхідний документ'"));
	ДобавитьСтроку(ЗаголовокДО, "DMOutgoingDocument", НСтр("ru='Исходящий документ';uk='Вихідний документ'"));
	ДобавитьСтроку(ЗаголовокДО, "DMProject", НСтр("ru='Проект';uk='Проект'"));
	ДобавитьСтроку(ЗаголовокДО, "DMCorrespondent", НСтр("ru='Корреспондент';uk='Кореспондент'"));
	
	ЗначениеВДанныеФормы(Дерево, ДеревоВариантов);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаВыбрать(Команда)
	
	ВыбратьВариант();
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	
	Закрыть(Неопределено);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ДеревоВариантовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ВыбратьВариант();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВыбратьВариант()
	
	ТекущиеДанные = Элементы.ДеревоВариантов.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Или ТекущиеДанные.ЭтоЗаголовок Тогда
		Возврат;
	КонецЕсли;
	
	Закрыть(ТекущиеДанные.Вариант);
	
КонецПроцедуры

&НаСервере
Функция ДобавитьСтроку(Дерево, Вариант = Неопределено, Представление = Неопределено, 
	ЭтоЗаголовок = Ложь)
	
	Строка = Дерево.Строки.Добавить();
	Строка.Вариант = Вариант;
	Строка.Представление = ?(Представление = Неопределено, 
		Строка(Вариант),
		Строка(Представление));
	Строка.ЭтоЗаголовок = ЭтоЗаголовок;
	
	Возврат Строка;
	
КонецФункции

#КонецОбласти