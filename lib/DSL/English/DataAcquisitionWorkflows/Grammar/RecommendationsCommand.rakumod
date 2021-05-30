use v6;

role DSL::English::DataAcquisitionWorkflows::Grammar::RecommendationsCommand {

    rule recommendations-command {
        <.can-data-acqui-word> <.data-acquirer-spec> <.recommend-phrase> <.item-of-data-phrase> <.with-preposition> <ingredient-spec-list> |
        [ <.recommend-phrase> | <.what-pronoun> ] [ <several-phrase> || <a-determiner> || <the-determiner> ]? [ <.something-data-acqui-word> | <.item-of-data-phrase> | <recipe-phrase> ]? [ <.to-preposition> [ <analyze-phrase> | <acquire-phrase> ] ] ? [ <.for-preposition> <period-spec> ]?
    }

    rule recommendations-by-profile-command {
        <.can-data-acqui-word> <.data-acquirer-spec> <.recommend-phrase> <.a-determiner>? <data-source-spec> |
        <.user-be-phrase> <.sick-data-acqui-word> <.what-data-acqui-word> <.do-verb> <user-spec> <.analyze-phrase> |
        <.user-be-phrase> <.in-preposition> <.the-determiner> <.mood-data-acqui-word> <.for-preposition> <.a-determiner> <snack-data-acqui-word> |
        <user-spec> <.want-data-acqui-word> [ <.to-preposition> [ <.acquire-data-acqui-word>  | <.try-data-acqui-word> <.out-adverb>? ] ]? [
           <.a-determiner>? <mixed-data-spec-list> <period-acquisition-spec>? |
           <something-data-acqui-word> <.from-preposition>? [ <data-source-spec> | <data-quality-spec> ] [ [ <.for-preposition> | <.at-preposition> | <.during-preposition> ] <period-acquisition-spec> ]? |
           <period-acquisition-spec> <.from-preposition>? <data-source-spec> ] |
        <.user-be-phrase> <.feeling-data-acqui-word> <.sick-data-acqui-word> <recommend-phrase> <.me-data-acqui-word>? <.a-determiner>? <item-of-data-phrase> |
        [ <recommend-phrase> | <tell-data-acqui-word>  | <show-data-acqui-word> ] <.me-data-acqui-word>? <.a-determiner>? <.few-data-acqui-word>? [
           <item-of-data-phrase> <.from-preposition> <data-source-spec> |
           [ <recipe-phrase> | <item-of-data-phrase> ] [
              <.from-preposition> <data-source-spec> |
              <.with-preposition> <ingredient-spec-list> ] |
           <some-data-acqui-word>? [ <ingredient-spec-list> || <mixed-data-spec-list> ] [ <recipe-data-acqui-word> | <item-of-data-phrase> <.recommendations-phrase>? | <recommendations-phrase> ] |
           <something-data-acqui-word> <.with-preposition>? <ingredient-spec-list> |
           <period-spec> <.item-of-data-phrase> |
           <new-data-acqui-word> <recipe-data-acqui-word> |
           <interesting-data-acqui-word> <recipe-data-acqui-word> |
           <ingredient-spec-list> <item-of-data-phrase> <.recommendations-phrase> |
           <non-prefix> <data-source-spec> <recipe-data-acqui-word> |
           <.some-data-acqui-word> <interesting-data-acqui-word> <data-source-spec> <recipe-data-acqui-word> ]
    }
}