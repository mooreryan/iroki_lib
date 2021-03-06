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

def color_given? str
  str && !str.empty?
end

# TODO spec this for hex matching
def label_tag? str
  m = str.match(/\Alabel:(#?\p{Alnum}+)\Z/i)

  m[1] if m
end

# TODO spec this for hex matching
def branch_tag? str
  m = str.match(/\Abranch:(#?\p{Alnum}+)\Z/i)

  m[1] if m
end

module Iroki
  module CoreExt
    module File
      # @note Only checks that first and last chars off the file
      #   (minus trailing newlines) are correct. I.e., first char is
      #   '(' and last char is ';'
      def valid_newick? fname
        str = Object::File.read(fname).chomp
        first_char = str[0]
        last_char = str[-1]

        first_char == "(" && last_char == ";"
      end

      def check_file arg, which
        help = " Try iroki --help for help."

        abort_if arg.nil?,
                 "You must provide a #{which} file.#{help}"

        abort_unless Object::File.exists?(arg),
                     "The file '#{arg}' doesn't exist.#{help}"

        arg
      end


      # Parses the color map to return the pattern hash.
      #
      # @note If exact_matching is true, then the keys of the pattern
      #   hash will be strings. If the exact_matching flag is false,
      #   then the keys of the pattern hash will be Regexp objects.
      #
      # @todo what's the point of the iroki_to_name? To allow wonky
      #   chars maybe?
      def parse_color_map_iroki(fname,
                                iroki_to_name,
                                exact_matching: true,
                                auto_color: false)


        check_file fname, :color_map

        name_to_iroki = iroki_to_name.invert

        patterns = {}
        Object::File.open(fname, "rt").each_line do |line|
          unless line.start_with? "#"
            label_tag = ""
            branch_tag = ""

            pattern, label_color, branch_color = line.chomp.split "\t"

            pattern.strip! if pattern
            label_color.strip! if label_color
            branch_color.strip! if branch_color

            # color = "black" if color.nil? || color.empty?

            assert pattern, "found no pattern"

            if exact_matching # TODO should this really be everytime?
              if name_to_iroki.has_key? pattern
                pattern = name_to_iroki[pattern]
              else
                AbortIf::logger.info "String '#{pattern}' has no " +
                                     "match in " +
                                     "name_to_iroki map"
              end
            else
              # TODO flag bad regexp
              pattern = Regexp.new pattern
            end


            if color_given?(label_color) && color_given?(branch_color)
              if label_tag?(label_color) &&
                 label_tag?(branch_color)

                abort_unless label_color == branch_color,
                             "Label tags specified twice for " +
                             "#{line.inspect}, but the tags don't " +
                             "match."

                # ie both are label tags specifying the same color
                branch_color = nil
              elsif branch_tag?(label_color) &&
                    branch_tag?(branch_color)

                abort_unless label_color == branch_color,
                             "Branch tags specified twice for " +
                             "#{line.inspect}, but the tags don't " +
                             "match."

                # ie both are branch tags specifying the same color
                label_color = nil
              end
            end

            if color_given?(label_color) && !color_given?(branch_color)
              if (color = label_tag? label_color)
                label_tag = Iroki::Color.get_tag color, auto_color
              elsif (color = branch_tag? label_color)
                branch_tag = Iroki::Color.get_tag color, auto_color
              elsif line.match(/\t\Z/) # empty branch color, branch
                                       # will be black
                label_tag = Iroki::Color.get_tag label_color,
                                                 auto_color
              else
                label_tag = Iroki::Color.get_tag label_color,
                                                 auto_color
                branch_tag = Iroki::Color.get_tag label_color,
                                                  auto_color
              end
            else
              if color_given? label_color
                if (color = label_tag? label_color)
                  label_tag = Iroki::Color.get_tag color, auto_color
                elsif (color = branch_tag? label_color)
                  branch_tag = Iroki::Color.get_tag color, auto_color
                else
                  label_tag = Iroki::Color.get_tag label_color,
                                                   auto_color
                end
              end

              if color_given? branch_color
                if (color = branch_tag? branch_color)
                  branch_tag = Iroki::Color.get_tag color, auto_color
                elsif (color = label_tag? branch_color)
                  label_tag = Iroki::Color.get_tag color, auto_color
                else
                  branch_tag = Iroki::Color.get_tag branch_color,
                                                    auto_color
                end
              end
            end

            patterns[pattern] = { label: label_tag,
                                  branch: branch_tag }
          end
        end

        patterns
      end


      def parse_name_map fname
        check_file fname, :name_map

        name_map = {}
        Object::File.open(fname, "rt").each_line do |line|
          unless line.start_with? "#"
            abort_if line.chomp.split("\t").count > 2,
                     "Line (#{line.inspect}) has more than two columns"

            oldname, newname = line.chomp.split "\t"

            oldname.strip! if oldname
            newname.strip! if newname

            abort_if oldname.nil? || oldname.empty?,
                     "Column 1 missing for line: #{line.inspect}"

            abort_if newname.nil? || newname.empty?,
                     "Column 2 missing for line: #{line.inspect}"

            abort_if name_map.has_key?(oldname),
                     "#{oldname} is repeated in column 1"

            name_map[oldname] = newname
          end
        end

        abort_if duplicate_values?(name_map),
                 "Names in column 2 of name map file must be unique"

        name_map
      end
    end
  end
end
