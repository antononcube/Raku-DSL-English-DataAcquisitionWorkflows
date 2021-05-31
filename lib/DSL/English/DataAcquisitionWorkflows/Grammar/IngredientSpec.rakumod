use v6;

use DSL::Shared::Roles::English::PipelineCommand;

role DSL::English::DataAcquisitionWorkflows::Grammar::IngredientSpec
        does DSL::Shared::Roles::English::PipelineCommand {

    rule data-quality-spec { [ <ingredient-spec> | <data-property-spec> ]+ % <.list-separator> }

    rule ingredient-spec-list { <ingredient-spec>+ % <.list-separator> }

    rule ingredient-spec { <entity-metadata-name> }

    rule data-property-spec-list { <data-property-spec>+ % <.list-separator> }

    rule data-property-spec {
        <categorial-data-acqui-word> |
        <numerical-data-acqui-word> |
        <hierarchical-data-acqui-word> |
        <no-determiner> <missing-values-phrase> |
        <complete-cases-phrase> }

    token categorial-data-acqui-word { 'categorical' }
    token numerical-data-acqui-word { 'numerical' }
    token hierarchical-data-acqui-word { 'hierarchical' }
}