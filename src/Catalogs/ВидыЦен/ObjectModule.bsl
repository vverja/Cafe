#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	Если ПравилаОкругленияЦены.Количество() > 1 Тогда
		ПравилаОкругленияЦены.Сортировать("НижняяГраницаДиапазонаЦен");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СхемаКомпоновкиДанных) Тогда
		ХранилищеСхемыКомпоновкиДанных = Неопределено;
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоВидовЦен") Тогда
		УстановитьПривилегированныйРежим(Истина);
		Запрос = Новый Запрос(
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ВидыЦен.Ссылка
		|ИЗ
		|	Справочник.ВидыЦен КАК ВидыЦен
		|ГДЕ
		|	ВидыЦен.Ссылка <> &Ссылка");
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		Если Не Запрос.Выполнить().Пустой() Тогда
			Константы.ИспользоватьНесколькоВидовЦен.Установить(Истина);
		КонецЕсли;
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновитьПовторноИспользуемыеЗначения()
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Идентификатор = "";
	
КонецПроцедуры

Функция ИспользуютсяРасширенныеНастройкиОкругления()
	
	ИспользоватьРасширеннуюНастройкуОкругления = Ложь;
	
	Если ПравилаОкругленияЦены.Количество() = 1
		И ПравилаОкругленияЦены[0].НижняяГраницаДиапазонаЦен = 0
		И ПравилаОкругленияЦены[0].ПсихологическоеОкругление = 0 Тогда
		ИспользоватьРасширеннуюНастройкуОкругления = Ложь;
	ИначеЕсли ПравилаОкругленияЦены.Количество() >= 1 Тогда
		ИспользоватьРасширеннуюНастройкуОкругления = Истина;
	Иначе
		ИспользоватьРасширеннуюНастройкуОкругления = Ложь;
	КонецЕсли;
	
	Возврат ИспользоватьРасширеннуюНастройкуОкругления;
	
КонецФункции

Функция ИспользуютсяРасширенныеВозможности()
	
	ИспользоватьРасширенныеВозможности = Ложь;
	
	Если ИспользуютсяРасширенныеНастройкиОкругления() Тогда
		ИспользоватьРасширенныеВозможности = Истина;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(СхемаКомпоновкиДанных) ИЛИ ХранилищеНастроекКомпоновкиДанных.Получить() <> Неопределено Тогда
		ИспользоватьРасширенныеВозможности = Истина;
	КонецЕсли;
	
	Если СпособЗаданияЦены = ПредопределенноеЗначение("Перечисление.СпособыЗаданияЦен.ЗаполнятьПоДаннымИБ")
		ИЛИ СпособЗаданияЦены = ПредопределенноеЗначение("Перечисление.СпособыЗаданияЦен.РассчитыватьПоФормуламОтДругихВидовЦен") Тогда
		ИспользоватьРасширенныеВозможности = Истина;
	КонецЕсли;
	
	Если ПорогиСрабатывания.Количество() > 0 Тогда
		ИспользоватьРасширенныеВозможности = Истина;
	КонецЕсли;
	
	Если ЦеновыеГруппы.Количество() > 0 Тогда
		ИспользоватьРасширенныеВозможности = Истина;
	КонецЕсли;
	
	Возврат ИспользоватьРасширенныеВозможности;
	
КонецФункции

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ЗаполнитьЗначенияПоУмолчанию();
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если Не ИндентификаторУникален() Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			СтрЗаменить(НСтр("ru='В базе данных уже содержится вид цены с идентификатором ""%Идентификатор%"". Идентификатор должен быть уникальным';uk='У базі даних міститься вид ціни з ідентифікатором ""%Идентификатор%"". Ідентифікатор повинен бути унікальним'"), "%Идентификатор%", Идентификатор), 
			ЭтотОбъект, "Идентификатор",, Отказ);
	КонецЕсли;
	
	Если СпособЗаданияЦены = Перечисления.СпособыЗаданияЦен.НаценкаНаДругойВидЦен
		И БазовыйВидЦены = Ссылка Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru='Базовый вид цены не может быть равен текущему виду цены';uk='Базовий вид ціни не може дорівнювати поточному виду ціни'"),
			ЭтотОбъект, "БазовыйВидЦены",, Отказ);
	КонецЕсли;
	
	Для Индекс = 0 По ПравилаОкругленияЦены.Количество() - 1 Цикл
		
		СтрокаПравилОкругления = ПравилаОкругленияЦены[Индекс];
		ВерхняяГраницаДиапазона = ?(Индекс < ПравилаОкругленияЦены.Количество() - 1, ПравилаОкругленияЦены[Индекс + 1].НижняяГраницаДиапазонаЦен, -1);
		ПроверитьКорректностьПравилОкругленияЦеныВСтроке(СтрокаПравилОкругления, ВерхняяГраницаДиапазона, Отказ);
		
	КонецЦикла;
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	Если СпособЗаданияЦены <> Перечисления.СпособыЗаданияЦен.РассчитыватьПоФормуламОтДругихВидовЦен Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Формула");
		МассивНепроверяемыхРеквизитов.Добавить("ЦеновыеГруппы.Формула");
	КонецЕсли;
	
	Если СпособЗаданияЦены <> Перечисления.СпособыЗаданияЦен.НаценкаНаДругойВидЦен Тогда
		МассивНепроверяемыхРеквизитов.Добавить("БазовыйВидЦены");
		МассивНепроверяемыхРеквизитов.Добавить("ЦеновыеГруппы.БазовыйВидЦены");
		МассивНепроверяемыхРеквизитов.Добавить("ЦеновыеГруппы.Наценка");
	КонецЕсли;
	
	Если СпособЗаданияЦены <> Перечисления.СпособыЗаданияЦен.НаценкаНаДругойВидЦен
		И СпособЗаданияЦены <> Перечисления.СпособыЗаданияЦен.НаценкаНаЦенуПоступления Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Наценка");
	КонецЕсли;
	
	ИспользоватьРасширенныеВозможностиЦенооборазования = ИспользуютсяРасширенныеВозможности();
	ИспользоватьПроизвольныеСхемыКомпоновкиДанных = Не ОбщегоНазначенияПовтИсп.РазделениеВключено() И ИспользоватьРасширенныеВозможностиЦенооборазования;
	
	Если ИспользоватьПроизвольныеСхемыКомпоновкиДанных Тогда
		МассивНепроверяемыхРеквизитов.Добавить("СхемаКомпоновкиДанных");
	КонецЕсли;
	
	Если Не ИспользоватьРасширенныеВозможностиЦенооборазования Тогда
		МассивНепроверяемыхРеквизитов.Добавить("СхемаКомпоновкиДанных");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияИЗаполнение

Процедура ЗаполнитьЗначенияПоУмолчанию()
	
	СхемаКомпоновкиДанных = "Типовой";
	ВалютаЦены = ДоходыИРасходыСервер.ПолучитьВалютуУправленческогоУчета(ВалютаЦены);
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

// Осуществляет поиск идентификатора, совпадающего с заполненным в объекте
//
// Возвращаемое значение:
//	Булево
//	Истина, если идентификатор не найден, Ложь в противном случае
//
Функция ИндентификаторУникален()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос();
	Запрос.Текст = "
		|ВЫБРАТЬ
		|	1 КАК Поле1
		|ИЗ
		|	Справочник.ВидыЦен КАК ВидыЦен
		|ГДЕ
		|	ВидыЦен.Идентификатор = &Идентификатор
		|	И ВидыЦен.Ссылка <> &Ссылка";
		
	Запрос.УстановитьПараметр("Ссылка",        Ссылка);
	Запрос.УстановитьПараметр("Идентификатор", Идентификатор);
	
	Возврат Запрос.Выполнить().Пустой();
	
КонецФункции

// Осуществляет проверку корректности правил округления в строке тч ПравилаОкругленияЦены
//
// Параметры:
//	СтрокаПравилОкругления  - Строка - Строка табличной части ПравилаОкругленияЦены
//	ВерхняяГраницаДиапазона - Число - значение верхней границы диапазона цен
//	Отказ                   - Булево - признак, указывающий на некорректность правил округления
//
Процедура ПроверитьКорректностьПравилОкругленияЦеныВСтроке(Знач СтрокаПравилОкругления, Знач ВерхняяГраницаДиапазона, Отказ) Экспорт
	
	Если ЗначениеЗаполнено(СтрокаПравилОкругления.ТочностьОкругления) И ВерхняяГраницаДиапазона > 0 
		И СтрокаПравилОкругления.ТочностьОкругления >= ВерхняяГраницаДиапазона Тогда
		
		ТекстОшибки = НСтр("ru='Точность округления в строке %НомерСтроки% списка ""Правила округления цены"" должна быть меньше нижней границы диапазона цен в следующей строке';uk='Точність округлення в рядку %НомерСтроки% списку ""Правила округлення ціни"" повинна бути менше нижньої межі діапазону цін у наступному рядку'");
		ТекстОшибки = СтрЗаменить(ТекстОшибки, "%НомерСтроки%", СтрокаПравилОкругления.НомерСтроки);
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстОшибки,
			ЭтотОбъект,
			ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ПравилаОкругленияЦены", СтрокаПравилОкругления.НомерСтроки, "ТочностьОкругления"),
			,
			Отказ);
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СтрокаПравилОкругления.ПсихологическоеОкругление) 
		И ВерхняяГраницаДиапазона > 0 И СтрокаПравилОкругления.ПсихологическоеОкругление >= ВерхняяГраницаДиапазона Тогда
		
		ТекстОшибки = НСтр("ru='Психологическое округление в строке %НомерСтроки% списка ""Правила округления цены"" должно быть меньше нижней границы диапазона цен в следующей строке';uk='Психологічне округлення в рядку %НомерСтроки% списку ""Правила округлення ціни"" повинно бути менше нижньої межі діапазону цін у наступному рядку'");
		ТекстОшибки = СтрЗаменить(ТекстОшибки, "%НомерСтроки%", СтрокаПравилОкругления.НомерСтроки);
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстОшибки,
			ЭтотОбъект,
			ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ПравилаОкругленияЦены", СтрокаПравилОкругления.НомерСтроки, "ПсихологическоеОкругление"),
			,
			Отказ);
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СтрокаПравилОкругления.ТочностьОкругления) И
		СтрокаПравилОкругления.ПсихологическоеОкругление >= СтрокаПравилОкругления.ТочностьОкругления Тогда
		
		ТекстОшибки = НСтр("ru='Психологическое округление в строке %НомерСтроки% списка ""Правила округления цены"" должно быть меньше точности округления';uk='Психологічне округлення в рядку %НомерСтроки% списку ""Правила округлення ціни"" повинно бути менше точності округлення'");
		ТекстОшибки = СтрЗаменить(ТекстОшибки, "%НомерСтроки%", СтрокаПравилОкругления.НомерСтроки);
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстОшибки,
			ЭтотОбъект,
			ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ПравилаОкругленияЦены", СтрокаПравилОкругления.НомерСтроки, "ПсихологическоеОкругление"),
			,
			Отказ);
		
	КонецЕсли;

#КонецОбласти
КонецПроцедуры
#КонецОбласти

#КонецЕсли
