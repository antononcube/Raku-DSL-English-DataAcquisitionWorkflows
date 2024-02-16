=begin comment
#==============================================================================
#
#   Data acquisition workflows grammar in Raku
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
#   For more details about Raku see https://raku.org/ .
#
#==============================================================================
=end comment

use v6.d;

use DSL::Shared::Roles::English::CommonParts;
use DSL::Shared::Roles::English::TimeIntervalSpec;
use DSL::Shared::Roles::English::PipelineCommand;
use DSL::Shared::Roles::PredicateSpecification;
use DSL::Shared::Roles::ErrorHandling;

use DSL::Entity::Metadata::Grammar::EntityNames;

use DSL::English::DataAcquisitionWorkflows::Grammar::IngredientQuery;
use DSL::English::DataAcquisitionWorkflows::Grammar::IntrospectionQuery;
use DSL::English::DataAcquisitionWorkflows::Grammar::RecommendationsCommand;
use DSL::English::DataAcquisitionWorkflows::Grammar::DataAcquisitionPhrases;
use DSL::English::DataAcquisitionWorkflows::Grammar::RandomDataGeneration;

use DSL::Entity::Metadata::ResourceAccess;

grammar DSL::English::DataAcquisitionWorkflows::Grammar
        does DSL::Shared::Roles::English::TimeIntervalSpec
        does DSL::Shared::Roles::English::PipelineCommand
        does DSL::Shared::Roles::ErrorHandling
        does DSL::Entity::Metadata::Grammar::EntityNames
        does DSL::English::DataAcquisitionWorkflows::Grammar::IntrospectionQuery
        does DSL::English::DataAcquisitionWorkflows::Grammar::IngredientQuery
        does DSL::English::DataAcquisitionWorkflows::Grammar::RecommendationsCommand
        does DSL::English::DataAcquisitionWorkflows::Grammar::DataAcquisitionPhrases
        does DSL::English::DataAcquisitionWorkflows::Grammar::RandomDataGeneration {

    my DSL::Entity::Metadata::ResourceAccess $resources;

    method get-resources(--> DSL::Entity::Metadata::ResourceAccess) { return $resources; }
    method set-resources(DSL::Entity::Metadata::ResourceAccess $obj) { $resources = $obj; }

    # TOPa
    rule TOP {
        <pipeline-command> ||
        <introspection-query-command> ||
        <ingredient-query-command> ||
        <recommendations-by-profile-command> ||
        <recommendations-command> ||
        <random-data-generation-command> ||
        <data-entity-command>
    }

    rule want-data-entity-command { 'i' 'want' [ 'to' 'use' ]? <entity-dataset-name> }

    rule data-entity-command { <entity-metadata-name> }

}

