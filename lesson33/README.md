# PostgreSQL cluster

- Развернуть кластер PostgreSQL из трех нод. Создать тестовую базу
- проверить статус репликации
- Сделать switchover/failover
- Поменять конфигурацию PostgreSQL + с параметром требующим перезагрузки
- Настроить клиентские подключения через HAProxy

### Решение

Для запуска необходимо выполнить команду:

```console
vagrant up
```

Если дииски быстрые - можно немного ускорить и запустить

```console
bash +x vagrantup.sh
```

### Проверки работы

Проверяем статус Patroni

![patroni](images/patroni-status.png)


Создать тестовую базу и проверить работу репликации:

![cluster](images/cluster.png)

Проверяем автоматический failover:

![failover](images/failover.png)

Проверяем switchover:



![switchover](images/switchover.png)



Меняем параметр (max_connections), требующий перезапуска кластера:

![needreboot](images/need-reboot.png)


Подуключаемся через HAProxy

![haproxy](images/haproxy.png)

