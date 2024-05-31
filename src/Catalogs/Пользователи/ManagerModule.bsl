#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает реквизиты объекта, которые не рекомендуется редактировать
// с помощью обработки группового изменения реквизитов.
//
// Возвращаемое значение:
//  Массив - список имен реквизитов объекта.
Функция РеквизитыНеРедактируемыеВГрупповойОбработке() Экспорт
	
	НеРедактируемыеРеквизиты = Новый Массив;
	НеРедактируемыеРеквизиты.Добавить("Служебный");
	НеРедактируемыеРеквизиты.Добавить("ИдентификаторПользователяИБ");
	НеРедактируемыеРеквизиты.Добавить("ИдентификаторПользователяСервиса");
	НеРедактируемыеРеквизиты.Добавить("СвойстваПользователяИБ");
	
	Возврат НеРедактируемыеРеквизиты;
	
КонецФункции

#КонецОбласти

#КонецЕсли

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	Если НЕ Параметры.Отбор.Свойство("Недействителен") Тогда
		Параметры.Отбор.Вставить("Недействителен", Ложь);
	КонецЕсли;
	
	Если НЕ Параметры.Отбор.Свойство("Служебный") Тогда
		Параметры.Отбор.Вставить("Служебный", Ложь);
	КонецЕсли;
	
КонецПроцедуры

//++ НЕ ГИСМ
// Получает физическое лицо пользователя.
//
// Параметры:
//  Пользователь - СправочникСсылка.Пользователи - ссылка на пользователя
//
// Возвращаемое значение:
//	Структура - физическое лицо пользователя
//
Функция ПолучитьРеквизитыПользователя(Пользователь) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Пользователи.ФизическоеЛицо КАК ФизическоеЛицо,
	|	Пользователи.Подразделение КАК Подразделение
	|ИЗ
	|	Справочник.Пользователи КАК Пользователи
	|ГДЕ
	|	Пользователи.Ссылка = &Пользователь";
	
	Запрос.УстановитьПараметр("Пользователь", Пользователь);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ФизическоеЛицо = Выборка.ФизическоеЛицо;
		Подразделение = Выборка.Подразделение;
	Иначе
		ФизическоеЛицо = Справочники.ФизическиеЛица.ПустаяСсылка();
		Подразделение = Справочники.СтруктураПредприятия.ПустаяСсылка();
	КонецЕсли;
	
	Возврат Новый Структура("ФизическоеЛицо, Подразделение", ФизическоеЛицо, Подразделение);
	
КонецФункции
//-- НЕ ГИСМ

////////////////////////////////////////////////////////////////////////////////
// Загрузка данных из файла

// Запрещает загрузку данных в этот справочник из подсистемы "ЗагрузкаДанныхИзФайла" 
// Пакетная загрузка данных в этот справочник небезопасна
//
Функция ИспользоватьЗагрузкуДанныхИзФайла() Экспорт
	Возврат Ложь;
КонецФункции

#КонецОбласти
