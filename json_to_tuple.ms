## Сопоставление данных из SQL и NoSQL баз данных

1) Как делаются запросы в MongoDB.
2) Сопоставление атрибутов в SQL и NoSQL базах данных.
3) Функция JSON to namedtuple.
4) Функция namedtuple to JSON.
5) Заключение.

##### Как делаются запросы в MongoDB

Работа с NoSQL БД как с большинством REST API (MongoDB и др.) подразумевает обработку JSON-образных данных. 

Запросы в MongoDB имеют много особенностей (см. https://docs.mongodb.com/manual/tutorial/query-documents/), но в рамках данной статьи рассмотрим одну особенность запросов к вложенным документам. Чтобы запросить вложенный элемент необходимо укзаать либо его имя либо индекс. Например, добавим в MongoDB следующий документы:
```
db.inventory.insertMany([
   { item: "journal", qty: 25, size: { h: 14, w: 21, uom: "cm" }, status: "A" },
   { item: "notebook", qty: 50, size: { h: 8.5, w: 11, uom: "in" }, status: "A" },
]);
```
Сделаем запрос, чтобы найти документы в которых атрибут `size` имеет податрибут `uom`, и который равен значению `"in"`. 
```
db.inventory.find( { "size.uom": "in" } )
```
Как могли заметить обращение к атрибутам документа осуществляется с помощью указания вложенности через точку `size.uom`.

##### Сопоставление атрибутов в SQL и NoSQL базах данных.

При настройке интеграций SQL / NoSQL, столбцу таблицы соответствует атрибут документа в виде приведённым выше (`attribute1.attribute2.attribute3...`).

Таким образом, можем представить указанный в примере JSON в виде кортежа, который можно использовать при работе с SQL-данными:

```python
from collections import namedtuple
fields = namedtuple('item', 'qty', 'size.h', 'size.w', 'size.uom', 'status')
values = [
    ("journal", 25, 14, 21, "cm", "A"),
    ("notebook", 50, 8.5, 11, "in", "A") 
]
```

##### Функция JSON to namedtuple

Функция, переводящая JSON любой вложенности в кортеж и список полей, выглядит следующим образом:

```python
def convert_to_tuple(item):
    def json_to_tuple(json_, childe_name=''):
        output = []
        for el in json_:
            cur_name = childe_name + "." + el if childe_name != '' else el
            output += json_to_tuple(json_[el], cur_name) if isinstance(json_[el], dict) else [(cur_name, json_[el])]
        return output
    if isinstance(item, dict):
        output_dict = dict(json_to_tuple(item))
        return tuple(output_dict.values()), tuple(output_dict.keys())
```

Работа на примере:

```python
# -*- coding: utf-8 -*-
dct = {
   "firstName": "Ivan",
   "lastName": "Иванов",
   "address": {
       "streetAddress": "Московское ш., 101, кв.101",
       "city": "Ленинград",
       "postalCode": 101101
   },
   "phoneNumbers": [
       "812 123-1234",
       "916 123-4567"
   ]
}
values, field_name = convert_to_tuple(dct)
for i, j in zip(values, field_name):
    print j, i
# phoneNumbers ['812 123-1234', '916 123-4567']
# address.city Ленинград
# firstName Ivan
# lastName Иванов
# address.streetAddress Московское ш., 101, кв.101
# address.postalCode 101101
```

##### Функция namedtuple to JSON

Функция, которая переводит кортежи в JSON-элемент, при чём поля через точку образуют вложенности выглядит следующим образом:

```python
def convert_from_tuple(item, names=()):
    if bool(names) and isinstance(item, tuple):
        result = {}
        for n in range(0, len(names)):
            cur_result = result
            parts = names[n].split('.')
            for part in parts[:-1]:
                if part not in result:
                    cur_result[part] = {}
                cur_result = cur_result[part]
            cur_result[parts[-1]] = item[n]
        return result
```

По-тестируем:

```python
# -*- coding: utf-8 -*-
import json
output_json = convert_from_tuple(*convert_to_tuple(dct))
text = json.dumps(output_json, encoding='utf-8', ensure_ascii=False)
print text
# {"lastName": "Иванов", "phoneNumbers": ["812 123-1234", "916 123-4567"],
#  "firstName": "Ivan", "address": {"postalCode": 101101, "city": "Ленинград",
#  "streetAddress": "Московское ш., 101, кв.101"}}
with open(r'C:\scripts\github\json_to_tuple\text.txt', 'wb') as file1:
    file1.write(text)
```

##### Заключение

Каждый тип баз данных имеет свои преимущества и недостатки. Использование преимуществ, обход недостатков и создание прозрачных интеграции между базами - ключевой навык создателей сложных информационных систем. 
