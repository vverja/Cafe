
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	НачальныйПризнакВыполнения = Объект.Выполнена;
	ТолькоПросмотр = Объект.Выполнена;
	
	Если Не Объект.Выполнена Тогда
		Объект.ДатаИсполнения = ТекущаяДата();
	КонецЕсли;
	
	ИспользоватьДатуИВремяВСрокахЗадач = ПолучитьФункциональнуюОпцию("ИспользоватьДатуИВремяВСрокахЗадач");
	Элементы.СрокИсполненияВремя.Видимость = ИспользоватьДатуИВремяВСрокахЗадач;
	Элементы.СрокНачалаИсполненияВремя.Видимость = ИспользоватьДатуИВремяВСрокахЗадач;
	Элементы.ДатаИсполнения.Формат = ?(ИспользоватьДатуИВремяВСрокахЗадач, "ДЛФ=DT", "ДЛФ=D");
	
	ИзменятьЗаданияЗаднимЧислом = ПолучитьФункциональнуюОпцию("ИзменятьЗаданияЗаднимЧислом");
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ДатаИсполнения", "ТолькоПросмотр", Не ИзменятьЗаданияЗаднимЧислом);
	
	Если Объект.Выполнена Тогда
		РезультатСогласования = БизнесПроцессы.СогласованиеПродажи.РезультатСогласованияПоТочкеМаршрута(Объект.БизнесПроцесс, Объект.ТочкаМаршрута);
		Если РезультатСогласования <> Неопределено Тогда
			Элементы.РезультатСогласования.Заголовок = РезультатСогласования;
		КонецЕсли;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		БизнесПроцессыИЗадачиСервер.ФормаЗадачиПриСозданииНаСервере(ЭтаФорма, Объект, 
			Элементы.ГруппаСостояние, Элементы.ДатаИсполнения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	БизнесПроцессыИЗадачиКлиент.ФормаЗадачиОбработкаОповещения(ЭтаФорма, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	БизнесПроцессыИЗадачиСервер.ФормаЗадачиПриСозданииНаСервере(ЭтаФорма, Объект, 
		Элементы.ГруппаСостояние, Элементы.ДатаИсполнения);
	Элементы.ОписаниеРезультата.ТолькоПросмотр = Объект.Выполнена;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрытьВыполнить()
	
	ОчиститьСообщения();
	Если Записать() Тогда
		ОповеститьОбИзменении(Объект.Ссылка);
		ПоказатьОповещениеПользователя(
			НСтр("ru='Изменение:';uk='Зміна:'"),
			ПолучитьНавигационнуюСсылку(Объект.Ссылка),
			Строка(Объект.Ссылка),
			БиблиотекаКартинок.Информация32);
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьВыполнить(Команда)
	
	Если Записать() Тогда
		ОповеститьОбИзменении(Объект.Ссылка);
		ПоказатьОповещениеПользователя(
			НСтр("ru='Изменение:';uk='Зміна:'"),
			ПолучитьНавигационнуюСсылку(Объект.Ссылка),
			Строка(Объект.Ссылка),
			БиблиотекаКартинок.Информация32);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Согласовано(Команда)
	
	Если Записать() Тогда
		
		ЗафиксироватьРезультатСогласованияСервер(Истина);
		
		ПоказатьОповещениеПользователя(
			НСтр("ru='Выполнение:';uk='Виконання:'"),
			ПолучитьНавигационнуюСсылку(Объект.Ссылка),
			Строка(Объект.Ссылка),
			БиблиотекаКартинок.Информация32);
		
		ОповеститьОбИзменении(Объект.Ссылка);
		Закрыть();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НеСогласовано(Команда)
	
	Если Не ЗначениеЗаполнено(Объект.РезультатВыполнения) Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru='Укажите причину отклонения документа';uk='Вкажіть причину відхилення документа'"),
			Объект.Ссылка,
			"Объект.РезультатВыполнения");
		
		Возврат;
		
	КонецЕсли;
	
	Если Записать() Тогда
		
		ЗафиксироватьРезультатСогласованияСервер(Ложь);
		
		ПоказатьОповещениеПользователя(
			НСтр("ru='Выполнение:';uk='Виконання:'"),
			ПолучитьНавигационнуюСсылку(Объект.Ссылка),
			Строка(Объект.Ссылка),
			БиблиотекаКартинок.Информация32);
		
		ОповеститьОбИзменении(Объект.Ссылка);
		Закрыть();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтклоненияОтУсловийПродаж(Команда)
	ПараметрыФормы = Новый Структура("ДокументПродажи", Объект.Предмет);
	ОткрытьФорму("Отчет.ОтклоненияОтУсловийПродаж.Форма", ПараметрыФормы);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

&НаСервере
Процедура ЗафиксироватьРезультатСогласованияСервер(Согласовано = Истина)
	
	Попытка
		ЗаблокироватьДанныеДляРедактирования(Объект.БизнесПроцесс);
	Исключение
			
		ТекстОшибки = НСтр("ru='При выполнении задачи не удалось заблокировать %Ссылка%. %ОписаниеОшибки%';uk='При виконанні задачі не вдалося заблокувати %Ссылка%. %ОписаниеОшибки%'");
		ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Ссылка%",         Объект.БизнесПроцесс);
		ТекстОшибки = СтрЗаменить(ТекстОшибки, "%ОписаниеОшибки%", КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			
		ВызватьИсключение ТекстОшибки;
			
	КонецПопытки;
	
	НачатьТранзакцию();
	
	Попытка
		
		УстановитьПривилегированныйРежим(Истина);
	
		СогласованиеОбъект = Объект.БизнесПроцесс.ПолучитьОбъект();
		СогласованиеОбъект.ДобавитьРезультатСогласования(
			Объект.ТочкаМаршрута,
			Пользователи.ТекущийПользователь(),
			?(Согласовано, Перечисления.РезультатыСогласования.Согласовано, Перечисления.РезультатыСогласования.НеСогласовано),
			Объект.РезультатВыполнения,
			Объект.ДатаИсполнения);
		
		СогласованиеОбъект.Записать();
		УстановитьПривилегированныйРежим(Ложь);
		БизнесПроцессыИЗадачиВызовСервера.ВыполнитьЗадачу(Объект.Ссылка);
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		ВызватьИсключение;
		
	КонецПопытки;
	
	РазблокироватьДанныеДляРедактирования(Объект.БизнесПроцесс);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
