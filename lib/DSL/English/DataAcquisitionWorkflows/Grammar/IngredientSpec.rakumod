use v6;

use DSL::Shared::Roles::English::PipelineCommand;

role DSL::English::DataAcquisitionWorkflows::Grammar::IngredientSpec
        does DSL::Shared::Roles::English::PipelineCommand {

    rule data-quality-spec { [ <data-property-spec> || <data-non-property-spec> || <ingredient-spec> ]+ % <.list-separator> }

    rule ingredient-spec-list { <ingredient-spec>+ % <.list-separator> }

    rule ingredient-spec { <entity-metadata-name> }

    rule data-property-spec-list { <data-property-spec>+ % <.list-separator> }

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
        <time-series-data> }

    token apache-data-acqui-word { 'apache' }
    token arrow-data-acqui-word { 'arrow' }
    token categorial-data-acqui-word { 'categorical' }
    token numerical-data-acqui-word { 'numerical' }
    token hierarchical-data-acqui-word { 'hierarchical' }
}