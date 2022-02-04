#!/usr/bin/env perl6

use lib './lib';
use lib '.';

use DSL::Shared::FiniteStateMachines::CoreFSM;
use DSL::English::DataAcquisitionWorkflows::FSM;
use Data::ExampleDatasets;
use Data::Reshapers;
use Text::CSV;

#--------------------------------------------------------
# Create FSM object
#--------------------------------------------------------

my DSL::English::DataAcquisitionWorkflows::FSM $daFSM .= new;

$daFSM.make-machine;

#--------------------------------------------------------
# Adjust interaction and logging functions
#--------------------------------------------------------

$daFSM.re-say = -> *@args { say |@args.map({ '⚙️' ~ $_.Str.subst(:g, "\n", "\n⚙️" )}) };
$daFSM.ECHOLOGGING = -> *@args {};

#--------------------------------------------------------
# Run FSM
#--------------------------------------------------------

$daFSM.run('WaitForRequest');

#if $daFSM.acquiredData ~~ Array {
#    say to-pretty-table($daFSM.acquiredData);
#}
