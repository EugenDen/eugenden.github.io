## Использование окна "Field Calculator"

Самым простым использованием Python в ArcGIS Desktop являются манипуляции с атрибутивными данными через окно "Field Calculator". Данные из ячеек строки могут извлекаться по названиям из столбцов (со специальным ограничителем - !Field1!, !X!) и назначаться аргументами функции.

### Пример с полной функцией

![alt-текст](../images/field_calculator/arcpy.field_calculator_1.JPG "arcpy.field_calculator_1")

В приведённом примере используется следующая функция:

```python
def func(x):
 if x > 0:
  a = 1
 else:
  a = 0
 return a
```

При выполнении в поле "INDEX", будет рассчитано значение по указанной функции, которая в качестве аргумента принимает значение из поля "X" (в той же строке).

### Пример с анонимной функций

Если позволяет код, есть возможность отказываться от конструкции полноценной функций и использовать краткий синтаксис (т. н. lambda-функции).

![alt-текст](../images/field_calculator/arcpy.field_calculator_2.JPG "arcpy.field_calculator_2")

```python
# 1 if !X! > 0 else 0
lambda x: 1 if x > 0 else 0
```
### Пример с обычным присвоением

Чтобы прописать ячейкам определённое значение достаточно его присвоить.

![alt-текст](../images/field_calculator/arcpy.field_calculator_3.JPG "arcpy.field_calculator_3")

В данном примере проиллюстировано присвоение значения Null.

### Пример с извлечением геометрии

Через окно "Field Calculator" есть простая возможность извлекать свойства геометрии объектов, такие как длина линий, координаты точки, площадь, экстент и др.

```
# рассчитать площадь полигона (в поле типа Double)
!SHAPE!.area

# определние координаты X и Y для точки (в поле типа Double)
!SHAPE!.X
!SHAPE!.Y

# извлечение свойств экстента объектов
# экстремальные значения для экстента  (в поле типа Double)
!SHAPE!.extent.XMin
!SHAPE!.extent.XMax
!SHAPE!.extent.YMin
!SHAPE!.extent.XMax

# Количество узлов-вертексов в геометрии
!SHAPE!.pointcount

# координата X для левой нижней точки экстента (в поле типа Double)
!SHAPE!.extent.lowerLeft.X
```
См. другие свойства геометрии объектов на официальном сайте ArcGIS [https://pro.arcgis.com/ru/pro-app/arcpy/classes/extent.htm](https://pro.arcgis.com/ru/pro-app/arcpy/classes/extent.htm)
