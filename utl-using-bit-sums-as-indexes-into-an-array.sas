Using bit sums as indexes into an array

Same problem restructured
https://stackoverflow.com/questions/56121578/recoding-multi-dimensional-array-variables-in-sas

The blshift function in the SAS Forum just multiplies by 2.

*_                   _
(_)_ __  _ __  _   _| |_
| | '_ \| '_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
;

data have1;
 input id g1_bit2  g1_bit1 ;
cards4;
1 1 0
2 0 1
3 1 1
;;;;
run;quit;


data have2;
 input id g2_bit2 g2_bit1;
cards4;
 1 0 1
 2 0 1
 3 1 1
;;;;
run;quit;



WORK.HAVE1 total obs=3

Obs    ID    G1_BIT2    G1_BIT1

 1      1       1          0
 2      2       0          1
 3      3       1          1

WORK.HAVE2 total obs=3

Obs    ID    G2_BIT2    G2_BIT1

 1      1       0          1
 2      2       0          1
 3      3       1          1

*           _              __                    _
 _ __ _   _| | ___  ___   / _| ___  _ __    __ _/ |
| '__| | | | |/ _ \/ __| | |_ / _ \| '__|  / _` | |
| |  | |_| | |  __/\__ \ |  _| (_) | |    | (_| | |
|_|   \__,_|_|\___||___/ |_|  \___/|_|     \__, |_|
                                           |___/
;
* same rule applies to g2 variables;

                                Possible Sums with 2 bits
WORK.HAVE1 total obs=3     +   -----------------------------
                           |   G1_SUM_    G1_SUM_    G1_SUM_
 ID    G1_BIT2    G1_BIT1  |     EQ_1       EQ_2       EQ_3
                           |
  1       1          0     |      1          0          0    sum(2*g1_bit1 + g1_bit2)=1
  2       0          1     |      0          1          0    sum(2*g1_bit1 + g1_bit2)=2
  3       1          1     |      0          0          1    sum(2*g1_bit1 + g1_bit2)=3
                           +
*            _               _
  ___  _   _| |_ _ __  _   _| |_
 / _ \| | | | __| '_ \| | | | __|
| (_) | |_| | |_| |_) | |_| | |_
 \___/ \__,_|\__| .__/ \__,_|\__|
                |_|
;

 WORK.WANT total obs=3
                                        G1_SUM_    G1_SUM_    G1_SUM_    G2_SUM_    G2_SUM_    G2_SUM_
 ID    G1_BIT2 G1_BIT1 G2_BIT2 G2_BIT1   EQ_1       EQ_2       EQ_3       EQ_1       EQ_2       EQ_3

  1       1       0       0       1       1          0          0          0          1          0
  2       0       1       0       1       0          1          0          0          1          0
  3       1       1       1       1       0          0          1          0          0          1

*
 _ __  _ __ ___   ___ ___  ___ ___
| '_ \| '__/ _ \ / __/ _ \/ __/ __|
| |_) | | | (_) | (_|  __/\__ \__ \
| .__/|_|  \___/ \___\___||___/___/
|_|
;

options missing='0';

data want;

  merge have1 have2;
  by id;

  array sums_g1  g1_sum_eq_1  g1_sum_eq_2  g1_sum_eq_3;
  array sums_g2  g2_sum_eq_1  g2_sum_eq_2  g2_sum_eq_3;

  sums_g1[ 2*g1_bit1 + g1_bit2]=1;
  sums_g2[ 2*g2_bit1 + g2_bit2]=1;

run;quit;




