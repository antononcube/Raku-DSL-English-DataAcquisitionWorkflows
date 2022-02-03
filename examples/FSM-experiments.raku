#!/usr/bin/env perl6

use lib './lib';
use lib '.';

use DSL::Shared::FiniteStateMachines::CoreFSM;
use DSL::English::DataAcquisitionWorkflows::FSM;
use Data::ExampleDatasets;
use Data::Reshapers;

#============================================================
# Object
#============================================================

my DSL::English::DataAcquisitionWorkflows::FSM $daFSM .= new;

$daFSM.make-machine;

#--------------------------------------------------------
# Run FSM
#--------------------------------------------------------

$daFSM.re-say = -> *@args { say |@args.map({ '⚙️' ~ $_.Str.subst(:g, "\n", "\n⚙️" )}) };
$daFSM.ECHOLOGGING = -> *@args {};

#$daFSM.run('WaitForRequest', ["take first five", "", "take the last one", "", ""]);
#$daFSM.run('WaitForRequest', ["filter by 'Title' starts with 'Air'", "", "show summary", "", "take the last one", "", ""]);
#$daFSM.run('WaitForRequest', ["show summary", "", "take top five", "", "take the last one", "", ""]);
$daFSM.run('WaitForRequest', ["show summary", "", "group by Rows; show counts", "", "start over", "take last twelve", "", "quit"]);
#$daFSM.run('WaitForRequest', ["show summary", "", "take top 5", "", "quit"]);
#$daFSM.run('WaitForRequest');

if $daFSM.acquiredData ~~ Array {
    say to-pretty-table($daFSM.acquiredData);
}