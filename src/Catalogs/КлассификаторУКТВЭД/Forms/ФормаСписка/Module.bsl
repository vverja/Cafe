#Область ОбработчикиСобытийТаблицыФормыСписок

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	
	Текст = НСтр("ru='Есть возможность подобрать из классификатора УКТВЭД
        |Подобрать?'
        |;uk='Є можливість підібрати з класифікатора УКТЗЕД
        |Підібрати?'");
		
	ДополнительныеПараметры = Новый Структура;
	Если Копирование Тогда
		//ЗначенияЗаполнения = Новый Структура;
		//ЗначенияЗаполнения.Вставить("Код", 					Элемент.ТекущиеДанные.Код);
		//ЗначенияЗаполнения.Вставить("Наименование", 		Элемент.ТекущиеДанные.Наименование);
		//ЗначенияЗаполнения.Вставить("НаименованиеПолное",	Элемент.ТекущиеДанные.НаименованиеПолное);
		//ДополнительныеПараметры.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
		ДополнительныеПараметры.Вставить("ЗначениеКопирования", Элемент.ТекущиеДанные.Ссылка);
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("ВопросПодобратьЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	ПоказатьВопрос(Оповещение, Текст, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПодобратьИзКлассификатора(Команда)
	
	ОткрытьФорму("Справочник.КлассификаторУКТВЭД.Форма.ФормаПодбораИзКлассификатора",,ЭтаФорма,,,,Новый ОписаниеОповещения("ПодобратьИзКлассификатораЗавершение", ЭтотОбъект),РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодобратьИзКлассификатораЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    Элементы.Список.Обновить();
    
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнениеВидаКодов(Команда)
	
	ОткрытьФорму("Справочник.КлассификаторУКТВЭД.Форма.ЗаполнениеВидаКодов",, ЭтаФорма,,,, Новый ОписаниеОповещения("ПодобратьИзКлассификатораЗавершение", ЭтотОбъект), РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВопросПодобратьЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ПодобратьИзКлассификатора(Неопределено);
	Иначе
		ОткрытьФорму("Справочник.КлассификаторУКТВЭД.Форма.ФормаЭлемента", ДополнительныеПараметры, ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


