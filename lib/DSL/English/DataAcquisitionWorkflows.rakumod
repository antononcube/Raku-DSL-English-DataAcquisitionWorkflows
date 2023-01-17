
=begin pod

=head1 DSL::English::DataAcquisitionWorkflows

C<DSL::English::DataAcquisitionWorkflows> package has grammar and action classes for the parsing and
interpretation of natural language commands that specify data acquisition workflows.

=head1 Synopsis

    use DSL::English::DataAcquisitionWorkflows;
    my $rcode = ToDataAcquisitionWorkflowCode('i want to work with large time series data');

=end pod

unit module DSL::English::DataAcquisitionWorkflows;

use DSL::Shared::Utilities::CommandProcessing;

use DSL::Entity::Metadata;

use DSL::English::DataAcquisitionWorkflows::Grammar;
use DSL::English::DataAcquisitionWorkflows::Actions::Bulgarian::Standard;
use DSL::English::DataAcquisitionWorkflows::Actions::Python::Ecosystem;
use DSL::English::DataAcquisitionWorkflows::Actions::R::base;
use DSL::English::DataAcquisitionWorkflows::Actions::Raku::Ecosystem;
use DSL::English::DataAcquisitionWorkflows::Actions::WL::Ecosystem;

#-----------------------------------------------------------
my %targetToAction{Str} =
    "Bulgarian"         => DSL::English::DataAcquisitionWorkflows::Actions::Bulgarian::Standard,
    "Mathematica"       => DSL::English::DataAcquisitionWorkflows::Actions::WL::Ecosystem,
    "Python"            => DSL::English::DataAcquisitionWorkflows::Actions::Python::Ecosystem,
    "Python-Ecosystem"  => DSL::English::DataAcquisitionWorkflows::Actions::Python::Ecosystem,
    "R"                 => DSL::English::DataAcquisitionWorkflows::Actions::R::base,
    "R-base"            => DSL::English::DataAcquisitionWorkflows::Actions::R::base,
    "Raku"              => DSL::English::DataAcquisitionWorkflows::Actions::Raku::Ecosystem,
    "Raku-Ecosystem"    => DSL::English::DataAcquisitionWorkflows::Actions::Raku::Ecosystem,
    "WL"                => DSL::English::DataAcquisitionWorkflows::Actions::WL::Ecosystem,
    "WL-Ecosystem"      => DSL::English::DataAcquisitionWorkflows::Actions::WL::Ecosystem,
    "WL-System"         => DSL::English::DataAcquisitionWorkflows::Actions::WL::Ecosystem;

my %targetToAction2{Str} = %targetToAction.grep({ $_.key.contains('-') }).map({ $_.key.subst('-', '::') => $_.value }).Hash;
%targetToAction = |%targetToAction , |%targetToAction2;


my Str %targetToSeparator{Str} =
    "Bulgarian"         => "\n",
    "Mathematica"       => " \\[DoubleLongRightArrow]\n",
    "Python"            => "\n",
    "Python-Ecosystem"  => "\n",
    "R"                 => " ;\n",
    "Raku"              => " ;\n",
    "Raku-Ecosystem"    => " ;\n",
    "WL"                => " \\[DoubleLongRightArrow]\n",
    "WL-Ecosystem"      => " \\[DoubleLongRightArrow]\n",
    "WL-System"         => " \\[DoubleLongRightArrow]\n";

my Str %targetToSeparator2{Str} = %targetToSeparator.grep({ $_.key.contains('-') }).map({ $_.key.subst('-', '::') => $_.value }).Hash;
%targetToSeparator = |%targetToSeparator , |%targetToSeparator2;

#-----------------------------------------------------------
sub DataAcquisitionWorkflowsGrammar() is export {
    my $pCOMMAND = DSL::English::DataAcquisitionWorkflows::Grammar;
    $pCOMMAND.set-resources(DSL::Entity::Metadata::resource-access-object());
    return $pCOMMAND;
}

#-----------------------------------------------------------
proto ToDataAcquisitionWorkflowCode(Str $command, Str $target = 'WL-Ecosystem', | ) is export {*}

multi ToDataAcquisitionWorkflowCode ( Str $command, Str $target = 'WL-Ecosystem', *%args ) {

    my $pCOMMAND = DataAcquisitionWorkflowsGrammar();

    my $ACTOBJ = %targetToAction{$target}.new(resources => DSL::Entity::Metadata::resource-access-object());

    if $target ∉ %targetToAction.keys {
        die "No actions for the target $target."
    }

    DSL::Shared::Utilities::CommandProcessing::ToWorkflowCode($command,
                                                              grammar => $pCOMMAND,
                                                              targetToAction => %($target => $ACTOBJ),
                                                              :%targetToSeparator,
                                                              :$target,
                                                              |%args )
}
