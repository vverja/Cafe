
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	ИспользуетсяРеглУчет = (Метаданные.ПланыСчетов.Найти("Хозрасчетный") <> Неопределено);
	
	Если ИспользуетсяРеглУчет Тогда
		Элементы.ГруппаКорСчет.Видимость = Ложь;
	Иначе
		ЗаполнитьСписокВыбораКоррСчета();
	КонецЕсли;
	
	Если Не РольДоступна("ДобавлениеИзменениеКлассификаторовНастроекДДС") И Не РольДоступна("ПолныеПрава") Тогда
		Элементы.РедактироватьСписокХозяйственныхОпераций.Доступность = Ложь;
	Конецесли;
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Объект", Объект);
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтаФорма, ДополнительныеПараметры);
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)

	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)

	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	ХозяйственныеОперацииНаименование = СформироватьЗаголовокРедактированияСпискаОпераций();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("СписокЗначений") Тогда
		
		Объект.ХозяйственныеОперации.Очистить();
		
		Для Каждого ЭлементСписка Из ВыбранноеЗначение Цикл
			Объект.ХозяйственныеОперации.Добавить().ХозяйственнаяОперация = ЭлементСписка.Значение;
		КонецЦикла;
		
		ХозяйственныеОперацииНаименование = СформироватьЗаголовокРедактированияСпискаОпераций();
		
		ПриИзмененииСпискаХозОпераций();
		
		Модифицированность = Истина;
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.Свойства 
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура ХозяйственныеОперацииНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("СписокХозяйственныхОпераций", Новый СписокЗначений);
	Для Каждого СтрокаХозОперации Из Объект.ХозяйственныеОперации Цикл
		ПараметрыФормы.СписокХозяйственныхОпераций.Добавить(СтрокаХозОперации.ХозяйственнаяОперация);
	КонецЦикла;
	
	ОткрытьФорму("Справочник.СтатьиДвиженияДенежныхСредств.Форма.ФормаРедактированияСпискаХозяйственныхОпераций",
		ПараметрыФормы, ЭтаФорма,,,, Неопределено, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

// Конец СтандартныеПодсистемы.Свойства

&НаКлиенте
Функция СформироватьЗаголовокРедактированияСпискаОпераций()

	Результат = "";
	Для Каждого СтрокаХозОперации Из Объект.ХозяйственныеОперации Цикл
		Результат = Результат + ?(Результат="","","; ") + СокрЛП(СтрокаХозОперации.ХозяйственнаяОперация);
	КонецЦикла;
	
	Если ПустаяСтрока(Результат) Тогда
		Результат = НСтр("ru='<Указать хозяйственные операции>';uk='<Вказати господарські операції>'");
	КонецЕсли;
	
	Возврат Результат;

КонецФункции

&НаСервере
Процедура ПриИзмененииСпискаХозОпераций()
	
	ЗаполнитьВидДвиженияДенежныхСредств();
	
	Если Не ИспользуетсяРеглУчет Тогда
		Объект.КорреспондирующийСчет = "";
		ЗаполнитьСписокВыбораКоррСчета();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьВидДвиженияДенежныхСредств()
	
	
	Для Каждого СтрокаТабличнойЧасти Из Объект.ХозяйственныеОперации Цикл
		
		ВидДвиженияДДС = Неопределено;
		
		Если (СтрокаТабличнойЧасти.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВыплатаЗарплаты) Тогда
			ВидДвиженияДДС = Перечисления.ВидыДвиженийДенежныхСредств.ОплатаТруда;
			
		ИначеЕсли (СтрокаТабличнойЧасти.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПоступлениеДенежныхСредствПоДепозитам)
			или (СтрокаТабличнойЧасти.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПоступлениеДенежныхСредствПоКредитам)
			или (СтрокаТабличнойЧасти.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПоступлениеДенежныхСредствПоЗаймамВыданным)
			или (СтрокаТабличнойЧасти.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПрочиеДоходы) Тогда
			ВидДвиженияДДС = Перечисления.ВидыДвиженийДенежныхСредств.ПрочиеПоступленияПоОперационнойДеятельности;
			
		ИначеЕсли (СтрокаТабличнойЧасти.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПоступлениеОплатыОтКлиента)
			или (СтрокаТабличнойЧасти.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПоступлениеОплатыОтКлиентаПоПлатежнойКарте) Тогда
			ВидДвиженияДДС = Перечисления.ВидыДвиженийДенежныхСредств.ВыручкаОтРеализацииТоваровУслуг;
			
		ИначеЕсли (СтрокаТабличнойЧасти.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПрочиеРасходы) Тогда
			ВидДвиженияДДС = Перечисления.ВидыДвиженийДенежныхСредств.ПрочиеРасходыПоОперационнойДеятельности;			
			
		КонецЕсли;
		
		Если ВидДвиженияДДС <> Неопределено Тогда
			Объект.ВидДвиженияДенежныхСредств = ВидДвиженияДДС;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокВыбораКоррСчета()
	
	СписокСчетов = Элементы.КорреспондирующийСчет.СписокВыбора;
	СписокСчетов.Очистить();
	
	Для Каждого СтрокаТабличнойЧасти Из Объект.ХозяйственныеОперации Цикл
		Если СтрокаТабличнойЧасти.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПрочиеДоходы Тогда
			
			СписокСчетов.Добавить("713", НСтр("ru='Доход от операционной аренды активов (713)';uk='Дохід від операційної оренди активів (713)'"));
			СписокСчетов.Добавить("715", НСтр("ru='Полученные штрафы пени неустойки (715)';uk='Отримані штрафи, пені неустойки (715)'"));
			СписокСчетов.Добавить("719", НСтр("ru='Другие доходы от операционной деятельности (719)';uk='Інші доходи від операційної діяльності (719)'"));
			СписокСчетов.Добавить("731", НСтр("ru='Дивиденды полученные (731)';uk='Дивіденди отримані (731)'"));
			СписокСчетов.Добавить("732", НСтр("ru='Проценты полученные (732)';uk='Відсотки отримані (732)'"));
			СписокСчетов.Добавить("733", НСтр("ru='Прочие доходы от финансовых операций (733)';uk='Інші доходи від фінансових операцій (733)'"));
			СписокСчетов.Добавить("741", НСтр("ru='Доход от реализации финансовых инвестиций (741)';uk='Дохід від реалізації фінансових інвестицій (741)'"));
			СписокСчетов.Добавить("746", НСтр("ru='Другие доходы от обычной деятельности (746)';uk='Інші доходи від звичайної діяльності (746)'"));
			
		ИначеЕсли СтрокаТабличнойЧасти.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПрочиеРасходы Тогда
			
			СписокСчетов.Добавить("661", НСтр("ru='Расчеты по заработной плате (661)';uk='Розрахунки по заробітній платі (661)'"));		
			СписокСчетов.Добавить("91", НСтр("ru='Общепроизводственные затраты (91)';uk='Загальновиробничі витрати (91)'"));
			СписокСчетов.Добавить("92", НСтр("ru='Административные затраты (92)';uk='Адміністративні витрати (92)'"));
			СписокСчетов.Добавить("93", НСтр("ru='Затраты на сбыт (93)';uk='Витрати на збут (93)'"));
			СписокСчетов.Добавить("941", НСтр("ru='Затраты на исследования и разработки (941)';uk='Витрати на дослідження і розробки (941)'"));
			СписокСчетов.Добавить("948", НСтр("ru='Признанные штрафы, пени, неустойки (948)';uk='Визнані штрафи, пені, неустойки (948)'"));
			СписокСчетов.Добавить("949", НСтр("ru='Другие затраты операционной деятельности (949)';uk='Інші витрати операційної діяльності (949)'"));
			СписокСчетов.Добавить("951", НСтр("ru='Проценты за кредит (951)';uk='Відсотки за кредит (951)'"));
			СписокСчетов.Добавить("952", НСтр("ru='Другие финансовые затраты (952)';uk='Інші фінансові витрати (952)'"));
			СписокСчетов.Добавить("977", НСтр("ru='Другие затраты обычной деятельности (977)';uk='Інші витрати звичайної діяльності (977)'"));
			
		ИначеЕсли СтрокаТабличнойЧасти.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПрочееПоступлениеДенежныхСредств Тогда
			
			СписокСчетов.Добавить("501", НСтр("ru='Долгосрочные кредиты банков в национальной валюте (501)';uk='Довгострокові кредити банків у національній валюті (501)'"));
			СписокСчетов.Добавить("502", НСтр("ru='Долгосрочные кредиты банков в иностранной валюте (502)';uk='Довгострокові кредити банків в іноземній валюті (502)'"));
			СписокСчетов.Добавить("503", НСтр("ru='Отсроченные долгосрочные кредиты банков в национальной валюте (503)';uk='Відстрочені довгострокові кредити банків у національній валюті (503)'"));
			СписокСчетов.Добавить("504", НСтр("ru='Отсроченные долгосрочные кредиты банков в иностранной валюте (504)';uk='Відстрочені довгострокові кредити банків в іноземній валюті (504)'"));
			СписокСчетов.Добавить("505", НСтр("ru='Прочие долгосрочные займы в национальной валюте (505)';uk='Інші довгострокові позики в національній валюті (505)'"));
			СписокСчетов.Добавить("506", НСтр("ru='Прочие долгосрочные займы в иностранной валюте (506)';uk='Інші довгострокові позики в іноземній валюті (506)'"));
			СписокСчетов.Добавить("601", НСтр("ru='Краткосрочные кредиты банков в национальной валюте (601)';uk='Короткострокові кредити банків у національній валюті (601)'"));
			СписокСчетов.Добавить("602", НСтр("ru='Краткосрочные кредиты банков в иностранной валюте (602)';uk='Короткострокові кредити банків в іноземній валюті (602)'"));
			СписокСчетов.Добавить("603", НСтр("ru='Отсроченные краткосрочные кредиты банков в национальной валюте (603)';uk='Відстрочені короткострокові кредити банків у національній валюті (603)'"));
			СписокСчетов.Добавить("604", НСтр("ru='Отсроченные краткосрочные кредиты банков в иностранной валюте (604)';uk='Відстрочені короткострокові кредити банків в іноземній валюті (604)'"));
			СписокСчетов.Добавить("605", НСтр("ru='Просроченные займы в национальной валюте (605)';uk='Прострочені позики в національній валюті (605)'"));
			СписокСчетов.Добавить("606", НСтр("ru='Просроченные займы в иностранной валюте (606)';uk='Прострочені позики в іноземній валюті (606)'"));
			
		ИначеЕсли СтрокаТабличнойЧасти.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПрочаяВыдачаДенежныхСредств Тогда
			
			СписокСчетов.Добавить("501", НСтр("ru='Долгосрочные кредиты банков в национальной валюте (501)';uk='Довгострокові кредити банків у національній валюті (501)'"));
			СписокСчетов.Добавить("502", НСтр("ru='Долгосрочные кредиты банков в иностранной валюте (502)';uk='Довгострокові кредити банків в іноземній валюті (502)'"));
			СписокСчетов.Добавить("503", НСтр("ru='Отсроченные долгосрочные кредиты банков в национальной валюте (503)';uk='Відстрочені довгострокові кредити банків у національній валюті (503)'"));
			СписокСчетов.Добавить("504", НСтр("ru='Отсроченные долгосрочные кредиты банков в иностранной валюте (504)';uk='Відстрочені довгострокові кредити банків в іноземній валюті (504)'"));
			СписокСчетов.Добавить("505", НСтр("ru='Прочие долгосрочные займы в национальной валюте (505)';uk='Інші довгострокові позики в національній валюті (505)'"));
			СписокСчетов.Добавить("506", НСтр("ru='Прочие долгосрочные займы в иностранной валюте (506)';uk='Інші довгострокові позики в іноземній валюті (506)'"));
			СписокСчетов.Добавить("601", НСтр("ru='Краткосрочные кредиты банков в национальной валюте (601)';uk='Короткострокові кредити банків у національній валюті (601)'"));
			СписокСчетов.Добавить("602", НСтр("ru='Краткосрочные кредиты банков в иностранной валюте (602)';uk='Короткострокові кредити банків в іноземній валюті (602)'"));
			СписокСчетов.Добавить("603", НСтр("ru='Отсроченные краткосрочные кредиты банков в национальной валюте (603)';uk='Відстрочені короткострокові кредити банків у національній валюті (603)'"));
			СписокСчетов.Добавить("604", НСтр("ru='Отсроченные краткосрочные кредиты банков в иностранной валюте (604)';uk='Відстрочені короткострокові кредити банків в іноземній валюті (604)'"));
			СписокСчетов.Добавить("605", НСтр("ru='Просроченные займы в национальной валюте (605)';uk='Прострочені позики в національній валюті (605)'"));
			СписокСчетов.Добавить("606", НСтр("ru='Просроченные займы в иностранной валюте (606)';uk='Прострочені позики в іноземній валюті (606)'"));
			СписокСчетов.Добавить("611", НСтр("ru='Текущая задолженность по долгосрочным обязательствам в национальной валюте (611)';uk='Поточна заборгованість за довгостроковими зобов''язаннями в національній валюті (611)'"));
			СписокСчетов.Добавить("612", НСтр("ru='Текущая задолженность по долгосрочным обязательствам в иностранной валюте (612)';uk='Поточна заборгованість за довгостроковими зобов''язаннями в іноземній валюті (612)'"));
			
		ИначеЕсли СтрокаТабличнойЧасти.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВыдачаДенежныхСредствВДругуюКассу Тогда
			
			СписокСчетов.Добавить("301", НСтр("ru='Касса в национальной валюте (301)';uk='Каса в національній валюті (301)'"));
			СписокСчетов.Добавить("302", НСтр("ru='Касса в иностранной валюте (302)';uk='Каса в іноземній валюті (302)'"));
			
		ИначеЕсли СтрокаТабличнойЧасти.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ОплатаПоставщику Тогда
			
			СписокСчетов.Добавить("631", НСтр("ru='Расчеты с отечественными поставщиками (631)';uk='Розрахунки з вітчизняними постачальниками (631)'"));
			СписокСчетов.Добавить("632", НСтр("ru='Расчеты с иностранными поставщиками (632)';uk='Розрахунки з іноземними постачальниками (632)'"));
			СписокСчетов.Добавить("3711", НСтр("ru='Расчеты по выданным авансам в национальной валюте (3711)';uk='Розрахунки за виданими авансами в національній валюті (3711)'"));
			СписокСчетов.Добавить("3712", НСтр("ru='Расчеты по выданным авансам в иностранной валюте (3712)';uk='Розрахунки за виданими авансами в іноземній валюті (3712)'"));
			СписокСчетов.Добавить("3771", НСтр("ru='Расчеты с другими дебиторами в национальной валюте (3771)';uk='Розрахунки з іншими дебіторами в національній валюті (3771)'"));
			СписокСчетов.Добавить("3772", НСтр("ru='Расчеты с другими дебиторами в иностранной валюте (3772)';uk='Розрахунки з іншими дебіторами в іноземній валюті (3772)'"));
			СписокСчетов.Добавить("6851", НСтр("ru='Расчеты с другими кредиторами в национальной валюте (6851)';uk='Розрахунки з іншими кредиторами в національній валюті (6851)'"));
			СписокСчетов.Добавить("6852", НСтр("ru='Расчеты с другими кредиторами в иностранной валюте (6852)';uk='Розрахунки з іншими кредиторами в іноземній валюті (6852)'"));			
			
		ИначеЕсли СтрокаТабличнойЧасти.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПоступлениеДенежныхСредствИзБанка
			Или СтрокаТабличнойЧасти.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПеречислениеДенежныхСредствНаДругойСчет Тогда
			
			СписокСчетов.Добавить("311", НСтр("ru='Текущие счета в национальной валюте (311)';uk='Поточні рахунки в національній валюті (311)'"));
			СписокСчетов.Добавить("312", НСтр("ru='Текущие счета в иностранной валюте (312)';uk='Поточні рахунки в іноземній валюті (312)'"));
			
		ИначеЕсли СтрокаТабличнойЧасти.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПоступлениеОплатыОтКлиента Тогда
			
			СписокСчетов.Добавить("361", НСтр("ru='Расчеты с отечественными покупателями (361)';uk='Розрахунки з вітчизняними покупцями (361)'"));
			СписокСчетов.Добавить("362", НСтр("ru='Расчеты с иностранными покупателями (362)';uk='Розрахунки з іноземними покупцями (362)'"));
			СписокСчетов.Добавить("6811", НСтр("ru='Расчеты по авансам полученным в национальной валюте (6811)';uk='Розрахунки за авансами одержаними в національній валюті (6811)'"));
			СписокСчетов.Добавить("6812", НСтр("ru='Расчеты по авансам полученным в иностранной валюте (6812)';uk='Розрахунки за авансами отриманими в іноземній валюті (6812)'"));
			СписокСчетов.Добавить("3771", НСтр("ru='Расчеты с другими дебиторами в национальной валюте (3771)';uk='Розрахунки з іншими дебіторами в національній валюті (3771)'"));
			СписокСчетов.Добавить("3772", НСтр("ru='Расчеты с другими дебиторами в иностранной валюте (3772)';uk='Розрахунки з іншими дебіторами в іноземній валюті (3772)'"));
			СписокСчетов.Добавить("6851", НСтр("ru='Расчеты с другими кредиторами в национальной валюте (6851)';uk='Розрахунки з іншими кредиторами в національній валюті (6851)'"));
			СписокСчетов.Добавить("6852", НСтр("ru='Расчеты с другими кредиторами в иностранной валюте (6852)';uk='Розрахунки з іншими кредиторами в іноземній валюті (6852)'"));
			
		ИначеЕсли СтрокаТабличнойЧасти.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.СдачаДенежныхСредствВБанк Тогда
			
			СписокСчетов.Добавить("311", НСтр("ru='Текущие счета в национальной валюте (311)';uk='Поточні рахунки в національній валюті (311)'"));
			СписокСчетов.Добавить("312", НСтр("ru='Текущие счета в иностранной валюте (312)';uk='Поточні рахунки в іноземній валюті (312)'"));			
			
		ИначеЕсли СтрокаТабличнойЧасти.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ОплатаДенежныхСредствВДругуюОрганизацию 
			ИЛИ СтрокаТабличнойЧасти.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратДенежныхСредствВДругуюОрганизацию 
			ИЛИ СтрокаТабличнойЧасти.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПоступлениеДенежныхСредствИзДругойОрганизации
			ИЛИ СтрокаТабличнойЧасти.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратДенежныхСредствОтДругойОрганизации Тогда
			
			СписокСчетов.Добавить("631", НСтр("ru='Расчеты с отечественными поставщиками (631)';uk='Розрахунки з вітчизняними постачальниками (631)'"));
			СписокСчетов.Добавить("632", НСтр("ru='Расчеты с иностранными поставщиками (632)';uk='Розрахунки з іноземними постачальниками (632)'"));
			СписокСчетов.Добавить("3711", НСтр("ru='Расчеты по выданным авансам в национальной валюте (3711)';uk='Розрахунки за виданими авансами в національній валюті (3711)'"));
			СписокСчетов.Добавить("3712", НСтр("ru='Расчеты по выданным авансам в иностранной валюте (3712)';uk='Розрахунки за виданими авансами в іноземній валюті (3712)'"));
			СписокСчетов.Добавить("3771", НСтр("ru='Расчеты с другими дебиторами в национальной валюте (3771)';uk='Розрахунки з іншими дебіторами в національній валюті (3771)'"));
			СписокСчетов.Добавить("3772", НСтр("ru='Расчеты с другими дебиторами в иностранной валюте (3772)';uk='Розрахунки з іншими дебіторами в іноземній валюті (3772)'"));
			СписокСчетов.Добавить("6851", НСтр("ru='Расчеты с другими кредиторами в национальной валюте (6851)';uk='Розрахунки з іншими кредиторами в національній валюті (6851)'"));
			СписокСчетов.Добавить("6852", НСтр("ru='Расчеты с другими кредиторами в иностранной валюте (6852)';uk='Розрахунки з іншими кредиторами в іноземній валюті (6852)'"));			
			СписокСчетов.Добавить("683", НСтр("ru='Внутрихозяйственные расчеты (683)';uk='Внутрішньогосподарські розрахунки (683)'"));

		ИначеЕсли СтрокаТабличнойЧасти.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВыдачаДенежныхСредствВКассуККМ Тогда
			
			СписокСчетов.Добавить("301", НСтр("ru='Касса в национальной валюте (301)';uk='Каса в національній валюті (301)'"));
			
		ИначеЕсли СтрокаТабличнойЧасти.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПоступлениеДенежныхСредствИзКассыККМ Тогда
			
			СписокСчетов.Добавить("301", НСтр("ru='Касса в национальной валюте (301)';uk='Каса в національній валюті (301)'"));			
			
		ИначеЕсли СтрокаТабличнойЧасти.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратДенежныхСредствОтПодотчетника Тогда
			
			СписокСчетов.Добавить("3721", НСтр("ru='Расчеты с подотчетными лицами в национальной валюте (3721)';uk='Розрахунки з підзвітними особами у національній валюті (3721)'"));
			СписокСчетов.Добавить("3722", НСтр("ru='Расчеты с подотчетными лицами в иностранной валюте (3722)';uk='Розрахунки з підзвітними особами в іноземній валюті (3722)'"));
			
		ИначеЕсли СтрокаТабличнойЧасти.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратДенежныхСредствОтПоставщика Тогда
			
			СписокСчетов.Добавить("631", НСтр("ru='Расчеты с отечественными поставщиками (631)';uk='Розрахунки з вітчизняними постачальниками (631)'"));
			СписокСчетов.Добавить("632", НСтр("ru='Расчеты с иностранными поставщиками (632)';uk='Розрахунки з іноземними постачальниками (632)'"));
			СписокСчетов.Добавить("3711", НСтр("ru='Расчеты по выданным авансам в национальной валюте (3711)';uk='Розрахунки за виданими авансами в національній валюті (3711)'"));
			СписокСчетов.Добавить("3712", НСтр("ru='Расчеты по выданным авансам в иностранной валюте (3712)';uk='Розрахунки за виданими авансами в іноземній валюті (3712)'"));
			СписокСчетов.Добавить("3771", НСтр("ru='Расчеты с другими дебиторами в национальной валюте (3771)';uk='Розрахунки з іншими дебіторами в національній валюті (3771)'"));
			СписокСчетов.Добавить("3772", НСтр("ru='Расчеты с другими дебиторами в иностранной валюте (3772)';uk='Розрахунки з іншими дебіторами в іноземній валюті (3772)'"));
			СписокСчетов.Добавить("6851", НСтр("ru='Расчеты с другими кредиторами в национальной валюте (6851)';uk='Розрахунки з іншими кредиторами в національній валюті (6851)'"));
			СписокСчетов.Добавить("6852", НСтр("ru='Расчеты с другими кредиторами в иностранной валюте (6852)';uk='Розрахунки з іншими кредиторами в іноземній валюті (6852)'"));
			
		ИначеЕсли СтрокаТабличнойЧасти.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратОплатыКлиенту Тогда
			
			СписокСчетов.Добавить("361", НСтр("ru='Расчеты с отечественными покупателями (361)';uk='Розрахунки з вітчизняними покупцями (361)'"));
			СписокСчетов.Добавить("362", НСтр("ru='Расчеты с иностранными покупателями (362)';uk='Розрахунки з іноземними покупцями (362)'"));
			СписокСчетов.Добавить("6811", НСтр("ru='Расчеты по авансам полученным в национальной валюте (6811)';uk='Розрахунки за авансами одержаними в національній валюті (6811)'"));
			СписокСчетов.Добавить("6812", НСтр("ru='Расчеты по авансам полученным в иностранной валюте (6812)';uk='Розрахунки за авансами отриманими в іноземній валюті (6812)'"));
			СписокСчетов.Добавить("3771", НСтр("ru='Расчеты с другими дебиторами в национальной валюте (3771)';uk='Розрахунки з іншими дебіторами в національній валюті (3771)'"));
			СписокСчетов.Добавить("3772", НСтр("ru='Расчеты с другими дебиторами в иностранной валюте (3772)';uk='Розрахунки з іншими дебіторами в іноземній валюті (3772)'"));
			СписокСчетов.Добавить("6851", НСтр("ru='Расчеты с другими кредиторами в национальной валюте (6851)';uk='Розрахунки з іншими кредиторами в національній валюті (6851)'"));
			СписокСчетов.Добавить("6852", НСтр("ru='Расчеты с другими кредиторами в иностранной валюте (6852)';uk='Розрахунки з іншими кредиторами в іноземній валюті (6852)'"));
			
		ИначеЕсли СтрокаТабличнойЧасти.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВыдачаДенежныхСредствПодотчетнику Тогда
			
			СписокСчетов.Добавить("3721", НСтр("ru='Расчеты с подотчетными лицами в национальной валюте (3721)';uk='Розрахунки з підзвітними особами у національній валюті (3721)'"));
			СписокСчетов.Добавить("3722", НСтр("ru='Расчеты с подотчетными лицами в иностранной валюте (3722)';uk='Розрахунки з підзвітними особами в іноземній валюті (3722)'"));
			
		ИначеЕсли СтрокаТабличнойЧасти.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПоступлениеДенежныхСредствИзДругойКассы Тогда
			
			СписокСчетов.Добавить("301", НСтр("ru='Касса в национальной валюте (301)';uk='Каса в національній валюті (301)'"));
			СписокСчетов.Добавить("302", НСтр("ru='Касса в иностранной валюте (302)';uk='Каса в іноземній валюті (302)'"));
		ИначеЕсли СтрокаТабличнойЧасти.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.КонвертацияВалюты Тогда
			
			СписокСчетов.Добавить("333", НСтр("ru='Денежные средства в пути в национальной валюте (333)';uk='Грошові кошти в дорозі в національній валюті (333)'"));
			СписокСчетов.Добавить("334", НСтр("ru='Денежные средства в пути в иностранной валюте (334)';uk='Грошові кошти в дорозі в іноземній валюті (334)'"));
			
		ИначеЕсли СтрокаТабличнойЧасти.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВыплатаЗарплаты Тогда
			
			СписокСчетов.Добавить("661", НСтр("ru='Расчеты по заработной плате (661)';uk='Розрахунки по заробітній платі (661)'"));
			
		ИначеЕсли СтрокаТабличнойЧасти.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПеречислениеВБюджет Тогда
			
			СписокСчетов.Добавить("6411", НСтр("ru='Расчеты по НДФЛ (6411)';uk='Розрахунки за ПДФО (6411)'"));
			СписокСчетов.Добавить("6412", НСтр("ru='Расчеты по НДС (6412)';uk='Розрахунки за ПДВ (6412)'"));
			СписокСчетов.Добавить("6413", НСтр("ru='Расчеты по налогу на прибыль (6413)';uk='Розрахунки з податку на прибуток (6413)'"));
			СписокСчетов.Добавить("6414", НСтр("ru='Расчеты по единому налогу (6414)';uk='Розрахунки за єдиним податком (6414)'"));
			СписокСчетов.Добавить("6415", НСтр("ru='Расчеты по другим налогам (6415)';uk='Розрахунки за іншими податками (6415)'"));
			СписокСчетов.Добавить("6416", НСтр("ru='Расчеты по акцизу (6416)';uk='Розрахунки за акцизом (6416)'"));
			СписокСчетов.Добавить("642", НСтр("ru='Расчеты по обязательным платежам (642)';uk='Розрахунки за обов''язковими платежами (642)'"));
			
		ИначеЕсли СтрокаТабличнойЧасти.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПеречислениеТаможне Тогда
			
			СписокСчетов.Добавить("3771", НСтр("ru='Расчеты с другими дебиторами в национальной валюте (3771)';uk='Розрахунки з іншими дебіторами в національній валюті (3771)'"));
			СписокСчетов.Добавить("3772", НСтр("ru='Расчеты с другими дебиторами в иностранной валюте (3772)';uk='Розрахунки з іншими дебіторами в іноземній валюті (3772)'"));
			СписокСчетов.Добавить("6851", НСтр("ru='Расчеты с другими кредиторами в национальной валюте (6851)';uk='Розрахунки з іншими кредиторами в національній валюті (6851)'"));
			СписокСчетов.Добавить("6852", НСтр("ru='Расчеты с другими кредиторами в иностранной валюте (6852)';uk='Розрахунки з іншими кредиторами в іноземній валюті (6852)'"));
			
		ИначеЕсли СтрокаТабличнойЧасти.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПеречислениеНаДепозиты Тогда
			
			СписокСчетов.Добавить("313", НСтр("ru='Другие счета в банке в национальной валюте (313)';uk='Інші рахунки в банку в національній валюті (313)'"));
			СписокСчетов.Добавить("314", НСтр("ru='Другие счета в банке в иностранной валюте (314)';uk='Інші рахунки в банку в іноземній валюті (314)'"));
			
		ИначеЕсли СтрокаТабличнойЧасти.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВыдачаЗаймов Тогда
			
			СписокСчетов.Добавить("376", НСтр("ru='Расчеты по ссудам членам кредитных союзов (376)';uk='Розрахунки за позиками членам кредитних спілок (376)'"));
			
		ИначеЕсли СтрокаТабличнойЧасти.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ОплатаПоКредитам Тогда
			
			// кредиты и займы краткосрочные
			СписокСчетов.Добавить("601", НСтр("ru='Краткосрочные кредиты банков в национальной валюте (601)';uk='Короткострокові кредити банків у національній валюті (601)'"));
			СписокСчетов.Добавить("602", НСтр("ru='Краткосрочные кредиты банков в иностранной валюте (602)';uk='Короткострокові кредити банків в іноземній валюті (602)'"));
			СписокСчетов.Добавить("603", НСтр("ru='Отсроченные краткосрочные кредиты банков в национальной валюте (603)';uk='Відстрочені короткострокові кредити банків у національній валюті (603)'"));
			СписокСчетов.Добавить("604", НСтр("ru='Отсроченные краткосрочные кредиты банков в иностранной валюте (604)';uk='Відстрочені короткострокові кредити банків в іноземній валюті (604)'"));
			СписокСчетов.Добавить("605", НСтр("ru='Просроченные займы в национальной валюте (605)';uk='Прострочені позики в національній валюті (605)'"));
			СписокСчетов.Добавить("606", НСтр("ru='Просроченные займы в иностранной валюте (606)';uk='Прострочені позики в іноземній валюті (606)'"));
			
			// кредиты и займы долгосрочные
			СписокСчетов.Добавить("501", НСтр("ru='Долгосрочные кредиты банков в национальной валюте (501)';uk='Довгострокові кредити банків у національній валюті (501)'"));
			СписокСчетов.Добавить("502", НСтр("ru='Долгосрочные кредиты банков в иностранной валюте (502)';uk='Довгострокові кредити банків в іноземній валюті (502)'"));
			СписокСчетов.Добавить("503", НСтр("ru='Отсроченные долгосрочные кредиты банков в национальной валюте (503)';uk='Відстрочені довгострокові кредити банків у національній валюті (503)'"));
			СписокСчетов.Добавить("504", НСтр("ru='Отсроченные долгосрочные кредиты банков в иностранной валюте (504)';uk='Відстрочені довгострокові кредити банків в іноземній валюті (504)'"));
			СписокСчетов.Добавить("505", НСтр("ru='Прочие долгосрочные займы в национальной валюте (505)';uk='Інші довгострокові позики в національній валюті (505)'"));
			СписокСчетов.Добавить("506", НСтр("ru='Прочие долгосрочные займы в иностранной валюте (506)';uk='Інші довгострокові позики в іноземній валюті (506)'"));			
			
			// комиссия (и прочие платежи) по кредитам и займам
			СписокСчетов.Добавить("684", НСтр("ru='Расчеты по начисленным процентам (684)';uk='Розрахунки за нарахованими відсотками (684)'"));
			
		ИначеЕсли СтрокаТабличнойЧасти.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПоступлениеДенежныхСредствПоДепозитам Тогда
			
			СписокСчетов.Добавить("313", НСтр("ru='Другие счета в банке в национальной валюте (313)';uk='Інші рахунки в банку в національній валюті (313)'"));
			СписокСчетов.Добавить("314", НСтр("ru='Другие счета в банке в иностранной валюте (314)';uk='Інші рахунки в банку в іноземній валюті (314)'"));
			СписокСчетов.Добавить("373", НСтр("ru='Расчеты по начисленным доходам (373)';uk='Розрахунки за нарахованими доходами (373)'"));
			
		ИначеЕсли СтрокаТабличнойЧасти.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПоступлениеДенежныхСредствПоЗаймамВыданным Тогда
			
			СписокСчетов.Добавить("373", НСтр("ru='Расчеты по начисленным доходам (373)';uk='Розрахунки за нарахованими доходами (373)'"));
			СписокСчетов.Добавить("376", НСтр("ru='Расчеты по ссудам членам кредитных союзов (376)';uk='Розрахунки за позиками членам кредитних спілок (376)'"));
			
		ИначеЕсли СтрокаТабличнойЧасти.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПоступлениеДенежныхСредствПоКредитам Тогда
			
			СписокСчетов.Добавить("601", НСтр("ru='Краткосрочные кредиты банков в национальной валюте (601)';uk='Короткострокові кредити банків у національній валюті (601)'"));
			СписокСчетов.Добавить("602", НСтр("ru='Краткосрочные кредиты банков в иностранной валюте (602)';uk='Короткострокові кредити банків в іноземній валюті (602)'"));
			СписокСчетов.Добавить("603", НСтр("ru='Отсроченные краткосрочные кредиты банков в национальной валюте (603)';uk='Відстрочені короткострокові кредити банків у національній валюті (603)'"));
			СписокСчетов.Добавить("604", НСтр("ru='Отсроченные краткосрочные кредиты банков в иностранной валюте (604)';uk='Відстрочені короткострокові кредити банків в іноземній валюті (604)'"));
			СписокСчетов.Добавить("501", НСтр("ru='Долгосрочные кредиты банков в национальной валюте (501)';uk='Довгострокові кредити банків у національній валюті (501)'"));
			СписокСчетов.Добавить("502", НСтр("ru='Долгосрочные кредиты банков в иностранной валюте (502)';uk='Довгострокові кредити банків в іноземній валюті (502)'"));
			СписокСчетов.Добавить("505", НСтр("ru='Прочие долгосрочные займы в национальной валюте (505)';uk='Інші довгострокові позики в національній валюті (505)'"));
			СписокСчетов.Добавить("506", НСтр("ru='Прочие долгосрочные займы в иностранной валюте (506)';uk='Інші довгострокові позики в іноземній валюті (506)'"));
			
		КонецЕсли;
		
	КонецЦикла;
	
	СписокСчетов.СортироватьПоЗначению(НаправлениеСортировки.Возр);
	
	Индекс = 0;
	ВГраницаСписка = СписокСчетов.Количество() - 1;
	
	Пока Индекс < ВГраницаСписка Цикл
		Если СписокСчетов[Индекс].Значение = СписокСчетов[Индекс + 1].Значение Тогда
			СписокСчетов.Удалить(СписокСчетов[Индекс + 1]);
			ВГраницаСписка = ВГраницаСписка - 1;
		Иначе
			Индекс = Индекс + 1;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ ПОДСИСТЕМЫ "СВОЙСТВ"

&НаКлиенте
Процедура Подключаемый_РедактироватьСоставСвойств()

	УправлениеСвойствамиКлиент.РедактироватьСоставСвойств(ЭтаФорма, Объект.Ссылка);

КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов() Экспорт

	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтаФорма, РеквизитФормыВЗначение("Объект"));

КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

#КонецОбласти

