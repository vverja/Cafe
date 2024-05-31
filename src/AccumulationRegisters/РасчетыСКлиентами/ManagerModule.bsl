#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область ОбновлениеИнформационнойБазы

Процедура ИсправитьДвижения_ДанныеДляОбновления(Параметры) Экспорт
	
	ДополнительныеПараметры = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	ДополнительныеПараметры.ЭтоДвижения = Истина;
	ДополнительныеПараметры.ПолноеИмяРегистра = "РегистрНакопления.РасчетыСКлиентами";


#Область АналитикаУчетаПоПартнерам
	
	// Производит замену измерения "АналитикаУчетаПоПартнерам" с учетом договора.
	
	Запрос = Новый Запрос("
		|ВЫБРАТЬ
		|	РасчетыСКлиентамиОстаткиИОбороты.ЗаказКлиента КАК ЗаказКлиента
		|ПОМЕСТИТЬ ВТДвижения
		|ИЗ
		|	РегистрНакопления.РасчетыСКлиентами.ОстаткиИОбороты(
		|			,
		|			,
		|			,
		|			,
		|			ЗаказКлиента ССЫЛКА Документ.ЗаказКлиента
		|				ИЛИ ЗаказКлиента ССЫЛКА Справочник.ДоговорыКонтрагентов) КАК РасчетыСКлиентамиОстаткиИОбороты
		|ГДЕ
		|	РасчетыСКлиентамиОстаткиИОбороты.ОтгружаетсяКонечныйОстаток <> 0
		|	И РасчетыСКлиентамиОстаткиИОбороты.КОтгрузкеКонечныйОстаток = 0
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	РасчетыСКлиентами.Регистратор КАК Регистратор,
		|	РасчетыСКлиентами.ВидДвижения КАК ВидДвижения,
		|	РасчетыСКлиентами.ЗаказКлиента КАК ЗаказКлиента,
		|	СУММА(РасчетыСКлиентами.Отгружается) КАК Отгружается
		|ПОМЕСТИТЬ ВТДвиженияЗаказов
		|ИЗ
		|	РегистрНакопления.РасчетыСКлиентами КАК РасчетыСКлиентами
		|ГДЕ
		|	РасчетыСКлиентами.Регистратор ССЫЛКА Документ.ЗаказКлиента
		|	И РасчетыСКлиентами.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|	И (РасчетыСКлиентами.ЗаказКлиента ССЫЛКА Документ.ЗаказКлиента
		|			ИЛИ РасчетыСКлиентами.ЗаказКлиента ССЫЛКА Документ.ЗаявкаНаВозвратТоваровОтКлиента
		|			ИЛИ РасчетыСКлиентами.ЗаказКлиента ССЫЛКА Справочник.ДоговорыКонтрагентов)
		|
		|СГРУППИРОВАТЬ ПО
		|	РасчетыСКлиентами.Регистратор,
		|	РасчетыСКлиентами.ЗаказКлиента,
		|	РасчетыСКлиентами.ВидДвижения
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТДвижения.Регистратор КАК Ссылка
		|ПОМЕСТИТЬ ВТЗаказы
		|ИЗ
		|	ВТДвиженияЗаказов КАК ВТДвижения
		|ГДЕ
		|	ВТДвижения.Отгружается = 0
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Расчеты.Регистратор КАК Ссылка
		|ИЗ
		|	РегистрНакопления.РасчетыСКлиентами КАК Расчеты
		|
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаПоПартнерам КАК Аналитика
		|		ПО Расчеты.АналитикаУчетаПоПартнерам = Аналитика.КлючАналитики
		|			И (Аналитика.Договор = ЗНАЧЕНИЕ(Справочник.ДоговорыКонтрагентов.ПустаяСсылка))
		|
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ДоговорыКонтрагентов КАК Договоры
		|		ПО (Договоры.Ссылка = 
		|				ВЫБОР КОГДА Расчеты.ЗаказКлиента ССЫЛКА Справочник.ДоговорыКонтрагентов
		|					ТОГДА Расчеты.ЗаказКлиента
		|				ИНАЧЕ Расчеты.ЗаказКлиента.Договор
		|			КОНЕЦ)
		|ГДЕ
		|	    Расчеты.Регистратор ССЫЛКА Документ.АктВыполненныхРабот
		|	ИЛИ Расчеты.Регистратор ССЫЛКА Документ.ВводОстатков
		|	ИЛИ Расчеты.Регистратор ССЫЛКА Документ.ВзаимозачетЗадолженности
		|	ИЛИ Расчеты.Регистратор ССЫЛКА Документ.ВозвратТоваровМеждуОрганизациями
		|	ИЛИ Расчеты.Регистратор ССЫЛКА Документ.ВозвратТоваровОтКлиента
		|	ИЛИ Расчеты.Регистратор ССЫЛКА Документ.ВыкупВозвратнойТарыКлиентом
		|	ИЛИ Расчеты.Регистратор ССЫЛКА Документ.ЗаказКлиента
		|	ИЛИ Расчеты.Регистратор ССЫЛКА Документ.ЗаявкаНаВозвратТоваровОтКлиента
		|	ИЛИ Расчеты.Регистратор ССЫЛКА Документ.ОперацияПоПлатежнойКарте
		|	ИЛИ Расчеты.Регистратор ССЫЛКА Документ.ОтчетКомиссионера
		|	ИЛИ Расчеты.Регистратор ССЫЛКА Документ.ОтчетКомиссионераОСписании
		|	ИЛИ Расчеты.Регистратор ССЫЛКА Документ.ОтчетКомитенту
		|	ИЛИ Расчеты.Регистратор ССЫЛКА Документ.ОтчетПоКомиссииМеждуОрганизациями
		|	ИЛИ Расчеты.Регистратор ССЫЛКА Документ.ОтчетПоКомиссииМеждуОрганизациямиОСписании
		|	ИЛИ Расчеты.Регистратор ССЫЛКА Документ.ПередачаТоваровМеждуОрганизациями
		|	ИЛИ Расчеты.Регистратор ССЫЛКА Документ.ПоступлениеБезналичныхДенежныхСредств
		|	ИЛИ Расчеты.Регистратор ССЫЛКА Документ.ПриходныйКассовыйОрдер
		|	ИЛИ Расчеты.Регистратор ССЫЛКА Документ.РасходныйКассовыйОрдер
		|	ИЛИ Расчеты.Регистратор ССЫЛКА Документ.РеализацияТоваровУслуг
		|	ИЛИ Расчеты.Регистратор ССЫЛКА Документ.РеализацияУслугПрочихАктивов
		|	ИЛИ Расчеты.Регистратор ССЫЛКА Документ.СписаниеБезналичныхДенежныхСредств
		|	ИЛИ Расчеты.Регистратор ССЫЛКА Документ.СписаниеЗадолженности
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ДокументРеализацииТовары.Ссылка
		|ИЗ
		|	Документ.РеализацияТоваровУслуг.Товары КАК ДокументРеализацииТовары
		|ГДЕ
		|	ДокументРеализацииТовары.ЗаказКлиента В
		|			(ВЫБРАТЬ
		|				ВТДвижения.ЗаказКлиента
		|			ИЗ
		|				ВТДвижения)
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ДокументРеализацииТовары.Ссылка
		|ИЗ
		|	Документ.РеализацияТоваровУслуг.Товары КАК ДокументРеализацииТовары
		|	
		|ГДЕ
		|	ДокументРеализацииТовары.ЗаказКлиента В
		|			(ВЫБРАТЬ
		|				ВТЗаказы.Ссылка
		|			ИЗ
		|				ВТЗаказы)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ДокументРеализации.Ссылка
		|ИЗ
		|	Документ.РеализацияТоваровУслуг КАК ДокументРеализации
		|ГДЕ
		|	ДокументРеализации.Договор В
		|			(ВЫБРАТЬ
		|				ВТДвижения.ЗаказКлиента
		|			ИЗ
		|				ВТДвижения)
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ДокументРеализации.Ссылка
		|ИЗ
		|	Документ.РеализацияТоваровУслуг КАК ДокументРеализации
		|	
		|ГДЕ
		|	ДокументРеализации.Договор В
		|			(ВЫБРАТЬ
		|				ВТЗаказы.Ссылка
		|			ИЗ
		|				ВТЗаказы)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ДокументРеализацииТовары.Ссылка
		|ИЗ
		|	Документ.АктВыполненныхРабот.Услуги КАК ДокументРеализацииТовары
		|ГДЕ
		|	ДокументРеализацииТовары.ЗаказКлиента В
		|			(ВЫБРАТЬ
		|				ВТДвижения.ЗаказКлиента
		|			ИЗ
		|				ВТДвижения)
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ДокументРеализацииТовары.Ссылка
		|ИЗ
		|	Документ.АктВыполненныхРабот.Услуги КАК ДокументРеализацииТовары
		|	
		|ГДЕ
		|	ДокументРеализацииТовары.ЗаказКлиента В
		|			(ВЫБРАТЬ
		|				ВТЗаказы.Ссылка
		|			ИЗ
		|				ВТЗаказы)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ДокументРеализации.Ссылка
		|ИЗ
		|	Документ.АктВыполненныхРабот КАК ДокументРеализации
		|ГДЕ
		|	ДокументРеализации.Договор В
		|			(ВЫБРАТЬ
		|				ВТДвижения.ЗаказКлиента
		|			ИЗ
		|				ВТДвижения)
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ДокументРеализации.Ссылка
		|ИЗ
		|	Документ.АктВыполненныхРабот КАК ДокументРеализации
		|	
		|ГДЕ
		|	ДокументРеализации.Договор В
		|			(ВЫБРАТЬ
		|				ВТЗаказы.Ссылка
		|			ИЗ
		|				ВТЗаказы)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Заказ.Ссылка КАК Ссылка
		|ИЗ
		|	Документ.ЗаказКлиента КАК Заказ
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЗаказКлиента.Товары КАК ЗаказТовары
		|		ПО Заказ.Ссылка = ЗаказТовары.Ссылка
		|ГДЕ
		|	Заказ.Ссылка В
		|			(ВЫБРАТЬ
		|				ВТЗаказы.Ссылка
		|			ИЗ
		|				ВТЗаказы)
		|	И Заказ.Статус <> ЗНАЧЕНИЕ(Перечисление.СтатусыЗаказовКлиентов.НеСогласован)
		|	И Заказ.ПорядокРасчетов <> ЗНАЧЕНИЕ(Перечисление.ПорядокРасчетов.ПоНакладным)
		|	И Заказ.ХозяйственнаяОперация В (ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.РеализацияКлиенту), ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ОтгрузкаБезПереходаПраваСобственности))
		|	И ЗаказТовары.ВариантОбеспечения В (ЗНАЧЕНИЕ(Перечисление.ВариантыОбеспечения.Отгрузить), ЗНАЧЕНИЕ(Перечисление.ВариантыОбеспечения.ОтгрузитьОбособленно))
		|	И НЕ ЗаказТовары.Отменено
		|	И (ЗаказТовары.Номенклатура.ТипНоменклатуры <> ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара)
		|			ИЛИ Заказ.ТребуетсяЗалогЗаТару
		|			ИЛИ НЕ Заказ.ВернутьМногооборотнуюТару)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Заказ.Ссылка КАК Ссылка
		|ИЗ
		|	Документ.ЗаявкаНаВозвратТоваровОтКлиента КАК Заказ
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЗаявкаНаВозвратТоваровОтКлиента.ЗаменяющиеТовары КАК ЗаказТовары
		|		ПО Заказ.Ссылка = ЗаказТовары.Ссылка
		|ГДЕ
		|	Заказ.Ссылка В
		|			(ВЫБРАТЬ
		|				ВТЗаказы.Ссылка
		|			ИЗ
		|				ВТЗаказы)
		|	И Заказ.Статус В (ЗНАЧЕНИЕ(Перечисление.СтатусыЗаявокНаВозвратТоваровОтКлиентов.КВозврату),
		|				ЗНАЧЕНИЕ(Перечисление.СтатусыЗаявокНаВозвратТоваровОтКлиентов.КОбеспечению),
		|				ЗНАЧЕНИЕ(Перечисление.СтатусыЗаявокНаВозвратТоваровОтКлиентов.КОтгрузке),
		|				ЗНАЧЕНИЕ(Перечисление.СтатусыЗаявокНаВозвратТоваровОтКлиентов.Выполнена))
		|	И Заказ.ПорядокРасчетов <> ЗНАЧЕНИЕ(Перечисление.ПорядокРасчетов.ПоНакладным)
		|	И Заказ.ХозяйственнаяОперация <> ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВозвратОтКомиссионера)
		|	И ЗаказТовары.ВариантОбеспечения В (ЗНАЧЕНИЕ(Перечисление.ВариантыОбеспечения.Отгрузить), ЗНАЧЕНИЕ(Перечисление.ВариантыОбеспечения.ОтгрузитьОбособленно))
		|	И НЕ ЗаказТовары.Отменено
		|	И (ЗаказТовары.Номенклатура.ТипНоменклатуры <> ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара)
		|			ИЛИ Заказ.ТребуетсяЗалогЗаТару
		|			ИЛИ НЕ Заказ.ВернутьМногооборотнуюТару)
		|;");
	
	Регистраторы = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, Регистраторы, ДополнительныеПараметры);
	
#КонецОбласти

#Область ЗаказКлиента
	Документы.ЗаказКлиента.ИсправлениеДвиженийРасчетыСКлиентамиЗарегистрироватьДанныеДляКОбработке(Параметры);
#КонецОбласти

#Область ЗаявкаНаВозвратТоваровОтКлиента
	Документы.ЗаявкаНаВозвратТоваровОтКлиента.ИсправлениеДвиженийРасчетыСКлиентамиЗарегистрироватьДанныеДляКОбработке(Параметры);
#КонецОбласти

#Область УдалениеПустыхДвижений
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Расчеты.Регистратор КАК Регистратор
	|ИЗ
	|	РегистрНакопления.РасчетыСКлиентами КАК Расчеты
	|	
	|ГДЕ
	|	Расчеты.Сумма = 0
	|	И Расчеты.Оплачивается = 0
	|	И Расчеты.КОплате = 0
	|	И Расчеты.КОтгрузке = 0
	|	И Расчеты.Отгружается = 0
	|");
	
	Регистраторы = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Регистратор");
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, Регистраторы, ДополнительныеПараметры);
	
#КонецОбласти


КонецПроцедуры

// Обработчик обновления BAS УТ 3.2.3
// Производит замену измерения "АналитикаУчетаПоПартнерам" с учетом договора.
Процедура ИсправитьДвижения(Параметры) Экспорт
	
	Регистраторы = Новый Массив;
	Регистраторы.Добавить("Документ.АктВыполненныхРабот");
	Регистраторы.Добавить("Документ.ВводОстатков");
	Регистраторы.Добавить("Документ.ВзаимозачетЗадолженности");
	Регистраторы.Добавить("Документ.ВозвратТоваровМеждуОрганизациями");
	Регистраторы.Добавить("Документ.ВозвратТоваровОтКлиента");
	Регистраторы.Добавить("Документ.ВыкупВозвратнойТарыКлиентом");
	Регистраторы.Добавить("Документ.ЗаказКлиента");
	Регистраторы.Добавить("Документ.ЗаявкаНаВозвратТоваровОтКлиента");
	Регистраторы.Добавить("Документ.ОперацияПоПлатежнойКарте");
	Регистраторы.Добавить("Документ.ОтчетКомиссионера");
	Регистраторы.Добавить("Документ.ОтчетКомиссионераОСписании");
	Регистраторы.Добавить("Документ.ОтчетКомитенту");
	Регистраторы.Добавить("Документ.ОтчетПоКомиссииМеждуОрганизациями");
	Регистраторы.Добавить("Документ.ОтчетПоКомиссииМеждуОрганизациямиОСписании");
	Регистраторы.Добавить("Документ.ПередачаТоваровМеждуОрганизациями");
	Регистраторы.Добавить("Документ.ПоступлениеБезналичныхДенежныхСредств");
	Регистраторы.Добавить("Документ.ПриходныйКассовыйОрдер");
	Регистраторы.Добавить("Документ.РасходныйКассовыйОрдер");
	Регистраторы.Добавить("Документ.РеализацияТоваровУслуг");
	Регистраторы.Добавить("Документ.РеализацияУслугПрочихАктивов");
	Регистраторы.Добавить("Документ.СписаниеБезналичныхДенежныхСредств");
	Регистраторы.Добавить("Документ.СписаниеЗадолженности");
	
	ОбработкаЗавершена = ОбновлениеИнформационнойБазыУТ.ПерезаписатьДвиженияИзОчереди(
		Регистраторы,
		"РегистрНакопления.РасчетыСКлиентами",
		Параметры.Очередь
    );
	
	Параметры.ОбработкаЗавершена = ОбработкаЗавершена;
	
КонецПроцедуры


Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаВерсию2_1_12(Параметры) Экспорт
	
	ИмяРегистра       = "РасчетыСКлиентами";
	ПолноеИмяРегистра = "РегистрНакопления." + ИмяРегистра;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ 
	|	РеализацияТоваровУслуг.Ссылка КАК Ссылка,
	|	РеализацияТоваровУслуг.ТребуетсяЗалогЗаТару КАК ТребуетсяЗалогЗаТару,
	|	РеализацияТоваровУслуг.ВернутьМногооборотнуюТару КАК ВернутьМногооборотнуюТару
	|ПОМЕСТИТЬ ВТДокументы
	|ИЗ
	|	Документ.РеализацияТоваровУслуг КАК РеализацияТоваровУслуг
	|ГДЕ
	|	РеализацияТоваровУслуг.РеализацияПоЗаказам
	|	И НЕ РеализацияТоваровУслуг.ПорядокРасчетов = ЗНАЧЕНИЕ(Перечисление.ПорядокРасчетов.ПоНакладным)
	|	И РеализацияТоваровУслуг.ХозяйственнаяОперация В (
	|		ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.РеализацияКлиенту), 
	|		ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.РеализацияКлиентуРеглУчет), 
	|		ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.РеализацияБезПереходаПраваСобственности))
	|	И РеализацияТоваровУслуг.Проведен
	|	И &ИспользоватьРасширенныеВозможностиЗаказаКлиента
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ 
	|	ВложенныйЗапрос.Ссылка КАК Регистратор
	|ИЗ
	|	(ВЫБРАТЬ
	|		ДокументыДляОбработки.Ссылка                     КАК Ссылка,
	|		СУММА(ДокументыДляОбработки.ОтгружаетсяДокумент) КАК ОтгружаетсяДокумент,
	|		СУММА(ДокументыДляОбработки.ОтгружаетсяРегистр)  КАК ОтгружаетсяРегистр
	|	ИЗ
	|		(ВЫБРАТЬ 
	|			ТаблицаТовары.Ссылка                     КАК Ссылка,
	|			СУММА(ТаблицаТовары.СуммаВзаиморасчетов) КАК ОтгружаетсяДокумент,
	|			0                                        КАК ОтгружаетсяРегистр
	|		ИЗ
	|			Документ.РеализацияТоваровУслуг.Товары КАК ТаблицаТовары
	|				ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТДокументы КАК ВТДокументы 
	|					ПО ВТДокументы.Ссылка =  ТаблицаТовары.Ссылка
	|		ГДЕ
	|			(ТаблицаТовары.Номенклатура.ТипНоменклатуры <> ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара)
	|				ИЛИ ВТДокументы.ТребуетсяЗалогЗаТару
	|				ИЛИ НЕ ВТДокументы.ВернутьМногооборотнуюТару)
	|			И ТаблицаТовары.КодСтроки <> 0
	|		СГРУППИРОВАТЬ ПО 
	|			ТаблицаТовары.Ссылка
	|		
	|		ОБЪЕДИНИТЬ ВСЕ
	|		
	|		ВЫБРАТЬ
	|			РасчетыСКлиентами.Регистратор,
	|			0,
	|			СУММА(РасчетыСКлиентами.Отгружается)
	|		ИЗ
	|			РегистрНакопления.РасчетыСКлиентами КАК РасчетыСКлиентами
	|				ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТДокументы КАК ВТДокументы 
	|					ПО ВТДокументы.Ссылка =  РасчетыСКлиентами.Регистратор
	|		СГРУППИРОВАТЬ ПО
	|			РасчетыСКлиентами.Регистратор) КАК ДокументыДляОбработки
	|	СГРУППИРОВАТЬ ПО
	|		ДокументыДляОбработки.Ссылка) КАК ВложенныйЗапрос
	|ГДЕ
	|	ВложенныйЗапрос.ОтгружаетсяДокумент < ВложенныйЗапрос.ОтгружаетсяРегистр";
	
	Запрос.УстановитьПараметр("ИспользоватьРасширенныеВозможностиЗаказаКлиента", ПолучитьФункциональнуюОпцию("ИспользоватьРасширенныеВозможностиЗаказаКлиента"));
	Результат = Запрос.Выполнить();
	
	ОбновлениеИнформационнойБазы.ОтметитьРегистраторыКОбработке(Параметры, Результат.Выгрузить().ВыгрузитьКолонку("Регистратор"), ПолноеИмяРегистра);
	
КонецПроцедуры

//Обработчик обновления движений документа "Реализация товаров и услуг" по регистру РасчетыСКлиентами.
//Корректирует движения по ресурсу "Отгружается" для заказов со строками сверх заказа.
//
Процедура ОбработатьДанныеДляПереходаНаВерсию2_1_12(Параметры) Экспорт
	
	ПолноеИмяРегистра = "РегистрНакопления.РасчетыСКлиентами";
	ПолноеИмяОбъекта  = "Документ.РеализацияТоваровУслуг";
	
	МетаданныеДокумента = Метаданные.НайтиПоПолномуИмени(ПолноеИмяОбъекта);
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Результат = ОбновлениеИнформационнойБазы.СоздатьВременнуюТаблицуРегистраторовРегистраДляОбработки(Параметры.Очередь, ПолноеИмяОбъекта, ПолноеИмяРегистра, МенеджерВременныхТаблиц);
	
	Если НЕ Результат.ЕстьДанныеДляОбработки Тогда
		Параметры.ОбработкаЗавершена = Истина;
		Возврат;
	КонецЕсли;
	Если НЕ Результат.ЕстьЗаписиВоВременнойТаблице Тогда
		Параметры.ОбработкаЗавершена = Ложь;
		Возврат;
	КонецЕсли; 
	
	ТекстЗапроса = 
	"ВЫБРАТЬ 
	|	ОбъектыДляОбработки.Регистратор                             КАК Регистратор,
	|	ОбъектыДляОбработки.Регистратор.ВерсияДанных                КАК ВерсияДанных,
	|	ВЫБОР 
	|		КОГДА ОбъектыДляОбработки.Регистратор ССЫЛКА Документ.РеализацияТоваровУслуг 
	|			ТОГДА ВЫБОР 
	|					КОГДА ВЫРАЗИТЬ(ОбъектыДляОбработки.Регистратор КАК Документ.РеализацияТоваровУслуг).ПорядокРасчетов 
	|							= ЗНАЧЕНИЕ(Перечисление.ПорядокРасчетов.ПоДоговорамКонтрагентов)
	|						ТОГДА ИСТИНА
	|					ИНАЧЕ ЛОЖЬ
	|				КОНЕЦ
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ                                                       КАК РасчетыПоДоговору
	|ИЗ
	|	ВТОбъектыДляОбработки КАК ОбъектыДляОбработки
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|
	|ВЫБРАТЬ 
	|	ДанныеДокумента.Ссылка                     КАК Регистратор,
	|	ДанныеДокумента.ЗаказКлиента               КАК ЗаказКлиента,
	|	СУММА(ДанныеДокумента.СуммаВзаиморасчетов) КАК Отгружается
	|ИЗ 
	|	Документ.РеализацияТоваровУслуг.Товары КАК ДанныеДокумента
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТОбъектыДляОбработки КАК ОбъектыДляОбработки
	|			ПО ОбъектыДляОбработки.Регистратор = ДанныеДокумента.Ссылка
	|ГДЕ
	|	ДанныеДокумента.КодСтроки <> 0
	|СГРУППИРОВАТЬ ПО
	|	ДанныеДокумента.Ссылка,
	|	ДанныеДокумента.ЗаказКлиента";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ВТОбъектыДляОбработки", Результат.ИмяВременнойТаблицы);
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Результат = Запрос.ВыполнитьПакет();
	
	Выборка            = Результат[0].Выбрать();
	ТаблицаОтгружается = Результат[1].Выгрузить();
	ТаблицаОтгружается.Индексы.Добавить("Регистратор, ЗаказКлиента");
	
	ЭтоФайловаяИБ = ОбщегоНазначения.ИнформационнаяБазаФайловая();
	
	Пока Выборка.Следующий() Цикл
		
		НачатьТранзакцию();
		
		Попытка
			
			Если НЕ ЭтоФайловаяИБ И Выборка.ВерсияДанных <> Выборка.Регистратор.ВерсияДанных Тогда
				ОтменитьТранзакцию();
				Продолжить;
			КонецЕсли;
			
			Блокировка = Новый БлокировкаДанных;
			
			ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяРегистра + ".НаборЗаписей");
			ЭлементБлокировки.УстановитьЗначение("Регистратор", Выборка.Регистратор);
			Блокировка.Заблокировать();
			
			Набор = РегистрыНакопления.РасчетыСКлиентами.СоздатьНаборЗаписей();
			Набор.Отбор.Регистратор.Установить(Выборка.Регистратор);
			Набор.Прочитать();
			
			СтруктураПоиска = Новый Структура("Регистратор, ЗаказКлиента");
			
			сч = 0;
			Пока сч < Набор.Количество() Цикл
				Запись = Набор[сч];
				Если Запись.Отгружается <> 0 Тогда
					
					Если Выборка.РасчетыПоДоговору Тогда
						СтруктураПоиска.Регистратор  = Запись.Регистратор;
						СтруктураПоиска.ЗаказКлиента = Запись.ПродажаПоЗаказу;
					Иначе
						ЗаполнитьЗначенияСвойств(СтруктураПоиска, Запись);
					КонецЕсли;
					
					СтрокиОтгружается = ТаблицаОтгружается.НайтиСтроки(СтруктураПоиска);
					
					Если СтрокиОтгружается.Количество() = 0 Тогда
						Набор.Удалить(Запись);
						Продолжить;
					Иначе
						Если СтрокиОтгружается[0].Отгружается <> Запись.Отгружается Тогда
							 Запись.Отгружается = СтрокиОтгружается[0].Отгружается;
						КонецЕсли;
					КонецЕсли;
					
				КонецЕсли;
				сч = сч + 1;
			КонецЦикла;
			
			ОбновлениеИнформационнойБазы.ЗаписатьДанные(Набор);
			
			ЗафиксироватьТранзакцию();
		
		Исключение
		
			ОтменитьТранзакцию();
			
			ТекстСообщения = НСтр("ru='Не удалось обработать документ: %Ссылка% по причине: %Причина%';uk='Не вдалося обробити документ: %Ссылка% з причини: %Причина%'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Ссылка%", Выборка.Регистратор);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Причина%", ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Предупреждение,
				МетаданныеДокумента, Выборка.Регистратор, ТекстСообщения);
			ВызватьИсключение;
			
		КонецПопытки;
		
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, ПолноеИмяРегистра);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли