# frozen_string_literal: true

require_relative "parse_opts_utils/version"
require_relative "parse_opts_utils/main"

module ParseOptsUtils
  class Error < StandardError; end
  include POU
end
