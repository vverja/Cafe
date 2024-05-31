
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);

	Если Параметры.Свойство("Автозаполнение") Тогда
		Объект.Владелец						= Параметры.Владелец;
		Объект.Наименование					= Параметры.Наименование;
		Объект.Должность					= Параметры.Должность;
		Объект.ПравоПодписиПоДоверенности	= Параметры.ПравоПодписиПоДоверенности;
		Объект.ДатаНачала					= Параметры.ДатаНачала;
		Объект.ДокументПраваПодписи			= Параметры.ДокументПраваПодписи;
		Объект.НомерДокументаПраваПодписи	= Параметры.НомерДокументаПраваПодписи;
		Объект.ДатаДокументаПраваПодписи	= Параметры.ДатаДокументаПраваПодписи;
	КонецЕсли;
	
	ПриСозданииЧтенииНаСервере();
	
	Элементы.Владелец.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций");
	
	Если ПолучитьФункциональнуюОпцию("БазоваяВерсия") Тогда
		Элементы.ФизическоеЛицо.Заголовок = НСтр("ru='Сотрудник';uk='Співробітник'");
	КонецЕсли;
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриСозданииЧтенииНаСервере();

	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);

КонецПроцедуры

&НаКлиенте
Процедура  ПослеЗаписи(ПараметрыЗаписи)

	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);
	
	Оповестить("Запись_ФизическиеЛица", , Объект.ФизическоеЛицо);
	Оповестить("Запись_ОтветственныеЛицаОрганизаций", , Объект.Ссылка);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)

	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВидОтветственногоЛицаПриИзменении(Элемент)
	
	Объект.ПравоПодписиПоДоверенности = Булево(ВидОтветственногоЛица);
	
	НаименованиеЗаполнитьСписокВыбора();
	
	УправлениеЭлементамиФормы(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОснованиеПраваПодписиПриИзменении(Элемент)
	
	НаименованиеЗаполнитьСписокВыбора();
	
КонецПроцедуры

&НаКлиенте
Процедура ФизическоеЛицоПриИзменении(Элемент)
	
	
	НаименованиеЗаполнитьСписокВыбора();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветственноеЛицоПриИзменении(Элемент)
	
	Если Не ИспользоватьНачислениеЗарплаты Тогда
		ДолжностиЗаполнитьСписокВыбора();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДолжностьСсылкаПриИзменении(Элемент)
	
	
	Если Объект.ПравоПодписиПоДоверенности Тогда
		НаименованиеЗаполнитьСписокВыбора();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДолжностьПриИзменении(Элемент)
	
	Если Объект.ПравоПодписиПоДоверенности Тогда
		НаименованиеЗаполнитьСписокВыбора();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДокументПраваПодписиПриИзменении(Элемент)
	
	УстановитьОснованиеПраваПодписи();
	
КонецПроцедуры

&НаКлиенте
Процедура НомерДокументаПраваПодписиПриИзменении(Элемент)
	
	УстановитьОснованиеПраваПодписи();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаДокументаПраваПодписиПриИзменении(Элемент)
	
	УстановитьОснованиеПраваПодписи();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриСозданииЧтенииНаСервере()
	
	ВидОтветственногоЛица = Число(Объект.ПравоПодписиПоДоверенности);
	
	ИспользоватьНачислениеЗарплаты = Константы.ИспользоватьНачислениеЗарплаты.Получить();
	
	Если ИспользоватьНачислениеЗарплаты Тогда
		Элементы.ДолжностьСтрока.КнопкаВыпадающегоСписка = Ложь;
	Иначе
		Элементы.ДолжностьСтрока.Заголовок = НСтр("ru='Должность';uk='Посада'");
		ДолжностиЗаполнитьСписокВыбора();
	КонецЕсли;
	
	НаименованиеЗаполнитьСписокВыбора(Ложь);
	ДокументПраваПодписиЗаполнитьСписокВыбора();
	
	УправлениеЭлементамиФормы(ЭтаФорма);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеЭлементамиФормы(Форма)
	
	Если Форма.ВидОтветственногоЛица = 0 Тогда
		Форма.Элементы.ГруппаОснованиеПраваПодписи.ТекущаяСтраница = Форма.Элементы.СтраницаОснованиеПраваПодписиПоУмолчанию;
	Иначе
		Форма.Элементы.ГруппаОснованиеПраваПодписи.ТекущаяСтраница = Форма.Элементы.СтраницаВводОснованияПраваПодписи;
	КонецЕсли;
	
КонецПроцедуры


#Область ЗаполнениеСписковВыбора

&НаСервере
Процедура ДолжностиЗаполнитьСписокВыбора()
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	ОтветственныеЛицаОрганизаций.Должность КАК Должность
	|ИЗ
	|	Справочник.ОтветственныеЛицаОрганизаций КАК ОтветственныеЛицаОрганизаций
	|ГДЕ
	|	ОтветственныеЛицаОрганизаций.Должность <> """"
	|	И ОтветственныеЛицаОрганизаций.ОтветственноеЛицо = &ОтветственноеЛицо
	|	И НЕ ОтветственныеЛицаОрганизаций.ПометкаУдаления
	|
	|УПОРЯДОЧИТЬ ПО
	|	Должность";
	
	Запрос.УстановитьПараметр("ОтветственноеЛицо", Объект.ОтветственноеЛицо);
	
	МассивДолжностей = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Должность");
	Элементы.ДолжностьСтрока.СписокВыбора.ЗагрузитьЗначения(МассивДолжностей);
	
КонецПроцедуры

&НаСервере
Процедура НаименованиеЗаполнитьСписокВыбора(ОчищатьПоле = Истина)
	
	Если ОчищатьПоле Тогда
		Объект.Наименование = "";
	КонецЕсли;
	Элементы.Наименование.СписокВыбора.Очистить();
	
	Если ЗначениеЗаполнено(Объект.ФизическоеЛицо) Тогда
		
		ФамилияИнициалы = ФизическиеЛицаУТ.ФамилияИнициалыФизЛица(Объект.ФизическоеЛицо, Объект.ДатаНачала);
		
		Если Объект.ПравоПодписиПоДоверенности Тогда
			
			Если ЗначениеЗаполнено(Объект.ОснованиеПраваПодписи) Тогда
				Элементы.Наименование.СписокВыбора.Добавить(ФамилияИнициалы + ", " + Объект.ОснованиеПраваПодписи);
				Если ЗначениеЗаполнено(Объект.Должность) Тогда
					Элементы.Наименование.СписокВыбора.Добавить(ФамилияИнициалы + ", " + Объект.Должность + ", " + Объект.ОснованиеПраваПодписи);
				КонецЕсли;
			КонецЕсли;
			
		КонецЕсли;
		
		Элементы.Наименование.СписокВыбора.Добавить(ФамилияИнициалы);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДокументПраваПодписиЗаполнитьСписокВыбора()
	
	КодЯзыкаИнформационнойБазы = Локализация.КодЯзыкаИнформационнойБазы();
	Элементы.ДокументПраваПодписи.СписокВыбора.Очистить();
	Элементы.ДокументПраваПодписи.СписокВыбора.Добавить(НСтр("ru='Доверенность';uk= 'Довіреність'", КодЯзыкаИнформационнойБазы));
	Элементы.ДокументПраваПодписи.СписокВыбора.Добавить(НСтр("ru='Приказ';uk= 'Наказ'", КодЯзыкаИнформационнойБазы));
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура УстановитьОснованиеПраваПодписи()
	
	Объект.ОснованиеПраваПодписи = Объект.ДокументПраваПодписи 
									+ " № "
									+ Объект.НомерДокументаПраваПодписи
									+ " " + НСтр("ru='от';uk='від'") + " "
									+ Формат(Объект.ДатаДокументаПраваПодписи, "ДФ=dd.MM.yyyy") 
									+ " " + НСтр("ru='г.';uk='р.'");
		
	НаименованиеЗаполнитьСписокВыбора();
	
КонецПроцедуры

#КонецОбласти
