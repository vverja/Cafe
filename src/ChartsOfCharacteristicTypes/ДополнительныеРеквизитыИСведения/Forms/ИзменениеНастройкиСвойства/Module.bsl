#Область ОписаниеПеременных

&НаКлиенте
Перем ПараметрыДлительнойОперацииКлиент;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	Если Параметры.ЭтоДополнительноеСведение Тогда
		Элементы.ТипыСвойства.ТекущаяСтраница = Элементы.Сведение;
		Заголовок = НСтр("ru='Изменить настройку дополнительного сведения';uk='Змінити настройки додаткової відомості'");
	Иначе
		Элементы.ТипыСвойства.ТекущаяСтраница = Элементы.Реквизит;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.НаборСвойств) Тогда
		Элементы.ВидыРеквизита.ТекущаяСтраница = Элементы.ВидОбщиеЗначенияРеквизитов;
		Элементы.ВидыСведения.ТекущаяСтраница  = Элементы.ВидОбщиеЗначенияСведений;
		
		Если ЗначениеЗаполнено(Параметры.ВладелецДополнительныхЗначений) Тогда
			ОтдельноеСвойствоСОбщимСпискомЗначений = 1;
		Иначе
			ОтдельноеСвойствоСОтдельнымСпискомЗначений = 1;
		КонецЕсли;
	Иначе
		Элементы.ВидыРеквизита.ТекущаяСтраница = Элементы.ВидОбщийРеквизит;
		Элементы.ВидыСведения.ТекущаяСтраница  = Элементы.ВидОбщееСведение;
		
		ОбщееСвойство = 1;
	КонецЕсли;
	
	Свойство = Параметры.Свойство;
	ТекущийНаборСвойств = Параметры.ТекущийНаборСвойств;
	ЭтоДополнительноеСведение = Параметры.ЭтоДополнительноеСведение;
	
	Элементы.ОтдельныеЗначенияРеквизитаКомментарий.Заголовок =
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Элементы.ОтдельныеЗначенияРеквизитаКомментарий.Заголовок, ТекущийНаборСвойств);
	
	Элементы.ОбщиеЗначенияРеквизитовКомментарий.Заголовок =
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Элементы.ОбщиеЗначенияРеквизитовКомментарий.Заголовок, ТекущийНаборСвойств);
	
	Элементы.ОтдельныеЗначенияСведенияКомментарий.Заголовок =
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Элементы.ОтдельныеЗначенияСведенияКомментарий.Заголовок, ТекущийНаборСвойств);
	
	Элементы.ОбщиеЗначенияСведенийКомментарий.Заголовок =
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Элементы.ОбщиеЗначенияСведенийКомментарий.Заголовок, ТекущийНаборСвойств);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("ЗаписатьИЗакрытьЗавершение", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВидПриИзменении(Элемент)
	
	ВидПриИзмененииНаСервере(Элемент.Имя);
	
КонецПроцедуры

&НаСервере
Процедура ВидПриИзмененииНаСервере(ИмяЭлемента)
	
	ОтдельноеСвойствоСОбщимСпискомЗначений = 0;
	ОтдельноеСвойствоСОтдельнымСпискомЗначений = 0;
	ОбщееСвойство = 0;
	
	ЭтотОбъект[Элементы[ИмяЭлемента].ПутьКДанным] = 1;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	ЗаписатьИЗакрытьЗавершение();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗаписатьИЗакрытьЗавершение(Результат = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если ОтдельноеСвойствоСОтдельнымСпискомЗначений = 1 Тогда
		ЗаписатьНачало();
	Иначе
		ЗаписатьЗавершение(Неопределено);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьНачало()
	
	Состояние(НСтр("ru='Выполняется изменение настройки свойства. Пожалуйста, подождите';uk='Виконується зміна настройки властивості. Будь ласка, почекайте'"));
	
	ОткрытьСвойство = ЗаписатьНаСервере();
	
	Если ОткрытьСвойство <> NULL Тогда
		ЗаписатьЗавершение(ОткрытьСвойство);
	Иначе
		ПараметрыДлительнойОперацииКлиент = Новый Структура;
		ПараметрыДлительнойОперацииКлиент.Вставить("ПараметрыОбработчикаОжидания");
		
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(
			ПараметрыДлительнойОперацииКлиент.ПараметрыОбработчикаОжидания);
		
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьИзменениеНастройкиСвойства",
			ПараметрыДлительнойОперацииКлиент.ПараметрыОбработчикаОжидания.МинимальныйИнтервал, Истина);
		
		ПараметрыДлительнойОперацииКлиент.Вставить("ФормаДлительнойОперации",
			ДлительныеОперацииКлиент.ОткрытьФормуДлительнойОперации(
				ЭтотОбъект, ПараметрыДлительнойОперации.ИдентификаторЗадания));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьИзменениеНастройкиСвойства()
	
	Результат = NULL;
	
	Попытка
		Если ПараметрыДлительнойОперацииКлиент.ФормаДлительнойОперации.Открыта()
		   И ПараметрыДлительнойОперацииКлиент.ФормаДлительнойОперации.ИдентификаторЗадания
		         = ПараметрыДлительнойОперации.ИдентификаторЗадания Тогда
			
			Результат = ЗаданиеВыполнено(ПараметрыДлительнойОперации);
			Если Результат = NULL Тогда
				
				ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(
					ПараметрыДлительнойОперацииКлиент.ПараметрыОбработчикаОжидания);
				
				ПодключитьОбработчикОжидания(
					"Подключаемый_ПроверитьИзменениеНастройкиСвойства",
					ПараметрыДлительнойОперацииКлиент.ПараметрыОбработчикаОжидания.ТекущийИнтервал,
					Истина);
			Иначе
				ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(
					ПараметрыДлительнойОперацииКлиент.ФормаДлительнойОперации);
			КонецЕсли;
		КонецЕсли;
	Исключение
		ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(
			ПараметрыДлительнойОперацииКлиент.ФормаДлительнойОперации);
		ВызватьИсключение;
	КонецПопытки;
	
	Если Результат <> NULL Тогда
		ЗаписатьЗавершение(Результат);
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ПараметрыДлительнойОперации)
	
	Если ДлительныеОперации.ЗаданиеВыполнено(ПараметрыДлительнойОперации.ИдентификаторЗадания) Тогда
		Возврат ПолучитьИзВременногоХранилища(ПараметрыДлительнойОперации.АдресХранилища);
	КонецЕсли;
	
	Возврат NULL;
	
КонецФункции

&НаКлиенте
Процедура ЗаписатьЗавершение(ОткрытьСвойство)
	
	Модифицированность = Ложь;
	
	Оповестить("Запись_ДополнительныеРеквизитыИСведения",
		Новый Структура("Ссылка", Свойство), Свойство);
	
	Оповестить("Запись_НаборыДополнительныхРеквизитовИСведений",
		Новый Структура("Ссылка", ТекущийНаборСвойств), ТекущийНаборСвойств);
	
	ОповеститьОВыборе(ОткрытьСвойство);
	
КонецПроцедуры

&НаСервере
Функция ЗаписатьНаСервере()
	
	ПараметрыПроцедуры = Новый Структура;
	ПараметрыПроцедуры.Вставить("Свойство", Свойство);
	ПараметрыПроцедуры.Вставить("ТекущийНаборСвойств", ТекущийНаборСвойств);
	
	НаименованиеЗадания = НСтр("ru='Изменение настройки дополнительного свойства';uk='Зміна настройки додаткової властивості'");
	
	Результат = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
		УникальныйИдентификатор,
		"ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.ИзменитьНастройкуСвойства",
		ПараметрыПроцедуры,
		НаименованиеЗадания);
		
	Если Результат.ЗаданиеВыполнено Тогда
		Возврат ПолучитьИзВременногоХранилища(Результат.АдресХранилища);
	КонецЕсли;
	
	ПараметрыДлительнойОперации = Результат;
	
	Возврат NULL;
	
КонецФункции

#КонецОбласти
