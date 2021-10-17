04_transform
========================================================
author: Andrea
date: 01-04-2020
width: 1500
height: 768

Obiettivi della serata
========================================================

É raro che i dati siano esattamente nella forma giusta di cui hai bisogno, per questo nei prossimi incontri vedremo come:

- creare nuove variabili
- riordinarle
- riassumerle

Per partire avremo bisogno di due librerie


```r
library (nycflights13) # tutti i voli del 2013 di New York
library (tidyverse) # ci concentreremo su dplyr
```

nycflights13::flights
========================================================


```
# A tibble: 336,776 x 19
    year month   day dep_time sched_dep_time dep_delay arr_time sched_arr_time
   <int> <int> <int>    <int>          <int>     <dbl>    <int>          <int>
 1  2013     1     1      517            515         2      830            819
 2  2013     1     1      533            529         4      850            830
 3  2013     1     1      542            540         2      923            850
 4  2013     1     1      544            545        -1     1004           1022
 5  2013     1     1      554            600        -6      812            837
 6  2013     1     1      554            558        -4      740            728
 7  2013     1     1      555            600        -5      913            854
 8  2013     1     1      557            600        -3      709            723
 9  2013     1     1      557            600        -3      838            846
10  2013     1     1      558            600        -2      753            745
# ... with 336,766 more rows, and 11 more variables: arr_delay <dbl>,
#   carrier <chr>, flight <int>, tailnum <chr>, origin <chr>, dest <chr>,
#   air_time <dbl>, distance <dbl>, hour <dbl>, minute <dbl>, time_hour <dttm>
```


Le basi di dplyr
========================================================

Per risolvere la maggior parte dei problemi di manipolazione dei dati bastano 5 funzioni:

- Scegliere le osservazioni in base ai loro valori (`filter()`). 
- Riordinare le righe (`arrange()`). 
- Scegliere le variabili in base al nome (`select()`). 
- Creare nuove variabili a partire da quelle esistenti (`mutate()`).
- Comprimere molti valori in un unico riepilogo (`summarize ()`). 

Queste vengono usate insieme a `group_by ()` che permette di eseguire le operazioni su sottoinsieme del dataset invece che su quello intero.

Una sintassi di base uguale per tutti
========================================================

Tutti i verbi funzionano in modo simile:

- primo argomento è il dataset
- gli altri argomenti spiegano cosa fare, le variabili (nomi delle colonne) vengono usate senza virgolette
- risultato è un nuovo (tibble) dataset

! attenzione che le funzioni dplyr non modificano mai i loro input. Per salvare il risultato si dovrà creare una nuova variabile con `<-`

Filtrare le righe con `filter()`
========================================================

Permette di creare sottoinsiemi di osservazioni in base ai loro valori.


```r
filter(flights, month == 12, day == 25) 
```

```
# A tibble: 719 x 19
    year month   day dep_time sched_dep_time dep_delay arr_time sched_arr_time
   <int> <int> <int>    <int>          <int>     <dbl>    <int>          <int>
 1  2013    12    25      456            500        -4      649            651
 2  2013    12    25      524            515         9      805            814
 3  2013    12    25      542            540         2      832            850
 4  2013    12    25      546            550        -4     1022           1027
 5  2013    12    25      556            600        -4      730            745
 6  2013    12    25      557            600        -3      743            752
 7  2013    12    25      557            600        -3      818            831
 8  2013    12    25      559            600        -1      855            856
 9  2013    12    25      559            600        -1      849            855
10  2013    12    25      600            600         0      850            846
# ... with 709 more rows, and 11 more variables: arr_delay <dbl>,
#   carrier <chr>, flight <int>, tailnum <chr>, origin <chr>, dest <chr>,
#   air_time <dbl>, distance <dbl>, hour <dbl>, minute <dbl>, time_hour <dttm>
```

Gli operatori standard sono `>`,  `>=`, `<`,  `<=`,  `!=` (diverso) e `==` (uguale) o anche `near()` (versione più flessibile), combinati in espressioni grazie a parentesi

Operatori booleani
========================================================

![ `x` <U+653C><U+3E38> il cerchio di sinistra,`y` <U+653C><U+3E38> il cerchio di destra e la regione ombreggiata mostra quale parti selezionate da ogni operatore](diagrams/transform-logical.png)

Combinare gli operatori tra loro
========================================================

L'ordine delle operazioni non funziona come l'inglese, per trovare i voli in partenza a novembre o dicembre non si può scrivere `filter (voli, mese == (11 | 12))`.

La sintassi corretta è


```r
filter(flights, month = 11 | month = 12)
```
 
o in alternativa


```r
filter(flights, month %in% c(11, 12))
```

```
# A tibble: 55,403 x 19
    year month   day dep_time sched_dep_time dep_delay arr_time sched_arr_time
   <int> <int> <int>    <int>          <int>     <dbl>    <int>          <int>
 1  2013    11     1        5           2359         6      352            345
 2  2013    11     1       35           2250       105      123           2356
 3  2013    11     1      455            500        -5      641            651
 4  2013    11     1      539            545        -6      856            827
 5  2013    11     1      542            545        -3      831            855
 6  2013    11     1      549            600       -11      912            923
 7  2013    11     1      550            600       -10      705            659
 8  2013    11     1      554            600        -6      659            701
 9  2013    11     1      554            600        -6      826            827
10  2013    11     1      554            600        -6      749            751
# ... with 55,393 more rows, and 11 more variables: arr_delay <dbl>,
#   carrier <chr>, flight <int>, tailnum <chr>, origin <chr>, dest <chr>,
#   air_time <dbl>, distance <dbl>, hour <dbl>, minute <dbl>, time_hour <dttm>
```

Attenzione ai `NA` #1
========================================================

I `NA` sono contagiosi, le operazioni che li coinvolgono spesso danno `NA` come risultato


```r
NA > 5
```

```
[1] NA
```

```r
10 == NA
```

```
[1] NA
```

***


```r
NA + 10
```

```
[1] NA
```

```r
NA / 2
```

```
[1] NA
```

```r
NA == NA
```

```
[1] NA
```

Attenzione ai `NA` #2
========================================================

Per capire se un valore è `NA` si usa is.na(x).

`filter()` mantiene solo le righe il cui il risultato è `TRUE` (quindi esclude sia i `FALSE` che i `NA`). Se si vogliono mantenere, la sintassi è quella dell'ultima riga


```r
df <- tibble(x = c(1, NA, 3))
# filter(df, x > 1)
filter(df, is.na(x) | x > 1)
```

```
# A tibble: 2 x 1
      x
  <dbl>
1    NA
2     3
```

Esercizi #1 - Trova tutti i voli che
========================================================

a. hanno avuto un ritardo all'arrivo di due o più ore

b. hanno volato a Houston ("IAH" o "HOU")

c. sono stati gestiti da United, American o Delta

d. sono partiti in estate (luglio, agosto e settembre)
  
e. sono arrivati con più di due ore di ritardo, ma non sono partiti in ritardo

f. sono stati ritardati di almeno un'ora alla partenza, ma hanno recuperato almeno 30 minuti mentre erano in volo

***  

g.Sono partiti tra mezzanotte e le 6:00 (incluso)

2. Un altro utile aiuto per il filtraggio di dplyr è `between ()`. Che cosa fa? Si può usare per semplificare il codice necessario per rispondere alle sfide precedenti?

3. Quanti voli hanno un "dep_time" mancante?
    Quali altre variabili mancano?
    Cosa potrebbero rappresentare queste righe?

Riordinare le righe con `arrange()`
========================================================

Funziona in modo simile a `filter()` tranne per il fatto che invece di selezionare le righe, cambia il loro ordine sulla base di nomi di colonne (o espressioni più complicate).

Ogni nuova colonna fornita viene usata per gestire i pareggi nelle colonne precedenti


```r
arrange(flights, year, month, day)
```

```
# A tibble: 336,776 x 19
    year month   day dep_time sched_dep_time dep_delay arr_time sched_arr_time
   <int> <int> <int>    <int>          <int>     <dbl>    <int>          <int>
 1  2013     1     1      517            515         2      830            819
 2  2013     1     1      533            529         4      850            830
 3  2013     1     1      542            540         2      923            850
 4  2013     1     1      544            545        -1     1004           1022
 5  2013     1     1      554            600        -6      812            837
 6  2013     1     1      554            558        -4      740            728
 7  2013     1     1      555            600        -5      913            854
 8  2013     1     1      557            600        -3      709            723
 9  2013     1     1      557            600        -3      838            846
10  2013     1     1      558            600        -2      753            745
# ... with 336,766 more rows, and 11 more variables: arr_delay <dbl>,
#   carrier <chr>, flight <int>, tailnum <chr>, origin <chr>, dest <chr>,
#   air_time <dbl>, distance <dbl>, hour <dbl>, minute <dbl>, time_hour <dttm>
```

Riordinare in ordine decrescente si fa con `desc()`
========================================================


```r
arrange(flights, desc(dep_delay))
```

```
# A tibble: 336,776 x 19
    year month   day dep_time sched_dep_time dep_delay arr_time sched_arr_time
   <int> <int> <int>    <int>          <int>     <dbl>    <int>          <int>
 1  2013     1     9      641            900      1301     1242           1530
 2  2013     6    15     1432           1935      1137     1607           2120
 3  2013     1    10     1121           1635      1126     1239           1810
 4  2013     9    20     1139           1845      1014     1457           2210
 5  2013     7    22      845           1600      1005     1044           1815
 6  2013     4    10     1100           1900       960     1342           2211
 7  2013     3    17     2321            810       911      135           1020
 8  2013     6    27      959           1900       899     1236           2226
 9  2013     7    22     2257            759       898      121           1026
10  2013    12     5      756           1700       896     1058           2020
# ... with 336,766 more rows, and 11 more variables: arr_delay <dbl>,
#   carrier <chr>, flight <int>, tailnum <chr>, origin <chr>, dest <chr>,
#   air_time <dbl>, distance <dbl>, hour <dbl>, minute <dbl>, time_hour <dttm>
```

I valori mancanti (NA) sono sempre ordinati in fondo


```r
df <- tibble(x = c(5, 2, NA))
arrange(df, x)
```

```
# A tibble: 3 x 1
      x
  <dbl>
1     2
2     5
3    NA
```

```r
arrange(df, desc(x))
```

```
# A tibble: 3 x 1
      x
  <dbl>
1     5
2     2
3    NA
```

Esercizi #2
========================================================

1. Ordina "flights" per trovare i voli con i ritardi di partenza più lunghi

2. Ordina "flights" per trovare i voli più veloci (velocità massima).

3. Quali voli hanno viaggiato più lontano? Quali hanno viaggiato per meno tempo?

4. Come potresti usare `arrange()` per ordinare tutti i valori mancanti all'inizio? (suggerimento: usa `! Is.na ()`).


Selezionare le colonne con `select ()`
========================================================

`select ()` consente di ingrandire rapidamente un sottoinsieme utile a quelle davvero interessanti utilizzando operazioni basate sui nomi delle variabili, soprattutto quando queste sono molte.


```r
select(flights, year, month, day) # by name
```

```
# A tibble: 336,776 x 3
    year month   day
   <int> <int> <int>
 1  2013     1     1
 2  2013     1     1
 3  2013     1     1
 4  2013     1     1
 5  2013     1     1
 6  2013     1     1
 7  2013     1     1
 8  2013     1     1
 9  2013     1     1
10  2013     1     1
# ... with 336,766 more rows
```

```r
# all columns between (inclusive)
select(flights, year:day)
```

```
# A tibble: 336,776 x 3
    year month   day
   <int> <int> <int>
 1  2013     1     1
 2  2013     1     1
 3  2013     1     1
 4  2013     1     1
 5  2013     1     1
 6  2013     1     1
 7  2013     1     1
 8  2013     1     1
 9  2013     1     1
10  2013     1     1
# ... with 336,766 more rows
```

```r
# all columns except (inclusive)
select(flights, -(year:day))
```

```
# A tibble: 336,776 x 16
   dep_time sched_dep_time dep_delay arr_time sched_arr_time arr_delay carrier
      <int>          <int>     <dbl>    <int>          <int>     <dbl> <chr>  
 1      517            515         2      830            819        11 UA     
 2      533            529         4      850            830        20 UA     
 3      542            540         2      923            850        33 AA     
 4      544            545        -1     1004           1022       -18 B6     
 5      554            600        -6      812            837       -25 DL     
 6      554            558        -4      740            728        12 UA     
 7      555            600        -5      913            854        19 B6     
 8      557            600        -3      709            723       -14 EV     
 9      557            600        -3      838            846        -8 B6     
10      558            600        -2      753            745         8 AA     
# ... with 336,766 more rows, and 9 more variables: flight <int>,
#   tailnum <chr>, origin <chr>, dest <chr>, air_time <dbl>, distance <dbl>,
#   hour <dbl>, minute <dbl>, time_hour <dttm>
```

Funzioni di supporto a select()
========================================================

- `starts_with("abc")`: nomi che iniziano con "abc".

- `ends_with("xyz") `: nomi che finiscono con" xyz ".

- `contains("ijk")`: nomi che contengono "ijk".

- `num_range("x", 1: 3)`: corrisponde a "x1", "x2" e "x3"

"?select" apre l'help per maggiori dettagli.

`rename()` funziona come "select" ma mantiene tutte le colonne.

Esercizi #3
========================================================

1. Fai un brainstorming su quanti più modi possibili per selezionare "dep_time", "dep_delay", "arr_time" e "arr_delay" da "flights".

2. Cosa fa la funzione `any_of()`? Perché potrebbe essere utile insieme a questo vettore?

```r
variables <- c("year", "month", "day", "dep_delay", "arr_delay")
```

***

3. Il risultato dell'esecuzione del seguente codice ti sorprende?
    In che modo gli helper selezionati gestiscono il caso per impostazione predefinita?
    Come puoi modificare tale impostazione predefinita?


```r
select(flights, contains("TIME"))
```

Aggiungere nuove variabili con `mutate()` #1
========================================================

`mutate ()` aggiunge nuove colonne che sono funzioni di colonne esistenti.

Innanzitutto creiamo un dataset più ristretto per vedere tutte le variabili


```r
flights_sml <- select(flights, 
  year:day, 
  ends_with("delay"), 
  distance, 
  air_time
)
```

a cui segue

***


```r
mutate(flights_sml,
  gain = dep_delay - arr_delay,
  speed = distance / air_time * 60,
  hours = air_time / 60,
  gain_per_hour = gain / hours
)
```

Aggiungere nuove variabili con `mutate()` #2
========================================================


```
# A tibble: 336,776 x 11
    year month   day dep_delay arr_delay distance air_time  gain speed hours
   <int> <int> <int>     <dbl>     <dbl>    <dbl>    <dbl> <dbl> <dbl> <dbl>
 1  2013     1     1         2        11     1400      227    -9  370. 3.78 
 2  2013     1     1         4        20     1416      227   -16  374. 3.78 
 3  2013     1     1         2        33     1089      160   -31  408. 2.67 
 4  2013     1     1        -1       -18     1576      183    17  517. 3.05 
 5  2013     1     1        -6       -25      762      116    19  394. 1.93 
 6  2013     1     1        -4        12      719      150   -16  288. 2.5  
 7  2013     1     1        -5        19     1065      158   -24  404. 2.63 
 8  2013     1     1        -3       -14      229       53    11  259. 0.883
 9  2013     1     1        -3        -8      944      140     5  405. 2.33 
10  2013     1     1        -2         8      733      138   -10  319. 2.3  
# ... with 336,766 more rows, and 1 more variable: gain_per_hour <dbl>
```
 
Operatori utili nei mutate #1
========================================================

- aritmetici: `+`, `-`, `*`, `/`, `^`
- funzioni aggreganti: `sum(x)`, `mean(x)`
- funzioni cumulative:  `cumsum ()`, `cumprod ()`, `cummin ()`, `cummax ()`
- aritmetica modulare : `%/%` (divisione intera) and `%%` (resto), dove `x == y * (x %/% y) + (x %% y)`

Ad esempio, nel dataset si può rompere "ora" e "minuto" da "dep_time" con:

***


```r
transmute(flights,
  dep_time,
  hour = dep_time %/% 100,
  minute = dep_time %% 100
)
```

```
# A tibble: 336,776 x 3
   dep_time  hour minute
      <int> <dbl>  <dbl>
 1      517     5     17
 2      533     5     33
 3      542     5     42
 4      544     5     44
 5      554     5     54
 6      554     5     54
 7      555     5     55
 8      557     5     57
 9      557     5     57
10      558     5     58
# ... with 336,766 more rows
```

Operatori utili nei mutate #2
========================================================

- offset: "lead ()" e "lag ()" consentono di fare riferimento a valori precedente o immediatamente successivo
- logaritmi come `log()`, `log2()`, `log10()`
- confronti logici (`<`, `<=`, `>`, `> =`, `! =` e `==`) che restituiscono una colonna di TRUE, FALSE o NA a seconda della condizione inserita

Operatori utili nei mutate #3 - Ranking
========================================================

- funzioni di ranking (creazione di classifica "i valori piccoli ai ranghi piccoli"), come `min_rank ()`


```r
y <- c(1, 2, 2, NA, 3, 4)
min_rank(y) # oppure min_rank(desc(y))
```

```
[1]  1  2  2 NA  4  5
```

```r
# o in alternativa
row_number(y)
```

```
[1]  1  2  3 NA  4  5
```

***


```r
dense_rank(y)
```

```
[1]  1  2  2 NA  3  4
```

```r
percent_rank(y)
```

```
[1] 0.00 0.25 0.25   NA 0.75 1.00
```

```r
cume_dist(y)
```

```
[1] 0.2 0.6 0.6  NA 0.8 1.0
```


Esercizi #4
========================================================

1. Attualmente `dep_time` e` sched_dep_time` sono convenienti da guardare, ma difficili da calcolare perché non sono realmente numeri continui (crea un istogramma per verificarlo).
    Convertili in una rappresentazione più conveniente del numero di minuti dalla mezzanotte precedente.

2. Confronta "air_time" con "arr_time - dep_time" (crea ggplot per vederlo meglio).
    Cosa ti aspetti di vedere?
    Cosa vedi?
    Cosa si deve fare per risolverlo?

3. Confronta `dep_time`,` sched_dep_time` e `dep_delay`.
    Come ti aspetteresti che quei tre numeri siano correlati?

4. Trova i 10 voli più in ritardo utilizzando una funzione di classificazione. Come gestire i pareggi?

5. Cosa restituisce "1: 3 + 1: 10"?
    Perché?

Nel prossimo incontro...
========================================================

- group_by()
- summarize()
- count()
- passaggi in ggplot
