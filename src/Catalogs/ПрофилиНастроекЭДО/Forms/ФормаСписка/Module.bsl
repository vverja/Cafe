
#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОбновитьСостояниеЭД" Тогда
		Элементы.Список.Обновить();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьПомощникПодключенияКСервису1СЭДО(Команда)
	
	ОбменСКонтрагентамиКлиент.ПомощникПодключенияКСервису1СЭДО();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПомощникПодключенияКПрямомуОбмену(Команда)
	
	ОбменСКонтрагентамиКлиент.ПомощникПодключенияКПрямомуОбмену();
	
КонецПроцедуры

#КонецОбласти
