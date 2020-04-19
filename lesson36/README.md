# Leeson 36 NFS,Samba
## Задача:
Vagrant стенд для NFS или SAMBA
NFS или SAMBA на выбор:

vagrant up должен поднимать 2 виртуалки: сервер и клиент
на сервер должна быть расшарена директория
на клиента она должна автоматически монтироваться при старте (fstab или autofs)
в шаре должна быть папка upload с правами на запись
- требования для NFS: NFSv3 по UDP, включенный firewall


## Решение:

По комманде `vagrant up` поднимается 2 ВМ server и client:
[server](./ansible/roles/nfs-server)

[client](./ansible/roles/nfs-server)

На  сервере создаем и "шарим" папку `/datadrive` с правами только на чтение. И в папке `/datadrive/upload`с правами на запись для всех пользователей в машины client.

Папка `/datadrive` монтируется к папке `/nfs` на машине client.

Доступ предоставляется по рпотоколу UPD NFSv3.



Проверяем ограничения по условию задачи:

Если попытаться создать файл или папку в смонитрованной папке `/nfs` будет выдано сообщение о том что не достаточно прав:

```[vagrant@nfs-Client1 upload]$ cd /nfs
[vagrant@nfs-Client1 nfs]$ mkdir test
mkdir: cannot create directory 'test': Permission denied
```

А если попытаться создать файл внутри папки `/nfs/upload` - результат будет удачным:

```bash
[vagrant@nfs-Client1 nfs]$ ls
upload
[vagrant@nfs-Client1 nfs]$ cd upload/
[vagrant@nfs-Client1 upload]$ mkdir test
[vagrant@nfs-Client1 upload]$ ls
1234r  test
[vagrant@nfs-Client1 upload]$ pwd
/nfs/upload
```

