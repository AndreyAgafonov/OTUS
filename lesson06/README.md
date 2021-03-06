LESSON 6. Размещаем свой RPM в своем репозитории.

<pre>

Задание:

- создать свой RPM-пакет (своё приложение или, к примеру, apache2 с определенными опциями);
- создать свой репозиторий и разместить там свой RPM-пакет
- реализовать вышеперечисленное в Vagrant или развернуть у себя через nginx и дать ссылку на репозиторий

</pre>

Дополнительно:
* реализовать доставку через docker: написать dockerfile, собрать image, разместить в docker registry, прислать ссылку и инструкцию.


<details> 
  
Решение:

[Vagrantfile](./Vagrantfile) с [provisioning](./provision.sh), который:
  - собирает httpd с некоторыми нужными зависимостями;
- создает репозиторий rpm;
- разворачивает репозиторий rpm через httpd;
- устанавливает docker
- используя dockerfile создает образ centos c httpd из нашего репозитория.
- (далее образ был запушен в DockerHub, комментарии в конце [файла](./provision.sh), инструкция к контейнеру на DockerHub'е) - [DockerHub](https://cloud.docker.com/u/andreyagafonov/repository/docker/andreyagafonov/otus_lab6)
</details>

**Andrey Agafonov 2019 aagafonov@inbox.ru**
