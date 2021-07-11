
=begin pod

=head1 DSL::English::DataAcquisitionWorkflows

C<DSL::English::DataAcquisitionWorkflows> package has grammar and action classes for the parsing and
interpretation of natural language commands that specify data acquisition workflows.

=head1 Synopsis

    use DSL::English::DataAcquisitionWorkflows;
    my $rcode = ToDataAcquisitionWorkflowCode('i want to work with large time series data');

=end pod

unit module DSL::English::DataAcquisitionWorkflows;

use DSL::Shared::Utilities::MetaSpecsProcessing;

use DSL::English::DataAcquisitionWorkflows::Grammar;
use DSL::English::DataAcquisitionWorkflows::Actions::Bulgarian::Standard;
use DSL::English::DataAcquisitionWorkflows::Actions::R::base;
use DSL::English::DataAcquisitionWorkflows::Actions::WL::System;

#-----------------------------------------------------------
my %targetToAction =
    "Mathematica"      => DSL::English::DataAcquisitionWorkflows::Actions::WL::System,
    "R"                => DSL::English::DataAcquisitionWorkflows::Actions::R::base,
    "R-base"           => DSL::English::DataAcquisitionWorkflows::Actions::R::base,
    "WL"               => DSL::English::DataAcquisitionWorkflows::Actions::WL::System,
    "WL-System"        => DSL::English::DataAcquisitionWorkflows::Actions::WL::System,
    "Bulgarian"        => DSL::English::DataAcquisitionWorkflows::Actions::Bulgarian::Standard;

my %targetToSeparator{Str} =
    "Julia"            => "\n",
    "Julia-DataFrames" => "\n",
    "R"                => " ;\n",
    "R-base"           => " ;\n",
    "Mathematica"      => "\n",
    "WL"               => ";\n",
    "WL-ClCon"         => " ==>\n",
    "WL-System"        => ";\n",
    "Bulgarian"        => "\n";


#-----------------------------------------------------------
sub has-semicolon (Str $word) {
    return defined index $word, ';';
}

#-----------------------------------------------------------
proto ToDataAcquisitionWorkflowCode(Str $command, Str $target = 'WL-System', Str :$userID = '' ) is export {*}

multi ToDataAcquisitionWorkflowCode ( Str $command where not has-semicolon($command), Str $target = 'WL-System', Str :$userID = '' ) {

    die 'Unknown target.' unless %targetToAction{$target}:exists;

    my $action = %targetToAction{$target}.new(:$userID);

    my $match = DSL::English::DataAcquisitionWorkflows::Grammar.parse($command.trim, actions => $action );
    die 'Cannot parse the given command.' unless $match;
    return $match.made;
}

multi ToDataAcquisitionWorkflowCode ( Str $command where has-semicolon($command), Str $target = 'WL-System', Str :$userID = '' ) {

    my $specTarget = get-dsl-spec( $command, 'target');
    my $specUserID = get-user-spec( $command, 'user-id');

    $specTarget = $specTarget ?? $specTarget<DSLTARGET> !! $target;
    $specUserID = ($specUserID and $specUserID<USERID> !(elem) <NONE NULL>) ?? $specUserID<USERID> !! $userID;

    die 'Unknown target.' unless %targetToAction{$specTarget}:exists;

    my @commandLines = $command.trim.split(/ ';' \s* /);

    @commandLines = grep { $_.Str.chars > 0 }, @commandLines;

    my @cmdLines = map { ToDataAcquisitionWorkflowCode($_, $specTarget, userID => $specUserID) }, @commandLines;

    @cmdLines = grep { $_.^name eq 'Str' }, @cmdLines;

    return @cmdLines.join( %targetToSeparator{$specTarget} ).trim;
}
