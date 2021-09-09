use lib './lib';
use lib '.';
use DSL::English::DataAcquisitionWorkflows;
use Test;

##===========================================================
## Recommendations commands
##===========================================================

my $pCOMMAND = DSL::English::DataAcquisitionWorkflows::Grammar;

plan 16;

## 1
ok $pCOMMAND.parse('can you suggest a local dataset'.lc),
        'can you suggest a local dataset';

## 2
ok $pCOMMAND.parse('recommend bike store and collection page data'.lc),
        'recommend bike store and collection page data';

## 3
ok $pCOMMAND.parse('recommend bike store, cohort study and collection page dataset'.lc),
        'recommend bike store, cohort study and collection page dataset';

## 4
ok $pCOMMAND.parse('recommend bike store data'.lc),
        'recommend bike store data';

## 5
ok $pCOMMAND.parse('suggest something with time series'.lc),
        'suggest something with time series';

## 6
ok $pCOMMAND.parse('tell me a interesting recipe'.lc),
        'tell me a interesting recipe';

## 7
ok $pCOMMAND.parse('tell me categorical data suggestions'.lc),
        'tell me categorical data suggestions';

## 8
ok $pCOMMAND.parse('tell me Christmas data'.lc),
        'tell me Christmas data';

## 9
ok $pCOMMAND.parse('tell me Easter datasets'.lc),
        'tell me Easter datasets';

## 10
ok $pCOMMAND.parse('tell me non cohort study recipe'.lc),
        'tell me non cohort study recipe';

## 11
ok $pCOMMAND.parse('tell me non star schema recipe'.lc),
        'tell me non star schema recipe';

## 12
ok $pCOMMAND.parse('tell me numerical data suggestions'.lc),
        'tell me numerical data suggestions';

## 13
ok $pCOMMAND.parse('tell me some interesting apache arrow recipe'.lc),
        'tell me some interesting apache arrow recipe';

## 14
ok $pCOMMAND.parse('tell me some interesting hierarchical data recipe'.lc),
        'tell me some interesting hierarchical data recipe';

## 15
ok $pCOMMAND.parse('recommend 12 datasets with bike store'.lc),
        'recommend 12 datasets with bike store';

## 16
ok $pCOMMAND.parse('recommend top 12 datasets with bike store'.lc),
        'recommend top 12 datasets with bike store';

done-testing;