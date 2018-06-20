## Создание переменных, добавление в PATH, запуск/удаление служб в PowerShell

Чтобы добавить пользовательскую переменную используйте: 

```powershell
Set-ItemProperty "hkcu:\Environment" MY_PATH1 "d:\temp"
```

Чтобы добавить системную перменную (запускать "Run as Administrator"):

```powershell
Set-ItemProperty "hklm:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" MY_PATH2 "c:\project"
```

Чтобы добавить путь в переменную PATH используйте:

```powershell
$Path = "d:\temp"
$envPaths = $env:Path -split ';'
if ($envPaths -notcontains $Path) {
    $envPaths = $envPaths + $Path | where { $_ }
    $new_path = $envPaths -join ';'
    Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" PATH $new_path
}
```

Чтобы создать службу и запустить её от конкретного пользователя используйте:

```powershell
$User = "domen\user"
$PWord = ConvertTo-SecureString -String "***" -AsPlainText -Force
$Credential = New-Object -TypeName "System.Management.Automation.PSCredential" -ArgumentList $User, $PWord
$Credential.UserName
New-Service -Name "MyService1" -BinaryPathName "D:\projects\main.exe" -Credential $Credential -Description "This is a test service"
Start-Service -Name "MyService1"
```

Чтобы остановить и удалить службу используйте:

```powershell
Stop-service "MyService1"
$service = Get-WmiObject -Class Win32_Service -Filter "Name='MyService1'"
$service.Delete()
```