# Д 4.2 Python
    Есть скрипт:
    #!/usr/bin/env python3
    a = 1
    b = '2'
    c = a + b
1.Какое значение будет присвоено переменной c?
Как получить для переменной c значение 12?
Как получить для переменной c значение 3?
Ответ:
выдает ошибку тип переменных разный
для получения 12 преобразуем аргумент (а) с=c = str(a)+b
для получения  3  преобразуем аргумент (b) в число  c = a+int(b)
 
2. Мы устроились на работу в компанию, где раньше уже был DevOps Engineer. Он написал скрипт, позволяющий узнать, какие файлы модифицированы в репозитории, относительно локальных изменений. Этим скриптом недовольно начальство, потому что в его выводе есть не все изменённые файлы, а также непонятен полный путь к директории, где они находятся. Как можно доработать скрипт ниже, чтобы он исполнял требования вашего руководителя?
Ответ: указал свой путь и убрал break. Работает



#!/usr/bin/env python3
 
import os
 
bash_command = ["cd /Users/a11/Desktop/devops-netology", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(prepare_result)
 
3. Доработать скрипт выше так, чтобы он мог проверять не только локальный репозиторий в текущей директории, а также умел воспринимать путь к репозиторию, который мы передаём как входной параметр. Мы точно знаем, что начальство коварное и будет проверять работу этого скрипта в директориях, которые не являются локальными репозиториями.
Ответ:
 
#!/usr/bin/env python3
 
import os
import sys
 
path = '~/devops-netology'
if len(sys.argv) == 2:
    if not os.path.isdir(f'{sys.argv[1]}/.git'):
        path = sys.argv[1]
        print(f'{sys.argv[1]} is not git repo')
        exit()
 
bash_command = [f'cd {path}', "pwd", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False
for i, result in enumerate(result_os.split('\n')):
    if i == 0:
        print(f'path {result}')
    if result.find('modified') != -1:
        prepare_result = result.replace('#\tmodified:   ', '')
        print(prepare_result)
 
Наша команда разрабатывает несколько веб-сервисов, доступных по http. Мы точно знаем, что на их стенде нет никакой балансировки, кластеризации, за DNS прячется конкретный IP сервера, где установлен сервис. Проблема в том, что отдел, занимающийся нашей инфраструктурой очень часто меняет нам сервера, поэтому IP меняются примерно раз в неделю, при этом сервисы сохраняют за собой DNS имена. Это бы совсем никого не беспокоило, если бы несколько раз сервера не уезжали в такой сегмент сети нашей компании, который недоступен для разработчиков. Мы хотим написать скрипт, который опрашивает веб-сервисы, получает их IP, выводит информацию в стандартный вывод в виде: <URL сервиса> - <его IP>. Также, должна быть реализована возможность проверки текущего IP сервиса c его IP из предыдущей проверки. Если проверка будет провалена - оповестить об этом в стандартный вывод сообщением: [ERROR] <URL сервиса> IP mismatch: <старый IP> <Новый IP>. Будем считать, что наша разработка реализовала сервисы: drive.google.com, mail.google.com, google.com.
Ответ:
#!/usr/bin/env python3
import os
import socket
 
filename='services.txt'
services = {}
 
def check_file():
    global services
    if not os.path.isfile(filename):
        services = {
            'drive.google.com': None,
            'mail.google.com': None,
            'google.com': None,
        }
        write_file()
 
 
def check_file_ip(line):
    if len(line) == 1:
        return None
    if line[1].strip() == 'None':
        return None
    return line[1].strip()
 
 
def read_file():
    check_file()
    with open(filename, 'r') as fn:
        for line in fn:
            line_list = line.split(':')
            service = line_list[0].strip()
            ip = check_file_ip(line_list)
            services[service] = ip
 
 
def write_file():
    with open(filename, 'w') as fn:
        for service, ip in services.items():
            fn.write(f'{service}:{ip}\n')
 
 
def get_ip(host):
    try:
        return socket.gethostbyname(host)
    except:
        return None
 
 
def check_ip():
    for service, ip in services.items():
        host_ip = get_ip(service)
        if not host_ip:
            print(f'[ERROR] {service} no IP')
services[service] = None
            continue
        if not ip:
            ip = host_ip
            services[service] = host_ip
        if ip == host_ip:
            print(f'{service} - {host_ip}')
        else:
            print(f'[ERROR] {service} IP mismatch: {ip} {host_ip}')
            services[service] = host_ip
 
 
 
read_file()
check_ip()
write_file()
 
