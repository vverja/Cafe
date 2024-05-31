&НаКлиенте
Перем ВыполняетсяЗакрытие;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ТолькоПросмотр = НЕ ПравоДоступа("Изменение", Метаданные.Справочники.СегментыПартнеров);
	
	КоличествоСегментовЗапретаОтгрузки = СегментыСервер.КоличествоСегментовЗапретаОтгрузки();
	ИспользоватьОдинСегментЗапретаОтгрузки = КоличествоСегментовЗапретаОтгрузки = 1;
	НетСегментовЗапретаОтгрузки = КоличествоСегментовЗапретаОтгрузки = 0;
	Партнер = Параметры.Партнер;
	НаименованиеКлиента = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Партнер, "Наименование");
	ПартнеруЗапрещенаОтгрузка = СегментыСервер.ПартнерВходитВСегментыЗапретаОтгрузки(Партнер);
	
	ПравоДоступаСегментыПартнеров = ПравоДоступа("Изменение", Метаданные.Справочники.СегментыПартнеров);
	Элементы.СегментыКлиентов.Видимость = ПравоДоступаСегментыПартнеров;
	
	Если ПартнеруЗапрещенаОтгрузка ТОгда
		Элементы.ГруппаСтраницыЗапрета.ТекущаяСтраница = Элементы.ГруппаОтгрузкаЗапрещена;
	Иначе
		Элементы.ГруппаСтраницыЗапрета.ТекущаяСтраница = Элементы.ГруппаОтгрузкаРазрешена;
	КонецЕсли;
	
	Элементы.ДекорацияНадпись.Заголовок = СтрЗаменить(Элементы.ДекорацияНадпись.Заголовок,"%Клиент%", НаименованиеКлиента);
	Элементы.ДекорацияНадпись1.Заголовок = СтрЗаменить(Элементы.ДекорацияНадпись1.Заголовок,"%Клиент%", НаименованиеКлиента);
	Элементы.ОтгрузкаЗапрещена.ТолькоПросмотр = ТолькоПросмотр;
	Элементы.ТаблицаСегментов.ТолькоПросмотр = ТолькоПросмотр;
	
	Если ИспользоватьОдинСегментЗапретаОтгрузки Тогда
		Элементы.ГруппаСтраницыСегментыЗапретаОтгрузки.ТекущаяСтраница = Элементы.ГруппаСтраницаСегментЗапретаОтгрузки;
		СегментЗапретаОтгрузки = Справочники.СегментыПартнеров.ПолучитьСегментЗапретаОтгрузки();
		ОтгрузкаЗапрещена = ?(ПартнеруЗапрещенаОтгрузка, "Запрещена", "Разрешена");
		СегментФормируетсяВручную = (СегментЗапретаОтгрузки.СпособФормирования 
			= Перечисления.СпособыФормированияСегментов.ФормироватьВручную);
		Элементы.ГруппаЗапретРазрешениеОтгрузки.Видимость = СегментФормируетсяВручную;
		
	ИначеЕсли НетСегментовЗапретаОтгрузки Тогда 
		Элементы.ГруппаСтраницыСегментыЗапретаОтгрузки.ТекущаяСтраница = Элементы.ГруппаСтраницаНетСегментовЗапрета;
	Иначе
		Элементы.ГруппаСтраницыСегментыЗапретаОтгрузки.ТекущаяСтраница = Элементы.ГруппаСтраницаСегментыЗапретаОтгрузки;
		ОбновитьСписокСегментов();
	КонецЕсли;
	
	Если ТолькоПросмотр 
		ИЛИ (ИспользоватьОдинСегментЗапретаОтгрузки И НЕ СегментФормируетсяВручную)
		ИЛИ НетСегментовЗапретаОтгрузки Тогда
		
		Элементы.ФормаКомандаЗаписать.Заголовок = НСтр("ru='ОК';uk='ОК'");
		
	КонецЕсли;

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если НЕ ВыполняетсяЗакрытие и Модифицированность И НЕ СохранитьПараметры Тогда
		
		СписокКнопок = Новый СписокЗначений();
		СписокКнопок.Добавить("Закрыть", НСтр("ru='Закрыть';uk='Закрити'"));
		СписокКнопок.Добавить("НеЗакрывать", НСтр("ru='Не закрывать';uk='Не закривати'"));
		
		Отказ = Истина;
		ПоказатьВопрос(Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект), НСтр("ru='Запрет отгрузки парнеру не будет изменен. Закрыть форму без сохранения результата?';uk='Заборона відвантаження партнеру не буде змінена. Закрити форму без збереження результату?'"), СписокКнопок);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    ОтветНаВопрос = РезультатВопроса;
    
    Если ОтветНаВопрос = "Закрыть" Тогда
        ВыполняетсяЗакрытие = Истина;
		Закрыть();
    КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСегменты

&НаКлиенте
Процедура ТаблицаСегментовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.ТаблицаСегментов.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Если Поле.Имя = "ТаблицаСегментовСегментПартнеров" Тогда
		ПоказатьЗначение(Неопределено, ТекущиеДанные.СегментПартнеров);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаСегментовОтгрузкаОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаСегментовОтгрузкаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ТаблицаСегментов.ТекущиеДанные; 
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Модифицированность = Истина;
	
	Если ТекущиеДанные.Отгрузка = "Разрешена" Тогда
		ТекущиеДанные.ИндексКартинки = 0;
	Иначе
		ТекущиеДанные.ИндексКартинки = 1;
	КонецЕсли;
	
	Если ТаблицаСегментов.Итог("ИндексКартинки") = 0 ТОгда
		Элементы.ГруппаСтраницыЗапрета.ТекущаяСтраница = Элементы.ГруппаОтгрузкаРазрешена;
	Иначе
		Элементы.ГруппаСтраницыЗапрета.ТекущаяСтраница = Элементы.ГруппаОтгрузкаЗапрещена;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОтгрузкаЗапрещенаПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаСегментовПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаСегментовПередУдалением(Элемент, Отказ)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаСегментовПриАктивизацииСтроки(Элемент)
	ТекущиеДанные = Элементы.ТаблицаСегментов.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено
		И ТекущиеДанные.СпособФормирования = ПредопределенноеЗначение("Перечисление.СпособыФормированияСегментов.ПериодическиОбновлять") Тогда
		
		Элементы.СтраницыЗапретаОтгрузки.ТекущаяСтраница = Элементы.СтраницаЗапретаОтгрузки;
		
	Иначе
		
		Элементы.СтраницыЗапретаОтгрузки.ТекущаяСтраница = Элементы.СтраницаЗапретаОтгрузкиПустая;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаЗаписать(Команда)
	
	Если НЕ ТолькоПросмотр Тогда
		ВключитьУдалитьВСегментКлиент();
		СохранитьПараметры = Истина;
	КонецЕсли;
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура СегментыКлиентов(Команда)
	ОткрытьФорму("Справочник.СегментыПартнеров.ФормаСписка");
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаСегментовОтгрузка.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТаблицаСегментов.СпособФормирования");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.СпособыФормированияСегментов.ПериодическиОбновлять;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);

КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокСегментов()

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СегментыПартнеров.Ссылка КАК Сегмент
	|ПОМЕСТИТЬ СегментыПартнеров
	|ИЗ
	|	Справочник.СегментыПартнеров КАК СегментыПартнеров
	|ГДЕ
	|	НЕ СегментыПартнеров.ПометкаУдаления
	|	И СегментыПартнеров.ЗапретОтгрузки
	|
	|СГРУППИРОВАТЬ ПО
	|	СегментыПартнеров.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ПартнерыСегмента.Сегмент,
	|	ПартнерыСегмента.Партнер
	|ПОМЕСТИТЬ ПартнерыСегмента
	|ИЗ
	|	РегистрСведений.ПартнерыСегмента КАК ПартнерыСегмента
	|ГДЕ
	|	ПартнерыСегмента.Партнер = &Партнер
	|
	|СГРУППИРОВАТЬ ПО
	|	ПартнерыСегмента.Сегмент,
	|	ПартнерыСегмента.Партнер
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СегментыПартнеров.Сегмент КАК СегментПартнеров,
	|	СегментыПартнеров.Сегмент.СпособФормирования КАК СпособФормирования,
	|	ВЫБОР
	|		КОГДА ПартнерыСегмента.Партнер = &Партнер
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ВходитВСегмент,
	|	ВЫБОР
	|		КОГДА ПартнерыСегмента.Партнер = &Партнер
	|			ТОГДА ""Запрещена""
	|		ИНАЧЕ ""Разрешена""
	|	КОНЕЦ КАК Отгрузка,
	|	ВЫБОР
	|		КОГДА ПартнерыСегмента.Партнер = &Партнер
	|			ТОГДА 1
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК ИндексКартинки,
	|	СегментыПартнеров.Сегмент.Описание КАК Описание
	|ИЗ
	|	СегментыПартнеров КАК СегментыПартнеров
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПартнерыСегмента КАК ПартнерыСегмента
	|		ПО (ПартнерыСегмента.Сегмент = СегментыПартнеров.Сегмент)";
	
	Запрос.УстановитьПараметр("Партнер", Партнер);
	РезультатЗапроса = Запрос.Выполнить().Выгрузить();
	
	ТаблицаСегментов.Загрузить(РезультатЗапроса);
	
КонецПроцедуры

#Область Прочее

&НаКлиенте
Процедура ВключитьУдалитьВСегментКлиент()
	
	Если ТаблицаСегментов.Количество() = 0 И НЕ ИспользоватьОдинСегментЗапретаОтгрузки Тогда
		Возврат;
	КонецЕсли;
	
	МассивРазрешаемыхСегментов = Новый Массив;
	МассивЗапрещаемыхСегментов = Новый Массив;
	
	Если ИспользоватьОдинСегментЗапретаОтгрузки И ЗначениеЗаполнено(СегментЗапретаОтгрузки)Тогда
		Если ПартнеруЗапрещенаОтгрузка И ОтгрузкаЗапрещена = "Разрешена" Тогда
			МассивРазрешаемыхСегментов.Добавить(СегментЗапретаОтгрузки);
		ИначеЕсли НЕ ПартнеруЗапрещенаОтгрузка И ОтгрузкаЗапрещена = "Запрещена" Тогда
			МассивЗапрещаемыхСегментов.Добавить(СегментЗапретаОтгрузки);
		КонецЕсли;
	ИначеЕсли НЕ ИспользоватьОдинСегментЗапретаОтгрузки Тогда
		Для каждого ТекСтрока Из ТаблицаСегментов Цикл
			
			Если ТекСтрока.ВходитВСегмент И ТекСтрока.Отгрузка = "Разрешена" Тогда
				МассивРазрешаемыхСегментов.Добавить(ТекСтрока.СегментПартнеров);
			ИначеЕсли НЕ ТекСтрока.ВходитВСегмент И ТекСтрока.Отгрузка = "Запрещена" Тогда
				МассивЗапрещаемыхСегментов.Добавить(ТекСтрока.СегментПартнеров);
			Иначе
				Продолжить;
			КонецЕсли;
			
		КонецЦикла;
	КонецЕсли;
	
	Если МассивЗапрещаемыхСегментов.Количество() > 0 ИЛИ МассивРазрешаемыхСегментов.Количество() > 0 Тогда
		
		ВключитьУдалитьВСегментСервер(МассивРазрешаемыхСегментов, МассивЗапрещаемыхСегментов);
		
	КонецЕсли;
	
	Если МассивЗапрещаемыхСегментов.Количество() > 0 Тогда
		Оповестить("ДобавлениеПартнераВСегмент");
	КонецЕсли;
	
	Если МассивРазрешаемыхСегментов.Количество() > 0 Тогда
		Оповестить("УдалениеПартнераИзСегмента");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ВключитьУдалитьВСегментСервер(МассивРазрешаемыхСегментов, МассивЗапрещаемыхСегментов);
	
	Для каждого ЭлементМассива Из МассивРазрешаемыхСегментов Цикл
		
		СегментыСервер.УдалитьПартнераИзСегмента(ЭлементМассива,Партнер);
		
	КонецЦикла;
	
	Для каждого ЭлементМассива Из МассивЗапрещаемыхСегментов Цикл
		
		СегментыСервер.ДобавитьПартнераВСегмент(ЭлементМассива,Партнер);
		
	КонецЦикла;
	
	ОбновитьСписокСегментов();
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

ВыполняетсяЗакрытие = Ложь;