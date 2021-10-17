03_import
========================================================
author: Andrea
date: 18/03/2021
autosize: true

Obiettivi della serata: i Comma Separated Value
========================================================

Imparare come utilizzare la libreria `readr` per importare delle tabelle di testo che contengono i dati che vogliamo analizzare

- la funzione base per i csv
- parsing di vettori
   * numeri (logical, interi, double)
   * stringhe
   * factor
   * date, date-time
- gestire casi particolari

***

Si parte sempre con


```r
library(tidyverse)
```


Funzioni fondamentali
========================================================

Sono due


```r
read_csv( file = <PATH>) # per i file di testo
```
 
oppure


```r
readxl() # per i file di excel
```


Esempio
========================================================


```r
read_csv("a,b,c
1,2,3
4,5,6")
```

```
# A tibble: 2 x 3
      a     b     c
  <dbl> <dbl> <dbl>
1     1     2     3
2     4     5     6
```

Argomenti di read_csv
========================================================


```r
read_csv(
  file = <PATH>,    # percorso file
  col_names = TRUE, # il file contiene il nome delle colonne?
  col_types = NULL, # che tipo di colonne?
  locale = default_locale(), # impostazioni locali
  na = c("", "NA"), # come sono scritti i NA?
  comment = "",     # simbolo per i commenti
  skip = 0,         # righe da saltare in cima al dataset
  n_max = Inf,      # righe da leggere (Inf = tutte)
)
```

Esercizi #1
========================================================

1. Qual è l'errore in queste linee di codice?


```r
read_csv("a,b\n1,2,3\n4,5,6")
read_csv("a,b,c\n1,2\n1,2,3,4")
read_csv("a,b\n\"1")
read_csv("a,b\n1,2\na,b")
read_csv("a;b\n1;3")
```

2. A volte nei file separati da virgole, nei testi ci sono delle virgole. Il carattere di "quote" serve a evitare che queste vengano lette come separazione di colonne. Come fare per leggere correttamente il seguente csv?


```r
testo <- "x,y\n1,'a,b'"
```

Parsing #1
========================================================

Capire come funziona read_csv() necessita di capire come vengono letti i vettori che compongono le colonne del file che stiamo importando.

Questo viene fatto grazie alla funzione parse_*()


```r
str(parse_logical(c("TRUE", "FALSE", "NA")))
```

```
 logi [1:3] TRUE FALSE NA
```


```r
str(parse_date(c("2010-01-01", "1979-10-14")))
```

```
 Date[1:2], format: "2010-01-01" "1979-10-14"
```

Parsing #2
========================================================

Quello che darebbe errore viene sostituito con NA


```r
parse_integer(c("123", "345", "abc", "123.45"))
```

```
[1] 123 345  NA  NA
attr(,"problems")
# A tibble: 2 x 4
    row   col expected               actual
  <int> <int> <chr>                  <chr> 
1     3    NA an integer             abc   
2     4    NA no trailing characters 123.45
```


Parsing nel dettaglio: i numeri #1
========================================================

I numeri vengono scritti in modo diverso in diverse parti del mondo.

Ad esempio il separatore delle migliaia o il simbolo del separatore decimale (che in Europa è la virgola mentre negli USA è il punto).

Per gestire queste impostazioni si varia l'argomento "locale"


```r
parse_double("1,23", locale = locale(decimal_mark = ","))
```

```
[1] 1.23
```

Parsing nel dettaglio: i numeri #2
========================================================

La funzione parse_number() recupera il numero all'interno di un blocco di testo


```r
parse_number("It cost $123.45")
```

```
[1] 123.45
```


Parsing nel dettaglio: i character
========================================================

I caratteri sono rappresentati in base a uno standard, che può essere ASCII, Latin-1 o UTF-8


```r
charToRaw("Hadley")
```

```
[1] 48 61 64 6c 65 79
```

Readr assume di base che i dati siano in UTF-8, che da solo può rappresentare tutti i caratteri usati (incluse anche le emoji). Quando si ottiene una lettura sbagliata, si ipotizza che ci sia stato un errore di codifica.


```r
x1 <- "El Ni\xf1o was particularly bad this year"
parse_character(x1, locale = locale(encoding = "Latin1"))
```

```
[1] "El Niño was particularly bad this year"
```

Parsing nel dettaglio: i factor
========================================================

Le variabili categoriche sono rappresentate in R dai factor, un tipo particolare di variabile che può assumere come valori solo determinati levels.


```r
fruit <- c("apple", "banana")
parse_factor(c("apple", "banana", "bananana"), levels = fruit)
```

```
[1] apple  banana <NA>  
attr(,"problems")
# A tibble: 1 x 4
    row   col expected           actual  
  <int> <int> <chr>              <chr>   
1     3    NA value in level set bananana
Levels: apple banana
```

Se però ci sono vari problemi, può essere più comodo importare come character e modificare in seguito.

Parsing nel dettaglio: le variabili temporali #1
========================================================

parse_datetime() si aspetta una combinazione di data-ora secondo ISO8601


```r
parse_datetime("2010-10-01T2010")
```

```
[1] "2010-10-01 20:10:00 UTC"
```


parse_date() si aspetta un anno composto da 4 cifre, un - o /, poi mese e poi giorno


```r
parse_date("2010-10-01")
```

```
[1] "2010-10-01"
```

Parsing nel dettaglio: le variabili temporali #2
========================================================

parse_time() si aspetta l'ora, poi i :, ed eventualmente minuti e secondi e am/pm


```r
library(hms)
( parse_time("01:10 am") )
```

```
01:10:00
```



```r
( parse_time("20:10:01") )
```

```
20:10:01
```


Parsing nel dettaglio: le variabili temporali #3
========================================================
Costruite secondo un format particolare.

Year

- `%Y` (4 digits).
- `%y` (2 digits); 00-69 -\> 2000-2069, 70-99 -\> 1970-1999.

Month

- `%m` (2 digits).
- `%b` (abbreviated name, like "Jan").
- `%B` (full name, "January").

***

Day

- `%d` (2 digits).
- `%e` (con eventuale spazio in cima).


Parsing nel dettaglio: le variabili temporali #4
========================================================
Time

- `%H` 0-23 hour.
- `%I` 0-12, da usare con `%p`.
- `%p` AM/PM indicator.
- `%M` minutes.
- `%S` integer seconds.

***

- `%Z` Time zone come nome(es. `America/Chicago`).
- `%z` (come offset da UTC, e.g. `+0800`).

Non-digits

- `%.` skip un carattere non numero
- `%*` skip qualunque numero di non numero


Parsing nel dettaglio: le variabili temporali #5
========================================================


```r
parse_date("01/02/15", "%m/%d/%y")
```

```
[1] "2015-01-02"
```

```r
parse_date("01/02/15", "%d/%m/%y")
```

```
[1] "2015-02-01"
```

```r
parse_date("01/02/15", "%y/%m/%d")
```

```
[1] "2001-02-15"
```

***

Se stai usando un linguaggio che non è l'inglese, i valori per `%b` or `%B` vanno modificati cambiando l'argomento `lang` di `locale()`.


```r
parse_date("1 gennaio 2015", "%d %B %Y", locale = locale("it"))
```

```
[1] "2015-01-01"
```

Esercizi #2
========================================================
1.  Quali sono i parametri più importanti per `locale()`?

2. Qual è la differenza tra `read_csv()` e `read_csv2()`?

3. Crea il codice per leggere correttamente le seguenti date

***


```r
d1 <- "January 1, 2010"

d2 <- "2015-Mar-07"

d3 <- "06-Jun-2017"

d4 <- c("August 19 (2015)")

d5 <- "12/30/14" # Dec 30, 2014

t1 <- "1705"

t2 <- "11:15:10.12 PM"
```

Parsing dell'intero file
========================================================

Ci sono due elementi fondamentali che readr fa quando legge un file

1. provare a indovinare il tipo corretto di variabile
2. provare a 


```r
challenge <- read_csv(
  readr_example("challenge.csv"), 
  col_types = cols(
    x = col_double(),
    y = col_logical()
  )
)
```
