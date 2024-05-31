
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	НачальныйПризнакВыполнения = Объект.Выполнена;
	ЗадачаОбъект = РеквизитФормыВЗначение("Объект");
	ЗаданиеОбъект = ЗадачаОбъект.БизнесПроцесс.ПолучитьОбъект();
	ЗначениеВРеквизитФормы(ЗаданиеОбъект, "Задание");

	ИспользоватьДатуИВремяВСрокахЗадач = ПолучитьФункциональнуюОпцию("ИспользоватьДатуИВремяВСрокахЗадач");
	Элементы.СрокИсполненияВремя.Видимость = ИспользоватьДатуИВремяВСрокахЗадач;
	Элементы.СрокНачалаИсполненияВремя.Видимость = ИспользоватьДатуИВремяВСрокахЗадач;
	Элементы.ДатаИсполнения.Формат = ?(ИспользоватьДатуИВремяВСрокахЗадач, "ДЛФ=DT", "ДЛФ=D");

	БизнесПроцессыИЗадачиСервер.ФормаЗадачиПриСозданииНаСервере(
		ЭтаФорма, Объект, Элементы.ГруппаСостояние, Элементы.ДатаИсполнения);

	Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	КоммерческоеПредложениеКлиенту.Ссылка
		|ИЗ
		|	Документ.КоммерческоеПредложениеКлиенту КАК КоммерческоеПредложениеКлиенту
		|ГДЕ
		|	(НЕ КоммерческоеПредложениеКлиенту.ПометкаУдаления)
		|	И КоммерческоеПредложениеКлиенту.Сделка = &Сделка");
	Запрос.УстановитьПараметр("Сделка", Задание.Предмет);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		КоммерческоеПредложение = Выборка.Ссылка;
		Элементы.КП.Заголовок   = КоммерческоеПредложение;
	Иначе
		Элементы.КП.Заголовок = НСтр("ru='Создать коммерческое предложение';uk='Створити комерційну пропозицію'");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Перем ПараметрСделка;
	
	Если ИмяСобытия = "Запись_КоммерческоеПредложениеКлиенту"
		И Параметр.Свойство("Сделка", ПараметрСделка) Тогда
		
		Если ПараметрСделка = Задание.Предмет Тогда
			КоммерческоеПредложение = Источник;
			Элементы.КП.Заголовок   = Источник;
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрытьВыполнить()

	БизнесПроцессыИЗадачиКлиент.ЗаписатьИЗакрытьВыполнить(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ВыполненоВыполнить()

	БизнесПроцессыИЗадачиКлиент.ЗаписатьИЗакрытьВыполнить(ЭтаФорма,Истина,Новый Структура("Сделка",Объект.Предмет));

КонецПроцедуры

&НаКлиенте
Процедура КоммерческоеПредложение(Команда)

	Если ЗначениеЗаполнено(КоммерческоеПредложение) Тогда
		ПоказатьЗначение(Неопределено, КоммерческоеПредложение);
	Иначе
		ОткрытьФорму(
			"Документ.КоммерческоеПредложениеКлиенту.ФормаОбъекта",
			Новый Структура("Основание", Задание.Предмет),,,,, Неопределено, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти
