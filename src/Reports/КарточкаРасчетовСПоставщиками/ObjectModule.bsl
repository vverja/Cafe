#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//   Форма - УправляемаяФорма - Форма отчета.
//   КлючВарианта - Строка - Имя предопределенного варианта отчета или уникальный идентификатор пользовательского.
//   Настройки - Структура - см. возвращаемое значение ОтчетыКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию().
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	Настройки.События.ПриСозданииНаСервере = Истина;
	Настройки.События.ПередЗагрузкойВариантаНаСервере = Истина;
КонецПроцедуры

// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
//
// Параметры:
//   Форма - УправляемаяФорма - Форма отчета.
//   Отказ - Передается из параметров обработчика "как есть".
//   СтандартнаяОбработка - Передается из параметров обработчика "как есть".
//
// См. также:
//   "УправляемаяФорма.ПриСозданииНаСервере" в синтакс-помощнике.
//
Процедура ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка) Экспорт
	
	Параметры = ЭтаФорма.Параметры;
	
	Если Параметры.Свойство("ПараметрКоманды")
			И Параметры.Свойство("ПараметрыОтчет")
			И Параметры.ПараметрыОтчет.Свойство("ДополнительныеПараметры") Тогда 
		
		Если Параметры.ПараметрыОтчет.ДополнительныеПараметры.ИмяКоманды = "КарточкаРасчетовСПоставщиком" Тогда
			
			Параметры.КлючВарианта = СформироватьПараметрыКарточкаРасчетовСПоставщиком(Параметры.ПараметрКоманды, ЭтаФорма.ФормаПараметры, Параметры);
			
		ИначеЕсли Параметры.ПараметрыОтчет.ДополнительныеПараметры.ИмяКоманды = "КарточкаРасчетовСПоставщикомПоДокументам" Тогда
			
			СтруктураНастроек = ПолучитьСтруктуруНастроек(Параметры.ПараметрКоманды);
			ЗначенияФункциональныхОпций = СтруктураНастроек.ЗначенияФункциональныхОпций;	
			СтрокаБазовая = ?(ЗначенияФункциональныхОпций.БазоваяВерсия, "Базовая", "");
			
			Параметры.КлючВарианта = "КарточкаРасчетовСПоставщикамиПоДокументамКонтекст" + СтрокаБазовая;
			
			Параметры.КлючНазначенияИспользования = Параметры.ПараметрКоманды;
			ЭтаФорма.ФормаПараметры.КлючНазначенияИспользования = Параметры.ПараметрКоманды;
			
			ЭтаФорма.ФормаПараметры.Отбор = СтруктураНастроек.СтруктураОтборов;
			
		КонецЕсли;
		
	КонецЕсли;
	
	ФормаПараметры = ЭтаФорма.ФормаПараметры;
	КомпоновщикНастроекФормы = ЭтаФорма.Отчет.КомпоновщикНастроек;
	
	ВзаиморасчетыСервер.ЗаменитьДокументыРасчетовСПоставщиками(ФормаПараметры);
	
КонецПроцедуры

// Вызывается в одноименном обработчике формы отчета после выполнения кода формы.
//
// Подробнее - см. ОтчетыПереопределяемый.ПередЗагрузкойВариантаНаСервере
//
Процедура ПередЗагрузкойВариантаНаСервере(ЭтаФорма, НовыеНастройкиКД) Экспорт
	
	
	Отчет = ЭтаФорма.Отчет;
	КомпоновщикНастроекФормы = Отчет.КомпоновщикНастроек;
	
	// Изменение настроек по функциональным опциям
	НастроитьПараметрыОтборыПоФункциональнымОпциям(КомпоновщикНастроекФормы);
	
	НовыеНастройкиКД = КомпоновщикНастроекФормы.Настройки;
	

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)

	СегментыСервер.ВключитьОтборПоСегментуПартнеровВСКД(КомпоновщикНастроек);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура НастроитьПараметрыОтборыПоФункциональнымОпциям(КомпоновщикНастроекФормы)
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьПартнеровКакКонтрагентов") Тогда
		КомпоновкаДанныхСервер.УдалитьЭлементОтбораИзВсехНастроекОтчета(КомпоновщикНастроекФормы, "Контрагент");
	КонецЕсли;
	
КонецПроцедуры

Функция СформироватьПараметрыКарточкаРасчетовСПоставщиком(ПараметрКоманды, ПараметрыФормы, Параметры)
	
	Если ТипЗнч(ПараметрКоманды) = Тип("Массив") Тогда
		ЭтоМассив = Истина;
		Если ПараметрКоманды.Количество() > 0 Тогда
			ПервыйЭлемент = ПараметрКоманды[0];
		Иначе
			ПервыйЭлемент = Неопределено;
		КонецЕсли;
	Иначе
		ЭтоМассив = Ложь;
		ПервыйЭлемент = ПараметрКоманды;
	КонецЕсли;
	
	Если ЭтоМассив Тогда
		ЕстьПодчиненныеПартнеры = Ложь;
		Для Каждого ЭлементПараметраКоманды Из ПараметрКоманды Цикл
			Если ПартнерыИКонтрагенты.ЕстьПодчиненныеПартнеры(ЭлементПараметраКоманды) Тогда
				ЕстьПодчиненныеПартнеры = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
	Иначе
		ЕстьПодчиненныеПартнеры = ПартнерыИКонтрагенты.ЕстьПодчиненныеПартнеры(ПараметрКоманды);
	КонецЕсли;
	
	СтрокаБазовая = ?(ПолучитьФункциональнуюОпцию("БазоваяВерсия"), "Базовая", "");
	
	КлючВарианта = Неопределено;
	
	Если ЕстьПодчиненныеПартнеры Тогда
		ФиксированныеНастройки = Новый НастройкиКомпоновкиДанных();
		ЭлементОтбора = ФиксированныеНастройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Партнер");
		Если ЭтоМассив Тогда
			ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСпискеПоИерархии;
		Иначе
			ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВИерархии;
		КонецЕсли;
		ЭлементОтбора.ПравоеЗначение = ПараметрКоманды;
		ПараметрыФормы.ФиксированныеНастройки = ФиксированныеНастройки;
		Параметры.ФиксированныеНастройки = ФиксированныеНастройки;
		ПараметрыФормы.КлючНазначенияИспользования = "ГруппаПартнеров";
		Параметры.КлючНазначенияИспользования = "ГруппаПартнеров";
		
		КлючВарианта = "КарточкаРасчетовСПоставщикамиКонтекст" + СтрокаБазовая;
	Иначе
		ПараметрыФормы.Отбор = Новый Структура("Партнер", ПараметрКоманды);
		ПараметрыФормы.КлючНазначенияИспользования = ПараметрКоманды;
		Параметры.КлючНазначенияИспользования = ПараметрКоманды;
		
		Если ЭтоМассив И ПараметрКоманды.Количество() = 1 Тогда
			КлючВарианта = "КарточкаРасчетовСПоставщикомКонтекст" + СтрокаБазовая;
		Иначе
			КлючВарианта = "КарточкаРасчетовСПоставщикамиКонтекст" + СтрокаБазовая;
		КонецЕсли;
	КонецЕсли;
	
	Возврат КлючВарианта;
	
КонецФункции

Функция ПолучитьСтруктуруНастроек(ПараметрКоманды)
	
	ЗначенияФункциональныхОпций = Новый Структура("БазоваяВерсия", ПолучитьФункциональнуюОпцию("БазоваяВерсия"));
	
	Типы = Новый Массив;
	Типы.Добавить(Тип("ДокументСсылка.ПоступлениеТоваровУслуг"));
	Типы.Добавить(Тип("ДокументСсылка.ТаможеннаяДекларацияИмпорт"));
	Типы.Добавить(Тип("ДокументСсылка.ЗаказПоставщику"));
	Типы.Добавить(Тип("ДокументСсылка.ВозвратТоваровПоставщику"));
	Типы.Добавить(Тип("ДокументСсылка.ПоступлениеУслугПрочихАктивов"));
	Типы.Добавить(Тип("ДокументСсылка.ВыкупВозвратнойТарыУПоставщика"));
	
	СтруктураНастроек = Новый Структура;
	СтруктураНастроек.Вставить("ЗначенияФункциональныхОпций", ЗначенияФункциональныхОпций);
	СтруктураНастроек.Вставить("СтруктураОтборов",
	                           ВзаиморасчетыСервер.СтруктураОтборовОтчетовРасчетыСКлиентами(ПараметрКоманды,
	                                                                                        "КарточкаРасчетовСПоставщиками",
	                                                                                        "КарточкаРасчетовСПоставщикомПоДокументам",
	                                                                                        Типы));
	Возврат СтруктураНастроек
	
КонецФункции

#КонецОбласти

#КонецЕсли