
// ОК()
//
&НаКлиенте
Процедура ОК(Команда)
	
	ТестированиеДанных = Ложь;

	Если ПустаяСтрока(Фамилия) И ((НЕ ПустаяСтрока(Имя)) Или (НЕ ПустаяСтрока(Отчество))) Тогда
		
		Сообщение = Новый СообщениеПользователю;

		Сообщение.Текст = НСтр("ru='Реквизит ""Фамилия"" не заполнен!';uk='Реквізит ""Прізвище"" не заповнений!'");

		Сообщение.Сообщить();

		ТестированиеДанных = Истина;
		
	КонецЕсли;

	Если НЕ ПустаяСтрока(Фамилия) И ((ПустаяСтрока(Имя)) И (НЕ ПустаяСтрока(Отчество))) Тогда
		
		Сообщение = Новый СообщениеПользователю;

		Сообщение.Текст = НСтр("ru='Реквизит ""Имя"" не заполнен!';uk='Реквізит ""Назва"" не заповнений!'");

		Сообщение.Сообщить();

		ТестированиеДанных = Истина;
		
	КонецЕсли;
    
	Если Найти(Фамилия, ",") > 0 Тогда
		
		Сообщение = Новый СообщениеПользователю;

		Сообщение.Текст = НСтр("ru='В реквизите ""Фамилия"" найден недопустимый символ "",""!';uk='У реквізиті ""Прізвище"" знайдений неприпустимий символ "",""!'");

		Сообщение.Сообщить();

		ТестированиеДанных = Истина;
		
	КонецЕсли;

	Если Найти(Имя, ",") > 0 Тогда
		
		Сообщение = Новый СообщениеПользователю;

		Сообщение.Текст = НСтр("ru='В реквизите ""Имя"" найден недопустимый символ "",""!';uk='У реквізиті ""Ім''я"" знайдений неприпустимий символ "",""!'");

		Сообщение.Сообщить();

		ТестированиеДанных = Истина;
		
	КонецЕсли;

	Если Найти(Отчество, ",") > 0 Тогда
		
		Сообщение = Новый СообщениеПользователю;

		Сообщение.Текст = НСтр("ru='В реквизите ""Отчество"" найден недопустимый символ "",""!';uk='У реквізиті ""По батькові"" знайдений неприпустимий символ "",""!'");

		Сообщение.Сообщить();

		ТестированиеДанных = Истина;
		
	КонецЕсли;

	Если ТестированиеДанных Тогда
		Возврат;
	КонецЕсли;

	ФИО = Новый Структура;
	ФИО.Вставить("Фамилия", Фамилия);
	ФИО.Вставить("Имя", Имя);
	ФИО.Вставить("Отчество", Отчество);
	
	Закрыть(ФИО);
	
КонецПроцедуры // ОК()

// Отмена()
//
&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры // Отмена()