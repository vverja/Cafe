////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	КешМетаданныхДерево = Обработки.НачальноеЗаполнениеИОбновлениеОбъектов.ПолучитьДеревоОбъектовСНачальнымЗаполнением();
	
	СписокВыбора = Элементы.ТипОбъекта.СписокВыбора;
	СписокВыбора.Добавить("ВсеОбъекты", НСтр("ru='Все объекты';uk='Всі об''єкти'"));
	Для каждого СтрокаОписанияРазделаМетаданных Из КешМетаданныхДерево.Строки Цикл
		СписокВыбора.Добавить(СтрокаОписанияРазделаМетаданных.Имя, СтрокаОписанияРазделаМетаданных.Представление);
	КонецЦикла;
	
	ЗначениеВРеквизитФормы(КешМетаданныхДерево, "КешМетаданных");
	
	ОбработатьУстановкуТипаОбъекта();
	
	УстановитьДоступность(ЭтаФорма);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ТипОбъектаПриИзменении(Элемент)
	
	ОбработатьУстановкуТипаОбъекта();
	
	УстановитьДоступность(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеОбъектаПриИзменении(Элемент)
	
	УстановитьДоступность(ЭтаФорма);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура КомандаЗаполнить(Команда)
	
	ЗаполнитьНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОткрытьФормуОбъекта(Команда)
	
	ОткрытьФорму(ТипОбъекта+"."+НаименованиеОбъекта+".ФормаСписка");
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступность(ЭтаФорма)
	
	НеобходимоУказатьКонкретныйОбъект = ЗначениеЗаполнено(ЭтаФорма.ТипОбъекта) И ЭтаФорма.ТипОбъекта <> "ВсеОбъекты";
	УказанКонкретныйОбъект            = НеобходимоУказатьКонкретныйОбъект И ЗначениеЗаполнено(ЭтаФорма.НаименованиеОбъекта);
	ТипОбъектаСодержитРегистрСведений = ЭтаФорма.ТипОбъекта = "РегистрСведений" ИЛИ ЭтаФорма.ТипОбъекта = "ВсеОбъекты";
	ТипОбъектаСодержитСправочник = ЭтаФорма.ТипОбъекта = "Справочник" ИЛИ ЭтаФорма.ТипОбъекта = "ВсеОбъекты";
	
	Элементы = ЭтаФорма.Элементы;
	
	Элементы.Заполнить.Доступность = УказанКонкретныйОбъект ИЛИ (ЭтаФорма.ТипОбъекта = "ВсеОбъекты");
	Элементы.Открыть.Доступность   = УказанКонкретныйОбъект;
	
	Элементы.НаименованиеОбъекта.Доступность = НеобходимоУказатьКонкретныйОбъект;	
	
	Элементы.ОчиститьРегистрыСведенийПередЗаписью.Доступность = ТипОбъектаСодержитРегистрСведений;
	Элементы.ЗаполнитьНеПредопределенные.Доступность = ТипОбъектаСодержитСправочник;
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьУстановкуТипаОбъекта()
	
	КешМетаданныхДерево = РеквизитФормыВЗначение("КешМетаданных");
	
	НаименованиеОбъекта = "";
	ОчиститьРегистрыСведенийПередЗаписью = Ложь;
		
	СписокВыбора = Элементы.НаименованиеОбъекта.СписокВыбора;
	СписокВыбора.Очистить();
	Если ЗначениеЗаполнено(ЭтаФорма.ТипОбъекта) И ЭтаФорма.ТипОбъекта <> "ВсеОбъекты" Тогда
		СтрокаДереваСНужнымРазделом = КешМетаданныхДерево.Строки.Найти(ЭтаФорма.ТипОбъекта, "Имя", Ложь);
		Для каждого ИмяОбъектаМетаданных из СтрокаДереваСНужнымРазделом.Строки Цикл
			СписокВыбора.Добавить(ИмяОбъектаМетаданных.Имя, ИмяОбъектаМетаданных.Представление);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНаСервере()
	
	Если ТипОбъекта = "ВсеОбъекты" Тогда
		Обработки.НачальноеЗаполнениеИОбновлениеОбъектов.ЗаполнитьВсеОбъекты(ОчиститьРегистрыСведенийПередЗаписью, Объект.ЗаполнитьПредопределенные, Объект.ЗаполнитьНеПредопределенные);
	Иначе	
		Обработки.НачальноеЗаполнениеИОбновлениеОбъектов.ЗаполнитьОбъект(ТипОбъекта, НаименованиеОбъекта, ОчиститьРегистрыСведенийПередЗаписью, Объект.ЗаполнитьПредопределенные, Объект.ЗаполнитьНеПредопределенные);
	КонецЕсли;	
	
Конецпроцедуры


	
