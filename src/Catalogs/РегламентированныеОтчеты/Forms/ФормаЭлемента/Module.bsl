
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		Элементы.ГруппаИспользовать.Видимость = Ложь;
		Элементы.ГруппаКнопокСохранения.Видимость = Ложь;
	Иначе 
		ЭтаФорма.ИспользоватьВнешнийОтчет = Число(Объект.ВнешнийОтчетИспользовать);
		ЭтаФорма.ВнешнийОтчетЗарегистрирован = ВнешнийОтчетЗарегистрирован(Объект.Ссылка);
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УправлениеЭУ();
КонецПроцедуры


&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	// проверки
	Если ПустаяСтрока(Объект.ИсточникОтчета) Тогда
		ПоказатьПредупреждение(,НСтр("ru='Укажите наименование объекта!';uk= 'Укажіть найменування об''єкта!'"));
		Модифицированность = Истина;
		Отказ = Истина;
		Возврат;
	КонецЕсли;

	Если НЕ Объект.ВнешнийОтчетИспользовать И ОпределитьТипОтчета(Объект.ИсточникОтчета, , Истина) = 0 Тогда
		ПоказатьПредупреждение(,НСтр("ru='Регламентированный отчет ""';uk='Регламентований звіт"" '") + СокрЛП(Объект.ИсточникОтчета) + НСтр("ru='"" не найден в конфигурации.';uk='"" не знайдений в конфігурації.'"));
		Модифицированность = Истина;
		Отказ = Истина;
		Возврат;
	КонецЕсли;

	Если Объект.ВнешнийОтчетИспользовать И НЕ ВнешнийОтчетЗарегистрирован Тогда
		ПоказатьПредупреждение(,НСтр("ru='Внешний отчет отсутствует! Загрузите внешний отчет или установите признак ""Использовать"" в положение ""Объект"".';uk='Зовнішній звіт відсутній! Завантажте зовнішній звіт або встановіть ознаку ""Використовувати"" в положення ""Об''єкт"".'"));
		Модифицированность = Истина;
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если НЕ Объект.ВнешнийОтчетИспользовать Тогда 
		Объект.ВнешнийОтчетВерсия = "";
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	// очищаем полное имя внешнего отчета - после записи оно не должно прорисовываться
	ПолноеИмяЗагруженногоВнешнегоОтчета = Неопределено;
	
	УправлениеЭУ();
	Оповестить("Обновить дерево отчетов", "Обновить дерево отчетов", ЭтаФорма);
	
	// если отчет изменялся и кэшировался, то выдадим предупреждение о вступлении изменений в силу только после перезапуска
	Если ИзмененВнешнийОтчетХранилище ИЛИ ИзмененПризнакИспользованияВнешнегоОтчета Тогда
		ОбъектКэшировался = ОтчетКэшировался(Объект.Ссылка);
		Если ОбъектКэшировался Тогда
			ТекстИзмененияВступятВСилу = Символы.ПС + НСтр("ru='ИЗМЕНЕНИЯ ВСТУПЯТ В СИЛУ ТОЛЬКО ПОСЛЕ ПОВТОРНОГО ОТКРЫТИЯ ПРОГРАММЫ!';uk='ЗМІНИ ВСТУПЛЯТЬ В СИЛУ ТІЛЬКИ ПІСЛЯ ПОВТОРНОГО ВІДКРИТТЯ ПРОГРАМИ!'");
			Если ИзмененВнешнийОтчетХранилище И НЕ ИзмененПризнакИспользованияВнешнегоОтчета Тогда
				ПоказатьПредупреждение(,НСтр("ru='Был загружен новый внешний отчет!';uk='Був завантажений новий зовнішній звіт!'") + ТекстИзмененияВступятВСилу);
			ИначеЕсли НЕ ИзмененВнешнийОтчетХранилище И ИзмененПризнакИспользованияВнешнегоОтчета Тогда
				ПоказатьПредупреждение(,НСтр("ru='Был изменен признак использования внешнего отчета!';uk='Була змінена ознака використання зовнішнього звіту!'") + ТекстИзмененияВступятВСилу);
			ИначеЕсли ИзмененВнешнийОтчетХранилище И ИзмененПризнакИспользованияВнешнегоОтчета Тогда
				ПоказатьПредупреждение(,НСтр("ru='Был изменен признак использования внешнего отчета и загружен новый внешний отчет!';uk='Була змінена ознака використання зовнішнього звіту та завантажений новий зовнішній звіт!'") + ТекстИзмененияВступятВСилу);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура ПолеИспользоватьВнешнийОтчетПриИзменении(Элемент)
	
	ИзмененПризнакИспользованияВнешнегоОтчета = Истина;
	Объект.ВнешнийОтчетИспользовать = (ЭтаФорма.ИспользоватьВнешнийОтчет = 1);
	Модифицированность = Истина;
	Если Объект.ВнешнийОтчетИспользовать И НЕ ВнешнийОтчетЗарегистрирован Тогда
		ВыбратьВнешнийОтчет();
	Иначе
		УправлениеЭУ();
	КонецЕсли;
	
	
КонецПроцедуры


// Функция определяет тип указанного в реквизите ИсточникОтчета 
// элемента справочника регламентированного отчета (обработки).
//
// Параметры
//  ФайлВнешнегоОтчета - строка - имя файла, указанное в реквизите элемента;
//  Расширение         - строка - расширение файла;
//
// Возвращаемое значение:
// - число, принимает значения:
//      - 1 - в реквизите указано наименование
//            встроенного в конфигурацию отчета;
//      - 2 - в реквизите указано полное наименование файла.
//      - 0 - в иных случаях.
//
&НаКлиенте
Функция ОпределитьТипОтчета(ФайлВнешнегоОтчета, Расширение = "", НеВыводитьСообщения = Ложь) Экспорт
	
	ТипОтчета = 0;
	
	Если Не ПустаяСтрока(ФайлВнешнегоОтчета) Тогда
	
		Если ВнешнийОтчетЗарегистрирован(Объект.Ссылка) ИЛИ ЭтоАдресВременногоХранилища(АдресФайлаВоВременномХранилище) Тогда 
			ТипОтчета  = 1;
		Иначе
			ТипОтчета = НайтиВМетаданных(ФайлВнешнегоОтчета);
		КонецЕсли;
	
		Если ТипОтчета = 0 Тогда
			Если НЕ НеВыводитьСообщения Тогда
				Сообщить(НСтр("ru='Не найден отчет ""';uk='Не знайдений звіт"" '") + ФайлВнешнегоОтчета + """!", СтатусСообщения.Внимание);
			КонецЕсли;
		КонецЕсли;
	
	Иначе
	
		Если НЕ НеВыводитьСообщения Тогда
			Сообщить(НСтр("ru='Не выбран файл внешнего отчета!';uk='Не вибрано файл зовнішнього звіту!'"), СтатусСообщения.Внимание);
		КонецЕсли;
	
	КонецЕсли;
	
	Возврат ТипОтчета;
	
КонецФункции


Функция НайтиВМетаданных(ФайлВнешнегоОтчета)
	
	Если Метаданные.Отчеты.Найти(ФайлВнешнегоОтчета) <> Неопределено Тогда
		Возврат 2;
	ИначеЕсли Метаданные.Документы.Найти(ФайлВнешнегоОтчета) <> Неопределено Тогда
		Возврат 3;
	Иначе
		Возврат 0;
	КонецЕсли;
	
КонецФункции


&НаКлиенте
Процедура ВыбратьВнешнийОтчет()
	
	#Если ВебКлиент Тогда
		
		АдресФайлаВоВременномХранилище = "";
		ВыбранноеИмяФайла              = "";
		
		ДополнительныеПараметры = Новый Структура("ВыбранноеИмяФайла", ВыбранноеИмяФайла);
		ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьВнешнийОтчетЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		НачатьПомещениеФайла(ОписаниеОповещения, АдресФайлаВоВременномХранилище,,, УникальныйИдентификатор);

	#Иначе
		
		// инициализируем свойства диалога
		Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
		Диалог.Заголовок = НСтр("ru='Выберите файл внешнего отчета';uk='Виберіть файл зовнішнього звіту'");
		Диалог.МножественныйВыбор = Ложь;
		Диалог.ПроверятьСуществованиеФайла = Истина;
		Диалог.Фильтр = НСтр("ru='Внешний отчет (*.erf)|*.erf';uk='Зовнішній звіт (*.erf)|*.erf'");
		
		// показываем диалог
		Если НЕ Диалог.Выбрать() Тогда
			Возврат;
		КонецЕсли;
		
		АдресФайлаВоВременномХранилище = ПоместитьВоВременноеХранилище(Новый ДвоичныеДанные(Диалог.ПолноеИмяФайла), Новый УникальныйИдентификатор);
		ПолноеИмяЗагруженногоВнешнегоОтчета = Диалог.ПолноеИмяФайла;
		
		ЗарегистрироватьВнешнийОтчет();
		
	#КонецЕсли
		
КонецПроцедуры


&НаКлиенте
Процедура ВыбратьВнешнийОтчетЗавершение(Результат, Адрес, ВыбранноеИмяФайла, ДополнительныеПараметры) Экспорт
	
	Если НЕ Результат Тогда
		Возврат;
	КонецЕсли;
	АдресФайлаВоВременномХранилище = Адрес;
	ПолноеИмяЗагруженногоВнешнегоОтчета = ВыбранноеИмяФайла;
	
	ЗарегистрироватьВнешнийОтчет();
	
КонецПроцедуры


Функция ПолноеИмяИДанныеФайла(ОбъектСсылка)
	
	ВремФайл = ПолучитьИмяВременногоФайла();
	ДанныеХранилища = ОбъектСсылка.ВнешнийОтчетХранилище.Получить();
	ДанныеХранилища.Записать(ВремФайл);
	АдресВременногоХранилища = ПоместитьВоВременноеХранилище(ДанныеХранилища, Новый УникальныйИдентификатор);
	
	ИмяФайла = ВнешниеОтчеты.Создать(ВремФайл).Метаданные().Имя + ".erf";
	
	Возврат Новый Структура("ИмяФайла, АдресВременногоХранилища", ИмяФайла, АдресВременногоХранилища);
	
КонецФункции

&НаКлиенте
Процедура ДекорацияВыгрузитьНажатие(Элемент)
	
	ПолноеИмяВыгружаемогоФайла = "";
	АдресДанныхВыгружаемогоФайла = "";
	ПолноеИмяФайлаВыбор = "";
	
	// извлекаем имя из отчета
	Состояние(НСтр("ru='Получение имени отчета...';uk='Одержання ім''я звіту...'"));
	Результат = ПолноеИмяИДанныеФайла(Объект.Ссылка);
	
	Если ТипЗнч(Результат) <> Тип("Структура") Тогда 
		Возврат;
	КонецЕсли;
	
	Если НЕ Результат.Свойство("ИмяФайла", ПолноеИмяВыгружаемогоФайла) Тогда 
		ПолноеИмяВыгружаемогоФайла = ?(ПустаяСтрока(Объект.ИсточникОтчета), "", Объект.ИсточникОтчета + ".erf");
	КонецЕсли;
	
	Если НЕ Результат.Свойство("АдресВременногоХранилища", АдресДанныхВыгружаемогоФайла) Тогда 
		Возврат;
	КонецЕсли;

	
	#Если ВебКлиент Тогда
		
		ПолучитьФайл(АдресДанныхВыгружаемогоФайла,ПолноеИмяВыгружаемогоФайла, Истина);
		
	#Иначе
		
		// инициализируем диалог выбора файлов
		Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
		Диалог.Заголовок = НСтр("ru='Укажите файл для сохранения';uk='Вкажіть файл для збереження'");
		Диалог.ПроверятьСуществованиеФайла = Истина;
		Диалог.Расширение = "erf";
		Диалог.Фильтр = НСтр("ru='Внешний отчет (*.erf)|*.erf';uk='Зовнішній звіт (*.erf)|*.erf'");
		
		
		Диалог.ПолноеИмяФайла = ПолноеИмяВыгружаемогоФайла;
		
		Состояние();
		
		// показываем диалог
		Если НЕ Диалог.Выбрать() Тогда
			Возврат;
		Иначе
			ПолноеИмяФайлаВыбор = Диалог.ПолноеИмяФайла;
		КонецЕсли;
		
		ПолучитьИзВременногоХранилища(АдресДанныхВыгружаемогоФайла).Записать(ПолноеИмяФайлаВыбор);
		
	#КонецЕсли	
	
КонецПроцедуры


&НаКлиенте
Процедура ЗарегистрироватьВнешнийОтчет()
	
	Состояние(НСтр("ru='Проверка внешнего отчета...';uk='Перевірка зовнішнього звіту...'"));
	
	СвойстваОтчета = РегламентированнаяОтчетностьВызовСервера.СвойстваВнешнегоОтчета(Объект.Ссылка, АдресФайлаВоВременномХранилище);
	Если СвойстваОтчета.Свойство("Результат") И НЕ СвойстваОтчета["Результат"] Тогда 
		ТекстПредупреждения = Неопределено;
		Если СвойстваОтчета.Свойство("ТекстПредупреждения", ТекстПредупреждения) Тогда 
			ПоказатьПредупреждение(,ТекстПредупреждения);
		КонецЕсли;
		ПолноеИмяЗагруженногоВнешнегоОтчета = Неопределено;
		Возврат;
	КонецЕсли;
		
	// проверка на соответствие идентификатора конфигурации в отчете идентификатору текущей конфигурации
	ИДКонфигурацииОтчета = Неопределено;
	Если СвойстваОтчета.Свойство("ИДКонфигурацииОтчета", ИДКонфигурацииОтчета)
		И ВРЕГ(ИДКонфигурацииОтчета) <> ВРЕГ(СвойстваОтчета.ИДКонфигурацииИмя)
		И ВРЕГ(ИДКонфигурацииОтчета) <> ВРЕГ(СвойстваОтчета.ИДКонфигурацииМетаданные) Тогда
		ТекстВопроса = НСтр("ru='ВНИМАНИЕ!
                             |
                             |Отчет не предназначен для использования с текущей конфигурацией!
                             |
                             |Продолжить действие (не рекомендуется)?';uk= 'УВАГА!
                             |
                             |Звіт не призначений для використання з поточною конфігурацією!
                             |
                             |Продовжити дію (не рекомендується)?'");
		ДополнительныеПараметры = Новый Структура("СвойстваОтчета", СвойстваОтчета);
		ОписаниеОповещения = Новый ОписаниеОповещения("ЗарегистрироватьВнешнийОтчетЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет);
	Иначе
		ЗарегистрироватьВнешнийОтчетИспользоватьСТекущейКонфигурацией(СвойстваОтчета);
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура ЗарегистрироватьВнешнийОтчетЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	СвойстваОтчета = ДополнительныеПараметры.СвойстваОтчета;
	
	Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда
		ПолноеИмяЗагруженногоВнешнегоОтчета = Неопределено;
		УправлениеЭУ();
	Иначе
		ЗарегистрироватьВнешнийОтчетИспользоватьСТекущейКонфигурацией(СвойстваОтчета);
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура ЗарегистрироватьВнешнийОтчетИспользоватьСТекущейКонфигурацией(СвойстваОтчета)
	
	// проверка на соответствие версии в отчете версии текущей конфигурации
	ВерсияКонфигурацииВнешнегоОтчета = Неопределено;
	Если СвойстваОтчета.Свойство("ВерсияКонфигурацииВнешнегоОтчета", ВерсияКонфигурацииВнешнегоОтчета)
		И ВерсияКонфигурацииВнешнегоОтчета <> СвойстваОтчета["ВерсияКонфигурацииМетаданные"] Тогда
		ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='ВНИМАНИЕ!
                  |
                  |Отчет не предназначен для использования с текущей версией конфигурации!
                  |
                  |Версия текущей конфигурации: %1
                  |Отчет предназначен для использования с версией: %2
                  |
                  |Продолжить действие (не рекомендуется)?'
                  |;uk='УВАГА!
                  |
                  |Звіт не призначений для використання із поточною версією конфігурації!
                  |
                  |Версія поточної конфігурації: %1
                  |Звіт призначений для використання з версією: %2
                  |
                  |Продовжити (не рекомендується)?'"), СвойстваОтчета["ВерсияКонфигурацииМетаданные"], ВерсияКонфигурацииВнешнегоОтчета);
		ДополнительныеПараметры = Новый Структура("СвойстваОтчета", СвойстваОтчета);
		ОписаниеОповещения = Новый ОписаниеОповещения("ЗарегистрироватьВнешнийОтчетИспользоватьСТекущейКонфигурациейЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет);
	Иначе
		ЗарегистрироватьВнешнийОтчетИспользоватьСТекущейВерсиейКонфигурацией(СвойстваОтчета);
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура ЗарегистрироватьВнешнийОтчетИспользоватьСТекущейКонфигурациейЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	СвойстваОтчета = ДополнительныеПараметры.СвойстваОтчета;
	
	Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда
		ПолноеИмяЗагруженногоВнешнегоОтчета = Неопределено;
		УправлениеЭУ();
	Иначе
		ЗарегистрироватьВнешнийОтчетИспользоватьСТекущейВерсиейКонфигурацией(СвойстваОтчета);
	КонецЕсли;

КонецПроцедуры


&НаКлиенте
Процедура ЗарегистрироватьВнешнийОтчетИспользоватьСТекущейВерсиейКонфигурацией(СвойстваОтчета)
	
	// проверка на соответствие имени метаданных отчета свойству ИсточникОтчета текущего элемента
	МетаданныеОтчетаИмя = СвойстваОтчета["ОбъектОтчетМетаданныеИмя"];
	Если НЕ ПустаяСтрока(Объект.ИсточникОтчета) И МетаданныеОтчетаИмя <> Объект.ИсточникОтчета Тогда
		ТекстВопроса = НСтр("ru='ВНИМАНИЕ!
                             |
                             |Обнаружено несоответствие между текущим элементом справочника и выбранным отчетом!
                             |
                             |Продолжить действие (не рекомендуется)?';uk= 'УВАГА!
                             |
                             |Виявлена невідповідність між поточним елементом довідника і обраним звітом!
                             |
                             |Продовжити дію (не рекомендується)?'");
		ДополнительныеПараметры = Новый Структура("СвойстваОтчета", СвойстваОтчета);
		ОписаниеОповещения = Новый ОписаниеОповещения("ЗарегистрироватьВнешнийОтчетИспользоватьСТекущейВерсиейКонфигурациейЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет);
	Иначе
		ЗарегистрироватьВнешнийОтчетСоответствиеМеждуСправочникомИОтчетом(СвойстваОтчета);
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура ЗарегистрироватьВнешнийОтчетИспользоватьСТекущейВерсиейКонфигурациейЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	СвойстваОтчета = ДополнительныеПараметры.СвойстваОтчета;
	
	Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда
		ПолноеИмяЗагруженногоВнешнегоОтчета = Неопределено;
		УправлениеЭУ();
	Иначе
		ЗарегистрироватьВнешнийОтчетСоответствиеМеждуСправочникомИОтчетом(СвойстваОтчета);
	КонецЕсли;

КонецПроцедуры


&НаКлиенте
Процедура ЗарегистрироватьВнешнийОтчетСоответствиеМеждуСправочникомИОтчетом(Знач СвойстваОтчета)
	
	// сравнение версий выбранного и хранимого отчетов
	ВерсияХранимогоОтчета = СокрЛП(Объект.ВнешнийОтчетВерсия);
	КраткаяВерсияВнешнегоОтчета = СвойстваОтчета["КраткаяВерсияВнешнегоОтчета"];
	Если ЗначениеЗаполнено(ВерсияХранимогоОтчета) И ЗначениеЗаполнено(КраткаяВерсияВнешнегоОтчета) Тогда
		РезультатСравнениеВерсийХранимогоИЗагружаемогоОтчетов = СравнитьКраткиеВерсииОтчетов(ВерсияХранимогоОтчета, КраткаяВерсияВнешнегоОтчета);
		Если РезультатСравнениеВерсийХранимогоИЗагружаемогоОтчетов = -1 Тогда // если загружаемый отчет старее хранимого
			ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='ВНИМАНИЕ!
                |
                |В информационной базе уже зарегистрирован аналогичный отчет более поздней версии.
                |
                |Версия зарегистрированного отчета: %1
                |Версия выбранного отчета: %2
                |
                |Использование более поздней версии предпочтительнее.
                |
                |Продолжить действие (не рекомендуется)?'
                |;uk='УВАГА!
                |
                |В інформаційній базі вже зареєстровано аналогічний звіт більш пізньої версії.
                |
                |Версія зареєстрованого звіту: %1
                |Версія вибраного звіту: %2
                |
                |Рекомендується використання більш пізньої версії.
                |
                |Продовжити дію (не рекомендується)?'"), ВерсияХранимогоОтчета, КраткаяВерсияВнешнегоОтчета);
			ОписаниеОповещения = Новый ОписаниеОповещения("ЗарегистрироватьВнешнийОтчетСоответствиеМеждуСправочникомИОтчетомЗавершение", ЭтотОбъект);
			ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет);
		Иначе
			ЗарегистрироватьВнешнийОтчетЗагрузкаВнешнегоОтчета();
		КонецЕсли;
	Иначе
		ЗарегистрироватьВнешнийОтчетЗагрузкаВнешнегоОтчета();
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура ЗарегистрироватьВнешнийОтчетСоответствиеМеждуСправочникомИОтчетомЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда
		ПолноеИмяЗагруженногоВнешнегоОтчета = Неопределено;
		УправлениеЭУ();
	Иначе
		ЗарегистрироватьВнешнийОтчетЗагрузкаВнешнегоОтчета();
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура ЗарегистрироватьВнешнийОтчетЗагрузкаВнешнегоОтчета()
	
	// загружаем внешний отчет в справочник
	Состояние(НСтр("ru='Загрузка внешнего отчета...';uk='Завантаження зовнішнього звіту...'")); 
	
	Результат = РегламентированнаяОтчетностьВызовСервера.ЗарегистрироватьВнешнийОтчет(Объект.Ссылка, АдресФайлаВоВременномХранилище);
	
	Если Результат.Свойство("Зарегистрирован") И НЕ Результат["Зарегистрирован"] Тогда 
		ТекстПредупреждения = Неопределено;
		Если Результат.Свойство("ТекстПредупреждения", ТекстПредупреждения) Тогда 
			ПоказатьПредупреждение(,ТекстПредупреждения);
		КонецЕсли;
		ПолноеИмяЗагруженногоВнешнегоОтчета = Неопределено;
		УправлениеЭУ();
	ИначеЕсли Результат["Зарегистрирован"] Тогда
		
		Если Результат.Свойство("ВнешнийОтчетВерсия") Тогда 
			Объект.ВнешнийОтчетВерсия = Результат.ВнешнийОтчетВерсия;
		КонецЕсли;
		Если Результат.Свойство("ВнешнийОтчетИспользовать") Тогда 
			Объект.ВнешнийОтчетИспользовать = Результат.ВнешнийОтчетИспользовать;
		КонецЕсли;
		Если Результат.Свойство("ИсточникОтчета") Тогда 
			Объект.ИсточникОтчета = Результат.ИсточникОтчета;
		КонецЕсли;
		Если Результат.Свойство("Наименование") Тогда 
			Объект.Наименование = Результат.Наименование;
		КонецЕсли;
		Если Результат.Свойство("Описание") Тогда 
			Объект.Описание = Результат.Описание;
		КонецЕсли;
		
		ЭтаФорма.ВнешнийОтчетЗарегистрирован = Истина;
		ИзмененВнешнийОтчетХранилище = Истина;
		УправлениеЭУ();
		
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Функция СравнитьКраткиеВерсииОтчетов(Версия1, Версия2)
	
	// раскладываем версию 1 и преобразуем составляющие к числам
	ЧастиВерсии1 = РегламентированнаяОтчетностьКлиентСервер.РазобратьСтрокуВМассивПоРазделителю(Версия1, ".");
	ЧислоСоставляющихВерсии1 = ЧастиВерсии1.Количество();
	Для Инд = 0 По ЧислоСоставляющихВерсии1 - 1 Цикл
		ЧастьВерсии1 = ЧастиВерсии1[Инд];
		Если НЕ СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(ЧастьВерсии1) Тогда
			Возврат Неопределено;
		КонецЕсли;
		ЧастиВерсии1[Инд] = Число(ЧастьВерсии1);
	КонецЦикла;
	
	// раскладываем версию 2 и преобразуем составляющие к числам
	ЧастиВерсии2 = РегламентированнаяОтчетностьКлиентСервер.РазобратьСтрокуВМассивПоРазделителю(Версия2, ".");
	ЧислоСоставляющихВерсии2 = ЧастиВерсии1.Количество();
	Для Инд = 0 По ЧислоСоставляющихВерсии2 - 1 Цикл
		ЧастьВерсии2 = ЧастиВерсии2[Инд];
		Если НЕ СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(ЧастьВерсии2) Тогда
			Возврат Неопределено;
		КонецЕсли;
		ЧастиВерсии2[Инд] = Число(ЧастьВерсии2);
	КонецЦикла;
	
	// дополняем массив составляющих нулями, уравнивая число составляющих первой и второй версий
	Если ЧислоСоставляющихВерсии1 > ЧислоСоставляющихВерсии2 Тогда
		Для Инд = ЧислоСоставляющихВерсии2 + 1 По ЧислоСоставляющихВерсии1 Цикл
			ЧастиВерсии2.Добавить(0);
		КонецЦикла;
	ИначеЕсли ЧислоСоставляющихВерсии2 > ЧислоСоставляющихВерсии1 Тогда
		Для Инд = ЧислоСоставляющихВерсии1 + 1 По ЧислоСоставляющихВерсии2 Цикл
			ЧастиВерсии1.Добавить(0);
		КонецЦикла;
	КонецЕсли;
	
	// сравниваем по каждому составляющему
	Для Инд = 0 По ЧислоСоставляющихВерсии1 - 1 Цикл
		ЧастьВерсии1 = ЧастиВерсии1[Инд];
		ЧастьВерсии2 = ЧастиВерсии2[Инд];
		Если ЧастьВерсии1 > ЧастьВерсии2 Тогда
			Возврат -1;
		ИначеЕсли ЧастьВерсии1 < ЧастьВерсии2 Тогда
			Возврат 1;
		КонецЕсли;
	КонецЦикла;
	
	Возврат 0;
	
КонецФункции


&НаСервереБезКонтекста
Функция ВнешнийОтчетЗарегистрирован(СсылкаНаОбъект)
	Возврат НЕ СсылкаНаОбъект.ВнешнийОтчетХранилище.Получить() = Неопределено;
КонецФункции


&НаКлиенте
Процедура УправлениеЭУ()
	
	Элементы.ПолеИсточникОтчетаОбъект.Доступность = НЕ Объект.ВнешнийОтчетИспользовать;
	Элементы.ПолеИсточникОтчетаФайл.Доступность = Объект.ВнешнийОтчетИспользовать;
	
	// управляем ЭУ внешнего отчета
	Если Модифицированность И ЗначениеЗаполнено(ПолноеИмяЗагруженногоВнешнегоОтчета) Тогда
		ИсточникОтчетаФайл = ПолноеИмяЗагруженногоВнешнегоОтчета;
	Иначе
		ИсточникОтчетаФайл = ?(ВнешнийОтчетЗарегистрирован, НСтр("ru='Отчет загружен в ИБ';uk='Звіт завантажений в ІБ'"), "");
	КонецЕсли;
	
	ВерсияВнешнегоОтчета = ?(ЗначениеЗаполнено(Объект.ВнешнийОтчетВерсия), СокрЛП(Объект.ВнешнийОтчетВерсия), НСтр("ru='<информация о версии недоступна>';uk='<інформація про версію недоступна>'"));
	Элементы.ПолеИсточникОтчетаФайл.Доступность = Объект.ВнешнийОтчетИспользовать;
	
	Элементы.ВерсияВнешнегоОтчета.Видимость = ВнешнийОтчетЗарегистрирован;
	Элементы.ДекорацияВыгрузить.Видимость = ВнешнийОтчетЗарегистрирован И НЕ ОчиститьХранилищеВнешнегоОтчета;
	
КонецПроцедуры


&НаКлиенте
Процедура ПолеИсточникОтчетаФайлОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если НЕ ВнешнийОтчетЗарегистрирован Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПолеИсточникОтчетаФайлОчисткаЗавершение", ЭтотОбъект);
	ТекстВопроса = НСтр("ru='Удалить хранящийся в информационной базе отчет?';uk='Видалити звіт, що зберігається в інформаційній базі?'");
	ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры


&НаКлиенте
Процедура ПолеИсточникОтчетаФайлОчисткаЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	
	ОчиститьХранилищеВнешнегоОтчета = Истина;
	ЭтаФорма.ВнешнийОтчетЗарегистрирован = Ложь;
	ИзмененВнешнийОтчетХранилище = Истина;
	Модифицированность = Истина;
	УправлениеЭУ();
	
КонецПроцедуры


&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	Если ЗначениеЗаполнено(АдресФайлаВоВременномХранилище) Тогда
		ТекущийОбъект.ВнешнийОтчетХранилище = Новый ХранилищеЗначения(ПолучитьИзВременногоХранилища(АдресФайлаВоВременномХранилище), Новый СжатиеДанных(9));
	ИначеЕсли ОчиститьХранилищеВнешнегоОтчета Тогда 
		ТекущийОбъект.ВнешнийОтчетХранилище = Неопределено;
	КонецЕсли;
КонецПроцедуры


&НаКлиенте
Процедура КомандаЗакрыть(Команда)
	Закрыть();
КонецПроцедуры


&НаКлиенте
Процедура КомандаСохранить(Команда)
	Записать();
	УправлениеЭУ();
КонецПроцедуры


&НаКлиенте
Процедура ПолеИсточникОтчетаФайлНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВыбратьВнешнийОтчет();
	
КонецПроцедуры


// Определяет кэшировалась ли информация для заданного элемента справочника РегламентированныеОтчеты.
// Параметры:
//		РеглОтч - ссылка на элемент справочника РегламентированныеОтчеты.
// Возвращаемое значение:
// 		Булево - Истина - информация кэшировалась,
// 				 Ложь - в противном случае.
&НаСервереБезКонтекста
Функция ОтчетКэшировался(РеглОтч) Экспорт
	
	Возврат (ПараметрыСеанса.ПараметрыВнешнихРегламентированныхОтчетов.Получить(РеглОтч.ИсточникОтчета) <> Неопределено);
	
КонецФункции