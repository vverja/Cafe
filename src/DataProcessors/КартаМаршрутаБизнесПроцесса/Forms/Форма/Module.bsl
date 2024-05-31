
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.БизнесПроцесс) Тогда
		БизнесПроцесс = Параметры.БизнесПроцесс;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ОбновитьКартуМаршрута();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура БизнесПроцессПриИзменении(Элемент)
	ОбновитьКартуМаршрута();
КонецПроцедуры

&НаКлиенте
Процедура КартаМаршрутаВыбор(Элемент)
	ОткрытьСписокЗадачТочкиМаршрута();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОбновитьВыполнить(Команда)
	ОбновитьКартуМаршрута();   
КонецПроцедуры

&НаКлиенте
Процедура ЗадачиВыполнить(Команда)
	ОткрытьСписокЗадачТочкиМаршрута();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбновитьКартуМаршрута()
	
	Если ЗначениеЗаполнено(БизнесПроцесс) Тогда
		КартаМаршрута = БизнесПроцесс.ПолучитьОбъект().ПолучитьКартуМаршрута();
	ИначеЕсли БизнесПроцесс <> Неопределено Тогда
		КартаМаршрута = БизнесПроцессы[БизнесПроцесс.Метаданные().Имя].ПолучитьКартуМаршрута();
		Возврат;
	Иначе
		КартаМаршрута = Новый ГрафическаяСхема;
		Возврат;
	КонецЕсли;
	
	Для Каждого Элемент Из КартаМаршрута.ЭлементыГрафическойСхемы Цикл
		Если ТипЗнч(Элемент) = Тип("ЭлементГрафическойСхемыДействие") Тогда
			Элемент.Пояснение = Элемент.Значение.РольИсполнителя.Наименование;
		КонецЕсли;
	КонецЦикла;
	
	ЕстьСостояние = БизнесПроцесс.Метаданные().Реквизиты.Найти("Состояние") <> Неопределено;
	СвойстваБизнесПроцесса = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
		БизнесПроцесс, "Автор,Дата,ДатаЗавершения,Завершен,Стартован" 
		+ ?(ЕстьСостояние, ",Состояние", ""));
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, СвойстваБизнесПроцесса);
	Если СвойстваБизнесПроцесса.Завершен Тогда
		Статус = НСтр("ru='Завершен';uk='Завершений'");
		Элементы.ГруппаСтатус.ТекущаяСтраница = Элементы.ГруппаЗавершен;
	ИначеЕсли СвойстваБизнесПроцесса.Стартован Тогда
		Статус = НСтр("ru='Стартован';uk='Стартований'");
		Элементы.ГруппаСтатус.ТекущаяСтраница = Элементы.ГруппаНеЗавершен;
	Иначе	
		Статус = НСтр("ru='Не стартован';uk='Не стартував'");
		Элементы.ГруппаСтатус.ТекущаяСтраница = Элементы.ГруппаНеЗавершен;
	КонецЕсли;
	Если ЕстьСостояние Тогда
		Статус = Статус + ", " + НРег(Состояние);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСписокЗадачТочкиМаршрута()

#Если ВебКлиент Тогда
	ПоказатьПредупреждение(,НСтр("ru='Данная операция недоступна в веб-клиенте.';uk='Дана операція недоступна у веб-клиенте.'"));
	Возврат;
#КонецЕсли
	ОчиститьСообщения();
	ТекЭлемент = Элементы.КартаМаршрута.ТекущийЭлемент;

	Если Не ЗначениеЗаполнено(БизнесПроцесс) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru='Необходимо указать бизнес-процесс.';uk='Необхідно вказати бізнес-процес.'"),,
			"БизнесПроцесс");
		Возврат;
	КонецЕсли;
	
	Если ТекЭлемент = Неопределено 
		Или	НЕ (ТипЗнч(ТекЭлемент) = Тип("ЭлементГрафическойСхемыДействие")
		Или ТипЗнч(ТекЭлемент) = Тип("ЭлементГрафическойСхемыВложенныйБизнесПроцесс")) Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru='Для просмотра списка задач необходимо выбрать точку действия или вложенный бизнес-процесс карты маршрута.';uk='Для перегляду списку задач необхідно вибрати точку дії або вкладений бізнес-процес карти маршруту.'"),,
			"КартаМаршрута");
		Возврат;
	КонецЕсли;

	ЗаголовокФормы = НСтр("ru='Задачи по точке маршрута бизнес-процесса';uk='Задачі по точці маршруту бізнес-процесу'");
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Отбор", Новый Структура("БизнесПроцесс,ТочкаМаршрута", БизнесПроцесс, ТекЭлемент.Значение));
	ПараметрыФормы.Вставить("ЗаголовокФормы", ЗаголовокФормы);
	ПараметрыФормы.Вставить("ПоказыватьЗадачи", 0);
	ПараметрыФормы.Вставить("ВидимостьОтборов", Ложь);
	ПараметрыФормы.Вставить("БлокировкаОкнаВладельца", РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	ПараметрыФормы.Вставить("Задача", Строка(ТекЭлемент.Значение));
	ПараметрыФормы.Вставить("БизнесПроцесс", Строка(БизнесПроцесс));
	ОткрытьФорму("Задача.ЗадачаИсполнителя.ФормаСписка", ПараметрыФормы, ЭтотОбъект, БизнесПроцесс);

КонецПроцедуры

#КонецОбласти
