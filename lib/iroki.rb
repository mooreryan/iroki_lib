# Copyright 2016 Ryan Moore
# Contact: moorer@udel.edu
#
# This file is part of Iroki.
#
# Iroki is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Iroki is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Iroki.  If not, see <http://www.gnu.org/licenses/>.

require "abort_if"

require "iroki/biom"
require "iroki/tree"
require "iroki/version"

require "iroki/const/const"

require "iroki/color/color"
require "iroki/color/gradient"
require "iroki/color/single_group_gradient"
require "iroki/color/two_group_gradient"
require "iroki/color/palette/palette"

require "iroki/core_ext/hash/hash"
require "iroki/core_ext/string/string"
require "iroki/core_ext/file/file"
require "iroki/utils/utils"
require "iroki/main/main"


include Iroki::Const
include Iroki::Color
include Iroki::CoreExt::Hash
String.include Iroki::CoreExt::String
include Iroki::CoreExt::File
include Iroki::Utils

include AbortIf
include AbortIf::Assert

module Iroki
end
