use Data::Reshapers;
use Data::Summarizers;
use Data::ExampleDatasets;
use DSL::Shared::FiniteStateMachines::CoreFSM;
use DSL::Shared::Roles::English::GlobalCommand;
use DSL::Shared::Roles::English::ListManagementCommand;
use DSL::English::DataQueryWorkflows::Grammar;
use DSL::English::DataQueryWorkflows::Actions::Raku::Reshapers;
use DSL::English::DataAcquisitionWorkflows::Actions::RakuObject::FSMCommand;
use Lingua::NumericWordForms::Roles::English::WordedNumberSpec;

my @datasetMetadata = get-datasets-metadata();

class DSL::English::DataAcquistionWorkflows::FSM
        is DSL::Shared::FiniteStateMachines::CoreFSM {

    #--------------------------------------------------------
    # This dataset is supposed to be handled by the functions Data::Reshapers
    has $.dataset is rw;
    has $.acquiredData;
    has $.itemSpec;
    has $.itemSpecCommand;

    #--------------------------------------------------------
    # Global command
    grammar FSMGlobalCommand
            does Lingua::NumericWordForms::Roles::English::WordedNumberSpec
            does DSL::Shared::Roles::ErrorHandling
            does DSL::Shared::Roles::English::GlobalCommand
            does DSL::Shared::Roles::English::ListManagementCommand
            does DSL::Shared::Roles::English::PipelineCommand {

        rule TOP { <.display-directive>? <list-management-command> | <global-command> | <pipeline-command> }
    };

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
        my $manager = DSL::English::DataAcquisitionWorkflows::Actions::RakuObject::FSMGrammar.new( object => $!dataset.clone);
        my $pres = FSMGlobalCommand.parse($input, rule => 'TOP', actions => $manager);

        &.ECHOLOGGING.("$stateID: Global commad parsing result: ", $pres);

        if $pres<global-command><global-quit> {

            &.re-say.("$stateID: Quiting.");

            return 'Exit';

        } elsif $pres<global-command><global-cancel> {

            &.re-say.("$stateID: Starting over.");

            return 'WaitForRequest';

        } elsif $pres<global-command><global-show-all> {

            $!dataset = @datasetMetadata.clone;
            $!itemSpec = $pres;
            $!itemSpecCommand = $input;

            return 'ListOfItems';

        } elsif $pres<global-command><global-help> {

            &.re-say.("$stateID: Help.");
            &.re-say.("$stateID: Type commands for the FSM...");

            return 'WaitForRequest';

        } elsif $pres<global-command><global-priority-list> {

            return 'PriorityList';

        } elsif so $pres<global-command> {

            $.re-warn.("$stateID: No implemented reaction for the given service input.");

            # Why not just return 'WaitForRequest' ?
            return 'WaitForRequest';
        }

        &.ECHOLOGGING.("$stateID: Main commad parsing result: ", $pres);

        # If it cannot be parsed, show message
        # Maybe ...

        if not so $pres<list-management-command> {
            return 'WaitForRequest';
        }

        # Switch to the next state
        $!itemSpecCommand = $input;
        $!itemSpec = $pres;
        return 'ListOfItems';
    }

    #--------------------------------------------------------
    multi method choose-transition(Str $stateID where $_ ~~ 'ListOfItems',
                                   $input is copy = Whatever, UInt $maxLoops = 5 --> Str) {

        # Get next transitions
        my @transitions = %.states{$stateID}.explicitNext;

        &.ECHOLOGGING.(@transitions.raku.Str);
        &.ECHOLOGGING.("$stateID: itemSpec => $!itemSpec");

        if $!itemSpec<global-show-all> {

            &.re-say.(to-pretty-table($!dataset));
            return "WaitForRequest";

        }

        # Get new dataset
        if $!itemSpec<list-management-command> {
            $!dataset = $!itemSpec.made;
        }

        &.re-say.("$stateID: Obtained the records:");
        if $!dataset ~~ Hash {
            &.re-say.(to-pretty-table([$!dataset,]))
        } else {
            &.re-say.(to-pretty-table($!dataset));
        }

        # No items

        # One item
        if $!dataset ~~ Hash {
            return "AcquireItem"
        }

        # Many items

        return 'WaitForRequest';
    }

    #--------------------------------------------------------
    multi method choose-transition(Str $stateID where $_ ~~ 'PrioritizedList',
                                   $input is copy = Whatever, UInt $maxLoops = 5 --> Str) {

        # Get next transitions
        my @transitions = %.states{$stateID}.explicitNext;

        &.ECHOLOGGING.(@transitions);

        &.re-say.(to-pretty-table($.dataset.pick(12)));
        return 'WaitForRequest';
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
        my $pres = FSMGlobalCommand.parse($input,
                rule => 'global-command',
                actions => DSL::Shared::Actions::English::RakuObject::ListManagementCommand.new( object => $.dataset) );

        &.ECHOLOGGING.("$stateID: Global commad parsing result: ", $pres);

        if $pres<global-quit> {

            &.re-say.("$stateID: Quiting.");

            return @transitions.first({ $_.id eq 'quit' or $_.to eq 'Exit' }).to;

        } elsif so $pres {
            $.re-warn("$stateID: Delegate handling of global requests.");

            return 'WaitForRequest';
        }

        # Main command handling
        &.ECHOLOGGING("$stateID: Main commad parsing result: ", $pres);

        # Special cases handling
        if $pres<list-management-command> {
            # List position command was entered. E.g."take the third one"

            $pres.made;

        } elsif not so $pres {
            # Cannot parse as filtering command

            &.re-say.("$stateID: Switch to DataQueryWorkflows parsing");

            $!itemSpecCommand = $input;
            $!itemSpec = Nil;
            return 'ParseAsDataQuery';

        }

        # Process "regularly" expected filtering input.

        ## Not implemented yet -- just delegate to ParseAsDataQuery


        # Switch to the next state
        $!itemSpecCommand = $input;
        $!itemSpec = $pres;
        return 'WaitForRequest';
    }

    #--------------------------------------------------------
    multi method choose-transition(Str $stateID where $_ ~~ 'ParseAsDataQuery',
                                   $input is copy = Whatever, UInt $maxLoops = 5 --> Str) {
        return 'None';
    }

    #--------------------------------------------------------
    multi method choose-transition(Str $stateID where $_ ~~ 'AcquireItem',
                                   $input is copy = Whatever, UInt $maxLoops = 5 --> Str) {

        # Get next transitions
        my @transitions = %.states{$stateID}.explicitNext;

        &.ECHOLOGGING.(@transitions.raku.Str);

        &.re-say.("Acquiring data : ", $!dataset<Title>);
        $!acquiredData = example-dataset( $!dataset<Package> ~ '::' ~ $!dataset<Item> ):keep;

        return 'Exit';
    }

    #--------------------------------------------------------
    multi method choose-transition(Str $stateID where $_ ~~ 'Help',
                                   $input is copy = Whatever, UInt $maxLoops = 5 --> Str) {
        return 'None';
    }

    #--------------------------------------------------------
    multi method choose-transition(Str $stateID where $_ ~~ 'Exit',
                                   $input is copy = Whatever, UInt $maxLoops = 5 --> Str) {
        # Should we ever be here?!
        return 'None';
    }
}