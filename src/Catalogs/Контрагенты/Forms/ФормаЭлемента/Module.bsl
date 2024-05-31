&НаКлиенте
Перем ПараметрыОбработчика;

&НаКлиенте
Перем ФормаДлительнойОперации Экспорт;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	Если Параметры.Свойство("ОснованиеОбособленныйКонтрагент") Тогда
		НаОснованииОбособленногоКонтрагента = Истина;
	КонецЕсли;
	
	
	ИспользоватьПартнеровКакКонтрагентов = ПолучитьФункциональнуюОпцию("ИспользоватьПартнеровКакКонтрагентов");
	
	// Обработчик подсистемы "Свойства"
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Объект", Объект);
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтаФорма, ДополнительныеПараметры);
    
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	Если Параметры.Ключ.Пустая() Тогда
    	пТекстЗаполнения=СокрЛП(ЭтотОбъект.Параметры.ТекстЗаполнения);
    	Если Не пТекстЗаполнения = "" Тогда
    		Если Пактум_Сервер.ВероятноЕДРПОУ(пТекстЗаполнения) Тогда
    			Объект.КодПоЕДРПОУ  = пТекстЗаполнения;
                Объект.Наименование = "";
        	Иначе 
        		Объект.Наименование = пТекстЗаполнения;
            КонецЕсли;
        КонецЕсли;
        пТекстЗаполнения="";
	КонецЕсли;
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами
    
	Если ИспользоватьПартнеровКакКонтрагентов Тогда
		Возврат;
	КонецЕсли;
	
	УпрощенныйВводДоступен = ПартнерыИКонтрагенты.УпрощенныйВводДоступен() ИЛИ ТолькоПросмотр;
	
	Элементы.Партнер.Видимость = НЕ ОбщегоНазначенияУТКлиентСервер.АвторизованВнешнийПользователь();
		
	// Обработчик механизма "ВерсионированиеОбъектов"
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	УправлениеКонтактнойИнформацией.ПриСозданииНаСервере(ЭтаФорма,
	                                                     Объект, 
	                                                     "ГруппаКонтактнаяИнформация",
	                                                     ПоложениеЗаголовкаЭлементаФормы.Лево);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
	
	Если Объект.Ссылка.Пустая() Тогда
		ПриСозданииЧтенииНаСервере();
		Если Параметры.Свойство("Основание") И ТипЗнч(Параметры.Основание) = Тип("Структура") Тогда
			Если Параметры.Основание.Свойство("АдресЭППартнера") И ЗначениеЗаполнено(Параметры.Основание.АдресЭППартнера) Тогда
				СтруктураДанных = Новый Структура;
				СтруктураДанных.Вставить("Представление", Параметры.Основание.АдресЭППартнера);
				СтруктураДанных.Вставить("КонтактнаяИнформация", "");
				ПартнерыИКонтрагенты.ЗаполнитьЭлементКонтактнойИнформации(
                    ЭтотОбъект,
				    ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.EmailКонтрагента"),
				    СтруктураДанных
                );
		    КонецЕсли;
    		Если Параметры.Основание.Свойство("СокращенноеНаименование") И ЗначениеЗаполнено(Параметры.Основание.СокращенноеНаименование) Тогда
    			Объект.НаименованиеПолное = Параметры.Основание.СокращенноеНаименование;
    		КонецЕсли;
		
		КонецЕсли;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма, Элементы.ПодменюПечать);
	// Конец СтандартныеПодсистемы.Печать

	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом
    
	
	// МенюОтчеты
	МенюОтчеты.ПриСозданииНаСервере(ЭтаФорма, Элементы.ПодменюОтчеты,, Ложь);
	// Конец МенюОтчеты
    
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриСозданииЧтенииНаСервере();
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	УправлениеКонтактнойИнформацией.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
	
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтаФорма, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	УправлениеКонтактнойИнформацией.ОбработкаПроверкиЗаполненияНаСервере(ЭтаФорма, Объект, Отказ);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	УправлениеКонтактнойИнформацией.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
	
	// Обработчик подсистемы "Свойства"
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект);
	
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
    
	Если ИспользоватьПартнеровКакКонтрагентов Тогда
		Отказ = Истина;
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Ключ", Объект.Партнер);
        ПараметрыФормы.Вставить("КодПоЕДРПОУ", Объект.КодПоЕДРПОУ);
		ПараметрыФормы.Вставить("Наименование", Объект.Наименование);
		ИмяФормыДляОткрытия = ?(Объект.Ссылка.Пустая(),"Форма.ПомощникНового","ФормаОбъекта");
        ОткрытьФорму("Справочник.Партнеры." + ИмяФормыДляОткрытия, ПараметрыФормы, );
		Возврат;
	КонецЕсли;
	
	УстановитьЗаголовокКодаПоЕДРПОУ();
    
    Элементы.ДекорацияЗаполнитьПоЕГРПОУ.Видимость=Ложь;
	
	
КонецПроцедуры 

&НаКлиенте
Процедура ПриЗакрытии()
	
	Если НаОснованииОбособленногоКонтрагента И ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ОповеститьОВыборе(Объект.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если ЗначениеЗаполнено(Объект.КодПоЕДРПОУ) И (Объект.ЮрФизЛицо = ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ЮрЛицоНеРезидент"))Тогда
		Объект.КодПоЕДРПОУ = "";
	КонецЕсли;

	
	// Если контрагент не является нерезидентом Украины, то страна регистрации должна быть Украина.
	Если Не Объект.ЮрФизЛицо = ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ЮрЛицоНеРезидент") Тогда
		Объект.СтранаРегистрации = ПредопределенноеЗначение("Справочник.СтраныМира.Украина");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// Подсистема "Свойства"
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтаФорма, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ПараметрыЗаписи.Вставить("Партнер", Объект.Партнер);
	Оповестить("Запись_Контрагенты", ПараметрыЗаписи, Объект.Ссылка);
	
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	УстановитьЗаголовокФормы();
	УправлениеДоступностью();
	НастроитьПанельНавигации();

	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВидКонтрагентаПриИзменении(Элемент)
	
	Если ВидКонтрагента = "ОбособленноеПодразделение" Тогда
		
		Объект.ЮрФизЛицо = ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ЮрЛицо");
		Объект.ОбособленноеПодразделение = Истина;
		
		Если Объект.ГоловнойКонтрагент = Объект.Ссылка Тогда
			Объект.ГоловнойКонтрагент = Неопределено;
		КонецЕсли;
		
	Иначе
		
		Объект.ЮрФизЛицо = ПредопределенноеЗначение("Перечисление.ЮрФизЛицо." + ВидКонтрагента);
		Объект.ОбособленноеПодразделение = Ложь;
		
		Если Объект.ГоловнойКонтрагент <> Объект.Ссылка Тогда
			Объект.ГоловнойКонтрагент = Неопределено;
		КонецЕсли;
		
	КонецЕсли;
	
	Если Объект.ЮрФизЛицо = ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ФизЛицо")
		ИЛИ Объект.ЮрФизЛицо = ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ЮрЛицоНеРезидент") Тогда
		Объект.ПлательщикНДС = Ложь;
		Объект.ИННПлательщикаНДС = "";
		Объект.НомерСвидетельстваПлательщикаНДС = "";
	КонецЕсли; 
	
	
	
	УправлениеДоступностью();
	ОтключитьОтметкуНезаполненного();
	УстановитьЗаголовокКодаПоЕДРПОУ();
	
КонецПроцедуры

&НаКлиенте
Процедура ПартнерПриИзменении(Элемент)
	
	УправлениеДоступностью();
	
КонецПроцедуры

&НаКлиенте
Процедура ГоловнойКонтрагентПриИзменении(Элемент)
	
	ОбработатьИзмененияГоловногоКонтрагента();
	ОтключитьОтметкуНезаполненного();
	
	УправлениеДоступностью();
	
КонецПроцедуры


&НаКлиенте
Процедура ИННПлательщикаНДСОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	Перем ТекстСообщения;
	ЭтоЮрЛицо = Объект.ЮрФизЛицо = ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ЮрЛицо")
		ИЛИ Объект.ЮрФизЛицо = ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ЮрЛицоНеРезидент");
	
	ОчиститьСообщения();
	
	Если НЕ ПустаяСтрока(Текст) И
		НЕ РегламентированныеДанныеКлиентСервер.ИННПлательщикаНДССоответствуетТребованиям(Текст, ЭтоЮрЛицо, ТекстСообщения) Тогда
		
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстСообщения,
				,"Объект.ИННПлательщикаНДС",,);
			
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КодПоЕДРПОУОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, Параметры, СтандартнаяОбработка)
	Перем ТекстСообщения;
	ОчиститьСообщения();
	
	ЭтоЮрЛицо = Объект.ЮрФизЛицо = ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ЮрЛицо")
		ИЛИ Объект.ЮрФизЛицо = ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ЮрЛицоНеРезидент");
	
	Если НЕ ПустаяСтрока(Текст) 
		И НЕ РегламентированныеДанныеКлиентСервер.КодПоЕДРПОУСоответствуетТребованиям(Текст,
			ЭтоЮрЛицо, 
			ТекстСообщения) Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстСообщения,
			,"Объект.КодПоЕДРПОУ",,);
		
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура НомерСвидетельстваОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	Перем ТекстСообщения;
	ЭтоЮрЛицо = Объект.ЮрФизЛицо = ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ЮрЛицо")
		ИЛИ Объект.ЮрФизЛицо = ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ЮрЛицоНеРезидент");
	
	ОчиститьСообщения();
	
	Если НЕ ПустаяСтрока(Текст) И
		НЕ РегламентированныеДанныеКлиентСервер.НомерСвидетельстваПлательщикаНДССоответствуетТребованиям(Текст, ЭтоЮрЛицо, ТекстСообщения) Тогда
		
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстСообщения,
				,"Объект.НомерСвидетельстваПлательщикаНДС",,);
			
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПлательщикНДСПриИзменении(Элемент)
	
	УправлениеДоступностью();
	
КонецПроцедуры


#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыКонтактнаяИнформация

// СтандартныеПодсистемы.КонтактнаяИнформация

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияПриИзменении(Элемент)
	УправлениеКонтактнойИнформациейКлиент.ПриИзменении(ЭтотОбъект, Элемент);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	УправлениеКонтактнойИнформациейКлиент.НачалоВыбора(ЭтотОбъект, Элемент, , СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияПриНажатии(Элемент, СтандартнаяОбработка)
	УправлениеКонтактнойИнформациейКлиент.НачалоВыбора(ЭтотОбъект, Элемент,, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияОчистка(Элемент, СтандартнаяОбработка)
	УправлениеКонтактнойИнформациейКлиент.Очистка(ЭтотОбъект, Элемент.Имя);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияВыполнитьКоманду(Команда)
	УправлениеКонтактнойИнформациейКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда.Имя);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ОбновитьКонтактнуюИнформацию(Результат) Экспорт
	УправлениеКонтактнойИнформацией.ОбновитьКонтактнуюИнформацию(ЭтотОбъект, Объект, Результат);
КонецПроцедуры

// Конец СтандартныеПодсистемы.КонтактнаяИнформация

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьПартнера(Команда)
	
	КонтрагентОснование = Новый Структура;
	КонтрагентОснование.Вставить("Название", Объект.Наименование);
	КонтрагентОснование.Вставить("КодПоЕДРПОУ", Объект.КодПоЕДРПОУ);
  	КонтрагентОснование.Вставить("ПлательщикНДС", Объект.ПлательщикНДС);
	КонтрагентОснование.Вставить("ИННПлательщикаНДС", Объект.ИННПлательщикаНДС);
	КонтрагентОснование.Вставить("НомерСвидетельстваПлательщикаНДС", Объект.НомерСвидетельстваПлательщикаНДС);
	КонтрагентОснование.Вставить("ЮрФизЛицо", Объект.ЮрФизЛицо);
	КонтрагентОснование.Вставить("ОбособленноеПодразделение", Объект.ОбособленноеПодразделение);
	КонтрагентОснование.Вставить("ПолноеЮридическоеНаименование",Объект.НаименованиеПолное);
	
	Для каждого КонтактнаяИнформация Из Объект.КонтактнаяИнформация Цикл
		
		Если КонтактнаяИнформация.Вид = ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.ФактАдресКонтрагента") Тогда
			ВидКонтактнойИнформации = "ФактАдресКонтрагента";
		ИначеЕсли КонтактнаяИнформация.Вид = ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.ЮрАдресКонтрагента") Тогда
			ВидКонтактнойИнформации = "ЮрАдресКонтрагента";
		ИначеЕсли КонтактнаяИнформация.Вид = ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.EmailКонтрагента") Тогда
			ВидКонтактнойИнформации = "EmailКонтрагента";
		ИначеЕсли КонтактнаяИнформация.Вид = ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.ТелефонКонтрагента") Тогда
			ВидКонтактнойИнформации = "ТелефонКонтрагента";
		Иначе
			Продолжить;
		КонецЕсли;
		
		КонтрагентОснование.Вставить(ВидКонтактнойИнформации,Новый Структура("Представление, ЗначенияПолей", КонтактнаяИнформация.Представление, КонтактнаяИнформация.ЗначенияПолей));
		
	КонецЦикла;
	
	ПараметрыОткрытия = Новый Структура("КонтрагентОснование",КонтрагентОснование);
	
	ОткрытьФорму("Справочник.Партнеры.Форма.ПомощникНового", ПараметрыОткрытия, ЭтаФорма,,,, 
			Новый ОписаниеОповещения("СоздатьПартнераЗавершение", ЭтотОбъект), РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПартнераЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено И Результат <> Объект.Партнер Тогда
		Объект.Партнер = Результат;
		Модифицированность = Истина;
		УправлениеДоступностью();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьГоловногоКонрагента(Команда)
	
	ПараметрыЗаполнения = Новый Структура;
	ПараметрыЗаполнения.Вставить("Контрагент", Объект.Ссылка);
	ПараметрыЗаполнения.Вставить("ИННПлательщикаНДС", Объект.ИННПлательщикаНДС);
	ПараметрыЗаполнения.Вставить("Партнер",    Объект.Партнер);
	ПараметрыЗаполнения.Вставить("ИспользоватьПартнеровКакКонтрагентов", Ложь);
	
	Оповещение = Новый ОписаниеОповещения("ЗаполнитьГоловногоКонтрагентаЗавершение", ЭтотОбъект);
	ПартнерыИКонтрагентыКлиент.ЗаполнитьГоловногоКонтрагента(ЭтотОбъект, ПараметрыЗаполнения, Ложь, Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеСокращенноеПриИзменении(Элемент)
	
	ПартнерыИКонтрагентыКлиент.СокрЮрНаименованиеПриИзменении(Объект.Наименование, Объект.НаименованиеПолное);
	
КонецПроцедуры


// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
&НаКлиенте
Процедура Подключаемый_ВыполнитьНазначаемуюКоманду(Команда)
	
	Если НЕ ДополнительныеОтчетыИОбработкиКлиент.ВыполнитьНазначаемуюКомандуНаКлиенте(ЭтаФорма, Команда.Имя) Тогда
		РезультатВыполнения = Неопределено;
		ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(Команда.Имя, РезультатВыполнения);
		ДополнительныеОтчетыИОбработкиКлиент.ПоказатьРезультатВыполненияКоманды(ЭтаФорма, РезультатВыполнения);
	КонецЕсли;
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура Подключаемый_РедактироватьСоставСвойств(Команда)
	
	УправлениеСвойствамиКлиент.РедактироватьСоставСвойств(ЭтаФорма);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры
//Конец ИнтеграцияС1СДокументооборотом

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();
	
	Возврат;

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ИНН.Имя);
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ИННФизЛицо.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("УпрощенныйВводДоступен");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ЮрФизЛицо");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
	СписокЗначений = Новый СписокЗначений;
	СписокЗначений.Добавить(Перечисления.ЮрФизЛицо.ЮрЛицо);
	СписокЗначений.Добавить(Перечисления.ЮрФизЛицо.ФизЛицо);
	СписокЗначений.Добавить(Перечисления.ЮрФизЛицо.ИндивидуальныйПредприниматель);
	ОтборЭлемента.ПравоеЗначение = СписокЗначений;

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ИНН");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Истина);

КонецПроцедуры

&НаСервере
Процедура УправлениеДоступностью()
	
	ПартнерыИКонтрагенты.УправлениеЭлементамиЮридическихРеквизитов(
		ЭтотОбъект, Объект.ЮрФизЛицо, Объект.ОбособленноеПодразделение, Объект.ПлательщикНДС, Объект.ГоловнойКонтрагент, Объект.Ссылка);
	
		
	
	
	Если НЕ Элементы.Найти("Партнер") = Неопределено Тогда
		
		Если (Объект.Партнер = Справочники.Партнеры.НеизвестныйПартнер ИЛИ
			Объект.Партнер = Справочники.Партнеры.РозничныйПокупатель) 
			И НЕ Объект.Ссылка.Пустая()
			И ПраваПользователяПовтИсп.ПравоСозданияПартнера() Тогда
			
			Элементы.СтраницыПартнер.ТекущаяСтраница = Элементы.СтраницаНеизвестныйПартнер;
		Иначе
			Элементы.СтраницыПартнер.ТекущаяСтраница = Элементы.СтраницаПартнерПодобран;
		КонецЕсли;
		
	КонецЕсли;
	
	
	// Страна регистрация видна только в том случае, когда контрагент не является резидентом Украины. 
	// В противном случае - и для физ лиц и для ФОП и для юр лиц страна регистрации всегда Украина.
	Элементы.ГруппаСтраницыДанныхРегистрацииКонтрагента.ТекущаяСтраница = 
		?(Объект.ЮрФизЛицо = Перечисления.ЮрФизЛицо.ЮрЛицоНеРезидент, 
		Элементы.ГруппаСтраницаИностраннойРегистрации, Элементы.ГруппаСтраницаУкраинскогоКонтрагента);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьЗаголовокКодаПоЕДРПОУ()
	
	Если Объект.ЮрФизЛицо = ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ЮрЛицо") ИЛИ Объект.ЮрФизЛицо = ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ЮрЛицоНеРезидент") Тогда
		ЗаголовокКода  = НСтр("ru='Код по ЕДРПОУ';uk='Код за ЄДРПОУ'");
		ПодсказкаВвода = НСтр("ru='Введите код ЕДРПОУ 8 цифр';uk='Введіть код ЄДРПОУ 8 цифр'");
	Иначе
		ЗаголовокКода = НСтр("ru='Код по ДРФО';uk='Код за ДРФО'");
        ПодсказкаВвода = НСтр("ru='Введите код ДРФО 10 цифр';uk='Введіть код ДРФО 10 цифр'")
                         + Символы.ПС
                         + НСтр("ru='или серию и номер паспорта старого образца - 2 буквы и 6 цифр, без пробела между серией и номером';uk='або серію та номер паспорта старого зразка - 2 літери і 6 цифр, без пробілу між серією та номером'") 
                         + Символы.ПС
                         + НСтр("ru='или номер паспорта нового образца - 9 цифр.';uk='або номер паспорта нового зразка - 9 цифр.'") 
                         + Символы.ПС
                         ;
	КонецЕсли;
		
	Элементы.КодПоЕДРПОУ.Заголовок      = ЗаголовокКода;
	Элементы.КодПоЕДРПОУ.ПодсказкаВвода = ПодсказкаВвода;
	
КонецПроцедуры



// СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтаФорма);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
&НаСервере
Процедура ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(ИмяЭлемента, РезультатВыполнения)
	
	ДополнительныеОтчетыИОбработки.ВыполнитьНазначаемуюКомандуНаСервере(ЭтаФорма, ИмяЭлемента, РезультатВыполнения);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

&НаСервере
Процедура ПриСозданииЧтенииНаСервере()
	
	
	УстановитьЗаголовокФормы();
	
	Если Объект.ОбособленноеПодразделение Тогда
		ВидКонтрагента = "ОбособленноеПодразделение";
	ИначеЕсли ЗначениеЗаполнено(Объект.ЮрФизЛицо) Тогда
		ВидКонтрагента = ОбщегоНазначения.ИмяЗначенияПеречисления(Объект.ЮрФизЛицо);
	КонецЕсли;
	
	УправлениеДоступностью();
	НастроитьПанельНавигации();

КонецПроцедуры

&НаСервере
Процедура НастроитьПанельНавигации()

	СтруктураНастроек = Новый Структура;
	СтруктураНастроек.Вставить("ИспользоватьДанныеКонтрагентаФизическогоЛица", Объект.ЮрФизЛицо = Перечисления.ЮрФизЛицо.ФизЛицо);
	
	ОбщегоНазначенияУТ.НастроитьФормуПоПараметрам(ЭтаФорма, СтруктураНастроек);

КонецПроцедуры

&НаСервере
Процедура ОбработатьИзмененияГоловногоКонтрагента()
	
	Если ЗначениеЗаполнено(Объект.ГоловнойКонтрагент) Тогда
		Объект.ИННПлательщикаНДС = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.ГоловнойКонтрагент, "ИННПлательщикаНДС");
	КонецЕсли;
	
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьГоловногоКонтрагентаЗавершение(ВыбранноеЗначение, ДополнительныеПараметры) Экспорт
	
	Если ВыбранноеЗначение <> Неопределено Тогда
		Объект.ГоловнойКонтрагент = ВыбранноеЗначение;
		Модифицированность = Истина;
		ОбработатьИзмененияГоловногоКонтрагента();
		ОтключитьОтметкуНезаполненного();
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуОтчет(Команда)
	
	МенюОтчетыКлиент.ВыполнитьПодключаемуюКомандуОтчет(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьЗаголовокФормы()
	
	Если Объект.Ссылка.Пустая() Тогда
		Заголовок = НСтр("ru='Контрагент (создание)';uk='Контрагент (створення)'");
	Иначе
		Заголовок = Объект.Наименование + " (" + НСтр("ru='Контрагент (юридическое или физическое лицо)';uk='Контрагент (юридична або фізична особа)'");
	КонецЕсли;
	
КонецПроцедуры



#Область Пактум

&НаКлиенте
Процедура ЗаполнитьПоЕГРПОУ(Команда)
    
	Если Не Пактум_Сервер.Пактум_Права() Тогда
		Оповестить("Пактум.СозданиеКарточки.Завершено");
		Возврат;
    КонецЕсли;
    
    Если НЕ Пактум_Сервер.НастройкиПодключенияКСервисуПактумЗаданы() Тогда
        Оповестить("Пактум.СозданиеКарточки.Завершено");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru='Не заданы настройки подключения к сервису Пактум.Контрагент!';uk='Не задані настройки підключення до сервісу Пактум.Контрагент!'")
        );
        Возврат;
    КонецЕсли; 
    
	пЕДРПОУ = СокрЛП(Объект.КодПоЕДРПОУ);
	Если пЕДРПОУ = "" Тогда
        ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
            НСтр("ru='Не заполнен код ЕГРПОУ';uk='Не заповнено код ЄДРПОУ'"),
            ,
            "КодПоЕДРПОУ"
        );        
		Оповестить("Пактум.СозданиеКарточки.Завершено");
		Возврат;
    КонецЕсли;
    
	СуществующиеКонтрагенты = Пактум_Сервер.ПолучитьКонтрагента(пЕДРПОУ);
	Если СуществующиеКонтрагенты.Кво > 0 Тогда
        ТекстВопроса = НСтр("ru='Контрагент(ы) с таким же ЕГРПОУ найден(ы) в базе. Открыть существующие карточки или заполнить данные в текущей карточке?';uk= 'Контрагента знайдено в базі. Відкрити існуючі картки чи заповнити дані відкритої картки?'");
        спКнопки=Новый СписокЗначений;
        спКнопки.Добавить(НСтр("ru='Открыть';uk='Відкрити'"));
        спКнопки.Добавить(НСтр("ru='Заполнить';uk='Заповнити'"));
        спКнопки.Добавить(НСтр("ru='Отменить';uk= 'Відмінити'"));
        ПоказатьВопрос(Новый ОписаниеОповещения("ВопросНаОткрытиеКарточки", ЭтотОбъект, СуществующиеКонтрагенты), ТекстВопроса, спКнопки);
	Иначе
		ВыполнитьЗаполнениеКарточки();
    КонецЕсли;
    
КонецПроцедуры

&НаКлиенте
Процедура ВопросНаОткрытиеКарточки(РезультатВопроса, ДополнительныеПараметры) Экспорт
    Ответ  = РезультатВопроса;
    Если Ответ = НСтр("ru='Открыть';uk='Відкрити'") Тогда
        Для Каждого Эл Из ДополнительныеПараметры.спКонтрагенты Цикл
    		ОткрытьФорму("Справочник.Контрагенты.ФормаОбъекта", Новый Структура("Ключ", Эл.Значение));
		КонецЦикла;
	ИначеЕсли Ответ = НСтр("ru='Заполнить';uk='Заповнити'") Тогда
		ВыполнитьЗаполнениеКарточки();
	Иначе
		Возврат;
    КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьЗаполнениеКарточки()
    
    пЕДРПОУ = СокрЛП(Объект.КодПоЕДРПОУ);
    
	СтруПараметры = Пактум_Сервер.ПроверкаКорректностиЕДРПОУ_Пактум(пЕДРПОУ);
	Если Не СтруПараметры.КорректностьЕДРПОУ_Значение Тогда
        ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
            СтруПараметры.КорректностьЕДРПОУ_ТекстОшибки,
            ,
            "КодПоЕДРПОУ"
        );        
		Оповестить("Пактум.СозданиеКарточки.Завершено");
		Возврат;
    КонецЕсли;
    Пактум_Токен = ?(СтруПараметры.Токен=Неопределено, "", СтруПараметры.Токен);
    
    
    РезультатЗапуска = Пактум_Сервер.ФоновоеЗаданиеДанныеПартнераПоКодПоЕДРПОУЗапустить(
        пЕДРПОУ,
        Пактум_Токен,
        УникальныйИдентификатор,
        ФоновоеЗаданиеИдентификатор
    );
    
    ФоновоеЗаданиеИдентификатор  = РезультатЗапуска.ИдентификаторЗадания;
    ФоновоеЗаданиеАдресХранилища = РезультатЗапуска.АдресХранилища;
    
    Если РезультатЗапуска.ЗаданиеЗапущено Тогда
        Пактум_КоличествоПроверок_ФоновогоЗадания = 0;
        ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчика);
        ПараметрыОбработчика.ТекущийИнтервал = 10;
        ПодключитьОбработчикОжидания("ФоновоеЗаданиеПроверитьНаКлиенте", 10, Истина);
        Пактум_Клиент.ЗаблокироватьФорму(ЭтаФорма);
    Иначе
        ВыполнитьЗаполнениеРеквизитовПоЕДРПОУ(РезультатЗапуска.РеквизитыКонтрагента);
    КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьЗаполнениеРеквизитовПоЕДРПОУ(РеквизитыКонтрагента, ЗаполнятьЕДРПОУ = Ложь)
	
	Если РеквизитыКонтрагента = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(РеквизитыКонтрагента.ОписаниеОшибки) Тогда
		Пактум_Клиент.ПоказатьПользователюОшибкуПолученияРеквизитовКонтрагентаПоЕДРПОУ(РеквизитыКонтрагента.ОписаниеОшибки);
        Возврат;
	ИначеЕсли ЗначениеЗаполнено(РеквизитыКонтрагента.ОписаниеПредупреждения) Тогда
		Пактум_Клиент.ПоказатьПользователюПредупреждениеПолученияРеквизитовКонтрагентаПоЕДРПОУ(РеквизитыКонтрагента.ОписаниеПредупреждения);
    КонецЕсли;    
        
    РезультатСравнения = Пактум_Клиент.РезультатСравненияПолученныхДанныхКонтрагентаСИмеющимися(
        РеквизитыКонтрагента,
        ДанныеОбъектаДляСравнения(),
        ЗаполнятьЕДРПОУ
    );
    
    Если РезультатСравнения.ЕстьИзменения Тогда
        
        Если РезультатСравнения.ЕстьИзмененияВЗаполненныхРеквизитах Тогда 
            
            ОписаниеОповещенияПерезаполнить = Новый ОписаниеОповещения(
                "ЗаполнениеРеквизитовКонтрагентаПоЕДРПОУЗавершение",
                ЭтотОбъект,
                Новый Структура("РеквизитыКонтрагента", РеквизитыКонтрагента)
            );
            ТекстВопроса = НСтр("ru='Перезаполнить реквизиты контрагента на основании данных сервиса Пактум.Контрагент?';uk='Перезаполнить реквізити контрагента на підставі даних сервісу Пактум.Контрагент?'");
            ПоказатьВопрос(ОписаниеОповещенияПерезаполнить, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
        
        Иначе
            
            ЗаполнитьРеквизитыКонтрагентаПоПолученнымДанным(РеквизитыКонтрагента);
            
        КонецЕсли;
        
    КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнениеРеквизитовКонтрагентаПоЕДРПОУЗавершение(Ответ, ДополнительныеПараметры) Экспорт

	Если Ответ = КодВозвратаДиалога.Да Тогда
		
		ЗаполнитьРеквизитыКонтрагентаПоПолученнымДанным(ДополнительныеПараметры.РеквизитыКонтрагента);
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьРеквизитыКонтрагентаПоПолученнымДанным(РеквизитыКонтрагента)
    
    ЗаполнитьЗначенияСвойств(Объект, РеквизитыКонтрагента, "КодПоЕДРПОУ, Наименование, ИННПлательщикаНДС, НомерСвидетельстваПлательщикаНДС, ПлательщикНДС");
    Объект.НаименованиеПолное = РеквизитыКонтрагента.НаименованиеПолное;
    
	Если РеквизитыКонтрагента.Свойство("Телефон") Тогда
		ПартнерыИКонтрагентыКлиент.ЗаполнитьЭлементКонтактнойИнформации(
            ЭтотОбъект,
		    ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.ТелефонКонтрагента"),
		    РеквизитыКонтрагента.Телефон
        );
    КонецЕсли;
    
	Если РеквизитыКонтрагента.Свойство("АдресЭП") Тогда
		ПартнерыИКонтрагентыКлиент.ЗаполнитьЭлементКонтактнойИнформации(
            ЭтотОбъект,
		    ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.EmailКонтрагента"),
		    РеквизитыКонтрагента.АдресЭП
        );
	КонецЕсли;
    
	Если РеквизитыКонтрагента.Свойство("ЮридическийАдрес") Тогда
		ПартнерыИКонтрагентыКлиент.ЗаполнитьЭлементКонтактнойИнформации(
            ЭтотОбъект,
		    ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.ЮрАдресКонтрагента"),
		    РеквизитыКонтрагента.ЮридическийАдрес
        );
    КонецЕсли;
    
    Если РеквизитыКонтрагента.Свойство("ДополнительнаяИнформация") И РеквизитыКонтрагента.ДополнительнаяИнформация <> Неопределено Тогда
        Объект.ДополнительнаяИнформация = Объект.ДополнительнаяИнформация + РеквизитыКонтрагента.ДополнительнаяИнформация;
    КонецЕсли;
    
    //Если РеквизитыКонтрагента.Свойство("Руководитель") И РеквизитыКонтрагента.Руководитель <> Неопределено Тогда
    //    УказатьДанныеКонтактногоЛица = Истина;
    //    ФамилияКЛ  = РеквизитыКонтрагента.Руководитель.Фамилия;
    //    ИмяКЛ      = РеквизитыКонтрагента.Руководитель.Имя;
    //    ОтчествоКЛ = РеквизитыКонтрагента.Руководитель.Отчество;
    //    Роль       = ПредопределенноеЗначение("Справочник.РолиКонтактныхЛицПартнеров.Руководитель");
    //    Если РеквизитыКонтрагента.Свойство("Телефон") И РеквизитыКонтрагента.Телефон <> Неопределено Тогда
    //        // отдельного телефона КЛ нет, присваиваем телефон контрагента
    //        ТелефонКЛ              = РеквизитыКонтрагента.Телефон.Представление;
    //        ТелефонКЛЗначенияПолей = РеквизитыКонтрагента.Телефон.КонтактнаяИнформация;
    //    КонецЕсли;
    //КонецЕсли;
	
	Модифицированность = Истина;
    
    УправлениеДоступностью();

КонецПроцедуры

&НаКлиенте
Процедура ФоновоеЗаданиеПроверитьНаКлиенте()
	
	РезультатВыполнения = Пактум_Сервер.ФоновоеЗаданиеВыполнено(ФоновоеЗаданиеИдентификатор, ФоновоеЗаданиеАдресХранилища);
	Если РезультатВыполнения.ЗаданиеВыполнено Тогда
		ВыполнитьЗаполнениеРеквизитовПоЕДРПОУ(РезультатВыполнения.РеквизитыКонтрагента);
        Пактум_Клиент.РазблокироватьФорму(ЭтаФорма);
    Иначе
        Пактум_КоличествоПроверок_ФоновогоЗадания = Пактум_КоличествоПроверок_ФоновогоЗадания + 1;
		Если Пактум_КоличествоПроверок_ФоновогоЗадания >= 21 Тогда 	//3 мин + 30 сек
		    ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
    		    СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
    			    НСтр("ru='Заполнить карточку контрагента с ЕДРПОУ %1 не удалось.';uk='Заповнити картку контрагента за ЄДРПОУ %1 не вдалося.'"),
    			    Объект.КодПоЕДРПОУ
                ),
                , 
                "КодПоЕДРПОУ"
            );
			Пактум_Клиент.РазблокироватьФорму(ЭтаФорма);
		Иначе
    		ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчика);
    		ПодключитьОбработчикОжидания("ФоновоеЗаданиеПроверитьНаКлиенте", ПараметрыОбработчика.ТекущийИнтервал, Истина);
        КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ДанныеОбъектаДляСравнения()

	ДанныеДляСравнения = Пактум_Клиент.ИнициироватьСтруктураДанныхДляСравнения();
    
    ЗаполнитьЗначенияСвойств(ДанныеДляСравнения, Объект, "КодПоЕДРПОУ, Наименование, ИННПлательщикаНДС, НомерСвидетельстваПлательщикаНДС, ПлательщикНДС");
    
    ДанныеДляСравнения.НаименованиеПолное = Объект.НаименованиеПолное;
    
	ДанныеКонтактнойИнформации = ПартнерыИКонтрагентыКлиент.ДанныеСтрокиКонтактнойИнформацииПоВиду(
	    ЭтотОбъект,
	    ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.ТелефонКонтрагента")
    );
	Если ДанныеКонтактнойИнформации <> Неопределено Тогда
		ДанныеДляСравнения.Телефон = ДанныеКонтактнойИнформации.Представление;
    КонецЕсли;
    
	ДанныеКонтактнойИнформации = ПартнерыИКонтрагентыКлиент.ДанныеСтрокиКонтактнойИнформацииПоВиду(
	    ЭтотОбъект,
	    ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.EmailКонтрагента")
    );
	Если ДанныеКонтактнойИнформации <> Неопределено Тогда
		ДанныеДляСравнения.АдресЭП = ДанныеКонтактнойИнформации.Представление;
	КонецЕсли;
	
	ДанныеКонтактнойИнформации = ПартнерыИКонтрагентыКлиент.ДанныеСтрокиКонтактнойИнформацииПоВиду(
	    ЭтотОбъект,
	    ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.ЮрАдресКонтрагента")
    );
	Если ДанныеКонтактнойИнформации <> Неопределено Тогда
		ДанныеДляСравнения.ЮридическийАдрес = ДанныеКонтактнойИнформации.Представление;
	КонецЕсли;
	
	Возврат ДанныеДляСравнения;

КонецФункции 

#КонецОбласти



#КонецОбласти
