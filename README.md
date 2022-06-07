# BudgetAppConsole

## Opis projektu
Aplikacja konsolowa do zarządzania budżetem domowym z wykorzystaniem języka programowania Ruby, gemu TTY oraz bazy danych sqlite3

## Opis funkcjonalności 
- dodawanie transakcji
- usuwanie transakcji
- edytowanie transakcji
- wyświetlanie wszystkich transakcji
- wyświetlanie 10 ostatnich transakcji
- obliczanie sumy wszystkich transakcji
- obliczanie sumy transakcji w aktualnym misiącu
- obliczanie sumy transakcji w aktualnym tygodniu

## Szczególnie interesujące zagadnienia projektowe
Wykorzystanie gemu TTY do łatwej nawigacji w aplikacji za pomocą strzałek. Dużo czasu spędziłem czasu nad UI/UX aplikacji. Wykorzystałem do tego TTY gem. https://ttytoolkit.org/

## Instrukcja instalacji
Skopiuj repozytorium z aplikacją z githuba
```
git clone git@github.com:mateuszbialowas/BudgetApp_Console.git
```
Ściągnij wszystkie potrzebne gemy potrzebne do uruchomienia projektu.
Przed uruchomieniem komendy upewnij się, że masz zainstalowany Ruby https://gorails.com/setup/ubuntu/21.04 oraz bazę danych sqlite3 https://www.sqlite.org/download.html 
```
bundle install
```
Stwórz nową bazę danych
```ruby
rake setup
```
Uruchom aplikację:
```
rake run
```

## Instrukcja konfiguracji
brak

## Instrukcja użytkownika
Poruszanie się w aplikacji za pomocą strzałek oraz przycisków:
- q (wrócenie do menu głównego)
- Q (wyjście z aplikacji)

## Wnioski
Cieszę się, że mogłem napisać aplikację konsolową BudgetApp_Console. Na pewno będę z niej korzystać. W przyszłości będę chciał zrobić asynchronizację danych z konsolowej aplikacji do graficznej aplikacji, by dane się zgadzały.


## Samoocena
Uważam że w odpowiedni sposób wykonałem zadanie realizując wszystkie punkty z wymagań do projektu. 

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).



Everyone interacting in the BudgetAppConsole project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/BudgetApp_Console/blob/master/CODE_OF_CONDUCT.md).

## Demo![BudgetApp_Console demo](https://user-images.githubusercontent.com/58574619/139562627-f632a92e-0089-43f0-9d2c-d15d8ed00a1d.gif)

