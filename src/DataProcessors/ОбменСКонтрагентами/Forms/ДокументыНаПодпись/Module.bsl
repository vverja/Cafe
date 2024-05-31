
#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ВыполнятьКОНаСервере Тогда
		ДействияПриОткрытии();
	Иначе
		Доступность = Ложь;
		Обработчик = Новый ОписаниеОповещения("ПослеУстановкиРасширенияДляРаботыСКриптографией", ЭтотОбъект);
		ТекстВопроса = НСтр("ru='Для работы с ЭП необходимо установить
                                |расширение работы с криптографией.'
                                |;uk='Для роботи з ЕП необхідно встановити
                                |розширення роботи з криптографією.'");
		ЭлектроннаяПодписьКлиент.УстановитьРасширение(Ложь, Обработчик, ТекстВопроса);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЭлектронноеВзаимодействиеСлужебныйВызовСервера.ЗначениеФункциональнойОпции("ИспользоватьОбменЭД") Тогда
		ТекстСообщения = ЭлектронноеВзаимодействиеСлужебныйВызовСервера.ТекстСообщенияОНеобходимостиНастройкиСистемы("РаботаСЭД");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , , , Отказ);
		Отказ = Истина;
	КонецЕсли;
	
	Если НЕ ЭлектронноеВзаимодействиеСлужебныйВызовСервера.ЗначениеФункциональнойОпции("ИспользоватьЭлектронныеПодписиЭД") Тогда
		ТекстСообщения = ЭлектронноеВзаимодействиеСлужебныйВызовСервера.ТекстСообщенияОНеобходимостиНастройкиСистемы("ПодписаниеЭД");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , , , Отказ);
		Отказ = Истина;
	КонецЕсли;
	
	Если Не Отказ Тогда
		Элементы.СтраницыАРМ.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
		
		АктуальныеВидыЭД = ОбменСКонтрагентамиПовтИсп.ПолучитьАктуальныеВидыЭД();
		Элементы.ВидЭД.СписокВыбора.ЗагрузитьЗначения(АктуальныеВидыЭД);
		ВыполнятьКОНаСервере = ЭлектронноеВзаимодействиеСлужебныйВызовСервера.ВыполнятьКриптооперацииНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОбновитьСостояниеЭД" Тогда
		ПерезаполнитьТаблицы();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	
	ПерезаполнитьТаблицы();
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаДокументовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОбменСКонтрагентамиСлужебныйКлиент.ОткрытьЭДДляПросмотра(Элементы.ТаблицаДокументов.ТекущиеДанные.ЭлектронныйДокумент);
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаСертификатовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СертификатПодписи = Элементы.ТаблицаСертификатов.ТекущиеДанные.Сертификат;
	Если НЕ ЕстьДокументыНаПодпись() Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьСписокДокументовПоСертификату();
	ПерейтиНаСтраницу(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ВидЭДПриИзменении(Элемент)
	
	ПерезаполнитьТаблицы();
	
КонецПроцедуры

&НаКлиенте
Процедура НаправлениеЭДПриИзменении(Элемент)
	
	ПерезаполнитьТаблицы();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Обновить(Команда)
	
	ПерезаполнитьТаблицы();
	
КонецПроцедуры

&НаКлиенте
Процедура Подписать(Команда)
	
	МассивЭД = Новый Массив;
	Для Каждого ТекСтрока Из ТаблицаДокументов Цикл
		Если ТекСтрока.Выбрать Тогда
			МассивЭД.Добавить(ТекСтрока.ЭлектронныйДокумент);
		КонецЕсли;
	КонецЦикла;
	
	ОбменСКонтрагентамиКлиент.СформироватьПодписатьОтправитьЭД(Неопределено, МассивЭД);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодписатьВсе(Команда)
	
	Если НЕ ЕстьДокументыНаПодпись() Тогда
		Возврат;
	КонецЕсли;
	
	// По выделенному сертификату найдем все документы на подпись
	СертификатПодписи = ?(Элементы.ТаблицаСертификатов.ТекущиеДанные = Неопределено,
		ТаблицаСертификатов[0].Сертификат, Элементы.ТаблицаСертификатов.ТекущиеДанные.Сертификат);
	
	ПараметрыОтбора = Новый Структура("Сертификат", СертификатПодписи);
	СтрокиДокументов = СводнаяТаблица.НайтиСтроки(ПараметрыОтбора);
	
	МассивДокументовНаПодпись = Новый Массив;
	Для Каждого ЭлементТаблицы Из СтрокиДокументов Цикл
		МассивДокументовНаПодпись.Добавить(ЭлементТаблицы.ЭлектронныйДокумент);
	КонецЦикла;
	
	ОбменСКонтрагентамиКлиент.СформироватьПодписатьОтправитьЭД(МассивДокументовНаПодпись);
	
КонецПроцедуры

&НаКлиенте
Процедура ВернутьсяКСпискуСертификатов(Команда)
	
	ПерейтиНаСтраницу(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиКСпискуДокументов(Команда)
	
	СертификатПодписи = ?(Элементы.ТаблицаСертификатов.ТекущиеДанные = Неопределено,
		ТаблицаСертификатов[0].Сертификат, Элементы.ТаблицаСертификатов.ТекущиеДанные.Сертификат);
		
	Если НЕ ЕстьДокументыНаПодпись() Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьСписокДокументовПоСертификату();
	ПерейтиНаСтраницу(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтметитьВыделенные(Команда)
	
	МассивСтрок = Элементы.ТаблицаДокументов.ВыделенныеСтроки;
	Для Каждого НомерСтроки Из МассивСтрок Цикл
		СтрокаТаблицы = ТаблицаДокументов.НайтиПоИдентификатору(НомерСтроки);
		Если СтрокаТаблицы <> Неопределено Тогда
			СтрокаТаблицы.Выбрать = Истина;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьОтметкуСоВсехСтрок(Команда)
	
	Для Каждого ТекДокумент Из ТаблицаДокументов Цикл
		Если ТекДокумент.Выбрать Тогда
			ТекДокумент.Выбрать = Ложь;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьСписокСертификатовИДокументов(МассивОтпечатковСертификатов)
	
	ТаблицаДоступныхСертификатов = ОбменСКонтрагентамиСлужебный.ТаблицаДоступныхДляПодписиСертификатов(
																			МассивОтпечатковСертификатов);
	ЗаполнитьСводнуюТаблицу(ТаблицаДоступныхСертификатов);
	ЗаполнитьСписокСертификатов(ТаблицаДоступныхСертификатов);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокСертификатов(ТаблицаДоступныхСертификатов)
	
	ТаблицаСертификатов.Очистить();
	Для Каждого ТекСтрока Из ТаблицаДоступныхСертификатов Цикл
		СтрокаТаблицы = ТаблицаСертификатов.Добавить();
		СтрокаТаблицы.Сертификат = ТекСтрока.Ссылка;
		СтрокаТаблицы.Отпечаток = ТекСтрока.Отпечаток;
		СтрокаТаблицы.ПарольПользователя = ТекСтрока.ПарольПользователя;
		ПараметрыОтбора = Новый Структура("Сертификат", ТекСтрока.Ссылка);
		СтрокаТаблицы.КоличествоДокументов = СводнаяТаблица.НайтиСтроки(ПараметрыОтбора).Количество();
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСводнуюТаблицу(ТаблицаДоступныхСертификатов)
	
	ЗапросПоДокументам = Новый Запрос;
	
	СтруктураДопОтбора = Новый Структура;
	Если ЗначениеЗаполнено(Контрагент) Тогда 
		СтруктураДопОтбора.Вставить("Контрагент", Контрагент);
		ЗапросПоДокументам.УстановитьПараметр("Контрагент", Контрагент);
	КонецЕсли;
	Если ЗначениеЗаполнено(ВидЭД) Тогда 
		СтруктураДопОтбора.Вставить("ВидЭД", ВидЭД);
		ЗапросПоДокументам.УстановитьПараметр("ВидЭД", ВидЭД);
	КонецЕсли;
	Если ЗначениеЗаполнено(НаправлениеЭД) Тогда 
		СтруктураДопОтбора.Вставить("НаправлениеЭД", НаправлениеЭД);
		ЗапросПоДокументам.УстановитьПараметр("НаправлениеЭД", НаправлениеЭД);
	КонецЕсли;
	
	ЗапросПоДокументам.Текст = ОбменСКонтрагентами.ПолучитьТекстЗапросаЭлектронныхДокументовНаПодписи(Ложь, СтруктураДопОтбора);
	ЗапросПоДокументам.УстановитьПараметр("ТекущийПользователь", Пользователи.ТекущийПользователь());
	ЗапросПоДокументам.УстановитьПараметр("ПользовательНеУказан", Пользователи.СсылкаНеуказанногоПользователя());
	Таблица = ЗапросПоДокументам.Выполнить().Выгрузить();
	
	ЗначениеВРеквизитФормы(Таблица, "СводнаяТаблица");
	
КонецПроцедуры

&НаКлиенте
Процедура ПерезаполнитьТаблицы()
	
	Оповещение = Новый ОписаниеОповещения("ПослеПолученияОтпечатковПерезаполнитьТаблицы", ЭтотОбъект);
	ЭлектроннаяПодписьКлиент.ПолучитьОтпечаткиСертификатов(Оповещение, Истина, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеПолученияОтпечатковПерезаполнитьТаблицы(Отпечатки, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если Не ТипЗнч(Отпечатки) = Тип("Соответствие") Тогда
		Возврат;
	КонецЕсли;
	
	МассивОтпечатковСертификатов = Новый Массив;
	Для Каждого КлючЗначение Из Отпечатки Цикл
		МассивОтпечатковСертификатов.Добавить(КлючЗначение.Ключ);
	КонецЦикла;
	
	ОтпечаткиСервера = ЭлектронноеВзаимодействиеСлужебныйВызовСервера.МассивОтпечатковСертификатов();
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(МассивОтпечатковСертификатов, ОтпечаткиСервера, Истина);
	
	ЗаполнитьСписокСертификатовИДокументов(МассивОтпечатковСертификатов);
	ЗаполнитьСписокДокументовПоСертификату();
	
КонецПроцедуры

&НаКлиенте
Функция ЕстьДокументыНаПодпись() 
	
	ПроверочныеДанные = ?(Элементы.ТаблицаСертификатов.ТекущиеДанные = Неопределено,
		ТаблицаСертификатов[0], Элементы.ТаблицаСертификатов.ТекущиеДанные);
	
	Если ПроверочныеДанные.КоличествоДокументов = 0 Тогда
		ТекстПредупреждения = НСтр("ru='По данному сертификату нет документов на подпись';uk='За цим сертифікатом немає документів на підпис'");
		ПоказатьПредупреждение(, ТекстПредупреждения);
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

&НаКлиенте
Процедура ПерейтиНаСтраницу(КДетализации)
	
	Если КДетализации Тогда
		Элементы.СтраницыАРМ.ТекущаяСтраница = Элементы.СтраницыАРМ.ПодчиненныеЭлементы.СтраницаДетализации;
		Заголовок = НСтр("ru='Документы на подпись по сертификату';uk='Документи на підпис за сертифікатом'")+ ": " + СертификатПодписи;
	Иначе
		Элементы.СтраницыАРМ.ТекущаяСтраница = Элементы.СтраницыАРМ.ПодчиненныеЭлементы.СтраницаСводки;
		Заголовок = НСтр("ru='Документы на подпись';uk='Документи на підпис'");
	КонецЕсли;
	
	Элементы.Подписать.Заголовок = НСтр("ru='Подписать и отправить отмеченные';uk='Підписати і відправити відмічені'");
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокДокументовПоСертификату()
	
	ТаблицаДокументов.Очистить();
	ПараметрыОтбора = Новый Структура("Сертификат", СертификатПодписи);
	СтрокиДокументов = СводнаяТаблица.НайтиСтроки(ПараметрыОтбора);
	
	Для Каждого СтрокаСДокументом Из СтрокиДокументов Цикл
		СтрокаТаблицы = ТаблицаДокументов.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТаблицы, СтрокаСДокументом);
	КонецЦикла;
		
КонецПроцедуры

&НаКлиенте
Процедура ОповеститьПользователя(КолПодписанных, КолПодготовленных, КолОтправленных)
	
	ТекстСостояния = НСтр("ru='Подписано произвольных ЭД: (%1)';uk='Підписано довільних ЕД: (%1)'");
	Количество = 0;
	Если КолОтправленных > 0 Тогда
		ТекстСостояния = ТекстСостояния + Символы.ПС + НСтр("ru='Отправлено: (%2)';uk='Відправлено: (%2)'");
		Количество = КолОтправленных;
	ИначеЕсли КолПодготовленных > 0 Тогда
		ТекстСостояния = НСтр("ru='Подготовлено к отправке: (%2)';uk='Підготовлено до відправки: (%2)'");
		Количество = КолПодготовленных;
	КонецЕсли;
	ТекстЗаголовка = НСтр("ru='Обмен электронными документами';uk='Обмін електронними документами'");
	ТекстСостояния = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСостояния, КолПодписанных, Количество);
	ПоказатьОповещениеПользователя(ТекстЗаголовка, , ТекстСостояния);
	
	Оповестить("ОбновитьСостояниеЭД");
	
КонецПроцедуры

&НаКлиенте
Процедура ДействияПриОткрытии()
	
	Отказ = Ложь;
	
	Оповещение = Новый ОписаниеОповещения("ПослеПолученияОтпечатковВыполнитьДействия", ЭтотОбъект);
	ЭлектроннаяПодписьКлиент.ПолучитьОтпечаткиСертификатов(Оповещение, Истина, НЕ ВыполнятьКОНаСервере);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Служебные обработчики асинхронных диалогов

&НаКлиенте
Процедура ПослеПолученияОтпечатковВыполнитьДействия(Отпечатки, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если ТипЗнч(Отпечатки) <> Тип("Соответствие") Тогда
		Закрыть();
		Возврат;
	КонецЕсли;
	
	МассивОтпечатковСертификатов = Новый Массив;
	Для Каждого КлючЗначение Из Отпечатки Цикл
		МассивОтпечатковСертификатов.Добавить(КлючЗначение.Ключ);
	КонецЦикла;
	
	ОтпечаткиСервера = ЭлектронноеВзаимодействиеСлужебныйВызовСервера.МассивОтпечатковСертификатов();
	
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(МассивОтпечатковСертификатов, ОтпечаткиСервера);

	ЗаполнитьСписокСертификатовИДокументов(МассивОтпечатковСертификатов);
	
	Если ТаблицаСертификатов.Количество() = 0 Тогда
		ТекстПредупреждения = НСтр("ru='Нет сертификатов подписи для пользователя
                                        |или не настроены правила подписи документов!'
                                        |;uk='Немає сертифікатів підпису для користувача
                                        |або не настроєні правила підпису документів!'");
		ОписаниеОповещения = Новый ОписаниеОповещения("ПослеЗакрытияПредупреждения", ЭтотОбъект);
		ПоказатьПредупреждение(ОписаниеОповещения, ТекстПредупреждения);
	ИначеЕсли ТаблицаСертификатов.Количество() > 1 Тогда
		ПерейтиНаСтраницу(Ложь);
	Иначе
		СертификатПодписи = ТаблицаСертификатов[0].Сертификат;
		ЗаполнитьСписокДокументовПоСертификату();
		ПерейтиНаСтраницу(Истина);
		Элементы.ГруппаКнопкиНазад.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияПредупреждения(ДополнительныеПараметры = Неопределено) Экспорт
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеУстановкиРасширенияДляРаботыСКриптографией(РасширениеУстановлено, ДополнительныеПараметры) Экспорт
	
	Если РасширениеУстановлено = Истина Тогда
		Доступность = Истина;
		ВыполнятьКОНаСервере = Ложь;
		ДействияПриОткрытии();
	Иначе
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеОтправкиПЭД(Результат, ДополнительныеПараметры) Экспорт
	
	КолПодписанных = 0;
	КолПодготовленных = 0;
	КолОтправленных = 0;
	Если ТипЗнч(Результат) = Тип("Структура") Тогда
		Если НЕ(Результат.Свойство("КолПодготовленных", КолПодготовленных)
				И ТипЗнч(КолПодготовленных) = Тип("Число")) Тогда
			//
			КолПодготовленных = 0;
		КонецЕсли;
		Если НЕ(Результат.Свойство("КолОтправленных", КолОтправленных)
				И ТипЗнч(КолОтправленных) = Тип("Число")) Тогда
			//
			КолОтправленных = 0;
		КонецЕсли;
	КонецЕсли;
	Если ТипЗнч(ДополнительныеПараметры) = Тип("Число") Тогда
		КолПодписанных = ДополнительныеПараметры;
	КонецЕсли;
	
	ОповеститьПользователя(КолПодписанных, КолПодготовленных, КолОтправленных);
	
КонецПроцедуры

#КонецОбласти
