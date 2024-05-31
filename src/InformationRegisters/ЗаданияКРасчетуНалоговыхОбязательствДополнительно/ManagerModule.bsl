#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

//Метод возвращает значение константы "Номер задания",
//считанной при разделяемой блокировке
Функция ПолучитьНомерЗадания() Экспорт
	НачатьТранзакцию();
	
	Блокировка = Новый БлокировкаДанных;
    ЭлементБлокировки = Блокировка.Добавить("Константа.НомерЗаданияКФормированиюИсходящихНалоговыхДокументов");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Разделяемый;
	Блокировка.Заблокировать();
	НомерЗадания = Константы.НомерЗаданияКФормированиюИсходящихНалоговыхДокументов.Получить();
	
	ЗафиксироватьТранзакцию();
	
	Возврат НомерЗадания;
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция КоличествоНеактуальныхДокументов(НачалоРасчета, КонецРасчета, АналитикиРасчета = Неопределено) Экспорт
	Запрос = Новый Запрос("
	|	ВЫБРАТЬ РАЗЛИЧНЫЕ
	|		КОЛИЧЕСТВО(Расчеты.Регистратор) КАК Количество
	|	ИЗ
	|		РегистрНакопления.НДСНоменклатурныйСоставДляНалоговыхНакладных КАК Расчеты
	|	ГДЕ
	|		Расчеты.Период МЕЖДУ &НачалоРасчета И &КонецРасчета
	|		И (Расчеты.АналитикаУчетаПоПартнерам В (&АналитикиРасчета)
	|			ИЛИ Расчеты.АналитикаУчетаПоПартнерам = ЗНАЧЕНИЕ(Справочник.КлючиАналитикиУчетаПоПартнерам.ПустаяСсылка)
	|			ИЛИ &ПоВсемАналитикам)
	|");
	
	Запрос.УстановитьПараметр("НачалоРасчета", НачалоРасчета);
	Запрос.УстановитьПараметр("КонецРасчета", КонецРасчета);
	Запрос.УстановитьПараметр("АналитикиРасчета", АналитикиРасчета);
	Запрос.УстановитьПараметр("ПоВсемАналитикам", НЕ Значениезаполнено(АналитикиРасчета));
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда 
		КоличествоДокументов = 0;
	Иначе
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		КоличествоДокументов = Выборка.Количество;
	КонецЕсли;
	Возврат КоличествоДокументов;
КонецФункции

#Область ОбновлениеИнформационнойБазы

#КонецОбласти

#КонецОбласти

#КонецЕсли