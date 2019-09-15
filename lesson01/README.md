# OTUS

OTUS

Последовательность компиляции ядра:
- установил голую системы centos7 
изначальная версия ядра 3.10
- обновляю пакеты.
  - yum -y update
- устанавливаю необходимые пакеты вместе с зависимостями:
  - perl-parent-0.225-244.el7.noarch
  - perl-HTTP-Tiny-0.033-3.el7.noarch
perl-podlators-2.5.1-3.el7.noarch
perl-Pod-Perldoc-3.20-4.el7.noarch
perl-Pod-Escapes-1.04-294.el7_6.noarch
perl-Text-ParseWords-3.29-4.el7.noarch
perl-Encode-2.51-7.el7.x86_64
perl-Pod-Usage-1.63-3.el7.noarch
perl-libs-5.16.3-294.el7_6.x86_64
perl-macros-5.16.3-294.el7_6.x86_64
perl-Storable-2.45-3.el7.x86_64
perl-Exporter-5.68-3.el7.noarch
perl-constant-1.27-2.el7.noarch
perl-Time-Local-1.2300-2.el7.noarch
perl-Carp-1.26-244.el7.noarch
perl-Time-HiRes-1.9725-3.el7.x86_64
pcre-devel-8erl-PathTools-3.40-5.el7.x86_64
perl-Scalar-List-Utils-1.27-248.el7.x86_64
perl-File-Temp-0.23.01-3.el7.noarch
perl-File-Path-2.09-2.el7.noarch
perl-threads-shared-1.43-6.el7.x86_64
perl-threads-1.87-4.el7.x86_64
perl-Filter-1.49-3.el7.x86_64
perl-Socket-2.010-4.el7.x86_64
perl-Pod-Simple-3.28-4.el7.noarch
perl-Getopt-Long-2.40-3.el7.noarch
perl-5.16.3-294.el7_6.x86_64
gpm-libs-1.20.7-5.el7.x86_64
mc-4.8.7-11.el7.x86_64
wget-1.14-18.el7.x86_64
mpfr-3.1.1-4.el7.x86_64
libmpc-1.0.1-3.el7.x86_64
cpp-4.8.5-36.el7_6.1.x86_64
kernel-headers-3.10.0-957.10.1.el7.x86_64
glibc-headers-2.17-260.el7_6.4.x86_64
glibc-devel-2.17-260.el7_6.4.x86_64
gcc-4.8.5-36.el7_6.1.x86_64
m4-1.4.16-10.el7.x86_64
flex-2.5.37-6.el7.x86_64
bison-3.0.4-2.el7.x86_64
ncurses-devel-5.9-14.20130511.el7_4.x86_64
zlib-devel-1.2.7-18.el7.x86_64
elfutils-libelf-devel-0.172-2.el7.x86_64
epel-release-7-11.noarch
libcom_err-devel-1.42.9-13.el7.x86_64
libsepol-devel-2.5-10.el7.x86_64
pcre-devel-8.32-17.el7.x86_64
libselinux-devel-2.5-14.1.el7.x86_64
libkadm5-1.15.1-37.el7_6.x86_64
libverto-devel-0.2.5-4.el7.x86_64
keyutils-libs-devel-1.5.8-3.el7.x86_64
krb5-devel-1.15.1-37.el7_6.x86_64
openssl-devel-1.0.2k-16.el7_6.1.x86_64
bc-1.06.95-13.el7.x86_64
libpng-1.5.13-7.el7_2.x86_64
json-c-0.11-4.el7_0.x86_64
libsmartcols-2.23.2-59.el7_6.1.x86_64
grub2-tools-minimal-2.02-0.76.el7.centos.1.x86_64
grub2-tools-2.02-0.76.el7.centos.1.x86_64
grub2-tools-extra-2.02-0.76.el7.centos.1.x86_64
grub2-2.02-0.76.el7.centos.1.x86_64
kernel-3.10.0-957.10.1.el7.x86_64

переходим в папку /usr/src/

  cd /usr/src

Скачиваем исходиники ядра, разоривируем в папку ./linux/
  wget https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.0.10.tar.xz
  tar -xf linux-5.0.10.tar.xz
  mv linux-5.0.10 linux
  cd linux
  
  Записываю  конфиг текущего ядра в .config
   cp /boot/config-3.10.0-862.el7.x86_64 /usr/src/linux/.config
   
   компилирую новое ядро 
   yes "" | make oldconfig 
   make -j16 && make modules_install && make-j16 install
   
   Все новое ядро скоимпилировано и  все нужные файлы в /boot/ и всё уже сделано, 
   открываем конфиг загрузчика и проверяем настройки (должна появится новая секция для нового ядра, но если нет то можно дописать её по аналогии).
   
   перезагружаемся 
   
   reboot
   
В загрузчике выбираем загрузку с новым ядром ипроверяем, что все впорядке:

   uname- rn

"compile-core 5.0.10"

Новое ядро собрано.

Можно прописать загрузу нового ядра по умолчанию.
