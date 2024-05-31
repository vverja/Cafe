&НаКлиенте
Перем ВыполняетсяЗакрытие;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	СоответствиеТипов = ОбщегоНазначенияУТ.СоответствиеМассивовПоТипамОбъектов(Параметры.Объекты);
	Если СоответствиеТипов.Количество() > 1 Тогда
		ВызватьИсключение НСтр("ru='Запрещено печатать комплект документов различного вида.';uk='Заборонено друкувати комплект документів різного виду.'");
	Иначе
		
		Для Каждого ТекТипОбъекта Из СоответствиеТипов Цикл
			ТипОбъекта = ТекТипОбъекта.Ключ;
			Прервать;
		КонецЦикла;
		
		ТаблицаОбъектов = РегистрыСведений.НастройкиПечатиОбъектов.ТаблицаОбъектовДляПечатиКомплектно();
		Если ТаблицаОбъектов.Найти(ТипОбъекта, "ТипОбъекта") = Неопределено Тогда
			ТекстСообщения = НСтр("ru='Печать комплектов для документов ""%Документ%"" не поддерживается.';uk='Друк комплектів для документів ""%Документ%"" не підтримується.'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Документ%", Метаданные.НайтиПоПолномуИмени(ТипОбъекта).Синоним);
			ВызватьИсключение ТекстСообщения;
		КонецЕсли;
		
	КонецЕсли;
	
	Объекты.ЗагрузитьЗначения(Параметры.Объекты);
	
	Если Объекты.Количество() = 1 Тогда
		
		ПараметрыОбъекта = РегистрыСведений.НастройкиПечатиОбъектов.ПараметрыОбъектаДляПечатиКомплектно(ТипОбъекта);
		ЕстьОрганизация = ПараметрыОбъекта.ЕстьОрганизация;
		ЕстьПартнер = ПараметрыОбъекта.ЕстьПартнер;
		
		Если ЕстьОрганизация И ЕстьПартнер Тогда
			Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Параметры.Объекты[0], "Партнер,Организация");
			Организация = Реквизиты.Организация;
			Партнер = Реквизиты.Партнер;
		ИначеЕсли ПараметрыОбъекта.ЕстьОрганизация Тогда
			Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Параметры.Объекты[0], "Организация");
			Организация = Реквизиты.Организация;
		ИначеЕсли ПараметрыОбъекта.ЕстьПартнер Тогда
			Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Параметры.Объекты[0], "Партнер");
			Партнер = Реквизиты.Партнер;
		КонецЕсли;
		
	КонецЕсли;
	
	КоллекцияПечатныхФорм = РегистрыСведений.НастройкиПечатиОбъектов.КомплектПечатныхФорм(
		ТипОбъекта,
		?(Объекты.Количество() = 1, Объекты[0].Значение, Неопределено),
		ВариантИспользования);
	
	СформироватьВариантыСохраненияНастроек();
	ОбновитьТекстВариантаИспользования();
	ОбновитьКомандуУдаленияНастроек();
	
	Если КоллекцияПечатныхФорм <> Неопределено Тогда
	
		Для Каждого ТекСтрока Из КоллекцияПечатныхФорм Цикл
			
			НоваяСтрока = КомплектПечатныхФорм.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекСтрока);
			
		КонецЦикла;
		
	КонецЕсли;
	
	// Печать
	ЗапрашиватьПодтверждение = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ОбщиеНастройкиПользователя", "ЗапрашиватьПодтверждениеПриПечатиКомплектаДокументов");
	Если ЗапрашиватьПодтверждение <> Неопределено Тогда
		ЗапрашиватьПодтверждениеПриПечатиКомплектаДокументов = ЗапрашиватьПодтверждение;
	Иначе
		ЗапрашиватьПодтверждениеПриПечатиКомплектаДокументов = Истина;
		ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("ОбщиеНастройкиПользователя", "ЗапрашиватьПодтверждениеПриПечатиКомплектаДокументов", Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если ВыполняетсяЗакрытие Тогда
		Возврат;
	КонецЕсли;
	
	Если Модифицированность И Не СохранитьПараметры Тогда
		
		СписокКнопок = Новый СписокЗначений();
		СписокКнопок.Добавить("Закрыть", НСтр("ru='Закрыть';uk='Закрити'"));
		СписокКнопок.Добавить("НеЗакрывать", НСтр("ru='Не закрывать';uk='Не закривати'"));
		
		Отказ = Истина;
		ПоказатьВопрос(Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект), НСтр("ru='Комплект печатных форм был изменен. Закрыть форму без сохранения настроек?';uk='Комплект друкованих форм був змінений. Закрити форму без збереження настройок?'"), СписокКнопок);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	ОтветНаВопрос = РезультатВопроса;
	
	Если ОтветНаВопрос = "Закрыть" Тогда
		ВыполняетсяЗакрытие = Истина;
		Закрыть();
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Печать(Команда)
	
	Если КомплектПечатныхФорм.НайтиСтроки(Новый Структура("Печатать", Истина)).Количество() > 0 Тогда
		УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(
			ТипОбъекта,
			"КомплектДокументов",
			Объекты.ВыгрузитьЗначения(),
			Неопределено,
			Новый Структура(
				"ПереопределитьПользовательскиеНастройкиКоличества,АдресКомплектаПечатныхФорм,ФиксированныйКомплект",
				Истина, ПоместитьКомплектПечатныхФормВоВременноеХранилищеСервер(), Истина));
		
		СохранитьПараметры = Истина;
		Закрыть();
	Иначе 
		ОчиститьСообщения();
		ТекстСообщения = НСтр("ru='Выберите хотя бы одну печатную форму для печати.';uk='Виберіть хоча б одну друковану форму для друку.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "КомплектПечатныхФорм");
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПечатьНаПринтер(Команда)
	Если КомплектПечатныхФорм.НайтиСтроки(Новый Структура("Печатать", Истина)).Количество() > 0 Тогда	
		УправлениеПечатьюКлиент.ВыполнитьКомандуПечатиНаПринтер(
			ТипОбъекта,
			"КомплектДокументов",
			Объекты.ВыгрузитьЗначения(),
			Новый Структура("ПереопределитьПользовательскиеНастройкиКоличества,АдресКомплектаПечатныхФорм", Истина, ПоместитьКомплектПечатныхФормВоВременноеХранилищеСервер()));
	Иначе
		ОчиститьСообщения();
		ТекстСообщения = НСтр("ru='Выберите хотя бы одну печатную форму для печати.';uk='Виберіть хоча б одну друковану форму для друку.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "КомплектПечатныхФорм");
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура УстановитьФлажки(Команда)
	
	Для Каждого ТекСтрока Из КомплектПечатныхФорм Цикл
		ТекСтрока.Печатать = Истина;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьФлажки(Команда)
	
	Для Каждого ТекСтрока Из КомплектПечатныхФорм Цикл
		ТекСтрока.Печатать = Ложь;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтандартныеНастройки(Команда)
	
	УстановитьСтандартныеНастройкиСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьНастройки(Команда)
	
	СохранитьНастройкиКлиент();
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьНастройкиПоОрганизации(Команда)
	
	СохранитьНастройкиКлиент(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьНастройкиПоОрганизацииПартнеру(Команда)
	
	СохранитьНастройкиКлиент(Истина, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьНастройки(Команда)
	
	УдалитьНастройкиСервер();
	
	ПоказатьОповещениеПользователя(
		НСтр("ru='Настройки печати удалены';uk='Настройки друку вилучені'"),
		,
		,
		БиблиотекаКартинок.Информация32);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапрашиватьПодтверждениеПриПечатиКомплектаДокументовПриИзменении(Элемент)
	
	ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранить("ОбщиеНастройкиПользователя", "ЗапрашиватьПодтверждениеПриПечатиКомплектаДокументов", ЗапрашиватьПодтверждениеПриПечатиКомплектаДокументов);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.КомплектПечатныхФормЭкземпляров.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("КомплектПечатныхФорм.Печатать");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.КомплектПечатныхФормПредставление.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.КомплектПечатныхФормЭкземпляров.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("КомплектПечатныхФорм.Печатать");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);

КонецПроцедуры

&НаСервере
Функция ПоместитьКомплектПечатныхФормВоВременноеХранилищеСервер()
	
	Возврат ПоместитьВоВременноеХранилище(КомплектПечатныхФорм.Выгрузить(),Новый УникальныйИдентификатор);
	
Конецфункции

&НаСервере
Процедура СформироватьВариантыСохраненияНастроек()
	
	ТекстТипОбъекта = НСтр("ru='Сохранить настройки для документов ""%ТипОбъекта%""';uk='Зберегти настройки для документів ""%ТипОбъекта%""'");
	ТекстТипОбъекта = СтрЗаменить(ТекстТипОбъекта, "%ТипОбъекта%", Метаданные.НайтиПоПолномуИмени(ТипОбъекта).Представление());
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СохранитьНастройки", "Заголовок", ТекстТипОбъекта);
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СохранитьНастройки", "Видимость", ПраваПользователяПовтИсп.СохранениеНастроекПечатиОбъектовПоУмолчанию());
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СохранитьНастройкиПоОрганизации", "Видимость", Ложь);
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СохранитьНастройкиПоОрганизацииПартнеру", "Видимость", Ложь);
	
	Если ЕстьОрганизация И ПраваПользователяПовтИсп.СохранениеНастроекПечатиОбъектовПоУмолчанию() Тогда
		ТекстТипОбъекта = ТекстТипОбъекта +  НСтр("ru=' по организации ""%Организация%""';uk=' за організацією ""%Организация%""'");
		ТекстТипОбъекта = СтрЗаменить(ТекстТипОбъекта, "%Организация%", Организация);
		ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СохранитьНастройкиПоОрганизации", "Заголовок", ТекстТипОбъекта);
		ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СохранитьНастройкиПоОрганизации", "Видимость", Истина);
	КонецЕсли;
	
	Если ЕстьПартнер И ПраваПользователяПовтИсп.ДобавлениеИзменениеНастройкиПечатиОбъектов() И
	 (НЕ ЕстьОрганизация ИЛИ ПраваПользователяПовтИсп.СохранениеНастроекПечатиОбъектовПоУмолчанию()) Тогда
		ТекстТипОбъекта = ТекстТипОбъекта + НСтр("ru=' по партнеру ""%Партнер%""';uk=' по партнеру ""%Партнер%""'");
		ТекстТипОбъекта = СтрЗаменить(ТекстТипОбъекта, "%Партнер%", Партнер);
		ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СохранитьНастройкиПоОрганизацииПартнеру", "Заголовок", ТекстТипОбъекта);
		ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СохранитьНастройкиПоОрганизацииПартнеру", "Видимость", Истина);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ОбновитьКомандуУдаленияНастроек()
	
	Если ВариантИспользования > 0 Тогда
	
		ТекстТипОбъекта = НСтр("ru='Удалить настройки для документов ""%ТипОбъекта%""';uk='Видалити настройки для документів ""%ТипОбъекта%""'");
		ТекстТипОбъекта = СтрЗаменить(ТекстТипОбъекта, "%ТипОбъекта%", Метаданные.НайтиПоПолномуИмени(ТипОбъекта).Представление());
		
		Если ВариантИспользования > 1 Тогда
			ТекстТипОбъекта = ТекстТипОбъекта +  НСтр("ru=' по организации ""%Организация%""';uk=' за організацією ""%Организация%""'");
			ТекстТипОбъекта = СтрЗаменить(ТекстТипОбъекта, "%Организация%", Организация);
		КонецЕсли;
		
		Если ВариантИспользования > 2 Тогда
			ТекстТипОбъекта = ТекстТипОбъекта + НСтр("ru=' по партнеру ""%Партнер%""';uk=' по партнеру ""%Партнер%""'");
			ТекстТипОбъекта = СтрЗаменить(ТекстТипОбъекта, "%Партнер%", Партнер);
		КонецЕсли;
		
		ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "УдалитьНастройки", "Заголовок", ТекстТипОбъекта);
		
		Если Пользователи.ЭтоПолноправныйПользователь() Или
			((ВариантИспользования = 2 ИЛИ (ВариантИспользования = 3 И ПраваПользователяПовтИсп.ДобавлениеИзменениеНастройкиПечатиОбъектов()))
				И ПраваПользователяПовтИсп.СохранениеНастроекПечатиОбъектовПоУмолчанию()) Тогда
			
			ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "УдалитьНастройки", "Видимость", Истина);
			
		КонецЕсли;
		
	Иначе
		
		ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "УдалитьНастройки", "Видимость", Ложь);
		
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ОбновитьТекстВариантаИспользования()
	
	Если ВариантИспользования > 0 Тогда
		ТекстТипОбъекта = НСтр("ru='Применяется настройка для документов ""%ТипОбъекта%""';uk='Застосовується настройка для документів ""%ТипОбъекта%""'");
		ТекстТипОбъекта = СтрЗаменить(ТекстТипОбъекта, "%ТипОбъекта%", Метаданные.НайтиПоПолномуИмени(ТипОбъекта).Представление());
		
		Если ВариантИспользования = 2 Или ВариантИспользования = 3 Тогда
			ТекстТипОбъекта = ТекстТипОбъекта +  НСтр("ru=' по организации ""%Организация%""';uk=' за організацією ""%Организация%""'");
			ТекстТипОбъекта = СтрЗаменить(ТекстТипОбъекта, "%Организация%", Организация);
		КонецЕсли;
		
		Если ВариантИспользования = 3 Тогда
			ТекстТипОбъекта = ТекстТипОбъекта +  НСтр("ru=' по клиенту ""%Партнер%""';uk=' по клієнту ""%Партнер%""'");
			ТекстТипОбъекта = СтрЗаменить(ТекстТипОбъекта, "%Партнер%", Партнер);
		КонецЕсли;
	Иначе
		ТекстТипОбъекта = НСтр("ru='Применяется настройка по умолчанию для документов ""%ТипОбъекта%""';uk='Застосовується настройка по умовчанню для документів ""%ТипОбъекта%""'");
		ТекстТипОбъекта = СтрЗаменить(ТекстТипОбъекта, "%ТипОбъекта%", Метаданные.НайтиПоПолномуИмени(ТипОбъекта).Представление());
	КонецЕсли;
	
	ВариантИспользованияТекст = ТекстТипОбъекта;
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьНастройкиКлиент(ЗаписыватьОрганизацию = Ложь, ЗаписыватьПартнера = Ложь)
	
	ЗаписатьНастройкиПечатиСервер(ЗаписыватьОрганизацию, ЗаписыватьПартнера);
	
	ПоказатьОповещениеПользователя(
		НСтр("ru='Настройки печати сохранены';uk='Настройки друку збережені'"),
		,
		,
		БиблиотекаКартинок.Информация32);
	
КонецПроцедуры

&НаСервере
Процедура УдалитьНастройкиСервер()
	
	Если ВариантИспользования = 1 Тогда
		РегистрыСведений.НастройкиПечатиОбъектов.УдалитьНастройкиПечатиОбъекта(ТипОбъекта, Справочники.Организации.ПустаяСсылка(), Справочники.Партнеры.ПустаяСсылка());
	ИначеЕсли ВариантИспользования = 2 Тогда
		РегистрыСведений.НастройкиПечатиОбъектов.УдалитьНастройкиПечатиОбъекта(ТипОбъекта, Организация, Справочники.Партнеры.ПустаяСсылка());
	ИначеЕсли ВариантИспользования = 3 Тогда
		РегистрыСведений.НастройкиПечатиОбъектов.УдалитьНастройкиПечатиОбъекта(ТипОбъекта, Организация, Партнер);
	КонецЕсли;
	
	РегистрыСведений.НастройкиПечатиОбъектов.КомплектПечатныхФорм(
		ТипОбъекта,
		?(Объекты.Количество() = 1, Объекты[0].Значение, Неопределено),
		ВариантИспользования);
	
	ОбновитьКомандуУдаленияНастроек();
	ОбновитьТекстВариантаИспользования();
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьНастройкиПечатиСервер(ЗаписыватьОрганизацию = Ложь, ЗаписыватьПартнера = Ложь)
	
	Модифицированность = Ложь;
	РегистрыСведений.НастройкиПечатиОбъектов.ЗаписатьНастройкиПечатиОбъекта(
		ТипОбъекта,
		КомплектПечатныхФорм.Выгрузить(),
		ЗаписыватьОрганизацию,
		ЗаписыватьПартнера,
		?(Объекты.Количество() = 1, Объекты[0].Значение, Неопределено));
	
	РегистрыСведений.НастройкиПечатиОбъектов.КомплектПечатныхФорм(
		ТипОбъекта,
		?(Объекты.Количество() = 1, Объекты[0].Значение, Неопределено),
		ВариантИспользования);
	
	ОбновитьТекстВариантаИспользования();
	ОбновитьКомандуУдаленияНастроек();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСтандартныеНастройкиСервер()
	
	ВариантИспользования = 0;
	КомплектПечатныхФорм.Очистить();
	МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ТипОбъекта);
	КоллекцияПечатныхФорм = МенеджерОбъекта.КомплектПечатныхФорм();
	РегистрыСведений.НастройкиПечатиОбъектов.ДополнитьКомплектВнешнимиПечатнымиФормами(ТипОбъекта, КоллекцияПечатныхФорм);
	ОбновитьТекстВариантаИспользования();
	
	Для Каждого ТекСтрока Из КоллекцияПечатныхФорм Цикл
		
		НоваяСтрока = КомплектПечатныхФорм.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекСтрока);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

ВыполняетсяЗакрытие = Ложь;