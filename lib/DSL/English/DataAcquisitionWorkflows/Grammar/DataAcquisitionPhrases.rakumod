use v6;

use DSL::Shared::Roles::English::PipelineCommand;
use DSL::Shared::Roles::English::CommonSpeechParts;
use DSL::Shared::Utilities::FuzzyMatching;

use DSL::Entity::Metadata::Grammar::EntityNames;

# Food preparation specific phrases
role DSL::English::DataAcquisitionWorkflows::Grammar::DataAcquisitionPhrases
        does DSL::Entity::Metadata::Grammar::EntityNames
        does DSL::Shared::Roles::English::PipelineCommand {

    rule recommend-phrase {
        [ <recommend-data-acqui-word> | <suggest-data-acqui-word> | <tell-data-acqui-word> ] <to-preposition>? <me-data-acqui-word>?
    }

    rule recommendations-phrase {
        <recommendations-data-acqui-word>       | <suggestions-data-acqui-word>
    }

    ##-------------------------------------------------------
    rule recipe-phrase {
        <recipe-data-acqui-word> | <recipes-data-acqui-word>
    }

    rule item-of-data-recipe-phrase {
        <item-of-data-phrase>? <recipe-phrase>
    }

    ##-------------------------------------------------------
    rule item-of-data-phrase {
        <data-schema-phrase> || <dataset-phrase>
    }

    token dataset-phrase { <data-noun> | <dataset-noun> | <datasets-noun> | <data-frame> | <data-frames> }

    token data-schema-phrase { [ <data-noun> | <dataset-noun> ]? <schema-data-acqui-word> }
    token data-schemas-phrase { [ <data-noun> | <dataset-noun> ]? <schemas-data-acqui-word> }

    token acquisition-phrase { <acquisition-data-acqui-word> | <gathering-data-acqui-word> | <processing-data-acqui-word> }

    ##-------------------------------------------------------
    rule user-be-phrase {
        <user-spec> <user-be-verb> | <im-data-acqui-word>
    }

    token user-spec { <i-data-acqui-word> | <we-data-acqui-word> }

    token user-be-verb { <am-data-acqui-word> | <are-data-acqui-word> }

    ##-------------------------------------------------------
    rule data-acquirer-spec {
        <you-data-acqui-word>          | <data-acquirer-name>
    }

    token data-acquirer-name { [ <data-noun> | <dataset-noun> ] <acuirer-noun> <system-noun>? | 'das' }
    token acquirer-noun { :i 'acquirer' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'acquirer') }> }

    ##-------------------------------------------------------
    rule data-source-spec {
        [ <variable-name> | <local-adjective> ] [ <source-data-acqui-word> ]?
    }

    token local-adjective { :i 'local' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'local') }> }

    ##-------------------------------------------------------
    rule period-spec {
        <easter-noun> |
        <christmas-noun> }

    rule period-acquisition-spec {
        <morning-noun> |
        <noon-noun> |
        <afternoon-noun> |
        <evening-noun> |
        <night-noun> }

    token afternoon-noun { :i 'afternoon' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'afternoon') }> }
    token christmas-noun { :i 'christmas' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'christmas') }> }
    token easter-noun { :i 'easter' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'easter') }> }
    token evening-noun { :i 'evening' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'evening') }> }
    token morning-noun { :i 'morning' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'morning') }> }
    token night-noun { :i 'night' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'night') }> }
    token noon-noun { :i 'noon' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'noon') }> }

    ##-------------------------------------------------------
    rule mixed-data-spec-list {
        <data-quality-spec-list> <data-source-spec>? ||
        <data-source-spec> <data-quality-spec-list> ||
        [ <data-source-spec> | <data-quality-spec-list> ]+ % <.list-separator> }

    ##-------------------------------------------------------
    ## General rules
    rule several-phrase {
        <a-determiner>? <few-data-acqui-word> |
        <several-data-acqui-word> }

    rule analysis-phrase {
        <analysis-data-acqui-word> |
        <examination-data-acqui-word> |
        <examinations-data-acqui-word> }

    rule analyze-phrase {
        <analyze-data-acqui-word> |
        <prepare-data-acqui-word> |
        <experiment-with-phrase> }

    rule analyzing-phrase {
        <analyzing-data-acqui-word> |
        <preparing-data-acqui-word> |
        <experimenting-with-phrase> }

    rule analyzed-phrase {
        <analyzed-data-acqui-word> |
        <prepared-data-acqui-word> |
        <experiment-with-phrase> }

    rule experiment-with-phrase {
        <experiment-data-acqui-word> <with-preposition> |
        <try-data-acqui-word> <out-adverb>? }

    rule experimenting-with-phrase {
        <experimenting-data-acqui-word> <with-preposition> |
        <trying-data-acqui-word> <out-adverb>? }

    rule experimented-with-phrase {
        <experimented-data-acqui-word> <with-preposition> |
        <tried-data-acqui-word> <out-adverb>? }

    rule ingredients-phrase {
        <ingredient-data-acqui-word> |
        <ingredients-data-acqui-word> |
        <metadata-data-acqui-word> |
        <variable-noun> |
        <variables-noun> |
        <element-data-acqui-word> |
        <component-data-acqui-word> <part-data-acqui-word>? }

    rule which-items-phrase { <what-data-acqui-word> | <which-determiner> }
    rule how-many-items-phrase { <what-data-acqui-word> <number-data-acqui-word> <of-preposition> | <how-data-acqui-word> <many-data-acqui-word> }

    rule to-acquire-phrase { <to-preposition> <acquire-phrase> }
    rule acquire-phrase { <acquire-data-acqui-word> | <get-verb> | <process-data-acqui-word> }

    rule acquired-phrase { <acquired-data-acqui-word> | <got-data-acqui-word> | <had-data-acqui-word> | <processed-data-acqui-word>}

    rule acquiring-phrase { <acquiring-data-acqui-word> | <processing-data-acqui-word> }

    ##-------------------------------------------------------
    rule star-schema-phrase { <star-data-acqui-word> <schema-data-acqui-word> }

    rule dataset-variables-phrase { <dataset-phrase>? [ <variable-noun> | <variables-noun> | <column-noun> | <columns> ] }

    ##-------------------------------------------------------
    ## General tokens
    token acquire-data-acqui-word { :i 'acquire' | ([\w]+) <?{ $0.Str !(elem) <acquiring acquired> and is-fuzzy-match( $0.Str, 'acquire') }> }
    token acquired-data-acqui-word {  :i 'acquired' | ([\w]+) <?{ $0.Str !(elem) <acquire acquiring> and is-fuzzy-match( $0.Str, 'acquired') }>}
    token acquiring-data-acqui-word { :i 'acquiring' | ([\w]+) <?{ $0.Str !(elem) <acquire acquired> and is-fuzzy-match( $0.Str, 'acquiring') }> }
    token acquisition-data-acqui-word {  :i 'acquisition' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'acquisition') }> }
    token am-data-acqui-word { :i 'am' }
    token analysis-data-acqui-word { :i 'analysis' | ([\w]+) <?{ $0.Str !(elem) <analyze analyzed analyzing> and is-fuzzy-match( $0.Str, 'analysis') }> }
    token analyze-data-acqui-word { :i 'analyze' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'analyze', 1) }> }
    token analyzed-data-acqui-word { :i 'analyzed' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'analyzed') }> }
    token analyzing-data-acqui-word { :i 'analyzing' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'analyzing') }> }
    token are-data-acqui-word { :i 'are' }
    token can-data-acqui-word { :i 'can' }
    token component-data-acqui-word { :i 'component' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'component') }> }
    token contain-data-acqui-word { :i 'contain' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'contain') }> }
    token data-frame-data-acqui-word { :i <data-frame> }
    token data-frames-data-acqui-word { :i <data-frames> }
    token did-data-acqui-word { :i 'did' }
    token do-data-acqui-word { :i 'do' }
    token element-data-acqui-word { :i 'element' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'element') }> }
    token examination-data-acqui-word { :i 'examination' | ([\w]+) <?{ $0.Str !(elem) <examinations> and is-fuzzy-match( $0.Str, 'examination') }> }
    token examinations-data-acqui-word { :i 'examinations' | ([\w]+) <?{ $0.Str !(elem) <examination> and is-fuzzy-match( $0.Str, 'examinations') }> }
    token experiment-data-acqui-word { :i 'experiment' | ([\w]+) <?{ $0.Str !(elem) <experimented experimenting> and is-fuzzy-match( $0.Str, 'experiment') }> }
    token experimented-data-acqui-word { :i 'experimented' | ([\w]+) <?{ $0.Str !(elem) <experiment experimenting> and is-fuzzy-match( $0.Str, 'experimented') }> }
    token experimenting-data-acqui-word { :i 'experimenting' | ([\w]+) <?{ $0.Str !(elem) <experiment experimenting> and is-fuzzy-match( $0.Str, 'experimenting') }> }
    token feeling-data-acqui-word { :i 'feeling' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'feeling') }> }
    token few-data-acqui-word { :i 'few' | ([\w]+) <?{ $0.Str ne 'new' and is-fuzzy-match( $0.Str, 'few', 1) }> }
    token gathering-data-acqui-word {  :i 'gathering' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'gathering') }> }
    token got-data-acqui-word { :i 'got' }
    token had-data-acqui-word { :i 'had' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'had', 1) }> }
    token have-data-acqui-word { :i 'have' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'have', 1) }> }
    token how-data-acqui-word { :i 'how' | ([\w]+) <?{ $0.Str ne 'show' and is-fuzzy-match( $0.Str, 'how', 1) }> }
    token i-data-acqui-word { :i 'i' }
    token im-data-acqui-word { :i 'im' | 'i\'m' }
    token ingredient-data-acqui-word { :i 'ingredient' | ([\w]+) <?{ $0.Str ne 'ingredients' and is-fuzzy-match( $0.Str, 'ingredient') }> }
    token ingredients-data-acqui-word { :i 'ingredients' | ([\w]+) <?{ $0.Str ne 'ingredient' and is-fuzzy-match( $0.Str, 'ingredients') }> }
    token interesting-data-acqui-word { :i 'interesting' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'interesting') }> }
    token kind-data-acqui-word { :i 'kind' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'kind', 1) }> }
    token know-data-acqui-word { :i 'know' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'know', 1) }> }
    token last-data-acqui-word { :i 'last' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'last', 1) }> }
    token light-data-acqui-word { :i 'light' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'light') }> }
    token local-data-acqui-word { :i 'local' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'local') }> }
    token make-data-acqui-word { :i 'make' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'make', 1) }> }
    token many-data-acqui-word { :i 'many' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'many', 1) }> }
    token me-data-acqui-word { :i 'me' }
    token metadata-data-acqui-word { :i 'metadata' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'metadata') }> }
    token mood-data-acqui-word { :i 'mood' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'mood', 1) }> }
    token most-data-acqui-word { :i 'most' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'most', 1) }> }
    token my-data-acqui-word { :i 'my' }
    token new-data-acqui-word { :i 'new' | ([\w]+) <?{ $0.Str ne 'few' and is-fuzzy-match( $0.Str, 'new', 1) }> }
    token number-data-acqui-word { :i 'number' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'number') }> }
    token often-data-acqui-word { :i 'often' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'often') }> }
    token our-data-acqui-word { :i 'our' }
    token part-data-acqui-word { :i 'part' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'part', 1) }> }
    token prepare-data-acqui-word { :i 'prepare' | ([\w]+) <?{ $0.Str !(elem) <prepared preparing> and is-fuzzy-match( $0.Str, 'prepare') }> }
    token prepared-data-acqui-word { :i 'prepared' | ([\w]+) <?{ $0.Str !(elem) <prepare preparing> and is-fuzzy-match( $0.Str, 'prepared') }> }
    token preparing-data-acqui-word { :i 'preparing' | ([\w]+) <?{ $0.Str !(elem) <prepare prepared> and is-fuzzy-match( $0.Str, 'preparing') }> }
    token process-data-acqui-word { :i 'process' | ([\w]+) <?{ $0.Str !(elem) <processed processing> and is-fuzzy-match( $0.Str, 'process') }> }
    token processed-data-acqui-word { :i 'processed' | ([\w]+) <?{ $0.Str !(elem) <process processing> and is-fuzzy-match( $0.Str, 'processed') }> }
    token processing-data-acqui-word { :i 'processing' | ([\w]+) <?{ $0.Str !(elem) <process processed> and is-fuzzy-match( $0.Str, 'processing') }> }
    token reaction-data-acqui-word { :i 'reaction' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'reaction') }> }
    token recipe-data-acqui-word { :i 'recipe' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'recipe') }> }
    token recipes-data-acqui-word { :i 'recipes' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'recipes') }> }
    token recommend-data-acqui-word { :i 'recommend' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'recommend') }> }
    token recommendations-data-acqui-word { :i 'recommendations' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'recommendations') }> }
    token schema-data-acqui-word { :i 'schema' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'schema') }> }
    token schemas-data-acqui-word { :i 'schemas' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'schemas') }> }
    token several-data-acqui-word { :i 'several' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'several') }> }
    token show-data-acqui-word { :i 'show' | ([\w]+) <?{ $0.Str ne 'how' and is-fuzzy-match( $0.Str, 'show', 1) }> }
    token some-data-acqui-word { :i 'some' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'some', 1) }> }
    token something-data-acqui-word { :i 'something' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'something') }> }
    token source-data-acqui-word { :i 'source' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'source') }> }
    token star-data-acqui-word { :i 'star' | ([\w]+) <?{ $0.Str ne 'start' and is-fuzzy-match( $0.Str, 'star', 1) }> }
    token suggest-data-acqui-word { :i 'suggest' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'suggest') }> }
    token suggestions-data-acqui-word { :i 'suggestions' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'suggestions') }> }
    token tell-data-acqui-word { :i 'tell' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'tell', 1) }> }
    token time-data-acqui-word { :i 'time' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'time', 1) }> }
    token times-data-acqui-word { :i 'times' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'times') }> }
    token tried-data-acqui-word { :i 'tried' | ([\w]+) <?{ $0.Str !(elem) <try trying> and is-fuzzy-match( $0.Str, 'tried') }> }
    token try-data-acqui-word { :i 'try' | ([\w]+) <?{ $0.Str !(elem) <tried trying> and is-fuzzy-match( $0.Str, 'try', 1) }> }
    token trying-data-acqui-word { :i 'trying' | ([\w]+) <?{ $0.Str !(elem) <tried try> and is-fuzzy-match( $0.Str, 'trying') }> }
    token want-data-acqui-word { :i 'want' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'want', 1) }> | 'wants' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'wants') }> }
    token was-data-acqui-word { :i 'was' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'was', 1) }> }
    token we-data-acqui-word { :i 'we' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'we', 1) }> }
    token what-data-acqui-word { :i 'what' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'what', 1) }> }
    token when-data-acqui-word { :i 'when' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'when', 1) }> }
    token with-data-acqui-word { :i 'with' }
    token year-data-acqui-word { :i 'year' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'year', 1) }> }
    token you-data-acqui-word { :i 'you' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'you', 1) }> }
}
