## Обработка esri JSON (в fc и обратно)

При работе с сервисами ArcGIS Server как во front- так и в backend приходится иметь дело с данными в формате JSON. В esri стандартизировали структуру JSON-файлов для передачи геометрии. Пример:

```python
json_example = """
{ 
"displayFieldName": "",
 "geometryType": "esriGeometryPoint",
 "spatialReference": {
  "wkid": 4326,
  "latestWkid": 4326
 },
 "fields": [
  {
   "name": "OBJECTID",
   "type": "esriFieldTypeOID",
   "alias": "OBJECTID"
  },
  {
   "name": "Name",
   "type": "esriFieldTypeString",
   "alias": "Name",
   "length": 50
  }
 ],
 "features": [
{"attributes":{"Name":"100001"},"geometry":{"x":150.840576171875,"y":59.593692779541016,"spatialReference":4326}},
{"attributes":{"Name":"100002"},"geometry":{"x":150.81520080566406,"y":59.56467056274414,"spatialReference":4326}},
{"attributes":{"Name":"100003"},"geometry":{"x":150.82833862304688,"y":59.55543899536133,"spatialReference":4326}},
{"attributes":{"Name":"100004"},"geometry":{"x":150.82803344726562,"y":59.555599212646484,"spatialReference":4326}} ],
 "exceededTransferLimit": false
}
"""
```

Чтобы переводить JSON в feature class используйте инструмент `JSONToFeatures_conversion`, а для обратной конвертации `FeaturesToJSON_conversion`.

Рассмотрим случай, когда необходимо обработать JSON, но при этом не создавать feature class или провести какие-либо манипуляции с данными и только потом сохранить в уже созданный класс пространственных данных. Понадобится две библиотеки: `arcpy` и `json`.

```python
import arcpy
import json
```

Далее JSON пример переводим в словарь, а затем в пары Name-Geometry:

```python
jd = json.loads(json_example)
result_list = [(item["attributes"]["Name"], arcpy.AsShape(item["geometry"], True))for item in jd["features"]]
for i, j in result_list:
    print i, j
# 100001 <geoprocessing describe geometry object object at 0x0000000011339828>
# 100002 <geoprocessing describe geometry object object at 0x0000000011339878>
# 100003 <geoprocessing describe geometry object object at 0x0000000011339788>
# 100004 <geoprocessing describe geometry object object at 0x00000000113398A0>
```

Создадим feature class и запишем в него полученные данные:

```python
print arcpy.env.scratchGDB
# C:\Users\eugenden\AppData\Local\Temp\scratch.gdb
arcpy.env.overwriteOutput = True
fc_path = arcpy.CreateFeatureclass_management(arcpy.env.scratchGDB, 'point_arrow', "POINT", spatial_reference=arcpy.SpatialReference(4326))
arcpy.AddField_management(fc_path, "Name", "TEXT")
with arcpy.da.InsertCursor(fc_path, ["Name", "SHAPE@"]) as icur:
    for row in result_list:
        icur.insertRow(row)
```

Конвертируем полученный feature class в JSON обратно и сравним:

```python
json_path = r"C:\Users\eugenden\AppData\Local\Temp\mypjsonfeatures.json"
to_json = arcpy.FeaturesToJSON_conversion(fc_path, json_path, "FORMATTED")

with open(json_path) as f_json:
    data = f_json.read()
print data
"""
{
  "displayFieldName" : "",
  "fieldAliases" : {
    "OBJECTID" : "OBJECTID",
    "Name" : "Name"
  },
  "geometryType" : "esriGeometryPoint",
  "spatialReference" : {
    "wkid" : 4326,
    "latestWkid" : 4326
  },
  "fields" : [
    {
      "name" : "OBJECTID",
      "type" : "esriFieldTypeOID",
      "alias" : "OBJECTID"
    },
    {
      "name" : "Name",
      "type" : "esriFieldTypeString",
      "alias" : "Name",
      "length" : 255
    }
  ],
  "features" : [
    {
      "attributes" : {
        "OBJECTID" : 1,
        "Name" : "100001"
      },
      "geometry" : {
        "x" : 150.84057617200006,
        "y" : 59.593692780000083
      }
    },
    {
      "attributes" : {
        "OBJECTID" : 2,
        "Name" : "100002"
      },
      "geometry" : {
        "x" : 150.81520080600012,
        "y" : 59.56467056300005
      }
    },
    {
      "attributes" : {
        "OBJECTID" : 3,
        "Name" : "100003"
      },
      "geometry" : {
        "x" : 150.82833862300004,
        "y" : 59.555438995000031
      }
    },
    {
      "attributes" : {
        "OBJECTID" : 4,
        "Name" : "100004"
      },
      "geometry" : {
        "x" : 150.82803344700005,
        "y" : 59.55559921300005
      }
    }
  ]
}
"""
```
