## Определение и замена источников данных в Map Document (.mxd)

Чтобы получить список всех слоёв mxd-проекта с их источником данных используйте следующий код: 

```python
import arpcy
map_document = arcpy.mapping.MapDocument("<Any path>")
layers = arcpy.mapping.ListLayers(map_document)
for layer in layers:
    try:
        print layer.name, layer.dataSource
    except Exception:
        print layer.name, None
```

Если вы открыли mxd-проект в ArcMap и используете тамошнюю консоль указывайте в качестве `MapDocument` "CURRENT".


Чтобы производить замену путей в mxd проекте понадобиться следующие входные параметры (для каждой замены):
 - путь к mxd;
 - путь к новой mxd с изменёнными путями;
 - путь к источнику данных, который необходимо заменить - текущий путь;
 - путь к источнику данных, на который необходимо заменить - новый путь.

Структурируем входные параметры в лист (JSON-подобная структура):
```python
"mxd_json": [
            {"old_mxd": "C://Temp//mxd//my_project_1.mxd",
             "new_mxd": "C://Temp//new_mxd//my_project_1.mxd",
             "paths": [
               {"old": "C:\\Users\\My_user\\AppData\\Roaming\\ESRI\\Desktop10.4\\ArcCatalog\\mydatabase_myuser@10.111.11.123.sde",
                "new": "C:\\conn\\viewer.sde"}]},
            {"old_mxd": "C://Temp//mxd//my_project_2.mxd",
             "new_mxd": "C://Temp//new_mxd//my_project_2.mxd",
             "paths": [
               {"old": "C:\\Users\\My_user\\AppData\\Roaming\\ESRI\\Desktop10.4\\ArcCatalog\\mydatabase_myuser@10.111.11.123.sde",
                "new": "C:\\conn\\viewer.sde"}]},
               {"old": "Database Connections\\mydatabase_editor@10.111.11.123.sde",
                "new": "C:\\conn\\editor.sde"},
               {"old": "Database Connections\\mydatabase_admin@10.111.11.123.sde",
                "new": "C:\\conn\\admin.sde"}]},
]
```
Обратите внимание на слэши, их количество и направление.

Замену путей можно осуществить, подав описанную структуру в следующую функцию:

```python
# -*- coding: utf-8 -*-
import arcpy
def replace_workspace(mxd_dict):
    """
        Функция открывает mxd-проекты, меняет источники данных для слоёв и сохраняет новые проекты по
        указываемым путям.
        Вся необходимая информация помещается во входной список словарей.
        Структура входного списка данных:
        ```
        example = [
            {'old_mxd': 'D:\\mxd\\mdoc.mxd',
             'new_mxd': 'D:\\mxd_new\\mdoc.mxd',
             'paths': [{'old': 'D:\projects\testbase.gdb', 'new': 'D:\megabase.gdb'},]
            },
        ]
        ```
        В атрибутах элемента списка (источник данных) указываются следующе параметры:
        - путь к mxd проекту, в котором необходимо изменить источники данных;
        - путь к новому mxd проекту, в котором будут изменены источники данных;
        - пути  к данным внутри mxd-проекта (старые и новые).
        Пример использования:
            replace_workspace(example)

    :param mxd_dict: входной параметр, список словарей с определённой структурой, в котором хранится информация о
        Map Document -ах и какие изменния для них необходимы, чтобы они заработали на других источниках данных.
    :return: функция меняет источники данных и сохраняет проекты по указаннному пути и ничего не возвращает
    """

    class MxdObj:
        def __init__(self, dict_):
            self.old_mxd = dict_['old_mxd']
            self.new_mxd = dict_['new_mxd']
            self.paths = dict_['paths']

    mxd_dicts = [MxdObj(mxd_) for mxd_ in mxd_dict]
    for mxd in mxd_dicts:
        try:
            map_document = arcpy.mapping.MapDocument(mxd.old_mxd)
            for path in mxd.paths:
                map_document.findAndReplaceWorkspacePaths(path['old'], path['new'])
            map_document.saveACopy(mxd.new_mxd)
            del mxd
        except Exception as e:
            print mxd.old_mxd, e
```