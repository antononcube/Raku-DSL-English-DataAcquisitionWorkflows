use v6;

use DSL::Shared::Roles::English::PipelineCommand;

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
        <apache-data-acqui-word> <arrow-data-acqui-word> |
        <categorial-data-acqui-word> |
        <complete-cases-phrase> |
        <hierarchical-data-acqui-word> |
        <no-determiner> <missing-values-phrase> |
        <numerical-data-acqui-word> |
        <star-schema-phrase> |
        <television-data-acqui-word> |
        <textual-data-acqui-word> |
        <time-series-phrase> }

    token apache-data-acqui-word { 'apache' }
    token arrow-data-acqui-word { 'arrow' }
    token categorial-data-acqui-word { 'categorical' }
    token numerical-data-acqui-word { 'numerical' }
    token hierarchical-data-acqui-word { 'hierarchical' }
    token television-data-acqui-word { 'television' | 'tv' }
    token textual-data-acqui-word { 'textual' | 'text' }
}