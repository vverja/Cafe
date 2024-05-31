
#Область ПрограммныйИнтерфейс

Процедура ОбъектНеНайден(Штрихкод, ИскатьПоВсемОбъектам = Истина) Экспорт
	
	ВывестиСообщениеОбъектНеНайден = Истина;
	
	Если ИскатьПоВсемОбъектам Тогда
		Состояние(НСтр("ru='Выполняется поиск документа по штрихкоду во всех документах информационной базы..';uk='Виконується пошук документа за штрихкодом у всіх документах інформаційної бази..'"));
		МассивСсылок = ШтрихкодированиеПечатныхФормВызовСервера.ПолучитьСсылкуПоШтрихкодуТабличногоДокумента(Штрихкод);
		Если МассивСсылок.Количество() > 0 Тогда
			ВывестиСообщениеОбъектНеНайден = Ложь;
			ПоказатьЗначение(,МассивСсылок[0]);
		КонецЕсли;
	КонецЕсли;
	
	Если ВывестиСообщениеОбъектНеНайден Тогда
		ОчиститьСообщения();
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Объект со штрихкодом %1 не найден';uk='Об''єкт зі штрихкодом %1 не знайдений'"), Штрихкод));
	КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьСсылкуПоШтрихкодуТабличногоДокумента(Штрихкод, Менеджеры = Неопределено) Экспорт
	
	Состояние(НСтр("ru='Выполняется поиск документа по штрихкоду...';uk='Виконується пошук документа за штрихкодом...'"));
	Возврат ШтрихкодированиеПечатныхФормВызовСервера.ПолучитьСсылкуПоШтрихкодуТабличногоДокумента(Штрихкод, Менеджеры);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти
