require 'test_helper'

module Byebug
  #
  # Tests for continue command
  #
  class ContinueTestCase < TestCase
    def program
      strip_line_numbers <<-EOC
         1:  module Byebug
         2:    #
         3:    # Toy class to test continue command.
         4:    #
         5:    class #{example_class}
         6:      def add_four(num)
         7:        num + 4
         8:      end
         9:    end
        10:
        11:    byebug
        12:
        13:    b = 5
        14:    c = b + 5
        15:    #{example_class}.new.add_four(c)
        16:  end
      EOC
    end

    def test_continues_up_to_breakpoint_if_no_line_specified
      enter 'break 14', 'continue'

      debug_code(program) { assert_equal 14, frame.line }
    end

    def test_works_in_abbreviated_mode_too
      enter 'break 14', 'cont'

      debug_code(program) { assert_equal 14, frame.line }
    end

    def test_continues_up_to_the_specified_line
      enter 'cont 14'

      debug_code(program) { assert_equal 14, frame.line }
    end

    def test_ignores_the_command_if_specified_line_is_not_valid
      enter 'cont 100'

      debug_code(program) { assert_equal 13, frame.line }
    end

    def test_shows_error_if_specified_line_is_not_valid
      enter 'cont 100'
      debug_code(program)

      check_error_includes 'Line 100 is not a valid stopping point in file'
    end
  end
end
