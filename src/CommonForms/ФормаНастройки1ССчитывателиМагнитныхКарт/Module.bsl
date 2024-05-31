
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	Параметры.Свойство("Идентификатор", Идентификатор);
	Параметры.Свойство("ДрайверОборудования", ДрайверОборудования);
	
	Заголовок = НСтр("ru='Оборудование:';uk='Устаткування:'") + Символы.НПП  + Строка(Идентификатор);
	
	ЦветТекста = ЦветаСтиля.ЦветТекстаФормы;
	ЦветОшибки = ЦветаСтиля.ЦветОтрицательногоЧисла;

	СписокПорт = Элементы.Порт.СписокВыбора;
	СписокПорт.Добавить(0, НСтр("ru='<Клавиатура>';uk='<Клавіатура>'"));
	Для Номер = 1 По 64 Цикл
		СписокПорт.Добавить(Номер, "COM" + Формат(Номер, "ЧЦ=2; ЧДЦ=0; ЧН=0; ЧГ=0"));
	КонецЦикла;

	СписокСкорость = Элементы.Скорость.СписокВыбора;
	СписокСкорость.Добавить(110,    "110");
	СписокСкорость.Добавить(300,    "300");
	СписокСкорость.Добавить(600,    "600");
	СписокСкорость.Добавить(1200,   "1200");
	СписокСкорость.Добавить(2400,   "2400");
	СписокСкорость.Добавить(4800,   "4800");
	СписокСкорость.Добавить(9600,   "9600");
	СписокСкорость.Добавить(14400,  "14400");
	СписокСкорость.Добавить(19200,  "19200");
	СписокСкорость.Добавить(38400,  "38400");
	СписокСкорость.Добавить(56000,  "56000");
	СписокСкорость.Добавить(57600,  "57600");
	СписокСкорость.Добавить(115200, "115200");
	СписокСкорость.Добавить(128000, "128000");
	СписокСкорость.Добавить(256000, "256000");

	СписокБитДанных = Элементы.БитДанных.СписокВыбора;
	Для Индекс = 1 По 8 Цикл
		СписокБитДанных.Добавить(Индекс, СокрЛП(Индекс));
	КонецЦикла;

	СписокСтопБит = Элементы.СтопБит.СписокВыбора;
	СписокСтопБит.Добавить(0, НСтр("ru='1 стоп-бит';uk='1 стоп-біт'"));
	СписокСтопБит.Добавить(1, НСтр("ru='1.5 стоп-бита';uk='1.5 стоп-біта'"));
	СписокСтопБит.Добавить(2, НСтр("ru='2 стоп-бита';uk='2 стоп-біта'"));
	
	СписокКодировка = Элементы.COMКодировка.СписокВыбора;
	СписокКодировка.Добавить("UTF-8");
	СписокКодировка.Добавить("Windows-1251");

	времПорт      = Неопределено;
	времСкорость  = Неопределено;
	времБитДанных = Неопределено;
	времСтопБит   = Неопределено;
	времТаймаут   = Неопределено;
	времТаймаутCOM   = Неопределено;
	времCOMКодировка = Неопределено;
	
	Параметры.ПараметрыОборудования.Свойство("Порт",      времПорт);
	Параметры.ПараметрыОборудования.Свойство("Скорость",  времСкорость);
	Параметры.ПараметрыОборудования.Свойство("БитДанных", времБитДанных);
	Параметры.ПараметрыОборудования.Свойство("СтопБит",   времСтопБит);
	Параметры.ПараметрыОборудования.Свойство("Таймаут",   времТаймаут);
	Параметры.ПараметрыОборудования.Свойство("ТаймаутCOM",   времТаймаутCOM);
	Параметры.ПараметрыОборудования.Свойство("COMКодировка", времCOMКодировка);
	
	Порт        = ?(времПорт      = Неопределено,         1, времПорт);
	Скорость    = ?(времСкорость  = Неопределено,      9600, времСкорость);
	БитДанных   = ?(времБитДанных = Неопределено,         8, времБитДанных);
	СтопБит     = ?(времСтопБит   = Неопределено,         0, времСтопБит);
	Таймаут     = ?(времТаймаут   = Неопределено,        75, времТаймаут);
	ТаймаутCOM   = ?(времТаймаутCOM   = Неопределено,       5, времТаймаутCOM);
	COMКодировка = ?(времCOMКодировка = Неопределено, "UTF-8", времCOMКодировка);
	
	времПараметрыДорожек = Неопределено;
	Если Не Параметры.ПараметрыОборудования.Свойство("ПараметрыДорожек", времПараметрыДорожек) Тогда
		времПараметрыДорожек = Новый Массив();
		Для Индекс = 1 По 3 Цикл
			НоваяСтрока = Новый Структура();
			НоваяСтрока.Вставить("НомерДорожки", Индекс);
			НоваяСтрока.Вставить("Префикс"     , 0);
			НоваяСтрока.Вставить("Суффикс"     , ?(Индекс = 2, 13, 0));
			НоваяСтрока.Вставить("Использовать", ?(Индекс = 2, Истина, Ложь));
			времПараметрыДорожек.Добавить(НоваяСтрока);
		КонецЦикла;
	КонецЕсли;

	Для Каждого СтрокаДорожки Из времПараметрыДорожек Цикл
		НоваяСтрока = ПараметрыДорожек.Добавить();
		НоваяСтрока.НомерДорожки = СтрокаДорожки.НомерДорожки;
		НоваяСтрока.Префикс      = СтрокаДорожки.Префикс;
		НоваяСтрока.Суффикс      = СтрокаДорожки.Суффикс;
		НоваяСтрока.Использовать = СтрокаДорожки.Использовать;
	КонецЦикла;
	
	Элементы.ТестУстройства.Видимость = (ПараметрыСеанса.РабочееМестоКлиента = Идентификатор.РабочееМесто);
	Элементы.УстановитьДрайвер.Видимость = (ПараметрыСеанса.РабочееМестоКлиента = Идентификатор.РабочееМесто);
	
	МенеджерОборудованияВызовСервераПереопределяемый.УстановитьОтображениеЗаголовковГрупп(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	ОбновитьИнформациюОДрайвере();

	НастроитьЭлементыУправления();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПортПриИзменении()
	
	НастроитьЭлементыУправления();
	
КонецПроцедуры

&НаКлиенте
Процедура ПараметрыДорожекПриАктивизацииЯчейки(Элемент)

	Если (Элемент.ТекущийЭлемент.Имя = "Префикс"
	 Или Элемент.ТекущийЭлемент.Имя = "Суффикс")
	   И Элемент.ТекущийЭлемент.СписокВыбора.Количество() = 0 Тогда
		СписокПараметрыДорожек = Элемент.ТекущийЭлемент.СписокВыбора;

		Для КодЭлемента = 0 По 127 Цикл
			СимволДорожки = "";
			Если КодЭлемента > 32 Тогда
				СимволДорожки = " ( " + Символ(КодЭлемента) + " )";
			ИначеЕсли КодЭлемента = 8 Тогда
				СимволДорожки = " (BACKSPACE)";
			ИначеЕсли КодЭлемента = 9 Тогда
				СимволДорожки = " (TAB)";
			ИначеЕсли КодЭлемента = 10 Тогда
				СимволДорожки = " (LF)";
			ИначеЕсли КодЭлемента = 13 Тогда
				СимволДорожки = " (CR)";
			ИначеЕсли КодЭлемента = 16 Тогда
				СимволДорожки = " (SHIFT)";
			ИначеЕсли КодЭлемента = 17 Тогда
				СимволДорожки = " (CONTROL)";
			ИначеЕсли КодЭлемента = 18 Тогда
				СимволДорожки = " (ALT)";
			ИначеЕсли КодЭлемента = 27 Тогда
				СимволДорожки = " (ESCAPE)";
			ИначеЕсли КодЭлемента = 32 Тогда
				СимволДорожки = " (SPACE)";
			КонецЕсли;
			СписокПараметрыДорожек.Добавить(КодЭлемента, Строка(КодЭлемента) + СимволДорожки);
		КонецЦикла;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ЗаписатьИЗакрытьВыполнить()

	НастроеноДорожек = 0;
	ДорожкаСПустымСуффиксом = Ложь;
	времПараметрыДорожек = Новый Массив();

	Для Индекс = 1 По 3 Цикл
		Если ПараметрыДорожек[3 - Индекс].Использовать = Истина Тогда
			ДорожкаСПустымСуффиксом =
			    ДорожкаСПустымСуффиксом ИЛИ (ПараметрыДорожек[3 - Индекс].Суффикс = 0);
			НастроеноДорожек = НастроеноДорожек + 1;
		КонецЕсли;
	КонецЦикла;

	Если Не ДорожкаСПустымСуффиксом Тогда
		Для Индекс = 1 По 3 Цикл
			НоваяСтрока = Новый Структура();
			НоваяСтрока.Вставить("НомерДорожки", ПараметрыДорожек[Индекс - 1].НомерДорожки);
			НоваяСтрока.Вставить("Использовать", ПараметрыДорожек[Индекс - 1].Использовать);
			НоваяСтрока.Вставить("Префикс"     , ПараметрыДорожек[Индекс - 1].Префикс);
			НоваяСтрока.Вставить("Суффикс"     , ПараметрыДорожек[Индекс - 1].Суффикс);
			времПараметрыДорожек.Добавить(НоваяСтрока);
		КонецЦикла;
	КонецЕсли;

	Если НастроеноДорожек > 0 И Не ДорожкаСПустымСуффиксом Тогда
		
		ОчиститьСообщения();
		
		НовыеЗначениеПараметров = Новый Структура;
		НовыеЗначениеПараметров.Вставить("Порт"      , Порт);
		НовыеЗначениеПараметров.Вставить("Скорость"  , Скорость);
		НовыеЗначениеПараметров.Вставить("БитДанных" , БитДанных);
		НовыеЗначениеПараметров.Вставить("СтопБит"   , СтопБит);
		НовыеЗначениеПараметров.Вставить("Таймаут"   , Таймаут);
		НовыеЗначениеПараметров.Вставить("ПараметрыДорожек", времПараметрыДорожек);
		НовыеЗначениеПараметров.Вставить("ТаймаутCOM"   , ТаймаутCOM);
		НовыеЗначениеПараметров.Вставить("COMКодировка" , COMКодировка);
		
		Результат = Новый Структура;
		Результат.Вставить("Идентификатор", Идентификатор);
		Результат.Вставить("ПараметрыОборудования", НовыеЗначениеПараметров);
		
		Закрыть(Результат);
		
	ИначеЕсли НастроеноДорожек = 0 Тогда
		ТекстСообщения = НСтр("ru='Необходимо указать использование хотя бы одной дорожки для считывателя';uk='Необхідно вказати використання хоча б однієї доріжки для зчитувача'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	ИначеЕсли ДорожкаСПустымСуффиксом Тогда
		ТекстСообщения = НСтр("ru='Для каждой используемой дорожки должен быть указан суффикс, отличный от 0';uk='Для кожної використовуваної доріжки повинен бути вказаний суфікс, відмінний від 0'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ТестУстройства(Команда)

	ОчиститьСообщения();
	
	ВходныеПараметры  = Неопределено;
	ВыходныеПараметры = Неопределено;

	времПараметрыУстройства = Новый Структура();
	времПараметрыУстройства.Вставить("Порт"     , Порт);
	времПараметрыУстройства.Вставить("Скорость" , Скорость);
	времПараметрыУстройства.Вставить("БитДанных", БитДанных);
	времПараметрыУстройства.Вставить("СтопБит"  , СтопБит);
	времПараметрыУстройства.Вставить("Таймаут"  , Таймаут);
	времПараметрыУстройства.Вставить("ТаймаутCOM"   , ТаймаутCOM);
	времПараметрыУстройства.Вставить("COMКодировка" , COMКодировка);
	времПараметрыУстройства.Вставить("ПараметрыДорожек", Новый Массив());
	
	МенеджерОборудованияКлиент.ВыполнитьДополнительнуюКоманду("CheckHealth",
	                                                          ВходныеПараметры,
	                                                          ВыходныеПараметры,
	                                                          Идентификатор,
	                                                          времПараметрыУстройства);

КонецПроцедуры

&НаКлиенте
Процедура УстановитьДрайверИзАрхиваПриЗавершении(Результат) Экспорт 
	
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Установка драйвера завершена.';uk='Встановлення драйвера завершена.'")); 
	ОбновитьИнформациюОДрайвере();
	
КонецПроцедуры 

&НаКлиенте
Процедура УстановитьДрайверИзДистрибутиваПриЗавершении(Результат, Параметры) Экспорт 
	
	Если Результат Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Установка драйвера завершена.';uk='Встановлення драйвера завершена.'")); 
		ОбновитьИнформациюОДрайвере();
	Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='При установке драйвера из дистрибутива произошла ошибка.';uk='При встановленні драйвера з дистрибутива сталася помилка.'")); 
	КонецЕсли;

КонецПроцедуры 

&НаКлиенте
Процедура УстановитьДрайвер(Команда)

	ОчиститьСообщения();
	ОповещенияДрайверИзДистрибутиваПриЗавершении = Новый ОписаниеОповещения("УстановитьДрайверИзДистрибутиваПриЗавершении", ЭтотОбъект);
	ОповещенияДрайверИзАрхиваПриЗавершении = Новый ОписаниеОповещения("УстановитьДрайверИзАрхиваПриЗавершении", ЭтотОбъект);
	МенеджерОборудованияКлиент.УстановитьДрайвер(ДрайверОборудования, ОповещенияДрайверИзДистрибутиваПриЗавершении, ОповещенияДрайверИзАрхиваПриЗавершении);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура НастроитьЭлементыУправления()
	
	ДоступностьПорт = Порт > 0;  
	Элементы.Скорость.Доступность  = ДоступностьПорт;
	Элементы.БитДанных.Доступность = ДоступностьПорт;
	Элементы.СтопБит.Доступность   = ДоступностьПорт;
	Элементы.Таймаут.Доступность   = НЕ ДоступностьПорт;
	Элементы.ТаймаутCOM.Доступность   = ДоступностьПорт;
	Элементы.COMКодировка.Доступность = ДоступностьПорт;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнформациюОДрайвере()

	ВходныеПараметры  = Неопределено;
	ВыходныеПараметры = Неопределено;

	времПараметрыУстройства = Новый Структура();
	времПараметрыУстройства.Вставить("Порт"     , Порт);
	времПараметрыУстройства.Вставить("Скорость" , Скорость);
	времПараметрыУстройства.Вставить("БитДанных", БитДанных);
	времПараметрыУстройства.Вставить("СтопБит"  , СтопБит);
	времПараметрыУстройства.Вставить("ПараметрыДорожек", Новый Массив());
	
	Если МенеджерОборудованияКлиент.ВыполнитьДополнительнуюКоманду("ПолучитьВерсиюДрайвера",
	                                                               ВходныеПараметры,
	                                                               ВыходныеПараметры,
	                                                               Идентификатор,
	                                                               времПараметрыУстройства) Тогда
		Драйвер        = ВыходныеПараметры[0];
		Версия         = ВыходныеПараметры[1];
		ВерсияИзБПО    = ВыходныеПараметры[2];
		ВерсияСтр      = ВыходныеПараметры[3];
		ВерсияИзБПОСтр = ВыходныеПараметры[4];
		
		// Проверка на соответствие номера версии драйвера в БПО и номера, который сообщает сам драйвер.
		Если ВерсияИзБПОСтр > ВерсияСтр Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Установленная на компьютере версия драйвера устарела! Необходимо обновление до версии:';uk='Встановлена на комп''ютері версія драйвера застаріла! Необхіднеоновлення до версії:'") + Символы.НПП + ВерсияИзБПО);
		КонецЕсли;
	Иначе
		Драйвер        = ВыходныеПараметры[2];
		Версия         = НСтр("ru='Не определена';uk='Не визначена'");
		ВерсияСтр      = 8000000;
		ВерсияИзБПОСтр = 8000000;
	КонецЕсли;

	Элементы.Драйвер.ЦветТекста = ?(Драйвер = НСтр("ru='Не установлен';uk='Не встановлений'"), ЦветОшибки, ЦветТекста);
	Элементы.Версия.ЦветТекста  = ?(Версия  = НСтр("ru='Не определена';uk='Не визначена'"), ЦветОшибки, ЦветТекста);
	
	Элементы.УстановитьДрайвер.Доступность = Не (Драйвер = НСтр("ru='Установлен';uk='Встановлений'"));
	
КонецПроцедуры

#КонецОбласти