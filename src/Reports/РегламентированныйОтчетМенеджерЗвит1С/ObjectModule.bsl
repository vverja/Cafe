#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
Перем мВерсияОтчета Экспорт;
Перем мПолноеИмяФайлаВнешнейОбработки Экспорт;

Функция ТаблицаФормОтчета() Экспорт
	
	ОписаниеТиповСтрока = Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(0));
	
	МассивТипов = Новый Массив;
	МассивТипов.Добавить(Тип("Дата"));
	ОписаниеТиповДата = Новый ОписаниеТипов(МассивТипов, , Новый КвалификаторыДаты(ЧастиДаты.Дата));
		
	ТаблицаФормОтчета = Новый ТаблицаЗначений;
	ТаблицаФормОтчета.Колонки.Добавить("ФормаОтчета",        ОписаниеТиповСтрока);
	ТаблицаФормОтчета.Колонки.Добавить("ОписаниеОтчета",     ОписаниеТиповСтрока, НСтр("ru='Утверждена';uk='Затверджена'"),  20);
	ТаблицаФормОтчета.Колонки.Добавить("ДатаНачалоДействия", ОписаниеТиповДата,   НСтр("ru='Действует с';uk='Діє з'"), 5);
	ТаблицаФормОтчета.Колонки.Добавить("ДатаКонецДействия",  ОписаниеТиповДата,   НСтр("ru='         по';uk='         по'"), 5);
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2016УФ";
	НоваяФорма.ОписаниеОтчета     = НСтр("ru='Утверждена Приказом Минфина Украины от 28.01.2016 № 21';uk= 'Затверджено Наказом Міністерства фінансів від 28.01.2016 № 21'");
	НоваяФорма.ДатаНачалоДействия = '2016-01-01';
	НоваяФорма.ДатаКонецДействия  = '2016-07-31';

	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2016Мес8УФ";
	НоваяФорма.ОписаниеОтчета     = НСтр("ru='Утверждена Приказом Минфина Украины от 28.01.2016 № 21 (с изменениями внесенными Приказом Минфина от 25.05.2016 № 503)';uk= 'Затверджено Наказом Міністерства фінансів від 28.01.2016 № 21 (зі змінами,  що внесені Наказом Мінфіна від 25.05.2016 № 503)'");
	НоваяФорма.ДатаНачалоДействия = '2016-08-01';
	НоваяФорма.ДатаКонецДействия  = '2017-02-28';
		
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2017УФ";
	НоваяФорма.ОписаниеОтчета     = НСтр("ru='Утверждена Приказом Минфина Украины от 28.01.2016 № 21 (в редакции Приказа Минфина от 23.02.2017 № 276)';uk= 'Затверджено Наказом Міністерства фінансів від 28.01.2016 № 21 (в редакції Наказу Мінфіна від 23.02.2017 № 276)'");
	НоваяФорма.ДатаНачалоДействия = '2017-03-01';
	НоваяФорма.ДатаКонецДействия  = Неопределено;
	
	Возврат ТаблицаФормОтчета;
	
КонецФункции

мВерсияОтчета = "БП 2.1.21.3.1";

#КонецЕсли
