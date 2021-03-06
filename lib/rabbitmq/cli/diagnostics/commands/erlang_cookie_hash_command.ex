## The contents of this file are subject to the Mozilla Public License
## Version 1.1 (the "License"); you may not use this file except in
## compliance with the License. You may obtain a copy of the License
## at https://www.mozilla.org/MPL/
##
## Software distributed under the License is distributed on an "AS IS"
## basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See
## the License for the specific language governing rights and
## limitations under the License.
##
## The Original Code is RabbitMQ.
##
## The Initial Developer of the Original Code is GoPivotal, Inc.
## Copyright (c) 2007-2020 VMware, Inc. or its affiliates.  All rights reserved.

defmodule RabbitMQ.CLI.Diagnostics.Commands.ErlangCookieHashCommand do
  @behaviour RabbitMQ.CLI.CommandBehaviour

  use RabbitMQ.CLI.Core.AcceptsDefaultSwitchesAndTimeout
  use RabbitMQ.CLI.Core.MergesNoDefaults
  use RabbitMQ.CLI.Core.AcceptsNoPositionalArguments

  def run([], %{node: node_name, timeout: timeout}) do
    :rabbit_data_coercion.to_binary(
      :rabbit_misc.rpc_call(node_name, :rabbit_nodes_common, :cookie_hash, [], timeout))
  end

  def output(result, %{formatter: "json"}) do
    {:ok, %{"result" => "ok", "value" => result}}
  end
  def output(result, _options) when is_bitstring(result) do
    {:ok, result}
  end

  def help_section(), do: :configuration

  def description(), do: "Displays a hash of the Erlang cookie (shared secret) used by the target node"

  def usage, do: "erlang_cookie_hash"

  def banner([], %{node: node_name}) do
    "Asking node #{node_name} its Erlang cookie hash..."
  end
end
