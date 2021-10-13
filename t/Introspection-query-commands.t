use lib './lib';
use lib '.';
use DSL::English::DataAcquisitionWorkflows;
use Test;

##===========================================================
## Introspection commands
##===========================================================

my $pCOMMAND = DSL::English::DataAcquisitionWorkflows::Grammar;

plan 28;

## 1
ok $pCOMMAND.parse('how many times I acquired hierarchical data in the last three months'.lc),
        'how many times I acquired hierarchical data in the last three months';

## 2
ok $pCOMMAND.parse('How many times I acquired anatomical structure data last year'.lc),
        'How many times I acquired anatomical structure data last year';

## 3
ok $pCOMMAND.parse('How many times I used grocery store datasets last year'.lc),
        'How many times I used grocery store datasets last year';

## 4
ok $pCOMMAND.parse('how many times I acquired TV data last year'.lc),
        'how many times I acquired TV data last year';

## 5
ok $pCOMMAND.parse('How many times I analyzed star schema data last year'.lc),
        'How many times I analyzed star schema data last year';

## 6
ok $pCOMMAND.parse('how many times I analyzed star schema datasets last year'.lc),
        'how many times I analyzed star schema datasets last year';

## 7
ok $pCOMMAND.parse('how many times I processed time series last year'.lc),
        'how many times I processed time series last year';

## 8
ok $pCOMMAND.parse('plot the timeline of my data acquisition'.lc),
        'plot the timeline of my data acquisition';

## 9
ok $pCOMMAND.parse('plot the timeline of my time series ackquisition'.lc),
        'plot the timeline of my time series ackquisition';

## 10
ok $pCOMMAND.parse('show the timeline of my data acqusition'.lc),
        'show the timeline of my data acqusition';

## 11
ok $pCOMMAND.parse('show the timeline of when I acquired star schema data'.lc),
        'show the timeline of when I acquired star schema data';

## 12
ok $pCOMMAND.parse('show the timeline of when I analyzed time series data'.lc),
        'show the timeline of when I analyzed time series data';

## 13
ok $pCOMMAND.parse('show timeline of when I data analyzed'.lc),
        'show timeline of when I data analyzed';

## 14
ok $pCOMMAND.parse('what data did we analyze between march and april'.lc),
        'what data did we analyze between march and april';

## 15
ok $pCOMMAND.parse('what datasets did I prepare from jan to april'.lc),
        'what datasets did I prepare from jan to april';

## 16
ok $pCOMMAND.parse('what did I acquire from jan to may'.lc),
        'what did I acquire from jan to may';

## 17
ok $pCOMMAND.parse('what did I acquire from jan to may'.lc),
        'what did I acquire from jan to may';

## 18
ok $pCOMMAND.parse('what did I analyze last year'.lc),
        'what did I analyze last year';

## 19
ok $pCOMMAND.parse('what did I analyze from jan to april'.lc),
        'what did I analyze from jan to april';

## 20
ok $pCOMMAND.parse('what did I analyze in the last two weeks'.lc),
        'what did I analyze in the last two weeks';

## 21
ok $pCOMMAND.parse('what did I analyze last year'.lc),
        'what did I analyze last year';

## 22
ok $pCOMMAND.parse('what did I experimented with in the last two weeks'.lc),
        'what did I experimented with in the last two weeks';

## 23
ok $pCOMMAND.parse('what did we acquire between march and april'.lc),
        'what did we acquire between march and april';

## 24
ok $pCOMMAND.parse('what is the timeline for acaquiring time series data'.lc),
        'what is the timeline for acaquiring time series data';

## 25
ok $pCOMMAND.parse('when is the last time I acquired'.lc),
        'when is the last time I acquired';

## 26
ok $pCOMMAND.parse('when is the last time I acquired categorical data'.lc),
        'when is the last time I acquired categorical data';

## 27
ok $pCOMMAND.parse('when is the last time I acquired text data'.lc),
        'when is the last time I acquired text data';

## 28
ok $pCOMMAND.parse('when is the last time I analyzed'.lc),
        'when is the last time I analyzed';

done-testing;
