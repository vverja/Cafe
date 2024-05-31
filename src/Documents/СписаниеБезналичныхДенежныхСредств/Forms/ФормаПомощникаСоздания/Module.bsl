
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("Основание") Тогда
		Если ЗначениеЗаполнено(Параметры.Основание)Тогда
			
			Если ТипЗнч(Параметры.Основание) = Тип("ДокументСсылка.ЗаявкаНаРасходованиеДенежныхСредств") Тогда
				
				ДокументОснование   = Параметры.Основание;
				
				Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДокументОснование, "Валюта, Организация, БанковскийСчет");
				
				ВалютаОснование     = Реквизиты.Валюта;
				
				БанковскийСчет      = Реквизиты.БанковскийСчет;
				
				Если Не ЗначениеЗаполнено(БанковскийСчет) Тогда
					БанковскийСчет = Справочники.БанковскиеСчетаОрганизаций.ПолучитьБанковскийСчетОрганизацииПоУмолчанию(
						Реквизиты.Организация,
						Реквизиты.Валюта);
				КонецЕсли;
				
				ИспользоватьНачислениеЗарплаты = Константы.ИспользоватьНачислениеЗарплаты.Получить();
				Если ИспользоватьНачислениеЗарплаты Тогда
				Иначе
					ЗаполнитьТаблицуДокументовПоФизЛицам()
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
	КонецЕсли;
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Для каждого СтрокаТаблицы Из ТаблицаДокументов Цикл
		Если НЕ ЗначениеЗаполнено(СтрокаТаблицы.ДокументСписание) Тогда
			СтрокаТаблицы.Отметка	= Истина
		КонецЕсли;
	КонецЦикла; 
	Элементы.ТаблицаДокументовСумма.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
	НСтр("ru='Сумма (%1)';uk='Сума (%1)'"),
	Строка(ВалютаОснование));
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТаблицадокументов

&НаКлиенте
Процедура ТаблицаДокументовОтметкаПриИзменении(Элемент)
	Если ЗначениеЗаполнено(Элемент.Родитель.ТекущиеДанные.ДокументСписание) Тогда
		Элемент.Родитель.ТекущиеДанные.Отметка = Ложь
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаДокументовДокументСписаниеПриИзменении(Элемент)
	Элемент.Родитель.ТекущиеДанные.Отметка = Ложь
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СнятьФлажки(Команда)
	
	УстановитьФлажкиСтрок(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьФлажки(Команда)
	
	УстановитьФлажкиСтрок(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьДокументы(Команда)

	Если НЕ ЗначениеЗаполнено(БанковскийСчет) Тогда
		
		СообщениеОбОшибке = НСтр("ru='Поле ""Банковский счет"" не заполнено.';uk='Поле ""Банківський рахунок"" не заповнено.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеОбОшибке);
		Возврат;
		
	КонецЕсли;
	
	ИндексСтроки = 0;
	Для каждого СтрокаТаблицы Из ТаблицаДокументов Цикл
		
		Если НЕ СтрокаТаблицы.Отметка Тогда
			ИндексСтроки = ИндексСтроки+1;
		    Продолжить
		КонецЕсли; 
		
		СоздатьДокументыСписаниеНаСервере(СтрокаТаблицы.ФизическоеЛицо,
										  СтрокаТаблицы.ЛицевойСчет, 
										  СтрокаТаблицы.Сумма, 
										  СтрокаТаблицы.ВедомостьПоВыплатеЗП, 
										  ИндексСтроки);
		ИндексСтроки = ИндексСтроки+1;

	КонецЦикла; 	
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьЖурналДокументов(Команда)
	
	ПараметрыОтбора = Новый Структура("ДокументОснование", ДокументОснование); 
	ОткрытьФорму("Документ.СписаниеБезналичныхДенежныхСредств.ФормаСписка", ПараметрыОтбора, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьФлажкиСтрок(СоздаватьДокументы)
	
	Для Каждого СтрокаТаблицы Из ТаблицаДокументов Цикл
		Если НЕ ЗначениеЗаполнено(СтрокаТаблицы.ДокументСписание) Тогда
		    СтрокаТаблицы.Отметка = СоздаватьДокументы;
		КонецЕсли; 
	КонецЦикла;
	
КонецПроцедуры


&НаСервере
Процедура ЗаполнитьТаблицуДокументовПоФизЛицам()
	
	ТЗФизЛица	= ДокументОснование.ЛицевыеСчетаСотрудников.Выгрузить();
	ТЗФизЛица.Колонки.Добавить("ДокументСписание",);
	МассивФизЛиц	= ТЗФизЛица.ВыгрузитьКолонку("ФизическоеЛицо");
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Списания.Ссылка КАК ДокументСписание,
	|	Списания.ПодотчетноеЛицо
	|ИЗ
	|	Документ.СписаниеБезналичныхДенежныхСредств КАК Списания
	|ГДЕ
	|	Списания.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВыплатаЗарплатыНаЛицевыеСчета)
	|	И Списания.ПодотчетноеЛицо В(&МассивФизЛиц)
	|	И Списания.ЗаявкаНаРасходованиеДенежныхСредств = &СсылкаЗаявка";
	
	Запрос.УстановитьПараметр("МассивФизЛиц", МассивФизЛиц);
	Запрос.УстановитьПараметр("СсылкаЗаявка", ДокументОснование);
	ТЗДокСписание = Запрос.Выполнить().Выгрузить();
	
	Для каждого СтрокаФЛ Из ТЗФизЛица Цикл
		
		НайденнаяСтрока = ТЗДокСписание.Найти(СтрокаФЛ.ФизическоеЛицо, "ПодотчетноеЛицо");
		Если НайденнаяСтрока <> Неопределено Тогда
			СтрокаФЛ.ДокументСписание = НайденнаяСтрока.ДокументСписание
		КонецЕсли; 
		
	КонецЦикла; 
	ТаблицаДокументов.Загрузить(ТЗФизЛица);
	
КонецПроцедуры

&НаСервере
Процедура СоздатьДокументыСписаниеНаСервере(ФизическоеЛицо, ЛицевойСчет, Сумма, ВедомостьПоВыплатеЗП, ИндексСтроки)
	
	ДокументСписаниеОбъект = Документы.СписаниеБезналичныхДенежныхСредств.СоздатьДокумент();
	ДокументСписаниеОбъект.ХозяйственнаяОперация 		= Перечисления.ХозяйственныеОперации.ВыплатаЗарплатыНаЛицевыеСчета;

	Если ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.ЗаявкаНаРасходованиеДенежныхСредств") Тогда
		ДокументСписаниеОбъект.Заполнить(ДокументОснование);
		Если ЗначениеЗаполнено(ЛицевойСчет.ТекстНазначения) Тогда
			ДокументСписаниеОбъект.НазначениеПлатежа = ЛицевойСчет.ТекстНазначения;	
		КонецЕсли;
		
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ДокументСписаниеОбъект.СтатьяДвиженияДенежныхСредств) Тогда
		ДокументСписаниеОбъект.СтатьяДвиженияДенежныхСредств =
			Справочники.СтатьиДвиженияДенежныхСредств.СтатьяДвиженияДенежныхСредствПоХозяйственнойОперации(
				ДокументСписаниеОбъект.ХозяйственнаяОперация);
	КонецЕсли;
	
	ДокументСписаниеОбъект.Дата                         = ТекущаяДата();
	ДокументСписаниеОбъект.ПодотчетноеЛицо              = ФизическоеЛицо;
	ДокументСписаниеОбъект.БанковскийСчетКонтрагента    = ЛицевойСчет;
	ДокументСписаниеОбъект.СуммаДокумента               = Сумма;
	ДокументСписаниеОбъект.БанковскийСчет               = БанковскийСчет;
	ДокументСписаниеОбъект.ОчередностьПлатежа           = 5;
	
	Если Константы.ИспользоватьНачислениеЗарплаты.Получить() Тогда
		
		НоваяСтрокаТЧСписание           = ДокументСписаниеОбъект.ВедомостиНаВыплатуЗарплаты.Добавить();
		
		НоваяСтрокаТЧСписание.Ведомость = ВедомостьПоВыплатеЗП;
		НоваяСтрокаТЧСписание.Сумма     = Сумма;
		
	КонецЕсли;
	
	ДокументСписаниеОбъект.Записать(РежимЗаписиДокумента.Проведение);
	
	ТаблицаДокументов[ИндексСтроки].ДокументСписание	= ДокументСписаниеОбъект.Ссылка;
	ТаблицаДокументов[ИндексСтроки].Отметка				= Ложь;
	
КонецПроцедуры

#КонецОбласти
