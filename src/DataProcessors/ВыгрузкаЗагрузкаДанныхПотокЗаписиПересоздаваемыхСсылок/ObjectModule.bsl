#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ВнутренееСостояние

Перем ТекущийКонтейнер;
Перем ТекущийСериализатор;
Перем ТекущиеСсылки;

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Процедура Инициализировать(Контейнер, Сериализатор) Экспорт
	
	ТекущийКонтейнер = Контейнер;
	ТекущийСериализатор = Сериализатор;
	
	ТекущиеСсылки = Новый Массив();
	
КонецПроцедуры

Процедура ПересоздатьСсылкуПриЗагрузке(Знач Ссылка) Экспорт
	
	ТекущиеСсылки.Добавить(Ссылка);
	
	Если ТекущиеСсылки.Количество() > ЛимитСсылокВФайле() Тогда
		ЗаписатьПересоздаваемыеСсылки();
	КонецЕсли;
	
КонецПроцедуры

Процедура Закрыть() Экспорт
	
	ЗаписатьПересоздаваемыеСсылки();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ЛимитСсылокВФайле()
	
	Возврат 34000;
	
КонецФункции

Процедура ЗаписатьПересоздаваемыеСсылки()
	
	Если ТекущиеСсылки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ИмяФайла = ТекущийКонтейнер.СоздатьФайл(ВыгрузкаЗагрузкаДанныхСлужебный.ReferenceRebuilding());
	ВыгрузкаЗагрузкаДанныхСлужебный.ЗаписатьОбъектВФайл(ТекущиеСсылки, ИмяФайла, ТекущийСериализатор);
	
	ТекущиеСсылки.Очистить();
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
