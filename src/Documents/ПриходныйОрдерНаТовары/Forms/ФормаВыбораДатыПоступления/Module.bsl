
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ДатаПоступления = НачалоДня(ТекущаяДата());
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТоварыКПоступлениюОстаткиИОбороты.Период КАК Период,
	|	ТоварыКПоступлениюОстаткиИОбороты.Номенклатура КАК Номенклатура,
	|	ТоварыКПоступлениюОстаткиИОбороты.Характеристика КАК Характеристика,
	|	ТоварыКПоступлениюОстаткиИОбороты.КПоступлениюКонечныйОстаток - ТоварыКПоступлениюОстаткиИОбороты.ПринимаетсяКонечныйОстаток КАК Ожидается
	|ИЗ
	|	РегистрНакопления.ТоварыКПоступлению.ОстаткиИОбороты(
	|			,
	|			,
	|			Регистратор,
	|			Движения,
	|			ДокументПоступления = &Распоряжение
	|				И Склад = &Склад) КАК ТоварыКПоступлениюОстаткиИОбороты
	|ГДЕ
	|	ТоварыКПоступлениюОстаткиИОбороты.КПоступлениюКонечныйОстаток - ТоварыКПоступлениюОстаткиИОбороты.ПринимаетсяКонечныйОстаток > 0
	|	И ТоварыКПоступлениюОстаткиИОбороты.Регистратор <> &ТекущийДокумент
	|
	|УПОРЯДОЧИТЬ ПО
	|	Период УБЫВ
	|ИТОГИ ПО
	|	Номенклатура,
	|	Характеристика";
	
	Запрос.УстановитьПараметр("Распоряжение", Параметры.Распоряжение);
	Запрос.УстановитьПараметр("ТекущийДокумент", Параметры.ТекущийДокумент);
	Запрос.УстановитьПараметр("Склад", Параметры.Склад);
	
	ВыборкаПоНоменклатуре = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	ДатыПоступлений = Новый Соответствие;
	
	Пока ВыборкаПоНоменклатуре.Следующий() Цикл
		
		ВыборкаПоХарактеристикам = ВыборкаПоНоменклатуре.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);

		Пока ВыборкаПоХарактеристикам.Следующий() Цикл
			
			ВыборкаПоДатам = ВыборкаПоХарактеристикам.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			
			ПерваяДатаПоступления = Неопределено;
			
			Пока ВыборкаПоДатам.Следующий() Цикл
				
				Если ВыборкаПоДатам.Ожидается <= 0 Тогда
					Прервать;
				КонецЕсли;
				
				ПерваяДатаПоступления = НачалоДня(ВыборкаПоДатам.Период);
				
				ДатаПоступлений = ДатыПоступлений.Получить(ПерваяДатаПоступления);
				
				Если ДатаПоступлений = Неопределено Тогда
					ДатыПоступлений.Вставить(ПерваяДатаПоступления,0);
				КонецЕсли;
				
			КонецЦикла;
			
			Если ПерваяДатаПоступления <> Неопределено Тогда 
				ДатыПоступлений[ПерваяДатаПоступления] = ДатыПоступлений[ПерваяДатаПоступления] + 1;
			КонецЕсли;
						
		КонецЦикла;
				
	КонецЦикла;
	
	Для Каждого КлючЗначение из ДатыПоступлений Цикл
		
		Элементы.ДатаПоступления.СписокВыбора.Добавить(КлючЗначение.Ключ,Формат(КлючЗначение.Значение,"ЧН=0; ЧГ="));
		
	КонецЦикла;
	
	Элементы.ДатаПоступления.СписокВыбора.СортироватьПоЗначению(НаправлениеСортировки.Возр);
	
	НарастающийИтог = 0;
	
	МассивУдаляемыхЗначений   = Новый Массив;
	НужноДобавитьТекущуюДату  = Ложь;
	ЧислоПозицийНаТекущуюДату = 0;
	
	Для Каждого СтрСп из Элементы.ДатаПоступления.СписокВыбора Цикл
		
		НарастающийИтог = НарастающийИтог + Число(СтрСп.Представление);
		
		Если СтрСп.Значение <= ДатаПоступления Тогда
			МассивУдаляемыхЗначений.Добавить(СтрСп);
			НужноДобавитьТекущуюДату = Истина;
		Иначе
			
			Если НужноДобавитьТекущуюДату Тогда
				ЧислоПозицийНаТекущуюДату = НарастающийИтог;
				НужноДобавитьТекущуюДату  = Ложь;
			КонецЕсли;
			
			ПредставлениеДатыПоступления = НСтр("ru='%Дата% (%Количество% поз.)';uk='%Дата% (%Количество% поз.)'");	
			
			ПредставлениеДатыПоступления = СтрЗаменить(ПредставлениеДатыПоступления,"%Дата%",Формат(СтрСп.Значение,"ДФ=dd.MM.yyyy"));
			ПредставлениеДатыПоступления = СтрЗаменить(ПредставлениеДатыПоступления,"%Количество%",НарастающийИтог);
			
			СтрСп.Представление = ПредставлениеДатыПоступления;
		КонецЕсли;
		
	КонецЦикла;
	
	Если НужноДобавитьТекущуюДату Тогда
		ЧислоПозицийНаТекущуюДату = НарастающийИтог;
	КонецЕсли;
	
	Если ЧислоПозицийНаТекущуюДату <> 0 Тогда
		ПредставлениеДатыПоступления = НСтр("ru='%Дата% (%Количество% поз.)';uk='%Дата% (%Количество% поз.)'");	
		
		ПредставлениеДатыПоступления = СтрЗаменить(ПредставлениеДатыПоступления,"%Дата%",Формат(ДатаПоступления,"ДФ=dd.MM.yyyy"));
		ПредставлениеДатыПоступления = СтрЗаменить(ПредставлениеДатыПоступления,"%Количество%",ЧислоПозицийНаТекущуюДату);
		
		Элементы.ДатаПоступления.СписокВыбора.Вставить(0,  НачалоДня(ДатаПоступления), ПредставлениеДатыПоступления);
		
	КонецЕсли;
	
	Для Каждого СтрМас из МассивУдаляемыхЗначений Цикл
		Элементы.ДатаПоступления.СписокВыбора.Удалить(СтрМас);		
	КонецЦикла;

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	ТекущаяДатаНачалоДня = НачалоДня(ТекущаяДата());
	
	Если ДатаПоступления < ТекущаяДатаНачалоДня Тогда
		ТекстПредупреждения = НСтр("ru='Укажите дату, не меньше текущей даты (%Дата%).';uk='Вкажіть дату, не менше поточної дати (%Дата%).'");
		
		ТекстПредупреждения = СтрЗаменить(ТекстПредупреждения, "%Дата%", Формат(ТекущаяДатаНачалоДня,"ДФ=dd.MM.yyyy"));
		
		ПоказатьПредупреждение(Неопределено, ТекстПредупреждения);
		
		Возврат;	
	КонецЕсли;
		
	Закрыть(ДатаПоступления);
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти
