=begin comment
#==============================================================================
#
#   Data Acquisition Workflows Bulgarian DSL actions in Raku (Perl 6)
#   Copyright (C) 2021  Anton Antonov
#
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
#   Written by Anton Antonov,
#   ʇǝu˙oǝʇsod@ǝqnɔuouoʇuɐ,
#   Windermere, Florida, USA.
#
#==============================================================================
#
#   For more details about Raku (Perl6) see https://raku.org/ .
#
#==============================================================================
=end comment

use v6;

use DSL::English::DataAcquisitionWorkflows::Grammar;
use DSL::Shared::Actions::English::WL::PipelineCommand;
use DSL::Shared::Actions::English::TimeIntervalSpec;

use DSL::Entity::Foods::Grammar::EntityNames;

use DSL::English::RecommenderWorkflows::Grammar;

class DSL::English::DataAcquisitionWorkflows::Actions::Bulgarian::Standard
        is DSL::Shared::Actions::English::TimeIntervalSpec
        is DSL::Shared::Actions::English::WL::PipelineCommand {

    ##=====================================================
    ## General
    ##=====================================================
    has Str $.userID is rw;

    has DSL::Entity::Metadata::ResourceAccess $.resources;

    method makeUserIDTag() {
        ( ! $.userID.defined or $.userID.chars == 0 or $.userID (elem) <NONE NULL>) ?? '' !! '"' ~ $.userID ~ '"';
    }

    method make-time-interval-predicate( %tiSpecArg ) {
        my %tiSpec = self.normalize-time-interval-spec(%tiSpecArg);
        'между ' ~ %tiSpec<From> ~ ' и ' ~ %tiSpec<To>;
    }

    ##=====================================================
    ## TOP
    ##=====================================================
    method TOP($/) { make $/.values[0].made; }

    ##=====================================================
    ## Introspection
    ##=====================================================
    method introspection-query-command($/) { make $/.values[0].made; }

    ##-----------------------------------------------------
    method introspection-data-retrieval ($/) {

        my $tiPred = '';
        my $pred = '';
        my $analyzePred = '';

        with $<time-interval-spec> {
            my %tiSpec = $<time-interval-spec>.made;
            $tiPred = self.make-time-interval-predicate(%tiSpec);
        };

        with $<introspection-action><analyze> or $<introspection-action><analyze> {
            $analyzePred = 'приготвени ';
        }

        with $<data-source-spec> {
            $pred = self.data-source-spec($<data-source-spec>, :!tag).lc;
        }

        my Str $userIDPred = ($.userID.defined and $.userID.chars > 0) ?? 'за потребителя "' ~ $.userID ~ '" ' !! '';

        my Str $datasets = $analyzePred ~ 'данни';

        if $tiPred.chars > 0 and $pred.chars > 0 {
            make $userIDPred ~ $datasets ~ ', които са ' ~ $tiPred ~ ', и за които ' ~ $pred;
        } elsif  $tiPred.chars > 0 {
            make $userIDPred ~ $datasets ~ ', които са ' ~ $tiPred;
        } elsif $pred.chars > 0 {
            make $userIDPred ~ $datasets ~ ', за които ' ~ $pred;
        } else {
            make $datasets ~ ' ' ~ $userIDPred;
        }
    }

    ##-----------------------------------------------------
    method introspection-counts-query($/) {
        my $res = self.introspection-data-retrieval($/);
        make 'брой на ' ~ $res;
    }

    ##-----------------------------------------------------
    method introspection-profile-query ($/) {
        my $res = self.introspection-data-retrieval($/);
        make 'Обобщи ' ~ $res;
    }

    ##-----------------------------------------------------
    method introspection-last-time-query ($/) {
        my $res = self.introspection-data-retrieval($/);
        make 'Кои са последните ' ~ $res;
    }

    ##-----------------------------------------------------
    method introspection-when-query ($/) {
        my $res = self.introspection-data-retrieval($/);
        make 'Кога ' ~ $res;
    }

    ##-----------------------------------------------------
    method introspection-timeline-query ($/) {
        my $res = self.introspection-data-retrieval($/);
        make 'Покажи времева линия за ' ~ $res;
    }

    ##=====================================================
    ## Ingredient query
    ##=====================================================
    method ingredient-query-command($/) {
        die 'ingredient-query-command:: Не е имплементирано !!!';
    }

    ##=====================================================
    ## Recommendations
    ##=====================================================
    method recommendations-command($/) {
        if $<analyze-phrase> && $<recipe-phrase> {
            make 'Препоръчай рецепти за анализ' ~ ($.userID.chars > 0 ?? ' за потребителя ' ~ self.makeUserIDTag() !! '')
        } elsif $<analyze-phrase> {
            make 'Препоръчай данни за анализ' ~ ($.userID.chars > 0 ?? ' за потребителя ' ~ self.makeUserIDTag() !! '')
        } elsif $<recipe-phrase> {
            make 'Препоръчай рецепти за подготвяне' ~ ($.userID.chars > 0 ?? ' за потребителя ' ~ self.makeUserIDTag() !! '')
        } else {
            make 'Препоръчай сурови или подготевени данни ' ~ ($.userID.chars > 0 ?? ' за потребителя ' ~ self.makeUserIDTag() !! '')
        }
    }

    ##=====================================================
    ## Recommendations by profile
    ##=====================================================
    method recommendations-by-profile-command($/) {
        my Str @resProfile;

        if $<data-with-quality-spec-list> {
             @resProfile.append($<data-with-quality-spec-list>.made)
        }

        if $<period-acquisition-spec> {
             @resProfile.append($<period-acquisition-spec>.made)
        }

        if $<mixed-data-spec-list> {
             @resProfile.append($<mixed-data-spec-list>.made)
        }

        if $<ingredient-spec-list> {
             @resProfile.append($<ingredient-spec-list>.made)
        }

        if self.makeUserIDTag().chars > 0 {
            make 'За потребителя ' ~ self.makeUserIDTag() ~ ' препоръчай данни или рецепти, които изпълняват условията: ' ~ @resProfile.join(', ');
        } else {
            make 'Препоръчай данни или рецепти, които изпълняват условията: ' ~ @resProfile.join(', ');
        }
    }

    ##=====================================================
    ## Fundamental tokens / rules
    ##=====================================================
    method entity-data-name($/) {
        make $/.Str.lc;
    }

    method entity-metadata-name($/) {
        make $/.Str.lc;
    }

    method data-source-spec($/) {
        make 'Източникът на данни е "' ~ $/.values[0].made ~ '"';
    }

    method period-acquisition-spec($/) {
        make 'Времето на трансформиране е "' ~ $/.Str.trim.lc ~ '"';
    }

    method period-spec($/) {
        make $/.Str.lc;
    }

    method data-with-quality-spec-list($/) {
        make 'Свойствата включват: ' ~ $/.values>>.made.join(', ');
    }

    method data-with-quality-spec($/) {
        make $/.values[0].made ~ ' данни';
    }

    method data-quality-spec-list($/) {
        make 'Свойствата включват: ' ~ $/.values>>.made.join(', ');
    }

    method data-quality-spec($/) {
        make $/.values[0].made;
    }

    method data-property-spec($/) {
        make '"' ~ $/.Str.trim.lc ~ '"';
    }

    method data-non-property-spec($/) {
        make 'без "' ~ $/.Str.trim.lc ~ '"';
    }

    method ingredient-spec-list($/) {
        make 'Метаданните включват: ' ~ $/.values>>.made.join(', ');
    }

    method ingredient-spec($/) {
        make '"' ~ $/.Str.trim.lc ~ '"';
    }
}
