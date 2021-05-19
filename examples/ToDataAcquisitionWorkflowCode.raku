#!/usr/bin/env perl6
use DSL::English::DataAcquisitionWorkflows;

sub MAIN
#= Conversion of (natural) DSL commands for data acquisition to (programming) code. (Or DSLs of other natural languages.)
(Str $commands, #= natural language commands
 Str $target = 'WL-System', #= target language/system/package (defaults to 'WL-System')
 Str $userID = '' #= user identifier (defaults to '')
 )
{
    put ToDataAcquisitionWorkflowCode($commands, $target, :$userID);
}