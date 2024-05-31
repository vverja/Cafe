#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	АдресСервиса = Константы.АдресВебСервиса1СДокументооборот.Получить();
	ЭтоПользовательЗаданияОбмена = ИнтеграцияС1СДокументооборотВызовСервера.ЭтоПользовательЗаданияОбмена();
	
#Если Не ВебКлиент Тогда
	// Добавим в список выбора имя пользователя ИС.
	ПользовательИБ = ПользователиИнформационнойБазы.ТекущийПользователь();
	Элементы.ИмяПользователя.СписокВыбора.Добавить(ПользовательИБ.Имя);
	Элементы.ИмяПользователя.КнопкаВыпадающегоСписка = Истина;
#КонецЕсли

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	ПарольСохранен = Ложь;
	ИнтеграцияС1СДокументооборотКлиент.ПрочитатьНастройкиАвторизации(
		ИмяПользователя, ПарольСохранен, Пароль);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	ТекстСообщенияОбОшибке = "";
	Если ИнтеграцияС1СДокументооборотВызовСервера.ПроверитьПодключение(АдресСервиса, 
		ИмяПользователя, Пароль, ТекстСообщенияОбОшибке) Тогда
		Если ЭтоПользовательЗаданияОбмена Тогда
			ИнтеграцияС1СДокументооборотВызовСервера.СохранитьНастройкиАвторизацииДляОбмена(ИмяПользователя, Пароль);
		КонецЕсли;
		ИнтеграцияС1СДокументооборотКлиент.СохранитьНастройкиАвторизации(ИмяПользователя, Пароль);
		ИнтеграцияС1СДокументооборотВызовСервера.УстановитьВерсиюСервисаВПараметрыСеанса();
		Закрыть(Истина);
		Оповестить("ИнтеграцияС1СДокументооборотом_УспешноеПодключение", , ВладелецФормы);
	Иначе
		ОписаниеОповещения = Новый ОписаниеОповещения("ОКЗавершение", ЭтотОбъект, ТекстСообщенияОбОшибке);
		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить("ОК", "ОК");
		Кнопки.Добавить("Подробнее", "Подробнее...");
		ПоказатьВопрос(ОписаниеОповещения, НСтр("ru='Не удалось подключиться к Документообороту с указанным
            |именем пользователя и паролем. Если вы уверены в их 
            |правильности, обратитесь к администратору.'
            |;uk='Не вдалося підключитися до Документообігу із зазначеним
            |ім''ям користувача і паролем. Якщо ви впевнені в їх 
            |правильності, зверніться до адміністратора.'"), Кнопки);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОКЗавершение(Результат, ТекстСообщенияОбОшибке) Экспорт

	Если Результат = "Подробнее" Тогда
		ПоказатьПредупреждение(, ТекстСообщенияОбОшибке);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти