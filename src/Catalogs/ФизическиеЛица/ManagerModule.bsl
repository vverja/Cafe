#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Функция определяет реквизиты физического лица.
//
// Параметры:
//  ФизЛицо - СправочникСсылка.ФизическиеЛица - Ссылка на элемент справочника
//
// Возвращаемое значение:
//	Выборка - Реквизиты выбранного физического лица
//
Функция ПолучитьРеквизитыФизическогоЛица(ФизЛицо) Экспорт
	
		
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ФизическиеЛица.КодПоДРФО КАК КодПоДРФО
	|ИЗ
	|	Справочник.ФизическиеЛица КАК ФизическиеЛица
	|ГДЕ
	|	ФизическиеЛица.Ссылка = &ФизЛицо
	|");
	
	Запрос.УстановитьПараметр("ФизЛицо", ФизЛицо);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка;
	Иначе
		Возврат Неопределено;
	КонецЕсли;

КонецФункции

// Функция определяет представление документа физического лица.
// Возвращает представление документа физического лица, если найден один документ.
// Возвращает пустую строку, если документ не найден или документов больше одного
//
// Параметры:
//  ФизЛицо - СправочникСсылка.ФизическиеЛица - Ссылка на физ. лицо
//  ВидДокумента - СправочникСсылка.ВидыДокументовФизическихЛиц - Вид документа физ. лица
//
// Возвращаемое значение:
//  Строка - Представление документа физического лица
//
Функция ПолучитьДокументФизическогоЛицаПоУмолчанию(ФизЛицо, ВидДокумента = Неопределено) Экспорт
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ ПЕРВЫЕ 2
	|	ДокументыФизическихЛиц.Представление КАК ПредставлениеДокументаФизическогоЛица
	|ИЗ
	|	РегистрСведений.ДокументыФизическихЛиц КАК ДокументыФизическихЛиц
	|ГДЕ
	|	ДокументыФизическихЛиц.Физлицо = &Физлицо
	|	И (ДокументыФизическихЛиц.ВидДокумента = &ВидДокумента
	|		ИЛИ &ВидДокумента = Неопределено)
	|");
	
	Запрос.УстановитьПараметр("Физлицо", ФизЛицо);
	Запрос.УстановитьПараметр("ВидДокумента", ?(ЗначениеЗаполнено(ВидДокумента), ВидДокумента, Неопределено));
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Количество() = 1 
	   И Выборка.Следующий()
	Тогда
		ПредставлениеДокументаФизическогоЛица = Выборка.ПредставлениеДокументаФизическогоЛица;
	Иначе
		ПредставлениеДокументаФизическогоЛица = "";
	КонецЕсли;
	
	Возврат ПредставлениеДокументаФизическогоЛица;

КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Вспомогательные процедуры формы справочника.

Процедура ОбработкаПроверкиЗаполненияНаСервере(Форма, Отказ, ПроверяемыеРеквизиты) Экспорт
	
	Если ЗначениеЗаполнено(Форма.Объект.КодПоДРФО) Тогда
		ВыборкаФизЛицо = КодПоДРФОУжеНазначенДругомуФизЛицу(Форма.Объект.КодПоДРФО, Форма.Объект.Ссылка);
		Если ВыборкаФизЛицо <> Неопределено Тогда
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Данный КодПоДРФО уже указан для физического лица  %1.';uk='Даний КодПоДРФО вказаний для фізичної особи, %1.'"),
				ВыборкаФизЛицо.Представление);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстСообщения,
				,
				"Объект.КодПоДРФО",
				,
				Отказ);
		КонецЕсли;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ФизическиеЛица.Ссылка
	|ИЗ
	|	Справочник.ФизическиеЛица КАК ФизическиеЛица
	|ГДЕ
	|	ФизическиеЛица.Наименование = &Наименование
	|	И ФизическиеЛица.Уточнение = &Уточнение
	|	И ФизическиеЛица.Ссылка <> &Ссылка";
	
	Запрос.УстановитьПараметр("Наименование", Форма.Объект.Наименование);
	Запрос.УстановитьПараметр("Уточнение",	  Форма.Объект.Уточнение);
	Запрос.УстановитьПараметр("Ссылка", 	  Форма.Объект.Ссылка);
	
	Результат = Запрос.Выполнить();
	Если Не Результат.Пустой() Тогда
		ТекстСообщения = НСтр("ru='Физическое лицо с таким ФИО и уточнением уже существует в информационной базе.
                        |Необходимо либо указать другую уточняющую информацию, либо воспользоваться уже имеющимся элементом справочника.'
                        |;uk='Фізична особа з таким ПІБ і уточненням вже існує в інформаційній базі.
                        |Необхідно або вказати іншу уточнюючу інформацію, або скористатися вже існуючим елементом довідника.'"); 
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстСообщения,
			,
			"Объект.Наименование",
			,
			Отказ);
	КонецЕсли;
	
КонецПроцедуры

//Определяет, есть ли в базе физическое лицо с таким же ИНН
// Параметры
//  КодПоДРФО  - Строка - проверяемый КодПоДРФО
//  ИсключаяСсылку  - СправочникСсылка.ФизическиеЛица - физическое лицо, исключаемое из проверки
//
// Возвращаемое значение:
//   ВыборкаИзРезультатовЗапроса, Неопределено   - выборка с данными найденного физического лица
//  с таким же КодПоДРФО Неопределено если искомый КодПоДРФО никому не назначен.
//
Функция КодПоДРФОУжеНазначенДругомуФизЛицу(КодПоДРФО, ИсключаяСсылку = Неопределено)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ФизическиеЛица.Ссылка,
	|	ПРЕДСТАВЛЕНИЕ(ФизическиеЛица.Наименование) КАК Представление
	|ИЗ
	|	Справочник.ФизическиеЛица КАК ФизическиеЛица
	|ГДЕ
	|	ФизическиеЛица.КодПоДРФО = &КодПоДРФО
	|	И ФизическиеЛица.Ссылка <> &Ссылка";
	
	Запрос.УстановитьПараметр("КодПоДРФО",	КодПоДРФО);
	Запрос.УстановитьПараметр("Ссылка", ИсключаяСсылку);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ 

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ЗначениеЗаполнено(Параметры.СтрокаПоиска) Тогда
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ФизическиеЛица.Ссылка КАК Ссылка,
		|	ФизическиеЛица.Наименование КАК Представление,
		|	"""" КАК КодПоДРФО,
		|	""По наименованию"" КАК НайденоПо,
		|	ФизическиеЛица.Уточнение,
		|	ФизическиеЛица.ПометкаУдаления КАК ПометкаУдаления
		|ИЗ
		|	Справочник.ФизическиеЛица КАК ФизическиеЛица
		|ГДЕ
		|	(ФизическиеЛица.Наименование ПОДОБНО &ФамилияИмяОтчетство
		|			ИЛИ ФизическиеЛица.Наименование ПОДОБНО &ФамилияИмя
		|			ИЛИ ФизическиеЛица.Наименование ПОДОБНО &Фамилия)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ФизическиеЛица.Ссылка,
		|	ФизическиеЛица.Наименование,
		|	ФизическиеЛица.КодПоДРФО,
		|	""По ДРФО"",
		|	ФизическиеЛица.Уточнение,
		|	ФизическиеЛица.ПометкаУдаления
		|ИЗ
		|	Справочник.ФизическиеЛица КАК ФизическиеЛица
		|ГДЕ
		|	ФизическиеЛица.КодПоДРФО ПОДОБНО &КодПоДРФО
		|	И ФизическиеЛица.КодПоДРФО <> """"
		|
		|УПОРЯДОЧИТЬ ПО
		|	ПометкаУдаления";
		
		ФИО = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(СокрЛП(Параметры.СтрокаПоиска)," ");
		
		КоличествоПодстрок = ФИО.Количество();
		Фамилия            = ?(КоличествоПодстрок > 0,ФИО[0],"");
		Имя                = ?(КоличествоПодстрок > 1,ФИО[1],"");
		Отчество           = ?(КоличествоПодстрок > 2,ФИО[2],"");
		
		Запрос.УстановитьПараметр("ФамилияИмяОтчетство", СокрЛП(Фамилия + " " + Имя + " " + Отчество) + "%");
		Запрос.УстановитьПараметр("ФамилияИмя", СокрЛП(Фамилия + " " + Имя + "%"));
		Запрос.УстановитьПараметр("Фамилия",  СокрЛП(Фамилия) + "%");
		Запрос.УстановитьПараметр("КодПоДРФО",СокрЛП(Параметры.СтрокаПоиска)  + "%");
		
		ДанныеВыбора = Новый СписокЗначений;
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		Пока Выборка.Следующий() Цикл
			
			Если Выборка.НайденоПо = "По наименованию" Тогда
				Представление = Выборка.Представление + ?(ПустаяСтрока(Выборка.Уточнение),""," (" + Выборка.Уточнение +")");
			Иначе
				Представление = Выборка.КодПоДРФО + " (" +Выборка.Представление + ")";
			КонецЕсли;
			
			Если Выборка.ПометкаУдаления Тогда
				СтруктураЗначение = Новый Структура("Значение,ПометкаУдаления", Выборка.Ссылка, Выборка.ПометкаУдаления);
				ДанныеВыбора.Добавить(СтруктураЗначение,Выборка.Представление,,БиблиотекаКартинок.ПомеченныйНаУдалениеЭлемент);
			Иначе
				ДанныеВыбора.Добавить(Выборка.Ссылка,Выборка.Представление);
			КонецЕсли;
			
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати – ТаблицаЗначений – состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли