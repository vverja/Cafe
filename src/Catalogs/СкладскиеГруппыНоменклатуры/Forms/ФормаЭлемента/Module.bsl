#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);

	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриЧтенииСозданииНаСервере();
	КонецЕсли;
		
	// подсистема запрета редактирования ключевых реквизитов объектов	
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);
	
	Если Объект.ОграничиватьПоВесу И Объект.ОграничиватьПоОбъему Тогда
		ОграничиватьПоВесуОбъему = "ВесИОбъем";
	ИначеЕсли Объект.ОграничиватьПоВесу Тогда
		ОграничиватьПоВесуОбъему = "Вес";
	ИначеЕсли Объект.ОграничиватьПоОбъему Тогда
		ОграничиватьПоВесуОбъему = "Объем";
	КонецЕсли;
	
	// МенюОтчеты
	МенюОтчеты.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюОтчеты);
	// Конец МенюОтчеты

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	ПриЧтенииСозданииНаСервере();
	
	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)

	Если ФизическиРазличаетсяОтНазначенияСтрока = "ФизическиРазличаетсяОтНазначения" Тогда
		ТекущийОбъект.ФизическиРазличаетсяОтНазначения = Истина;
	Иначе
		ТекущийОбъект.ФизическиРазличаетсяОтНазначения = Ложь;
	КонецЕсли;
	
	Если ОграничиватьПоВесуОбъему = "ВесИОбъем" Тогда
		ТекущийОбъект.ОграничиватьПоВесу = Истина;
		ТекущийОбъект.ОграничиватьПоОбъему = Истина;
	ИначеЕсли ОграничиватьПоВесуОбъему = "Вес" Тогда
		ТекущийОбъект.ОграничиватьПоВесу = Истина;
		ТекущийОбъект.ОграничиватьПоОбъему = Ложь;
	ИначеЕсли ОграничиватьПоВесуОбъему = "Объем" Тогда
		ТекущийОбъект.ОграничиватьПоВесу = Ложь;
		ТекущийОбъект.ОграничиватьПоОбъему = Истина;
	КонецЕсли;
	
	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура  ПослеЗаписи(ПараметрыЗаписи)

	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

// МенюОтчеты
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуОтчет(Команда)
	
	МенюОтчетыКлиент.ВыполнитьПодключаемуюКомандуОтчет(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры
// Конец МенюОтчеты

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТипНоменклатурыПриИзменении(Элемент)
	
	УправлениеФлагомФизическиРазличаетсяОтНазначения();
	
КонецПроцедуры

&НаКлиенте
Процедура ОграничиватьПоВесуОбъемуПриИзменении(Элемент)
	
	Модифицированность = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// Обработчик команды, создаваемой механизмом запрета редактирования ключевых реквизитов.
//
&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)

	Если Не Объект.Ссылка.Пустая() Тогда
		ОткрытьФорму("Справочник.СкладскиеГруппыНоменклатуры.Форма.РазблокированиеРеквизитов",,,,,, 
			Новый ОписаниеОповещения("Подключаемый_РазрешитьРедактированиеРеквизитовОбъектаЗавершение", ЭтотОбъект), 
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъектаЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    Если ТипЗнч(Результат) = Тип("Массив") И Результат.Количество() > 0 Тогда
        
        ЗапретРедактированияРеквизитовОбъектовКлиент.УстановитьДоступностьЭлементовФормы(ЭтаФорма, Результат);
        
    КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
		
	УправлениеФлагомФизическиРазличаетсяОтНазначения();
	
КонецПроцедуры

&НаСервере
Процедура УправлениеФлагомФизическиРазличаетсяОтНазначения()
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьОбособленноеОбеспечениеЗаказов")
		И Объект.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Товар Тогда
		Элементы.ГруппаФизическиРазличаетсяОтНазначения.Видимость = Истина;
		Если Объект.ФизическиРазличаетсяОтНазначения Тогда
			ФизическиРазличаетсяОтНазначенияСтрока = "ФизическиРазличаетсяОтНазначения";
		Иначе
			ФизическиРазличаетсяОтНазначенияСтрока = "НеФизическиРазличаетсяОтНазначения";
		КонецЕсли;
	Иначе
		Элементы.ГруппаФизическиРазличаетсяОтНазначения.Видимость = Ложь;
		ФизическиРазличаетсяОтНазначенияСтрока = "НеФизическиРазличаетсяОтНазначения";
		Объект.ФизическиРазличаетсяОтНазначения = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
