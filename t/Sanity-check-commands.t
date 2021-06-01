use lib './lib';
use lib '.';
use DSL::English::DataAcquisitionWorkflows;
use Test;

my $pCOMMAND = DSL::English::DataAcquisitionWorkflows::Grammar;

##===========================================================
## Sanity check commands
##===========================================================
## The list of tests here is for illustration purposes.
## The list is made of small samples of more dedicated tests.

plan 10;

## 1
ok $pCOMMAND.parse('how many datasets have bus stop data'.lc),
        'how many datasets have bus stop data';

## 2
ok $pCOMMAND.parse('recommend a few data recipes'.lc),
        'recommend a few data recipes';

## 3
ok $pCOMMAND.parse('recommend a few datasets to experiment with'.lc),
        'recommend a few datasets to experiment with';

## 4
ok $pCOMMAND.parse('recommend a few datasets with time series data'.lc),
        'recommend a few datasets with time series data';

## 5
ok $pCOMMAND.parse('recommend datasets to analyze'.lc),
        'recommend datasets to analyze';

## 6
ok $pCOMMAND.parse('suggest a recipe with categorical data'.lc),
        'suggest a recipe with categorical data';

## 7
ok $pCOMMAND.parse('what do i analyze during easter'.lc),
        'what do i analyze during easter';

## 8
ok $pCOMMAND.parse('what did i acquire last year'.lc),
        'what did i acquire last year';

## 9
ok $pCOMMAND.parse('what do i acquire each month'.lc),
        'what do i acquire each month';

## 10
ok $pCOMMAND.parse('what number of datasets have anatomical structure variables'.lc),
        'what number of datasets have anatomical structure variables';

done-testing;
