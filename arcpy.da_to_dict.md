## Получение данных из курсора arcpy.da в виде словаря

Пусть есть таблица "cities", в которой есть следующие столбцы: "OBJECTID", "CITY_ID", "NAME", "POPULATION".

Чтобы получить данные о населении городов используем arcpy.da:

```python
import arcpy

with arcpy.da.SearchCursor(r'C:\tmp\data.gdb\cities', '*') as sc:
    for row in sc:
        print 'Name: ', row[2], 'Population: ', row[3]
```

Обращение к данным в строке курсора осуществляется с помощью индексов (например row[3]). Бывает такое, что в таблице полей не 4, а 40, и необходимо еще сделать математические манипуляции с данными, такой код сложно читать:

```python
index = (row[18] - row[33]) * (row[24] + row[37]) ** -1 * 100
```

Как вариант - превратить данные курсора в словарь или именнованный кортеж, и тогда появится возможность обращаться к полям таблицы по имени.

Словарь:

```python
import arcpy


def rows_as_dicts(cursor):
    colnames = cursor.fields
    for row in cursor:
        yield dict(zip(colnames, row))

with arcpy.da.SearchCursor(r'C:\tmp\data.gdb\cities', '*') as sc:
    for row in rows_as_dicts(sc):
        print 'Name: ', row['NAME'], 'Population: ', row['POPULATION']
``` 

Именованный кортеж:

```python
import collections
import arcpy


def rows_as_namedtuples(cursor):
    col_tuple = collections.namedtuple('Row', cursor.fields)
    for row in cursor:
        yield col_tuple(*row)

with arcpy.da.SearchCursor(r'C:\tmp\data.gdb\cities', '*') as sc:
    for row in rows_as_namedtuples(sc):
        print 'Name: ', row.NAME, 'Population: ', row.POPULATION
```

Пример с вычислениями может быть записан с использованием именованного кортежа, после чего не нужно обращаться к таблице и определять по индексу поля-участники:

```python
index = (row.FIRST_PRICE - row.SECOND_PRICE) * (row.INDEX_ZX + row.INDEX_QT) ** -1 * 100
```

При составлении использовались:

* [https://arcpy.wordpress.com/2012/07/12/getting-arcpy-da-rows-back-as-dictionaries/]
