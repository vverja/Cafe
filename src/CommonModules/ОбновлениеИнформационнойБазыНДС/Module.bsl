////////////////////////////////////////////////////////////////////////////////
// Обновление информационной базы НДС.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область ТекстыЗапросовОбработчиковОбновления

// Метод возвращает текст запроса, который используется
// для отложенного проведения по регистрам. Вызывается из метода
// ТекстЗапросаДанных модуля ОтложенноеОбновлениеИБ. Данный текст
// используется для проведения документов по регистрам "Парти прочих расходов"
// и "Прочие расходы" при переходе на ред. 11.1
Функция ТекстОбработчиковОбновления() Экспорт
	
	
	ТекстЗапроса = "";
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции


#Область ОбновлениеИнформационнойБазы

#КонецОбласти

#КонецОбласти