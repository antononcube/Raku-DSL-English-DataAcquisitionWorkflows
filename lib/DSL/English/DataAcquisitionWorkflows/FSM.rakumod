=head1 Finite State Machine (FSM) class for data acquisition

=begin para
The code of this class is obsolete. It is kept for reference purposes.
The new FSM data acquisition class(es) are in DSL::FiniteStateMachines.
=end para


use Data::Reshapers;
use Data::Summarizers;
use Data::ExampleDatasets;
use DSL::Shared::FiniteStateMachines::CoreFSM;
use DSL::Shared::Roles::English::GlobalCommand;
use DSL::Shared::Roles::English::ListManagementCommand;
use DSL::English::DataQueryWorkflows::Grammar;
use DSL::English::DataQueryWorkflows::Actions::Raku::Reshapers;
use DSL::English::DataAcquisitionWorkflows::Actions::Raku::FSMCommand;
use Lingua::NumericWordForms::Roles::English::WordedNumberSpec;
use Text::CSV;
use XDG::BaseDirectory :terms;

my @datasetMetadata = get-datasets-metadata();

class DSL::English::DataAcquisitionWorkflows::FSM
        is DSL::Shared::FiniteStateMachines::CoreFSM {

    #--------------------------------------------------------
    # This dataset is supposed to be handled by the functions Data::Reshapers
    has $.dataset is rw;
    has $.acquiredData;
    has $.itemSpec;
    has $.itemSpecCommand;

    #--------------------------------------------------------
    # Metadata set predicate
    method is-metadata-row( $data ) {
        return $data ~~ Hash && ($data.keys (&) <Title Rows Cols CSV Doc>).elems == 5;
    }

    method is-metadata-dataset( $data ) {
        return ($data ~~ Array) && ([and] $data.map({ self.is-metadata-row($_) }));
    }

    #--------------------------------------------------------
    # Global command
    grammar FSMGlobalCommand
            is DSL::English::DataQueryWorkflows::Grammar
            does Lingua::NumericWordForms::Roles::English::WordedNumberSpec
            does DSL::Shared::Roles::English::GlobalCommand {
        rule TOP { <.display-directive>? <list-management-command> || <global-command> || <workflow-commands-list> }
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
        my $manager = DSL::English::DataAcquisitionWorkflows::Actions::Raku::FSMGrammar.new( object => $!dataset.clone);
        my $pres = FSMGlobalCommand.parse($input, rule => 'TOP', actions => $manager);

        &.ECHOLOGGING.("$stateID: Global commad parsing result: ", $pres);

        if $pres<global-command><global-quit> {

            &.re-say.("$stateID: Quiting.");

            return 'Exit';

        } elsif $pres<global-command><global-cancel> {

            &.re-say.("$stateID: Starting over.");

            $!dataset = @datasetMetadata.clone;

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

        if not so $pres {
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

        if $!itemSpec<global-command><global-show-all> {

            &.re-say.(to-pretty-table($!dataset));
            return "WaitForRequest";

        }

        my $lastDataset = $!dataset.clone;

        # Get new dataset
        &.ECHOLOGGING.("Parsed: {$!itemSpec.gist}");
        if $!itemSpec<list-management-command> || $!itemSpec<workflow-commands-list> {

            use MONKEY;
            my $obj = $!dataset;
            &.ECHOLOGGING.("Interpreted: {$!itemSpec.made}");
            EVAL $!itemSpec.made;
            $!dataset = $obj;
            if $!dataset ~~ Seq { $!dataset = $!dataset.Array }

        }

        if $lastDataset eqv $!dataset {
            &.re-say.("$stateID: Pipeline value was not changed.");
            return 'WaitForRequest';
        }

        &.re-say.("$stateID: Obtained the records:");
        #`(
        say '$!dataset : ', $!dataset.raku;
        say 'self.is-metadata-row($!dataset) : ', self.is-metadata-row($!dataset);
        say 'self.is-metadata-dataset($!dataset) : ', self.is-metadata-dataset($!dataset);
        )
        if self.is-metadata-row($!dataset) {
            &.re-say.(to-pretty-table([$!dataset,]))
        } elsif self.is-metadata-dataset($!dataset) {
            &.re-say.(to-pretty-table($!dataset));
        }

        if $!dataset.elems == 0 {
            # No items
            &.re-say.("Empty set was obtained. Reverting to previous value.");
            $!dataset = $lastDataset;

            return 'WaitForRequest';

        } elsif self.is-metadata-row($!dataset) || self.is-metadata-dataset($!dataset) && $!dataset.elems == 1 {
            # One item

            return 'AcquireItem';

        } else {
            # Many items

            return 'WaitForRequest';
        }


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
    multi method choose-transition(Str $stateID where $_ ~~ 'AcquireItem',
                                   $input is copy = Whatever, UInt $maxLoops = 5 --> Str) {

        # Get next transitions
        my @transitions = %.states{$stateID}.explicitNext;

        &.ECHOLOGGING.(@transitions.raku.Str);

        # The parser/ actions <list-management-command> might produce a table with one row
        # or just the hash corresponding to that row.
        # If the former take the content of the table.
        if $!dataset ~~ Array {
            $!dataset = $!dataset.values[0];
        }

        &.re-say.("Acquiring data : ", $!dataset<Title>);
        my $query = '\'' ~ $!dataset<Package> ~ '::' ~ $!dataset<Item> ~ '\'';
        $!itemSpec = $!dataset<Package> ~ '::' ~ $!dataset<Item>;
        $!acquiredData = example-dataset( / <{ $query }> $ / ):keep;

        return 'ExportData';
    }

    #--------------------------------------------------------
    multi method choose-transition(Str $stateID where $_ ~~ 'ExportData',
                                   $input is copy = Whatever, UInt $maxLoops = 5 --> Str) {
        # Prompt selection menu
        &.re-say.( "Export dataset as [1] R-project, [2] WL-notebook, [3] Raku-package, [4] Microsoft Excel file, or [5] No export\n(choose one...)");

        # Get selection
        my $n;
        loop {
            $n = val get;
            last if $n ~~ Int && $n ~~ 1..5;
            say "Invalid input; try again.";
        }

        # Compute export names
        my $dateTimeSuffix = DateTime.now(formatter => { sprintf "%04d-%02d-%02dT%02d-%02d-%02d", .year, .month, .day, .hour, .minute, .second }).Str;
        my $projName = $!itemSpec.subst('::','-') ~ $dateTimeSuffix;

        # Export actions
        if $n == 1 {
            # R-project is selected
            my $dirName = data-home.Str ~ '/DataAcquisitionFSM/rstudio';
            $dirName ~= '/' ~ $projName;

            # Create the package
            shell "mkdir -p $dirName";
            shell "R -e 'usethis::create_project(path=\"$dirName\")'";

            # Put in the data
            shell "mkdir $dirName/data";
            my $rproj = slurp %?RESOURCES<default.Rproj>;
            csv(in => $!acquiredData, out => "$dirName/data/dataset.csv", sep => ',');

            # Copy the R-project files
            spurt("$dirName/$projName.Rproj", $rproj);

            # Open
            shell "open $dirName/$projName.Rproj"

        } elsif $n == 4 {
            # Microsoft Excel is selected

            my $dirName = data-home.Str ~ '/DataAcquisitionFSM/MSExcel';
            $dirName ~= '/' ~ $projName;

            # Create the package
            shell "mkdir -p $dirName";

            # Put in the data
            csv(in => $!acquiredData, out => "$dirName/$projName.csv", sep => ',');

            # Open
            shell "open $dirName/$projName.csv"
        }

        # Goto Exit state or stay
        return $n < 5 ?? 'ExportData' !! 'Exit';
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

    #--------------------------------------------------------
    method make-machine() {
        note "This class is obsolete. Using the classes in DSL::FniniteStateMachines.";

        self.dataset = get-datasets-metadata(deepcopy=>True);

        #--------------------------------------------------------
        # States
        #--------------------------------------------------------
        self.add-state("WaitForRequest",   -> $obj { say "🔊 PLEASE enter item request."; });
        self.add-state("ListOfItems",      -> $obj { say "🔊 LISTING items."; });
        self.add-state("PrioritizedList",  -> $obj { say "🔊 PRIORITIZED dataset."; });
        self.add-state("AcquireItem",      -> $obj { say "🔊 ACQUIRE dataset: ", $obj.dataset[0]; });
        self.add-state("ExportData",       -> $obj { say "🔊 EXPORT dataset: ", $obj.dataset[0]; });
        self.add-state("Help",             -> $obj { say "🔊 HELP is help..."; });
        self.add-state("Exit",             -> $obj { say "🔊 SHUTTING down..."; });

        #--------------------------------------------------------
        # Transitions
        #--------------------------------------------------------
        self.add-transition("WaitForRequest",   "itemSpec",           "ListOfItems");
        self.add-transition("WaitForRequest",   "startOver",          "WaitForRequest");
        self.add-transition("WaitForRequest",   "priority",           "PrioritizedList");
        self.add-transition("WaitForRequest",   "help",               "Help");
        self.add-transition("WaitForRequest",   "quit",               "Exit");

        self.add-transition("PrioritizedList",  "priorityListGiven",  "WaitForRequest");

        self.add-transition("ListOfItems",      "manyItems",          "WaitForRequest");
        self.add-transition("ListOfItems",      "noItems",            "WaitForRequest");
        self.add-transition("ListOfItems",      "uniqueItemObtained", "AcquireItem");

        self.add-transition("AcquireItem",      "acquired",             "ExportData");
        self.add-transition("ExportData",       "exported",             "Exit");

        self.add-transition("Help",             "helpGiven",          "WaitForRequest");

        #--------------------------------------------------------
        # Loggers
        #--------------------------------------------------------

        self.re-say = -> *@args { say |@args.map({ '⚙️' ~ $_.Str.subst(:g, "\n", "\n⚙️" )}) };
        self.ECHOLOGGING = -> *@args {};

        # Result
        return self;
    }

}