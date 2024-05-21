#!/bin/bash

#адрес электронной почты
EMAIL="ddmitiy@mail.ru"
LOG_FILE="access.log"

LOCKFILE=/tmp/script.lock

function sleep_new() {
sleep 3
}

if [ -e "$LOCKFILE" ] 
then echo 'Ошибка: уже запущен другой экземпляр скрипта'
	exit 1
else touch $LOCKFILE
echo "Создан файл"
 

fi


#echo $$ > $LOCKFILE
trap "rm -f $LOCKFILE" EXIT

echo "Список IP адресов (с наибольшим кол-вом запросов) с указанием кол-ва запросов c момента последнего запуска скрипта;"
sleep_new

DZ_RESULT1=$(awk '{print $1}' $LOG_FILE  | sort | uniq -c | sort -rnk1)

echo "Список запрашиваемых URL (с наибольшим кол-вом запросов) с указанием кол-ва запросов c момента последнего запуска скрипта;"
sleep_new
DZ_RESULT2=$(awk '{print $7}' $LOG_FILE  | sort | uniq -c | sort -rnk1)

echo "Ошибки веб-сервера/приложения c момента последнего запуска;"
DZ_RESULT3=$(grep -in error access.log)


echo "2 вариант"
sleep_new
DZ_RESULT4=$(grep -v '200' access.log) 

echo "Список всех кодов HTTP ответа с указанием их кол-ва с момента последнего запуска скрипта;"
sleep_new
DZ_RESULT5=$(awk '{print $9}' access.log | sort| uniq -c | sort -k2) 

MESSAGE="Результат анализа логов: $DZ_RESULT1 DZ_RESULT2 DZ_RESULT3 DZ_RESULT4 DZ_RESULT5"

echo "$MESSAGE" | mail -s "Отчет анализа логов" "$EMAIL"

rm -f "$LOCKFILE"
