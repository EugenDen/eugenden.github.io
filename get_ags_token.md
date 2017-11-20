## Получение токена для ArcGIS Server или Portal for ArcGIS

Чтобы получить http-доступ к сервисам, функциям администратора и пр. необходимо сначала авторизоваться. В случае технологий ArcGIS мы можем получить токен, а потом с помощью него обращаться к интересуемому нас контенту.

Далее код, в котором создаётся токен:

```python
import urllib
import urllib2
import json
import ssl

# portal
url_ = 'https://domen/arcgis/sharing/generateToken'
# server
# url_ = 'https:/server:port/arcgis/admin/generateToken'
user = r'mygroup\eugenden'
pw = 'PA$$W0RD'
params = urllib.urlencode({'username': user, 'password': pw, 'client': 'requestip', 'f': 'json'})
print params

headers = {"Content-type": "application/x-www-form-urlencoded", "Accept": "text/plain"}

ctx = ssl.create_default_context()
ctx.check_hostname = False
ctx.verify_mode = ssl.CERT_NONE

tk = urllib2.Request(url_, params, headers)
tk_response = urllib2.urlopen(tk, context=ctx)
tk_str = json.load(tk_response)['token']
print tk_str
```

Краткое описание. 
Сначала импортируются необходимые модули. Затем объявлятся необходимые пользовательские переменные: url - для получения токена, имя пользователя и пароль. Затем формируется url-строка параметров. Прописываем headers. После настраиваем игнорирование проверки ssl-сертификата. Формируем запрос (urllib2.Request). Делаем вызов (urlopen) и получаем ответ в формате json (как указали в параметрах). Переводим json в словарь (json.load) и выбираем значение по ключу.
