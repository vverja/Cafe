
#Область ОбработчикиСобытийФормы


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ПараметрОповещения = Новый Структура("ИмяРегистра", "ФИОФизическихЛиц");
	Оповестить("ИзмененыЛичныеДанные", ПараметрОповещения, Запись.ФизическоеЛицо);
	
КонецПроцедуры

#КонецОбласти
