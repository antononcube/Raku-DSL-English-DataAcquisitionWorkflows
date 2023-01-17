use lib './lib';
use lib '.';
use DSL::English::DataAcquisitionWorkflows;

use DSL::English::DataAcquisitionWorkflows::Actions::WL::Ecosystem;
use DSL::English::DataAcquisitionWorkflows::Actions::R::base;
use DSL::English::DataAcquisitionWorkflows::Actions::Raku::Ecosystem;
use DSL::Entity::Geographics;

#-----------------------------------------------------------
my $pCOMMAND = DSL::English::DataAcquisitionWorkflows::Grammar;

$pCOMMAND.set-resources(DSL::Entity::Metadata::resource-access-object());

my $actionsObj = DSL::English::DataAcquisitionWorkflows::Actions::WL::Ecosystem.new(resources=>DSL::Entity::Metadata::resource-access-object());

sub daw-parse( Str:D $command, Str:D :$rule = 'TOP' ) {
        $pCOMMAND.parse($command, :$rule);
}

sub daw-interpret( Str:D $command,
                   Str:D:$rule = 'TOP',
                   :$actions = $actionsObj) {
        $pCOMMAND.parse( $command, :$rule, :$actions ).made;
}

#----------------------------------------------------------

say "=" x 60;
#my $cmd = 'which datasets have a variable that is about web pages';
#my $cmd = 'how many times I acquired hierarchical data in the last twenty three months';
#my $cmd = "when is the last time I analyzed time series data";
my $cmd = "recommend 20 data to acquire";
#my $cmd = "recommend 20 datasets to acquire";
#my $cmd = "recommend top 20 of datasets with bike store";

#my $cmd = "generate a random data frame";
#my $cmd = "generate a random data frame with 200 rows and 43 columns in long form";
#my $cmd = "generate a random dataset in long form with 200 rows and column names 'kira' and 'sala'";
#my $cmd = "generate a random text with 200 words using the seed words 'apartment', 'street'";
#my $cmd = "generate a random text with 20 sentences with GPT3 using the key words 'apartment', 'street'";
#my $cmd = "generate a random dataset with 200 rows and column names 'kira' and 'sala' in long form";
#my $cmd = "generate a random dataset with 200 rows and column names 'kira' and 'sala' in long form with 20 number of values";

say daw-parse( $cmd, rule => 'TOP' );

say '-' x 60;

say daw-interpret($cmd);

say "=" x 60;

#----------------------------------------------------------

my @testCommands = (
'can you suggest a local dataset',
'suggest something with time series',
'recommend data to acquire',
'recommend data to analyze',
'recommend data to acquire for easter',
'recommend some data to analyze for christmass',
'recommend bike store data',
'recommend bike store and collection page data'
);

my @testCommands2 = (
'show the timeline of my data acquisition',
'show the timeline of when I analyzed time series data',
'how many times I acquired hierarchical data in the last three months',
'how many times I processed time series last year',
'what data did we analyze between march and april',
'what datasets did I prepared from jan to april',
'what did I acquired from jan to may',
'what did I experimented with in the last two weeks',
'what did I analyzed last year',
'plot the timeline of my data acquisition'
);

my @targets = <WL-Ecosystem>;

for @testCommands2 -> $c {
    say "=" x 60;
    say $c;
    for @targets -> $t {
        say '-' x 30;
        say $t;
        say '-' x 30;
        my $start = now;
        my $res = daw-interpret($c, actions => $actionsObj);
        #my $res = daw-parse($c);
        say "time:", now - $start;
        say $res;
    }
}