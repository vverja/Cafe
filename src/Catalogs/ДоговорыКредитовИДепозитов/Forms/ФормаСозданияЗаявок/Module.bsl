
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	Если Параметры.Свойство("Договоры") Тогда
		СписокДоговоров.ЗагрузитьЗначения(Параметры.Договоры);
	КонецЕсли;
	
	Если Параметры.Свойство("Контрагенты") Тогда
		СписокКонтрагентов.ЗагрузитьЗначения(Параметры.Контрагенты);
	КонецЕсли;
	
	Если Параметры.Свойство("ИдентификаторФормы") Тогда
		ИдентификаторФормы = Параметры.ИдентификаторФормы;
	КонецЕсли;
	
	ПериодВыборки.Вариант = ВариантСтандартногоПериода.Следующие7Дней;

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьЗаявки(Команда)
	
	Если ЗакрытьФорму Тогда
		Закрыть();
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ПериодВыборки.ДатаНачала) Тогда
		ПоказатьПредупреждение(Неопределено, НСтр("ru='Не указана дата начала периода!';uk='Не зазначена дата початку періоду!'"));
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ПериодВыборки.ДатаОкончания) Тогда
		ПоказатьПредупреждение(Неопределено, НСтр("ru='Не указана дата окончания периода!';uk='Не зазначена дата закінчення періоду!'"));
		Возврат;
	КонецЕсли;
	
	Если ПериодВыборки.ДатаНачала > ПериодВыборки.ДатаОкончания Тогда
		ПоказатьПредупреждение(Неопределено, НСтр("ru='Дата начала периода не может превышать дату окончания периода!';uk='Дата початку періоду не може перевищувати дату закінчення періоду!'"));
		Возврат;
	КонецЕсли;
	
	ТекстСообщения = "";
	
	Создано = СоздатьЗаявкиСервер();
	
	ШаблонТекста = НСтр("ru='Создано %1 документов';uk='Створено %1 документів'");
	ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонТекста, Формат(Создано, "ЧН=0"));
	Элементы.ГруппаПериод.ТолькоПросмотр = Истина;
	ЗакрытьФорму = Истина;
	Элементы.ФормаСоздатьЗаявки.Заголовок = НСтр("ru='Готово';uk='Готово'");
	
КонецПроцедуры

&НаКлиенте
Процедура ТекстСообщенияНажатие(Элемент, СтандартнаяОбработка)
	
	ОткрытьФорму("Документ.ЗаявкаНаРасходованиеДенежныхСредств.Форма.ФормаСпискаДокументов");
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

&НаСервере
Функция СоздатьЗаявкиСервер()
	
	ПараметрыЗаявок = Новый Структура("ДатаНачала, ДатаОкончания, Договоры, Контрагенты");
	ПараметрыЗаявок.ДатаНачала = ПериодВыборки.ДатаНачала;
	ПараметрыЗаявок.ДатаОкончания = ПериодВыборки.ДатаОкончания;
	ПараметрыЗаявок.Контрагенты = СписокКонтрагентов;
	ПараметрыЗаявок.Договоры = СписокДоговоров;
	ПараметрыЗаявок.Вставить("ИдентификаторФормы", ИдентификаторФормы);
	Справочники.ДоговорыКредитовИДепозитов.СоздатьЗаявкиНаРасходДС(ПараметрыЗаявок);
	
	Возврат ПараметрыЗаявок.ВсегоСоздано;
	
КонецФункции

#КонецОбласти

#КонецОбласти
