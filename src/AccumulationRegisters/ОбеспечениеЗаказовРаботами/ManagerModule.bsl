#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ТекстЗапросаСторноЗаписейЗаказа() Экспорт

	Текст =
		"ВЫБРАТЬ
		|	Таблица.Номенклатура     КАК Номенклатура,
		|	Таблица.Характеристика   КАК Характеристика,
		|	Таблица.Подразделение    КАК Подразделение,
		|	Таблица.Назначение       КАК Назначение,
		|
		|	Таблица.Период           КАК Период,
		|
		|	ВЫБОР КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) ТОГДА
		|				Таблица.КОбеспечению
		|			ИНАЧЕ
		|				- Таблица.КОбеспечению
		|		КОНЕЦ          КАК КОбеспечению
		|
		|ИЗ
		|	РегистрНакопления.ОбеспечениеЗаказовРаботами КАК Таблица
		|
		|ГДЕ
		|	Таблица.Активность
		|	И Таблица.Регистратор В(&Ссылка)
		|	И Таблица.КОбеспечению <> 0
		|	И &Отбор
		|;
		|
		|//////////////////////////////////////////////////
		|";

	Возврат Текст;

КонецФункции

Функция ТекстЗапросаОстатков(ИспользоватьКорректировку, Разделы = Неопределено) Экспорт

	Если Не ИспользоватьКорректировку Тогда

		ТекстЗапроса =
			"ВЫБРАТЬ
			|	Т.Номенклатура              КАК Номенклатура,
			|	Т.Характеристика            КАК Характеристика,
			|	Т.Подразделение             КАК Подразделение,
			|	Т.Назначение                КАК Назначение,
			|	Т.КОбеспечениюРасход        КАК Количество
			|ПОМЕСТИТЬ ВтОстаткиРабот
			|ИЗ
			|	РегистрНакопления.ОбеспечениеЗаказовРаботами.Обороты(,,,
			|		(Номенклатура, Характеристика, Подразделение, Назначение) В
			|			(ВЫБРАТЬ
			|				Т.Номенклатура    КАК Номенклатура,
			|				Т.Характеристика  КАК Характеристика,
			|				Т.Подразделение   КАК Подразделение,
			|				Т.Назначение      КАК Назначение
			|			ИЗ
			|				ВтРаботы КАК Т
			|		)) КАК Т
			|ИНДЕКСИРОВАТЬ ПО
			|	Номенклатура, Характеристика, Подразделение, Назначение
			|;
			|
			|///////////////////////////////////////////////////
			|";

	Иначе

		ТекстЗапроса =
			"ВЫБРАТЬ
			|	НаборДанных.Номенклатура      КАК Номенклатура,
			|	НаборДанных.Характеристика    КАК Характеристика,
			|	НаборДанных.Подразделение     КАК Подразделение,
			|	НаборДанных.Назначение        КАК Назначение,
			|	СУММА(НаборДанных.Количество) КАК Количество
			|ПОМЕСТИТЬ ВтОстаткиРабот
			|ИЗ
			|	(ВЫБРАТЬ
			|		Т.Номенклатура              КАК Номенклатура,
			|		Т.Характеристика            КАК Характеристика,
			|		Т.Подразделение             КАК Подразделение,
			|		Т.Назначение                КАК Назначение,
			|		Т.КОбеспечениюРасход        КАК Количество
			|	ИЗ
			|		РегистрНакопления.ОбеспечениеЗаказовРаботами.Обороты(,,,
			|			(Номенклатура, Характеристика, Подразделение, Назначение) В
			|				(ВЫБРАТЬ
			|					Т.Номенклатура    КАК Номенклатура,
			|					Т.Характеристика  КАК Характеристика,
			|					Т.Подразделение   КАК Подразделение,
			|					Т.Назначение      КАК Назначение
			|				ИЗ
			|					ВтРаботы КАК Т
			|
			|		)) КАК Т
			|
			|	ОБЪЕДИНИТЬ ВСЕ
			|
			|	ВЫБРАТЬ
			|		Т.Номенклатура          КАК Номенклатура,
			|		Т.Характеристика        КАК Характеристика,
			|		Т.Подразделение         КАК Подразделение,
			|		Т.Назначение            КАК Назначение,
			|		- Т.КОбеспечению        КАК Количество
			|	ИЗ
			|		ВтОбеспечениеЗаказовРаботамиКорректировка КАК Т
			|	) КАК НаборДанных
			|
			|СГРУППИРОВАТЬ ПО
			|	НаборДанных.Номенклатура, НаборДанных.Характеристика, НаборДанных.Подразделение, НаборДанных.Назначение
			|ИМЕЮЩИЕ
			|	СУММА(НаборДанных.Количество) <> 0
			|ИНДЕКСИРОВАТЬ ПО
			|	Номенклатура, Характеристика, Подразделение, Назначение
			|;
			|
			|///////////////////////////////////////////////////
			|";

	КонецЕсли;

	Если Разделы <> Неопределено Тогда
		Разделы.Добавить("ТаблицаОстаткиРабот");
	КонецЕсли;

	Возврат ТекстЗапроса;

КонецФункции

Функция ТекстЗапросаОстатковИОборотов(ИспользоватьКорректировку, Разделы = Неопределено) Экспорт
	
	ТекстЗапроса = ТекстЗапросаОстатков(ИспользоватьКорректировку, Разделы)
		+ ТекстЗапросаОборотов(ИспользоватьКорректировку, Разделы)
		+ "ВЫБРАТЬ
		|	Т.Номенклатура                                КАК Номенклатура,
		|	Т.Характеристика                              КАК Характеристика,
		|	Т.Назначение                                  КАК Назначение,
		|	Т.Подразделение                               КАК Подразделение,
		|	ЕСТЬNULL(ОборотыГрафика.Период,
		|		ДАТАВРЕМЯ(1,1,1))                         КАК Период,
		|	ЕСТЬNULL(ОборотыГрафика.Количество,0)         КАК Оборот,
		|	ЕСТЬNULL(ОстаткиГрафика.Количество,0)         КАК Остаток
		|ИЗ
		|	ВтРаботы КАК Т
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВтОстаткиРабот КАК ОстаткиГрафика
		|		ПО Т.Номенклатура   = ОстаткиГрафика.Номенклатура
		|		 И Т.Характеристика = ОстаткиГрафика.Характеристика
		|		 И Т.Подразделение  = ОстаткиГрафика.Подразделение
		|		 И Т.Назначение     = ОстаткиГрафика.Назначение
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВтОборотыРабот КАК ОборотыГрафика
		|		ПО Т.Номенклатура   = ОборотыГрафика.Номенклатура
		|		 И Т.Характеристика = ОборотыГрафика.Характеристика
		|		 И Т.Подразделение  = ОборотыГрафика.Подразделение
		|		 И Т.Назначение     = ОборотыГрафика.Назначение
		|УПОРЯДОЧИТЬ ПО
		|	Номенклатура, Характеристика, Подразделение, Назначение,
		|	Период Убыв
		|;
		|
		|/////////////////////////////////////////////////////
		|";

	Если Разделы <> Неопределено Тогда
		Разделы.Добавить("ТаблицаОстаткиИОборотыРабот");
	КонецЕсли;

	Возврат ТекстЗапроса;

КонецФункции

// Возвращает текст запроса для выборки заказов, содержащих отобранную номенклатуру.
//
// Возвращаемое значение
//  Строка - Текст запроса.
//
Функция ТекстЗапросаЗаказовНоменклатуры() Экспорт

	ТекстЗапроса =
		"ВЫБРАТЬ
		|	Т.Регистратор КАК Заказ
		|ИЗ
		|	РегистрНакопления.ОбеспечениеЗаказовРаботами КАК Т
		|ГДЕ
		|	(Т.Назначение, Т.Номенклатура, Т.Характеристика, Т.Подразделение) В(
		|		ВЫБРАТЬ
		|			Т.Назначение     КАК Назначение,
		|			Т.Номенклатура   КАК Номенклатура,
		|			Т.Характеристика КАК Характеристика,
		|			Т.Подразделение  КАК Подразделение
		|		ИЗ
		|			РегистрНакопления.ОбеспечениеЗаказовРаботами.Остатки(, {Номенклатура.* КАК Номенклатура}) КАК Т)
		|	И Т.КОбеспечению > 0
		|{ГДЕ
		|	Номенклатура.* КАК Номенклатура}";

	Возврат ТекстЗапроса;

КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ТекстЗапросаОборотов(ИспользоватьКорректировку, Разделы = Неопределено)

	Если Не ИспользоватьКорректировку Тогда
		
		ТекстЗапроса =
			"ВЫБРАТЬ
			|	НаборДанных.Номенклатура      КАК Номенклатура,
			|	НаборДанных.Характеристика    КАК Характеристика,
			|	НаборДанных.Подразделение     КАК Подразделение,
			|	НаборДанных.Назначение        КАК Назначение,
			|
			|	НаборДанных.Период            КАК Период,
			|	СУММА(НаборДанных.Количество) КАК Количество
			|ПОМЕСТИТЬ ВтОборотыРабот
			|ИЗ
			|	(ВЫБРАТЬ
			|		Т.Номенклатура        КАК Номенклатура,
			|		Т.Характеристика      КАК Характеристика,
			|		Т.Подразделение       КАК Подразделение,
			|		Т.Назначение          КАК Назначение,
			|
			|		ВЫБОР КОГДА Т.Период <= &НачалоТекущегоДня ТОГДА
			|					&НачалоТекущегоДня
			|				ИНАЧЕ
			|					НАЧАЛОПЕРИОДА(Т.Период, ДЕНЬ)
			|			КОНЕЦ             КАК Период,
			|		
			|		Т.КОбеспечению        КАК Количество
			|	ИЗ
			|		РегистрНакопления.ОбеспечениеЗаказовРаботами КАК Т
			|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВтРаботы КАК Работы
			|			ПО Т.Номенклатура   = Работы.Номенклатура
			|			 И Т.Характеристика = Работы.Характеристика
			|			 И Т.Подразделение  = Работы.Подразделение
			|			 И Т.Назначение     = Работы.Назначение
			|	ГДЕ
			|		Т.Активность
			|		И Т.КОбеспечению <> 0
			|		И Т.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
			|
			|	) КАК НаборДанных
			|
			|СГРУППИРОВАТЬ ПО
			|	НаборДанных.Номенклатура, НаборДанных.Характеристика, НаборДанных.Подразделение, НаборДанных.Назначение,
			|	НаборДанных.Период
			|ИМЕЮЩИЕ
			|	СУММА(НаборДанных.Количество) <> 0
			|ИНДЕКСИРОВАТЬ ПО
			|	Номенклатура, Характеристика, Подразделение, Назначение,
			|	Период
			|;
			|
			|///////////////////////////////////////////////////
			|";
		
	Иначе
		ТекстЗапроса =
			"ВЫБРАТЬ
			|	НаборДанных.Номенклатура      КАК Номенклатура,
			|	НаборДанных.Характеристика    КАК Характеристика,
			|	НаборДанных.Подразделение     КАК Подразделение,
			|	НаборДанных.Назначение        КАК Назначение,
			|
			|	НаборДанных.Период            КАК Период,
			|	СУММА(НаборДанных.Количество) КАК Количество
			|ПОМЕСТИТЬ ВтОборотыРабот
			|ИЗ
			|	(ВЫБРАТЬ
			|		Т.Номенклатура        КАК Номенклатура,
			|		Т.Характеристика      КАК Характеристика,
			|		Т.Подразделение       КАК Подразделение,
			|		Т.Назначение          КАК Назначение,
			|
			|		ВЫБОР КОГДА Т.Период <= &НачалоТекущегоДня ТОГДА
			|					&НачалоТекущегоДня
			|				ИНАЧЕ
			|					НАЧАЛОПЕРИОДА(Т.Период, ДЕНЬ)
			|			КОНЕЦ             КАК Период,
			|		
			|		Т.КОбеспечению        КАК Количество
			|	ИЗ
			|		РегистрНакопления.ОбеспечениеЗаказовРаботами КАК Т
			|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВтРаботы КАК Работы
			|			ПО Т.Номенклатура   = Работы.Номенклатура
			|			 И Т.Характеристика = Работы.Характеристика
			|			 И Т.Подразделение  = Работы.Подразделение
			|			 И Т.Назначение     = Работы.Назначение
			|	ГДЕ
			|		Т.Активность
			|		И Т.КОбеспечению <> 0
			|		И Т.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
			|
			|	ОБЪЕДИНИТЬ ВСЕ
			|
			|	ВЫБРАТЬ
			|		Т.Номенклатура          КАК Номенклатура,
			|		Т.Характеристика        КАК Характеристика,
			|		Т.Подразделение         КАК Подразделение,
			|		Т.Назначение            КАК Назначение,
			|
			|		ВЫБОР КОГДА Т.Период <= &НачалоТекущегоДня ТОГДА
			|				&НачалоТекущегоДня
			|			ИНАЧЕ Т.Период
			|		КОНЕЦ                   КАК Период,
			|		- Т.КОбеспечению        КАК Количество
			|	ИЗ
			|		ВтОбеспечениеЗаказовРаботамиКорректировка КАК Т
			|	) КАК НаборДанных
			|
			|СГРУППИРОВАТЬ ПО
			|	НаборДанных.Номенклатура, НаборДанных.Характеристика, НаборДанных.Подразделение, НаборДанных.Назначение,
			|	НаборДанных.Период
			|ИМЕЮЩИЕ
			|	СУММА(НаборДанных.Количество) <> 0
			|ИНДЕКСИРОВАТЬ ПО
			|	Номенклатура, Характеристика, Подразделение, Назначение,
			|	Период
			|;
			|
			|///////////////////////////////////////////////////
			|";
	
	КонецЕсли;
	
	Если Разделы <> Неопределено Тогда
		Разделы.Добавить("ТаблицаОборотыРабот");
	КонецЕсли;

	Возврат ТекстЗапроса;

КонецФункции

#Область ОбновлениеИнформационнойБазы


Процедура ИсправитьДвижения_ДанныеДляОбновления(Параметры) Экспорт 
	
	ПолноеИмяРегистра = "РегистрНакопления.ОбеспечениеЗаказовРаботами";

#Область ЗаказКлиента
	Документы.ЗаказКлиента.ИсправлениеДвиженийОбеспечениеЗаказовРаботамиЗарегистрироватьДанныеДляКОбработке(Параметры);
#КонецОбласти
	
#Область ЗаявкаНаВозвратТоваровОтКлиента
	ТекстЗапроса =
	"//Отклоненные заявки на возврат
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ЗаявкаНаВозврат.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.ЗаявкаНаВозвратТоваровОтКлиента КАК ЗаявкаНаВозврат
	|		
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ОбеспечениеЗаказовРаботами КАК Регистр
	|		ПО ЗаявкаНаВозврат.Ссылка = Регистр.Регистратор
	|ГДЕ
	|	ЗаявкаНаВозврат.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыЗаявокНаВозвратТоваровОтКлиентов.Отклонена)
	|	И НЕ Регистр.Регистратор ЕСТЬ NULL";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Регистраторы = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	ОбновлениеИнформационнойБазы.ОтметитьРегистраторыКОбработке(Параметры, Регистраторы, ПолноеИмяРегистра);
    
	Документы.ЗаявкаНаВозвратТоваровОтКлиента.ИсправлениеДвиженийОбеспечениеЗаказовРаботамиЗарегистрироватьДанныеДляКОбработке(Параметры);
#КонецОбласти

КонецПроцедуры

Процедура ИсправитьДвижения(Параметры) Экспорт
	
	Регистраторы = Новый Массив;
	
	Регистраторы.Добавить("Документ.ЗаказКлиента");
	Регистраторы.Добавить("Документ.ЗаявкаНаВозвратТоваровОтКлиента");

	Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазыУТ.ПерезаписатьДвиженияИзОчереди(
        Регистраторы,
		"РегистрНакопления.ОбеспечениеЗаказовРаботами",
		Параметры.Очередь
    );
    
КонецПроцедуры




#КонецОбласти

#КонецОбласти

#КонецЕсли