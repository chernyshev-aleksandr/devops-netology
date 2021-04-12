#4.1. Командная оболочка Bash

1. Есть скрипт:
```bash
a=1
b=2
c=a+b
d=$a+$b
e=$(($a+$b))
```
* Какие значения переменным c,d,e будут присвоены?
* Почему?

Ответ:
* c = a+b - это строка
* d= 1+2 - это конкатенация переменных
* e=3 - это число, т.к  $(( арифметическое действие

2. На нашем локальном сервере упал сервис и мы написали скрипт, который постоянно проверяет его доступность, записывая дату проверок до тех пор, пока сервис не станет доступным. В скрипте допущена ошибка, из-за которой выполнение не может завершиться, при этом место на Жёстком Диске постоянно уменьшается. Что необходимо сделать, чтобы его исправить:

```bash

   #!/usr/bin/env bash
   while ((1==1)) - закрыл скобку
   do
   curl https://localhost:4757
   if (($?!= 0)) - убрал пробел
   then
   date > curl.log
   else
   break - добавил 
   fi
   done
  ```
  
3. Необходимо написать скрипт, который проверяет доступность трёх IP: 192.168.0.1, 173.194.222.113, 87.250.250.242 по 80 порту и записывает результат в файл log. Проверять доступность необходимо пять раз для каждого узла.

```bash
   
   #!/usr/bin/env bash
   ip_list="192.168.0.1 173.194.222.113 87.250.250.242"
   for ip in ${ip_list[@]}; do
   for count in {1..5}; do
   curl --connect-timeout 3 -I -s http://$ip:80
   if [ $? -eq 0 ]
   then  
   echo "ip:$ip check:$count status:OK" >> Desktop/vagrant/ping.log
   else
   echo "ip:$ip check:$count status:ERROR" >> Desktop/vagrant/ping.log
   fi
   done
   done

```

Результат файл log:

ip:192.168.0.1 check:1 status:OK

ip:192.168.0.1 check:2 status:OK

ip:192.168.0.1 check:3 status:OK

ip:192.168.0.1 check:4 status:OK

ip:192.168.0.1 check:5 status:OK

ip:173.194.222.113 check:1 status:OK

ip:173.194.222.113 check:2 status:OK

ip:173.194.222.113 check:3 status:OK

ip:173.194.222.113 check:4 status:OK

ip:173.194.222.113 check:5 status:OK

ip:87.250.250.242 check:1 status:OK

ip:87.250.250.242 check:2 status:OK

ip:87.250.250.242 check:3 status:OK

ip:87.250.250.242 check:4 status:OK

ip:87.250.250.242 check:5 status:OK







4. Необходимо дописать скрипт из предыдущего задания так, чтобы он выполнялся до тех пор, пока один из узлов не окажется недоступным. Если любой из узлов недоступен - IP этого узла пишется в файл error, скрипт прерывается

```bash

#!/usr/bin/env bash
ip_list="192.168.0.1 173.194.222.113 87.250.250.242"
while : ; do
for ip in ${ip_list[@]}; do
echo $ip
for count in {1..5}; do
curl --connect-timeout 3 -I -s http://$ip:80 > /dev/null
if [ $? -eq 0 ]
then
echo "ip:$ip check:$count status:OK" >> Desktop/vagrant/ping.log
else
echo $ip >> Desktop/vagrant/error.log
exit
fi
done
done
done

```

Результат файл log: ниже при отключении сети файл eroor:

ip:192.168.0.1 check:1 status:OK

ip:192.168.0.1 check:2 status:OK

ip:192.168.0.1 check:3 status:OK

ip:192.168.0.1 check:4 status:OK

ip:192.168.0.1 check:5 status:OK

ip:173.194.222.113 check:1 status:OK

ip:173.194.222.113 check:2 status:OK

ip:173.194.222.113 check:3 status:OK

ip:173.194.222.113 check:4 status:OK

ip:173.194.222.113 check:5 status:OK

ip:87.250.250.242 check:1 status:OK

ip:87.250.250.242 check:2 status:OK

ip:87.250.250.242 check:3 status:OK

ip:87.250.250.242 check:4 status:OK

ip:87.250.250.242 check:5 status:OK

при отключении сети файл eroor:

192.168.0.1