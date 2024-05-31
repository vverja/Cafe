#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	// Вместо ОбменДанными.Загрузка используется ДополнительныеСвойства.Свойство("ДляПроведения").
	// Данное свойство устанавливается в модуле ПроведениеСервер при интерактивном проведении документа.
	Если НЕ ДополнительныеСвойства.Свойство("ДляПроведения") ИЛИ ПланыОбмена.ГлавныйУзел() <> Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	БлокироватьДляИзменения = Истина;
	ДополнительныеСвойства.ДляПроведения.Вставить("ВалютаУпр", Константы.ВалютаУправленческогоУчета.Получить());
	ДополнительныеСвойства.ДляПроведения.Вставить("ВалютаРегл", Константы.ВалютаРегламентированногоУчета.Получить());
	
	// Текущее состояние набора помещается во временную таблицу,
	// чтобы при записи получить изменение нового набора относительно текущего.
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	Записи.Период                     КАК Период,
	|	Записи.Регистратор                КАК Регистратор,
	|	Записи.Организация                КАК Организация,
	|	Записи.ПодотчетноеЛицо            КАК ПодотчетноеЛицо,
	|	Записи.ЦельВыдачи                 КАК ЦельВыдачи,
	|	Записи.Валюта                     КАК Валюта,
	|
	|	Записи.Сумма       КАК Сумма,
	|	Записи.СуммаУпр    КАК СуммаУпр,
	|	Записи.СуммаРегл   КАК СуммаРегл,
	|	Записи.КОтчету     КАК КОтчету,
	|
	|	Записи.ХозяйственнаяОперация         КАК ХозяйственнаяОперация,
	|	Записи.СтатьяДвиженияДенежныхСредств КАК СтатьяДвиженияДенежныхСредств,
	|	Записи.Заказ                         КАК Заказ
	|ПОМЕСТИТЬ ДенежныеСредстваУПодотчетныхЛицПередЗаписью
	|ИЗ
	|	РегистрНакопления.ДенежныеСредстваУПодотчетныхЛиц КАК Записи
	|ГДЕ
	|	Записи.Регистратор = &Регистратор
	|	И (ТипЗначения(Записи.Регистратор) = ТИП(Документ.ПереоценкаВалютныхСредств)
	|		ИЛИ Записи.Валюта <> &ВалютаУпр
	|		ИЛИ Записи.Валюта <> &ВалютаРегл
	|	)
	|");
	
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Запрос.УстановитьПараметр("ВалютаУпр", ДополнительныеСвойства.ДляПроведения.ВалютаУпр);
	Запрос.УстановитьПараметр("ВалютаРегл", ДополнительныеСвойства.ДляПроведения.ВалютаРегл);
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Выполнить();
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	// Вместо ОбменДанными.Загрузка используется ДополнительныеСвойства.Свойство("ДляПроведения").
	// Данное свойство устанавливается в модуле ПроведениеСервер при интерактивном проведении документа.
	Если НЕ ДополнительныеСвойства.Свойство("ДляПроведения") ИЛИ ПланыОбмена.ГлавныйУзел() <> Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	// Рассчитывается изменение нового набора относительно текущего с учетом накопленных изменений
	// и помещается во временную таблицу.
	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	НАЧАЛОПЕРИОДА(Таблица.Период, МЕСЯЦ) КАК МЕСЯЦ,
	|	Таблица.Организация                  КАК Организация,
	|	&Операция                            КАК Операция,
	|	Таблица.Регистратор                  КАК Документ
	|ИЗ
	|	(ВЫБРАТЬ
	|		Записи.Период                     КАК Период,
	|		Записи.Регистратор                КАК Регистратор,
	|		Записи.Организация                КАК Организация,
	|		Записи.ПодотчетноеЛицо            КАК ПодотчетноеЛицо,
	|		Записи.ЦельВыдачи                 КАК ЦельВыдачи,
	|		Записи.Валюта                     КАК Валюта,
	|
	|		Записи.Сумма       КАК Сумма,
	|		Записи.СуммаУпр    КАК СуммаУпр,
	|		Записи.СуммаРегл   КАК СуммаРегл,
	|		Записи.КОтчету     КАК КОтчету,
	|
	|		Записи.ХозяйственнаяОперация         КАК ХозяйственнаяОперация,
	|		Записи.СтатьяДвиженияДенежныхСредств КАК СтатьяДвиженияДенежныхСредств,
	|		Записи.Заказ                         КАК Заказ
	|	ИЗ
	|		ДенежныеСредстваУПодотчетныхЛицПередЗаписью КАК Записи
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|
	|	ВЫБРАТЬ
	|		Записи.Период                     КАК Период,
	|		Записи.Регистратор                КАК Регистратор,
	|		Записи.Организация                КАК Организация,
	|		Записи.ПодотчетноеЛицо            КАК ПодотчетноеЛицо,
	|		Записи.ЦельВыдачи                 КАК ЦельВыдачи,
	|		Записи.Валюта                     КАК Валюта,
	|
	|		-Записи.Сумма       КАК Сумма,
	|		-Записи.СуммаУпр    КАК СуммаУпр,
	|		-Записи.СуммаРегл   КАК СуммаРегл,
	|		-Записи.КОтчету     КАК КОтчету,
	|
	|		Записи.ХозяйственнаяОперация         КАК ХозяйственнаяОперация,
	|		Записи.СтатьяДвиженияДенежныхСредств КАК СтатьяДвиженияДенежныхСредств,
	|		Записи.Заказ                         КАК Заказ
	|	ИЗ
	|		РегистрНакопления.ДенежныеСредстваУПодотчетныхЛиц КАК Записи
	|	ГДЕ
	|		Записи.Регистратор = &Регистратор
	|		И (ТипЗначения(Записи.Регистратор) = ТИП(Документ.ПереоценкаВалютныхСредств)
	|			ИЛИ Записи.Валюта <> &ВалютаУпр
	|			ИЛИ Записи.Валюта <> &ВалютаРегл)
	|	) КАК Таблица
	|
	|СГРУППИРОВАТЬ ПО
	|	НАЧАЛОПЕРИОДА(Таблица.Период, МЕСЯЦ),
	|	Таблица.Период,
	|	Таблица.Регистратор,
	|	Таблица.Организация,
	|	Таблица.ПодотчетноеЛицо,
	|	Таблица.ЦельВыдачи,
	|	Таблица.Валюта,
	|	Таблица.ХозяйственнаяОперация,
	|	Таблица.СтатьяДвиженияДенежныхСредств,
	|	Таблица.Заказ
	|ИМЕЮЩИЕ
	|	СУММА(Таблица.Сумма) <> 0
	|	ИЛИ СУММА(Таблица.СуммаУпр) <> 0
	|	ИЛИ СУММА(Таблица.СуммаРегл) <> 0
	|	ИЛИ СУММА(Таблица.КОтчету) <> 0
	|");
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Запрос.УстановитьПараметр("Операция", Перечисления.ОперацииЗакрытияМесяца.ПереоценкаВалютныхСредств);
	Запрос.УстановитьПараметр("ВалютаУпр", ДополнительныеСвойства.ДляПроведения.ВалютаУпр);
	Запрос.УстановитьПараметр("ВалютаРегл", ДополнительныеСвойства.ДляПроведения.ВалютаРегл);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("Константа.НомерЗаданияКЗакрытиюМесяца");
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Разделяемый;
		Блокировка.Заблокировать();

		НаборЗаписей = РегистрыСведений.ЗаданияКЗакрытиюМесяца.СоздатьМенеджерЗаписи();
		ЗаполнитьЗначенияСвойств(НаборЗаписей, Выборка);
		НаборЗаписей.НомерЗадания = Константы.НомерЗаданияКЗакрытиюМесяца.Получить();
		НаборЗаписей.Записать();
	КонецЦикла;
КонецПроцедуры

#КонецОбласти

#КонецЕсли