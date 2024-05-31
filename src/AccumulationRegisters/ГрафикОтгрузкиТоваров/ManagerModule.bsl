#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Текст запроса сторно записей заказа. Получаемый текст запроса содержит параметры:
//  Ссылка - Документ, сторно записи коотрого необходимо получить, Отбор - условие отбора номенлкатуры.
//
// Возвращаемое значение - Строка - Текст запроса сторно записей.
//
Функция ТекстЗапросаСторноЗаписейЗаказа() Экспорт

	Текст =
		"ВЫБРАТЬ
		|	Таблица.Номенклатура     КАК Номенклатура,
		|	Таблица.Характеристика   КАК Характеристика,
		|	Таблица.Склад            КАК Склад,
		|	Таблица.Назначение       КАК Назначение,
		|
		|	Таблица.ДатаСобытия          КАК ДатаСобытия,
		|	-Таблица.КоличествоИзЗаказов КАК КоличествоИзЗаказов,
		|	-Таблица.КоличествоПодЗаказ  КАК КоличествоПодЗаказ
		|
		|ИЗ
		|	РегистрНакопления.ГрафикПоступленияТоваров КАК Таблица
		|
		|ГДЕ
		|	Таблица.Активность
		|	И Таблица.Регистратор В(&Ссылка)
		|	И &Отбор
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	Таблица.Номенклатура     КАК Номенклатура,
		|	Таблица.Характеристика   КАК Характеристика,
		|	Таблица.Склад            КАК Склад,
		|	Таблица.Назначение       КАК Назначение,
		|
		|	Таблица.ДатаОтгрузки         КАК ДатаСобытия,
		|	Таблица.КоличествоИзЗаказов  КАК КоличествоИзЗаказов,
		|	0                            КАК КоличествоПодЗаказ
		|
		|ИЗ
		|	РегистрНакопления.ГрафикОтгрузкиТоваров КАК Таблица
		|
		|ГДЕ
		|	Таблица.Активность
		|	И Таблица.Регистратор В(&Ссылка)
		|	И &Отбор
		|;
		|
		|//////////////////////////////////////////////////
		|";

	Возврат Текст;

КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбновлениеИнформационнойБазы


Процедура ИсправитьДвижения_ДанныеДляОбновления(Параметры) Экспорт
	
	ИмяРегистра = "ГрафикОтгрузкиТоваров";
	ПолноеИмяРегистра = "РегистрНакопления." + ИмяРегистра;
	
#Область ЗаказКлиента
	ПолноеИмяДокумента = "Документ.ЗаказКлиента";
	ТекстЗапросаАдаптированный = Документы.ЗаказКлиента.АдаптированныйТекстЗапросаДвиженийПоРегистру(ИмяРегистра);
	Регистраторы = ОбновлениеИнформационнойБазыУТ.РегистраторыДляПерепроведения(
		ТекстЗапросаАдаптированный, ПолноеИмяРегистра, ПолноеИмяДокумента);
	
	ОбновлениеИнформационнойБазы.ОтметитьРегистраторыКОбработке(Параметры, Регистраторы, ПолноеИмяРегистра);
	Документы.ЗаказКлиента.ИсправлениеДвиженийГрафикОтгрузкиТоваровЗарегистрироватьДанныеДляКОбработке(Параметры);
#КонецОбласти
	
#Область ЗаявкаНаВозвратТоваровОтКлиента
	ПолноеИмяДокумента = "Документ.ЗаявкаНаВозвратТоваровОтКлиента";
	ТекстЗапросаАдаптированный = Документы.ЗаявкаНаВозвратТоваровОтКлиента.АдаптированныйТекстЗапросаДвиженийПоРегистру(ИмяРегистра);
	Регистраторы = ОбновлениеИнформационнойБазыУТ.РегистраторыДляПерепроведения(
		ТекстЗапросаАдаптированный, ПолноеИмяРегистра, ПолноеИмяДокумента);
	
	ОбновлениеИнформационнойБазы.ОтметитьРегистраторыКОбработке(Параметры, Регистраторы, ПолноеИмяРегистра);
	Документы.ЗаявкаНаВозвратТоваровОтКлиента.ИсправлениеДвиженийГрафикОтгрузкиТоваровЗарегистрироватьДанныеДляКОбработке(Параметры);
#КонецОбласти
	
#Область ЗаказНаВнутреннееПотребление
	ПолноеИмяДокумента = "Документ.ЗаказНаВнутреннееПотребление";
	ТекстЗапросаАдаптированный = Документы.ЗаказНаВнутреннееПотребление.АдаптированныйТекстЗапросаДвиженийПоРегистру(ИмяРегистра);
	Регистраторы = ОбновлениеИнформационнойБазыУТ.РегистраторыДляПерепроведения(
		ТекстЗапросаАдаптированный, ПолноеИмяРегистра, ПолноеИмяДокумента);
	
	ОбновлениеИнформационнойБазы.ОтметитьРегистраторыКОбработке(Параметры, Регистраторы, ПолноеИмяРегистра);
#КонецОбласти
	
#Область ЗаказНаПеремещение
	ПолноеИмяДокумента = "Документ.ЗаказНаПеремещение";
	ТекстЗапросаАдаптированный = Документы.ЗаказНаПеремещение.АдаптированныйТекстЗапросаДвиженийПоРегистру(ИмяРегистра);
	Регистраторы = ОбновлениеИнформационнойБазыУТ.РегистраторыДляПерепроведения(
		ТекстЗапросаАдаптированный, ПолноеИмяРегистра, ПолноеИмяДокумента);
	
	ОбновлениеИнформационнойБазы.ОтметитьРегистраторыКОбработке(Параметры, Регистраторы, ПолноеИмяРегистра);
#КонецОбласти
	
#Область ЗаказНаСборку
	ПолноеИмяДокумента = "Документ.ЗаказНаСборку";
	ТекстЗапросаАдаптированный = Документы.ЗаказНаСборку.АдаптированныйТекстЗапросаДвиженийПоРегистру(ИмяРегистра);
	Регистраторы = ОбновлениеИнформационнойБазыУТ.РегистраторыДляПерепроведения(
		ТекстЗапросаАдаптированный, ПолноеИмяРегистра, ПолноеИмяДокумента);
	
	ОбновлениеИнформационнойБазы.ОтметитьРегистраторыКОбработке(Параметры, Регистраторы, ПолноеИмяРегистра);
	
	Регистраторы = Документы.ЗаказНаСборку.ЗаказыНаРазборкуКоторыеНужноРазбитьПередЗаполнениемСерий();
	ОбновлениеИнформационнойБазы.ОтметитьРегистраторыКОбработке(Параметры, Регистраторы, ПолноеИмяРегистра);
	
	Регистраторы = Документы.ЗаказНаСборку.РазборкиКоторыеНужноРазбитьПоВариантуОбеспечения();
	ОбновлениеИнформационнойБазы.ОтметитьРегистраторыКОбработке(Параметры, Регистраторы, ПолноеИмяРегистра);
#КонецОбласти
	
КонецПроцедуры

// Обработчик обновления BAS УТ 3.2.3
// Производит замену измерения "АналитикаУчетаПоПартнерам" с учетом договора.
Процедура ИсправитьДвижения(Параметры) Экспорт
	
	Регистраторы = Новый Массив;
	Регистраторы.Добавить("Документ.ЗаказКлиента");
	Регистраторы.Добавить("Документ.ЗаказНаВнутреннееПотребление");
	Регистраторы.Добавить("Документ.ЗаявкаНаВозвратТоваровОтКлиента");
	Регистраторы.Добавить("Документ.ЗаказНаСборку");
	Регистраторы.Добавить("Документ.ЗаказНаПеремещение");
	
	ОбработкаЗавершена = ОбновлениеИнформационнойБазыУТ.ПерезаписатьДвиженияИзОчереди(
		Регистраторы, 
        "РегистрНакопления.ГрафикОтгрузкиТоваров", 
        Параметры.Очередь
    );
	
	Параметры.ОбработкаЗавершена = ОбработкаЗавершена;
	
КонецПроцедуры



#КонецОбласти

#КонецОбласти

#КонецЕсли
