// Работает только если подсистема ИПП выключена из командного интерфейса.
// e1cib/command/Справочник.Новости.Команда.КомандаСписокНовостейДляРедактирования.

// Важно, что подсистема ИнтернетПоддержкаПользователей должна быть включена в командный интерфейс (хотя может быть и не видна).
// Иначе будет ошибка при вызове этой команды.
// При изменении наименования подсистемы ИнтернетПоддержкаПользователей, необходимо изменить ссылки и здесь.
// НЕ работает, если подсистема ИПП выключена из командного интерфейса.
// e1cib/navigationpoint/ИнтернетПоддержкаПользователей/Справочник.Новости.Команда.КомандаСписокНовостейДляРедактирования.

#Область ПрограммныйИнтерфейс
#КонецОбласти

#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)

	ПараметрыФормы = Новый Структура;
	Форма = ОткрытьФорму(
		"Справочник.Новости.Форма.ФормаСпискаДляРедактирования",
		ПараметрыФормы,
		Неопределено,
		""); // Уникальность

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
#КонецОбласти

