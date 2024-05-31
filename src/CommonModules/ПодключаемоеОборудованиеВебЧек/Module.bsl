#Область ПрограммныйИнтерфейс

// Функция возвращает возможность работы модуля в асинхронном режиме.
// Стандартные команды модуля:
// - ПодключитьУстройство
// - ОтключитьУстройство
// - ВыполнитьКоманду
// Команды модуля для работы асинхронном режиме (должны быть определены):
// - НачатьПодключениеУстройства
// - НачатьОтключениеУстройства
// - НачатьВыполнениеКоманды.
//
Функция ПоддержкаАсинхронногоРежима() Экспорт
	
	Возврат Ложь;
	
КонецФункции

// Функция осуществляет подключение устройства.
//
Функция ПодключитьУстройство(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры) Экспорт
	
	Результат = Истина;
	НовыйСтандарт = Ложь;
	
	ВыходныеПараметры = Новый Массив();
	ПараметрыПодключения.Вставить("ИДУстройства", "");
	
	
	
	//Если ТипОборудованияИспользуемый = "ЭквайринговыйТерминал" Тогда
	ПараметрыПодключения.Вставить("КодОригинальнойТранзакции", Неопределено);
	ПараметрыПодключения.Вставить("ТипТранзакции", "");
	//	КонецЕсли;
	
	
	Возврат Результат;
	
КонецФункции

// Функция осуществляет отключение устройства.
//
Функция ОтключитьУстройство(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры) Экспорт
	
	Результат = Истина;
	
	ВыходныеПараметры = Новый Массив();
	
	//	ОбъектДрайвера.Отключить(ПараметрыПодключения.ИДУстройства);
	
	Возврат Результат;
	
КонецФункции

// Функция получает, обрабатывает и перенаправляет на исполнение команду к драйверу.
//
Функция ВыполнитьКоманду(Команда, ВходныеПараметры = Неопределено, ВыходныеПараметры = Неопределено,
	ОбъектДрайвера, Параметры, ПараметрыПодключения) Экспорт
	
	Результат = Истина;
	
	ВыходныеПараметры = Новый Массив();
	
	// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩИЕ ДЛЯ ВСЕХ ТИПОВ ДРАЙВЕРОВ
	
	// Тестирование устройства
	Если Команда = "ТестУстройства" ИЛИ Команда = "CheckHealth" Тогда
		Результат = ТестУстройства(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);
		
	ИначеЕсли Команда = "ВыполнитьДополнительноеДействие" ИЛИ Команда = "DoAdditionalAction" Тогда
		ИмяДействия = ВходныеПараметры[0];
		Результат = ВыполнитьДополнительноеДействие(ОбъектДрайвера, Параметры, ПараметрыПодключения, ИмяДействия, ВыходныеПараметры);
		
		// Получение версии драйвера
	ИначеЕсли Команда = "ПолучитьВерсиюДрайвера" ИЛИ Команда = "GetVersion" Тогда
		Результат = ПолучитьВерсиюДрайвера(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);
		
		// Получение описание драйвера.
	ИначеЕсли Команда = "ПолучитьОписаниеДрайвера" ИЛИ Команда = "GetDescription" Тогда
		Результат = ПолучитьОписаниеДрайвера(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);
		
		// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩИЕ ДЛЯ РАБОТЫ С ЭКВАЙРИНГОВЫМИ ТЕРМИНАЛАМИ
		
		// Функция возвращает, будет ли печать слип чеков на терминале.
	ИначеЕсли Команда = "PrintSlipOnTerminal" ИЛИ Команда = "ПечатьКвитанцийНаТерминале" Тогда
		Результат = ПечатьКвитанцийНаТерминале(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);
		
		// Оплата платежной картой
	ИначеЕсли Команда = "AuthorizeSales" ИЛИ Команда = "ОплатитьПлатежнойКартой" Тогда
		Сумма      = ВходныеПараметры[0];
		НомерКарты = ВходныеПараметры[1];
		НомерЧека  = ?(ВходныеПараметры.Количество() > 2, ВходныеПараметры[2], "");
		Результат = ОплатитьПлатежнойКартой(ОбъектДрайвера, Параметры, ПараметрыПодключения,
		Сумма,  НомерКарты, НомерЧека, ВыходныеПараметры);
		// Возврат платежа
	ИначеЕсли Команда = "AuthorizeRefund" ИЛИ Команда = "ВернутьПлатежПоПлатежнойКарте" Тогда
		Сумма          = ВходныеПараметры[0];
		НомерКарты     = ВходныеПараметры[1];
		СсылочныйНомер = ?(ВходныеПараметры.Количество() > 2, ВходныеПараметры[2], "");
		НомерЧека      = ?(ВходныеПараметры.Количество() > 3, ВходныеПараметры[3], "");
		Результат = ВернутьПлатежПоПлатежнойКарте(ОбъектДрайвера, Параметры, ПараметрыПодключения,
		Сумма, НомерКарты, СсылочныйНомер, НомерЧека, ВыходныеПараметры);
		// Отмена платежа
	ИначеЕсли Команда = "AuthorizeVoid" ИЛИ Команда = "ОтменитьПлатежПоПлатежнойКарте" Тогда
		Сумма          = ВходныеПараметры[0];
		СсылочныйНомер = ВходныеПараметры[1];
		НомерЧека      = ?(ВходныеПараметры.Количество() > 2, ВходныеПараметры[2], "");
		Результат = ОтменитьПлатежПоПлатежнойКарте(ОбъектДрайвера, Параметры, ПараметрыПодключения,
		Сумма, СсылочныйНомер, НомерЧека, ВыходныеПараметры);
		// Сверка итогов по картам
	ИначеЕсли Команда = "Settlement" ИЛИ Команда = "ИтогиДняПоКартам" Тогда
		Результат = ИтогиДняПоКартам(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);
		
		// Аварийная отмена платежа
	ИначеЕсли Команда = "EmergencyVoid" ИЛИ Команда = "АварийнаяОтменаОперации" Тогда
		Результат = АварийнаяОтменаОперации(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);
		
		// Преавторизация платежа
	ИначеЕсли Команда = "AuthorizePreSales" ИЛИ Команда = "ПреавторизацияПоПлатежнойКарте" Тогда
		Сумма      = ВходныеПараметры[0];
		НомерКарты = ВходныеПараметры[1];
		НомерЧека  = ?(ВходныеПараметры.Количество() > 2, ВходныеПараметры[2], "");
		Результат = ПреавторизоватьПоПлатежнойКарте(ОбъектДрайвера, Параметры, ПараметрыПодключения,
		Сумма, НомерКарты, НомерЧека, ВыходныеПараметры);
		
		// Отмена преавторизации платежа.
	ИначеЕсли Команда = "AuthorizeVoidPreSales" ИЛИ Команда = "ОтменитьПреавторизациюПоПлатежнойКарте" Тогда
		Сумма          = ВходныеПараметры[0];
		НомерКарты     = ВходныеПараметры[1];
		СсылочныйНомер = ?(ВходныеПараметры.Количество() > 2, ВходныеПараметры[2], "");
		НомерЧека      = ?(ВходныеПараметры.Количество() > 3, ВходныеПараметры[3], "");
		Результат = ОтменитьПреавторизациюПоПлатежнойКарте(ОбъектДрайвера, Параметры, ПараметрыПодключения,
		Сумма, НомерКарты, СсылочныйНомер, НомерЧека, ВыходныеПараметры);
		
		// Завершение преавторизации платежа.
	ИначеЕсли Команда = "AuthorizeCompletion" ИЛИ Команда = "ЗавершитьПреавторизациюПоПлатежнойКарте" Тогда
		Сумма          = ВходныеПараметры[0];
		НомерКарты     = ВходныеПараметры[1];
		СсылочныйНомер = ?(ВходныеПараметры.Количество() > 2, ВходныеПараметры[2], "");
		НомерЧека      = ?(ВходныеПараметры.Количество() > 3, ВходныеПараметры[3], "");
		Результат = ЗавершитьПреавторизациюПоПлатежнойКарте(ОбъектДрайвера, Параметры, ПараметрыПодключения,
		Сумма, НомерКарты, СсылочныйНомер, НомерЧека, ВыходныеПараметры);
		
		// Указанная команда не поддерживается данным драйвером
	Иначе
		СообщениеОбОшибке = НСтр("ru='Команда ""%Команда%"" не поддерживается данным драйвером.';uk='Команда ""%Команда%"" не підтримується цим драйвером.'");
		СообщениеОбОшибке = СтрЗаменить(СообщениеОбОшибке, "%Команда%", Команда);
		СформироватьОшибку(ВыходныеПараметры, СообщениеОбОшибке);
		Результат = Ложь;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Размер пакета в элементах передаваемой информации в драйвер.
//
Функция РазмерПакетаПоУмолчанию() Экспорт
	
	РазмерПакета = 200;
	Возврат РазмерПакета;
	
КонецФункции

#КонецОбласти


#Область ПроцедурыИФункцииОбщиеДляЭквайринговыхТерминалов

// Функция возвращает, будет ли печать слип чеков на терминале.
//
Функция ПечатьКвитанцийНаТерминале(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры) Экспорт
	
	Результат = Истина;
	
	//Попытка
	//	Ответ = ОбъектДрайвера.ПечатьКвитанцийНаТерминале();
	ВыходныеПараметры.Очистить();  
	ВыходныеПараметры.Добавить(Истина);
	
	Возврат Результат;
	
КонецФункции

// Функция осуществляет сверку итогов по картам.
//
Функция ИтогиДняПоКартам(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры)
	
	
	Результат = Истина;
	Ответ     = Ложь;
	СлипЧек   = "";
	ТипСоединения = 0;
	comport = "";
	Dest = "COM1";
	МерчантИД = 0;

	
	ПараметрыПодключения.ТипТранзакции = НСтр("ru='Сверка итогов';uk='Звірка підсумків'");
		Если Параметры.МерчантИД = ""  Тогда
		  МерчантИД = Параметры.МерчантИД;
	КонецЕсли;
	Если  Параметры.ТипСоединения = 0 Тогда
		
		Dest = "COM"+Строка(Параметры.Порт);
		
	ИначеЕсли Параметры.ТипСоединения =1 Тогда

		Dest = СокрЛП(Параметры.IP);
	иначе
		Dest = "demo";
		
	КонецЕсли;	
	
	Попытка
			Ответ=ОбъектДрайвера.Cardserv("<?xml version=""1.0"" encoding=""UTF-8""?> <InputParameters> <Parameters  type="""+Параметры.Модель+"""  dest="""+Dest+"""  method= ""Verify"" merchantId = """+МерчантИД+"""  /></InputParameters>");
	
	//	Ответ = ОбъектДрайвера.ИтогиДняПоКартам(ПараметрыПодключения.ИДУстройства, СлипЧек);
	Если Ответ Тогда
		СлипЧек = "";
			ВыходныеПараметры.Очистить();
			МассивМассивов = Новый Массив();
			МассивМассивов.Добавить("СлипЧек");
			МассивМассивов.Добавить(СлипЧек);
			ВыходныеПараметры.Добавить(МассивМассивов);
		Иначе
			Результат = Ложь;
			ОписаниеОшибки = "";
			ОбъектДрайвера.ПолучитьОшибку(ОписаниеОшибки);
			СформироватьОшибку(ВыходныеПараметры, ОписаниеОшибки);
		КонецЕсли;
	Исключение
		Результат = Ложь;
		СформироватьОшибкуДрайвера(ВыходныеПараметры, "ИтогиДняПоКартам", ОписаниеОшибки());
	КонецПопытки;
	


	
КонецФункции

// Функция осуществляет авторизацию/оплату по карте.
//
Функция ОплатитьПлатежнойКартой(ОбъектДрайвера, Параметры, ПараметрыПодключения,
	Сумма, НомерКарты, НомерЧека, ВыходныеПараметры)
	
	Результат      = Истина;
	КодRRN         = "";
	КодАвторизации = "";
	СлипЧек        = "";
	ТипСоединения = 0;
	comport = "";
	Dest = "COM1";
	
		МерчантИД = 0;
	Если Параметры.МерчантИД <> ""  Тогда
		  МерчантИД = Параметры.МерчантИД;
	КонецЕсли;	

	
	Если  Параметры.ТипСоединения = 0 Тогда
		
		Dest = "COM"+Строка(Параметры.Порт);
		
	ИначеЕсли Параметры.ТипСоединения =1 Тогда

		Dest = СокрЛП(Параметры.IP);
	иначе
		Dest = "demo";
		
	КонецЕсли;	
	ПараметрыПодключения.ТипТранзакции = НСтр("ru='Оплатить';uk='Оплатити'");
	
	Если НЕ (Сумма > 0) Тогда
		ПараметрыПодключения.ТипТранзакции = НСтр("ru='Отказ';uk='Відмова'");
		Результат = Ложь;
		ТекстОшибки = НСтр("ru='Не корректная сумма операции.';uk='Не коректна сума операції.'");
		СформироватьОшибку(ВыходныеПараметры, ТекстОшибки);
		Возврат Результат;
	КонецЕсли;
	
	попытка
	Ответ=ОбъектДрайвера.Cardserv("<?xml version=""1.0"" encoding=""UTF-8""?> <InputParameters> <Parameters  type="""+Параметры.Модель+"""  dest="""+Dest+"""  method= ""Purchase"" amount = """+СтрЗаменить(Сумма,Символы.НПП,"")+""" merchantId = """+МерчантИД+"""  /></InputParameters>");
	//  Ответ = истина;
//	зн = 1/0;
	СтруктураПараметров = Новый Структура;
	Если  Ответ Тогда
		
		СтрокаXMLОтвет = ОбъектДрайвера.StatusBarXML();                                                                                                      
		
		Если СтрДлина(СтрокаXMLОтвет)>0 Тогда
			ЧтениеXML = Новый ЧтениеXML;
			ЧтениеXML.УстановитьСтроку(СтрокаXMLОтвет);
			ЧтениеXML.ПерейтиКСодержимому();
			
			Пока ЧтениеXML.Прочитать() Цикл
				Если ЧтениеXML.Имя = "Parameters" И ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда  
					Пока ЧтениеXML.ПрочитатьАтрибут() Цикл
						СтруктураПараметров.Вставить(ЧтениеXML.Имя,ЧтениеXML.Значение);	
					КонецЦикла;	
				КонецЕсли;
			КонецЦикла;	
		КонецЕсли;
		
		
	
	ТекстСообщения ="";		
	МассивСтрок = Новый Массив;
	МассивСтрок.Добавить(СтруктураПараметров.bankacquirer); //PA
	
	МассивСтрок.Добавить(СтруктураПараметров.terminalid);  //PB
	МассивСтрок.Добавить("Сплата"); //PC
	МассивСтрок.Добавить(СтруктураПараметров.pan); //PD
	МассивСтрок.Добавить(СтруктураПараметров.approvalcode); //PE
	МассивСтрок.Добавить(СтруктураПараметров.paymentsystem); //PSNM
	МассивСтрок.Добавить(СтруктураПараметров.rrn); //RRN
	
	СтрокаИзМассива = СтрСоединить(МассивСтрок, ";");
	КонецЕсли;

		Если Ответ Тогда
	ВыходныеПараметры.Очистить();
	ВыходныеПараметры.Добавить(СтруктураПараметров.pan);
	ВыходныеПараметры.Добавить(СтрокаИзМассива);
	ВыходныеПараметры.Добавить(СтруктураПараметров.invoicenumber);
	МассивМассивов = Новый Массив();
	МассивМассивов.Добавить("СлипЧек");
	МассивМассивов.Добавить("слип");
	ВыходныеПараметры.Добавить(МассивМассивов);
	ВыходныеПараметры.Добавить(СтруктураПараметров.approvalcode);
		Иначе
			ПараметрыПодключения.ТипТранзакции = НСтр("ru='Отказ';uk='Відмова'");
			Результат = Ложь;
			СтрокаXMLОтвет = "";
			СтрокаXMLОтвет = ОбъектДрайвера.StatusBarXML(); 
			СформироватьОшибку(ВыходныеПараметры, СтрокаXMLОтвет);
		КонецЕсли;
	Исключение
		Результат = Ложь;
		СформироватьОшибкуДрайвера(ВыходныеПараметры, "ОплатитьПлатежнойКартой","Помилка оплати карткою");
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

// Функция осуществляет возврат платежа по карте.
//
Функция ВернутьПлатежПоПлатежнойКарте(ОбъектДрайвера, Параметры, ПараметрыПодключения,
	Сумма, НомерКарты, СсылочныйНомер, НомерЧека, ВыходныеПараметры)
	
	Результат      = Истина;
	КодRRN         = "";
	КодАвторизации = "";
	СлипЧек        = "";
	ТипСоединения = 0;
	comport = "";
	Dest = "COM1";
	
	МерчантИД = 0;
	Если Параметры.МерчантИД <> ""  Тогда
		  МерчантИД = Параметры.МерчантИД;
	КонецЕсли;	

	
	Если  Параметры.ТипСоединения = 0 Тогда
		
		Dest = "COM"+Строка(Параметры.Порт);
		
	ИначеЕсли Параметры.ТипСоединения =1 Тогда

		Dest = СокрЛП(Параметры.IP);
	иначе
		Dest = "demo";
		
	КонецЕсли;	
	ПараметрыПодключения.ТипТранзакции = НСтр("ru='Оплатить';uk='Оплатити'");
	
	Если НЕ (Сумма > 0) Тогда
		ПараметрыПодключения.ТипТранзакции = НСтр("ru='Отказ';uk='Відмова'");
		Результат = Ложь;
		ТекстОшибки = НСтр("ru='Не корректная сумма операции.';uk='Не коректна сума операції.'");
		СформироватьОшибку(ВыходныеПараметры, ТекстОшибки);
		Возврат Результат;
	КонецЕсли;
	
	попытка
	Ответ=ОбъектДрайвера.Cardserv("<?xml version=""1.0"" encoding=""UTF-8""?> <InputParameters> <Parameters  type="""+Параметры.Модель+"""  dest="""+Dest+"""  method= ""Refund"" amount = """+СтрЗаменить(Сумма,Символы.НПП,"")+""" merchantId = """+МерчантИД+"""  rrn = """+СсылочныйНомер+"""  subMerchant = """"/></InputParameters>");
	//  Ответ = истина;
	//зн = 1/0;
	СтруктураПараметров = Новый Структура;
	Если  Ответ Тогда
		
		СтрокаXMLОтвет = ОбъектДрайвера.StatusBarXML();                                                                                                      
		
		Если СтрДлина(СтрокаXMLОтвет)>0 Тогда
			ЧтениеXML = Новый ЧтениеXML;
			ЧтениеXML.УстановитьСтроку(СтрокаXMLОтвет);
			ЧтениеXML.ПерейтиКСодержимому();
			
			Пока ЧтениеXML.Прочитать() Цикл
				Если ЧтениеXML.Имя = "Parameters" И ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда  
					Пока ЧтениеXML.ПрочитатьАтрибут() Цикл
						СтруктураПараметров.Вставить(ЧтениеXML.Имя,ЧтениеXML.Значение);	
					КонецЦикла;	
				КонецЕсли;
			КонецЦикла;	
		КонецЕсли;
		
		
	
	ТекстСообщения ="";		
	МассивСтрок = Новый Массив;
	МассивСтрок.Добавить(СтруктураПараметров.bankacquirer); //PA
	
	МассивСтрок.Добавить(СтруктураПараметров.terminalid);  //PB
	МассивСтрок.Добавить("Повернення"); //PC
	МассивСтрок.Добавить(СтруктураПараметров.pan); //PD
	МассивСтрок.Добавить(СтруктураПараметров.approvalcode); //PE
	МассивСтрок.Добавить(СтруктураПараметров.paymentsystem); //PSNM
	МассивСтрок.Добавить(СтруктураПараметров.rrn); //RRN
	
	СтрокаИзМассива = СтрСоединить(МассивСтрок, ";");
	КонецЕсли;

		Если Ответ Тогда
				//добавлено для совместимости
	МассивСтрок1 = Новый Массив;
	МассивСтрок1.Добавить(СтрокаИзМассива);
	МассивСтрок1.Добавить(СтрокаИзМассива);

	ВыходныеПараметры.Очистить();
	ВыходныеПараметры.Добавить(МассивСтрок1);
	ВыходныеПараметры.Добавить(СтрокаИзМассива);
	ВыходныеПараметры.Добавить(СтруктураПараметров.invoicenumber);
	МассивМассивов = Новый Массив();
	МассивМассивов.Добавить("СлипЧек");
	МассивМассивов.Добавить("слип");
	ВыходныеПараметры.Добавить(МассивМассивов);
	ВыходныеПараметры.Добавить(СтруктураПараметров.approvalcode);
		Иначе
			ПараметрыПодключения.ТипТранзакции = НСтр("ru='Отказ';uk='Відмова'");
			Результат = Ложь;
			СтрокаXMLОтвет = "";
			СтрокаXMLОтвет = ОбъектДрайвера.StatusBarXML(); 
			СформироватьОшибку(ВыходныеПараметры, СтрокаXMLОтвет);
		КонецЕсли;
	Исключение
		Результат = Ложь;
		СформироватьОшибкуДрайвера(ВыходныеПараметры, "ОплатитьПлатежнойКартой","Помилка оплати карткою");
	КонецПопытки;
	
	Возврат Результат;

КонецФункции

// Функция осуществляет отмену платежа по карте.
//
Функция ОтменитьПлатежПоПлатежнойКарте(ОбъектДрайвера, Параметры, ПараметрыПодключения,
	Сумма, СсылочныйНомер, НомерЧека, ВыходныеПараметры)
	
	
	Результат      = Истина;
	КодRRN         = "";
	КодАвторизации = "";
	СлипЧек        = "";
	ТипСоединения = 0;
	comport = "";
	Dest = "COM1";
	
		МерчантИД = 0;
	Если Параметры.МерчантИД <> ""  Тогда
		  МерчантИД = Параметры.МерчантИД;
	КонецЕсли;	

	
	Если  Параметры.ТипСоединения = 0 Тогда
		
		Dest = "COM"+Строка(Параметры.Порт);
		
	ИначеЕсли Параметры.ТипСоединения =1 Тогда

		Dest = СокрЛП(Параметры.IP);
	иначе
		Dest = "demo";
		
	КонецЕсли;	
	ПараметрыПодключения.ТипТранзакции = НСтр("ru='Оплатить';uk='Оплатити'");
	
	Если НЕ (Сумма > 0) Тогда
		ПараметрыПодключения.ТипТранзакции = НСтр("ru='Отказ';uk='Відмова'");
		Результат = Ложь;
		ТекстОшибки = НСтр("ru='Не корректная сумма операции.';uk='Не коректна сума операції.'");
		СформироватьОшибку(ВыходныеПараметры, ТекстОшибки);
		Возврат Результат;
	КонецЕсли;
	 rrn = "";
	//ВебЧек   	
				Если СтрДлина(СсылочныйНомер)>0  Тогда
					
					//Если ОбщиеПараметры.ДокументОснование.БезналичнаяОплата.Количество() > 0 Тогда
						МассивСтрок = СтрРазделить(Врег(СсылочныйНомер), ";");
						
						Если МассивСтрок.Количество()=7 Тогда
							rrn  = МассивСтрок[6];
						КонецЕсли;
						
			
				КонецЕсли;
		//ВебЧек

	
	попытка
	Ответ=ОбъектДрайвера.Cardserv("<?xml version=""1.0"" encoding=""UTF-8""?> <InputParameters> <Parameters  type="""+Параметры.Модель+"""  dest="""+Dest+"""  method= ""Refund"" amount = """+СтрЗаменить(Сумма,Символы.НПП,"")+""" merchantId = """+МерчантИД+"""  rrn = """+rrn+"""  subMerchant = """"/></InputParameters>");
	//  Ответ = истина;
	//зн = 1/0;
	СтруктураПараметров = Новый Структура;
	Если  Ответ Тогда
		
		СтрокаXMLОтвет = ОбъектДрайвера.StatusBarXML();                                                                                                      
		
		Если СтрДлина(СтрокаXMLОтвет)>0 Тогда
			ЧтениеXML = Новый ЧтениеXML;
			ЧтениеXML.УстановитьСтроку(СтрокаXMLОтвет);
			ЧтениеXML.ПерейтиКСодержимому();
			
			Пока ЧтениеXML.Прочитать() Цикл
				Если ЧтениеXML.Имя = "Parameters" И ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда  
					Пока ЧтениеXML.ПрочитатьАтрибут() Цикл
						СтруктураПараметров.Вставить(ЧтениеXML.Имя,ЧтениеXML.Значение);	
					КонецЦикла;	
				КонецЕсли;
			КонецЦикла;	
		КонецЕсли;
		
		
	
	ТекстСообщения ="";		
	МассивСтрок = Новый Массив;
	МассивСтрок.Добавить(СтруктураПараметров.bankacquirer); //PA
	
	МассивСтрок.Добавить(СтруктураПараметров.terminalid);  //PB
	МассивСтрок.Добавить("Повернення"); //PC
	МассивСтрок.Добавить(СтруктураПараметров.pan); //PD
	МассивСтрок.Добавить(СтруктураПараметров.approvalcode); //PE
	МассивСтрок.Добавить(СтруктураПараметров.paymentsystem); //PSNM
	МассивСтрок.Добавить(СтруктураПараметров.rrn); //RRN
	
	СтрокаИзМассива = СтрСоединить(МассивСтрок, ";");
	КонецЕсли;

		Если Ответ Тогда
				//добавлено для совместимости
	МассивСтрок1 = Новый Массив;
	МассивСтрок1.Добавить(СтрокаИзМассива);
	МассивСтрок1.Добавить(СтрокаИзМассива);
	ВыходныеПараметры.Очистить();
	ВыходныеПараметры.Добавить(МассивСтрок1);
	ВыходныеПараметры.Добавить(СтрокаИзМассива);
	ВыходныеПараметры.Добавить(СтруктураПараметров.invoicenumber);
	МассивМассивов = Новый Массив();
	МассивМассивов.Добавить("СлипЧек");
	МассивМассивов.Добавить("слип");
	ВыходныеПараметры.Добавить(МассивМассивов);
	ВыходныеПараметры.Добавить(СтруктураПараметров.approvalcode);
		Иначе
			ПараметрыПодключения.ТипТранзакции = НСтр("ru='Отказ';uk='Відмова'");
			Результат = Ложь;
			СтрокаXMLОтвет = "";
			СтрокаXMLОтвет = ОбъектДрайвера.StatusBarXML(); 
			СформироватьОшибку(ВыходныеПараметры, СтрокаXMLОтвет);
		КонецЕсли;
	Исключение
		Результат = Ложь;
		СформироватьОшибкуДрайвера(ВыходныеПараметры, "ОплатитьПлатежнойКартой","Помилка оплати карткою");
	КонецПопытки;
	
	Возврат Результат;

	
КонецФункции

// Функция осуществляет аварийную отмену операции по карте.
//
Функция АварийнаяОтменаОперации(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры)
	
	Ответ = Ложь;
	Результат = Истина;
			ПараметрыПодключения.ТипТранзакции = НСтр("ru='Отказ';uk='Відмова'");
			Результат = Ложь; 
			ОписаниеОшибки = "Операція не підтримуеться";
			ОбъектДрайвера.ПолучитьОшибку(ОписаниеОшибки);
			СформироватьОшибку(ВыходныеПараметры, ОписаниеОшибки);
	Возврат Результат;

	
КонецФункции

// Функция осуществляет преавторизацию по карте.
// 
Функция ПреавторизоватьПоПлатежнойКарте(ОбъектДрайвера, Параметры, ПараметрыПодключения,
	Сумма, НомерКарты, НомерЧека, ВыходныеПараметры)
	Результат      = Истина;
	КодRRN         = "";
	КодАвторизации = "";
	СлипЧек        = "";
	
			ПараметрыПодключения.ТипТранзакции = НСтр("ru='Отказ';uk='Відмова'");
			Результат = Ложь; 
			ОписаниеОшибки = "Операція не підтримуеться";
			ОбъектДрайвера.ПолучитьОшибку(ОписаниеОшибки);
			СформироватьОшибку(ВыходныеПараметры, ОписаниеОшибки);
	Возврат Результат;

	
КонецФункции

// Функция осуществляет отмену преавторизации по карте.
//
Функция ОтменитьПреавторизациюПоПлатежнойКарте(ОбъектДрайвера, Параметры, ПараметрыПодключения,
	Сумма, НомерКарты, СсылочныйНомер, НомерЧека, ВыходныеПараметры)
	Результат      = Истина;
	КодАвторизации = "";
	СлипЧек        = "";
	
			ПараметрыПодключения.ТипТранзакции = НСтр("ru='Отказ';uk='Відмова'");
			Результат = Ложь; 
			ОписаниеОшибки = "Операція не підтримуеться";
			ОбъектДрайвера.ПолучитьОшибку(ОписаниеОшибки);
			СформироватьОшибку(ВыходныеПараметры, ОписаниеОшибки);
	Возврат Результат;
	
КонецФункции

// Функция осуществляет завершение преавторизации по карте.
//
Функция ЗавершитьПреавторизациюПоПлатежнойКарте(ОбъектДрайвера, Параметры, ПараметрыПодключения,
	Сумма, НомерКарты, СсылочныйНомер, НомерЧека, ВыходныеПараметры)
	Результат      = Истина;
	КодАвторизации = "";
	СлипЧек        = "";
			ПараметрыПодключения.ТипТранзакции = НСтр("ru='Отказ';uk='Відмова'");
			Результат = Ложь; 
			ОписаниеОшибки = "Операція не підтримуеться";
			ОбъектДрайвера.ПолучитьОшибку(ОписаниеОшибки);
			СформироватьОшибку(ВыходныеПараметры, ОписаниеОшибки);
	Возврат Результат;
	
КонецФункции

#КонецОбласти


#Область ПроцедурыИФункцииОбщиеДляВсехТиповДрайверов

// Функция осуществляет тестирование устройства.
//
Функция ТестУстройства(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры)
	
	Результат            = Истина;
	РезультатТеста       = "";
	АктивированДемоРежим = "";
	
		Если  Параметры.ТипСоединения = 0 Тогда
		
		Dest = "COM"+Строка(Параметры.Порт);
		
	ИначеЕсли Параметры.ТипСоединения =1 Тогда

		Dest = СокрЛП(Параметры.IP);
	иначе
		Dest = "demo";
	АктивированДемоРежим = "Активовано"
	КонецЕсли;	
	
	
	Попытка
		ОбъектДрайвера = Новый COMОбъект("WebCheck.ClassCardserv");

	Ответ=ОбъектДрайвера.Cardserv("<?xml version=""1.0"" encoding=""UTF-8""?> <InputParameters> <Parameters  type="""+Параметры.Модель+"""  dest="""+Dest+"""  method= ""Identify"" merchantId = ""0""  /></InputParameters>");
	//  Ответ = истина;
	СтруктураПараметров = Новый Структура;
	Если  Ответ Тогда
		
		СтрокаXMLОтвет = ОбъектДрайвера.StatusBarXML();                                                                                                      
		
		Если СтрДлина(СтрокаXMLОтвет)>0 Тогда
			ЧтениеXML = Новый ЧтениеXML;
			ЧтениеXML.УстановитьСтроку(СтрокаXMLОтвет);
			ЧтениеXML.ПерейтиКСодержимому();
			
			Пока ЧтениеXML.Прочитать() Цикл
				Если ЧтениеXML.Имя = "Parameters" И ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда  
					Пока ЧтениеXML.ПрочитатьАтрибут() Цикл
						СтруктураПараметров.Вставить(ЧтениеXML.Имя,ЧтениеXML.Значение);	
					КонецЦикла;	
				КонецЕсли;
			КонецЦикла;	
		КонецЕсли;
	КонецЕсли;
	
		Если Ответ Тогда
			ВыходныеПараметры.Очистить();
			ВыходныеПараметры.Добавить(0);
			РезультатТеста = "Під'єднано банківський термінал: "+СтруктураПараметров.vendor +" "+СтруктураПараметров.model;
		Иначе
			Результат = Ложь;
			РезультатТеста = "Помилка під'єднання присторою по інтерфейсу  " +Dest;
		КонецЕсли;
	
	Исключение
		Результат = Ложь;

	КонецПопытки;
	
	Возврат Результат;
	
	
КонецФункции

// Функция осуществляет выполнение дополнительного действия для устройства.
//
Функция ВыполнитьДополнительноеДействие(ОбъектДрайвера, Параметры, ПараметрыПодключения, ИмяДействия, ВыходныеПараметры)
	
	Результат  = Истина;
	
	Для Каждого Параметр Из Параметры Цикл
		Если Лев(Параметр.Ключ, 2) = "P_" Тогда
			ЗначениеПараметра = Параметр.Значение;
			ИмяПараметра = Сред(Параметр.Ключ, 3);
			Ответ = ОбъектДрайвера.УстановитьПараметр(ИмяПараметра, ЗначениеПараметра) 
		КонецЕсли;
	КонецЦикла;
	
	Попытка
		Ответ = ОбъектДрайвера.ВыполнитьДополнительноеДействие(ИмяДействия);
		Если НЕ Ответ Тогда
			Результат = Ложь;
			ОписаниеОшибки = "";
			ОбъектДрайвера.ПолучитьОшибку(ОписаниеОшибки);
			СформироватьОшибку(ВыходныеПараметры, ОписаниеОшибки);
		Иначе
			ВыходныеПараметры.Очистить();  
		КонецЕсли;
	Исключение
		Результат = Ложь;
		СформироватьОшибкуДрайвера(ВыходныеПараметры, "ВыполнитьДополнительноеДействие", ОписаниеОшибки());
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

// Функция возвращает версию установленного драйвера.
//
Функция ПолучитьВерсиюДрайвера(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры)
	
	Результат = Истина;
	
	ВыходныеПараметры.Добавить(НСтр("ru='Установлен';uk='Встановлений'"));
	ВыходныеПараметры.Добавить(НСтр("ru='Не определена';uk='Не визначена'"));
	
	Попытка
		ВерсияДрайвера = ОбъектДрайвера.ПолучитьНомерВерсии();
	Исключение
		
		Попытка
			// Получаем описание драйвера.
			ОписаниеДрайвера = "";
			ОбъектДрайвера.ПолучитьОписание(ОписаниеДрайвера);
			ОписаниеДрайвераПараметры = МенеджерОборудованияВызовСервера.ПолучитьОписаниеДрайвера(ОписаниеДрайвера);
			ВерсияДрайвера = ОписаниеДрайвераПараметры.ВерсияДрайвера;
		Исключение
			Результат = Истина;
		КонецПопытки;
	КонецПопытки;
	
	ВыходныеПараметры[1] = ВерсияДрайвера;
	
	Возврат Результат;
	
КонецФункции

// Функция возвращает описание установленного драйвера.
//
Функция ПолучитьОписаниеДрайвера(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры)
	
	Результат = Истина;
	
	ВыходныеПараметры.Очистить();
	ВыходныеПараметры.Добавить(НСтр("ru='Установлен';uk='Встановлений'"));
	ВыходныеПараметры.Добавить(НСтр("ru='Не определена';uk='Не визначена'"));
	
	ВыходныеПараметры.Добавить(НСтр("ru='Не определено';uk='Не визначено'"));
	ВыходныеПараметры.Добавить(НСтр("ru='Не определено';uk='Не визначено'"));
	ВыходныеПараметры.Добавить(НСтр("ru='Не определено';uk='Не визначено'"));
	ВыходныеПараметры.Добавить(Неопределено);
	ВыходныеПараметры.Добавить(Неопределено);
	ВыходныеПараметры.Добавить(Неопределено);
	ВыходныеПараметры.Добавить(Неопределено);
	ВыходныеПараметры.Добавить(Неопределено);
	ВыходныеПараметры.Добавить(Неопределено);
	
	НаименованиеДрайвера      = "";
	ОписаниеДрайвера          = "";
	ТипОборудования           = "";
	ИнтеграционныйКомпонент   = Ложь;
	ОсновнойДрайверУстановлен = Ложь;
	РевизияИнтерфейса         = МенеджерОборудованияКлиентПовтИсп.РевизияИнтерфейсаДрайверов();
	URLЗагрузкиДрайвера       = "";
	ПараметрыДрайвера         = "";
	ДополнительныеДействия    = "";
	
	Если ПараметрыПодключения.Свойство("ТипОборудования") Тогда
		ТипОборудования = ПараметрыПодключения.ТипОборудования;
		// Предопределенный параметр с указанием типа драйвера.
		ОбъектДрайвера.УстановитьПараметр("EquipmentType", ТипОборудования) 
	КонецЕсли;
	
	Попытка
		// Получаем версию драйвера
		ВерсияДрайвера = ОбъектДрайвера.ПолучитьНомерВерсии();
		// Получаем описание драйвера
		ОбъектДрайвера.ПолучитьОписание(НаименованиеДрайвера, ОписаниеДрайвера, ТипОборудования, РевизияИнтерфейса, ИнтеграционныйКомпонент, 
		ОсновнойДрайверУстановлен, URLЗагрузкиДрайвера);
	Исключение
		Попытка
			ОписаниеДрайвера = "";
			ОбъектДрайвера.ПолучитьОписание(ОписаниеДрайвера);
			ОписаниеДрайвераПараметры = МенеджерОборудованияВызовСервера.ПолучитьОписаниеДрайвера(ОписаниеДрайвера);
			ВерсияДрайвера            = ОписаниеДрайвераПараметры.ВерсияДрайвера;
			НаименованиеДрайвера      = ОписаниеДрайвераПараметры.НаименованиеДрайвера;
			ОписаниеДрайвера          = ОписаниеДрайвераПараметры.ОписаниеДрайвера;
			ТипОборудования           = ОписаниеДрайвераПараметры.ТипОборудования;
			ИнтеграционныйКомпонент   = ОписаниеДрайвераПараметры.ИнтеграционныйКомпонент;
			ОсновнойДрайверУстановлен = ОписаниеДрайвераПараметры.ОсновнойДрайверУстановлен;
			URLЗагрузкиДрайвера       = ОписаниеДрайвераПараметры.URLЗагрузкиДрайвера;
			// Получаем ревизию интерфейса драйвера.
			РевизияИнтерфейса = ОбъектДрайвера.ПолучитьРевизиюИнтерфейса();
		Исключение
			ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru='Ошибка получения описания драйвера';uk='Помилка отримання опису драйвера'") + Символы.ПС + ОписаниеОшибки());
		КонецПопытки
	КонецПопытки;
	
	Если Результат Тогда
		ВыходныеПараметры[1] = ВерсияДрайвера;
		ВыходныеПараметры[2] = НаименованиеДрайвера;
		ВыходныеПараметры[3] = ОписаниеДрайвера;
		ВыходныеПараметры[4] = ТипОборудования;
		ВыходныеПараметры[5] = РевизияИнтерфейса;
		ВыходныеПараметры[6] = ИнтеграционныйКомпонент;
		ВыходныеПараметры[7] = ОсновнойДрайверУстановлен;
		ВыходныеПараметры[8] = URLЗагрузкиДрайвера;
		
		// Получаем описание драйвера
		ОбъектДрайвера.ПолучитьПараметры(ПараметрыДрайвера);
		ВыходныеПараметры[9] = ПараметрыДрайвера;
		// Получаем дополнительные действия.
		ОбъектДрайвера.ПолучитьДополнительныеДействия(ДополнительныеДействия);
		ВыходныеПараметры[10] = ДополнительныеДействия;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура СформироватьОшибкуДрайвера(ВыходныеПараметры, ИмяМетода = Неопределено, ОписаниеОшибки = Неопределено)
	
	Если НЕ ПустаяСтрока(ИмяМетода) Тогда
		СообщениеОбОшибке = НСтр("ru='Ошибка вызова метода драйвера <%1>.';uk='Помилка виклику методу драйвера <%1>.'");
		СообщениеОбОшибке = СтрШаблон(СообщениеОбОшибке, ИмяМетода); 
	Иначе
		СообщениеОбОшибке = НСтр("ru='Данный тип оборудование не поддерживает данную команду.';uk='Даний тип обладнання не підтримує дану команду.'");
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(ОписаниеОшибки) Тогда
		СообщениеОбОшибке = СообщениеОбОшибке + Символы.ПС + ОписаниеОшибки;
	КонецЕсли;
	СформироватьОшибку(ВыходныеПараметры, СообщениеОбОшибке);
	
КонецПроцедуры

Процедура СформироватьОшибку(ВыходныеПараметры, СообщениеОбОшибке)
	
	ВыходныеПараметры.Очистить();
	ВыходныеПараметры.Добавить(999);
	ВыходныеПараметры.Добавить(СообщениеОбОшибке);
	
КонецПроцедуры

#КонецОбласти

