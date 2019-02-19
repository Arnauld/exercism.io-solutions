defmodule BankAccount do
  @moduledoc """
  A bank account that supports access from multiple processes.
  """

  @typedoc """
  An account handle.
  """
  @opaque account :: pid

  defmacro invoke_or(expr, fallback) do
    quote do
      try do
        unquote(expr)
      catch
        :exit, _ -> unquote(fallback)
      end
    end
  end

  @doc """
  Open the bank. Makes the account available.
  """
  @spec open_bank() :: account
  def open_bank() do
    {:ok, pid} = Agent.start_link(fn -> 0 end)
    pid
  end

  @doc """
  Close the bank. Makes the account unavailable.
  """
  @spec close_bank(account) :: none
  def close_bank(account) when is_pid(account) do
    Agent.stop(account)
  end

  @doc """
  Get the account's balance.
  """
  @spec balance(account) :: integer | {:error, :account_closed}
  def balance(account) when is_pid(account) do
    invoke_or(
      Agent.get(account, fn balance -> balance end),
      {:error, :account_closed}
    )
  end

  @doc """
  Update the account's balance by adding the given amount which may be negative.
  """
  @spec update(account, integer) :: any
  def update(account, amount) when is_pid(account) and is_integer(amount) do
    invoke_or(
      Agent.update(account, fn balance -> balance + amount end),
      {:error, :account_closed}
    )
  end
end
