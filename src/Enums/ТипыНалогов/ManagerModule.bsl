
Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	УстановитьПривилегированныйРежим(Истина);
	
	МассивИсключаемыхЗначений = Новый Массив;
	
	Если МассивИсключаемыхЗначений.Количество() > 0 Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ОбщегоНазначенияУТВызовСервера.ПолучитьСписокВыбораПеречисления(
			"ТипыНалогов",
			ДанныеВыбора,
			Параметры,
			МассивИсключаемыхЗначений);
		
	КонецЕсли;
	
КонецПроцедуры

