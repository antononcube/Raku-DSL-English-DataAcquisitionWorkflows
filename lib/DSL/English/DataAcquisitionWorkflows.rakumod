
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
use DSL::English::DataAcquisitionWorkflows::Actions::WL::System;

#-----------------------------------------------------------
my %targetToAction{Str} =
    "Bulgarian"         => DSL::English::DataAcquisitionWorkflows::Actions::Bulgarian::Standard,
    "Mathematica"       => DSL::English::DataAcquisitionWorkflows::Actions::WL::System,
    "Python"            => DSL::English::DataAcquisitionWorkflows::Actions::Python::Ecosystem,
    "Python-Ecosystem"  => DSL::English::DataAcquisitionWorkflows::Actions::Python::Ecosystem,
    "R"                 => DSL::English::DataAcquisitionWorkflows::Actions::R::base,
    "R-base"            => DSL::English::DataAcquisitionWorkflows::Actions::R::base,
    "Raku"              => DSL::English::DataAcquisitionWorkflows::Actions::Raku::Ecosystem,
    "Raku-Ecosystem"    => DSL::English::DataAcquisitionWorkflows::Actions::Raku::Ecosystem,
    "WL"                => DSL::English::DataAcquisitionWorkflows::Actions::WL::System,
    "WL-System"         => DSL::English::DataAcquisitionWorkflows::Actions::WL::System;

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
    "WL-System"         => " \\[DoubleLongRightArrow]\n";

my Str %targetToSeparator2{Str} = %targetToSeparator.grep({ $_.key.contains('-') }).map({ $_.key.subst('-', '::') => $_.value }).Hash;
%targetToSeparator = |%targetToSeparator , |%targetToSeparator2;


#-----------------------------------------------------------
proto ToDataAcquisitionWorkflowCode(Str $command, Str $target = 'WL-System', | ) is export {*}

multi ToDataAcquisitionWorkflowCode ( Str $command, Str $target = 'WL-System', *%args ) {

#    DSL::Shared::Utilities::CommandProcessing::ToWorkflowCode( $command,
#                                                               grammar => DSL::English::DataAcquisitionWorkflows::Grammar,
#                                                               :%targetToAction,
#                                                               :%targetToSeparator,
#                                                               :$target,
#                                                               |%args );

    my $pCOMMAND = DSL::English::DataAcquisitionWorkflows::Grammar;
    $pCOMMAND.set-resources(DSL::Entity::Metadata::get-entity-resources-access-object());

    my $ACTOBJ = %targetToAction{$target}.new(resources => DSL::Entity::Metadata::get-entity-resources-access-object());

    DSL::Shared::Utilities::CommandProcessing::ToWorkflowCode( $command,
                                                               grammar => $pCOMMAND,
                                                               actions => $ACTOBJ,
                                                               separator => %targetToSeparator{$target},
                                                               |%args )
}
