module Polls::Patches::Models
  module UserPatch
    def self.included(base)
      base.class_eval do
        has_many :polls
        has_many :answers
      end
    end
  end
end