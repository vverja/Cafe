#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ПередЗаписью(Отказ, Замещение)
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	Если НЕ ДополнительныеСвойства.Свойство("ДляПроведения") Тогда 
		Возврат;
	КонецЕсли;
	
	Если ПланыОбмена.ГлавныйУзел() <> Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ПартииРасходов.Период                       КАК Период,
	|	ПартииРасходов.Регистратор                  КАК Регистратор,
	|	ПартииРасходов.Подразделение                КАК Подразделение,
	|	ПартииРасходов.Организация                  КАК Организация,
	|	ПартииРасходов.СтатьяРасходов               КАК СтатьяРасходов,
	|	ПартииРасходов.АналитикаРасходов            КАК АналитикаРасходов,
	|	ПартииРасходов.ДокументПоступленияРасходов  КАК ДокументПоступленияРасходов,
	|	ПартииРасходов.АналитикаУчетаПартий         КАК АналитикаУчетаПартий,
	|	ПартииРасходов.АналитикаУчетаНоменклатуры   КАК АналитикаУчетаНоменклатуры,
	|	ПартииРасходов.СтоимостьРегл                КАК СтоимостьРегл,
	|	ПартииРасходов.НДСРегл                      КАК НДСРегл
	|
	|ПОМЕСТИТЬ ПартииПрочихРасходовПередЗаписью
	|ИЗ
	|	РегистрНакопления.ПартииПрочихРасходов КАК ПартииРасходов
	|ГДЕ
	|	ПартииРасходов.Регистратор = &Регистратор
	|	И ПартииРасходов.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|");
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	
	Запрос.Выполнить();

КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если НЕ ДополнительныеСвойства.Свойство("ДляПроведения") Тогда
		Возврат;
	КонецЕсли;
	
	Если ПланыОбмена.ГлавныйУзел() <> Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос("
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Таблица.Период                          КАК Период,
	|	Таблица.Регистратор                     КАК Регистратор,
	|	Таблица.Подразделение                   КАК Подразделение,
	|	Таблица.Организация                     КАК Организация,
	|	Таблица.СтатьяРасходов                  КАК СтатьяРасходов,
	|	Таблица.ВариантРаспределенияРасходов    КАК ВариантРаспределенияРасходов,
	|	Таблица.АналитикаРасходов               КАК АналитикаРасходов,
	|	Таблица.ДокументПоступленияРасходов     КАК ДокументПоступленияРасходов,
	|	Таблица.АналитикаУчетаПартий            КАК АналитикаУчетаПартий,
	|	Таблица.АналитикаУчетаНоменклатуры      КАК АналитикаУчетаНоменклатуры,
	|	СУММА(Таблица.СтоимостьРегл)            КАК СтоимостьРегл,
	|	СУММА(Таблица.НДСРегл)                  КАК НДСРегл
	|ПОМЕСТИТЬ втПартийПрочихРасходовРазница
	|ИЗ
	|	(ВЫБРАТЬ
	|		Таблица.Период                          КАК Период,
	|		Таблица.Регистратор                     КАК Регистратор,
	|		Таблица.Подразделение                   КАК Подразделение,
	|		Таблица.Организация                     КАК Организация,
	|		Таблица.СтатьяРасходов                  КАК СтатьяРасходов,
	|		СтатьиРасходов.ВариантРаспределенияРасходов КАК ВариантРаспределенияРасходов,
	|		Таблица.АналитикаРасходов               КАК АналитикаРасходов,
	|		Таблица.ДокументПоступленияРасходов     КАК ДокументПоступленияРасходов,
	|		Таблица.АналитикаУчетаПартий            КАК АналитикаУчетаПартий,
	|		Таблица.АналитикаУчетаНоменклатуры      КАК АналитикаУчетаНоменклатуры,
	|		Таблица.СтоимостьРегл                   КАК СтоимостьРегл,
	|		Таблица.НДСРегл                         КАК НДСРегл
	|	ИЗ
	|		ПартииПрочихРасходовПередЗаписью КАК Таблица
	|		ЛЕВОЕ СОЕДИНЕНИЕ
	|			ПланВидовХарактеристик.СтатьиРасходов КАК СтатьиРасходов
	|		ПО
	|			Таблица.СтатьяРасходов =  СтатьиРасходов.Ссылка
	|
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ПартииРасходов.Период                       КАК Период,
	|		ПартииРасходов.Регистратор                  КАК Регистратор,
	|		ПартииРасходов.Подразделение                КАК Подразделение,
	|		ПартииРасходов.Организация                  КАК Организация,
	|		ПартииРасходов.СтатьяРасходов               КАК СтатьяРасходов,
	|		СтатьиРасходов.ВариантРаспределенияРасходов КАК ВариантРаспределенияРасходов,
	|		ПартииРасходов.АналитикаРасходов            КАК АналитикаРасходов,
	|		ПартииРасходов.ДокументПоступленияРасходов  КАК ДокументПоступленияРасходов,
	|		ПартииРасходов.АналитикаУчетаПартий         КАК АналитикаУчетаПартий,
	|		ПартииРасходов.АналитикаУчетаНоменклатуры   КАК АналитикаУчетаНоменклатуры,
	|		-ПартииРасходов.СтоимостьРегл               КАК СтоимостьРегл,
	|		-ПартииРасходов.НДСРегл                     КАК НДСРегл
	|	ИЗ
	|		РегистрНакопления.ПартииПрочихРасходов КАК ПартииРасходов
	|		ЛЕВОЕ СОЕДИНЕНИЕ
	|			ПланВидовХарактеристик.СтатьиРасходов КАК СтатьиРасходов
	|		ПО
	|			ПартииРасходов.СтатьяРасходов =  СтатьиРасходов.Ссылка
	|	ГДЕ
	|		ПартииРасходов.Регистратор = &Регистратор
	|		И ПартииРасходов.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|
	|) КАК Таблица
	|
	|СГРУППИРОВАТЬ ПО
	|	Таблица.Период,
	|	Таблица.Регистратор,
	|	Таблица.Организация,
	|	Таблица.Подразделение,
	|	Таблица.СтатьяРасходов,
	|	Таблица.ВариантРаспределенияРасходов,
	|	Таблица.АналитикаРасходов,
	|	Таблица.ДокументПоступленияРасходов,
	|	Таблица.АналитикаУчетаПартий,
	|	Таблица.АналитикаУчетаНоменклатуры
	|;
	|
	|///////////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	НАЧАЛОПЕРИОДА(Таблица.Период, МЕСЯЦ) КАК МЕСЯЦ,
	|	Таблица.Организация                  КАК Организация,
	|	Таблица.Регистратор                  КАК Документ
	|ИЗ
	|	втПартийПрочихРасходовРазница КАК Таблица
	|	
	|ГДЕ
	|	Таблица.ВариантРаспределенияРасходов = ЗНАЧЕНИЕ(Перечисление.ВариантыРаспределенияРасходов.НаСебестоимостьТоваров)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ПартииПрочихРасходовПередЗаписью
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ втПартийПрочихРасходовРазница
	|");
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	РегистрыСведений.ЗаданияКРасчетуСебестоимости.СоздатьЗаписиРегистраПоДаннымВыборки(РезультатЗапроса[1].Выбрать());
	
	
КонецПроцедуры

#КонецЕсли
