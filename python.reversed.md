## Итерирование в обратном порядке

Если вызвать в консоли python следующую команду будет предоставлена информация о классе list:

```python
help(list())
```

Нас интересует наличие метода reverse:

```
 |  remove(...)
 |      L.remove(value) -- remove first occurrence of value.
 |      Raises ValueError if the value is not present.
 |
 |  reverse(...)
 |      L.reverse() -- reverse *IN PLACE*
 |
 |  sort(...)
 |      L.sort(cmp=None, key=None, reverse=False) -- stable sort *IN PLACE*;
 |      cmp(x, y) -> -1, 0, 1
```

Посмотрим как работает:

```python
q = [1, 2, 3, 4]
for x in reversed(q):
    print x
# 4
# 3
# 2
# 1
```
Обратная итерация сработает только в том случае, если объект имеет определенный размер (в памяти), или если в нём реализован специальный метод __reversed__(). Если дать объект, который можно итерировать, но он не имеет метода reversed, получим следующее:

```python
for y in reversed({1: 100, 2: 200}):
    print y
# TypeError: argument to reversed() must be a sequence
```

Чтобы осуществить в этом случае итерирование в обратном порядке - превратим сначала в список - унаследуем методы list:

```python
for y in reversed(list({1: 100, 2: 200})):
    print y
# 2
# 1
```

Также если вам необходимо проитерировать что-то такое, что нельзя превратить в список или это очень затратно по ресурсам, можно итерирование предопределить в собственном классе:

```python
class Countdown:
    def __init__(self, x):
        self.x = x

    def __iter__(self):
        n = self.x
        while n > 0:
            yield n
            n -= 1

    def __reversed__(self):
        n = 1
        while n <= self.x:
            yield n
            n += 1

e = Countdown(5)
for s in reversed(e):
    print s
# 1
# 2
# 3
# 4
# 5
```
При составлении использовались:

* _O'Reilly® Python Cookbook, 3rd Edition: Recipes for Mastering Python 3 (David Beazley, et al)_
