#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область Печать

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	СтруктураТипов = ОбщегоНазначенияУТ.СоответствиеМассивовПоТипамОбъектов(МассивОбъектов);
	
 	
	
	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Истина;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "М7_Страница1") Тогда			   
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "М7_Страница1", НСтр("ru='М-7 (страница 1)';uk='М-7 (сторінка 1)'"), ПолучитьПечатнуюФормуМ7(СтруктураТипов, "М7_Страница1", ПараметрыПечати, МассивОбъектов, ОбъектыПечати));
	КонецЕсли;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "М7_Страница2") Тогда			   
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "М7_Страница2", НСтр("ru='М-7 (страница 2)';uk='М-7 (сторінка 2)'"), ПолучитьПечатнуюФормуМ7(СтруктураТипов, "М7_Страница2", ПараметрыПечати, МассивОбъектов, ОбъектыПечати));
	КонецЕсли;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "М7_Страница3") Тогда			   
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "М7_Страница3", НСтр("ru='М-7 (страница 3)';uk='М-7 (сторінка 3)'"), ПолучитьПечатнуюФормуМ7(СтруктураТипов, "М7_Страница3", ПараметрыПечати, МассивОбъектов, ОбъектыПечати));
	КонецЕсли;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "М7_Страница4") Тогда			   
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "М7_Страница4", НСтр("ru='М-7 (страница 4)';uk='М-7 (сторінка 4)'"), ПолучитьПечатнуюФормуМ7(СтруктураТипов, "М7_Страница4", ПараметрыПечати, МассивОбъектов, ОбъектыПечати));
	КонецЕсли;
	
	ФормированиеПечатныхФорм.ЗаполнитьПараметрыОтправки(ПараметрыВывода.ПараметрыОтправки, МассивОбъектов, КоллекцияПечатныхФорм);
	
КонецПроцедуры

#Область Печать_М7

// Функция формирует и возвращает печатную форму М-7
//
// Параметры:
// 		ИмяМакета - Строка - Строка имени макета
// 		ПечатьВНоменклатуреПоставщика - Булево
// 		МассивОбъектов - Массив - массив документов для печати
// 		ОбъектыПечати - СписокЗначений
//
// Возвращаемое значение:
// 		ТабличныйДокумент
//
Функция ПолучитьПечатнуюФормуМ7(СтруктураТипов, ИмяМакета, ПараметрыПечати, МассивОбъектов, ОбъектыПечати)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	
	УстановитьПривилегированныйРежим(Истина);
	
	НомерТипаДокумента = 0;
	
	Для Каждого СтруктураОбъектов Из СтруктураТипов Цикл

		НомерТипаДокумента = НомерТипаДокумента + 1;
		Если НомерТипаДокумента > 1 Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		
		// Кешируем исходные данные перед печатью первой страницы
		Если ИмяМакета = "М7_Страница1" Тогда
			
			КешИсходныхДанных = Новый Структура;
			
			КешИсходныхДанных.Вставить("Макет", УправлениеПечатью.МакетПечатнойФормы("Обработка.ПечатьАктыОРасхождениях.ПФ_MXL_UK_М7"));
			
			КолонкаКодов = ФормированиеПечатныхФорм.ИмяДополнительнойКолонки();
			Если НЕ ЗначениеЗаполнено(КолонкаКодов) Тогда
				КолонкаКодов = "Код";
			КонецЕсли;
			КешИсходныхДанных.Вставить("КолонкаКодов", КолонкаКодов);
			
			
			МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(СтруктураОбъектов.Ключ);
			
			ДанныеДляПечати = МенеджерОбъекта.ПолучитьДанныеДляПечатнойФормыМ7(ПараметрыПечати, СтруктураОбъектов.Значение);

			ДанныеПечати       = ДанныеДляПечати.ДанныеПечати.Выбрать();
			ТаблицаТоваров     = ДанныеДляПечати.ДанныеТоваров.Выгрузить();
	        ТаблицаТоваровПоДокументам = ДанныеДляПечати.ДанныеТоваровПоДокументам.Выгрузить();
			ТаблицаКурсовВалют = ДанныеДляПечати.ДанныеКурсовВалют.Выгрузить();
			
			ПересчитатьСуммыВВалютеРегламентированногоУчета(ТаблицаТоваров, ТаблицаКурсовВалют);
			
	 		
			
			
			КешИсходныхДанных.Вставить("ДанныеПечати", ДанныеПечати);
			КешИсходныхДанных.Вставить("ТаблицаТоваровПоДокументам", ТаблицаТоваровПоДокументам);
			КешИсходныхДанных.Вставить("ТаблицаТоваров", ТаблицаТоваров);
			
			ПараметрыПечати.Вставить("КешИсходныхДанных", КешИсходныхДанных);
		Иначе		
			ПараметрыПечати.КешИсходныхДанных.ДанныеПечати.Сбросить();
		КонецЕсли;
		
		ЗаполнитьТабличныйДокументМ7(ИмяМакета, ТабличныйДокумент, ПараметрыПечати, ОбъектыПечати);
		
		// Удалем кеш, после печати послейдней страницы
		Если ИмяМакета = "М7_Страница4" Тогда
			ПараметрыПечати.Удалить("КешИсходныхДанных");
		КонецЕсли;
		
		Если ПривилегированныйРежим() Тогда
			УстановитьПривилегированныйРежим(Ложь);
		КонецЕсли;
		
	КонецЦикла;
	
	
	Возврат ТабличныйДокумент;
	
	
КонецФункции

//Процедура заполняет табличный документ М-7
//
// Параметры:
// 	ИмяМакета - Строка - Строка имени макета
// 	ТабличныйДокумент - ТабличныйДокумент - Табличный документ для вывода печатной формы
//  ПараметрыПечати - Структура - Структура дополнительных параметров печати
// 	ОбъектыПечати - СписокЗначений
//
Процедура ЗаполнитьТабличныйДокументМ7(ИмяМакета, ТабличныйДокумент, ПараметрыПечати, ОбъектыПечати)
	
	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_АктОРасхожденияхПриПоступленииТоваров_" + ИмяМакета;		
	
	Макет = ПараметрыПечати.КешИсходныхДанных["Макет"];
	
	ПечатьВНоменклатуреПоставщика = ПараметрыПечати["ПечатьВНоменклатуреПоставщика"];
	
	ДанныеПечати = ПараметрыПечати.КешИсходныхДанных["ДанныеПечати"];
		
	ПервыйДокумент = Истина;
	
	Пока ДанныеПечати.Следующий() Цикл
		
		Если ДанныеПечати.ОшибкаНетРасхождений Тогда
			
			Если ИмяМакета = "М7_Страница1" Тогда
				Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='В документе %1 нет расхождений. Печать акта про прием материалов (М-7) при приемке %2 не требуется.';uk='У документі %1 немає розбіжностей. Друк акту про приймання матеріалів (М-7) при прийманні %2 не потрібний.'"), ДанныеПечати.Ссылка);
				
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					Текст,
					ДанныеПечати.Ссылка
				);			
			КонецЕсли;
			
			Продолжить;
			
		КонецЕсли;
		
		Если ПервыйДокумент Тогда
			ПервыйДокумент = Ложь;
		Иначе
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;				
		
		Если ИмяМакета = "М7_Страница1" Тогда
					
			// Получение исходных данных
			ТаблицаТоваровПоДокументам = ПараметрыПечати.КешИсходныхДанных["ТаблицаТоваровПоДокументам"];
						
			Область = Макет.ПолучитьОбласть("ШапкаПервойСтраницы");			
			Область.Параметры.Заполнить(ДанныеПечати);
			
			Область.Параметры.НомерДокумента           = ПрефиксацияОбъектовКлиентСервер.ПолучитьНомерНаПечать(ДанныеПечати.НомерДокумента, Ложь, Истина);
			
			СведенияОбОрганизации = ФормированиеПечатныхФорм.СведенияОЮрФизЛице(ДанныеПечати.Организация, ДанныеПечати.ДатаДокумента);			
			Область.Параметры.ПредставлениеОрганизации = ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОбОрганизации, "ПолноеНаименование,",,"uk");
			Область.Параметры.КодПоЕДРПОУ              = СведенияОбОрганизации.КодПоЕДРПОУ;
			
			Область.Параметры.РуководительФИО          = ФизическиеЛицаУТ.ФамилияИнициалыФизЛица(ДанныеПечати.Руководитель);
			
			Область.Параметры.Заполнить(ПолучитьСтруктуруПоДате("ДатаСчетаВходящий", ДанныеПечати.ДатаСчетаВходящий));
			Область.Параметры.Заполнить(ПолучитьСтруктуруПоДате("ДатаСопроводительногоТранспортногоДокумента", ДанныеПечати.ДатаСопроводительногоТранспортногоДокумента));
			
			Область.Параметры.Грузоотправитель         = ФормированиеПечатныхФорм.ОписаниеОрганизации(ФормированиеПечатныхФорм.СведенияОЮрФизЛице(ДанныеПечати.Грузоотправитель, ДанныеПечати.ДатаДокумента), "ПолноеНаименование,ЮридическийАдрес,",,"uk");
			Область.Параметры.Грузополучатель          = ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОбОрганизации, "ПолноеНаименование,ЮридическийАдрес,",,"uk");
			Область.Параметры.Поставщик                = ФормированиеПечатныхФорм.ОписаниеОрганизации(ФормированиеПечатныхФорм.СведенияОЮрФизЛице(ДанныеПечати.Поставщик, ДанныеПечати.ДатаДокумента), "ПолноеНаименование,ЮридическийАдрес,",,"uk");
			
			Область.Параметры.Заполнить(ПолучитьСтруктуруПоДате("ДатаОтправленияТоваров", ДанныеПечати.ДатаОтправленияТоваров));
			Область.Параметры.Заполнить(ПолучитьСтруктуруПоДате("ДатаДоговораПоставки", ДанныеПечати.ДатаДоговораПоставки));
			Область.Параметры.ДатаНомерДокументаОВызовеПредставителяПартнера = Формат(ДанныеПечати.ДатаДокументаОВызовеПредставителяПартнера, "Л=uk; ДЛФ=DD")+ ?(ЗначениеЗаполнено(ДанныеПечати.НомерДокументаОВызовеПредставителяПартнера)," №"+ДанныеПечати.НомерДокументаОВызовеПредставителяПартнера,"");
			
			ТабличныйДокумент.Вывести(Область);
			
			// Вывод таблицы товаров по документам
			Область = Макет.ПолучитьОбласть("ТаблицаТоваровПоДокументамШапка");
			ТабличныйДокумент.Вывести(Область);
			Строки = ТаблицаТоваровПоДокументам.НайтиСтроки(Новый Структура("Ссылка",ДанныеПечати.Ссылка));
			Для Каждого Строка Из Строки Цикл
				Область = Макет.ПолучитьОбласть("ТаблицаТоваровПоДокументамСтрока");
				Область.Параметры.Заполнить(Строка);
				Если ПечатьВНоменклатуреПоставщика Тогда
 					Область.Параметры.Товар = Строка.НоменклатураПоставщикаНаименование;
				Иначе
					Область.Параметры.Товар = НоменклатураКлиентСервер.ПредставлениеНоменклатурыДляПечати(
						Строка.НоменклатураНаименование,
						Строка.ХарактеристикаНаименование
					);
				КонецЕсли;
				ТабличныйДокумент.Вывести(Область);
			КонецЦикла;
			Область = Макет.ПолучитьОбласть("ТаблицаТоваровПоДокументамПодвал");
			ТабличныйДокумент.Вывести(Область);
			
			// Вывод таблицы приемки товаров
			Область = Макет.ПолучитьОбласть("ТаблицаПриемкиТоваровШапка");
			ТабличныйДокумент.Вывести(Область);			
			Область = Макет.ПолучитьОбласть("ТаблицаПриемкиТоваровСтрока");
			ТаблицаПриемкиТоваров = ДанныеПечати.ТаблицаПриемкиТоваров.Выгрузить();
			Если ТаблицаПриемкиТоваров.Количество() = 0 Тогда
				ТабличныйДокумент.Вывести(Область);
			Иначе
				Для Каждого Строка Из ТаблицаПриемкиТоваров Цикл
					Область.Параметры.Заполнить(Строка);
					ТабличныйДокумент.Вывести(Область);
				КонецЦикла;
			КонецЕсли;
			Область = Макет.ПолучитьОбласть("ТаблицаПриемкиТоваровПодвал");
			ТабличныйДокумент.Вывести(Область);

			
		ИначеЕсли ИмяМакета = "М7_Страница2" Тогда
			
			Область = Макет.ПолучитьОбласть("ШапкаВторойСтраницы");
		    ТабличныйДокумент.Вывести(Область);
			
			ВывестиМногострочноеПоле(ТабличныйДокумент, Макет, ДанныеПечати, "УсловияХраненияТовараДоВскрытияНаСкладеПолучателя", 4);
			
			ВывестиМногострочноеПоле(ТабличныйДокумент, Макет, ДанныеПечати, "СостояниеТарыИУпаковки", 4);
			
			ВывестиМногострочноеПоле(ТабличныйДокумент, Макет, ДанныеПечати, "СпособОпределенияИКоличествоТоваровКоторыхНедостаточно", 4);
			
			ВывестиМногострочноеПоле(ТабличныйДокумент, Макет, ДанныеПечати, "ПрочиеДанные", 4);

			
		ИначеЕсли ИмяМакета = "М7_Страница3" Тогда
			
			// Получение исходных данных
			ТаблицаТоваров             = ПараметрыПечати.КешИсходныхДанных["ТаблицаТоваров"];
			КолонкаКодов               = ПараметрыПечати.КешИсходныхДанных["КолонкаКодов"];		
						
			// Вывод таблицы товаров
			Область = Макет.ПолучитьОбласть("ТаблицаТоваровШапка");
			Область.Параметры.Заполнить(ДанныеПечати);
			Область.Параметры.НДС =  ?(ДанныеПечати.ЦенаВключаетНДС, "", " " + НСтр("ru='(без ПДВ)';uk='(без ПДВ)'"));
		    ТабличныйДокумент.Вывести(Область);
			
			Область = Макет.ПолучитьОбласть("ТаблицаТоваровСтрока");
			Товары = ТаблицаТоваров.НайтиСтроки(Новый Структура("Ссылка", ДанныеПечати.Ссылка));
			Для Каждого Товар Из Товары Цикл
				Область.Параметры.Заполнить(Товар);
				Если ПечатьВНоменклатуреПоставщика Тогда
					Область.Параметры.Товар = Товар.НоменклатураПоставщика;
				Иначе
					Область.Параметры.Товар = НоменклатураКлиентСервер.ПредставлениеНоменклатурыДляПечати(
						Товар.НоменклатураНаименование,
						Товар.ХарактеристикаНаименование
					);
				КонецЕсли;
				Область.Параметры.НомерПаспорта = Товар.НомерПаспорта;
				Область.Параметры.ЗначениеКода = Товар[КолонкаКодов];
				ТабличныйДокумент.Вывести(Область);
			КонецЦикла;

			Область = Макет.ПолучитьОбласть("ТаблицаТоваровПодвал");
		    ТабличныйДокумент.Вывести(Область);
			
		ИначеЕсли ИмяМакета = "М7_Страница4" Тогда
			
			Область = Макет.ПолучитьОбласть("ШапкаЧетвертойСтраницы");
	    	ТабличныйДокумент.Вывести(Область);		
			
			// Вывод заключения комиссии
			ВывестиМногострочноеПоле(ТабличныйДокумент, Макет, ДанныеПечати, "ЗаключениеКомиссии", 4);
			// Вывод приложения
			ВывестиМногострочноеПоле(ТабличныйДокумент, Макет, ДанныеПечати, "Приложение", 4);
			
			Область = Макет.ПолучитьОбласть("ПодвалЧетвертойСтраницы");
			Область.Параметры.Заполнить(ДанныеПечати);
			
			Область.Параметры.ЧленКомиссии1ФИО = ФизическиеЛицаУТ.ФамилияИнициалыФизЛица(ДанныеПечати.ЧленКомиссии1);
			Область.Параметры.ЧленКомиссии2ФИО = ФизическиеЛицаУТ.ФамилияИнициалыФизЛица(ДанныеПечати.ЧленКомиссии2);
			Область.Параметры.ЧленКомиссии3ФИО = ФизическиеЛицаУТ.ФамилияИнициалыФизЛица(ДанныеПечати.ЧленКомиссии3);

			Область.Параметры.Заполнить(ПолучитьСтруктуруПоДате("ДатаПриемкиТоваров", ДанныеПечати.ДатаПриемкиТоваров));
			Область.Параметры.Заполнить(ПолучитьСтруктуруПоДате("ДатаКоммерческогоАкта", ДанныеПечати.ДатаКоммерческогоАкта));
			Область.Параметры.КладовщикПринявшийТоварФИО = ФизическиеЛицаУТ.ФамилияИнициалыФизЛица(ДанныеПечати.КладовщикПринявшийТовар);			
	    	ТабличныйДокумент.Вывести(Область);		
			
		КонецЕсли;
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ДанныеПечати.Ссылка);
		
	КонецЦикла; 
	
	Если ИмяМакета <> "М7_Страница3" Тогда
		ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
	Иначе
		ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;		
	КонецЕсли;
			
	ТабличныйДокумент.АвтоМасштаб = Истина;
	
КонецПроцедуры

#КонецОбласти
 

#КонецОбласти

#Область Прочее

// Производит пересчет ценовых показателей таблицы товаров в валюте регламентированного учета
//
// Параметры:
//  ТаблицаТоваров - ТаблицаЗначений - Таблица по товарам
//  ТаблицаВалют - ТаблицаЗначений - Таблица значений курсов валют
//
Процедура ПересчитатьСуммыВВалютеРегламентированногоУчета(ТаблицаТоваров, ТаблицаВалют)
	
	СоответствиеСсылок = Новый Соответствие;    // Ключ - <ДокументСсылка.АктОРасхождениях>
	                                            // Значение - <Структура>
	
	Для Каждого Строка Из ТаблицаТоваров Цикл
		
		ТекущаяСсылка = СоответствиеСсылок[Строка.Ссылка];
		
		Если ТекущаяСсылка = Неопределено Тогда
			
			ТекущаяСсылка = Новый Структура;
			
			ОписаниеКурсовВалют = ТаблицаВалют.Найти(Строка.Ссылка, "Ссылка");
			Если ОписаниеКурсовВалют = Неопределено ИЛИ ОписаниеКурсовВалют.ПересчетНеТребуется Тогда
				ТекущаяСсылка.Вставить("ТребуетсяПересчет", Ложь);
			Иначе
				ТекущаяСсылка.Вставить("ТребуетсяПересчет", Истина);
				
				ТекущаяСсылка.Вставить("КоэффициентПересчета",
					ОписаниеКурсовВалют.КурсВалютыДокумента * ОписаниеКурсовВалют.КратностьВалютыРегламентированногоУчета
					/ (ОписаниеКурсовВалют.КратностьВалютыДокумента * ОписаниеКурсовВалют.КурсВалютыРегламентированногоУчета));
				
				ТекущаяСсылка.Вставить("ЦенаВключаетНДСПоДокументам", Строка.ЦенаВключаетНДСПоДокументам);
				ТекущаяСсылка.Вставить("ЦенаВключаетНДСПоФакту", Строка.ЦенаВключаетНДСПоДокументам);
				
				ТекущаяСсылка.Вставить("ИтогПоДокументам", 0);
				ТекущаяСсылка.Вставить("МассивПоДокументам", Новый Массив);
				ТекущаяСсылка.Вставить("ИтогПоФакту", 0);
				ТекущаяСсылка.Вставить("МассивПоФакту", Новый Массив);
				
			КонецЕсли;
			
			СоответствиеСсылок.Вставить(Строка.Ссылка, ТекущаяСсылка);
			
		КонецЕсли;
		
		Если ТекущаяСсылка.ТребуетсяПересчет Тогда
			
			Если Строка.СуммаПоДокументам <> 0 Тогда
				СуммаПоДокументам = ?(ТекущаяСсылка.ЦенаВключаетНДСПоДокументам,
					Строка.СуммаПоДокументам,
					Строка.СуммаПоДокументам+Строка.СуммаНДСПоДокументам)
					* ТекущаяСсылка.КоэффициентПересчета;
				ТекущаяСсылка.ИтогПоДокументам = ТекущаяСсылка.ИтогПоДокументам + СуммаПоДокументам;
				ТекущаяСсылка.МассивПоДокументам.Добавить(СуммаПоДокументам);
			КонецЕсли;
			Если Строка.СуммаПоФакту <> 0 Тогда
				СуммаПоФакту = ?(ТекущаяСсылка.ЦенаВключаетНДСПоФакту,
					Строка.СуммаПоФакту,
					Строка.СуммаПоФакту+Строка.СуммаНДСПоФакту)
					* ТекущаяСсылка.КоэффициентПересчета;
				ТекущаяСсылка.ИтогПоФакту = ТекущаяСсылка.ИтогПоФакту + СуммаПоФакту;
				ТекущаяСсылка.МассивПоФакту.Добавить(СуммаПоФакту);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Для Каждого ТекущаяСсылка Из СоответствиеСсылок Цикл
		
		Если НЕ ТекущаяСсылка.Значение.ТребуетсяПересчет Тогда
			Продолжить;
		КонецЕсли;
		
		ТекущаяСсылка.Значение.МассивПоДокументам = ОбщегоНазначения.РаспределитьСуммуПропорциональноКоэффициентам(
			ТекущаяСсылка.Значение.ИтогПоДокументам, ТекущаяСсылка.Значение.МассивПоДокументам);
		ТекущаяСсылка.Значение.МассивПоФакту = ОбщегоНазначения.РаспределитьСуммуПропорциональноКоэффициентам(
			ТекущаяСсылка.Значение.ИтогПоФакту, ТекущаяСсылка.Значение.МассивПоФакту);
		
	КонецЦикла;
	
	Для Каждого Строка Из ТаблицаТоваров Цикл
		
		ТекущаяСсылка = СоответствиеСсылок[Строка.Ссылка];
		Если ТекущаяСсылка = Неопределено ИЛИ НЕ ТекущаяСсылка.ТребуетсяПересчет Тогда
			Продолжить;
		КонецЕсли;
		
		Если ТекущаяСсылка.МассивПоДокументам <> Неопределено И Строка.СуммаПоДокументам<>0 Тогда
			СтавкаНДСЧислом             = ЦенообразованиеКлиентСервер.ПолучитьСтавкуНДСЧислом(Строка.СтавкаНДС);
			СуммаСНДС                   = ТекущаяСсылка.МассивПоДокументам[0];
			Строка.СуммаНДСПоДокументам = Окр(СуммаСНДС / (1 + СтавкаНДСЧислом) * СтавкаНДСЧислом,2);
			Строка.СуммаПоДокументам    = ?(ТекущаяСсылка.ЦенаВключаетНДСПоДокументам, СуммаСНДС, СуммаСНДС - Строка.СуммаНДСПоДокументам);
			ТекущаяСсылка.МассивПоДокументам.Удалить(0);
			Если Строка.КоличествоПоДокументам > 0 Тогда
				Строка.Цена= Строка.СуммаПоДокументам / Строка.КоличествоПоДокументам;
			КонецЕсли;
		КонецЕсли;
		
		Если ТекущаяСсылка.МассивПоФакту <> Неопределено И Строка.СуммаПоФакту <> 0 Тогда
			СтавкаНДСЧислом        = ЦенообразованиеКлиентСервер.ПолучитьСтавкуНДСЧислом(Строка.СтавкаНДС);
			СуммаСНДСПоФакту       = ТекущаяСсылка.МассивПоФакту[0];
			Строка.СуммаНДСПоФакту = Окр(СуммаСНДСПоФакту / (1 + СтавкаНДСЧислом) * СтавкаНДСЧислом,2);
			Строка.СуммаПоФакту    = ?(ТекущаяСсылка.ЦенаВключаетНДСПоФакту, СуммаСНДСПоФакту, СуммаСНДСПоФакту - Строка.СуммаНДСПоФакту);
			ТекущаяСсылка.МассивПоФакту.Удалить(0);
			Если Строка.КоличествоПоФакту > 0 Тогда
				Строка.Цена = Строка.СуммаПоФакту / Строка.КоличествоПоФакту;
			КонецЕсли;
		Иначе
			Строка.Цена = Строка.Цена;
		КонецЕсли;
		
		Если ТекущаяСсылка.МассивПоДокументам <> Неопределено И Строка.СуммаПоДокументам<>0 Тогда
			Строка.Цена = Строка.Цена;
		КонецЕсли;
		
		Если ТаблицаТоваров.Колонки.Найти("СуммаИзлишек") <> Неопределено Тогда
			Строка.СуммаИзлишек   = ?(Строка.СуммаПоФакту>Строка.СуммаПоДокументам, Строка.СуммаПоФакту-Строка.СуммаПоДокументам, 0);
			Строка.СуммаНедостача = ?(Строка.СуммаПоФакту<Строка.СуммаПоДокументам, Строка.СуммаПоДокументам-Строка.СуммаПоФакту, 0);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Выводит многострочное поле в табличный документ
//
// Параметры:
//  ТабличныйДокумент - ТабличныйДокумент
//  Макет - ТабличныйДокумент - Макет табличного документа
//  ДанныеПечати - ВыборкаИзРезультатаЗапроса
//  ИмяПоля - Строка - Имя реквизита результата запроса, имя области макета, имя параметра области макета
//  КоличествоСтрокРучногоВвода - Число - Количество строк ручного заполнения
//
Процедура ВывестиМногострочноеПоле(ТабличныйДокумент, Макет, ДанныеПечати, ИмяПоля, КоличествоСтрокРучногоВвода=4)
	
	Область = Макет.ПолучитьОбласть(ИмяПоля);
	ТабличныйДокумент.Вывести(Область);
	Если ЗначениеЗаполнено(ДанныеПечати[ИмяПоля]) Тогда
		
		Область = Макет.ПолучитьОбласть("МногострочноеПоле");
		Область.Параметры.Значение = ДанныеПечати[ИмяПоля];
		ТабличныйДокумент.Вывести(Область);
		
	Иначе
		ОбластьСтрокиРучногоЗаполнения = Макет.ПолучитьОбласть("СтрокаРучногоЗаполнения");
		Для Счет =1 По КоличествоСтрокРучногоВвода Цикл
			ТабличныйДокумент.Вывести(ОбластьСтрокиРучногоЗаполнения);
		КонецЦикла;
		
	КонецЕсли;
	
	ОбластьСтрокиПробела = Макет.ПолучитьОбласть("СтрокаПробела");
	ТабличныйДокумент.Вывести(ОбластьСтрокиПробела);
	
КонецПроцедуры

// Получает заполненную структуру по дате и имени параметра
//
// Параметры:
//  ИмяПараметра - Строка - Строка префикса имен параметров структуры
//  Дата - Дата - Дата, которую необходимо разбить на параметры
//
// Возвращаемое значение:
//  Структура даты - Структура - содержит данные указанной даты 
//
Функция ПолучитьСтруктуруПоДате(ИмяПараметра, Дата)
	
	
	СтруктураДаты = Новый Структура;
	Если НЕ ЗначениеЗаполнено(Дата) Тогда
		Возврат СтруктураДаты;
	КонецЕсли;
	СтруктураДаты.Вставить(ИмяПараметра+"День", День(Дата));
 	СтруктураДаты.Вставить(ИмяПараметра+"Месяц", Сред(Формат(Дата,"ДФ=dd.MMMM;Л=uk_UA"), 4));
	СтруктураДаты.Вставить(ИмяПараметра+"Год", Формат(Год(Дата), "ЧГ=0"));
	
	Возврат СтруктураДаты;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли
