
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ ЭлектронноеВзаимодействиеПереопределяемый.ЕстьПравоОткрытияЖурналаРегистрации() Тогда
		ТекстСообщения = НСтр("ru='Недостаточно прав для просмотра журнала регистрации.';uk='Недостатньо прав для перегляду журналу реєстрації.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , , , Отказ);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти
