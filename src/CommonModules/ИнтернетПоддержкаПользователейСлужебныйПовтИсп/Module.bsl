
////////////////////////////////////////////////////////////////////////////////
// Подсистема "Интернет-поддержка пользователей".
// ОбщийМодуль.ИнтернетПоддержкаПользователейСлужебныйПовтИсп.
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Возвращает обработчики событий подсистем библиотеки.
//
// Возвращаемое значение:
//	Структура - описание обработчиков.
//		* Сервер - Структура - серверные обработчики;
//			** ПараметрыРаботыКлиентаПриЗапуске - Массив - элементы типа Строка -
//				имена модулей, реализующих обработку заполнения параметров
//				работы клиента при запуске;
//			** ОчиститьНастройкиИПППользователя - элементы типа Строка -
//				имена модулей, реализующих обработку очистки настроек
//				пользователя при выходе авторизованного пользователя из ИПП;
//			** БизнесПроцессы - Соответствие - серверные обработчики
//				бизнес-процессов:
//				*** Ключ - Строка - точка входа бизнес-процесса;
//				*** Значение - Строка - имя серверного модуля, реализующего
//					обработчик бизнес-процесса;
//		* Клиент - Структура - клиентские обработчики;
//			** ПриНачалеРаботыСистемы - элементы типа Строка -
//				имена клиентских модулей, реализующих обработку
//				события "При начале работы системы"
//			** БизнесПроцессы - Соответствие - клиентские обработчики
//				бизнес-процессов:
//				*** Ключ - Строка - <Точка входа бизнес-процесса>\<Имя события>;
//				*** Значение - Строка - имя клиентского модуля, реализующего
//					обработчик бизнес-процесса;
//
// Реализация заполнения описания обработчиков событий.
// Заполняется в процедуре <МодульПодсистемы>.ДобавитьОбработчикиСобытий(СерверныеОбработчики, КлиентскиеОбработчики)
// <МодульПодсистемы> - имя модуля возвращается функцией ИнтернетПоддержкаПользователей.МодулиПодсистем()
// Параметры СерверныеОбработчики, КлиентскиеОбработчики соответствуют полям *Сервер и *Клиент возвращаемого значения.
//
// 1. Серверные события:
// 1) ПараметрыРаботыКлиентаПриЗапуске - описание обработчиков, заполняющих параметры работы клиента при запуске.
// СерверныеОбработчики.ПараметрыРаботыКлиентаПриЗапуске.Добавить(<ИмяМодуля>);
// добавляется имя модуля, реализующего экспортную процедуру служебного программного интерфейса:
//
//// Добавляет необходимые параметры работы клиента при запуске.
//// Добавленные параметры доступны в
//// СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиентаПриЗапуске().ИнтернетПоддержкаПользователей.<ИмяПараметра>;
//// Используется в том случае, если подсистема реализует сценарий, выполняемый
//// при начале работы системы.
////
//// Параметры:
////	Параметры - Структура - заполняемые параметры;
////
////Процедура ПараметрыРаботыКлиентаПриЗапуске(Параметры) Экспорт
//
// Вызывается из ИнтернетПоддержкаПользователей.ПараметрыРаботыКлиентаПриЗапуске()
//
// 2) ОчиститьНастройкиИПППользователя - описание обработчиков, выполняющих очистку
//	настроек пользователя при выходе авторизованного пользователя из Интернет-поддержки.
//
// СерверныеОбработчики.ОчиститьНастройкиИПППользователя.Добавить(<ИмяМодуля>);
// добавляется имя модуля, реализующего экспортную процедуру служебного программного интерфейса:
//
//// Вызывается при выходе авторизованного пользователя из Интернет-
//// поддержки при нажатии ссылки "Выход".
//// Выполняет очистку настроек пользователя, реализуемых подсистемой.
////
////Процедура ОчиститьНастройкиИПППользователя() Экспорт
//
// Вызывается из ИнтернетПоддержкаПользователейВызовСервера.ОчиститьНастройкиИПППользователя()
//
//
// 3) БизнесПроцессы - описание обработчиков бизнес-процессов в контексте сервера платформы,
//	реализуемых подсистемой.
//
// СерверныеОбработчики.БизнесПроцессы.Вставить("<МестоЗапуска>\<ИмяСобытия>", <ИмяМодуля>);
//		МестоЗапуска - точка входа, обрабатываемая подсистемой;
//		ИмяСобытия - строковое имя события;
//		ИмяМодуля - имя модуля, реализующего экспортную процедуру служебного программного
//			интерфейса для обработки события.
//
// Имена событий и описание методов служебного программного интерфейса:
//
// - "ПараметрыСозданияКонтекста"
//// Вызывается при заполнении параметров создания контекста бизнес-процесса.
//// См. процедуру ИнтернетПоддержкаПользователейВызовСервера.ПараметрыСозданияКонтекста().
////
//// Параметры:
////	Параметры - Структура - предзаполненные параметры:
////	* МестоЗапуска - Строка - точка входа бизнес-процесса;
////	* ПриНачалеРаботыСистемы - Булево - Истина, если запуск бизнес-процесса
////		выполняется при начале работы системы;
////	* ИспользоватьИнтернетПоддержку - Булево - Истина, если разрешено
////		использование ИПП для текущего режима работы ИБ;
////	* ЗапускРазрешен - Булево - Истина, если текущему пользователю разрешен
////		запуск ИПП;
////	ПрерватьОбработку - Булево - в параметре возвращается признак завершения
////		дальнейшей обработки, если известно, что дальнейшая обработка не
////		требуется.
////
////Процедура ПараметрыСозданияКонтекста(Параметры, ПрерватьОбработку) Экспорт
//
//
//
// - "ОпределитьВозможностьЗапуска"
//// Выполняет дополнительную проверку возможности запуска бизнес-процесса
//// по точке входа и параметрам создания контекста взаимодействия.
//// Вызывается из ИнтернетПоддержкаПользователейКлиентСервер.ОпределитьВозможностьЗапускаПоМестуИПараметрам()
////
//// Параметры:
////	МестоЗапуска - Строка - точка входа бизнес-процесса.
////	ПараметрыИнтернетПоддержки - см. функцию
////		ИнтернетПоддержкаПользователей.ПараметрыСозданияКонтекста();
////	ОписаниеДействия - Структура - в структуре возвращается описание
////		выполняемого действия в случае запрета запуска бизнес-процесса.
////		см. ИнтернетПоддержкаПользователейКлиентСервер.ОпределитьВозможностьЗапускаПоМестуИПараметрам().
////
////Процедура ОпределитьВозможностьЗапуска(
////	МестоЗапуска,
////	ПараметрыИнтернетПоддержки,
////	ОписаниеДействия) Экспорт
//
//
//
//
//
//
// - "ПриСозданииКонтекстаВзаимодействия"
//// Добавляет необходимые параметры к созданному контексту выполнения
//// бизнес-процесса.
//// Вызывается из ИнтернетПоддержкаПользователейВызовСервера.НовыйКонтекстВзаимодействия()
////
//// Параметры:
////	Контекст - см. функцию
////		ИнтернетПоддержкаПользователейВызовСервера.НовыйКонтекстВзаимодействия()
////
//// Параметры:
////	Контекст - см. функцию
////		ИнтернетПоддержкаПользователейВызовСервера.НовыйКонтекстВзаимодействия()
////Процедура ПриСозданииКонтекстаВзаимодействия(Контекст) Экспорт
//
//
//
//
// - "КонтекстВыполненияКоманды"
//// Определяет контекст выполнения команды сервиса Интернет-поддержки: клиент
//// или сервер платформы.
//// Вызывается из ИнтернетПоддержкаПользователейКлиентСервер.ТипКоманды()
////
//// Параметры:
////	ИмяКоманды - Строка - имя выполняемой команды;
////	СоединениеНаСервере - Булево - Истина, если соединение с сервисом ИПП
////		устанавливается на сервере платформы.
////	КонтекстВыполнения - Число - в параметре возвращается контекст выполнения
////		команды: 0 - сервер платформы, 1 - клиент, -1 - неизвестная команда.
////
////Процедура КонтекстВыполненияКоманды(ИмяКоманды, СоединениеНаСервере, КонтекстВыполнения) Экспорт
//
//
//
// - "ВыполнитьКомандуСервиса"
//// Выполнение команды сервиса ИПП на стороне сервера платформы.
//// Вызывается из ИнтернетПоддержкаПользователейВызовСервера.ВыполнитьКомандуСервиса().
//// Параметры:
////	КСКонтекст - см. описание функции
////		ИнтернетПоддержкаПользователейВызовСервера.НовыйКонтекстВзаимодействия();
////	СтруктураКоманды - см. описание функции
////		ИнтернетПоддержкаПользователейКлиентСервер.СтруктурироватьОтветСервера();
////	КонтекстОбработчика - см. описание функции
////		ИнтернетПоддержкаПользователейКлиентСервер.НовыйКонтекстОбработчикаКоманд()
////
////Процедура ВыполнитьКомандуСервиса(КСКонтекст, СтруктураКоманды, КонтекстОбработчика) Экспорт
//
//
//
//
// - "СтруктурироватьКомандуСервиса"
//// Вызывается при структурировании команды сервиса Интернет-поддержки на стороне
//// сервера платформы.
//// Подробнее см. функцию
//// МониторИнтернетПоддержкиКлиентСервер.СтруктурироватьОтветСервера().
////
////Процедура СтруктурироватьКомандуСервиса(ИмяКоманды, КомандаСервиса, СтруктураКоманды) Экспорт
//
//
//
//
//
// - "ЗаполнитьПараметрыВнутреннейФормы"
//// Вызывается при необходимости определения параметров формы по ее индексу
//// на стороне сервера платформы.
//// Вызывается из ИнтернетПоддержкаПользователейКлиентСервер.ПараметрыВнутреннейФормы()
//// Параметры:
////	ИндексФормы - Строка - индекс формы бизнес-процесса.
////	Параметры - Структура - параметры формы. В структуру добавляются поля:
////		* ИмяОткрываемойФормы - Строка - полное имя формы по ее индексу,
////			дополнительные параметры открытия формы.
////
////Процедура ЗаполнитьПараметрыВнутреннейФормы(ИндексФормы, Параметры) Экспорт
//
//
//
// 2. Клиентские обработчики
//
// 1) ПриНачалеРаботыСистемы - описание обработчиков, заполняющих параметры работы клиента при запуске.
// КлиентскиеОбработчики.ПриНачалеРаботыСистемы.Добавить(<ИмяМодуля>);
// добавляется имя модуля, реализующего экспортную процедуру служебного программного интерфейса,
// выполняемую при начале работы системы:
//
//// Вызывается при начале работы системы из
//// ИнтернетПоддержкаПользователейКлиент.ПриНачалеРаботыСистемы().
////
////Процедура ПриНачалеРаботыСистемы() Экспорт
//
//
// 2) БизнесПроцессы - описание обработчиков бизнес-процессов в контексте сервера платформы,
//	реализуемых подсистемой.
//
// КлиентскиеОбработчики.БизнесПроцессы.Вставить("<МестоЗапуска>\<ИмяСобытия>", <ИмяМодуля>);
//		МестоЗапуска - точка входа, обрабатываемая подсистемой;
//		ИмяСобытия - строковое имя события;
//		ИмяМодуля - имя модуля, реализующего экспортную процедуру служебного программного
//			интерфейса для обработки события.
//
// Имена событий и описание методов служебного программного интерфейса:
//
// - "ОпределитьВозможностьЗапуска"
// - "ОпределитьВозможностьЗапуска"
//// Выполняет дополнительную проверку возможности запуска бизнес-процесса
//// по точке входа и параметрам создания контекста взаимодействия.
//// Вызывается из ИнтернетПоддержкаПользователейКлиентСервер.ОпределитьВозможностьЗапускаПоМестуИПараметрам()
////
//// Параметры:
////	МестоЗапуска - Строка - точка входа бизнес-процесса.
////	ПараметрыИнтернетПоддержки - см. функцию
////		ИнтернетПоддержкаПользователей.ПараметрыСозданияКонтекста();
////	ОписаниеДействия - Структура - в структуре возвращается описание
////		выполняемого действия в случае запрета запуска бизнес-процесса.
////		см. ИнтернетПоддержкаПользователейКлиентСервер.ОпределитьВозможностьЗапускаПоМестуИПараметрам().
////
////Процедура ОпределитьВозможностьЗапуска(
////	МестоЗапуска,
////	ПараметрыИнтернетПоддержки,
////	ОписаниеДействия) Экспорт
//
//
//
//
// - "КонтекстВыполненияКоманды"
//// Определяет контекст выполнения команды сервиса Интернет-поддержки: клиент
//// или сервер платформы.
//// Вызывается из ИнтернетПоддержкаПользователейКлиентСервер.ТипКоманды()
////
//// Параметры:
////	ИмяКоманды - Строка - имя выполняемой команды;
////	СоединениеНаСервере - Булево - Истина, если соединение с сервисом ИПП
////		устанавливается на сервере платформы.
////	КонтекстВыполнения - Число - в параметре возвращается контекст выполнения
////		команды: 0 - сервер платформы, 1 - клиент, -1 - неизвестная команда.
////
////Процедура КонтекстВыполненияКоманды(ИмяКоманды, СоединениеНаСервере, КонтекстВыполнения) Экспорт
//
//
//
//
//
// - "ВыполнитьКомандуСервиса"
//// Выполнение команды сервиса ИПП на стороне сервера платформы.
//// Вызывается из ИнтернетПоддержкаПользователейКлиент.ВыполнитьКомандуСервиса()
////
//// Параметры:
////	КонтекстВзаимодействия - см. описание функции
////		ИнтернетПоддержкаПользователейВызовСервера.НовыйКонтекстВзаимодействия();
////	СтруктураКоманды - см. описание функции
////		ИнтернетПоддержкаПользователейКлиентСервер.СтруктурироватьОтветСервера();
////	КонтекстОбработчика - см. описание функции
////		ИнтернетПоддержкаПользователейКлиентСервер.НовыйКонтекстОбработчикаКоманд()
////	ПрерватьОбработкуКоманд - Булево - в параметре возвращается признак
////		необходимости остановки выполнения команд при возникновении асинхронного действия.
////
////Процедура ВыполнитьКомандуСервиса(
////	КонтекстВзаимодействия,
////	ТекущаяФорма,
////	СтруктураКоманды,
////	КонтекстОбработчика,
////	ПрерватьОбработкуКоманд) Экспорт
//
//
//
//
// - "ПараметрыОткрытияФормы"
//// Вызывается при формировании параметров открытия формы бизнес-процесса,
//// передаваемых в метода ПолучитьФорму().
//// Вызывается из ИнтернетПоддержкаПользователейКлиент.СформироватьПараметрыОткрытияФормы()
////
//// Параметры:
////	КСКонтекст - см. функцию
////		ИнтернетПоддержкаПользователейВызовСервера.НовыйКонтекстВзаимодействия()
////	ИмяОткрываемойФормы - Строка - полное имя открываемой формы;
////	Параметры - Структура - заполняемые параметры открытия формы.
////
////Процедура ПараметрыОткрытияФормы(КСКонтекст, ИмяОткрываемойФормы, Параметры) Экспорт
//
//
//
//
// - "СтруктурироватьКомандуСервиса"
//// Вызывается при структурировании команды сервиса Интернет-поддержки на стороне
//// сервера платформы.
//// Подробнее см. функцию
//// МониторИнтернетПоддержкиКлиентСервер.СтруктурироватьОтветСервера().
////
////Процедура СтруктурироватьКомандуСервиса(ИмяКоманды, КомандаСервиса, СтруктураКоманды) Экспорт
//
//
//
//
// - "ЗаполнитьПараметрыВнутреннейФормы"
//// Вызывается при необходимости определения параметров формы по ее индексу
//// на стороне сервера платформы.
//// Вызывается из ИнтернетПоддержкаПользователейКлиентСервер.ПараметрыВнутреннейФормы()
//// Параметры:
////	ИндексФормы - Строка - индекс формы бизнес-процесса.
////	Параметры - Структура - параметры формы. В структуру добавляются поля:
////		* ИмяОткрываемойФормы - Строка - полное имя формы по ее индексу,
////			дополнительные параметры открытия формы.
////
////Процедура ЗаполнитьПараметрыВнутреннейФормы(ИндексФормы, Параметры) Экспорт
//
Функция ОбработчикиСобытий() Экспорт
	
	Результат = Новый Структура;
	
	ИменаМодулейПодсистем = ИнтернетПоддержкаПользователей.МодулиПодсистем();
	
	// Добавление обработчиков событий
	
	Серверные = Новый Структура;
	Серверные.Вставить("ПараметрыРаботыКлиентаПриЗапуске", Новый Массив);
	Серверные.Вставить("ПараметрыРаботыКлиента"          , Новый Массив);
	Серверные.Вставить("ОчиститьНастройкиИПППользователя", Новый Массив);
	Серверные.Вставить("БизнесПроцессы"                  , Новый Соответствие);
	
	Клиентские = Новый Структура;
	Клиентские.Вставить("ПриНачалеРаботыСистемы", Новый Массив);
	Клиентские.Вставить("БизнесПроцессы"        , Новый Соответствие);
	
	Для каждого ИмяМодуля Из ИменаМодулейПодсистем Цикл
		
		МодульПодсистемы = ОбщегоНазначения.ОбщийМодуль(ИмяМодуля);
		Если МодульПодсистемы = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		// Добавление подсистемой обработчиков событий
		МодульПодсистемы.ДобавитьОбработчикиСобытий(Серверные, Клиентские);
		
	КонецЦикла;
	
	Результат.Вставить("Сервер", Серверные);
	Результат.Вставить("Клиент", Клиентские);
	
	Возврат Результат;
	
КонецФункции

Функция ОпределенияСервиса(МестоположениеWSDL, ОписательОшибки, ТаймаутПодключения = -1) Экспорт
	
	Определения = ИнтернетПоддержкаПользователейКлиентСервер.НовыйОпределенияСервиса(
		МестоположениеWSDL,
		,
		ТаймаутПодключения);
	
	Если НЕ ПустаяСтрока(Определения.КодОшибки) Тогда
		ОписательОшибки = Определения;
		ВызватьИсключение Определения.СообщениеОбОшибке;
	КонецЕсли;
	
	Возврат Определения;
	
КонецФункции

Функция НастройкиСоединенияССерверамиИПП() Экспорт
	
	Результат = Новый Структура;
	УстановитьПривилегированныйРежим(Истина);
	
	Если ОбщегоНазначенияКлиентСервер.ЭтоВебКлиент() Тогда
		Результат.Вставить("УстанавливатьПодключениеНаСервере", Истина);
	ИначеЕсли ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		Результат.Вставить("УстанавливатьПодключениеНаСервере", Ложь);
	КонецЕсли;
	
	ТекстЗапроса      = "";
	КолонкиПараметров = Новый Массив;
	Таблицы           = Новый Массив;
	
	КолонкиПараметров.Добавить("ВЫБОР
		|		КОГДА ТаймаутПодключенияКСервисуИнтернетПоддержки.Значение = 0
		|			ТОГДА 30
		|		ИНАЧЕ ТаймаутПодключенияКСервисуИнтернетПоддержки.Значение
		|	КОНЕЦ КАК ТаймаутПодключения");
	КолонкиПараметров.Добавить("ДоменРасположенияСерверовИПП.Значение КАК ДоменРасположенияСерверовИПП");
	Если НЕ Результат.Свойство("УстанавливатьПодключениеНаСервере") Тогда
		КолонкиПараметров.Добавить("ПодключениеКСервисуИППССервера.Значение КАК УстанавливатьПодключениеНаСервере");
		Таблицы.Добавить("Константа.ПодключениеКСервисуИППССервера КАК ПодключениеКСервисуИППССервера");
	КонецЕсли;
	
	Таблицы.Добавить("Константа.ТаймаутПодключенияКСервисуИнтернетПоддержки КАК ТаймаутПодключенияКСервисуИнтернетПоддержки");
	Таблицы.Добавить("Константа.ДоменРасположенияСерверовИПП КАК ДоменРасположенияСерверовИПП");
	
	КолонкиСтр = "";
	Для Итератор = 0 По КолонкиПараметров.ВГраница() Цикл
		КолонкиСтр = КолонкиСтр + ?(Итератор > 0, ",", "") + КолонкиПараметров[Итератор];
	КонецЦикла;
	
	ТаблицыСтр = "";
	Для Итератор = 0 По Таблицы.ВГраница() Цикл
		ТаблицыСтр = ТаблицыСтр + ?(Итератор > 0, ",", "") + Таблицы[Итератор];
	КонецЦикла;
	
	ТекстЗапроса = "ВЫБРАТЬ " + КолонкиСтр + " ИЗ " + ТаблицыСтр;
	
	ЗапросПараметров = Новый Запрос(ТекстЗапроса);
	РезультатЗапроса = ЗапросПараметров.Выполнить();
	
	ВыборкаПараметров = РезультатЗапроса.Выбрать();
	ВыборкаПараметров.Следующий();
	
	Если НЕ Результат.Свойство("УстанавливатьПодключениеНаСервере") Тогда
		Результат.Вставить("УстанавливатьПодключениеНаСервере", ВыборкаПараметров.УстанавливатьПодключениеНаСервере);
	КонецЕсли;
	
	Результат.Вставить("ТаймаутПодключения"          , ВыборкаПараметров.ТаймаутПодключения);
	Результат.Вставить("ДоменРасположенияСерверовИПП", 1);
	
	Возврат Результат;
	
КонецФункции

Функция ПроверитьURLДоступен(URL, ИмяОшибки, СообщениеОбОшибке, ИнформацияОбОшибке) Экспорт
	
	ИнтернетПоддержкаПользователейКлиентСервер.СлужебнаяПроверитьURLДоступен(
		URL,
		ИмяОшибки,
		СообщениеОбОшибке,
		ИнформацияОбОшибке);
	
	Если Не ПустаяСтрока(ИмяОшибки) Тогда
		ВызватьИсключение ИмяОшибки;
	КонецЕсли;
	
	Возврат "";
	
КонецФункции

// Возвращает base64-строку: идентификатор конфигурации информационной базы.
//
Функция ИДКонфигурации() Экспорт
	
	Если ИнтернетПоддержкаПользователей.ДоступнаРаботаСНастройкамиКлиентаЛицензирования() Тогда
		Возврат КлиентЛицензирования.ИДКонфигурации();
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

#КонецОбласти