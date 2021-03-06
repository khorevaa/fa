﻿
Функция РассчитатьЗначениеПоказателя(ЗначенияПоказателей, Показатель, ЗначениеПоУмолчанию = Неопределено) Экспорт
	Результат = ЗначениеПоУмолчанию;
	
	Если 1=2 Тогда
		Показатель = Справочники.Показатели.ПустаяСсылка();
	КонецЕсли; 
	
	Формула = Показатель.ФормулаРасчета;
	
	Если ПустаяСтрока(Формула) Тогда
		Возврат ЗначениеПоУмолчанию;
	КонецЕсли;
	
	Возврат ВычислитьЗначениеПоФормуле(ЗначенияПоказателей, Показатель, Формула, ЗначениеПоУмолчанию);
	
КонецФункции

Функция ПроверитьЗначениеПоказателя(ЗначенияПоказателей, Показатель, ЗначениеПоУмолчанию = Неопределено) Экспорт
	
	Результат = ЗначениеПоУмолчанию;
	
	Если 1=2 Тогда
		Показатель = Справочники.Показатели.ПустаяСсылка();
	КонецЕсли; 
	
	Формула = Показатель.ФормулаПроверки;
	
	Если ПустаяСтрока(Формула) Тогда
		Возврат ЗначениеПоУмолчанию;
	КонецЕсли;
	
	Возврат ВычислитьЗначениеПоФормуле(ЗначенияПоказателей, Показатель, Формула, ЗначениеПоУмолчанию);
	
КонецФункции

Функция ВычислитьЗначениеПоФормуле(ЗначенияПоказателей, Показатель, Формула, ЗначениеПоУмолчанию = Неопределено)
	
	Значения = Новый Соответствие;
	
	Для Каждого КлючИЗначение Из ЗначенияПоказателей Цикл
		
		ТекПоказатель = КлючИЗначение.Ключ;
		ТекЗнач = КлючИЗначение.Значение;
		ТекУслОбозн = ?(ТипЗнч(ТекПоказатель) = Тип("СправочникСсылка.Показатели"), 
					    ТекПоказатель.УсловноеОбозначение,
						ТекПоказатель);

		Значения.Вставить(ТекУслОбозн, ТекЗнач);
		
	КонецЦикла; 
	
	ИспользумыеУсловныеОбозначения = Новый Массив; 
	Стр = Формула;
	
	НачПоз = Найти(Стр, "[");
	ТекПоз = НачПоз;
	Пока НачПоз > 0 Цикл
		
		НачалоСообщенияОбОшибке = "Ошибка расчета показателя """ + Показатель + """! Ошибка в формуле """ + Формула + """. Поз. #" + ТекПоз + ": ";
		
		КонПоз = Найти(Стр, "]");
		Если КонПоз = 0 
			Или КонПоз <= НачПоз Тогда
		    ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НачалоСообщенияОбОшибке + "Проверьте правильность указания символов ""["" и ""]""!");
			Возврат ЗначениеПоУмолчанию;
		КонецЕсли; 
		
		ТекУслОбозн = Сред(Стр, НачПоз + 1, КонПоз - НачПоз - 1);
		
		Если ПустаяСтрока(ТекУслОбозн) Тогда
		    ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НачалоСообщенияОбОшибке + "Не задано наименование показателя!");
			Возврат ЗначениеПоУмолчанию;
		КонецЕсли; 
		
		Если Значения.Получить(ТекУслОбозн) = Неопределено Тогда
		    ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НачалоСообщенияОбОшибке + "Показатель """ + ТекУслОбозн + """ не найден!");
			Возврат ЗначениеПоУмолчанию;
		КонецЕсли; 
		
		ТекУслОбозн = СтрЗаменить(ТекУслОбозн, """", """""");
		
		Если ИспользумыеУсловныеОбозначения.Найти(ТекУслОбозн) = Неопределено Тогда
			ИспользумыеУсловныеОбозначения.Добавить(ТекУслОбозн);
		КонецЕсли; 
		
		Стр = Сред(Стр, КонПоз + 1);
		ТекПоз = ТекПоз + КонПоз + 1 - НачПоз;
		
		НачПоз = Найти(Стр, "[");
		ТекПоз = ТекПоз + НачПоз - 1;
		
	КонецЦикла; 
	
	НачалоСообщенияОбОшибке = "Ошибка расчета показателя """ + Показатель + """ по формуле """ + Формула + """! ";
	
	ФормулаДляВычисления = Формула;
	
	Для Каждого ТекУслОбозн Из ИспользумыеУсловныеОбозначения Цикл
		
		Если Значения.Получить(ТекУслОбозн) = Неопределено Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НачалоСообщенияОбОшибке + "Значение показателя """ + ТекУслОбозн + """ не установлено!");
			Возврат ЗначениеПоУмолчанию;
		КонецЕсли; 
		
		ФормулаДляВычисления = СтрЗаменить(ФормулаДляВычисления, 
			"[" + ТекУслОбозн + "]",
			"Значения.Получить(""" + ТекУслОбозн + """)");
			
	КонецЦикла; 
	
	УстановитьБезопасныйРежим(Истина);
	Попытка
		Результат = Вычислить(ФормулаДляВычисления);
	Исключение
		Результат = ЗначениеПоУмолчанию;
	    ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НачалоСообщенияОбОшибке
			+ "Техн.информация: Формула для вычисления = """ + ФормулаДляВычисления + ". Описание ошибки = " + ОписаниеОшибки());
	КонецПопытки; 
	УстановитьБезопасныйРежим(Ложь);
	
	Возврат Результат;
	
КонецФункции