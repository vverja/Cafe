//Переопределяет форму создаваемого объета, с формы объекта на помощник создания обмена
Процедура ПриСозданииПланаОбменаОбработкаПолученияФормы(Источник, ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка) Экспорт
	
	Если ВидФормы = "ФормаОбъекта"    
		И Не Параметры.Свойство("Ключ") Тогда
		
		СтандартнаяОбработка = Ложь;
		
		Если ОбменДаннымиУТУП.ЭтоСозданиеУзлаОбмена(Источник) Тогда
			ВыбраннаяФорма = "Обработка.ПомощникСозданияОбменаДанными.Форма.Форма";
			Параметры.Вставить("ИмяПланаОбмена", Источник.ПустаяСсылка().МетаДанные().Имя);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры