# frozen_string_literal: true

require "serverspec"
set :backend, :exec

describe file("/etc/root_password") do
  it { should contain("much-entropy") }
end
