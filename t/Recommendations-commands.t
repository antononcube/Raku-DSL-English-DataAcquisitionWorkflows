use lib './lib';
use lib '.';
use DSL::English::DataAcquisitionWorkflows;
use Test;

##===========================================================
## Recommendations commands
##===========================================================

my $pCOMMAND = DSL::English::DataAcquisitionWorkflows::Grammar;

plan 18;

## 1
ok $pCOMMAND.parse('recommend data'.lc),
        'recommend data';

## 2
ok $pCOMMAND.parse('recommend a data schema'.lc),
        'recommend a data schema';

## 3
ok $pCOMMAND.parse('recommend data schemas'.lc),
        'recommend data schemas';

## 4
ok $pCOMMAND.parse('recommend a dataset'.lc),
        'recommend a dataset';

## 5
ok $pCOMMAND.parse('recommend datasets'.lc),
        'recommend datasets';

## 6
ok $pCOMMAND.parse('recommend a dataset to analyze'.lc),
        'recommend a dataset to analyze';

## 7
ok $pCOMMAND.parse('recommend a few datasets'.lc),
        'recommend a few datasets';

## 8
ok $pCOMMAND.parse('recommend data to acquire'.lc),
        'recommend data to acquire';

## 9
ok $pCOMMAND.parse('suggest data to acquire'.lc),
        'suggest data to acquire';

## 10
ok $pCOMMAND.parse('suggest data to analyze'.lc),
        'suggest data to analyze';

## 11
ok $pCOMMAND.parse('recommend datasets for the afternoon'.lc),
        'recommend datasets for the afternoon';

## 12
ok $pCOMMAND.parse('recommend data to acquire for easter'.lc),
        'recommend data to acquire for easter';

## 13
ok $pCOMMAND.parse('recommend some data to analyze for christmass'.lc),
        'recommend some data to analyze for christmass';

## 14
ok $pCOMMAND.parse('recommend datasets for easter'.lc),
        'recommend datasets for easter';

## 15
ok $pCOMMAND.parse('suggest a dataset to analyze'.lc),
        'suggest a dataset to analyze';

## 16
ok $pCOMMAND.parse('suggest me datasets'.lc),
        'suggest me datasets';

## 17
ok $pCOMMAND.parse('tell me a few datasets'.lc),
        'tell me a few datasets';

## 18
ok $pCOMMAND.parse('what to analyze'.lc),
        'what to analyze';

done-testing;
