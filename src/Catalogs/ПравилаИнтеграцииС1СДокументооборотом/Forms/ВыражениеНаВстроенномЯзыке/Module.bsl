
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("ВычисляемоеВыражение", ВычисляемоеВыражение);
	Параметры.Свойство("ТипВыражения", ТипВыражения);
	
	Инструкция = "<html>
	|<style type=""text/css"">
	|	body {
	|		overflow:    auto;
	|		margin-top:  12px; 		 
	|		margin-left: 20px; 
	|		font-family: MS Shell Dlg, Microsoft Sans Serif, sans-serif; 
	|		font-size:   8pt;}
	|	table {
	|		width:       270px;  
	|		font-family: MS Shell Dlg, Microsoft Sans Serif, sans-serif; 
	|		font-size:   8pt;}
	|	td {vertical-align: top;}
	|	p {
	|		margin-top: 7px;}
	|</style>
	|<body>";
	
	Если ТипВыражения = "ПравилоВыгрузки"
		Или ТипВыражения = "ПравилоЗагрузки" Тогда
		
		Заголовок = НСтр("ru='Выражение на встроенном языке';uk='Вираз вбудованою мовою'");
		
		Инструкция = Инструкция + "<p>" + 
			НСтр("ru='Результат вычисления выражения на встроенном языке платформы
            |должен присваиваться переменной <b>Результат</b>.'
            |;uk='Результат обчислення виразу на вбудованій мові платформи
            |повинен присвоюватися змінній <b>Результат</b>.'");
		
	ИначеЕсли ТипВыражения = "УсловиеПрименимостиПриВыгрузке" Тогда
			
		Заголовок = НСтр("ru='Условие применимости правила';uk='Умова застосування правила'");
		
		Инструкция = Инструкция + "<p>" + 
			НСтр("ru='Выражение на встроенном языке платформы определяет
            |применимость правила при создании объекта Документооборота на основании 
            |объекта этой конфигурации. Результат вычисления должен присваиваться переменной
            |<b>Результат</b>. <b>Истина</b> означает применимость правила, <b>Ложь</b> – неприменимость.
            |Выражение проверяется только для правил, подходящих по значениям ключевых реквизитов.
            |</p><p>Значение по умолчанию: <b>Истина</b>.'
            |;uk='Вираз на вбудованій мові платформи визначає
            |застосовність правила при створенні об''єкта Документообігу на підставі 
            |об''єкта цієї конфігурації. Результат обчислення повинен присвоюватися змінної
            |<b>Результат</b>. <b>Істина</b> означає застосовність правила, <b>Хибність</b> – незастосовність.
            |Вираз перевіряється тільки для правил, відповідних за значенням ключових реквізитів.
            |</p><p>Значення по умовчанню: <b>True</b>.'") + "<p>";
		
	ИначеЕсли ТипВыражения = "УсловиеПрименимостиПриЗагрузке" Тогда
		
		Заголовок = НСтр("ru='Условие применимости правила';uk='Умова застосування правила'");
		
		Инструкция = Инструкция + "<p>" + 
			НСтр("ru='Выражение на встроенном языке платформы определяет
            |применимость правила при создании объекта этой конфигурации на основании 
            |объекта Документооборота. Результат вычисления должен присваиваться переменной
            |<b>Результат</b>. <b>Истина</b> означает применимость правила, <b>Ложь</b> – неприменимость.
            |Выражение проверяется только для правил, подходящих по значениям ключевых реквизитов.
            |</p><p>Значение по умолчанию: <b>Истина</b>.'
            |;uk='Вираз на вбудованій мові платформи визначає
            |застосовність правила при створенні об''єкта цієї конфігурації на підставі 
            |об''єкта Документообігу. Результат обчислення повинен присвоюватися змінної
            |<b>Результат</b>. <b>Істина</b> означає застосовність правила, <b>Хибність</b> – незастосовність.
            |Вираз перевіряється тільки для правил, відповідних за значенням ключових реквізитів.
            |</p><p>Значення по умовчанню: <b>True</b>.'") + "<p>";
		
	КонецЕсли;
	
	Инструкция = Инструкция + " " + НСтр("ru='К реквизитам объекта';uk='До реквізитів об''єкта'") + " ";
	
	Если ТипВыражения = "ПравилоЗагрузки"
		Или ТипВыражения = "УсловиеПрименимостиПриЗагрузке" Тогда
		
		Инструкция = Инструкция + НСтр("ru='Документооборота';uk='Документообігу'");
		СоставРеквизитов = Справочники.ПравилаИнтеграцииС1СДокументооборотом.
			ПолучитьРеквизитыОбъектаДокументооборота(Параметры.ТипОбъектаДокументооборота);
		
		// Дополним реквизиты состояниями.
		Если Параметры.ТипОбъектаДокументооборота <> "DMCorrespondent" 
			И ИнтеграцияС1СДокументооборотПовтИсп.ДоступенФункционалВерсииСервиса("1.3.2.3.CORP") Тогда
			СоставСостояний = Справочники.ПравилаИнтеграцииС1СДокументооборотом.
				ВозможныеСостоянияОбъектаДокументооборота();
			Для каждого СтрокаСостояния из СоставСостояний Цикл
				СтрокаРеквизита = СоставРеквизитов.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаРеквизита, СтрокаСостояния);
			КонецЦикла;
		КонецЕсли;
		
	Иначе // ПравилоВыгрузки, УсловиеПрименимостиПриВыгрузке
		
		Инструкция = Инструкция + НСтр("ru='этой конфигурации';uk='цієї конфігурації'");
		СоставРеквизитов = Справочники.ПравилаИнтеграцииС1СДокументооборотом.
			ПолучитьРеквизитыОбъектаПотребителя(Параметры.ТипОбъектаПотребителя);
			
	КонецЕсли;
		
	Инструкция = Инструкция + " " + 
		НСтр("ru='можно обращаться через переменную <b>Источник</b>.
        |Реквизиты источника:'
        |;uk='можна звертатися через змінну <b>Джерело</b>.
        |Реквізити джерела:'") 
		+ "</p><table>";
		
	СоставРеквизитов.Сортировать("Имя");
	
	Для каждого СтруктураРеквизита из СоставРеквизитов Цикл
		
		// Отбросим доп. реквизиты.
		Если (ТипВыражения = "ПравилоЗагрузки"
			Или ТипВыражения = "УсловиеПрименимостиПриЗагрузке")
			И СтруктураРеквизита.ДопРеквизит Тогда
			Продолжить;
		КонецЕсли;
		
		Инструкция = Инструкция + "<tr>";
		Если ТипЗнч(СтруктураРеквизита.Тип) = Тип("СписокЗначений")
			И СтруктураРеквизита.Тип.Количество() > 0
			И Лев(СтруктураРеквизита.Тип[0], 2) = "DM" Тогда
			Инструкция = Инструкция + "<td><a href=""#" + СтруктураРеквизита.Тип[0] + """>" 
				+ СтруктураРеквизита.Имя + "</a></td>";
		Иначе
			Инструкция = Инструкция + "<td>" + СтруктураРеквизита.Имя + "</td>";
		КонецЕсли;
		Если СтруктураРеквизита.Представление <> СтруктураРеквизита.Имя Тогда
			Инструкция = Инструкция + "<td>" + СтруктураРеквизита.Представление + "</td>";
		КонецЕсли;
		Инструкция = Инструкция + "</tr>";
		
	КонецЦикла;
	
	Инструкция = Инструкция + "</table>";
	
	Инструкция = Инструкция + "</body></html>";
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОчистить(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("КомандаОчиститьЗавершение", ЭтаФорма);
	ТекстВопроса = НСтр("ru='Вы действительно хотите очистить введенное выражение?';uk='Ви дійсно хочете очистити введений вираз?'");
	ИнтеграцияС1СДокументооборотКлиент.ПоказатьВопросДаНет(ОписаниеОповещения, ТекстВопроса);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОК(Команда)
	
	Закрыть(ВычисляемоеВыражение);
	
КонецПроцедуры

&НаКлиенте
Процедура РеквизитыПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если Не ЗначениеЗаполнено(ДанныеСобытия.HRef) Тогда
		Возврат;
	КонецЕсли;
	
	Позиция = СтрНайти(ДанныеСобытия.HRef, "#", НаправлениеПоиска.СКонца);
	Ссылка = Сред(ДанныеСобытия.HRef, Позиция + 1);
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Ссылка", Ссылка);
	
	ОткрытьФорму("Справочник.ПравилаИнтеграцииС1СДокументооборотом.Форма.ОписаниеВебСервисов", 
		ПараметрыФормы, ЭтаФорма,,,,, РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОчиститьЗавершение(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		Закрыть("");
	КонецЕсли;
	
КонецПроцедуры
