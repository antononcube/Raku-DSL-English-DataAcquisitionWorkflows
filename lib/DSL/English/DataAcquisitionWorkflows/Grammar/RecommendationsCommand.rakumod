use v6;

role DSL::English::DataAcquisitionWorkflows::Grammar::RecommendationsCommand {

    rule recommendations-command {
        <.can-data-acqui-word> <.data-acquirer-spec> <.recommend-phrase> <.item-of-data-phrase> <.with-preposition> <ingredient-spec-list> |
        [ <.recommend-phrase> | <.what-pronoun> ]
          [ <several-phrase> | <a-determiner> | <the-determiner> ]?
          [ <.something-data-acqui-word> | <.some-determiner>? <.item-of-data-phrase> | <.item-of-data-phrase>? <recipe-phrase> ]?
          [ <.to-preposition> [ <analyze-phrase> | <acquire-phrase> ] ]?
          [ <.for-preposition> <.the-determiner>? [ <period-spec> | <period-acquisition-spec> ] ]?
    }

    rule recommendations-by-profile-command {
        <recommendations-by-profile-opportunistic> |
        <recommendations-by-profile-user-wants> |
        <recommendations-by-profile-main> }

    rule recommendations-by-profile-opportunistic {
        <.can-data-acqui-word> <.data-acquirer-spec> <.recommend-phrase> <.a-determiner>? [ <data-source-spec> <.dataset-phrase> | <.dataset-phrase> <.from-preposition> <data-source-spec> ] }

    rule recommendations-by-profile-user-wants {
        <user-spec> <.want-data-acqui-word> <.to-acquire-phrase>? [
           <.a-determiner>? [ <data-quality-spec-list> | <mixed-data-spec-list> ] <.item-of-data-phrase>? <period-acquisition-spec>? |
           <something-data-acqui-word> <.from-preposition>? [ <data-source-spec> | <data-with-quality-spec-list> ] [ [ <.for-preposition> | <.at-preposition> | <.during-preposition> ] <period-acquisition-spec> ]? |
           <period-acquisition-spec> <.from-preposition>? <data-source-spec> ] }

    rule recommendations-by-profile-main {
        [ <recommend-phrase> | <tell-data-acqui-word>  | <show-data-acqui-word> ] <.me-data-acqui-word>? <.a-determiner>? <.few-data-acqui-word>? [
           <item-of-data-phrase> <.from-preposition> <data-source-spec> |
           [ <recipe-phrase> | <item-of-data-phrase> ] [
              <.from-preposition> <data-source-spec> |
              <.with-preposition> <data-with-quality-spec-list> ] |
           <data-with-quality-spec-list> [ <recipe-phrase> | <dataset-phrase> ] |
           <some-data-acqui-word>? [ <data-quality-spec-list> || <mixed-data-spec-list> ] [ <item-of-data-recipe-phrase> | <item-of-data-phrase> <.recommendations-phrase>? | <recommendations-phrase> ] |
           <something-data-acqui-word> <.with-preposition>? <data-with-quality-spec-list> |
           <period-spec> <.item-of-data-phrase> |
           <new-data-acqui-word> <item-of-data-recipe-phrase> |
           <.some-data-acqui-word>? <interesting-data-acqui-word> [ <data-with-quality-spec-list> [ <dataset-phrase> | <acquisition-phrase> ]? ]? <recipe-phrase>? |
           <ingredient-spec-list> <item-of-data-phrase> <.recommendations-phrase> |
           <non-prefix> <data-source-spec> <recipe-phrase> |
           <.some-data-acqui-word>? <interesting-data-acqui-word> <data-source-spec> <recipe-phrase> ]
    }
}