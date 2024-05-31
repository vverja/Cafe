#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает мобильное приложение, актуальное для указанного пользователя И компьютера
//
// Параметры:
//  ИмяПользователя - Строка - имя пользователя мобильного приложения, для которого требуется получить мобильное приложение
//  КодМобильногоКомпьютера - Строка - код мобильного компьютера, для которого запрашивается мобильное приложение
//  ПараметрыОбменаДанными - Строка - XMl-строка параметров, определенных в мобильном приложении
//   
// Возвращаемое значение
//  Мобильное приложение - Строка, строка, содержащая мобильное приложение
//
Функция ПолучитьМобильноеПриложение(ИмяПользователя, КодМобильногоКомпьютера, ПараметрыОбменаДанными = "") Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	УзелОбмена = МобильныеПриложения.ПолучитьУзелОбменаДляМобильногоПодключения(ИмяПользователя, КодМобильногоКомпьютера);
	
	МобильноеПриложение = УзелОбмена.ВерсияМобильногоПриложения.МобильноеПриложение;
	
	#Если ВнешнееСоединение Тогда
	Если ПустаяСтрока(МобильноеПриложение) Тогда
		ТекстСообщения = НСтр("ru='В информационной базе отсутствует файл мобильного приложения';uk='В інформаційній базі відсутній файл мобільного додатка'");
		ВызватьИсключение(ТекстСообщения);
	КонецЕсли;
	#КонецЕсли

	Возврат МобильноеПриложение;
	
КонецФункции

// Выполняет запись мобильного приложения в виде кодированной строки
//
// Параметры:  
//  ИмяМобильногоПриложения - Строка - имя мобильного приложения
//  ВерсияМобильногоПриложения - Строка - идентификатор версии мобильного приложения
//  МобильноеПриложение - Строка - строка, содержащая файл мобильного приложения
//  ИспользуемыеМетаданные - Строка - строка, содержащая перечень метаданных, используемых мобильным приложением, в виде XML
// 
Процедура ЗаписатьМобильноеПриложение(ИмяМобильногоПриложения, ВерсияМобильногоПриложения, МобильноеПриложение, ИспользуемыеМетаданные) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ПустаяСтрока(ИмяМобильногоПриложения) Тогда
		ТекстСообщения = НСтр("ru='Не указано имя мобильного приложения';uk='Не вказано ім''я мобільного додатка'");
		ВызватьИсключение(ТекстСообщения);
	ИначеЕсли ПустаяСтрока(ВерсияМобильногоПриложения) Тогда
		ТекстСообщения = НСтр("ru='Не указана версия мобильного приложения';uk='Не вказана версія мобільного додатку'");
        ВызватьИсключение(ТекстСообщения);
	КонецЕсли;
	
	ГруппаПриложения = МобильныеПриложения.ПолучитьГруппуПриложения(ИмяМобильногоПриложения);
	
	// Если группа, соответствующая приложению, отсутствует в справочнике - создадим ее
	Если ГруппаПриложения.Пустая() Тогда	
		Объект = Справочники.ВерсииМобильныхПриложений.СоздатьГруппу();
		Объект.Наименование = ИмяМобильногоПриложения;
		Объект.Записать();
		ГруппаПриложения = Объект.Ссылка;
	КонецЕсли;	
	
	// Проверим, нет ли уже данной версии в справочнике
	ЭлементПриложения = МобильныеПриложения.ПолучитьЭлементПриложения(ИмяМобильногоПриложения, ВерсияМобильногоПриложения);
	
	Если ЭлементПриложения.Пустая() Тогда
		Объект = Справочники.ВерсииМобильныхПриложений.СоздатьЭлемент();
		Объект.Родитель = ГруппаПриложения;
		Объект.Код = ВерсияМобильногоПриложения;
		Объект.Наименование = ИмяМобильногоПриложения + ", версия: " + ВерсияМобильногоПриложения;
	Иначе	
		Объект = ЭлементПриложения.ПолучитьОбъект();
	КонецЕсли;
	
	Объект.МобильноеПриложение = МобильноеПриложение;
	Объект.ИспользуемыеМетаданные = ИспользуемыеМетаданные;
	
	Попытка
		Объект.Записать();
	Исключение
		
		ТекстСообщения = ИнформацияОбОшибке().Описание;
		ЗаписьЖурналаРегистрации(НСтр("ru='Ошибка записи мобильного приложения';uk='Помилка запису мобільного додатка'"), УровеньЖурналаРегистрации.Ошибка, , , ТекстСообщения);
		
		ТекстИсключения = НСтр("ru='Ошибка записи мобильного приложения';uk='Помилка запису мобільного додатка'");
		ВызватьИсключение(ТекстИсключения);
		
	КонецПопытки;
	
КонецПроцедуры

// Возвращает данные, выбранные из ИБ в соответствии с заданной для пользователя схемой обмена
//
// Параметры:
//  ИмяПользователя - Строка - имя пользователя мобильного приложения, для которого требуется получить данные ИБ
//  КодМобильногоКомпьютера - Строка - код мобильного компьютера, для которого запрашиваются данные
//  НачальнаяИнициализацияИБ - Булево - признак, указывающий на то, что производится начальная инициализация мобильной ИБ
//  ПараметрыОбменаДанными - Строка - XMl-строка параметров, определенных в мобильном приложении
//   
// Возвращаемое значение
//  Данные - Строка - данные ИБ в виде XMl-строки
//
Функция ПолучитьДанные(ИмяПользователя, КодМобильногоКомпьютера, Знач НачальнаяИнициализацияИБ = Ложь, ПараметрыОбменаДанными = "") Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	УзелОбмена = МобильныеПриложения.ПолучитьУзелОбменаДляМобильногоПодключения(ИмяПользователя, КодМобильногоКомпьютера);
	
	#Если ВнешнееСоединение Тогда
	СтрокаИнициализацииПодключения =НСтр("ru='Для пользователя %ИмяПользователя% и мобильного компьютера %КодМобильногоКомпьютера%';uk='Для користувача %ИмяПользователя% та мобільного комп''ютера %КодМобильногоКомпьютера%'");
	СтрокаИнициализацииПодключения = СтрЗаменить(СтрокаИнициализацииПодключения, "%ИмяПользователя%", ИмяПользователя);
	СтрокаИнициализацииПодключения = СтрЗаменить(СтрокаИнициализацииПодключения, "%КодМобильногоКомпьютера%", КодМобильногоКомпьютера);
	
	Если УзелОбмена.ВерсияМобильногоПриложения.Пустая() Тогда
		ТекстСообщения = НСтр("ru=' не указана используемая версия мобильного приложения';uk=' не вказана використовувана версія мобільного додатку'");
		ВызватьИсключение(СтрокаИнициализацииПодключения + ТекстСообщения);
	КонецЕсли;
	#КонецЕсли
	
	// Если производится начальная инициализация мобильной ИБ, необходимо все данные, удовлетворяющие схеме обмена,
	// пометить как измененные для данного узла обмена
	Если НачальнаяИнициализацияИБ Тогда
		МобильныеПриложения.ЗарегистрироватьИзмененияДанных(УзелОбмена);
	КонецЕсли;
	
	СтруктураПараметровОбменаДанными = МобильныеПриложения.ПолучитьСтруктуруПараметровОбменаДанными(ПараметрыОбменаДанными);
	
	МобильныеПриложения.ПодготовитьДанные(УзелОбмена, СтруктураПараметровОбменаДанными);
	
	Возврат МобильныеПриложения.СформироватьПакетОбмена(УзелОбмена, СтруктураПараметровОбменаДанными, НачальнаяИнициализацияИБ);
	
КонецФункции

// Выполняет запись данных, полученных от мобильного приложения, в текущую ИБ
//
// Параметры:
//  ИмяПользователя - Строка - имя пользователя мобильного приложения, чьи данные необходимо записать
//  КодМобильногоКомпьютера - Строка - код мобильного компьютера, от которого получены данные
//  ДанныеМобильногоПриложения - Строка - строка, содержащая сериализованные в XML данные, полученные от мобильного приложения
//  ПараметрыОбменаДанными - Строка - XMl-строка параметров, определенных в мобильном приложении
// 
Процедура ЗаписатьДанные(ИмяПользователя, КодМобильногоКомпьютера, ДанныеМобильногоПриложения, ПараметрыОбменаДанными = "") Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	УзелОбмена = МобильныеПриложения.ПолучитьУзелОбменаДляМобильногоПодключения(ИмяПользователя, КодМобильногоКомпьютера);
	
	#Если ВнешнееСоединение Тогда
	СтрокаИнициализацииПодключения =НСтр("ru='Для пользователя %ИмяПользователя% и мобильного компьютера %КодМобильногоКомпьютера%';uk='Для користувача %ИмяПользователя% та мобільного комп''ютера %КодМобильногоКомпьютера%'");
	СтрокаИнициализацииПодключения = СтрЗаменить(СтрокаИнициализацииПодключения, "%ИмяПользователя%", ИмяПользователя);
	СтрокаИнициализацииПодключения = СтрЗаменить(СтрокаИнициализацииПодключения, "%КодМобильногоКомпьютера%", КодМобильногоКомпьютера);
	
	Если УзелОбмена.ВерсияМобильногоПриложения.Пустая() Тогда
		ТекстСообщения = НСтр("ru=' не указана используемая версия мобильного приложения';uk=' не вказана використовувана версія мобільного додатку'");
		ВызватьИсключение(СтрокаИнициализацииПодключения + ТекстСообщения);
	КонецЕсли;
	#КонецЕсли

	Попытка
		МобильныеПриложения.ЗаписатьДанныеПолученногоПакетаОбмена(УзелОбмена, ДанныеМобильногоПриложения, ПараметрыОбменаДанными);
	Исключение
		
		ТекстСообщения = ИнформацияОбОшибке().Описание;
		ЗаписьЖурналаРегистрации(НСтр("ru='Ошибка записи данных, полученных от мобильного приложения';uk='Помилка запису даних, отриманих від мобільного додатка'"), УровеньЖурналаРегистрации.Ошибка, , , ТекстСообщения);
		
		#Если ВнешнееСоединение Тогда
		ТекстСообщения = НСтр("ru='Ошибка записи данных';uk='Помилка запису даних'");
		ВызватьИсключение(ТекстСообщения);
		#КонецЕсли
	КонецПопытки;
			
КонецПроцедуры

// Выполняет проверку и возвращает результат проверки, существует ли указанная версия мобильного приложения
//
// Параметры:
//  ИмяМобильного приложения - Строка - имя мобильного приложения, для которого необходимо проверить существование версии
//  ВерсияМобильногоПриложения - Строка - версия мобильного приложения, существование которой необходимо проверить
//   
// Возвращаемое значение
//   Результат - Булево. Истина - если версия существует, Ложь - в противном случае
//
Функция ВерсияМобильногоПриложенияСуществует(ИмяМобильногоПриложения, ВерсияМобильногоПриложения) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ЭлементПриложения = МобильныеПриложения.ПолучитьЭлементПриложения(ИмяМобильногоПриложения, ВерсияМобильногоПриложения);
	
	Если ЭлементПриложения.Пустая() Тогда
		Возврат Ложь;
	Иначе
		Возврат Истина;
	КонецЕсли;	
	
КонецФункции

// Осуществляет отражение в ИБ факта получения данных мобильным клиентом
//
// Параметры:
//  ИмяПользователя - Строка - имя пользователя мобильного приложения, получение данных которого нужно зарегистрировать
//  КодМобильногоКомпьютера - Строка - код мобильного компьютера, получение данных от которого нужно зарегистрировать
//  ПараметрыОбменаДанными - Строка - XMl-строка параметров, определенных в мобильном приложении
//   
Процедура ЗарегистрироватьПолучениеДанных(ИмяПользователя, КодМобильногоКомпьютера, ПараметрыОбменаДанными = "") Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	УзелОбмена = МобильныеПриложения.ПолучитьУзелОбменаДляМобильногоПодключения(ИмяПользователя, КодМобильногоКомпьютера);
	
	ОбъектУзла = УзелОбмена.ПолучитьОбъект();
	
	Попытка
		
		ОбъектУзла.НомерПринятого = ОбъектУзла.НомерОтправленного;
		ОбъектУзла.Записать();
		
		ПланыОбмена.УдалитьРегистрациюИзменений(УзелОбмена, ОбъектУзла.НомерОтправленного);

	Исключение
		
		ТекстСообщения = ИнформацияОбОшибке().Описание;
		ЗаписьЖурналаРегистрации(НСтр("ru='Ошибка при регистрации получения данных от мобильного приложения';uk='Помилка при реєстрації отримання даних від мобільного додатка'"), УровеньЖурналаРегистрации.Ошибка, , , ТекстСообщения);
		
		#Если ВнешнееСоединение Тогда
		ТекстСообщения = НСтр("ru='Ошибка при регистрации получения данных';uk='Помилка при реєстрації отримання даних'");
		ВызватьИсключение(ТекстСообщения);
		#КонецЕсли
	КонецПопытки;
	
КонецПроцедуры

// Выполняет аутентификацию мобильного пользователя
//
// Параметры:
//  ИмяПользователя - Строка - имя пользователя мобильного приложения, получение данных которого нужно зарегистрировать
//  КодМобильногоКомпьютера - Строка - код мобильного компьютера,  аутентификация которого выполняется
//  ПарольПользователя - Строка - пароль мобильного пользователя
//   
// Возвращаемое значение
//  Результат - Булево - результат аутентификации: Истина - аутентификация выполнена, Ложь - аутентификация не выполнена
//
Функция ВыполнитьАутентификацию(ИмяПользователя, КодМобильногоКомпьютера, ПарольПользователя) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);	
	УзелОбмена = МобильныеПриложения.ПолучитьУзелОбменаДляМобильногоПодключения(ИмяПользователя, КодМобильногоКомпьютера);	
	
	Если УзелОбмена.Пустая() ИЛИ УзелОбмена.Пароль <> ПарольПользователя Тогда
		Возврат Ложь;
	Иначе
		Возврат Истина;
	КонецЕсли;

КонецФункции

#КонецОбласти

#КонецЕсли
