## Простой старт на windows

Скачиваем средство разработки wxDev-C++ с ресурса [http://wxdsgn.sourceforge.net/?q=node/4](http://wxdsgn.sourceforge.net/?q=node/4)

Устанавливаем, выбираем первоначальные настройки, запускаем.

![](../images//c.start//new.PNG "c.start_1")

Нажимаем Ctrl+N чтобы создать новый скрипт.

Набираем следующие команды:

```c
#include <stdio.h>

int main (void)
{
  printf ("Hello, World!\n");
}
```

Сохраняем скрипт на диск с расширением `.c`.

![](../images//c.start//commands.PNG "c.start_2")

Нажимаем Ctrl+F9 чтобы скомпилировать программу.

![](../images//c.start//compile.PNG "c.start_3")

Запустим полученный exe в консоле.

![](../images//cpp.start//run.PNG "c.start_4")
