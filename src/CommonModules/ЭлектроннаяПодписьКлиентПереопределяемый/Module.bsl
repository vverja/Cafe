////////////////////////////////////////////////////////////////////////////////
// Подсистема "Электронная подпись".
// 
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Вызывается после создания на сервере, но до открытия форм ПодписаниеДанных, РасшифровкаДанных.
// Используется для дополнительных действий, которые требуют серверного вызова, чтобы не
// вызывать сервер лишний раз.
//
// Параметры:
//  Операция          - Строка - строка Подписание или Расшифровка.
//
//  ВходныеПараметры  - Произвольный - значение свойства ПараметрыДополнительныхДействий
//                      параметра ОписаниеДанных методов Подписать, Расшифровать общего
//                      модуля ЭлектроннаяПодписьКлиент.
//                      
//  ВыходныеПараметры - Произвольный - произвольные данные, которые были возвращены
//                      с сервера из одноименной процедуры общего модуля.
//                      ЭлектроннаяПодписьПереопределяемый.
//
Процедура ПередНачаломОперации(Операция, ВходныеПараметры, ВыходныеПараметры) Экспорт
	
	
	
КонецПроцедуры

// Вызывается из формы ПроверкаСертификата, если при создании формы были добавлены дополнительные проверки.
//
// Параметры:
//  Параметры - Структура - со свойствами:
//  * ОжидатьПродолжения   - Булево - (возвращаемое значение) - если Истина, тогда дополнительная проверка
//                            будет выполнятся асинхронно, продолжение возобновится после выполнения оповещения.
//                            Начальное значение Ложь.
//  * Оповещение           - ОписаниеОповещения - обработка, которую нужно вызывать для продолжения
//                              после асинхронного выполнения дополнительной проверки.
//  * Сертификат           - СправочникСсылка.СертификатыКлючейЭлектроннойПодписиИШифрования - проверяемый сертификат.
//  * Проверка             - Строка - имя проверки, добавленное в процедуре ПриСозданииФормыПроверкаСертификата
//                              общего модуля ЭлектроннаяПодписьПереопределяемый.
//  * МенеджерКриптографии - МенеджерКриптографии - подготовленный менеджер криптографии для
//                              выполнения проверки.
//                         - Неопределено - если стандартные проверки отключены в процедуре
//                              ПриСозданииФормыПроверкаСертификата общего модуля ЭлектроннаяПодписьПереопределяемый.
//  * ОписаниеОшибки       - Строка - (возвращаемое значение) - описание ошибки, полученной при выполнении проверки.
//                              Это описание сможет увидеть пользователь при нажатии на картинку результата.
//  * ЭтоПредупреждение    - Булево - (возвращаемое значение) - вид картинки Ошибка/Предупреждение 
//                            начальное значение Ложь.
//
Процедура ПриДополнительнойПроверкеСертификата(Параметры) Экспорт
	
	Возврат;
	
КонецПроцедуры

// Вызывается при открытии инструкции по работе с программами электронной подписи и шифрования.
//
// Параметры:
//  Раздел - Строка - начальное значение "БухгалтерскийИНалоговыйУчет",
//                    можно указать "УчетВГосударственныхУчреждениях".
//
Процедура ПриОпределенииРазделаСтатьиНаИТС(Раздел) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти
