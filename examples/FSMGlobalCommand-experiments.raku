#!/usr/bin/env perl6

use lib './lib';
use lib '.';

use Lingua::NumericWordForms::Roles::English::WordedNumberSpec;
use DSL::English::DataQueryWorkflows::Grammar;
use DSL::Shared::FiniteStateMachines::CoreFSM;
use DSL::Shared::Roles::English::GlobalCommand;
use DSL::Shared::Roles::English::ListManagementCommand;
use DSL::Shared::Roles::English::PipelineCommand;
use DSL::Shared::Roles::ErrorHandling;
use DSL::Shared::Actions::English::RakuObject::ListManagementCommand;

use DSL::English::DataAcquisitionWorkflows::Actions::RakuObject::FSMCommand;
use DSL::English::DataAcquisitionWorkflows::FSM;

use Data::ExampleDatasets;
use Data::Generators;
use Data::Reshapers;
use Data::Summarizers;

# Global command
grammar FSMGlobalCommand
        is DSL::English::DataQueryWorkflows::Grammar
        does Lingua::NumericWordForms::Roles::English::WordedNumberSpec
        does DSL::Shared::Roles::English::GlobalCommand {
    rule TOP {
        <.display-directive>? <list-management-command> | <global-command> | <workflow-commands-list>
    }
};

srand(332);
my @temp = random-tabular-dataset( 12, <axiom theorem conjecture lemma corollary>, generators => { axiom => &random-pet-name } );

say to-pretty-table(@temp);

#my $input = "select the columns lemma and axiom; filter by axiom is like rx/ <[A..M]> .* /; echo pipeline value; summarize";
my $input = "select the columns lemma and axiom; filter by axiom starts with 'M'; echo pipeline value; summarize";
#my $input = "show top 5 elements";

my $manager = DSL::English::DataAcquisitionWorkflows::Actions::RakuObject::FSMGrammar.new(object => @temp.clone);

my $pres = FSMGlobalCommand.parse($input, rule => 'TOP', actions => $manager);

say '⎯' x 60;

say "Commands :\n $input";

say '⎯' x 60;

say "Parsed :";
say $pres;

say '⎯' x 60;

say "Interpreted :";
say $pres.made;

say '⎯' x 60;

my $res;

if so $pres<workflow-commands-list> {
    use MONKEY;
    my $obj = @temp;
    EVAL $pres.made;
    $res = $obj;
} else {
    $res = $pres.made
}

if $res ~~ Hash {

    say to-pretty-table([$res,])

} else {
    say to-pretty-table($res);
}

