# frozen_string_literal: true

require 'gem_config'
require "extend_ruby_sdk/version"
require 'extend_ruby_sdk/client'
require 'extend_ruby_sdk/product'

module ExtendRubySdk
  include GemConfig::Base

  with_configuration do
    has :access_token, classes: String
  end
end
