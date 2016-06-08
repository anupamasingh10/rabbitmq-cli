## The contents of this file are subject to the Mozilla Public License
## Version 1.1 (the "License"); you may not use this file except in
## compliance with the License. You may obtain a copy of the License
## at http://www.mozilla.org/MPL/
##
## Software distributed under the License is distributed on an "AS IS"
## basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See
## the License for the specific language governing rights and
## limitations under the License.
##
## The Original Code is RabbitMQ.
##
## The Initial Developer of the Original Code is GoPivotal, Inc.
## Copyright (c) 2007-2016 Pivotal Software, Inc.  All rights reserved.


defmodule EnvironmentCommandTest do
  use ExUnit.Case, async: false
  import TestHelper

  @command EnvironmentCommand

  setup_all do
    RabbitMQCtl.start_distribution()
    :net_kernel.connect_node(get_rabbit_hostname)

    on_exit([], fn ->
      :erlang.disconnect_node(get_rabbit_hostname)
      :net_kernel.stop()
    end)

    :ok
  end

  setup do
    {:ok, opts: %{node: get_rabbit_hostname}}
  end

  test "validate: argument count validates" do
    assert @command.validate([], %{}) == :ok 
    assert @command.validate(["extra"], %{}) == {:validation_failure, :too_many_args}
  end

  @tag target: get_rabbit_hostname
  test "run: environment request on a named, active RMQ node is successful", context do
    assert @command.run([], context[:opts])[:kernel] != nil
    assert @command.run([], context[:opts])[:rabbit] != nil
  end

  test "run: environment request on nonexistent RabbitMQ node returns nodedown" do
    target = :jake@thedog
    :net_kernel.connect_node(target)
    opts = %{node: target}

    assert @command.run([], opts) == {:badrpc, :nodedown}
  end

  test "banner", context do
    assert @command.banner([], context[:opts])
      =~ ~r/Application environment of node #{get_rabbit_hostname}/
  end
end
