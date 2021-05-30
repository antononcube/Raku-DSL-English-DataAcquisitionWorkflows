use v6;

role DSL::English::DataAcquisitionWorkflows::Grammar::IntrospectionQuery {

    rule introspection-query-command {
        <introspection-counts-query> |
        <introspection-profile-query> |
        <introspection-last-time-query> |
        <introspection-when-query> |
        <introspection-timeline-query>
    }

    ## Counts
    rule introspection-counts-query {
        <.how-many-times-phrase> <user-spec> [ <acquired-phrase> | <analyzed-phrase> ] <data-source-spec> <time-interval-spec>
    }
    rule how-many-times-phrase {
        [ <.what-pronoun> <.number-noun> <.of-preposition> | <.how-adverb> <.many-data-acqui-word> ] <.times-noun>
    }

    ## Kind of food
    rule introspection-profile-query {
        <.what-pronoun> [ <.do-verb> | <.did-data-acqui-word> ] <user-spec> <introspection-action>
           [ [ <.for-preposition> | <.at-preposition> | <.during-preposition> | <.in-preposition> ] <period-spec> <period-acquisition-spec>? | <time-interval-spec> ] |
        <.what-pronoun> <.kind-data-acqui-word> <.of-preposition> <entity-food-name> <user-spec> <.make-data-acqui-word> <.most-data-acqui-word> <.often-data-acqui-word>
    }

    rule introspection-action {
        <acquire=.acquire-phrase> | <analyze=.analyze-phrase> |
        <acquired=.acquired-phrase> | <analyzed=.analyzed-phrase> |
        <acquired=.acquiring-phrase> | <analyzed=.analyzing-phrase> }

    ## Point-in-time
    rule introspection-last-time-query {
        [ <.when-pronoun> | <.what-pronoun> ] [ <.was-data-acqui-word> | <.is-verb> ] <.the-determiner> <last-data-acqui-word> <time-data-acqui-word> <user-spec> <introspection-action> <data-source-spec>? }

    ## When
    rule introspection-when-query {
        <.at-what-time-phrase> <.did-data-acqui-word> <user-spec> <introspection-action> <data-source-spec>?
    }
    rule at-what-time-phrase { <when-pronoun> | <at-preposition>? <what-pronoun> <time-noun> }

    ## Timeline
    rule introspection-timeline-query {
        [ <.display-timeline-phrase> | <.what-timeline-phrase> ] <.of-preposition>? [ <my-determiner> | <our-determiner> ]
            [ <data-source-spec> <introspection-action> | <introspection-action> <.of-preposition>? <data-source-spec>? ] |
        [ <.display-timeline-phrase> | <.what-timeline-phrase> ] <.of-preposition>? [ <.when-pronoun> | <.the-determiner> <.times-food-word-prep> ] <user-spec> <introspection-action> <data-source-spec>? |
        [ <.display-timeline-phrase> | <.what-timeline-phrase> ] [ <.of-preposition> | <.for-preposition> ]? [ <.my-data-acqui-word> | <.our-data-acqui-word> ]? <introspection-action> [ <.of-preposition> | <.for-preposition> ]? <data-source-spec>?
    }
    rule display-timeline-phrase { [ <display-directive> | <plot-directive> ] <the-determiner>? <timeline-noun> }
    rule what-timeline-phrase { <what-pronoun> <is-verb> <the-determiner>? <timeline-noun> }
}