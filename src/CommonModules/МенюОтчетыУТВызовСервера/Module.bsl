
#Область ПрограммныйИнтерфейс

Функция ОписаниеКомандыОтчет(ИмяКоманды, АдресКомандОтчетовВоВременномХранилище) Экспорт
	
	Возврат МенюОтчеты.ОписаниеКомандыОтчет(ИмяКоманды, АдресКомандОтчетовВоВременномХранилище);
	
КонецФункции

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

#Область СостояниеВыполненияДокументов

Функция ПроверитьСписокДокументов(МассивДокументов) Экспорт 
	
	СоотвествиеТипов = ОбщегоНазначенияУТ.СоответствиеМассивовПоТипамОбъектов(МассивДокументов);
	Возврат СоотвествиеТипов.Количество() = 1;
	
КонецФункции

#КонецОбласти

#Область СравнениеГрафиковКредитовИДепозитов

Функция ВладелецГрафика(ВариантГрафика) Экспорт
	
	Возврат ВариантГрафика.Владелец;
	
КонецФункции

#КонецОбласти

#КонецОбласти