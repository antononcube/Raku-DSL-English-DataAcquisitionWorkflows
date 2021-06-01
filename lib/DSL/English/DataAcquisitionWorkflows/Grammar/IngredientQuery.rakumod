use v6;

use DSL::English::DataAcquisitionWorkflows::Grammar::DataAcquisitionPhrases;
use DSL::English::DataAcquisitionWorkflows::Grammar::IngredientSpec;
use DSL::Shared::Roles::English::CommonSpeechParts;

role DSL::English::DataAcquisitionWorkflows::Grammar::IngredientQuery
        does DSL::English::DataAcquisitionWorkflows::Grammar::IngredientSpec {

    rule ingredient-query-command {
        <ingredient-query-which-items-query>    | <ingredient-query-how-many-items-query>
    }

    rule ingredient-query-which-items-query {
        <.which-items-phrase> <ingredient-query-body>
    }

    rule ingredient-query-how-many-items-query {
        <.how-many-items-phrase> <ingredient-query-body>
    }

    rule do-you-know-phrase {
        <do-verb> <you-data-acqui-word> <know-data-acqui-word>
    }

    rule have-phrase {
        <that-pronoun>? [ <have-data-acqui-word> | <contain-data-acqui-word> | <are-verb>? <with-preposition> ]
    }

    rule do-you-know-to-have-phrase { <do-you-know-phrase>? <to-preposition>? <have-phrase> }

    rule ingredient-query-body {
        <item-of-data-phrase> <.have-phrase> [ <.a-determiner> | <.the-determiner> ]? <.ingredients-phrase>? <ingredient-query-main-part> |
        <recipes-data-acqui-word> <.do-you-know-to-have-phrase> [ <.a-determiner> | <.the-determiner> ]? <.ingredients-phrase>? <ingredient-query-main-part> |
        <data-frames-data-acqui-word> <.do-you-know-to-have-phrase> [ <.a-determiner> | <.the-determiner> ]? <.ingredients-phrase>? <ingredient-query-main-part>
    }

    rule ingredient-query-main-part { <data-quality-spec-list> [ <data-noun> | <dataset-variables-phrase> ]? }
}