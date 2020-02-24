# Простая защита от DDOS

## Задание

- Разобраться в базовых принципах конфигурирования nginx;

Использовать стенд https://gitlab.com/otus_linux/nginx-antiddos-example и следовать инструкциям из [README](nginx-antiddos-example/README.md).

## Решение
Решена только первая часть:
Написать конфигурацию nginx, которая даёт доступ клиенту только с определенной cookie. Если у клиента её нет, нужно выполнить редирект на location, в котором кука будет добавлена, после чего клиент будет обратно отправлен (редирект) на запрашиваемый ресурс.

### Описания изменений
Внес изменения в конфиг [ngixn](nginx-antiddos-example/nginx.conf).<br>
Как следует читать данный конфиг (представлен только измененный фрагмент):

```
Всё, что пришло к нам (будут обслужены все хостнеймы)- попадает в корневую локейшен,
потому что описания других нет, а / - попадает под любое условие.)
location / {
# проверяем, есть ли кука -=SuperDefenceDDos=-
    if ($http_cookie !~* "ddos=SuperDefenceDDos") {
        # Если нет, то отмечаем кукой "base_url" текущий URL. Чтобы потом мы могли сюда же вернуться.
        add_header Set-Cookie "base_url=$scheme://$http_host$request_uri";
        # и устремляемся в локейшн /set-cookie
        return 302 set-cookie;
        }
    Если кука обнаружена, то предоставляем доступ к контенту.
    (специально ддя этого ничего в конфгие делать не требуется).
}


location /set-cookie {
        # отмечаем кукой -=SuperDefenceDDos=-
        add_header Set-Cookie "ddos=SuperDefenceDDos";
        # и пинаем обратно на исходный URL,
        return 302 $cookie_base_url;
```
### Сборка образа и push в docker hub
Подгототавливаем папку к сборки. В папке для сборки должны находится dockerfile, конфиг nginx, текстовый файлик otus.txt. <br>
Сборка. В папке с всем выше перечисленным запускаем:
```
# docker build -t andreyagafonov/otus_lesson27:latest .
```
Ждем, когда образ полностью соберется, проверяем что все правильно указали

```
# docker images
REPOSITORY                     TAG                 IMAGE ID            CREATED             SIZE
andreyagafonov/otus_lesson27   latest              59c56471e1b3        6 seconds ago       21.8MB
```

Пушим образ в hub.docker.com (Вы предварительно должны быть авторизаваны - команда ```docker login``` ):

```
# docker push andreyagafonov/otus_lesson27
```
Готово. Образ собран и находится в докер хабе.

## Проверка.
### Требования
Для проверки на своей машине, у Вас должено быть:
- OS : Win,Mac,*nix
- Soft: docker engine.
### Запуск контейнера
Для запуска контейнера выполните команду:
```
# docker run -p 80:80 andreyagafonov/otus_lesson27:latest
```
Локально, с запущенным контейнером выполняем команду curl (Либо если такой возможности нет - localhost необходимо заменить на адрес/хост машины где запущен контейнер):
```
# curl http://localhost/otus.txt -IL
HTTP/1.1 302 Moved Temporarily
Server: nginx/1.17.8
Date: Mon, 24 Feb 2020 18:00:55 GMT
Content-Type: text/html
Content-Length: 145
Connection: keep-alive
Location: set-cookie
Set-Cookie: base_url=http://localhost/otus.txt

HTTP/1.1 302 Moved Temporarily
Server: nginx/1.17.8
Date: Mon, 24 Feb 2020 18:00:55 GMT
Content-Type: text/html
Content-Length: 145
Connection: keep-alive
Location: http://localhost/otus.txt
Set-Cookie: ddos=SuperDefenceDDos

HTTP/1.1 200 OK
Server: nginx/1.17.8
Date: Mon, 24 Feb 2020 18:00:55 GMT
Content-Type: text/plain
Content-Length: 36
Last-Modified: Mon, 24 Feb 2020 17:40:44 GMT
Connection: keep-alive
ETag: "5e540a9c-24"
Accept-Ranges: bytes
```
Наблюдаем, что происходит. первый редирект с кодом 302 добавляет куку
```
Set-Cookie: base_url=http://localhost/otus.txt
```
и отправляет нас по URI
```
Location: set-cookie
```
На втором редиректе добавляется кука
```
Set-Cookie: ddos=SuperDefenceDDos
```
и  нас снова перенаправляет, но уже по первоначальному запросу
```
Location: http://localhost/otus.txt
```
 который мы сделални на первом редиректе. И наконец на 3-м шаге мо получаем саму страничку с кодом 200. <br>
Вот и все ребята :).
