////////////////////////////////////////////////////////////////////////////////
// Подсистема "Работа с контрагентами".
// Процедуры и функции проверки корректности заполнения регламентированных данных.
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Проверяет соответствие ИНН требованиям.
//
// Параметры:
//  ИНН          	- Строка - Проверяемый индивидуальный номер плательщика НДС.
//  ЭтоЮрЛицо   	- Булево - признак, является ли владелец ИНН юридическим лицом.
//  ТекстСообщения 	- Строка - Текст сообщения о найденных ошибках.
//
// Возвращаемое значение:
//  Истина       - ИНН соответствует требованиям;
//  Ложь         - ИНН не соответствует требованиям.
//
Функция ИННПлательщикаНДССоответствуетТребованиям(Знач ИННПлательщикаНДС, ЭтоЮрЛицо, ТекстСообщения) Экспорт

	СоответствуетТребованиям = Истина;
	ТекстСообщения = "";

	ИННПлательщикаНДС = СокрЛП(ИННПлательщикаНДС);
	ДлинаИНН          = СтрДлина(ИННПлательщикаНДС);

	Если ЭтоЮрЛицо = Неопределено Тогда
	   	ТекстСообщения = ТекстСообщения + НСтр("ru='Не определен тип владельца ИНН.';uk='Не визначений тип власника ІПН.'");
		Возврат Ложь;
	КонецЕсли;
	
	Если НЕ СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(ИННПлательщикаНДС) Тогда
		СоответствуетТребованиям = Ложь;
		ТекстСообщения = ТекстСообщения + НСтр("ru='ИНН должен состоять только из цифр.';uk='ІПН повинен складатися тільки з цифр.'");
	КонецЕсли;


	Возврат СоответствуетТребованиям;

КонецФункции 

// Проверяет соответствие номера свидетельства плательщика НДС требованиям.
//
// Параметры:
//  НомерСвидетельстваПлательщикаНДС - Строка - Проверяемый номер свидетельства плательщика НДС.
//  ЭтоЮрЛицо   	- Булево - признак, является ли владелец номера свидетельства плательщика НДС юридическим лицом.
//  ТекстСообщения 	- Строка - Текст сообщения о найденных ошибках.
//
// Возвращаемое значение:
//  Истина       - номера свидетельства плательщика НДС соответствует требованиям;
//  Ложь         - номера свидетельства плательщика НДС не соответствует требованиям.
//
Функция НомерСвидетельстваПлательщикаНДССоответствуетТребованиям(Знач НомерСвидетельстваПлательщикаНДС, ЭтоЮрЛицо, ТекстСообщения) Экспорт

	СоответствуетТребованиям = Истина;
	ТекстСообщения = "";

	НомерСвидетельстваПлательщикаНДС      = СокрЛП(НомерСвидетельстваПлательщикаНДС);
	ДлинаНомерСвидетельстваПлательщикаНДС = СтрДлина(НомерСвидетельстваПлательщикаНДС);

	Если ЭтоЮрЛицо = Неопределено Тогда
	   	ТекстСообщения = ТекстСообщения + НСтр("ru='Не определен тип владельца номера свидетельства плательщика НДС.';uk='Не визначений тип власника номеру свідоцтва платника ПДВ.'");
		Возврат Ложь;
	КонецЕсли;
	
	Если НЕ СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(НомерСвидетельстваПлательщикаНДС) Тогда
		СоответствуетТребованиям = Ложь;
		ТекстСообщения = ТекстСообщения + НСтр("ru='Номер свидетельства плательщика НДС должен состоять только из цифр.';uk='Номер свідоцтва платника ПДВ повинен складатися тільки з цифр.'");
	КонецЕсли;


	Возврат СоответствуетТребованиям;

КонецФункции  // НомерСвидетельстваПлательщикаНДССоответствуетТребованиям


// Проверяет соответствие кода ЕДРПОУ/ДРФО требованиям стандартов.
//
// Параметры:
//  ПроверяемыйКод         - Строка - проверяемый код ЕДРПОУ/ДРФО;
//  ЭтоЮрЛицо              - Булево - признак, является ли владелец кода ЕДРПОУ/ДРФО юридическим лицом;
//  ТекстСообщения         - Строка - текст сообщения о найденных ошибках в проверяемом коде ЕДРПОУ/ДРФО;
//
// Возвращаемое значение:
//  Булево.
//
Функция КодПоЕДРПОУСоответствуетТребованиям(Знач ПроверяемыйКод, ЭтоЮрЛицо, ТекстСообщения = "") Экспорт
	
	ПроверяемыйКод = СокрЛП(ПроверяемыйКод);
	ТекстСообщения = "";
	ДлинаКода = СтрДлина(ПроверяемыйКод);

	Если ЭтоЮрЛицо = Неопределено Тогда
		ТекстСообщения = ТекстСообщения + НСтр("ru='Не определен тип владельца кода ЕДРПОУ/ДРФО.';uk='Не визначений тип власника коду ЄДРПОУ/ДРФО.'");
		Возврат Ложь;
	КонецЕсли;
    
    Если ЭтоЮрЛицо Тогда
    	Если Не СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(ПроверяемыйКод) Тогда
    		ТекстСообщения = ТекстСообщения + НСтр("ru='Код ЕДРПОУ юридического лица должен состоять только из цифр.';uk='Код ЄДРПОУ юридичної особи повинен складатися тільки з цифр.'") + Символы.ПС;
        КонецЕсли;
	    Если ДлинаКода <> 8 Тогда
		    ТекстСообщения = ТекстСообщения + НСтр("ru='Код ЕДРПОУ юридического лица должен состоять из 8 цифр.';uk='Код ЄДРПОУ юридичної особи повинен складатися з 8 цифр.'") + Символы.ПС;
        КонецЕсли;    
    ИначеЕсли Не ЭтоЮрЛицо Тогда
        Успешно = (ДлинаКода = 8) ИЛИ (ДлинаКода = 9) ИЛИ (ДлинаКода = 10);
        Если ДлинаКода = 10 Тогда // код ДРФО
        	Если Не СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(ПроверяемыйКод) Тогда
        		Успешно = Ложь;
        	КонецЕсли;
        ИначеЕсли ДлинаКода = 9 Тогда // номер паспорта нового образца (id-карты)
        	Если Не СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(ПроверяемыйКод) Тогда
        		Успешно = Ложь;
            КонецЕсли;
        ИначеЕсли ДлинаКода = 8 Тогда // серия-номер паспорта старого образца
            СерияПаспорта = Сред(ПроверяемыйКод, 1, 2);
            НомерПаспорта = Сред(ПроверяемыйКод, 3, 6);
        	Если Не (СтроковыеФункцииКлиентСервер.ТолькоКириллицаВСтроке(СерияПаспорта) И СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(НомерПаспорта)) Тогда
        		Успешно = Ложь;
            КонецЕсли;
        КонецЕсли; 
        Если Не Успешно Тогда
            ТекстСообщения = ТекстСообщения + НСтр("ru='Код ДРФО физического лица должен состоять из 10 цифр,';uk='Код ДРФО фізичної особи повинен складатися з 10 цифр,'") 
                             + Символы.ПС
                             + НСтр("ru='или должны быть указаны данные паспорта:';uk='або повинні бути вказані дані паспорта:'") 
                             + Символы.ПС
                             + НСтр("ru='для паспортов старого образца серия и номер - 2 буквы и 6 цифр, без пробела между серией и номером';uk='для паспортів старого зразка серія і номер - 2 літери і 6 цифр, без пробілу між серією та номером'") 
                             + Символы.ПС
                             + НСтр("ru='для паспортов нового образца номер - 9 цифр.';uk='для паспортів нового зразка номер - 9 цифр.'") 
                             + Символы.ПС
                             ;
        
        КонецЕсли; 
    КонецЕсли;
	
	Если Не ПустаяСтрока(ТекстСообщения) Тогда
		ТекстСообщения = СокрЛП(ТекстСообщения);
		Возврат Ложь;
	КонецЕсли;
	
	
	Возврат Истина;
	
КонецФункции // КодПоЕДРПОУСоответствуетТребованиям


// Проверка корректности банковского счета
//
// Параметры:
//  Номер        - Строка - Номер банковского счета.
//  ВалютныйСчет - Булево - Признак, является ли счет валютным.
//  ТекстОшибки  - Строка - Текст сообщения о найденных ошибках.
//
// Возвращаемое значение:
//  Булево
//  Истина - контрольный ключ верен
//  Ложь - контрольный ключ не верен
//
Функция ПроверитьКорректностьНомераСчета(Знач Номер, ВалютныйСчет = Ложь, ТекстОшибки = "") Экспорт
	
	Результат = Истина;
	Номер = СокрЛП(Номер);
	Если ПустаяСтрока(Номер) Тогда
		Возврат Результат;
	КонецЕсли;
	
	Если НомерБанковскогоСчетаСоответствуетСтандартуIBAN(Номер) Тогда
		Возврат Результат;
	КонецЕсли;
	
	ТекстОшибки = "";
	Если НЕ СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(Номер) Тогда	
		ТекстОшибки = ТекстОшибки + ?(ПустаяСтрока(ТекстОшибки), "", " ") +
			НСтр("ru='Номер банковского счета должен соответствовать стандарту IBAN (длина 29 знаков) либо состоять только из цифр (обычно 14 знаков)';uk='Номер банківського рахунку повинен відповідати стандарту IBAN (довжина 29 знаків) або складатися тільки з цифр (зазвичай 14 знаків)'");
		Результат   = Ложь;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция НомерБанковскогоСчетаСоответствуетСтандартуIBAN(НомерСчета) Экспорт
	
	Результат = Ложь;
	
	ДлинаНомера = СтрДлина(НомерСчета);
	КодСтраны = Лев(НомерСчета, 2);
	
	Если КодСтраны = "UA" И ДлинаНомера = 29 Тогда
		Результат = Истина;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ПолучитьКодБанкаПоНомеруСчетаIBAN(НомерСчета) Экспорт
	
	КодБанка = "";
	
	Если НомерБанковскогоСчетаСоответствуетСтандартуIBAN(НомерСчета) Тогда
		КодБанка = Сред(НомерСчета, 5, 6);
	КонецЕсли;
	
	Возврат КодБанка;
	
КонецФункции

#КонецОбласти
