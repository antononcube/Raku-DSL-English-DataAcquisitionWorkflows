use v6;

use DSL::Shared::Roles::English::PipelineCommand;

role DSL::English::DataAcquisitionWorkflows::Grammar::IngredientSpec
        does DSL::Shared::Roles::English::PipelineCommand {

    rule data-quality-spec { <no-determiner> <missing-values-phrase> }

    rule ingredient-spec-list { <ingredient-spec>+ % <.list-separator> }

    rule ingredient-spec { <entity-metadata-name> }
}