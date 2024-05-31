#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("СтрокаПоиска", ?(Параметры.СтрокаПоиска = Неопределено, "", Параметры.СтрокаПоиска) + "%");
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВидыДокументовФизическихЛиц.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ВидыДокументовФизическихЛиц КАК ВидыДокументовФизическихЛиц
	|ГДЕ
	|	НЕ ВидыДокументовФизическихЛиц.ПометкаУдаления
	|	И ВидыДокументовФизическихЛиц.Наименование ПОДОБНО &СтрокаПоиска
	|
	|УПОРЯДОЧИТЬ ПО
	|	ВидыДокументовФизическихЛиц.РеквизитДопУпорядочивания";
	
	ДанныеВыбора = Новый СписокЗначений;
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ДанныеВыбора.Добавить(Выборка.Ссылка);
	КонецЦикла;
	
КонецПроцедуры

#КонецЕсли