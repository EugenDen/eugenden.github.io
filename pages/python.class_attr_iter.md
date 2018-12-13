## Итерация по атрибуту класса

Пусть есть класс, в атрибутах которого есть список. Добавим в класс метод по добавлению элементов в этот список.


```python
class Server:
    def __init__(self, ip):
        self.ip = ip
        self.descendants = []

    def add_descendant(self, descendant):
        self.descendants.append(descendant)
```

Используем класс для создания нескольких экземпляров - пусть один будет главным сервером и 2 дочерних. Добавим через метод дочерние в главный.

```python
primary_server = Server("119.11.001.226")
first_descendant = Server("119.11.001.228")
second_descendant = Server("119.11.001.130")

primary_server.add_descendant(first_descendant)
primary_server.add_descendant(second_descendant)
```


В списке атрибута класса главного сервера теперь 2 дочерних сервера. Попробова сделать итерацию по этим серверам, будет получена ошибка `TypeError: iteration over non-sequence`. 

```python
for s in primary_server:
    print s.ip
# TypeError: iteration over non-sequence
``` 

Чтобы пройти по элементам списка класса, ссылаясь только на класс потребуется выполнить протокол итерации. Необходимо чтобы у класса был метод `__iter__()`, который возвращал бы объект-итератор с реализованным методом `next()` для python2 или `__next__()` для python3. Кратким путём будет добавить метод возвращающий внутренний итератор:

```python
def __iter__(self):
    return iter(self.descendants)
```

Также можно сделать всю логику самостоятельно. Для этого необходимо добавить классу атрибут длину последовательности `index`. При добавлении/удалении в список элемента длину необходимо изменять. А также реализовать методы `__iter__` и `__next__`:

```python
class Server:
    def __init__(self, ip):
        self.ip = ip
        self.descendants = []
        self.index = 0

    def __iter__(self):
        return self

    def next(self):
        if self.index == 0:
            raise StopIteration
        self.index = self.index - 1
        return self.descendants[self.index]

    def add_descendant(self, descendant):
        self.descendants.append(descendant)
        self.index += 1

primary_server = Server("119.11.001.226")
first_descendant = Server("119.11.001.228")
second_descendant = Server("119.11.001.130")

primary_server.add_descendant(first_descendant)
primary_server.add_descendant(second_descendant)

print primary_server.next().ip
print "--"
for s in primary_server:
    print s.ip

# 119.11.001.130
# --
# 119.11.001.228
```
