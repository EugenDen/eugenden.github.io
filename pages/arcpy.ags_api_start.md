## Начало работы с API ARCGIS Server

Для работы понабодобиться инструмент, позволяющий отправлять POST-запросы. Для примера возьмем  библиотеку Python urrlib2.

Зафиксируем версию python
```python
import sys
print sys.version
'2.7.10 (default, May 23 2015, 09:44:00) [MSC v.1500 64 bit (AMD64)]'
```

Сформируем credential для ArcGIS Server

```
server_cred = {
    "protocol": "https",
    "hostname": "GIS_SERVER",
    "root": "arcgis",
    "port": "6443",
    "federated": "False",
    "token_url": "/admin/generatetoken",
    "user": "siteadmin",
    "password": "qwerty123"
}
```

Кроме библиотеки `urllib2` понадобиться библиотека `json`, т.к. работа с API базируется на обмене текстовыми файлами в формате JSON. Для игнорирования проверки `ssl` потребуется соответствующая встроенная бибилотека. Помимо этого ддя кодировки параметров пригодиться библиотека `urllib`.  

```python
import urllib
import urllib2
import json
import ssl
```

Введем функцию для обработки POST-запросов. Укажем headers, закодируем входные параметры и настроим игнорирование сертификата ssl.  

```python
def urllib2_call(url_, params_):
    ctx = ssl.create_default_context()
    ctx.check_hostname = False
    ctx.verify_mode = ssl.CERT_NONE
    headers = {"Content-type": "application/x-www-form-urlencoded", "Accept": "text/plain"}
    params = urllib.urlencode(params_)
    sc = urllib2.Request(url_, params, headers)
    sc_response = urllib2.urlopen(sc, context=ctx)
    return sc_response
```

Теперь можно описать функцию получения токена к ArcGIS Server. Необходимо учесть, что сервер может быть интегрирован с порталом и тогда понадобиться портальный токен. В данном примере используется получение токена для IP если сервер неинтегрированный и токен на "web url", если сервер интегированный.

```python
def get_token(user_, pw_, token_url_, url=""):
    if bool(url):
        token_parameters = {'username': user_, 'password': pw_, 'client': 'referer',
                            'referer': '{0}/admin'.format(url_), 'f': 'pjson'}
    else:
        token_parameters = {'username': user_, 'password': pw_, 'client': 'requestip', 'f': 'json'}
    response = urllib2_call(token_url_, token_parameters)
    data = response.read()
    if response.code != 200:
        print 'Error while fetching tokens from URL', str(data)
        return ""
    else:
        token = json.loads(data)
        return token['token']
```

К серверу все запросы можно выполнять с помощью одной функции, меняя url и параметры.

```python
def post_url(url, params, token_url, user, pw, federated="False"):
    if bool(token_url) and bool(user) and bool(pw) and federated == "False":
        tk_str = get_token(user, pw, token_url)
        params['token'] = tk_str if isinstance(params, dict) else {'token': tk_str}
    if bool(token_url) and bool(user) and bool(pw) and federated == "True":
        tk_str = get_token(user, pw, token_url, url)
        params['token'] = tk_str if isinstance(params, dict) else {'token': tk_str}
    params['f'] = 'json'
    response = urllib2_call(url, params)
    data = response.read()
    if response.code != 200:
        print 'Error calling URL={0}, params={1}, descriptions: '.format(url, params), str(data)
        return ""
    else:
        return response, data
```

Попробуем какой-нибудь практический случай, например добавление роли на портале:

```python
def add_role(x, y):
    print "start function: add_role"
    print "y", y
    url = "{0}://{1}:{2}/{3}".format(x["protocol"], x["hostname"], x["port"], x["root"])
    mid_url = "/admin/security/roles/add"
    compleate_token_url = "{0}/{1}".format(url, x["token_url"])
    url_line = url + mid_url
    roles = y
    for role in roles:
        item = {"rolename": "{}".format(role), "description": ""}
        post_url(url_line, item, compleate_token_url, x["user"], x["password"], x["federated"])
        print "@add role " + role

add_role(server_cred, ["role1", "role2"])
```
