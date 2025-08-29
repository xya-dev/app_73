defmodule App73.Profile.Command do
  @moduledoc """
  Represents commands for user profile management.
  """

  alias App73.Profile.Command
  @type t :: Command.Create.t()

  defmodule Create do
    @moduledoc """
    Represents a command to create a new user profile.
    """

    @type t() :: %__MODULE__{
            email: String.t(),
            provider: String.t(),
            provider_user_id: String.t()
          }

    defstruct [
      :email,
      :provider,
      :provider_user_id
    ]
  end
end
