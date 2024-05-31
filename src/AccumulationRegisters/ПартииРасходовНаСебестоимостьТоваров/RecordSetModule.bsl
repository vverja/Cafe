#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура СкинутьГраницыПартииТоваровОрганизацийПоследовательность()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если НЕ ДополнительныеСвойства.Свойство("ДляПроведения") ИЛИ ПланыОбмена.ГлавныйУзел() <> Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	МИНИМУМ(Задания.Месяц) КАК Месяц
	|ПОМЕСТИТЬ НачалоРасчета
	|ИЗ
	|	РегистрСведений.ЗаданияКРасчетуСебестоимости КАК Задания
	|;
	|//////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	НАЧАЛОПЕРИОДА(Партии.Период, МЕСЯЦ) КАК Месяц,
	|	Партии.Организация КАК Организация,
	|	&Регистратор КАК Документ
	|ИЗ
	|	РегистрНакопления.ПартииРасходовНаСебестоимостьТоваров КАК Партии
	|	ЛЕВОЕ СОЕДИНЕНИЕ НачалоРасчета КАК НачалоРасчета
	|		ПО ИСТИНА
	|ГДЕ
	|	Партии.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|	И Партии.Регистратор = &Регистратор
	|	И ТИПЗНАЧЕНИЯ(Партии.Регистратор) = ТИП(Документ.ТаможеннаяДекларацияИмпорт)
	|	И ЕСТЬNULL(НачалоРасчета.Месяц, Партии.Период) >= Партии.Период
	|	И &ИспользоватьПартионныйУчет
	|");
	
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Запрос.УстановитьПараметр("ИспользоватьПартионныйУчет", Константы.ИспользоватьПартионныйУчет.Получить());
	
	РегистрыСведений.ЗаданияКРасчетуСебестоимости.СоздатьЗаписиРегистраПоДаннымВыборки(Запрос.Выполнить().Выбрать());
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	СкинутьГраницыПартииТоваровОрганизацийПоследовательность();
КонецПроцедуры

Процедура ПередЗаписью(Отказ, Замещение)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	СкинутьГраницыПартииТоваровОрганизацийПоследовательность();
КонецПроцедуры

#КонецЕсли
