=begin comment
#==============================================================================
#
#   Data Acquisition Workflows Python-Ecosystem actions in Python (Perl 6)
#   Copyright (C) 2022  Anton Antonov
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
#   For more details about Python (Perl6) see https://raku.org/ .
#
#==============================================================================
=end comment

use v6;

use DSL::English::DataAcquisitionWorkflows::Grammar;
use DSL::Shared::Actions::English::WL::PipelineCommand;
use DSL::Shared::Actions::English::TimeIntervalSpec;

use DSL::Entity::Metadata::Actions::WL::System;

use DSL::English::RecommenderWorkflows::Grammar;

class DSL::English::DataAcquisitionWorkflows::Actions::Python::Ecosystem
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

    # Separator
    method separator() { "." }

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
            my %tiSpec = $<time-interval-spec>.made;
            $tiPred = self.make-time-interval-predicate(%tiSpec);
        };

        if $<introspection-action><analyze> or $<introspection-action><analyzed> {
            $tiPred ~= ( $tiPred.chars > 0 ?? ' && ' !! ' ') ~ '$_<Action> eq "Analyze"'
        }

        with $<data-source-spec> {
            $tiPred ~= ( $tiPred.chars > 0 ?? ' && ' !! ' ') ~ ' $_<Source>.lc eq "' ~ self.data-source-spec($<data-source-spec>, :!tag).lc ~ '"'
        }

        if $.userID.defined and $.userID.chars > 0 {
            my $userIDPred = '#UserID == "' ~ $.userID ~ '"';
            make '@dataAcquisitions.grep({' ~ ( $tiPred.chars > 0 ?? $tiPred ~ ' and ' ~ $userIDPred !! $userIDPred ) ~ ' })'
        } else {
            make $tiPred.chars > 0 ?? 'dsDataAcquisitions[Select[' ~ $tiPred ~ '&]]' !! 'dsDataAcquisitions'
        }
    }

    ##-----------------------------------------------------
    method introspection-counts-query($/) {
        my $res = self.introspection-data-retrieval($/);
        make $res ~'.elems'
    }

    ##-----------------------------------------------------
    method introspection-profile-query ($/) {
        my $res = self.introspection-data-retrieval($/);
        make 'records-summary(' ~ $res ~')'
    }

    ##-----------------------------------------------------
    method introspection-last-time-query ($/) {
        my $res = self.introspection-data-retrieval($/);
        make $res ~'[SortBy[-AbsoluteTime[#Timestamp]&]][1 ;; UpTo[3]]'
    }

    ##-----------------------------------------------------
    method introspection-when-query ($/) {
        my $res = self.introspection-data-retrieval($/);
        make $res ~'.sort({ $_<Timestamp> })'
    }

    ##-----------------------------------------------------
    method introspection-timeline-query ($/) {
        my $res = self.introspection-data-retrieval($/);
        make '{ my $dsTemp=' ~ $res ~ '; group-by( $dsTemp, "UserID") }'
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
        my $nrecs = '';
        my Str $actionPred = '';
        if $<acquire-phrase> { $actionPred = '"Action:Acquire"'}
        elsif $<analyze-phrase> { $actionPred = '"Action:Analyze"'}

        if $<top-nrecs-spec> {
            $nrecs = ', ' ~ $<top-nrecs-spec>.made;
        }

        my Str $prof =
                do if self.makeUserIDTag().chars > 0 && $actionPred.chars > 0 { '{' ~ ( self.makeUserIDTag(), $actionPred).join(',') ~ '}' }
                elsif self.makeUserIDTag().chars > 0 {self.makeUserIDTag() }
                elsif $actionPred.chars > 0 { $actionPred }
                else {'' }

        make 'sbrDataAcquisitions' ~ self.separator() ~
                '.recommendByProfile(' ~ $prof ~ $nrecs ~ ').joinAcross().takeValue()'
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
        my Str $nrecs = '';
        my Str @resProfile;

        if $<top-nrecs-spec> {
            $nrecs = ', ' ~ $<top-nrecs-spec>.made;
        }

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
        make 'sbrDataAcquisitions' ~ self.separator() ~
                'recommendByProfile( [' ~ @resProfile.join(', ') ~ ']' ~ $nrecs ~ ').joinAcross().takeValue()';
    }

    ##=====================================================
    ## Random data generation
    ##=====================================================
    method random-data-generation-command($/) { make $/.values[0].made; }

    method random-tabular-data-generation-command($/) {

        if $<random-tabular-dataset-arguments-list> {
            my %allArgs = $<random-tabular-dataset-arguments-list>.made;
            %allArgs = %( NumberOfRows => 'None', NumberOfColumns => 'None' ) , %allArgs;

            if %allArgs<ColumnNames>:exists { %allArgs = %allArgs , %( NumberOfColumns => '[' ~ %allArgs<ColumnNames> ~ ']' ) }
            my %opts = %allArgs;
            %opts<NumberOfColumns>:delete;
            %opts<NumberOfRows>:delete;
            %opts<ColumnNames>:delete;

            my $opts = %opts.elems == 0 ?? '' !! ', ' ~ %opts.values.join(', ') ;
            make 'random_data_frame(' ~ %allArgs<NumberOfRows> ~ ', ' ~ %allArgs<NumberOfColumns> ~ $opts ~ ')';
        } else {
            make 'random_data_frame()';
        }
    }

    method random-tabular-dataset-arguments-list($/) { make $<random-tabular-dataset-argument>>>.made; }
    method random-tabular-dataset-argument($/) { make $/.values[0].made; }

    method random-tabular-dataset-nrows-spec($/) { make %( NumberOfRows => 'n_rows = ' ~ $/.values[0].made ); }

    method random-tabular-dataset-ncols-spec($/) { make %( NumberOfColumns => 'columns_spec = ' ~ $/.values[0].made ); }

    method random-tabular-dataset-colnames-spec($/) { make %( ColumnNames => 'columns_spec = ' ~ $/.values[0].made ); }

    method random-tabular-dataset-form-spec($/) { make %( Form => 'form = "' ~ $/.values[0].made ~ '"' ); }

    method random-tabular-dataset-col-generators-spec($/) { make %( Generators => 'generators = ' ~ $/.values[0].made ); }

    method random-tabular-dataset-max-number-of-values-spec($/) { make %( MaxNumberOfValues => 'max_number_of_values = ' ~ $/.values[0].made ); }

    method random-tabular-dataset-min-number-of-values-spec($/) { make %( MinNumberOfValues => 'min_number_of_values = ' ~ $/.values[0].made ); }

    method rows-or-columns-count-spec($/) { make $/.values[0].made; }

    ##=====================================================
    ## Fundamental tokens / rules
    ##=====================================================
    method top-nrecs-spec($/) {
        make $<integer-value>.made;
    }

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
        make 'not (' ~ $/.values[0].made.substr ~ ')';
    }

    method ingredient-spec-list($/) {
        make $/.values>>.made;
    }

    method ingredient-spec($/) {
        make '"ColumnHeading:' ~ $/.values[0].made.substr(1, *-1) ~ '"';
    }

    ##-------------------------------------------------------
    ## Generic
    ##-------------------------------------------------------
    method word-value($/) {
        make $/.Str;
    }

    # Column specs
    method column-specs-list($/) { make $<column-spec>>>.made.join(', '); }
    method column-spec($/) {  make $/.values[0].made; }
    method column-name-spec($/) { make '"' ~ $<mixed-quoted-variable-name>.made.subst(:g, '"', '') ~ '"'; }

    # Setup code commend
    method setup-code-command($/) {
        make 'SETUPCODE' =>"from RandomDataGenerators import *\nprint(\"Import/create smrDataAcquisitions\")\n";
    }
}
