if !System.get_env("EXERCISM_TEST_EXAMPLES") do
  Code.load_file("diamond.exs", __DIR__)
end

ExUnit.start()
ExUnit.configure(exclude: :pending, trace: true)

defmodule DiamondTest do
  use ExUnit.Case

  # @tag :pending
  test "letter A" do
    shape = Diamond.build_shape(?A)
    assert shape == "A\n"
  end


  test "letter A should provide the A pattern" do
    seq = Diamond.pattern(?A)
    assert List.to_string(seq) == "A"
  end

  test "letter B should provide the BAB pattern" do
    seq = Diamond.pattern(?B)
    assert List.to_string(seq) == "BAB"
  end

  test "letter C should provide the CBABC pattern" do
    seq = Diamond.pattern(?C)
    assert List.to_string(seq) == "CBABC"
  end

  # @tag :pending
  test "letter C" do
    shape = Diamond.build_shape(?C)

    assert shape == """
           \s A \s
           \sB B\s
           C   C
           \sB B\s
           \s A \s
           """
  end

  # @tag :pending
  test "letter E" do
    shape = Diamond.build_shape(?E)

    assert shape == """
           \s   A   \s
           \s  B B  \s
           \s C   C \s
           \sD     D\s
           E       E
           \sD     D\s
           \s C   C \s
           \s  B B  \s
           \s   A   \s
           """
  end
end
