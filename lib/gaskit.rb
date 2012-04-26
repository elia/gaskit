require 'bundler'
Bundler.require

module Gaskit
  autoload :App, 'gaskit/app'

  def self.root
    @root ||= Pathname(File.expand_path('../..', __FILE__))
  end

  def self.repo_path
    @root_path ||= root.to_s
  end

  def self.repo_path= path
    @root_path = File.expand_path(path)
  end

  def self.env
    @env ||= ActiveSupport::StringInquirer.new(ENV['RACK_ENV'] || 'development')
  end

  def self.repo
    @repo ||= env.test? ? Grit::Repo.init(Pathname(repo_path).join('testrepo').to_s) : Grit::Repo.new(repo_path.to_s)
  end

  def self.branch
    @branch ||= 'gaskit'
  end

  def self.load_config!
    file = File.expand_path('../../config.yml', __FILE__)
    return false unless File.exist? file

    require 'yaml'
    @config = YAML.load_file(file)
    @config.each_pair do |key, value|
      Gaskit.public_send "#{key}=", value
    end
  end

  class << self
    attr_writer :root_path, :branch

  end
end

Gaskit.load_config!

require 'gaskit/story'
require 'gaskit/user'
