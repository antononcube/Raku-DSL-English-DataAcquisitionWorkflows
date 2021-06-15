=begin comment
#==============================================================================
#
#   Data Acquisition Workflows R-base actions in Raku (Perl 6)
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
use DSL::Shared::Actions::English::R::PipelineCommand;
use DSL::Entity::Foods::Grammar::EntityNames;

class DSL::English::DataAcquisitionWorkflows::Actions::R::Fineli
        is DSL::Shared::Actions::English::R::PipelineCommand {

    method TOP($/) { make 'Not implemented.'; }
}
