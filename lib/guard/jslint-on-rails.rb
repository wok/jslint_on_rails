require 'guard'
require 'guard/guard'
require 'guard/notifier'
require 'jslint'

module Guard
  class JslintOnRails < Guard
    VERSION = '0.2.0'

    def initialize(watchers=[], options={})
      super
      @config_path = File.join(Dir.pwd, options[:config_path] || 'config/jslint.yml')
    end

    def start
      UI.info "Guard::JsLintOnRails started using config: #{@config_path}"
    end

    def run_on_change(paths)
      error = nil
      begin
        lint = ::JSLint::Lint.new(
          :paths => paths,
          :config_path => @config_path 
        )
        lint.run
      rescue ::JSLint::LintCheckFailure => e
        error = e
      end
      Notifier.notify((error ? 'failed' : 'passed'), :title => 'JSLint results', :image => (error ? :failed : :success))
      true
    end
  end
end
