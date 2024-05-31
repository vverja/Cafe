#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Функция УстановитьДополнительныйФайл(Объект) Экспорт
	
	Если Объект.Идентификатор = "СписокНалоговыхИнспекций" Тогда
		
		Попытка
			ПараметрыВыгрузки = Новый Структура;
			ПараметрыВыгрузки.Вставить("ДвоичныеДанныеФайла", Объект.Файл.Получить());
			ПараметрыВыгрузки.Вставить("НеОбновлять", Ложь);
			Обработки.ЗагрузкаНалоговыхИнспекций.ЗагрузитьДанныеГНИ(ПараметрыВыгрузки, Неопределено);
			
			ОбщегоназначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Загрузка налоговых инспекций завершена';uk='Завантаження податкових інспекцій завершено'"));
			Возврат Истина;
		Исключение
			ОбщегоназначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Не удалось загрузить список налоговых инспекций';uk='Не вдалося завантажити список податкових інспекцій'"));
			Возврат Ложь;
		КонецПопытки;	
		
	ИначеЕсли СтрНайти(Объект.Идентификатор, "РегламентированныйОтчет") > 0 Тогда
		
		Если ОбщегоНазначенияПовтИсп.РазделениеВключено() И ОбщегоНазначенияПовтИсп.ДоступноИспользованиеРазделенныхДанных() Тогда
			Возврат Ложь;
		КонецЕсли;
		
		// загружаем внешний отчет в справочник
		
		Отчет = Справочники.РегламентированныеОтчеты.НайтиПоРеквизиту("ИсточникОтчета", Объект.Идентификатор);
		АдресФайлаВоВременномХранилище = ПоместитьВоВременноеХранилище(Объект.Файл.Получить(), Новый УникальныйИдентификатор);
		
		Свойства =  РегламентированнаяОтчетностьВызовСервера.СвойстваВнешнегоОтчета(Отчет, АдресФайлаВоВременномХранилище);
		Если Свойства.ВерсияКонфигурацииВнешнегоОтчета <> Свойства.ВерсияКонфигурацииМетаданные Тогда
			ОбщегоназначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Отчет не предназначен для использования с текущей версией конфигурации!';uk='Звіт не призначений для використання із поточною версією конфігурації!'"));
			Возврат Ложь;
		КонецЕсли;	
		Результат = РегламентированнаяОтчетностьВызовСервера.ЗарегистрироватьВнешнийОтчет(Отчет, АдресФайлаВоВременномХранилище);
		
		Если Результат.Свойство("Зарегистрирован") И НЕ Результат["Зарегистрирован"] Тогда 
			ОбщегоназначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Не удалось зарегистрировать отчет';uk='Не вдалося зареєструвати звіт'"));
			ТекстПредупреждения = Неопределено;
			Если Результат.Свойство("ТекстПредупреждения", ТекстПредупреждения) Тогда 
				ОбщегоназначенияКлиентСервер.СообщитьПользователю(ТекстПредупреждения);
				Возврат Ложь;
			КонецЕсли;
		ИначеЕсли Результат["Зарегистрирован"] Тогда
			
			Попытка
				ОтчетОбъект = Отчет.ПолучитьОбъект();
				
				Если Результат.Свойство("ВнешнийОтчетВерсия") Тогда 
					ОтчетОбъект.ВнешнийОтчетВерсия = Результат.ВнешнийОтчетВерсия;
				КонецЕсли;
				Если Результат.Свойство("ВнешнийОтчетИспользовать") Тогда 
					ОтчетОбъект.ВнешнийОтчетИспользовать = Результат.ВнешнийОтчетИспользовать;
				КонецЕсли;
				Если Результат.Свойство("ИсточникОтчета") Тогда 
					ОтчетОбъект.ИсточникОтчета = Результат.ИсточникОтчета;
				КонецЕсли;
				Если Результат.Свойство("Наименование") Тогда 
					ОтчетОбъект.Наименование = Результат.Наименование;
				КонецЕсли;
				Если Результат.Свойство("Описание") Тогда 
					ОтчетОбъект.Описание = Результат.Описание;
				КонецЕсли;
				
				ОтчетОбъект.ВнешнийОтчетХранилище = Новый ХранилищеЗначения(ПолучитьИзВременногоХранилища(АдресФайлаВоВременномХранилище), Новый СжатиеДанных(9));
				
				ОбщегоназначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Зарегистрирован отчет';uk='Зареєстрований звіт'"));
				
				ОтчетОбъект.Записать();
				Возврат Истина;
			Исключение
				ОбщегоназначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Не удалось зарегистрировать отчет';uk='Не вдалося зареєструвати звіт'"));
				Возврат Ложь;
			КонецПопытки;	
			
		КонецЕсли;
		
	КонецЕсли;	
	
КонецФункции

#КонецЕсли