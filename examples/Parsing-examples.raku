use lib './lib';
use lib '.';
use DSL::English::DataAcquisitionWorkflows;

use DSL::English::DataAcquisitionWorkflows::Actions::WL::System;

#-----------------------------------------------------------
my $pCOMMAND = DSL::English::DataAcquisitionWorkflows::Grammar;

sub daw-parse( Str:D $command, Str:D :$rule = 'TOP' ) {
        $pCOMMAND.parse($command, :$rule);
}

sub daw-interpret( Str:D $command,
                   Str:D:$rule = 'TOP',
                   :$actions = DSL::English::DataAcquisitionWorkflows::Actions::WL::System.new) {
        $pCOMMAND.parse( $command, :$rule, :$actions ).made;
}

#----------------------------------------------------------

say "=" x 60;
my $cmd = 'what did i acquire in the last eleven months';
#my $cmd = 'bike store';
#my $cmd = 'recommend bike store and collection page data';

#say daw-parse( $cmd, rule => 'introspection-query-command' );

#say daw-parse( 'bike store, collection page', rule => 'ingredient-spec-list' );

#say '-' x 60;
#
#say daw-interpret( $cmd );

say "=" x 60;

#----------------------------------------------------------

my @testCommands = (
'recommend data to acquire',
'recommend data to analyze',
'recommend data to acquire for easter',
'recommend some data to analyze for christmass',
'recommend bike store data',
'recommend bike store and collection page data'
);

my @testCommands2 = (
'show the timeline of my data acqusition',
'show the timeline of when I analyzed time series data',
'how many times I acquired hierarchical data in the last three months',
'how many times I processed time series last year',
'what data did we analuzed between march and april',
'what datasets did I prepared from jan to april',
'what did I acquired from jan to may',
'what did I experimented with in the last two weeks',
'what did I analyzed last year'
);

my @targets = <Bulgarian>;

for @testCommands -> $c {
    say "=" x 60;
    say $c;
    for @targets -> $t {
        say '-' x 30;
        say $t;
        say '-' x 30;
        my $start = now;
        my $res = daw-interpret($c, actions => DSL::English::DataAcquisitionWorkflows::Actions::Bulgarian::Standard.new);
        say "time:", now - $start;
        say $res;
    }
}