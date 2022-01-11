#!/usr/bin/env perl6

use lib './lib';
use lib '.';

use DSL::Shared::FiniteStateMachines::CoreFSM;
use DSL::English::DataAcquisitionWorkflows::FSM;
use Data::ExampleDatasets;

#============================================================
# Object
#============================================================

my DSL::English::DataAcquistionWorkflows::FSM $daFSM .= new;

$daFSM.dataset = get-datasets-metadata();

#--------------------------------------------------------
# States
#--------------------------------------------------------
$daFSM.add-state("WaitForRequest",   -> $obj { say "🔊 PLEASE enter item request."; });
$daFSM.add-state("ListOfItems",      -> $obj { say "🔊 LISTING items."; });
$daFSM.add-state("PrioritizedList",  -> $obj { say "🔊 PRIORITIZED dataset."; });
$daFSM.add-state("WaitForFilter",    -> $obj { say "🔊 ENTER filter..."; });
$daFSM.add-state("AcquireItem",      -> $obj { say "🔊 ACQUIRE dataset: ", $obj.dataset[0]; });
$daFSM.add-state("Help",             -> $obj { say "🔊 HELP is help..."; });
$daFSM.add-state("Exit",             -> $obj { say "🔊 SHUTTING down..."; });

$daFSM.add-state("ParseAsDataQuery", -> $obj { say "🔊 PARSE as data query..."; });

#--------------------------------------------------------
# Transitions
#--------------------------------------------------------
$daFSM.add-transition("WaitForRequest",   "itemSpec",           "ListOfItems");
$daFSM.add-transition("WaitForRequest",   "startOver",          "WaitForRequest");
$daFSM.add-transition("WaitForRequest",   "priority",           "PrioritizedList");
$daFSM.add-transition("WaitForRequest",   "help",               "Help");
$daFSM.add-transition("WaitForRequest",   "quit",               "Exit");

$daFSM.add-transition("PrioritizedList",  "priorityListGiven",  "WaitForRequest");

$daFSM.add-transition("ListOfItems",      "manyItems",          "WaitForFilter");
$daFSM.add-transition("ListOfItems",      "noItems",            "WaitForRequest");
$daFSM.add-transition("ListOfItems",      "uniqueItemObtained", "AcquireItem");

$daFSM.add-transition("AcquireItem",      "startOver",          "WaitForRequest");

$daFSM.add-transition("WaitForFilter",    "startOver",          "WaitForRequest");
$daFSM.add-transition("WaitForFilter",    "filterInput",        "ListOfItems");
$daFSM.add-transition("WaitForFilter",    "priority",           "PrioritizedList");
$daFSM.add-transition("WaitForFilter",    "unrecognized",       "WaitForFilter");
$daFSM.add-transition("WaitForFilter",    "help",               "Help");
$daFSM.add-transition("WaitForFilter",    "quit",               "Exit");

$daFSM.add-transition("Help",             "helpGiven",          "WaitForRequest");

$daFSM.add-transition("WaitForFilter",    "tryDataQuery",       "ParseAsDataQuery");
$daFSM.add-transition("ParseAsDataQuery", "unrecognized",       "WaitForFilter");
$daFSM.add-transition("ParseAsDataQuery", "filterInput",        "ListOfItems");


#--------------------------------------------------------
# Run FSM
#--------------------------------------------------------

$daFSM.run('WaitForRequest');