module Gaskit
  class Story
    include Toy::Store
    self.include_root_in_json = false

    store :git, Gaskit.repo, :branch => Gaskit.branch, :path => 'stories'

    attribute :description, String
    attribute :type,        String, :default => 'feature'
    attribute :owner_email, String
    attribute :status,      String, :default => 'pending'
    attribute :position,    Float

    def self.count
      contents.length
    end

    def self.all
      contents.map do |entry|
        get(entry.name)
      end.sort_by {|m| m.position || 1 }
    end

    def type
      self[:type]
    end

    def type=(type)
      self[:type] = type
    end

  private

    def self.contents
      head = store.head

      if head && tree = head.commit.tree / store.options[:path]
        tree.contents
      else
        []
      end
    end

  end
end