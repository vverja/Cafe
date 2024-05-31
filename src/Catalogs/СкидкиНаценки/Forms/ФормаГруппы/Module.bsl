
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	// Обработчик подсистемы запрета редактирования реквизитов объектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);
	
	Элементы.Наименование.ОтметкаНезаполненного = Ложь;
	
	Если Объект.Ссылка = Справочники.СкидкиНаценки.КорневаяГруппа Тогда
		Элементы.Родитель.Видимость = Ложь;
	КонецЕсли;
	
	ПриСозданииЧтенииНаСервере();

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриСозданииЧтенииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// Обработчик подсистемы запрета редактирования реквизитов объектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВариантСовместногоПримененияСкидокНаценокПриИзменении(Элемент)
	
	ОбновитьЭлементыФормы(ЭтаФорма, Описание);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)
	
	ОбщегоНазначенияУТКлиент.РазрешитьРедактированиеРеквизитовОбъекта(ЭтаФорма);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьЭлементыФормы(Форма, Описание)
	
	Если Форма.Объект.ВариантСовместногоПрименения = ПредопределенноеЗначение("Перечисление.ВариантыСовместногоПримененияСкидокНаценок.Максимум") Тогда
		Описание = НСтр("ru='Применяется одна наибольшая скидка внутри группы';uk='Застосовується одна найбільша знижка всередині групи'");
		Форма.Элементы.ВариантРасчетаРезультатаСовместногоПрименения.Видимость = Истина;
	ИначеЕсли Форма.Объект.ВариантСовместногоПрименения = ПредопределенноеЗначение("Перечисление.ВариантыСовместногоПримененияСкидокНаценок.Минимум") Тогда
		Описание = НСтр("ru='Применяется одна наименьшая скидка внутри группы';uk='Застосовується одна найменша знижка всередині групи'");
		Форма.Элементы.ВариантРасчетаРезультатаСовместногоПрименения.Видимость = Истина;
	ИначеЕсли Форма.Объект.ВариантСовместногоПрименения = ПредопределенноеЗначение("Перечисление.ВариантыСовместногоПримененияСкидокНаценок.Вытеснение") Тогда
		Описание = НСтр("ru='При совместном действии скидок (наценок) в одной группе будет действовать только та скидка, которая имеет наивысший приоритет в группе';uk='При спільній дії знижок (націнок) в одній групі буде діяти тільки та знижка, яка має найвищий пріоритет в групі'");
		Форма.Элементы.ВариантРасчетаРезультатаСовместногоПрименения.Видимость = Истина;
	ИначеЕсли Форма.Объект.ВариантСовместногоПрименения = ПредопределенноеЗначение("Перечисление.ВариантыСовместногоПримененияСкидокНаценок.Сложение") Тогда
		Описание = НСтр("ru='Применяется сумма всех скидок внутри группы';uk='Застосовується сума всіх знижок всередині групи'");
		Форма.Элементы.ВариантРасчетаРезультатаСовместногоПрименения.Видимость = Ложь;
	ИначеЕсли Форма.Объект.ВариантСовместногоПрименения = ПредопределенноеЗначение("Перечисление.ВариантыСовместногоПримененияСкидокНаценок.Умножение") Тогда
		Описание = НСтр("ru='Скидки применяются последовательно в порядке приоритета внутри группы';uk='Знижки застосовуються послідовно в порядку пріоритету всередині групи'");
		Форма.Элементы.ВариантРасчетаРезультатаСовместногоПрименения.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииЧтенииНаСервере()
	
	ОбновитьЭлементыФормы(ЭтаФорма, Описание);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
