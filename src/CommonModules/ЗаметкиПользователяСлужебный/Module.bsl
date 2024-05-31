////////////////////////////////////////////////////////////////////////////////
// Подсистема "Заметки пользователя".
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// См. описание этой же процедуры в модуле СтандартныеПодсистемыСервер.
Процедура ПриДобавленииОбработчиковСлужебныхСобытий(КлиентскиеОбработчики, СерверныеОбработчики) Экспорт
	
	// СЕРВЕРНЫЕ ОБРАБОТЧИКИ.
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.НапоминанияПользователя") Тогда
		СерверныеОбработчики["СтандартныеПодсистемы.НапоминанияПользователя\ПриЗаполненииСпискаРеквизитовИсточникаСДатамиДляНапоминания"].Добавить(
			"ЗаметкиПользователяСлужебный");
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ТекущиеДела") Тогда
		СерверныеОбработчики["СтандартныеПодсистемы.ТекущиеДела\ПриЗаполненииСпискаТекущихДел"].Добавить(
			"ЗаметкиПользователяСлужебный");
	КонецЕсли;
	
КонецПроцедуры

// Определить объекты метаданных, в модулях менеджеров которых ограничивается возможность 
// редактирования реквизитов при групповом изменении.
//
// Параметры:
//   Объекты - Соответствие - в качестве ключа указать полное имя объекта метаданных,
//                            подключенного к подсистеме "Групповое изменение объектов". 
//                            Дополнительно в значении могут быть перечислены имена экспортных функций:
//                            "РеквизитыНеРедактируемыеВГрупповойОбработке",
//                            "РеквизитыРедактируемыеВГрупповойОбработке".
//                            Каждое имя должно начинаться с новой строки.
//                            Если указана пустая строка, значит в модуле менеджера определены обе функции.
//
Процедура ПриОпределенииОбъектовСРедактируемымиРеквизитами(Объекты) Экспорт
	Объекты.Вставить(Метаданные.Справочники.Заметки.ПолноеИмя(), "РеквизитыРедактируемыеВГрупповойОбработке");
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьСнятьПометкуУдаленияЗаметок(Источник, Отказ) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПометкаУдаления = Источник.ПометкаУдаления;
	Если Не ПометкаУдаления И Не Источник.ДополнительныеСвойства.Свойство("СнятаПометкаУдаления") Тогда
		Возврат;
	КонецЕсли;
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Заметки.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.Заметки КАК Заметки
	|ГДЕ
	|	Заметки.ПометкаУдаления = &ПометкаУдаления
	|	И &ПолеВладельца = &Владелец";
	
	ПолеВладельца = "Заметки.Предмет";
	Если ТипЗнч(Источник) = Тип("СправочникОбъект.Пользователи") 
		И (ПометкаУдаления Или Источник.ДополнительныеСвойства.Свойство("СнятаПометкаУдаления")) Тогда
			ПолеВладельца = "Заметки.Автор";
	КонецЕсли;
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ПолеВладельца", ПолеВладельца);
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Владелец", Источник.Ссылка);
	Запрос.УстановитьПараметр("ПометкаУдаления", Не ПометкаУдаления);
	
	УстановитьПривилегированныйРежим(Истина);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ЗаметкаОбъект = Выборка.Ссылка.ПолучитьОбъект();
		ЗаметкаОбъект.УстановитьПометкуУдаления(ПометкаУдаления, Ложь);
		ЗаметкаОбъект.ДополнительныеСвойства.Вставить("ПометкаУдаленияЗаметки", Истина);
		Попытка
			ЗаметкаОбъект.Записать();
		Исключение
			ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			ЗаписьЖурналаРегистрации(НСтр("ru='Заметки пользователя.Изменение пометки удаления';uk='Нотатки користувача.Зміна позначки вилучення'",ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
				УровеньЖурналаРегистрации.Ошибка, ЗаметкаОбъект.Метаданные(), ЗаметкаОбъект.Ссылка, ТекстОшибки);
		КонецПопытки;
	КонецЦикла;
	
КонецПроцедуры

// Добавляет признак изменения пометки удаления объекта.
Процедура УстановитьСтатусИзмененияПометкиУдаления(Источник) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Источник.ПометкаУдаления Тогда
		ПометкаУдаленияПоСсылке = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Источник.Ссылка, "ПометкаУдаления");
		Если ПометкаУдаленияПоСсылке = Истина Тогда
			Источник.ДополнительныеСвойства.Вставить("СнятаПометкаУдаления");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Заполняет список текущих дел пользователя.
//
// Параметры:
//  ТекущиеДела - ТаблицаЗначений - таблица значений с колонками:
//    * Идентификатор - Строка - внутренний идентификатор дела, используемый механизмом "Текущие дела".
//    * ЕстьДела      - Булево - если Истина, дело выводится в списке текущих дел пользователя.
//    * Важное        - Булево - если Истина, дело будет выделено красным цветом.
//    * Представление - Строка - представление дела, выводимое пользователю.
//    * Количество    - Число  - количественный показатель дела, выводится в строке заголовка дела.
//    * Форма         - Строка - полный путь к форме, которую необходимо открыть при нажатии на гиперссылку
//                               дела на панели "Текущие дела".
//    * ПараметрыФормы- Структура - параметры, с которыми нужно открывать форму показателя.
//    * Владелец      - Строка, объект метаданных - строковый идентификатор дела, которое будет владельцем для текущего
//                      или объект метаданных подсистема.
//    * Подсказка     - Строка - текст подсказки.
//
Процедура ПриЗаполненииСпискаТекущихДел(ТекущиеДела) Экспорт
	
	МодульТекущиеДелаСервер = ОбщегоНазначения.ОбщийМодуль("ТекущиеДелаСервер");
	Если Не ПравоДоступа("Редактирование", Метаданные.Справочники.Заметки)
		Или Не ПолучитьФункциональнуюОпцию("ИспользоватьЗаметки")
		Или МодульТекущиеДелаСервер.ДелоОтключено("ЗаметкиПользователя") Тогда
		Возврат;
	КонецЕсли;
	
	// Процедура вызывается только при наличии подсистемы "Текущие дела", поэтому здесь
	// не делается проверка существования подсистемы.
	Разделы = МодульТекущиеДелаСервер.РазделыДляОбъекта(Метаданные.Справочники.Заметки.ПолноеИмя());
	
	КоличествоЗаметок = КоличествоЗаметок();
	
	Для Каждого Раздел Из Разделы Цикл
		ИдентификаторЗаметки = "ЗаметкиПользователя" + СтрЗаменить(Раздел.ПолноеИмя(), ".", "");
		Дело = ТекущиеДела.Добавить();
		Дело.Идентификатор = ИдентификаторЗаметки;
		Дело.ЕстьДела      = КоличествоЗаметок > 0;
		Дело.Представление = НСтр("ru='Мои заметки';uk='Мої нотатки'");
		Дело.Количество    = КоличествоЗаметок;
		Дело.Форма         = "Справочник.Заметки.Форма.ВсеЗаметки";
		Дело.Владелец      = Раздел;
	КонецЦикла;
	
КонецПроцедуры

// Переопределяет массив реквизитов объекта, относительно которых разрешается устанавливать время напоминания.
// Например, можно скрыть те реквизиты с датами, которые являются служебными или не имеют смысла для 
// установки напоминаний: дата документа или задачи и прочие.
// 
// Параметры:
//  Источник	 - Любая ссылка - Ссылка на объект, для которого формируется массив реквизитов с датами.
//  МассивРеквизитов - Массив - Массив имен реквизитов (из метаданных), содержащих даты.
//
Процедура ПриЗаполненииСпискаРеквизитовИсточникаСДатамиДляНапоминания(Источник, МассивРеквизитов) Экспорт
	
	Если ТипЗнч(Источник) = Тип("СправочникСсылка.Заметки") Тогда
		МассивРеквизитов.Очистить();
	КонецЕсли;
	
КонецПроцедуры

Функция КоличествоЗаметок()
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КОЛИЧЕСТВО(СправочникЗаметки.Ссылка) КАК Количество
	|ИЗ
	|	Справочник.Заметки КАК СправочникЗаметки
	|ГДЕ
	|	СправочникЗаметки.Автор = &Пользователь
	|		И НЕ СправочникЗаметки.ПометкаУдаления";
	
	Запрос.УстановитьПараметр("Пользователь", Пользователи.ТекущийПользователь());
	
	РезультатЗапроса = Запрос.Выполнить().Выгрузить();
	Возврат РезультатЗапроса[0].Количество;
	
КонецФункции

#КонецОбласти
