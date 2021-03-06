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

require "spec_helper"
require "fileutils"

describe Iroki::Main do
  let(:this_dir) { File.dirname __FILE__ }
  let(:spec_dir) { File.join this_dir, ".." }
  let(:test_files) { File.join spec_dir, "test_files" }
  let(:nexus_files) { File.join test_files, "nexus_files" }

  # The vals ror the original tests
  let(:min_lumin) { 50 }
  let(:max_lumin) { 90 }

  let(:empty_name_map) { File.join test_files, "empty.name_map" }

  let(:two_group_biom) { File.join test_files, "two_group.biom" }
  let(:two_group_tre) { File.join test_files, "two_group.tre" }
  let(:two_group_nex) { File.join nexus_files, "two_group.nex" }

  let(:single_sample_biom) { File.join test_files, "single_sample.biom" }
  let(:single_sample_tre) { File.join test_files, "single_sample.tre" }
  let(:single_sample_nex) { File.join nexus_files, "single_sample.nex" }
  let(:single_sample_one_color_nex) { File.join nexus_files, "single_sample_one_color.nex" }

  let(:newick) { File.join test_files, "test.tre" }
  let(:expected_nexus) { File.join nexus_files, "expected.nex" }
  let(:output_nexus) { File.join nexus_files, "output.nex" }
  let(:color_map) { File.join test_files, "test.color_map" }

  let(:jess_newick) { File.join test_files, "jess.tre" }
  let(:jess_nexus)  { File.join nexus_files, "jess.nex" }

  let(:small_newick)    { File.join test_files, "small.tre" }
  let(:small_nexus)     { File.join nexus_files, "small.nex" }
  let(:small_color_map) { File.join test_files, "small.color_map" }

  let(:kelly_newick)    { File.join test_files, "23.tre" }
  let(:kelly_nexus)     { File.join nexus_files, "23.nex" }
  let(:kelly_out)       { File.join nexus_files, "23.out.nex" }
  let(:kelly_color_map) { File.join test_files, "23.color_map" }


  let(:regex_bug_tre) {
    File.join test_files, "regex_bug.tre"
  }
  let(:regex_bug_color_map) {
    File.join test_files, "regex_bug.color_map"
  }
  let(:regex_bug_nexus) {
    File.join nexus_files, "regex_bug.nex"
  }

  # deep dive into testing command line options in conjunction with a
  # complicated color map
  let(:basic_tre) { File.join test_files, "basic.tre" }

  let(:basic_color_map_with_tags) {
    File.join test_files, "basic_color_map_with_tags.txt" }
  let(:basic_color_map_regex) {
    File.join test_files, "basic_color_map_regex.txt" }

  let(:basic_branches) {
    File.join nexus_files, "basic_branches_only.nex" }
  let(:basic_branches_regex) {
    File.join nexus_files, "basic_branches_only_regex.nex" }

  let(:basic_labels) {
    File.join nexus_files, "basic_labels_only.nex"}
  let(:basic_labels_regex) {
    File.join nexus_files, "basic_labels_only_regex.nex"}

  let(:basic_labels_and_branches) {
    File.join nexus_files, "basic_labels_and_branches.nex"}
  let(:basic_labels_and_branches_regex) {
    File.join nexus_files, "basic_labels_and_branches_regex.nex"}

  let(:apple_name_map) {
    File.join test_files, "apple.name_map" }
  let(:apple_newick) {
    File.join test_files, "apple.tre" }
  let(:apple_no_color_nexus) {
    File.join nexus_files, "apple.no_color.nexus" }

  let(:z_tre) {
    File.join test_files, "z.tre" }
  let(:z_color_map) {
    File.join test_files, "z.color_map" }
  let(:z_name_map) {
    File.join test_files, "z.name_map" }
  let(:z_nex) {
    File.join nexus_files, "z.nex" }
  let(:z_nex_with_name_map) {
    File.join nexus_files, "z_with_name_map.nex" }

  let(:color_map_override_biom) {
    File.join test_files, "color_map_override.biom" }
  let(:color_map_override_tre) {
    File.join test_files, "color_map_override.tre" }
  let(:color_map_override_nex) {
    File.join nexus_files, "color_map_override.nex" }
  let(:color_map_override_color_map) {
    File.join test_files, "color_map_override.color_map" }
  let(:color_map_override_name_map) {
    File.join test_files, "color_map_override.name_map" }

  let(:color_map_has_entries_not_in_tree_nex) {
    File.join nexus_files, "color_map_has_entries_not_in_tree.nex" }

  let(:single_group_bug_tre) {
    File.join test_files, "single_group_bug.tre" }
  let(:single_group_bug_nex) {
    File.join test_files, "single_group_bug.nex" }
  let(:single_group_bug_color_map) {
    File.join test_files, "single_group_bug.color_map" }
  let(:single_group_bug_biom) {
    File.join test_files, "single_group_bug.biom" }
  let(:single_group_bug_min_lumin) {
    1 }
  let(:single_group_bug_max_lumin) {
    100 }
  let(:single_group_bug_single_group_true) {
    true }

  let(:ambiguous_regex_color_map) {
    File.join test_files, "ambiguous_regex.color_map"
  }

  # Iroki issues
  let(:iroki_issue_2_tree) {
    File.join test_files, "iroki_issues", "issue_6", "tree"
  }
  let(:iroki_issue_2_nexus) {
    File.join test_files, "iroki_issues", "issue_6", "nexus"
  }
  let(:iroki_issue_2_color_map) {
    File.join test_files, "iroki_issues", "issue_6", "color_map"
  }

  let(:iroki_issue_9_tree) {
    File.join test_files, "iroki_issues", "issue_9", "tree"
  }
  let(:iroki_issue_9_color_map) {
    File.join test_files, "iroki_issues", "issue_9", "color_map"
  }

  let(:iroki_issue_15_tree) {
    File.join test_files, "iroki_issues", "issue_15", "tree"
  }
  let(:iroki_issue_15_nexus) {
    File.join test_files, "iroki_issues", "issue_15", "nexus"
  }
  let(:iroki_issue_15_color_map) {
    File.join test_files, "iroki_issues", "issue_15", "color_map"
  }

  let(:iroki_issue_21_color_map) {
    File.join test_files, "iroki_issues", "issue_21", "color_map"
  }
  let(:iroki_issue_21_tree) {
    File.join test_files, "iroki_issues", "issue_21", "tree"
  }
  let(:iroki_issue_21_biom) {
    File.join test_files, "iroki_issues", "issue_21", "biom"
  }


  describe "::iroki_job" do
    it "calls main without needing the output file" do
      # the min and max lumin don't actually affect the output, just
      # here to test that it accepts the opts
      actual_output = Iroki::Main::iroki_job color_branches:   true,
                                             color_taxa_names: true,
                                             exact:            true,
                                             color_map_f:      color_map,
                                             newick_f:         newick,
                                             min_lumin:        min_lumin,
                                             max_lumin:        max_lumin

      expected_output = File.read expected_nexus

      expect(actual_output).to eq expected_output
    end

    it "actually passes the min and max lumin vals to main"
  end

  describe "::main" do
    context "when getting the auto color options" do

      it "raises SystemExit when display-auto-color-options is passed" do
        expect { Iroki::Main::main display_auto_color_options: true }.
          to raise_error SystemExit
      end

      it "prints the kelly color palette"
    end

    context "with renaming" do
      context "no coloring options" do
        it "renames node labels with a name map" do
          # this also tests what happens when (1) names are in the
          # tree but missing from the name map, (2) names are in the
          # name map but not in the tree, (3) illegal characters are
          # used (parentheses and spaces only), (4) tags with hex
          # codes
          Iroki::Main::main name_map_f: apple_name_map,
                            newick_f:   apple_newick,
                            out_f:      output_nexus

          check_output output_nexus, apple_no_color_nexus
        end
      end
    end

    it "is fine when the color map has entries not in the tree" do
      Iroki::Main::main color_branches: true,
                        color_taxa_names: true,
                        exact: true,
                        newick_f: two_group_tre,
                        color_map_f: basic_color_map_with_tags,
                        out_f: output_nexus

      check_output output_nexus, color_map_has_entries_not_in_tree_nex
    end

    it "runs Iroki main program" do
      Iroki::Main::main color_branches:   true,
                        color_taxa_names: true,
                        exact:            true,
                        color_map_f:      color_map,
                        newick_f:         newick,
                        out_f:            output_nexus

      expected_output = File.read expected_nexus
      actual_output   = File.read output_nexus

      expect(actual_output).to eq expected_output

      FileUtils.rm output_nexus
    end

    it "handles a biom file that has more entries than the tree"
    it "handles a biom file that has fewer entries than the tree"
    it "doesn't die if the color gradient radio button is selected with no biom file"
    it "raises AbortIf::Exit if nothing in the color map matches matches the tree"
    it "handles when user uses new and old names in color map"

    context "single group bug" do
      it "doesn't mistake a single group biom for a two group biom" do
        expect { Iroki::Main::main color_branches: true,
                                   color_taxa_names: true,
                                   exact: true,
                                   color_map_f: single_group_bug_color_map,
                                   newick_f: single_group_bug_tre,
                                   biom_f: single_group_bug_biom,
                                   out_f: output_nexus,
                                   min_lumin: 1,
                                   max_lumin: 100,
                                   single_color: true }.not_to raise_error

        expected_output = File.read(single_group_bug_nex)
        actual_output   = File.read output_nexus

        expect(actual_output).to eq expected_output

        FileUtils.rm output_nexus
      end
    end

    it "returns the nexus string when it completes successfully" do
      val = Iroki::Main::main color_branches:   true,
                              color_taxa_names: true,
                              exact:            true,
                              color_map_f:      color_map,
                              newick_f:         newick,
                              out_f:            output_nexus

      expected_output = File.read expected_nexus

      expect(val).to eq expected_output
    end

    context "seanie's issue" do
      it "handles seanie's weird chars" do
        Iroki::Main::main color_branches:   true,
                          color_taxa_names: true,
                          exact:            true,
                          color_map_f:      z_color_map,
                          newick_f:         z_tre,
                          out_f:            output_nexus

        expected_output = File.read z_nex
        actual_output   = File.read output_nexus

        expect(actual_output).to eq expected_output

        FileUtils.rm output_nexus
      end

      context "with name map" do
        # NOTE the name map must not contain the surrounding quotes!
        it "handles seanie's weird chars" do
          Iroki::Main::main color_branches:   true,
                            color_taxa_names: true,
                            exact:            true,
                            color_map_f:      z_color_map,
                            name_map_f:       z_name_map,
                            newick_f:         z_tre,
                            out_f:            output_nexus

          expected_output = File.read z_nex_with_name_map
          actual_output   = File.read output_nexus

          expect(actual_output).to eq expected_output

          FileUtils.rm output_nexus
        end
      end
    end

    it "handles auto colors mixed with specified colors" do
      Iroki::Main::main color_branches:   true,
                        color_taxa_names: true,
                        exact:            true,
                        auto_color:       "kelly",
                        color_map_f:      small_color_map,
                        newick_f:         small_newick,
                        out_f:            output_nexus

      actual_output   = File.read output_nexus
      expected_output = File.read small_nexus

      expect(actual_output).to eq expected_output

      FileUtils.rm output_nexus
    end

    it "handles Jess's bug (RAxML terminal leaf node with no name)" do
      Iroki::Main::main color_branches:   true,
                        color_taxa_names: true,
                        exact:            true,
                        auto_color:       "kelly",
                        color_map_f:      small_color_map,
                        newick_f:         jess_newick,
                        out_f:            output_nexus

      actual_output   = File.read output_nexus
      expected_output = File.read jess_nexus

      expect(actual_output).to eq expected_output

      FileUtils.rm output_nexus
    end

    context "with color gradients" do
      it "handles single sample biom files with single color gradient" do
        Iroki::Main::main color_branches:   true,
                          color_taxa_names: true,
                          exact:            true,
                          biom_f:           single_sample_biom,
                          single_color:     true,
                          newick_f:         single_sample_tre,
                          out_f:            output_nexus,

                          min_lumin: 10, # old default
                          max_lumin: 95  # old default

        actual_output   = File.read output_nexus
        expected_output = File.read single_sample_one_color_nex

        expect(actual_output).to eq expected_output

        FileUtils.rm output_nexus
      end


      it "handles single sample biom files with two color gradient" do
        Iroki::Main::main color_branches:   true,
                          color_taxa_names: true,
                          exact:            true,
                          biom_f:           single_sample_biom,
                          newick_f:         single_sample_tre,
                          out_f:            output_nexus,

                          min_lumin: min_lumin,
                          max_lumin: 97 # the old default

        actual_output   = File.read output_nexus
        expected_output = File.read single_sample_nex

        expect(actual_output).to eq expected_output

        FileUtils.rm output_nexus
      end

      it "handles two group biom files with two color gradient" do
        Iroki::Main::main color_branches:   true,
                          color_taxa_names: true,
                          exact:            true,
                          biom_f:           two_group_biom,
                          newick_f:         two_group_tre,
                          out_f:            output_nexus,

                          min_lumin: min_lumin,
                          max_lumin: max_lumin

        check_output output_nexus, two_group_nex
      end

      context "color gradient with color map and name map" do
        it "uses the color map to override the gradient" do
          # also tests (1) captical letters and lower case letters in
          # color map hex codes, (2) weird symbols in name map
          Iroki::Main::main color_branches:   true,
                            color_taxa_names: true,
                            exact:            true,
                            name_map_f:       color_map_override_name_map,
                            color_map_f:      color_map_override_color_map,
                            biom_f:           color_map_override_biom,
                            newick_f:         color_map_override_tre,
                            out_f:            output_nexus,

                            min_lumin: min_lumin,
                            max_lumin: max_lumin

          check_output output_nexus, color_map_override_nex
        end
      end
    end

    it "handles color map + name map"
    it "handles two group biom file with single single color option"

    context "Testing of command line args with tricky color map" do
      context "exact string matching" do
        it "colors the labels" do
          Iroki::Main::main color_branches: false,
                            color_taxa_names: true,
                            exact: true,
                            newick_f: basic_tre,
                            color_map_f: basic_color_map_with_tags,
                            out_f: output_nexus

          check_output output_nexus, basic_labels
        end

        it "colors the branches" do
          Iroki::Main::main color_branches: true,
                            color_taxa_names: false,
                            exact: true,
                            newick_f: basic_tre,
                            color_map_f: basic_color_map_with_tags,
                            out_f: output_nexus

          check_output output_nexus, basic_branches
        end

        it "colors labels and branches" do
          Iroki::Main::main color_branches: true,
                            color_taxa_names: true,
                            exact: true,
                            newick_f: basic_tre,
                            color_map_f: basic_color_map_with_tags,
                            out_f: output_nexus

          check_output output_nexus, basic_labels_and_branches
        end
      end

      # TODO is this in the tricky context from above? It shouldn't be
      context "regular expression matching" do
        context "with biom file" do

          # https://github.com/mooreryan/iroki_web/issues/4
          it "dies because biom file and regex can't go together" do
            expect { Iroki::Main::main color_branches: true,
                                       exact:          false,
                                       biom_f:         two_group_biom,
                                       newick_f:       two_group_tre,
                                       out_f:          output_nexus
            }.to raise_error AbortIf::Exit
          end
        end

        context "just color map" do
          it "colors the labels" do
            Iroki::Main::main color_branches: false,
                              color_taxa_names: true,
                              exact: false,
                              newick_f: basic_tre,
                              color_map_f: basic_color_map_regex,
                              out_f: output_nexus

            check_output output_nexus, basic_labels_regex
          end

          it "colors the branches" do
            Iroki::Main::main color_branches: true,
                              color_taxa_names: false,
                              exact: false,
                              newick_f: basic_tre,
                              color_map_f: basic_color_map_regex,
                              out_f: output_nexus

            check_output output_nexus, basic_branches_regex
          end

          it "colors labels and branches" do
            Iroki::Main::main color_branches: true,
                              color_taxa_names: true,
                              exact: false,
                              newick_f: basic_tre,
                              color_map_f: basic_color_map_regex,
                              out_f: output_nexus

            check_output output_nexus, basic_labels_and_branches_regex
          end

          it "works with the ^ (match at beginning character) (bug fix)" do
            Iroki::Main::main color_branches: true,
                              color_taxa_names: true,
                              exact: false,
                              newick_f: regex_bug_tre,
                              color_map_f: regex_bug_color_map,
                              out_f: output_nexus

            check_output output_nexus, regex_bug_nexus
          end
        end
      end
    end

    # it "looks good with kelly colors" do
    #   Iroki::Main::main color_branches:   true,
    #                     color_taxa_names: true,
    #                     exact:            true,
    #                     auto_color:       "kelly",
    #                     color_map_f:      kelly_color_map,
    #                     newick_f:         kelly_newick,
    #                     out_f:            kelly_out

    #   actual_output   = File.read kelly_out
    #   expected_output = File.read kelly_nexus

    #   expect(actual_output).to eq expected_output

    #   # FileUtils.rm output_nexus
    # end

    context "bad user input" do
      it "raises Exit when the regex matches more than one node" do
        expect { Iroki::Main::main color_branches:   true,
                                   color_taxa_names: true,
                                   exact:            false,
                                   color_map_f:      ambiguous_regex_color_map,
                                   newick_f:         basic_tre,
                                   out_f:            output_nexus }.
          to raise_error AbortIf::Exit
      end

      it "raises AbortIf::Exit when the auto-color option is invalid" do
        auto_color = "asldkfjaldj"

        expect { Iroki::Main::main color_branches:   true,
                                   color_taxa_names: true,
                                   exact:            true,
                                   auto_color:       auto_color,
                                   color_map_f:      small_color_map,
                                   newick_f:         small_newick,
                                   out_f:            output_nexus }.
          to raise_error AbortIf::Exit

      end

      it "raises AbortIf::Exit when the newick file doesn't exist" do
        expect { Iroki::Main::main color_branches:   true,
                                   color_taxa_names: true,
                                   exact:            true,
                                   auto_color:       "kelly",
                                   color_map_f:      small_color_map,
                                   newick_f:         "sldfjalsdjf",
                                   out_f:            output_nexus }.
          to raise_error AbortIf::Exit
      end

      it "raises AbortIf::Exit when the color file doesn't exist" do
        expect { Iroki::Main::main color_branches:   true,
                                   color_taxa_names: true,
                                   exact:            true,
                                   auto_color:       "kelly",
                                   color_map_f:      "alsdkjf",
                                   newick_f:         small_newick,
                                   out_f:            output_nexus }.
          to raise_error AbortIf::Exit
      end

      it "raises AbortIf::Exit when the newick file is nil" do
        expect { Iroki::Main::main color_branches:   true,
                                   color_taxa_names: true,
                                   exact:            true,
                                   auto_color:       "kelly",
                                   color_map_f:      small_color_map,
                                   newick_f:         nil,
                                   out_f:            output_nexus }.
          to raise_error AbortIf::Exit
      end

      it "raises AbortIf::Exit when only the newick file is given" do
        expect { Iroki::Main::main newick_f: small_newick }.
          to raise_error AbortIf::Exit
      end

      it "raises AbortIf::Exit when only the color map file is given" do
        expect { Iroki::Main::main color_map_f: small_color_map }.
          to raise_error AbortIf::Exit
      end

      it "raises AbortIf::Exit when only the name map file is given" do
        expect { Iroki::Main::main name_map_f: small_color_map }.
          to raise_error AbortIf::Exit
      end

      it "raises AbortIf::Exit when only the biom file is given" do
        expect { Iroki::Main::main biom_f: two_group_biom }.
          to raise_error AbortIf::Exit
      end

      it "raises AbortIf::Exit when given newick, color branches " +
         " and neither a biom file nor a color map file" do
        expect { Iroki::Main::main color_branches: true,
                                   newick_f: small_newick,
                                   out_f: output_nexus }.
          to raise_error AbortIf::Exit
      end

      it "raises AbortIf::Exit when given newick, color labels " +
         " and neither a biom file nor a color map file" do
        expect { Iroki::Main::main color_taxa_names: true,
                                   newick_f: small_newick,
                                   out_f: output_nexus }.
          to raise_error AbortIf::Exit
      end

      it "raises AbortIf::Exit when given no output file" do
        expect { Iroki::Main::main color_branches:   true,
                                   color_taxa_names: true,
                                   exact:            true,
                                   auto_color:       "kelly",
                                   color_map_f:      small_color_map,
                                   newick_f:         small_newick,
                                   out_f:            nil }.
          to raise_error AbortIf::Exit
      end

      it "raises when given biom f but no color options" do
        expect { Iroki::Main::main exact: true,
                                   biom_f: two_group_biom,
                                   newick_f: small_newick,
                                   out_f: output_nexus }.
          to raise_error AbortIf::Exit
      end

      it "raises when given color map but no color options" do
        expect { Iroki::Main::main exact: true,
                                   color_map_f: small_color_map,
                                   newick_f: small_newick,
                                   out_f: output_nexus }.
          to raise_error AbortIf::Exit
      end

      it "raises when given --single-color with no biom file" do
        expect { Iroki::Main::main exact: true,
                                   color_branches: true,
                                   color_taxa_names: true,
                                   color_map_f: small_color_map,
                                   newick_f: small_newick,
                                   out_f: output_nexus,
                                   single_color: true}.
          to raise_error AbortIf::Exit
      end

      it "raises when given single color with two group biom file" do
        expect { Iroki::Main::main exact: true,
                                   color_branches: true,
                                   color_taxa_names: true,
                                   biom_f: two_group_biom,
                                   newick_f: small_newick,
                                   out_f: output_nexus,
                                   single_color: true}.
          to raise_error AbortIf::Exit
      end
    end

    context "Iroki issues" do
      context "issue 6" do
        it "handles the empty branch column" do
          Iroki::Main::main color_branches:   true,
                            color_taxa_names: true,
                            exact:            true,
                            color_map_f:      iroki_issue_2_color_map,
                            newick_f:         iroki_issue_2_tree,
                            out_f:            output_nexus

          expected_output = File.read iroki_issue_2_nexus
          actual_output   = File.read output_nexus

          expect(actual_output).to eq expected_output

          FileUtils.rm output_nexus
        end
      end

      context "issue 9" do
        it "raises error when Newick file isn't valid" do
          expect { Iroki::Main::main exact: true,
                                     color_branches: true,
                                     color_taxa_names: true,
                                     color_map_f: iroki_issue_9_color_map,
                                     newick_f: iroki_issue_9_tree,
                                     out_f: output_nexus}.
            to raise_error AbortIf::Exit

        end
      end

      context "issue 21 -- regex and biom files" do
        it "exits with regex matching and biom file" do
          expect { Iroki::Main::main exact: false,
                                     color_branches: true,
                                     color_taxa_names: true,
                                     color_map_f: iroki_issue_21_color_map,
                                     newick_f: iroki_issue_21_tree,
                                     biom_f: iroki_issue_21_biom,
                                     out_f: output_nexus}.
            to raise_error AbortIf::Exit
        end
      end

      context "issue 15 -- default colors" do
        it "lets the user choose a default color with a color name" do
          Iroki::Main::main color_branches:   true,
                            color_taxa_names: true,
                            exact:            true,
                            color_map_f:      iroki_issue_15_color_map,
                            newick_f:         iroki_issue_15_tree,
                            out_f:            output_nexus,
                            default_color:    "blue"

          expected_output = File.read iroki_issue_15_nexus
          actual_output   = File.read output_nexus

          expect(actual_output).to eq expected_output

          FileUtils.rm output_nexus
        end

        it "lets the user choose a default color with a color name (regex)" do
          Iroki::Main::main color_branches:   true,
                            color_taxa_names: true,
                            color_map_f:      iroki_issue_15_color_map,
                            newick_f:         iroki_issue_15_tree,
                            out_f:            output_nexus,
                            default_color:    "blue"

          expected_output = File.read iroki_issue_15_nexus
          actual_output   = File.read output_nexus

          expect(actual_output).to eq expected_output

          FileUtils.rm output_nexus
        end


        it "lets the user choose a default color with a hex code" do
          Iroki::Main::main color_branches:   true,
                            color_taxa_names: true,
                            exact:            true,
                            color_map_f:      iroki_issue_15_color_map,
                            newick_f:         iroki_issue_15_tree,
                            out_f:            output_nexus,
                            default_color:    "#0000ff"

          expected_output = File.read iroki_issue_15_nexus
          actual_output   = File.read output_nexus

          expect(actual_output).to eq expected_output

          FileUtils.rm output_nexus
        end

        it "raises AbortIf::Exit if hex code is bad" do
          expect {
            Iroki::Main::main color_branches:   true,
                              color_taxa_names: true,
                              exact:            true,
                              color_map_f:      iroki_issue_15_color_map,
                              newick_f:         iroki_issue_15_tree,
                              out_f:            output_nexus,
                              default_color:    "0000ff"}.
            to raise_error AbortIf::Exit
        end

        it "raises AbortIf::Exit if the default color isn't available" do
          expect {
            Iroki::Main::main color_branches:   true,
                              color_taxa_names: true,
                              exact:            true,
                              color_map_f:      iroki_issue_15_color_map,
                              newick_f:         iroki_issue_15_tree,
                              out_f:            output_nexus,
                              default_color:    "arstoien"}.
            to raise_error AbortIf::Exit
        end
      end
    end
  end
end

def check_output actual, expected
  expect(File.read(actual)).to eq File.read(expected)
end
