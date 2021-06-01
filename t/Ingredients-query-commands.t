use lib './lib';
use lib '.';
use DSL::English::DataAcquisitionWorkflows;
use Test;

##===========================================================
## Ingredients commands
##===========================================================

my $pCOMMAND = DSL::English::DataAcquisitionWorkflows::Grammar;

plan 18;

## 1
ok $pCOMMAND.parse('how many datasets contain both categorical and numerical columns'.lc),
'how many datasets contain both categorical and numerical columns';

## 2
ok $pCOMMAND.parse('how many datasets contain categorical and numerical data'.lc),
'how many datasets contain categorical and numerical data';

## 3
ok $pCOMMAND.parse('how many datasets contain categorical variables'.lc),
'how many datasets contain categorical variables';

## 4
ok $pCOMMAND.parse('how many datasets have a civic structure variable'.lc),
'how many datasets have a civic structure variable';

## 5
ok $pCOMMAND.parse('how many datasets have civic structure'.lc),
'how many datasets have civic structure';

## 6
ok $pCOMMAND.parse('how many datasets have CivicStructure'.lc),
'how many datasets have CivicStructure';

## 7
ok $pCOMMAND.parse('how many datasets have time series data'.lc),
'how many datasets have time series data';

## 8
ok $pCOMMAND.parse('how many recipes do you know with time series data'.lc),
'how many recipes do you know with time series data';

## 9
ok $pCOMMAND.parse('what number of datasets are with tv data'.lc),
'what number of datasets are with tv data';

## 10
ok $pCOMMAND.parse('what number of datasets do you know to have anatomical structure data'.lc),
'what number of datasets do you know to have anatomical structure data';

## 11
ok $pCOMMAND.parse('what number of datasets have bridge data'.lc),
'what number of datasets have bridge data';

## 12
ok $pCOMMAND.parse('what number of datasets have bus station data'.lc),
'what number of datasets have bus station data';

## 13
ok $pCOMMAND.parse('what number of datasets have protein'.lc),
'what number of datasets have protein';

## 14
ok $pCOMMAND.parse('what number of datasets have tunel data'.lc),
'what number of datasets have tunel data';

## 15
ok $pCOMMAND.parse('which datasets have a animal shelter column'.lc),
'which datasets have a animal shelter column';

## 16
ok $pCOMMAND.parse('which datasets have a variable that is about web pages'.lc),
'which datasets have a variable that is about web pages';

## 17
ok $pCOMMAND.parse('which datasets have the variables representing medical condition and employment agency'.lc),
'which datasets have the variables representing medical condition and employment agency';

## 18
ok $pCOMMAND.parse('which datasets have the variables that are both categorical and numerical'.lc),
'which datasets have the variables that are both categorical and numerical';

done-testing;
