////////////////////////////////////////////////////////////////////////////////
// Клиентские процедуры работы с механизмами обеспечения
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область Обеспечение

// Отбражает вопрос о необходимости отгружать заказ одной датой или частями.
// Вызывает процедуру переноса данных в форму документа.
// Используется при переносе в документ строк с учетом дат отгрузки.
//  Параметры:
//   Форма - Форма в которой будет отображен вопрос и в обработку оповещения которой будет передан результат ответа.
//   ЗначенияРеквизитов - Структура - Cодержит значения реквизитов объекта, редактируемого в форме.
//                                    Содержит поля:
//                                                   ДатаОтгрузки - Дата - Дата отгрузки, заданная для документа в целом.
//                                                   НеОтгружатьЧастями - Булево - Признак, что заказ отгружается целиком, установленной датой отгрузки.
//                                                   ЖелаемаяДатаОтгрузки - Дата - Желаемая дата отгрузки, заданная для документа в целом
//                                                                                 (оговаривается с получателем товара, клиентом).
//                                    Вопрос будет задан, только если НеОтгружатьЧастями = Истина.
//   ДополнительныеПараметры - Структура - Структура для обработки оповещением после ответа пользователем на вопрос.
//                                         Обязательное поле в структуре:
//                                                                        МаксимальнаяДатаОтгрузки - Дата - максимальная дата отгрузки в строках
//                                                                                                          которые необходимо перенести в документ.
//                                         Структура также содержит данные строк в производльном форма, которые будут перенесены в документ в обработку оповещения.
//   ИмяПроцедурыОповещения - Строка - Имя экспортной процедуры формы в которой производится обработка оповещения после ответа на вопрос.
//
Процедура ПоказатьВопросОбОтгрузкеОднойДатой(Форма, ЗначенияРеквизитов, ДополнительныеПараметры, ИмяПроцедурыОповещения) Экспорт
	
	НачалоДня = НачалоДня(ОбщегоНазначенияКлиент.ДатаСеанса());
	СтараяДатаОтгрузки = ЗначенияРеквизитов.ДатаОтгрузки;
	НоваяДатаОтгрузки = Макс(
		ДополнительныеПараметры.МаксимальнаяДатаОтгрузки,
		ЗначенияРеквизитов.ЖелаемаяДатаОтгрузки,
		НачалоДня);
		
	ОписаниеОповещения = Новый ОписаниеОповещения(ИмяПроцедурыОповещения, Форма, ДополнительныеПараметры);
	ЗадатьВопрос = ЗначенияРеквизитов.НеОтгружатьЧастями И НоваяДатаОтгрузки > СтараяДатаОтгрузки;
	Если ЗадатьВопрос И ЗначениеЗаполнено(СтараяДатаОтгрузки) Тогда
		
		Если ИмяПроцедурыОповещения = "ЗаполнитьВариантОбеспеченияПослеВопроса" Тогда
			ШаблонТекстаВопроса = НСтр("ru='Дата отгрузки текущей строки %1, дата отгрузки остальных строк %2.
                                            |Можно отгрузить все одной датой %1, можно отгружать частями.'
                                            |;uk='Дата відвантаження поточного рядку %1, дата відвантаження інших рядків %2.
                                            |Можна відвантажити все однією датою %1, можна відвантажувати частинами.'");
		Иначе
			ШаблонТекстаВопроса = НСтр("ru='Дата отгрузки подобранных строк %1, дата отгрузки остальных строк %2.
                                            |Можно отгрузить все одной датой %1, можно отгружать частями.'
                                            |;uk='Дата відвантаження підібраних рядків %1, дата відвантаження інших рядків %2.
                                            |Можна відвантажити все однією датою %1, можна відвантажувати частинами.'");
		КонецЕсли;
		СтараяДатаОтгрузкиСтрокой = Формат(СтараяДатаОтгрузки, "ДЛФ=D");
		НоваяДатаОтгрузкиСтрокой = Формат(НоваяДатаОтгрузки, "ДЛФ=D");
		ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ШаблонТекстаВопроса,
			НоваяДатаОтгрузкиСтрокой,
			СтараяДатаОтгрузкиСтрокой);
		
		СписокКнопок = Новый СписокЗначений();
		ШаблонКнопки = НСтр("ru='Отгрузить одной датой (%1)';uk='Відвантажити однією датою (%1)'");
		ТекстКнопки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонКнопки, НоваяДатаОтгрузкиСтрокой);
		СписокКнопок.Добавить(КодВозвратаДиалога.Нет, ТекстКнопки);
		СписокКнопок.Добавить(КодВозвратаДиалога.Да, НСтр("ru='Отгружать частями';uk='Відвантажувати частинами'"));
		
		ЗаголовокВопроса = НСтр("ru='Вопрос';uk='Питання'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, СписокКнопок,,, ЗаголовокВопроса);
		
	Иначе
		
		ВыполнитьОбработкуОповещения(ОписаниеОповещения);
		
	КонецЕсли;
	
КонецПроцедуры

// Открывает форму обработки "Состояние обеспечения заказов" для выделенных заказов в форме списка
//
// Параметры:
//  ПолеСписка - ТаблицаФормы - таблица содержащая список заказов.
//  Форма - Управляемая форма - форма, в которой расположена таблица.
//
Процедура ОткрытьФормуСостояниеОбеспечения(ПолеСписка, Форма) Экспорт

	Если ПолеСписка = Неопределено Тогда

		ТекстПредупреждения = НСтр("ru='Команда не может быть выполнена для указанного объекта!';uk='Команда не може бути виконана для зазначеного об''єкта!'");
		ПоказатьПредупреждение(, ТекстПредупреждения);
		Возврат;

	КонецЕсли;

	Заказы = Новый СписокЗначений();

	Для Каждого Заказ Из ПолеСписка.ВыделенныеСтроки Цикл
	
		Если ТипЗнч(Заказ) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
			Продолжить;
		КонецЕсли;

		Заказы.Добавить(ПолеСписка.ДанныеСтроки(Заказ).Ссылка);

	КонецЦикла;

	ПараметрыФормы = Новый Структура("Заказы", Заказы);
	ОткрытьФорму("Обработка.СостояниеОбеспечения.Форма", ПараметрыФормы, Форма, Форма.УникальныйИдентификатор);

КонецПроцедуры

// Проверяет возможность выполнения команды "Состояние обеспечения" в документе (наличие строк в списке товаров)
// и сообщает, если команду выполнить невозможно.
//
// Параметры:
//  Форма          - УправляемаяФорма     - форма, содержащая список товаров.
//  Поле           - Строка               - Путь к реквизиту формы - списку товаров.
//  ТекстСообщения - Строка, Неопределено - переопределенный текст сообщения о невозможности выполнения команды.
// Возвращаемое значение:
//  - Булево - Истина - проверка выполнена успешно, Ложь - в противном случае.
//
Функция ПроверитьВозможностьВыполненияКомандыСостояниеОбеспеченияВДокументе(Форма, Поле = "Товары", Знач ТекстПредупреждения = Неопределено) Экспорт
	
	Коллекция = Форма.Объект[Поле];
	ПроверкаУспешна = Коллекция.Количество() > 0;
	Если Не ПроверкаУспешна Тогда
		
		Если ТекстПредупреждения = Неопределено Тогда
			
			ТекстПредупреждения = НСтр("ru='Не введено ни одной строки в список ""Товары"".
                |Просмотр состояния обеспечения списка товаров невозможен.'
                |;uk='Не введено жодного рядка в список ""Товари"".
                |Перегляд стану забезпечення списку товарів неможливий.'")
			
		КонецЕсли;
		ПоказатьПредупреждение(, ТекстПредупреждения);
		
	КонецЕсли;
	Возврат ПроверкаУспешна;
	
КонецФункции

#КонецОбласти

// Заполняет служебные реквизиты "ДатаОтгрузкиОбязательна" и "СкладОбязателен" в шапке документа.
//
//  Параметры:
//   Товары - ДанныеФормыКоллекция - таблица формы.
//   ДатаОтгрузкиОбязательна - РеквизитФормы - служебный реквизит формы, заполняемый, исходя из итогов одноименного реквизита таблицы формы.
//   СкладОбязателен - РеквизитФормы - служебный реквизит формы, заполняемый, исходя из итогов одноименного реквизита таблицы формы.
//
Процедура ЗаполнитьСлужебныеРеквизиты(Товары, ДатаОтгрузкиОбязательна = Неопределено, СкладОбязателен = Неопределено) Экспорт
	
	ДатаОтгрузкиОбязательна  = ?(Товары.Итог("ДатаОтгрузкиОбязательна") = 0, 0, 1);
	СкладОбязателен          = ?(Товары.Итог("СкладОбязателен") = 0, 0, 1);
	
КонецПроцедуры

#КонецОбласти
