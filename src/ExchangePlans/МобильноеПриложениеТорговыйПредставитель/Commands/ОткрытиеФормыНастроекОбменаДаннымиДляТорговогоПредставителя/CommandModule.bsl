
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("НеОтображатьЭтотУзел", Истина);
	
	ОткрытьФорму("ПланОбмена.МобильноеПриложениеТорговыйПредставитель.ФормаСписка", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры
