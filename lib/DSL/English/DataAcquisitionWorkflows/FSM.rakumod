use Data::Reshapers;
use Data::Summarizers;
use Data::ExampleDatasets;
use DSL::Shared::FiniteStateMachines::CoreFSM;
use DSL::Shared::Roles::English::GlobalCommand;
use DSL::Shared::Roles::English::ListManagementCommand;
use DSL::English::DataQueryWorkflows::Grammar;
use DSL::English::DataQueryWorkflows::Actions::Raku::Reshapers;
use DSL::Shared::Actions::English::Raku::ListManagementCommand;

my @datasetMetadata = get-datasets-metadata();

class DSL::English::DataAcquistionWorkflows::FSM
        is DSL::Shared::FiniteStateMachines::CoreFSM {

    #--------------------------------------------------------
    # This dataset is supposed to be handled by the functions Data::Reshapers
    has @.dataset;
    has $.itemSpec;
    has $.itemSpecCommand;

    #--------------------------------------------------------
    # Global command
    grammar GlobalCommand
            does DSL::Shared::Roles::ErrorHandling
            does DSL::Shared::Roles::English::GlobalCommand
            does DSL::Shared::Roles::English::PipelineCommand {

        rule TOP { <pipeline-command> | <global-command> }
    };

    #--------------------------------------------------------
    # List management command grammar
    grammar ListManagementCommand
            does DSL::Shared::Roles::English::ListManagementCommand
            does Lingua::NumericWordForms::Roles::English::WordedNumberSpec
            does DSL::Shared::Roles::ErrorHandling {

        rule TOP { <pipeline-command> | <list-management-command> }
    };

    #--------------------------------------------------------
    # List management command actions

    method list-management-command($/) {}
    method list-management-command($/) {}

    #--------------------------------------------------------
    multi method choose-transition(Str $stateID where $_ ~~ 'WaitForRequest',
                                   $input is copy = Whatever, UInt $maxLoops = 5 --> Str) {

        # Get next transitions
        my @transitions = %.states{$stateID}.explicitNext;

        &.ECHOLOGGING.(@transitions.raku.Str);

        # Get input if not given
        if $input.isa(Whatever) {
            $input = val get;
        }

        # Check was "global" command was entered. E.g."start over".
        my $pres = GlobalCommand.parse($input, rule => 'global-command');

        &.ECHOLOGGING.("$stateID: Global commad parsing result: ", $pres);

        if $pres<global-quit> {

            &.re-say.("$stateID: Quiting.");
            
            return @transitions.first({ $_.id eq 'quit' or $_.to eq 'Exit' }).to;

        } elsif $pres<global-cancel> {

            &.re-say.("$stateID: Starting over.");

            return @transitions.first({ $_.id eq 'startOver' or $_.to eq 'WaitForRequest' }).to;

        } elsif $pres<global-show-all> {

            $.dataset = @datasetMetadata;
            $.itemSpec = $pres;
            $.itemSpecCommand = $input;

            return @transitions.first({ $_.id eq 'itemSpec' or $_.to eq 'ListOfItems' }).to;

        } elsif $pres<global-help> {

            &.re-say.("$stateID: Help.");
            &.re-say.("$stateID: Type commands for the FSM...");

            return @transitions.first({ $_.id eq 'startOver' or $_.to eq 'WaitForRequest' }).to;

        } elsif $pres<global-priority-list> {

            return @transitions.first({ $_.id eq 'priority' or $_.to eq 'PriorityList' }).to;

        } elsif so $pres {

            $.re-warn.("$stateID: No implemented reaction for the given service input.");

            # Why not just return 'WaitForRequest' ?
            return @transitions.first({ $_.id eq 'startOver' or $_.to eq 'WaitForRequest' }).to;
        }

        # Main command handling
        ## Why not just switch ot 'WaitForFilter'?
        my $mres = ListManagementCommand.parse($input);

        &.ECHOLOGGING("$stateID: Main commad parsing result: ", $mres);

        # If it cannot be parsed, show message
        # Maybe ...

        if not so $mres {
            return @transitions.first({ $_.id eq 'startOver' or $_.to eq 'WaitForRequest' }).to;
        }

        # Switch to the next state
        $.itemSpecCommand = $input;
        $.itemSpec = $mres;
        return @transitions.first({ $_.id eq 'itemSpec' or $_.to eq 'ListOfItems' }).to;
    }

    #--------------------------------------------------------
    multi method choose-transition(Str $stateID where $_ ~~ 'ListOfItems',
                                   $input is copy = Whatever, UInt $maxLoops = 5 --> Str) {
        return 'None';
    }

    #--------------------------------------------------------
    multi method choose-transition(Str $stateID where $_ ~~ 'PrioritizedList',
                                   $input is copy = Whatever, UInt $maxLoops = 5 --> Str) {

        # Get next transitions
        my @transitions = %.states{$stateID}.explicitNext;

        &.ECHOLOGGING.(@transitions);

        &.re-say.(to-pretty-table($.dataset.pick(12)));
        return @transitions.first({ $_.id eq 'priorityListGiven' or $_.to eq 'WaitForRequest' }).to;
    }

    #--------------------------------------------------------
    multi method choose-transition(Str $stateID where $_ ~~ 'WaitForFilter',
                                   $input is copy = Whatever, UInt $maxLoops = 5 --> Str) {

        # Get next transitions
        my @transitions = %.states{$stateID}.explicitNext;

        &.ECHOLOGGING.(@transitions.raku.Str);

        # Get input if not given
        if $input.isa(Whatever) {
            $input = val get;
        }

        # Check was "global" command was entered. E.g."start over".
        my $pres = GlobalCommand.parse($input, rule => 'global-command');

        &.ECHOLOGGING.("$stateID: Global commad parsing result: ", $pres);

        if $pres<global-quit> {

            &.re-say.("$stateID: Quiting.");

            return @transitions.first({ $_.id eq 'quit' or $_.to eq 'Exit' }).to;

        } elsif so $pres {
            $.re-warn("$stateID: Delegate handling of global requests.");

            return @transitions.first({ $_.id eq 'startOver' or $_.to eq 'WaitForRequest' }).to;
        }

        # Main command handling
        my $mres = ListManagementCommandGrammar.parse($input,
                actions => DSL::Shared::Actions::English::Raku::ListManagementCommand.new)

        &.ECHOLOGGING("$stateID: Main commad parsing result: ", $mres);

        # Special cases handling
        if not so $mres {
            # Cannot parse as filtering command

            &.re-say.("$stateID: Switch to DataQueryWorkflows parsing");

            $.itemSpecCommand = $input;
            $.itemSpec = Nil;
            return @transitions.first({ $_.id eq 'tryDataQuery' or $_.to eq 'ParseAsDataQuery' }).to;

        } elsif $mres<list-management-command> {
            # List position command was entered. E.g."take the third one"
        }

        # Process "regularly" expected filtering input.

        ## Not implemented yet -- just delegate to ParseAsDataQuery


        # Switch to the next state
        $.itemSpecCommand = $input;
        $.itemSpec = $mres;
        return @transitions.first({ $_.id eq 'priorityListGiven' or $_.to eq 'WaitForRequest' }).to;
    }

    #--------------------------------------------------------
    multi method choose-transition(Str $stateID where $_ ~~ 'ParseAsDataQuery',
                                   $input is copy = Whatever, UInt $maxLoops = 5 --> Str) {
        return 'None';
    }

    #--------------------------------------------------------
    multi method choose-transition(Str $stateID where $_ ~~ 'AcquireItem',
                                   $input is copy = Whatever, UInt $maxLoops = 5 --> Str) {
        return 'None';
    }

    #--------------------------------------------------------
    multi method choose-transition(Str $stateID where $_ ~~ 'Help',
                                   $input is copy = Whatever, UInt $maxLoops = 5 --> Str) {
        return 'None';
    }

    #--------------------------------------------------------
    multi method choose-transition(Str $stateID where $_ ~~ 'Exit',
                                   $input is copy = Whatever, UInt $maxLoops = 5 --> Str) {
        return 'None';
    }
}