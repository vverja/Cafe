
#Область ПрограммныйИнтерфейс

Процедура ВыполнитьКомандуОтчет(ИмяФормыОтчета, ПараметрКоманды, ВладелецФормы, ПараметрыОтчет = Неопределено) Экспорт
	
	// Проверим количество объектов.
	Если НЕ ПроверитьКоличествоПереданныхОбъектов(ПараметрКоманды) Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОткрытия = Новый Структура("ИмяФормыОтчета,ПараметрКоманды,ПараметрыОтчет,СформироватьПриОткрытии,Отбор,КлючВарианта");
	ПараметрыОткрытия.ИмяФормыОтчета	= ИмяФормыОтчета;
	ПараметрыОткрытия.ПараметрыОтчет	= ПараметрыОтчет;
	ПараметрыОткрытия.СформироватьПриОткрытии = Истина;
	ПараметрыОткрытия.ПараметрКоманды	= ПараметрКоманды;
	
	ОбщегоНазначенияКлиентСервер.ДополнитьСтруктуру(ПараметрыОткрытия, ПараметрыОтчет.ПараметрыФормы, Истина);
	
	ОткрытьФорму(ИмяФормыОтчета, ПараметрыОткрытия, ВладелецФормы, ПараметрКоманды);
	
КонецПроцедуры

Процедура ВыполнитьПодключаемуюКомандуОтчет(Знач Команда, Знач Форма, Знач Источник) Экспорт
	
	ОписаниеКоманды = Команда;
	Если ТипЗнч(Команда) = Тип("КомандаФормы") Тогда
		ОписаниеКоманды = ОписаниеКомандыОтчет(Команда.Имя, Форма.Команды.Найти("АдресКомандОтчетовВоВременномХранилище").Действие);
	КонецЕсли;
	
	Если ТипЗнч(Источник) = Тип("ТаблицаФормы") и ЗначениеЗаполнено(ОписаниеКоманды.ИмяСписка) Тогда
		Источник = Форма.Элементы[ОписаниеКоманды.ИмяСписка];
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ОписаниеКоманды", ОписаниеКоманды);
	ДополнительныеПараметры.Вставить("Форма", Форма);
	ДополнительныеПараметры.Вставить("Источник", Источник);
	
	Если ТипЗнч(Источник) = Тип("ДанныеФормыСтруктура")
		И (Источник.Ссылка.Пустая() или ОписаниеКоманды.ВыполнятьЗаписьВФорме)
		И (Источник.Ссылка.Пустая() Или Форма.Модифицированность) Тогда
		
		Если Источник.Ссылка.Пустая() Тогда
			ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Данные еще не записаны.
                    |Выполнение действия ""%1"" возможно только после записи данных.
                    |Данные будут записаны.'
                    |;uk='Дані ще не записані.
                    |Виконання дії ""%1"" можливе тільки після запису даних.
                    |Дані будуть записані.'"),
				ОписаниеКоманды.Представление);
				
			ОписаниеОповещения = Новый ОписаниеОповещения("ВыполнитьПодключаемуюКомандуОтчетПодтверждениеЗаписи", МенюОтчетыСлужебныйКлиент, ДополнительныеПараметры);
			ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ОКОтмена);
			Возврат;
		КонецЕсли;
		МенюОтчетыСлужебныйКлиент.ВыполнитьПодключаемуюКомандуОтчетПодтверждениеЗаписи(КодВозвратаДиалога.ОК, ДополнительныеПараметры);
		Возврат;
	КонецЕсли;
	
	МенюОтчетыСлужебныйКлиент.ВыполнитьПодключаемуюКомандуОтчетПодтверждениеЗаписи(Неопределено, ДополнительныеПараметры);
	
КонецПроцедуры

// Устанавливает свойство видимость для элемента формы
Процедура УстановитьВидимостьЭлементаФормыКлиент(Форма, ПолноеИмяЭлемента, Видимость) Экспорт
	
	Для каждого ТекЭлемент Из Форма.Элементы Цикл
		
		МассивПодстрок = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ТекЭлемент.Имя, "_");
		МассивПодстрок.Удалить(0);
		
		ИмяЭлемента = СтроковыеФункцииКлиентСервер.СтрокаИзМассиваПодстрок(МассивПодстрок, "_");
		ИмяЭлемента = СтрЗаменить(ИмяЭлемента, "_", ".");
		
		Если ИмяЭлемента = ПолноеИмяЭлемента Тогда
			ТекЭлемент.Видимость = Видимость;
		КонецЕсли;
		
	КонецЦикла; 
	
КонецПроцедуры

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

Функция ОписаниеКомандыОтчет(ИмяКоманды, АдресКомандОтчетовВоВременномХранилище)
	
	Возврат МенюОтчетыКлиентПовтИсп.ОписаниеКомандыОтчет(ИмяКоманды, АдресКомандОтчетовВоВременномХранилище);
	
КонецФункции

Функция ПроверитьКоличествоПереданныхОбъектов(ПараметрКоманды)
	
	Если ТипЗнч(ПараметрКоманды) = Тип("Массив") И ПараметрКоманды.Количество() = 0 Тогда
		Возврат Ложь;
	Иначе
		Возврат Истина;
	КонецЕсли;
	
КонецФункции

Процедура ПроверитьПроведенностьДокументов(ОписаниеПроцедурыЗавершения, СписокДокументов, Форма = Неопределено) Экспорт
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ОписаниеПроцедурыЗавершения", ОписаниеПроцедурыЗавершения);
	ДополнительныеПараметры.Вставить("СписокДокументов", СписокДокументов);
	ДополнительныеПараметры.Вставить("Форма", Форма);
	
	НепроведенныеДокументы = ОбщегоНазначенияВызовСервера.ПроверитьПроведенностьДокументов(СписокДокументов);
	ЕстьНепроведенныеДокументы = НепроведенныеДокументы.Количество() > 0;
	Если ЕстьНепроведенныеДокументы Тогда
		ДополнительныеПараметры.Вставить("НепроведенныеДокументы", НепроведенныеДокументы);
		МенюОтчетыСлужебныйКлиент.ПроверитьПроведенностьДокументовДиалогПроведения(ДополнительныеПараметры);
	Иначе
		ВыполнитьОбработкуОповещения(ОписаниеПроцедурыЗавершения, СписокДокументов);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
