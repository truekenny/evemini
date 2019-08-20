## Evemini

Evemini - приложение, дублирующие содержимое окна другого приложения или игры и отображаемое поверх их.

### Скачать

Последний релиз можно найти [на этой странице](https://github.com/truekenny/evemini/releases).

![Evemini](https://raw.githubusercontent.com/truekenny/evemini/master/Evemini.png)

### Возможности

- Клонирование содержимого любого окна;
- Выбор региона целевого окна (с помощью опции меню или зажатой клавишей Alt при выборе мышью);
- Сохранение конфигурации;
- Загрузка конфигурации из файла или командной строки.

### Требования

- Windows Vista, 7, 8, 10;
- Включенный режим Windows Aero.

### Использование

#### Первый запуск

1. Запуск приложения;
2. Выбор окна из меню, доступное при нажатии правой кнопкой мыши (*Select Target*);
3. Изменяем размеры окна приложения и перемещаем его **на** область, которую желаем клонировать и выбираем в меню (*Select Target Region*) **или** с зажатой клавишей Alt выбираем нужную область мышкой в окне копии;
4. Приложение настроено, окно можно передвинуть в удобную позицию на дисплее.

#### Последующие запуски без повторной настройки

1. После закрытия приложения в папке с ним появится файл с сохраненной конфигурацией с именем вида (*Firefox - Twitch.ini*);
2. Если скинуть этот файл на exe приложения, то приложение запустится с этой конфигурацией;
3. Можно создать ярлык на приложение с параметром равным имени этого файла конфигурации, то есть `evemini ".\Firefox - Twitch.ini"`, с полным или относительным путём (относительный путь должен начинаться с текущей директории `.\`) к файлу (если в имени файла или пути к нему есть пробелы, то кавычки обязательны).

- Другой вариант, это переместить всю конфигурацию в параметры приложения, например:

```
evemini^
 --capsuleer-name="Gamer Name"^
 --form-left=1866 --form-top=882 --form-width=687 --form-height=160^
 --game-left=1866 --game-top=550 --game-width=317 --game-height=189^
 --window-movable=false --window-sizable=false
```

- Запуск нескольких копий из batch файла, например, создаём файл `go.bat` со следующим содержимым:

```
start /LOW evemini^
 --capsuleer-name="Gamer First"^
 --form-left=1866 --form-top=882 --form-width=687 --form-height=160^
 --game-left=1866 --game-top=550 --game-width=317 --game-height=189^
 --window-movable=false --window-sizable=false

start /LOW evemini^
 --capsuleer-name="Gamer Second"^
 --form-left=1866 --form-top=882 --form-width=687 --form-height=160^
 --game-left=1866 --game-top=550 --game-width=317 --game-height=189^
 --window-movable=false --window-sizable=false

rem Сколько угодно сразу
```

#### Параметры командной строки

- `--window-name` - полное имя целевого окна (обязателен или `--capsuleer-name`)
- `--capsuleer-name` - имя капсулёра (обязателен или `--window-name`)

- `--form-left` - смещение окна приложения от левого края дисплея
- `--form-top` - смещение окна от верхнего края дисплея
- `--form-width` - ширина окна
- `--form-height` - высота окна

- `--window-color` - цвет окна (по умолчанию `clBtnFace`; [Варианты цветов](http://docwiki.embarcadero.com/RADStudio/Rio/en/Colors_in_the_VCL), допустимы форматы вида: **clRed** и **$0000FF**)
- `--border-default-color` - цвет рамки, пока целевое окно **вне** фокуса (по умолчанию `clGray`)
- `--border-active-color` - цвет рамки, пока целевое окно **в** фокусе (по умолчанию `clLime`)
- `--border-default-width` - ширина рамки, пока целевое окно **вне** фокуса (по умолчанию `1`)
- `--border-active-width` - ширина рамки, пока целевое окно **в** фокусе (по умолчанию `3`)

- `--game-left` - смещение от левого края целевого окна для получения изображения (по умолчанию `0`)
- `--game-top` - смещение от верхнего края (по умолчанию `0`)
- `--game-width` - ширина копируемой области (по умолчанию равен размеру окна)
- `--game-height` - высота (по умолчанию равен размеру окна)

- `--window-movable` - приложение можно передвигать с помощью мышки (по умолчанию `true`)
- `--window-sizable` - приложению можно изменять размеры (по умолчанию `true`)
- `--window-proportion` - приложение сохраняет пропорции при изменении его размеров (по умолчанию `true`)
- `--always-visible` - если целевое окно закрыто, то приложение будет скрыто, измените эту опцию, чтобы оно было видно всегда (по умолчанию `false`)
- `--invert-wheel` - инвертирует действие колеса мыши (по умолчанию `false`)
- `--window-stick` - окна приклеиваются к границам дисплея и друг к другу (по умолчанию `true`)
- `--window-border` - у неактивного окна будет серая рамка толщиной 1 пиксель (по умолчанию `false`)
- `--hide-if-target-active` - окно превью будет скрыто, если целевое окно в фокусе (по умолчанию `false`)

#### Неочевидные возможности

- Клик средней кнопки мыши закрывает окно;
- Прокрутка колеса мыши изменяет размер окна;
- Выбор региона возможен с зажатой кнопкой Alt (нажать и удерживать Alt, удерживая курсор в пределах приложения нажать левую кнопку мыши, отвести курсор в пределах приложения в новую позицию и отпустить левую кнопку мыши, и затем Alt);
- Опция *Select Window Again* позволяет сбросить текущую цель дублирования и выполнить поиск заново (это может быть полезно, например, при отделении вкладки в браузере);
- Опция *Forget* позволяет забыть найденное окно (может быть полезно при смене контента окна, например, при переключении вкладки браузера с одного сайта на другой),
- Если все окна программы закрыты (*не скрыты*), то приложение закрывается.

#### Пример файла конфигурации `Calculator.ini`

```
[game]
name=Calculator
left=0
top=0
width=336
height=509
[form]
left=909
top=829
width=165
height=250
color=clYellow
[border]
default-color=clBlue
active-color=clGreen
default-width=3
active-width=6
[check]
window-movable=1
window-sizable=1
always-visible=1
window-proportion=1
invert-wheel=0
window-stick=1
window-border=1
hide-if-target-active=0
```

#### Похожие программы

- [EVE-O Preview](https://github.com/Phrynohyas/eve-o-preview)

  Что лучше в Evemini:
  - Возможно выбрать регион целевого окна;
  - Более универсальное, так как можно выбрать не только игровые окна Eve  Online.
  
- [OnTopReplica](https://github.com/LorenzCK/OnTopReplica)

  Что лучше в Evemini:
  - Автоматическое восстановление изображения, после перезакрытия целевого окна (игры);
  - Автоматическая загрузка конфигурации полезна, если вы любите выключать свой компьютер, подготовка всех окон с помощью запуска одного batch файла.
