# frozen_string_literal: true
require "spec_helper"

describe file("/etc/root_password") do
  it { should contain("much-entropy") }
end
