=begin comment
#==============================================================================
#
#   Data Acquisition Workflows WL-System actions in Raku (Perl 6)
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
#   antononcube @ posteo . net,
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

use DSL::Entity::Metadata::Actions::WL::System;

use DSL::English::RecommenderWorkflows::Grammar;

class DSL::English::DataAcquisitionWorkflows::Actions::WL::System
        is DSL::Shared::Actions::English::TimeIntervalSpec
        is DSL::Entity::Metadata::Actions::WL::System {

    ##=====================================================
    ## General
    ##=====================================================
    has Str $.userID;

    method makeUserIDTag() {
        ( ! $.userID.defined or $.userID.chars == 0 or $.userID (elem) <NONE NULL>) ?? '' !! '"UserID:' ~ $.userID ~ '"';
    }

    method make-time-interval-predicate( %tiSpecArg ) {
        my %tiSpec = self.normalize-time-interval-spec(%tiSpecArg);
        'AbsoluteTime[DateObject["' ~ %tiSpec<From> ~ '"]] <= AbsoluteTime[#Timestamp] <= AbsoluteTime[DateObject["' ~ %tiSpec<To> ~ '"]]'
    }

    ##=====================================================
    ## TOP
    ##=====================================================
    method TOP($/) { make $/.values[0].made; }

    ##=====================================================
    ## Data query
    ##=====================================================
    method data-query-command($/)  {
        die "Not implemented: data-query-command."
    }
    method location-spec($/) { make $.Str; }

    ##=====================================================
    ## Introspection
    ##=====================================================
    method introspection-query-command($/) { make $/.values[0].made; }

    ##-----------------------------------------------------
    method introspection-data-retrieval ($/) {

        my $tiPred ='';

        with $<time-interval-spec> {
            say $<time-interval-spec>.made;
            my %tiSpec = $<time-interval-spec>.made;
            $tiPred = self.make-time-interval-predicate(%tiSpec);
        };

        if $<introspection-action><analyze> or $<introspection-action><analyzed> {
            $tiPred ~= ( $tiPred.chars > 0 ?? ' && ' !! ' ') ~ '#Action == "Analyze"'
        }

        with $<data-source-spec> {
            $tiPred ~= ( $tiPred.chars > 0 ?? ' && ' !! ' ') ~ 'ToLowerCase[#Source] == "' ~ self.data-source-spec($<data-source-spec>, :!tag).lc ~ '"'
        }

        if $.userID.defined and $.userID.chars > 0 {
            my $userIDPred = '#UserID == "' ~ $.userID ~ '"';
            make 'dsDataAcquisitions[Select[' ~ $tiPred ~ ' && '~ $userIDPred ~ '&]]'
        } else {
            make $tiPred.chars > 0 ?? 'dsDataAcquisitions[Select[' ~ $tiPred ~ '&]]' !! 'dsDataAcquisitions'
        }
    }

    ##-----------------------------------------------------
    method introspection-counts-query($/) {
        my $res = self.introspection-data-retrieval($/);
        make 'Length[' ~ $res ~']'
    }

    ##-----------------------------------------------------
    method introspection-profile-query ($/) {
        my $res = self.introspection-data-retrieval($/);
        make 'ResourceFunction["RecordsSummary"][' ~ $res ~']'
    }

    ##-----------------------------------------------------
    method introspection-last-time-query ($/) {
        my $res = self.introspection-data-retrieval($/);
        make $res ~'[SortBy[-AbsoluteTime[#Timestamp]&]][1 ;; UpTo[3]]'
    }

    ##-----------------------------------------------------
    method introspection-when-query ($/) {
        my $res = self.introspection-data-retrieval($/);
        make 'SortBy[' ~ $res ~', #Timestamp&]'
    }

    ##-----------------------------------------------------
    method introspection-timeline-query ($/) {
        my $res = self.introspection-data-retrieval($/);
        make 'Block[{dsTemp=' ~ $res ~ '}, GroupBy[Normal@dsTemp, #UserID &, TimelinePlot[#Timestamp -> #PeriodAcquisition & /@ #, AspectRatio -> 1/4, ImageSize -> Large] &]]'
    }

    ##=====================================================
    ## Ingredient query
    ##=====================================================
    method ingredient-query-command($/) {
        die 'ingredient-query-command:: Not implemented yet !!!';
    }

    ##=====================================================
    ## Recommendations
    ##=====================================================
    method recommendations-command($/) {
        make 'smrDataAcquisitions ==> SMRRecommend[' ~ self.makeUserIDTag() ~'] ==> SMRMonJoinAcross["Warning"->False] ==> SMRMonTakeValue[]';
    }

    ##=====================================================
    ## Recommendations by profile
    ##=====================================================
    method recommendations-by-profile-command($/) {
        make $/.values[0].made;
    }

    method recommendations-by-profile-opportunistic($/) {
        self.recommendations-by-profile-main($/);
    }

    method recommendations-by-profile-user-wants($/) {
        self.recommendations-by-profile-main($/);
    }

    method recommendations-by-profile-main($/) {
        my Str @resProfile;

        if $<data-quality-spec> {
             @resProfile.append($<data-quality-spec>.made)
        }

        if $<period-acquisition-spec> {
             @resProfile.append($<period-acquisition-spec>.made)
        }

        if $<period-spec> {
             @resProfile.append($<period-spec>.made)
        }

        if $<data-quality-spec-list> {
             @resProfile.append($<data-quality-spec-list>.made)
        }

        if $<data-with-quality-spec-list> {
             @resProfile.append($<data-with-quality-spec-list>.made)
        }

        if $<mixed-data-spec-list> {
             @resProfile.append($<mixed-data-spec-list>.made)
        }

        if $<data-source-spec> {
             @resProfile.append($<data-source-spec>.made)
        }

        if self.makeUserIDTag().chars > 0 {
            @resProfile = @resProfile.append(self.makeUserIDTag())
        }

        #make to_DSL_code('USE TARGET SMRMon-R; use smrDataAcquisitions; recommend by profile ' ~ @resProfile.join(', ') ~ '; echo pipeline value;');
        make 'smrDataAcquisitions ==> SMRMonRecommendByProfile[ {' ~ @resProfile.join(', ') ~ '} ] ==> SMRMonJoinAcross["Warning"->False] ==> SMRMonTakeValue[]';
    }

    ##=====================================================
    ## Fundamental tokens / rules
    ##=====================================================

    ##=====================================================
    ## Fundamental tokens / rules
    ##=====================================================
    method data-source-spec($/, :$tag = True) {
        make $tag ?? '"DataCategory:' ~ $/.Str.trim.lc ~ '"' !! '"' ~ $/.Str.trim.lc ~ '"';
    }

    method period-acquisition-spec($/) {
        make '"PeriodAcquistion' ~ $/.values[0].made.substr(1, *-1) ~ '"';
    }

    method period-spec($/) {
        make '"Period:' ~ $/.Str.lc ~ '"';
    }

    method mixed-data-spec-list($/) {
        make $/.values>>.made.flat;
    }

    method data-with-quality-spec-list($/) {
        make $/.values>>.made.flat;
    }

    method data-with-quality-spec($/) {
        make $/.values[0].made;
    }

    method data-quality-spec-list($/) {
        make $/.values>>.made.flat;
    }

    method data-quality-spec($/) {
        make $/.values[0].made;
    }

    method data-property-spec($/) {
        if $<entity-data-type-name> {
            make '"DataType:' ~ $<entity-data-type-name>.made.substr(1,*-1) ~ '"';
        } else {
            make '"DataType:' ~ $/.Str.trim.lc ~ '"';
        }
    }

    method data-non-property-spec($/) {
        make 'Not[' ~ $/.values[0].made.substr ~ ']';
    }

    method ingredient-spec-list($/) {
        make $/.values>>.made;
    }

    method ingredient-spec($/) {
        make '"ColumnHeading:' ~ $/.values[0].made.substr(1, *-1) ~ '"';
    }

}
