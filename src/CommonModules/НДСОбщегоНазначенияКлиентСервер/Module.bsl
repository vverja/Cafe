////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ РАБОТЫ С СТАВКАМИ НДС

// Возвращает числовое значение ставки НДС по значению перечисления
//
// Параметры:
// 		СтавкаНДС - ПеречислениеСсылка.СтавкиНДС - значение перечисления СтавкиНДС
//
// Возвращаемое значение:
// 		Число - Значение ставки НДС числом
//
Функция ПолучитьСтавкуНДСЧислом(СтавкаНДС) Экспорт
	
	Если СтавкаНДС = ПредопределенноеЗначение("Перечисление.СтавкиНДС.НДС20") Тогда
		Возврат 0.20;
    ИначеЕсли СтавкаНДС = ПредопределенноеЗначение("Перечисление.СтавкиНДС.НДС14") Тогда
    	Возврат 0.14;
	ИначеЕсли СтавкаНДС = ПредопределенноеЗначение("Перечисление.СтавкиНДС.НДС7") Тогда
		Возврат 0.07;
	Иначе
		Возврат 0;
	КонецЕсли;
	
КонецФункции // ПолучитьСтавкуНДСЧислом()

// Возвращает строковое значение ставки НДС по значению перечисления
//
// Параметры:
// 		СтавкаНДС - ПеречислениеСсылка.СтавкиНДС - значение перечисления СтавкиНДС
//
// Возвращаемое значение:
// 		Строка - Значение ставки НДС строкой
//
Функция ПолучитьСтавкуНДССтрокой(СтавкаНДС) Экспорт
	
	Если СтавкаНДС = ПредопределенноеЗначение("Перечисление.СтавкиНДС.НДС20") Тогда
		ЗначениеНалога = "20";
    ИначеЕсли СтавкаНДС = ПредопределенноеЗначение("Перечисление.СтавкиНДС.НДС14") Тогда
    	ЗначениеНалога = "14";
	ИначеЕсли СтавкаНДС = ПредопределенноеЗначение("Перечисление.СтавкиНДС.НДС7") Тогда
		ЗначениеНалога = "7";
	ИначеЕсли СтавкаНДС = ПредопределенноеЗначение("Перечисление.СтавкиНДС.НДС0") Тогда
		ЗначениеНалога = "0";
	ИначеЕсли СтавкаНДС = ПредопределенноеЗначение("Перечисление.СтавкиНДС.БезНДС") Тогда
		ЗначениеНалога = "Без НДС";
	ИначеЕсли СтавкаНДС = ПредопределенноеЗначение("Перечисление.СтавкиНДС.НеНДС") Тогда
		ЗначениеНалога = "Не НДС";
	Иначе
		ЗначениеНалога = Строка(СтавкаНДС);
	КонецЕсли;
	
	Возврат ЗначениеНалога;
	
КонецФункции // ПолучитьСтавкуНДССтрокой()

// Возвращает строковое значение ставки НДС по значению перечисления
//
// Параметры:
// 		СтавкаНДС - ПеречислениеСсылка.СтавкиНДС - значение перечисления СтавкиНДС
//
// Возвращаемое значение:
// 		Строка - Значение ставки НДС строкой
//
Функция ПолучитьПоСтрокеСтавкуНДС(ЗначениеНалога) Экспорт
	
	Если ЗначениеНалога = "20" Тогда
		СтавкаНДС = ПредопределенноеЗначение("Перечисление.СтавкиНДС.НДС20");
    ИначеЕсли ЗначениеНалога = "14" Тогда
    	СтавкаНДС = ПредопределенноеЗначение("Перечисление.СтавкиНДС.НДС14");
	ИначеЕсли ЗначениеНалога = "7" Тогда
		СтавкаНДС = ПредопределенноеЗначение("Перечисление.СтавкиНДС.НДС7");
	ИначеЕсли ЗначениеНалога = "0" Тогда
		СтавкаНДС = ПредопределенноеЗначение("Перечисление.СтавкиНДС.НДС0");
	ИначеЕсли ЗначениеНалога = "Без НДС" Тогда
		СтавкаНДС = ПредопределенноеЗначение("Перечисление.СтавкиНДС.БезНДС");
	Иначе
		СтавкаНДС = ПредопределенноеЗначение("Перечисление.СтавкиНДС.НеНДС");
	КонецЕсли;
	
	Возврат СтавкаНДС;
		
КонецФункции // ПолучитьСтавкуНДССтрокой()


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ РАБОТЫ С ФОРМАМИ НАЛОГОВЫХ ДОКУМЕНТОВ

// Пересчитывает сумму из валюты ВалютаНач по курсу ПоКурсуНач 
// в валюту ВалютаКон по курсу ПоКурсуКон без округления до 2-х знаков после запятой
Функция ПересчитатьИзВалютыВВалюту(Сумма, ВалютаНач, ВалютаКон, ПоКурсуНач, ПоКурсуКон, 
	ПоКратностьНач = 1, ПоКратностьКон = 1) Экспорт
	
	Если ВалютаНач = ВалютаКон Тогда
		Возврат Сумма;
	КонецЕсли;
	
	Если ПоКурсуНач = 0
		ИЛИ ПоКратностьНач = 0
		ИЛИ ПоКурсуКон = 0
		ИЛИ ПоКратностьКон = 0 Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='При пересчете в валюту %1 сумма %2 установлена в нулевое значение, т.к. курс валюты не задан.';uk='При перерахуванні у валюту %1 сума %2 установлена в нульове значення, тому що курс валюти не заданий.'"), 
				ВалютаКон, 
				Формат(Сумма, "ЧДЦ=2; ЧН=0")
			)
		);
		
		Возврат 0;
		
	КонецЕсли;
	
	Возврат (Сумма * ПоКурсуНач * ПоКратностьКон) / (ПоКурсуКон * ПоКратностьНач);
	
КонецФункции


Функция КодЕдиницыИзмеренияДляПечатиНалоговых(Код) Экспорт

	Код = СтрЗаменить(Строка(Код), " ", "");
	
	Если НЕ СтрДлина(Код) = 4 Тогда
	
		Возврат "";	
		
	Иначе
		
		Для НомСимв = 1 По 4 Цикл
			КодСимвола = КодСимвола(Код, НомСимв);
			Если НЕ (КодСимвола >= 48 И КодСимвола <= 57) Тогда
				Возврат "";
			КонецЕсли; 
		КонецЦикла; 		
		
		Возврат Код;
		
	КонецЕсли;	

КонецФункции


