#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//   Форма - УправляемаяФорма - Форма отчета.
//   КлючВарианта - Строка - Имя предопределенного варианта отчета или уникальный идентификатор пользовательского.
//   Настройки - Структура - см. возвращаемое значение ОтчетыКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию().
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	Настройки.События.ПриСозданииНаСервере = Истина;
	Настройки.Вставить("РазрешеноМенятьВарианты", Истина);
КонецПроцедуры

// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
//
// Параметры:
//   Форма - УправляемаяФорма - Форма отчета.
//   Отказ - Передается из параметров обработчика "как есть".
//   СтандартнаяОбработка - Передается из параметров обработчика "как есть".
//
// См. также:
//   "УправляемаяФорма.ПриСозданииНаСервере" в синтакс-помощнике.
//
Процедура ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка) Экспорт
	
	КомпоновщикНастроекФормы = ЭтаФорма.Отчет.КомпоновщикНастроек;
	Параметры = ЭтаФорма.Параметры;
	
	Если Параметры.Свойство("ПараметрКоманды") Тогда
		ЭтаФорма.ФормаПараметры.Отбор.Вставить("Документ", Параметры.ПараметрКоманды);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	ПараметрСтандартныйПериод = Неопределено;
	
	Для Каждого Элемент Из КомпоновщикНастроек.ПользовательскиеНастройки.Элементы Цикл
		
		Если ТипЗнч(Элемент) = Тип("ЗначениеПараметраНастроекКомпоновкиДанных")
			И ТипЗнч(Элемент.Значение) = Тип("СтандартныйПериод") Тогда
			Если Элемент.Использование Тогда
				ПараметрСтандартныйПериод = Элемент.Значение;
			КонецЕсли;
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	ПериодОтчетаНачало = Дата(1, 1, 1, 0, 0, 1);
	Если ПараметрСтандартныйПериод <> Неопределено И ЗначениеЗаполнено(ПараметрСтандартныйПериод.ДатаНачала) Тогда
		ПериодОтчетаНачало = ПараметрСтандартныйПериод.ДатаНачала;
	КонецЕсли;
	
	ПериодОтчетаОкончание = Дата(2999, 12, 31, 23, 59, 59);
	Если ПараметрСтандартныйПериод <> Неопределено И ЗначениеЗаполнено(ПараметрСтандартныйПериод.ДатаОкончания) Тогда
		ПериодОтчетаОкончание = ПараметрСтандартныйПериод.ДатаОкончания;
	КонецЕсли;
	
	ПараметрПериодОтчетаНачало = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("ПериодОтчетаНачало");
	ПараметрПериодОтчетаНачало.Значение = ПериодОтчетаНачало;
	ПараметрПериодОтчетаНачало.Использование = Истина;
	ПараметрПериодОтчетаОкончание = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("ПериодОтчетаОкончание");
	ПараметрПериодОтчетаОкончание.Значение = ПериодОтчетаОкончание;
	ПараметрПериодОтчетаОкончание.Использование = Истина;
	
	СхемаКомпоновкиДанных.НаборыДанных.НаборДанных.Запрос = ТекстЗапросаНабораДанных();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ТекстЗапросаНабораДанных()
	
	Возврат
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ТабличнаяЧасть.ПартияТМЦВЭксплуатации
	|ПОМЕСТИТЬ ПартииДокумента
	|ИЗ
	|	Документ.ВнутреннееПотреблениеТоваров.Товары КАК ТабличнаяЧасть
	|ГДЕ
	|	&ПоДокументу
	|	И ТабличнаяЧасть.Ссылка = &Документ
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ТабличнаяЧасть.ПартияТМЦВЭксплуатации
	|ИЗ
	|	Документ.ЗаказНаВнутреннееПотребление КАК Заказ
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ВнутреннееПотреблениеТоваров.Товары КАК ТабличнаяЧасть
	|		ПО Заказ.Ссылка = ТабличнаяЧасть.ЗаказНаВнутреннееПотребление
	|ГДЕ
	|	&ПоДокументу
	|	И Заказ.Ссылка = &Документ
	|
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ТабличнаяЧасть.ПартияТМЦВЭксплуатации
	|ИЗ
	|	Документ.ПрочееОприходованиеТоваров.Товары КАК ТабличнаяЧасть
	|ГДЕ
	|	&ПоДокументу
	|	И ТабличнаяЧасть.Ссылка = &Документ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Партии.Ссылка,
	|	ВЫБОР
	|		КОГДА Партии.ДатаЗавершенияЭксплуатации <= &ПериодОтчетаОкончание
	
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК НазначенныйРесурсПревышен
	|ПОМЕСТИТЬ ПартииПериодНачало
	|ИЗ
	|	Справочник.ПартииТМЦВЭксплуатации КАК Партии
	|ГДЕ
	|	НЕ Партии.ПометкаУдаления
	|	И
	|				Партии.ДатаЗавершенияЭксплуатации >= &ПериодОтчетаНачало
	|	И (НЕ &ПоДокументу
	|			ИЛИ Партии.Ссылка В
	|				(ВЫБРАТЬ
	|					ПартииДокумента.ПартияТМЦВЭксплуатации
	|				ИЗ
	|					ПартииДокумента КАК ПартииДокумента))
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Партии.Ссылка,
	|	ВЫБОР
	|		КОГДА Партии.ДатаЗавершенияЭксплуатации > &ПериодОтчетаОкончание
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК НазначенныйРесурсПревышен
	|ПОМЕСТИТЬ ПартииПериодОкончание
	|ИЗ
	|	Справочник.ПартииТМЦВЭксплуатации КАК Партии
	|ГДЕ
	|	НЕ Партии.ПометкаУдаления
	|	И
	|				Партии.ДатаЗавершенияЭксплуатации > &ПериодОтчетаОкончание
	|	И (НЕ &ПоДокументу
	|			ИЛИ Партии.Ссылка В
	|				(ВЫБРАТЬ
	|					ПартииДокумента.ПартияТМЦВЭксплуатации
	|				ИЗ
	|					ПартииДокумента КАК ПартииДокумента))
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТМЦВЭксплуатации.ПериодСекунда,
	|	ТМЦВЭксплуатации.ПериодМинута,
	|	ТМЦВЭксплуатации.ПериодЧас,
	|	ТМЦВЭксплуатации.ПериодДень,
	|	ТМЦВЭксплуатации.ПериодНеделя,
	|	ТМЦВЭксплуатации.ПериодДекада,
	|	ТМЦВЭксплуатации.ПериодМесяц,
	|	ТМЦВЭксплуатации.ПериодКвартал,
	|	ТМЦВЭксплуатации.ПериодПолугодие,
	|	ТМЦВЭксплуатации.ПериодГод,
	|	ТМЦВЭксплуатации.Регистратор КАК Регистратор,
	|	ТМЦВЭксплуатации.Организация КАК Организация,
	|	ТМЦВЭксплуатации.Подразделение КАК Подразделение,
	|	ТМЦВЭксплуатации.ФизическоеЛицо КАК ФизическоеЛицо,
	|	ТМЦВЭксплуатации.Номенклатура КАК Номенклатура,
	|	ТМЦВЭксплуатации.Характеристика КАК Характеристика,
	|	ТМЦВЭксплуатации.Партия КАК Партия,
	|	ВЫБОР
	|		КОГДА ТМЦВЭксплуатации.КоличествоОборот > 0
	|			ТОГДА ТМЦВЭксплуатации.КоличествоОборот
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК Приход,
	|	ВЫБОР
	|		КОГДА ТМЦВЭксплуатации.КоличествоОборот < 0
	|			ТОГДА -ТМЦВЭксплуатации.КоличествоОборот
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК Расход
	|ПОМЕСТИТЬ втОборотыЗаПериод
	|ИЗ
	|	РегистрНакопления.ТМЦВЭксплуатации.Обороты(
	|		&ПериодОтчетаНачало,
	|		&ПериодОтчетаОкончание,
	|		Авто,
	|		Партия В
	|			(ВЫБРАТЬ
	|				АктуальныеПартии.Ссылка
	|			ИЗ
	|				ПартииПериодНачало КАК АктуальныеПартии)) КАК ТМЦВЭксплуатации
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ТМЦВЭксплуатацииКонечныйОстаток.Партия.ДатаЗавершенияЭксплуатации,
	|	НАЧАЛОПЕРИОДА(ТМЦВЭксплуатацииКонечныйОстаток.Партия.ДатаЗавершенияЭксплуатации, МИНУТА),
	|	НАЧАЛОПЕРИОДА(ТМЦВЭксплуатацииКонечныйОстаток.Партия.ДатаЗавершенияЭксплуатации, ЧАС),
	|	НАЧАЛОПЕРИОДА(ТМЦВЭксплуатацииКонечныйОстаток.Партия.ДатаЗавершенияЭксплуатации, ДЕНЬ),
	|	НАЧАЛОПЕРИОДА(ТМЦВЭксплуатацииКонечныйОстаток.Партия.ДатаЗавершенияЭксплуатации, НЕДЕЛЯ),
	|	НАЧАЛОПЕРИОДА(ТМЦВЭксплуатацииКонечныйОстаток.Партия.ДатаЗавершенияЭксплуатации, ДЕКАДА),
	|	НАЧАЛОПЕРИОДА(ТМЦВЭксплуатацииКонечныйОстаток.Партия.ДатаЗавершенияЭксплуатации, МЕСЯЦ),
	|	НАЧАЛОПЕРИОДА(ТМЦВЭксплуатацииКонечныйОстаток.Партия.ДатаЗавершенияЭксплуатации, КВАРТАЛ),
	|	НАЧАЛОПЕРИОДА(ТМЦВЭксплуатацииКонечныйОстаток.Партия.ДатаЗавершенияЭксплуатации, ПОЛУГОДИЕ),
	|	НАЧАЛОПЕРИОДА(ТМЦВЭксплуатацииКонечныйОстаток.Партия.ДатаЗавершенияЭксплуатации, ГОД),
	|	ТМЦВЭксплуатацииКонечныйОстаток.Партия.Документ,
	|	ТМЦВЭксплуатацииКонечныйОстаток.Организация,
	|	ТМЦВЭксплуатацииКонечныйОстаток.Подразделение,
	|	ТМЦВЭксплуатацииКонечныйОстаток.ФизическоеЛицо,
	|	ТМЦВЭксплуатацииКонечныйОстаток.Номенклатура,
	|	ТМЦВЭксплуатацииКонечныйОстаток.Характеристика,
	|	ТМЦВЭксплуатацииКонечныйОстаток.Партия,
	|	0,
	|	СУММА(ТМЦВЭксплуатацииКонечныйОстаток.КоличествоОборот)
	|ИЗ
	|	РегистрНакопления.ТМЦВЭксплуатации.Обороты(
	|			,
	|			&ПериодОтчетаОкончание,
	|			,
	|			Партия В
	|				(ВЫБРАТЬ
	|					АктуальныеПартии.Ссылка
	|				ИЗ
	|					ПартииПериодНачало КАК АктуальныеПартии
	|				ГДЕ
	|					АктуальныеПартии.НазначенныйРесурсПревышен)) КАК ТМЦВЭксплуатацииКонечныйОстаток
	|ГДЕ
	|	ТМЦВЭксплуатацииКонечныйОстаток.КоличествоОборот > 0
	|
	|СГРУППИРОВАТЬ ПО
	|	ТМЦВЭксплуатацииКонечныйОстаток.Партия.ДатаЗавершенияЭксплуатации,
	|	ТМЦВЭксплуатацииКонечныйОстаток.Партия.Документ,
	|	ТМЦВЭксплуатацииКонечныйОстаток.Организация,
	|	ТМЦВЭксплуатацииКонечныйОстаток.Подразделение,
	|	ТМЦВЭксплуатацииКонечныйОстаток.ФизическоеЛицо,
	|	ТМЦВЭксплуатацииКонечныйОстаток.Номенклатура,
	|	ТМЦВЭксплуатацииКонечныйОстаток.Характеристика,
	|	ТМЦВЭксплуатацииКонечныйОстаток.Партия,
	|	ТМЦВЭксплуатацииКонечныйОстаток.Партия.ДатаЗавершенияЭксплуатации
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ТМЦВЭксплуатацииНачальныйОстаток.Организация,
	|	ТМЦВЭксплуатацииНачальныйОстаток.Подразделение,
	|	ТМЦВЭксплуатацииНачальныйОстаток.ФизическоеЛицо,
	|	ТМЦВЭксплуатацииНачальныйОстаток.Номенклатура,
	|	ТМЦВЭксплуатацииНачальныйОстаток.Характеристика,
	|	ТМЦВЭксплуатацииНачальныйОстаток.Партия,
	|	ТМЦВЭксплуатацииНачальныйОстаток.КоличествоОборот КАК НачальныйОстаток
	|ПОМЕСТИТЬ втНачальныйОстаток
	|ИЗ
	|	РегистрНакопления.ТМЦВЭксплуатации.Обороты(
	|			,
	|			&ПериодОтчетаНачало,
	|			,
	|			Партия В
	|				(ВЫБРАТЬ
	|					АктуальныеПартии.Ссылка
	|				ИЗ
	|					ПартииПериодНачало КАК АктуальныеПартии)) КАК ТМЦВЭксплуатацииНачальныйОстаток
	|ГДЕ
	|	ТМЦВЭксплуатацииНачальныйОстаток.КоличествоОборот > 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ТМЦВЭксплуатацииНачальныйОстаток.Организация,
	|	ТМЦВЭксплуатацииНачальныйОстаток.Подразделение,
	|	ТМЦВЭксплуатацииНачальныйОстаток.ФизическоеЛицо,
	|	ТМЦВЭксплуатацииНачальныйОстаток.Номенклатура,
	|	ТМЦВЭксплуатацииНачальныйОстаток.Характеристика,
	|	ТМЦВЭксплуатацииНачальныйОстаток.Партия,
	|	ТМЦВЭксплуатацииНачальныйОстаток.КоличествоОборот КАК КонечныйОстаток
	|ПОМЕСТИТЬ втКонечныйОстаток
	|ИЗ
	|	РегистрНакопления.ТМЦВЭксплуатации.Обороты(
	|			,
	|			&ПериодОтчетаОкончание,
	|			,
	|			Партия В
	|				(ВЫБРАТЬ
	|					АктуальныеПартии.Ссылка
	|				ИЗ
	|					ПартииПериодОкончание КАК АктуальныеПартии)) КАК ТМЦВЭксплуатацииНачальныйОстаток
	|ГДЕ
	|	ТМЦВЭксплуатацииНачальныйОстаток.КоличествоОборот > 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	втОборотыЗаПериод.ПериодСекунда,
	|	втОборотыЗаПериод.ПериодМинута,
	|	втОборотыЗаПериод.ПериодЧас,
	|	втОборотыЗаПериод.ПериодДень,
	|	втОборотыЗаПериод.ПериодНеделя,
	|	втОборотыЗаПериод.ПериодДекада,
	|	втОборотыЗаПериод.ПериодМесяц,
	|	втОборотыЗаПериод.ПериодКвартал,
	|	втОборотыЗаПериод.ПериодПолугодие,
	|	втОборотыЗаПериод.ПериодГод,
	|	втОборотыЗаПериод.Регистратор КАК Регистратор,
	|	втОборотыЗаПериод.Организация КАК Организация,
	|	втОборотыЗаПериод.Подразделение КАК Подразделение,
	|	втОборотыЗаПериод.ФизическоеЛицо КАК ФизическоеЛицо,
	|	втОборотыЗаПериод.Номенклатура КАК Номенклатура,
	|	втОборотыЗаПериод.Характеристика КАК Характеристика,
	|	втОборотыЗаПериод.Партия КАК Партия,
	|	ЕСТЬNULL(СУММА(втОборотыЗаПериодИтоги.Приход - втОборотыЗаПериодИтоги.Расход), 0) КАК НачальныйОстаток,
	|	втОборотыЗаПериод.Приход КАК Приход,
	|	втОборотыЗаПериод.Расход КАК Расход
	|ПОМЕСТИТЬ втОборотыСИтогами
	|ИЗ
	|	втОборотыЗаПериод КАК втОборотыЗаПериод
	|		ЛЕВОЕ СОЕДИНЕНИЕ втОборотыЗаПериод КАК втОборотыЗаПериодИтоги
	|		ПО втОборотыЗаПериод.Организация = втОборотыЗаПериодИтоги.Организация
	|			И втОборотыЗаПериод.Подразделение = втОборотыЗаПериодИтоги.Подразделение
	|			И втОборотыЗаПериод.ФизическоеЛицо = втОборотыЗаПериодИтоги.ФизическоеЛицо
	|			И втОборотыЗаПериод.Номенклатура = втОборотыЗаПериодИтоги.Номенклатура
	|			И втОборотыЗаПериод.Характеристика = втОборотыЗаПериодИтоги.Характеристика
	|			И втОборотыЗаПериод.Партия = втОборотыЗаПериодИтоги.Партия
	|			И втОборотыЗаПериод.ПериодСекунда > втОборотыЗаПериодИтоги.ПериодСекунда
	|
	|СГРУППИРОВАТЬ ПО
	|	втОборотыЗаПериод.ПериодСекунда,
	|	втОборотыЗаПериод.ПериодМинута,
	|	втОборотыЗаПериод.ПериодЧас,
	|	втОборотыЗаПериод.ПериодДень,
	|	втОборотыЗаПериод.ПериодНеделя,
	|	втОборотыЗаПериод.ПериодДекада,
	|	втОборотыЗаПериод.ПериодМесяц,
	|	втОборотыЗаПериод.ПериодКвартал,
	|	втОборотыЗаПериод.ПериодПолугодие,
	|	втОборотыЗаПериод.ПериодГод,
	|	втОборотыЗаПериод.Регистратор,
	|	втОборотыЗаПериод.Организация,
	|	втОборотыЗаПериод.Подразделение,
	|	втОборотыЗаПериод.ФизическоеЛицо,
	|	втОборотыЗаПериод.Номенклатура,
	|	втОборотыЗаПериод.Характеристика,
	|	втОборотыЗаПериод.Партия,
	|	втОборотыЗаПериод.Приход,
	|	втОборотыЗаПериод.Расход
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	втОборотыСИтогами.ПериодСекунда,
	|	втОборотыСИтогами.ПериодМинута,
	|	втОборотыСИтогами.ПериодЧас,
	|	втОборотыСИтогами.ПериодДень,
	|	втОборотыСИтогами.ПериодНеделя,
	|	втОборотыСИтогами.ПериодДекада,
	|	втОборотыСИтогами.ПериодМесяц,
	|	втОборотыСИтогами.ПериодКвартал,
	|	втОборотыСИтогами.ПериодПолугодие,
	|	втОборотыСИтогами.ПериодГод,
	|	втОборотыСИтогами.Регистратор КАК Регистратор,
	|	втОборотыСИтогами.Организация КАК Организация,
	|	втОборотыСИтогами.Подразделение КАК Подразделение,
	|	втОборотыСИтогами.ФизическоеЛицо КАК ФизическоеЛицо,
	|	втОборотыСИтогами.Номенклатура КАК Номенклатура,
	|	втОборотыСИтогами.Характеристика КАК Характеристика,
	|	втОборотыСИтогами.Партия КАК Партия,
	|	ЕСТЬNULL(втНачальныйОстаток.НачальныйОстаток, 0) + втОборотыСИтогами.НачальныйОстаток КАК НачальныйОстаток,
	|	втОборотыСИтогами.Приход КАК Приход,
	|	втОборотыСИтогами.Расход КАК Расход,
	|	ЕСТЬNULL(втНачальныйОстаток.НачальныйОстаток, 0) + втОборотыСИтогами.НачальныйОстаток + втОборотыСИтогами.Приход - втОборотыСИтогами.Расход КАК КонечныйОстаток
	|ПОМЕСТИТЬ втИтоговаяТаблица
	|ИЗ
	|	втОборотыСИтогами КАК втОборотыСИтогами
	|		ЛЕВОЕ СОЕДИНЕНИЕ втНачальныйОстаток КАК втНачальныйОстаток
	|		ПО втОборотыСИтогами.Организация = втНачальныйОстаток.Организация
	|			И втОборотыСИтогами.Подразделение = втНачальныйОстаток.Подразделение
	|			И втОборотыСИтогами.ФизическоеЛицо = втНачальныйОстаток.ФизическоеЛицо
	|			И втОборотыСИтогами.Номенклатура = втНачальныйОстаток.Номенклатура
	|			И втОборотыСИтогами.Характеристика = втНачальныйОстаток.Характеристика
	|			И втОборотыСИтогами.Партия = втНачальныйОстаток.Партия
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	НАЧАЛОПЕРИОДА(&ПериодОтчетаНачало, ДЕНЬ) КАК Период,
	|	НАЧАЛОПЕРИОДА(&ПериодОтчетаНачало, ДЕНЬ),
	|	НАЧАЛОПЕРИОДА(&ПериодОтчетаНачало, ДЕНЬ),
	|	НАЧАЛОПЕРИОДА(&ПериодОтчетаНачало, ДЕНЬ),
	|	НАЧАЛОПЕРИОДА(&ПериодОтчетаНачало, НЕДЕЛЯ),
	|	НАЧАЛОПЕРИОДА(&ПериодОтчетаНачало, ДЕКАДА),
	|	НАЧАЛОПЕРИОДА(&ПериодОтчетаНачало, МЕСЯЦ),
	|	НАЧАЛОПЕРИОДА(&ПериодОтчетаНачало, КВАРТАЛ),
	|	НАЧАЛОПЕРИОДА(&ПериодОтчетаНачало, ПОЛУГОДИЕ),
	|	НАЧАЛОПЕРИОДА(&ПериодОтчетаНачало, ГОД),
	|	NULL КАК Регистратор,
	|	втНачальныйОстаток.Организация КАК Организация,
	|	втНачальныйОстаток.Подразделение КАК Подразделение,
	|	втНачальныйОстаток.ФизическоеЛицо КАК ФизическоеЛицо,
	|	втНачальныйОстаток.Номенклатура КАК Номенклатура,
	|	втНачальныйОстаток.Характеристика КАК Характеристика,
	|	втНачальныйОстаток.Партия КАК Партия,
	|	втНачальныйОстаток.НачальныйОстаток КАК НачальныйОстаток,
	|	0 КАК Приход,
	|	0 КАК Расход,
	|	втНачальныйОстаток.НачальныйОстаток КАК КонечныйОстаток
	|ИЗ
	|	втНачальныйОстаток КАК втНачальныйОстаток
	|		ЛЕВОЕ СОЕДИНЕНИЕ втОборотыСИтогами КАК втОборотыСИтогами
	|		ПО втНачальныйОстаток.Организация = втОборотыСИтогами.Организация
	|			И втНачальныйОстаток.Подразделение = втОборотыСИтогами.Подразделение
	|			И втНачальныйОстаток.ФизическоеЛицо = втОборотыСИтогами.ФизическоеЛицо
	|			И втНачальныйОстаток.Номенклатура = втОборотыСИтогами.Номенклатура
	|			И втНачальныйОстаток.Характеристика = втОборотыСИтогами.Характеристика
	|			И втНачальныйОстаток.Партия = втОборотыСИтогами.Партия
	|ГДЕ
	|	втОборотыСИтогами.Партия ЕСТЬ NULL
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	НАЧАЛОПЕРИОДА(&ПериодОтчетаОкончание, ДЕНЬ) КАК Период,
	|	НАЧАЛОПЕРИОДА(&ПериодОтчетаОкончание, ДЕНЬ),
	|	НАЧАЛОПЕРИОДА(&ПериодОтчетаОкончание, ДЕНЬ),
	|	НАЧАЛОПЕРИОДА(&ПериодОтчетаОкончание, ДЕНЬ),
	|	НАЧАЛОПЕРИОДА(&ПериодОтчетаОкончание, НЕДЕЛЯ),
	|	НАЧАЛОПЕРИОДА(&ПериодОтчетаОкончание, ДЕКАДА),
	|	НАЧАЛОПЕРИОДА(&ПериодОтчетаОкончание, МЕСЯЦ),
	|	НАЧАЛОПЕРИОДА(&ПериодОтчетаОкончание, КВАРТАЛ),
	|	НАЧАЛОПЕРИОДА(&ПериодОтчетаОкончание, ПОЛУГОДИЕ),
	|	НАЧАЛОПЕРИОДА(&ПериодОтчетаОкончание, ГОД),
	|	NULL КАК Регистратор,
	|	втКонечныйОстаток.Организация КАК Организация,
	|	втКонечныйОстаток.Подразделение КАК Подразделение,
	|	втКонечныйОстаток.ФизическоеЛицо КАК ФизическоеЛицо,
	|	втКонечныйОстаток.Номенклатура КАК Номенклатура,
	|	втКонечныйОстаток.Характеристика КАК Характеристика,
	|	втКонечныйОстаток.Партия КАК Партия,
	|	втКонечныйОстаток.КонечныйОстаток КАК НачальныйОстаток,
	|	0 КАК Приход,
	|	0 КАК Расход,
	|	втКонечныйОстаток.КонечныйОстаток КАК КонечныйОстаток
	|ИЗ
	|	втКонечныйОстаток КАК втКонечныйОстаток
	|		ЛЕВОЕ СОЕДИНЕНИЕ втОборотыСИтогами КАК втОборотыСИтогами
	|		ПО втКонечныйОстаток.Организация = втОборотыСИтогами.Организация
	|			И втКонечныйОстаток.Подразделение = втОборотыСИтогами.Подразделение
	|			И втКонечныйОстаток.ФизическоеЛицо = втОборотыСИтогами.ФизическоеЛицо
	|			И втКонечныйОстаток.Номенклатура = втОборотыСИтогами.Номенклатура
	|			И втКонечныйОстаток.Характеристика = втОборотыСИтогами.Характеристика
	|			И втКонечныйОстаток.Партия = втОборотыСИтогами.Партия
	|		ЛЕВОЕ СОЕДИНЕНИЕ втНачальныйОстаток КАК втНачальныйОстаток
	|		ПО втКонечныйОстаток.Организация = втНачальныйОстаток.Организация
	|			И втКонечныйОстаток.Подразделение = втНачальныйОстаток.Подразделение
	|			И втКонечныйОстаток.ФизическоеЛицо = втНачальныйОстаток.ФизическоеЛицо
	|			И втКонечныйОстаток.Номенклатура = втНачальныйОстаток.Номенклатура
	|			И втКонечныйОстаток.Характеристика = втНачальныйОстаток.Характеристика
	|			И втКонечныйОстаток.Партия = втНачальныйОстаток.Партия
	|ГДЕ
	|	втОборотыСИтогами.Партия ЕСТЬ NULL И втНачальныйОстаток.Партия ЕСТЬ NULL
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ИтоговаяТаблица.ПериодСекунда,
	|	ИтоговаяТаблица.ПериодМинута,
	|	ИтоговаяТаблица.ПериодЧас,
	|	ИтоговаяТаблица.ПериодДень,
	|	ИтоговаяТаблица.ПериодНеделя,
	|	ИтоговаяТаблица.ПериодДекада,
	|	ИтоговаяТаблица.ПериодМесяц,
	|	ИтоговаяТаблица.ПериодКвартал,
	|	ИтоговаяТаблица.ПериодПолугодие,
	|	ИтоговаяТаблица.ПериодГод,
	|	ИтоговаяТаблица.Регистратор,
	|	ИтоговаяТаблица.Организация,
	|	ИтоговаяТаблица.Подразделение,
	|	ИтоговаяТаблица.ФизическоеЛицо,
	|	ИтоговаяТаблица.Номенклатура,
	|	ИтоговаяТаблица.Характеристика,
	|	ИтоговаяТаблица.Номенклатура.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	ИтоговаяТаблица.Партия,
	|	ИтоговаяТаблица.НачальныйОстаток,
	|	ИтоговаяТаблица.Приход,
	|	ИтоговаяТаблица.Расход,
	|	ИтоговаяТаблица.КонечныйОстаток КАК КонечныйОстаток,
	|	ЕСТЬNULL(ПартииПериодНачало.НазначенныйРесурсПревышен, ЛОЖЬ) КАК НазначенныйРесурсПревышен
	|ИЗ
	|	втИтоговаяТаблица КАК ИтоговаяТаблица
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПартииПериодНачало КАК ПартииПериодНачало
	|		ПО ИтоговаяТаблица.Партия = ПартииПериодНачало.Ссылка";
	
КонецФункции

#КонецОбласти

#КонецЕсли