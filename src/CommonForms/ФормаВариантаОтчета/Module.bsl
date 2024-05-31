////////////////////////////////////////////////////////////////////////////////
// Стандартный функционал

#Область СтандартныйФункционал

&НаКлиенте
Процедура ПоляГруппировкиНедоступны()
	
	Элементы.СтраницыПолейГруппировки.ТекущаяСтраница = Элементы.НедоступныеНастройкиПолейГруппировки;
					
КонецПроцедуры

&НаКлиенте
Процедура ВыбранныеПоляДоступны(ЭлементСтруктуры)
	
	Если Отчет.КомпоновщикНастроек.Настройки.НаличиеВыбораУЭлемента(ЭлементСтруктуры) Тогда
				
		ЛокальныеВыбранныеПоля = Истина;
		Элементы.СтраницыПолейВыбора.ТекущаяСтраница = Элементы.НастройкиВыбранныхПолей;
			
	Иначе
			
		ЛокальныеВыбранныеПоля = Ложь;
		Элементы.СтраницыПолейВыбора.ТекущаяСтраница = Элементы.ОтключенныеНастройкиВыбранныхПолей;
			
	КонецЕсли;
		
	Элементы.ЛокальныеВыбранныеПоля.ТолькоПросмотр = Ложь;
					
КонецПроцедуры

&НаКлиенте
Процедура ВыбранныеПоляНедоступны()
	
	ЛокальныеВыбранныеПоля = Ложь;
	Элементы.ЛокальныеВыбранныеПоля.ТолькоПросмотр = Истина;
	Элементы.СтраницыПолейВыбора.ТекущаяСтраница = Элементы.НедоступныеНастройкиВыбранныхПолей;
					
КонецПроцедуры

&НаКлиенте
Процедура ОтборДоступен(ЭлементСтруктуры)
	
	Если Отчет.КомпоновщикНастроек.Настройки.НаличиеОтбораУЭлемента(ЭлементСтруктуры) Тогда
		
		ЛокальныйОтбор = Истина;
		Элементы.СтраницыОтбора.ТекущаяСтраница = Элементы.НастройкиОтбора;
			
	Иначе
		
		ЛокальныйОтбор = Ложь;
		Элементы.СтраницыОтбора.ТекущаяСтраница = Элементы.ОтключенныеНастройкиОтбора;
			
	КонецЕсли;
			
	Элементы.ЛокальныйОтбор.ТолькоПросмотр = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборНедоступен()
	
	ЛокальныйОтбор = Ложь;
	Элементы.ЛокальныйОтбор.ТолькоПросмотр = Истина;
	Элементы.СтраницыОтбора.ТекущаяСтраница = Элементы.НедоступныеНастройкиОтбора;
		
КонецПроцедуры

&НаКлиенте
Процедура ПорядокДоступен(ЭлементСтруктуры)
	
	Если Отчет.КомпоновщикНастроек.Настройки.НаличиеПорядкаУЭлемента(ЭлементСтруктуры) Тогда
		
		ЛокальныйПорядок = Истина;
		Элементы.СтраницыПорядка.ТекущаяСтраница = Элементы.НастройкиПорядка;
					
	Иначе
		
		ЛокальныйПорядок = Ложь;
		Элементы.СтраницыПорядка.ТекущаяСтраница = Элементы.ОтключенныеНастройкиПорядка;
					
	КонецЕсли;
			
	Элементы.ЛокальныйПорядок.ТолькоПросмотр = Ложь;
		
КонецПроцедуры

&НаКлиенте
Процедура ПорядокНедоступен()
	
	ЛокальныйПорядок = Ложь;
	Элементы.ЛокальныйПорядок.ТолькоПросмотр = Истина;
	Элементы.СтраницыПорядка.ТекущаяСтраница = Элементы.НедоступныеНастройкиПорядка;
		
КонецПроцедуры

&НаКлиенте
Процедура УсловноеОформлениеДоступно(ЭлементСтруктуры)
	
	Если Отчет.КомпоновщикНастроек.Настройки.НаличиеУсловногоОформленияУЭлемента(ЭлементСтруктуры) Тогда
		
		ЛокальноеУсловноеОформление = Истина;
		Элементы.СтраницыУсловногоОформления.ТекущаяСтраница = Элементы.НастройкиУсловногоОформления;
					
	Иначе
		
		ЛокальноеУсловноеОформление = Ложь;
		Элементы.СтраницыУсловногоОформления.ТекущаяСтраница = Элементы.ОтключенныеНастройкиУсловногоОформления;
					
	КонецЕсли;
			
	Элементы.ЛокальноеУсловноеОформление.ТолькоПросмотр = Ложь;
		
КонецПроцедуры

&НаКлиенте
Процедура УсловноеОформлениеНедоступно()
	
	ЛокальноеУсловноеОформление = Ложь;
	Элементы.ЛокальноеУсловноеОформление.ТолькоПросмотр = Истина;
	Элементы.СтраницыУсловногоОформления.ТекущаяСтраница = Элементы.НедоступныеНастройкиУсловногоОформления;
		
КонецПроцедуры

&НаКлиенте
Процедура ПараметрыВыводаДоступны(ЭлементСтруктуры)
	
	Если Отчет.КомпоновщикНастроек.Настройки.НаличиеПараметровВыводаУЭлемента(ЭлементСтруктуры) Тогда
		
		ЛокальныеПараметрыВывода = Истина;
		Элементы.СтраницыПараметровВывода.ТекущаяСтраница = Элементы.НастройкиПараметровВывода;
					
	Иначе
		
		ЛокальныеПараметрыВывода = Ложь;
		Элементы.СтраницыПараметровВывода.ТекущаяСтраница = Элементы.ОтключенныеНастройкиПараметровВывода;
					
	КонецЕсли;
			
	Элементы.ЛокальныеПараметрыВывода.ТолькоПросмотр = Ложь;
		
КонецПроцедуры

&НаКлиенте
Процедура ПараметрыВыводаНедоступны()
	
	ЛокальныеПараметрыВывода = Ложь;
	Элементы.ЛокальныеПараметрыВывода.ТолькоПросмотр = Истина;
	Элементы.СтраницыПараметровВывода.ТекущаяСтраница = Элементы.НедоступныеНастройкиПараметровВывода;
	
КонецПроцедуры

&НаКлиенте
Процедура КомпоновщикНастроекНастройкиПриАктивизацииПоля(Элемент)
		
	Перем ВыбраннаяСтраница;
	
	Если Элементы.КомпоновщикНастроекНастройки.ТекущийЭлемент.Имя = "КомпоновщикНастроекНастройкиНаличиеВыбора" Тогда
		
		ВыбраннаяСтраница = Элементы.СтраницаПолейВыбора;
		
	ИначеЕсли Элементы.КомпоновщикНастроекНастройки.ТекущийЭлемент.Имя = "КомпоновщикНастроекНастройкиНаличиеОтбора" Тогда
		
		ВыбраннаяСтраница = Элементы.СтраницаОтбора;
		
	ИначеЕсли Элементы.КомпоновщикНастроекНастройки.ТекущийЭлемент.Имя = "КомпоновщикНастроекНастройкиНаличиеПорядка" Тогда
		
		ВыбраннаяСтраница = Элементы.СтраницаПорядка;
		
	ИначеЕсли Элементы.КомпоновщикНастроекНастройки.ТекущийЭлемент.Имя = "КомпоновщикНастроекНастройкиНаличиеУсловногоОформления" Тогда
		
		ВыбраннаяСтраница = Элементы.СтраницаУсловногоОформления;
		
	ИначеЕсли Элементы.КомпоновщикНастроекНастройки.ТекущийЭлемент.Имя = "КомпоновщикНастроекНастройкиНаличиеПараметровВывода" Тогда
		
		ВыбраннаяСтраница = Элементы.СтраницаПараметровВывода;
		
	КонецЕсли;
	
	Если ВыбраннаяСтраница <> Неопределено Тогда
		
		Элементы.СтраницыНастроек.ТекущаяСтраница = ВыбраннаяСтраница;
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура КомпоновщикНастроекНастройкиПриАктивизацииСтроки(Элемент)
	
	ЭлементСтруктуры = Отчет.КомпоновщикНастроек.Настройки.ПолучитьОбъектПоИдентификатору(Элементы.КомпоновщикНастроекНастройки.ТекущаяСтрока);
	ТипЭлемента = ТипЗнч(ЭлементСтруктуры); 
	
	Если ТипЭлемента = Неопределено
		Или ТипЭлемента = Тип("КоллекцияЭлементовСтруктурыДиаграммыКомпоновкиДанных")
		Или ТипЭлемента = Тип("КоллекцияЭлементовСтруктурыТаблицыКомпоновкиДанных") Тогда
		
		ПоляГруппировкиНедоступны();
		ВыбранныеПоляНедоступны();
		ОтборНедоступен();
		ПорядокНедоступен();
		УсловноеОформлениеНедоступно();
		ПараметрыВыводаНедоступны();
		
	ИначеЕсли ТипЭлемента = Тип("НастройкиКомпоновкиДанных")
		Или ТипЭлемента = Тип("НастройкиВложенногоОбъектаКомпоновкиДанных") Тогда
		
		ПоляГруппировкиНедоступны();
		
		ЛокальныеВыбранныеПоля = Истина;
		Элементы.ЛокальныеВыбранныеПоля.ТолькоПросмотр = Истина;
		Элементы.СтраницыПолейВыбора.ТекущаяСтраница = Элементы.НастройкиВыбранныхПолей;
		
		ЛокальныйОтбор = Истина;
		Элементы.ЛокальныйОтбор.ТолькоПросмотр = Истина;
		Элементы.СтраницыОтбора.ТекущаяСтраница = Элементы.НастройкиОтбора;
		
		ЛокальныйПорядок = Истина;
		Элементы.ЛокальныйПорядок.ТолькоПросмотр = Истина;
		Элементы.СтраницыПорядка.ТекущаяСтраница = Элементы.НастройкиПорядка;
		
		ЛокальноеУсловноеОформление = Истина;
		Элементы.ЛокальноеУсловноеОформление.ТолькоПросмотр = Истина;
		Элементы.СтраницыУсловногоОформления.ТекущаяСтраница = Элементы.НастройкиУсловногоОформления;
		
		ЛокальныеПараметрыВывода = Истина;
		Элементы.ЛокальныеПараметрыВывода.ТолькоПросмотр = Истина;
		Элементы.СтраницыПараметровВывода.ТекущаяСтраница = Элементы.НастройкиПараметровВывода;
		
	ИначеЕсли ТипЭлемента = Тип("ГруппировкаКомпоновкиДанных")
		Или ТипЭлемента = Тип("ГруппировкаТаблицыКомпоновкиДанных")
		Или ТипЭлемента = Тип("ГруппировкаДиаграммыКомпоновкиДанных") Тогда
		
		Элементы.СтраницыПолейГруппировки.ТекущаяСтраница = Элементы.НастройкиПолейГруппировки;
		
		ВыбранныеПоляДоступны(ЭлементСтруктуры);
		ОтборДоступен(ЭлементСтруктуры);
		ПорядокДоступен(ЭлементСтруктуры);
		УсловноеОформлениеДоступно(ЭлементСтруктуры);
		ПараметрыВыводаДоступны(ЭлементСтруктуры);
		
	ИначеЕсли ТипЭлемента = Тип("ТаблицаКомпоновкиДанных")
		Или ТипЭлемента = Тип("ДиаграммаКомпоновкиДанных") Тогда
		
		ПоляГруппировкиНедоступны();
		ВыбранныеПоляДоступны(ЭлементСтруктуры);
		ОтборНедоступен();
		ПорядокНедоступен();
		УсловноеОформлениеДоступно(ЭлементСтруктуры);
		ПараметрыВыводаДоступны(ЭлементСтруктуры);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиКОтчету(Элемент)
	
	ЭлементСтруктуры = Отчет.КомпоновщикНастроек.Настройки.ПолучитьОбъектПоИдентификатору(Элементы.КомпоновщикНастроекНастройки.ТекущаяСтрока);
	НастройкиЭлемента =  Отчет.КомпоновщикНастроек.Настройки.НастройкиЭлемента(ЭлементСтруктуры);
	Элементы.КомпоновщикНастроекНастройки.ТекущаяСтрока = Отчет.КомпоновщикНастроек.Настройки.ПолучитьИдентификаторПоОбъекту(НастройкиЭлемента);
	
КонецПроцедуры

&НаКлиенте
Процедура ЛокальныеВыбранныеПоляПриИзменении(Элемент)
	
	Если ЛокальныеВыбранныеПоля Тогда
		
		Элементы.СтраницыПолейВыбора.ТекущаяСтраница = Элементы.НастройкиВыбранныхПолей;
			
	Иначе
		
		Элементы.СтраницыПолейВыбора.ТекущаяСтраница = Элементы.ОтключенныеНастройкиВыбранныхПолей;

		ЭлементСтруктуры = Отчет.КомпоновщикНастроек.Настройки.ПолучитьОбъектПоИдентификатору(Элементы.КомпоновщикНастроекНастройки.ТекущаяСтрока);
		Отчет.КомпоновщикНастроек.Настройки.ОчиститьВыборЭлемента(ЭлементСтруктуры);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЛокальныйОтборПриИзменении(Элемент)
	
	Если ЛокальныйОтбор Тогда
		
		Элементы.СтраницыОтбора.ТекущаяСтраница = Элементы.НастройкиОтбора;
			
	Иначе
		
		Элементы.СтраницыОтбора.ТекущаяСтраница = Элементы.ОтключенныеНастройкиОтбора;

		ЭлементСтруктуры = Отчет.КомпоновщикНастроек.Настройки.ПолучитьОбъектПоИдентификатору(Элементы.КомпоновщикНастроекНастройки.ТекущаяСтрока);
		Отчет.КомпоновщикНастроек.Настройки.ОчиститьОтборЭлемента(ЭлементСтруктуры);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЛокальныйПорядокПриИзменении(Элемент)
	
	Если ЛокальныйПорядок Тогда
		
		Элементы.СтраницыПорядка.ТекущаяСтраница = Элементы.НастройкиПорядка;
					
	Иначе
		
		Элементы.СтраницыПорядка.ТекущаяСтраница = Элементы.ОтключенныеНастройкиПорядка;
					
		ЭлементСтруктуры = Отчет.КомпоновщикНастроек.Настройки.ПолучитьОбъектПоИдентификатору(Элементы.КомпоновщикНастроекНастройки.ТекущаяСтрока);
		Отчет.КомпоновщикНастроек.Настройки.ОчиститьПорядокЭлемента(ЭлементСтруктуры);
		
	КонецЕсли;
				
КонецПроцедуры

&НаКлиенте
Процедура ЛокальноеУсловноеОформлениеПриИзменении(Элемент)

	Если ЛокальноеУсловноеОформление Тогда
		
		Элементы.СтраницыУсловногоОформления.ТекущаяСтраница = Элементы.НастройкиУсловногоОформления;
					
	Иначе
		
		Элементы.СтраницыУсловногоОформления.ТекущаяСтраница = Элементы.ОтключенныеНастройкиУсловногоОформления;
					
		ЭлементСтруктуры = Отчет.КомпоновщикНастроек.Настройки.ПолучитьОбъектПоИдентификатору(Элементы.КомпоновщикНастроекНастройки.ТекущаяСтрока);
		Отчет.КомпоновщикНастроек.Настройки.ОчиститьУсловноеОформлениеЭлемента(ЭлементСтруктуры);
					
	КонецЕсли;
				
КонецПроцедуры

&НаКлиенте
Процедура ЛокальныеПараметрыВыводаПриИзменении(Элемент)
	
	Если ЛокальныеПараметрыВывода Тогда
		
		Элементы.СтраницыПараметровВывода.ТекущаяСтраница = Элементы.НастройкиПараметровВывода;
					
	Иначе
		
		Элементы.СтраницыПараметровВывода.ТекущаяСтраница = Элементы.ОтключенныеНастройкиПараметровВывода;
					
		ЭлементСтруктуры = Отчет.КомпоновщикНастроек.Настройки.ПолучитьОбъектПоИдентификатору(Элементы.КомпоновщикНастроекНастройки.ТекущаяСтрока);
		Отчет.КомпоновщикНастроек.Настройки.ОчиститьПараметрыВыводаЭлемента(ЭлементСтруктуры);
	КонецЕсли;
			
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("ПредставлениеВарианта") И ЗначениеЗаполнено(Параметры.ПредставлениеВарианта) Тогда
		АвтоЗаголовок = Ложь;
		Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Изменение варианта отчета ""%1""';uk='Зміна варіанта звіту ""%1""'"), Параметры.ПредставлениеВарианта);
	КонецЕсли;
	
	Если Параметры.Свойство("НастройкиОтчета", НастройкиОтчета) Тогда
		Если НастройкиОтчета.СхемаМодифицирована Тогда
			Отчет.КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(НастройкиОтчета.АдресСхемы));
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если Параметры.ТекущаяСтрока <> Неопределено Тогда
		ПодключитьОбработчикОжидания("УстановитьТекущуюСтроку", 0.1, Истина);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗавершитьРедактирование(Команда)
	Если МодальныйРежим
		Или РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс
		Или ВладелецФормы = Неопределено Тогда
		Закрыть(Истина);
	Иначе
		РезультатВыбора = Новый Структура;
		РезультатВыбора.Вставить("ВариантМодифицирован", Ложь);
		РезультатВыбора.Вставить("ПользовательскиеНастройкиМодифицированы", Ложь);
		
		Если ВариантМодифицирован Тогда
			РезультатВыбора.ВариантМодифицирован = Истина;
			РезультатВыбора.Вставить("НастройкиКД", Отчет.КомпоновщикНастроек.Настройки);
		КонецЕсли;
		
		Если ВариантМодифицирован Или ПользовательскиеНастройкиМодифицированы Тогда
			РезультатВыбора.ПользовательскиеНастройкиМодифицированы = Истина;
			РезультатВыбора.Вставить("ПользовательскиеНастройкиКД", Отчет.КомпоновщикНастроек.ПользовательскиеНастройки);
		КонецЕсли;
		
		#Если ВебКлиент Тогда
			РезультатВыбора.ВариантМодифицирован = Истина; // Для платформы.
			РезультатВыбора.Вставить("НастройкиКД", Отчет.КомпоновщикНастроек.Настройки);
			РезультатВыбора.ПользовательскиеНастройкиМодифицированы = Истина;
			РезультатВыбора.Вставить("ПользовательскиеНастройкиКД", Отчет.КомпоновщикНастроек.ПользовательскиеНастройки);
		#КонецЕсли
		
		ОповеститьОВыборе(РезультатВыбора);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьТекущуюСтроку()
	Элементы.КомпоновщикНастроекНастройки.ТекущаяСтрока = Параметры.ТекущаяСтрока;
КонецПроцедуры

#КонецОбласти
