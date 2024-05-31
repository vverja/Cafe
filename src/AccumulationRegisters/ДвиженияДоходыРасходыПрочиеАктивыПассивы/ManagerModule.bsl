#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда


#Область ОбновлениеИнформационнойБазы

Функция ПолноеИмяОбъекта()
	Возврат "РегистрНакопления.ДвиженияДоходыРасходыПрочиеАктивыПассивы";
КонецФункции


Процедура ЗарегистироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Строки.Регистратор КАК Ссылка
	|ИЗ
	|	РегистрНакопления.ДвиженияДоходыРасходыПрочиеАктивыПассивы КАК Строки
	|ГДЕ
	|	Строки.Статья = ЗНАЧЕНИЕ(ПланВидовХарактеристик.СтатьиАктивовПассивов.НалогиИВзносыСОплатыТруда)
	|	ИЛИ Строки.КорСтатья = ЗНАЧЕНИЕ(ПланВидовХарактеристик.СтатьиАктивовПассивов.НалогиИВзносыСОплатыТруда)");
	
	СписокРегистраторов = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
    
    ДополнительныеПараметрыОтметки = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	ДополнительныеПараметрыОтметки.ЭтоДвижения = Истина;
	ДополнительныеПараметрыОтметки.ПолноеИмяРегистра = ПолноеИмяОбъекта();
    
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, СписокРегистраторов, ДополнительныеПараметрыОтметки);
	
КонецПроцедуры

// Обработчик обновления BAS УТ 3.2.3
// Перекладывает суммы с неиспользуемой статьи пассивов "НалогиИВзносыСОплатыТруда" на новую - "Налоги".
// Помимо статьи перезаполняется аналитика.
Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Результат = ОбновлениеИнформационнойБазы.СоздатьВременнуюТаблицуРегистраторовРегистраДляОбработки(
		Параметры.Очередь,
		Неопределено,
		ПолноеИмяОбъекта(),
		МенеджерВременныхТаблиц);
	
	Если Не Результат.ЕстьЗаписиВоВременнойТаблице Тогда
		Параметры.ОбработкаЗавершена = Не Результат.ЕстьДанныеДляОбработки;
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Регистр.Период КАК Период,
	|	Регистр.Регистратор КАК Ссылка
	|ИЗ
	|	РегистрНакопления.ДвиженияДоходыРасходыПрочиеАктивыПассивы КАК Регистр
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТДляОбработкиДвиженияДоходыРасходыПрочиеАктивыПассивы КАК ДляОбработки
	|		ПО Регистр.Регистратор = ДляОбработки.Регистратор
	|
	|УПОРЯДОЧИТЬ ПО
	|	Период УБЫВ,
	|	Ссылка");
	
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	ВыборкаДокументы = Запрос.Выполнить().Выбрать();
	
	Пока ВыборкаДокументы.Следующий() Цикл
		
		НачатьТранзакцию();
		
		Попытка
			
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить("РегистрНакопления.ДвиженияДоходыРасходыПрочиеАктивыПассивы.НаборЗаписей");
			ЭлементБлокировки.УстановитьЗначение("Регистратор", ВыборкаДокументы.Ссылка);
			Блокировка.Заблокировать();
			
			НаборЗаписей = РегистрыНакопления.ДвиженияДоходыРасходыПрочиеАктивыПассивы.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.Регистратор.Установить(ВыборкаДокументы.Ссылка);
			НаборЗаписей.Прочитать();
			
			Для Каждого Строка Из НаборЗаписей Цикл
				
				Если Строка.Статья = ПланыВидовХарактеристик.СтатьиАктивовПассивов.НалогиИВзносыСОплатыТруда Тогда
					
					Строка.Статья = ПланыВидовХарактеристик.СтатьиАктивовПассивов.Налоги;
					
					
				КонецЕсли;
				
				Если Строка.КорСтатья = ПланыВидовХарактеристик.СтатьиАктивовПассивов.НалогиИВзносыСОплатыТруда Тогда
					
					Строка.КорСтатья = ПланыВидовХарактеристик.СтатьиАктивовПассивов.Налоги;
					
					
				КонецЕсли;
				
			КонецЦикла;
			
			ОбновлениеИнформационнойБазы.ЗаписатьДанные(НаборЗаписей);
			
			ЗафиксироватьТранзакцию();
		Исключение
			
			ОтменитьТранзакцию();
			
			ТекстСообщения = НСтр("ru='Не удалось обработать движения документа %Документ% по регистру ""Движения Доходы/Расходы - Прочие активы/пассивы"". Причина: %Причина%';uk='Не вдалося обробити рухи документа %Документ% регістру ""Рухи Доходи/Витрати - Інші активи/пасиви"". Причина: %Причина%'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Документ%", ВыборкаДокументы.Ссылка);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Причина%", ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Предупреждение,
				ВыборкаДокументы.Ссылка.Метаданные(), ВыборкаДокументы.Ссылка, ТекстСообщения);
			
			ВызватьИсключение;
			
		КонецПопытки;
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = Не ОбновлениеИнформационнойБазы.ЕстьДанныеДляОбработки(Параметры.Очередь, ПолноеИмяОбъекта());
	
КонецПроцедуры


#КонецОбласти

#КонецЕсли