////////////////////////////////////////////////////////////////////////////////
// КОД ПРОЦЕДУР И ФУНКЦИЙ модуля ДатыЗапретаИзмененияПереопределяемый
// для поддержки библиотечного подхода разработки
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Вызывается из переопределяемого модуля
Процедура НастройкаИнтерфейса(Знач НастройкиРаботыИнтерфейса) Экспорт
	
	НастройкиРаботыИнтерфейса.ИспользоватьВнешнихПользователей = Истина;
	
КонецПроцедуры

// Вызывается из переопределяемого модуля
Процедура ЗаполнитьИсточникиДанныхДляПроверкиЗапретаИзменения(Знач ИсточникиДанных) Экспорт
	
	// Данные(Таблица, ПолеДаты, Раздел, ПолеОбъекта)
	
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.АвансовыйОтчет",                       "Дата", "АвансовыеОтчеты", "Организация");
	
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ВзаимозачетЗадолженности",             "Дата", "ВзаимозачетыСписанияЗадолженности", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ВзаимозачетЗадолженности",             "Дата", "ВзаимозачетыСписанияЗадолженности", "КонтрагентДебитор");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ВзаимозачетЗадолженности",             "Дата", "ВзаимозачетыСписанияЗадолженности", "КонтрагентКредитор");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.СписаниеЗадолженности",                "Дата", "ВзаимозачетыСписанияЗадолженности", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.СписаниеЗадолженности",                "Дата", "ВзаимозачетыСписанияЗадолженности", "Контрагент");
	
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.АктВыполненныхРабот",                      "Дата", "ПродажиВозвратыОтКлиентов", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.АктОРасхожденияхПослеОтгрузки",            "Дата", "ПродажиВозвратыОтКлиентов", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.АктОРасхожденияхПослеПриемки",             "Дата", "ПродажиВозвратыОтКлиентов", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ВозвратТоваровОтКлиента",                  "Дата", "ПродажиВозвратыОтКлиентов", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.КорректировкаРеализации",                  "Дата", "ПродажиВозвратыОтКлиентов", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ОтчетКомиссионера",                        "Дата", "ПродажиВозвратыОтКлиентов", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ОтчетКомиссионераОСписании",               "Дата", "ПродажиВозвратыОтКлиентов", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ОтчетОРозничныхПродажах",                  "Дата", "ПродажиВозвратыОтКлиентов", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ОтчетОРозничнойВыручке",                   "Дата", "ПродажиВозвратыОтКлиентов", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.РеализацияТоваровУслуг",                   "Дата", "ПродажиВозвратыОтКлиентов", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.РеализацияУслугПрочихАктивов",             "Дата", "ПродажиВозвратыОтКлиентов", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.НалоговаяНакладная",                   "Дата", "ПродажиВозвратыОтКлиентов", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.Приложение2КНалоговойНакладной",       "Дата", "ПродажиВозвратыОтКлиентов", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ВыкупВозвратнойТарыКлиентом",              "Дата", "ПродажиВозвратыОтКлиентов", "Организация");
	 
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ВозвратТоваровПоставщику",             "Дата", "ЗакупкиВозвратыПоставщикамПеремещенияСборки", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.КорректировкаПоступления",             "Дата", "ЗакупкиВозвратыПоставщикамПеремещенияСборки", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ОтчетКомитенту",                       "Дата", "ЗакупкиВозвратыПоставщикамПеремещенияСборки", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ОтчетКомитентуОСписании",              "Дата", "ЗакупкиВозвратыПоставщикамПеремещенияСборки", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ПоступлениеТоваровУслуг",              "Дата", "ЗакупкиВозвратыПоставщикамПеремещенияСборки", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ПоступлениеУслугПрочихАктивов",        "Дата", "ЗакупкиВозвратыПоставщикамПеремещенияСборки", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ПеремещениеТоваров",                   "Дата", "ЗакупкиВозвратыПоставщикамПеремещенияСборки", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.СборкаТоваров",                        "Дата", "ЗакупкиВозвратыПоставщикамПеремещенияСборки", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ТаможеннаяДекларацияИмпорт",           "Дата", "ЗакупкиВозвратыПоставщикамПеремещенияСборки", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.РегистрацияВходящегоНалоговогоДокумента", "Дата", "ЗакупкиВозвратыПоставщикамПеремещенияСборки", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ВыкупВозвратнойТарыУПоставщика",       "Дата", "ЗакупкиВозвратыПоставщикамПеремещенияСборки", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.КорректировкаНазначенияТоваров",       "Дата", "ЗакупкиВозвратыПоставщикамПеремещенияСборки", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.АктОРасхожденияхПослеПеремещения",     "Дата", "ЗакупкиВозвратыПоставщикамПеремещенияСборки", "Организация");
	
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ВнутреннееПотреблениеТоваров",         "Дата", "СписанияОприходованияТоваров", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ОприходованиеИзлишковТоваров",         "Дата", "СписанияОприходованияТоваров", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ПересортицаТоваров",                   "Дата", "СписанияОприходованияТоваров", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ПорчаТоваров",                         "Дата", "СписанияОприходованияТоваров", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ПрочееОприходованиеТоваров",           "Дата", "СписанияОприходованияТоваров", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.СписаниеНедостачТоваров",              "Дата", "СписанияОприходованияТоваров", "Организация");
	
	
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ВозвратТоваровМеждуОрганизациями",                        "Дата", "РегламентныеОперации", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ОтчетПоКомиссииМеждуОрганизациями",                       "Дата", "РегламентныеОперации", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ОтчетПоКомиссииМеждуОрганизациямиОСписании",              "Дата", "РегламентныеОперации", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ПередачаТоваровМеждуОрганизациями",                       "Дата", "РегламентныеОперации", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.РаспределениеДоходовИРасходовПоНаправлениямДеятельности", "Дата", "РегламентныеОперации", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.РаспределениеРасходовБудущихПериодов",                    "Дата", "РегламентныеОперации", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.РасчетСебестоимостиТоваров",                              "Дата", "РегламентныеОперации", "");
	
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.УстановкаКоэффициентаПропорциональногоНДС",  			 "Дата", "РегламентныеОперации", "Организация");
	
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ВводОстатков",                                            "Дата", "РегламентныеОперации", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ПрочиеДоходыРасходы",                                     "Дата", "РегламентныеОперации", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ДвижениеПрочихАктивовПассивов",                           "Дата", "РегламентныеОперации", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.КорректировкаНалоговогоНазначенияЗапасов",               "Дата", "РегламентныеОперации", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.НачисленияКредитовИДепозитов",                            "Дата", "РегламентныеОперации", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ПереоценкаВалютныхСредств",                               "Дата", "РегламентныеОперации", "Организация");
	
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ОтчетБанкаПоОперациямЭквайринга",      "Дата", "Банк", "БанковскийСчет");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ПоступлениеБезналичныхДенежныхСредств","ДатаПроведенияБанком", "Банк", "БанковскийСчет");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.СписаниеБезналичныхДенежныхСредств",   "ДатаПроведенияБанком", "Банк", "БанковскийСчет");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ПокупкаПродажаВалюты",                 "Дата", "Банк", "");
	
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ОперацияПоПлатежнойКарте",                          "Дата", "Касса", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ПриходныйКассовыйОрдер",                            "Дата", "Касса", "Касса");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.РасходныйКассовыйОрдер",                            "Дата", "Касса", "Касса");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ИнвентаризацияНаличныхДенежныхСредств",             "Дата", "Касса", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ОтражениеРасхожденийПриИнкассацииДенежныхСредств",  "Дата", "Касса", "Организация");
	
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ОрдерНаОтражениеИзлишковТоваров",             "Дата", "СкладскиеОперации", "Склад");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ОрдерНаОтражениеНедостачТоваров",             "Дата", "СкладскиеОперации", "Склад");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ОрдерНаОтражениеПорчиТоваров",                "Дата", "СкладскиеОперации", "Склад");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ОрдерНаПеремещениеТоваров",                   "Дата", "СкладскиеОперации", "Склад");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ОтборРазмещениеТоваров",                      "Дата", "СкладскиеОперации", "Склад");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.КорректировкаПоОрдеруНаТовары",  			 "Дата", "СкладскиеОперации", "Склад");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ПересчетТоваров",                             "Дата", "СкладскиеОперации", "Склад");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ПриходныйОрдерНаТовары",                      "Дата", "СкладскиеОперации", "Склад");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.РасходныйОрдерНаТовары",                      "ДатаОтгрузки", "СкладскиеОперации", "Склад");
	
	
	// Планирование
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ПланПродажПоКатегориям", "Дата",               "Планирование", "");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ПланПродажПоКатегориям", "НачалоПериода",      "Планирование", "");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.НормативРаспределенияПлановПродажПоКатегориям", "Дата", "Планирование", "");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.НормативРаспределенияПлановПродажПоКатегориям", "ДатаНачалаДействия", "Планирование", "");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ПланЗакупок",            "Дата",               "Планирование", "");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ПланЗакупок",            "НачалоПериода",      "Планирование", "");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ПланПродаж",             "Дата",               "Планирование", "");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ПланПродаж",             "НачалоПериода",      "Планирование", "");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ПланСборкиРазборки",     "Дата",               "Планирование", "");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ПланСборкиРазборки",     "НачалоПериода",      "Планирование", "");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ПрочиеДоходыРасходы", "ПрочиеРасходы.ДатаОтражения", "РегламентныеОперации", "ПрочиеРасходы.ДатаОтражения");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ПрочиеДоходыРасходы", "ПрочиеДоходы.ДатаОтражения", "РегламентныеОперации", "ПрочиеРасходы.ДатаОтражения");
	
	
КонецПроцедуры

// Вызывается из переопределяемого модуля
Процедура ПередПроверкойЗапретаИзменения(Объект,
                                         ПроверкаЗапретаИзменения,
                                         УзелПроверкиЗапретаЗагрузки,
                                         ВерсияОбъекта) Экспорт
	
	Если ТипЗнч(Объект) = Тип("ДокументОбъект.СписаниеБезналичныхДенежныхСредств")
		Или ТипЗнч(Объект) = Тип("ДокументОбъект.ПоступлениеБезналичныхДенежныхСредств") Тогда
		// Отказ от проверки с учетом того, что ДатаПроведенияБанком, используемая в проверке, не указывается,
		// если документ не проведен банком, а указывается позже, после проведения документа банком.
		ПроведеноБанкомНоваяВерсия  = Объект.ПроведеноБанком;
		ПроведеноБанкомСтараяВерсия = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(
			Объект.Ссылка, "ПроведеноБанком") = Истина;
		
		Если Не ПроведеноБанкомНоваяВерсия И Не ПроведеноБанкомСтараяВерсия Тогда
			ПроверкаЗапретаИзменения = Ложь;
			УзелПроверкиЗапретаЗагрузки = Неопределено;
			
		ИначеЕсли Не ПроведеноБанкомНоваяВерсия Тогда
			ВерсияОбъекта = "СтараяВерсия"; // Проверить только новую версию объекта.
			
		ИначеЕсли Не ПроведеноБанкомСтараяВерсия Тогда
			ВерсияОбъекта = "НоваяВерсия"; // Проверить только старую версию объекта.
		КонецЕсли;
		
	КонецЕсли;
	
	// При работе помощника зачета оплаты не учитывается дата запрета изменения.
	Если Объект.ДополнительныеСвойства.Свойство("ПроверкаДатыЗапретаИзменения") Тогда
		ПроверкаЗапретаИзменения = Объект.ДополнительныеСвойства.ПроверкаДатыЗапретаИзменения;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти
