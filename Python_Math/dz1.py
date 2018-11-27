import math
from typing import Tuple, TypeVar

"""
Даны 2 строки long_phrase и short_phrase. Напишите код, который проверяет действительно ли длинная фраза long_phrase
длиннее короткой short_phrase. И выводит True или False в зависимости от результата сравнения.
"""


def check_length(long_phrase: str, short_phrase: str) -> bool:
    """
    Метод сравнивает длинную строку и короткую строка и выводит True если длинная строка длиннее короткой
    :param long_phrase: Длинная строка
    :param short_phrase: Короткая строка
    :return: bool
    """
    return len(long_phrase) > len(short_phrase)


print(check_length(long_phrase='Насколько проще было бы писать программы, если бы не заказчики',
                   short_phrase='640Кб должно хватить для любых задач. Билл Гейтс (по легенде)'))

"""
Дана строка text. Определите какая из двух букв встречается в нем чаще - 'а' или 'и'.
text = 'Если программист в 9-00 утра на работе, значит, он там и ночевал'
"""


def check_letters(text: str) -> str:
    """
    Метод выводит какая буква чаще встречается в строке text:  'а' или 'и'
    :param text: Искомая строка
    :return: str result
    """
    count_a, count_i = 0, 0
    for letter in text:
        if letter == 'а':
            count_a += 1
        elif letter == 'и':
            count_i += 1
    if count_a > count_i:
        result = 'В строке чаще встречается буква А. {} против {}'.format(count_a, count_i)
    elif count_i > count_a:
        result = 'В строке чаще встречается буква И. {} против {}'.format(count_i, count_a)
    else:
        result = 'В строке кол-во букв И и А совпадают. {} против {}'.format(count_i, count_a)
    return result


print(check_letters(text='Если программист в 9-00 утра на работе, значит, он там и ночевал'))

"""
3. Дано значение объема файла в байтах. Напишите перевод этого значения в мегабайты в формате:
'Объем файла равен 213.68Mb'
"""


def to_megabytes(file_size: int) -> str:
    """
    Метод конвертирует размер файла из байтов в мегабайты
    :param file_size: Размер файла в байтах
    :return: str
    """
    mb_basis = 1024 ** 2
    return 'Объем файла равен {0:.2f} Mb'.format(file_size / mb_basis)


print(to_megabytes(1048576))

"""
Выведите на экран значение синуса 30 градусов с помощью метода math.sin.
"""


def print_sin(angle: int) -> float:
    """
    Метод вывода синуса угла
    :param angle: значение угла в градусах
    :return: float Синус угла
    """
    return math.sin(math.radians(angle))


print(print_sin(30))

"""
5. В прошлом задании у вас скорее всего не получилось точного значения 0.5 из-за конечной точности вычисления синуса. 
Но почему некоторые простые операции также могут давать неточный результат? Попробуйте вывести на экран результат 
операции 0.1 + 0.2
"""
print(0.1 + 0.2)

"""
Потому что компьютеры работают не с десятичнымт цифрами, а с двоичными 
"""

"""
Задания посложнее
В переменных a и b записаны 2 различных числа. Вам необходимо написать код, который меняет значения a и b местами 
без использования третьей переменной.
"""


def change_a_b(a: int, b: int) -> Tuple[int, int]:
    """
    Метод замены а на b
    :param a: Число 1
    :param b: Число 2
    :return: Записываем в a число b, а в b число а
    """
    b, a = a, b
    return a, b


a, b = change_a_b(3, 5)
print(a)
print(b)

"""
Дано число в двоичной системе счисления: num=10011. Напишите алгоритм перевода этого числа в привычную нам десятичную 
систему счисления.
Возможно, вам понадобится цикл прохождения всех целых чисел от 0 до m:
for n in range(m)
"""

A = TypeVar('A', str, int) # Тип или str или int


def binary_to_decimal(binary: A) -> int:
    """
    Метод конвертации двоичного числа в текстовом представлении в десятичное
    :param binary:
    :return:
    """
    binary = str(binary)
    factor = len(binary)
    result = 0
    for n in range(factor):
        if binary[n] == '1':
            result += 2 ** (factor - n - 1)

    return result


assert binary_to_decimal('10011') == 19
assert binary_to_decimal('101100101') == 357

print(binary_to_decimal('10011'))
print(binary_to_decimal(10011))
