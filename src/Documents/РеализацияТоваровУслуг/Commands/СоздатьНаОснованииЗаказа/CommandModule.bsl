
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыОткрытия = ПараметрыОткрытияФормы(ПараметрКоманды);
	Если ПараметрыОткрытия = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОткрытьФорму(
		"Документ.РеализацияТоваровУслуг.Форма.ФормаДокумента",
		ПараметрыОткрытия,
		ПараметрыВыполненияКоманды.Источник,
		ПараметрыВыполненияКоманды.Уникальность,
		ПараметрыВыполненияКоманды.Окно,
		ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	
КонецПроцедуры

&НаСервере
Функция ПараметрыОткрытияФормы(ПараметрКоманды)
	
	ПараметрыОснования = Новый Структура;
	ПараметрыОснования.Вставить("СкладОтгрузки", 			Неопределено);
	ПараметрыОснования.Вставить("ВариантОформленияПродажи", Перечисления.ВариантыОформленияПродажи.РеализацияТоваровУслуг);
	
	Если ПараметрКоманды.Количество() = 1
	 ИЛИ НЕ ПолучитьФункциональнуюОпцию("ИспользоватьРеализациюПоНесколькимЗаказам") Тогда
		
		ПараметрыОснования.Вставить("ДокументОснование", ПараметрКоманды[0]);
		
	Иначе
		
		РеквизитыШапки = Новый Структура;
		Если НЕ ПродажиВызовСервера.СформироватьДанныеЗаполненияРеализации(ПараметрКоманды, РеквизитыШапки) Тогда
			Возврат Неопределено;
		КонецЕсли;
		
		ПараметрыОснования.Вставить("РеквизитыШапки",      РеквизитыШапки);
		ПараметрыОснования.Вставить("ДокументОснование",   ПараметрКоманды);
		
	КонецЕсли;
	
	Возврат Новый Структура("Основание", ПараметрыОснования);
	
КонецФункции
