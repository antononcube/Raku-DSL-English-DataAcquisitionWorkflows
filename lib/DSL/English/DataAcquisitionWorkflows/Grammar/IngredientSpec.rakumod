use v6;

use DSL::Shared::Roles::English::PipelineCommand;
use DSL::Shared::Utilities::FuzzyMatching;

role DSL::English::DataAcquisitionWorkflows::Grammar::IngredientSpec
        does DSL::Shared::Roles::English::PipelineCommand {

    rule data-with-quality-spec-list { <.both-determiner>? <data-with-quality-spec>+ % <.list-separator> }

    rule data-with-quality-spec { <data-quality-spec-list> <.item-of-data-phrase>? }

    rule data-quality-spec-list { <.both-determiner>? <data-quality-spec>+ % <.list-separator> }

    rule data-quality-spec { <data-non-property-spec> || <data-property-spec> || <ingredient-spec> }

    rule ingredient-spec-list { <ingredient-spec>+ % <.list-separator> }

    rule ingredient-spec { <entity-metadata-name> }

    rule data-non-property-spec {
        <non-prefix> <data-property-spec>
    }

    rule data-property-spec {
        <entity-data-type-name> |
        <apache-data-acqui-word> <arrow-data-acqui-word> |
        <no-determiner> <missing-values-phrase> |
        <television-data-acqui-word> }

    token apache-data-acqui-word { :i 'apache' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'apache') }> }
    token arrow-data-acqui-word { :i 'arrow' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'arrow') }> }
    token television-data-acqui-word { :i 'television' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'television') }> | 'tv' }
}