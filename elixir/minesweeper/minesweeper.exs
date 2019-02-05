defmodule Minesweeper do
  @doc """
  Annotate empty spots next to mines with the number of mines next to them.
  """
  @spec annotate([String.t()]) :: [String.t()]

  @neighbors [{-1,-1}, {-1,0}, {-1,+1}, {0,-1}, {0,+1}, {+1,-1}, {+1,0}, {+1,+1}]

  def annotate([]), do: []
  def annotate(board) do
  	mines = collect_mine_positions(board, 1, MapSet.new())
  	{sx,sy} = size_of(board)
  	for y <- Enum.to_list(1..sy) do
	  	row = for x <- Enum.to_list(1..sx), do:	
  				cell_at(mines, x, y)
  		Enum.join(row, "")
  	end
  end

  defp cell_at(mines, x, y) do
  	mine? = MapSet.member?(mines, {x,y})
  	case mine? do
  		true -> "*"
  		false -> 
  			mines_around = Enum.filter(@neighbors, 
  				fn {dx,dy} -> 
  					MapSet.member?(mines, {x+dx,y+dy})
  				end)
  			case Enum.count(mines_around) do
  				0 -> " "
  				x -> "#{x}"
  			end
  	end
  end

  defp size_of([]), do: {0, 0}
  defp size_of(t = [row|_]), do: {String.length(row), length(t)}

  defp collect_mine_positions([], _, acc), do: acc
  defp collect_mine_positions([row|others], row_num, acc) do
  	new_acc = collect_mine_positions(String.to_charlist(row), row_num, 1, acc)
  	collect_mine_positions(others, row_num+1, new_acc)
  end
  defp collect_mine_positions([], _, _, acc), do: acc
  defp collect_mine_positions([?*|others], row_num, col_num, acc) do
  	collect_mine_positions(others, row_num, col_num+1, MapSet.put(acc, {col_num, row_num}))
  end
  defp collect_mine_positions([_|others], row_num, col_num, acc) do
  	collect_mine_positions(others, row_num, col_num+1, acc)
  end
  
end
