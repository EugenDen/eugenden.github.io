## Простой старт на windows

Скайчаем и установим инсталятор с официального сайта [https://golang.org/dl/](https://golang.org/dl/).

Просмотрим переменные окружения для Go и изменим GOPATH:

```
go env

// set GO111MODULE=
// set GOARCH=amd64
// set GOBIN=
// ....

Set-ItemProperty -Path 'HKCU:\Environment\' -Name 'GOPATH' -Value "D:\Go_data"
```

Загрузим репозиторий:

```powershell
go get github.com/EugenDen/eugenden.github.io
```

Создадим текстовый файл с расширением `.go`.

Введём следующие команды:

```go
package main

import "fmt"

func main() {
    fmt.Println("Hello World")
}
```

Далее в консоли перейдём в папку с файлом и запустим компиляцию командой `go build`. Затем запустим полученный `exe`.


```powershell
PS D:\Go_data\src> go build D:\Go_data\src\helloworld.go
PS D:\Go_data\src> .\helloworld.exe
Hello World
```