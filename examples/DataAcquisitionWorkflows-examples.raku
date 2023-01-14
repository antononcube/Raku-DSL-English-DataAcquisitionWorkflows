use lib './lib';
use lib '.';
use DSL::English::DataAcquisitionWorkflows;

use DSL::English::DataAcquisitionWorkflows::Actions::WL::System;

my @testCommands = (
'recommend data to acquire',
#'recommend time series data for pumps',
#'recommend maintenance data for printers',
#'recommend customer service data that has product descriptions',
'create a random dataset with five columns and 2000 rows',
#"take time series data for company's fuel pumps",
#'what data did I worked with last month',
#'USER ID ssj889afa; when is the last time worked with time series data',
#'show timeline of when I create random data',
#'what did kind of data did I acquire last year',
#'plot the timeline of my customer service data usage',
#'which numerical columns have normal distribution',
#'how many records have missing values',
#'what are the outliers in column Col1 in the table Tbl1'
);

my @targets = <Python-Ecosystem Raku-Ecosystem WL-System>;

for @testCommands -> $c {
    say "=" x 120;
    say "command :\t", $c;
    for @targets -> $t {
        say "-" x 120;
        say $t;
        my $start = now;
        my $res = ToDataAcquisitionWorkflowCode($c ~ "\ninclude setup code", $t, format => 'hash');
        say "interpretation :\t", $res;
        say "time: ", round(now - $start,0.0001);
    }
}
