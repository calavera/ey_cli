module EYCli
  module Command
    class Console < Base
      include EYCli
      require 'irb'

      def invoke
        ARGV.clear
        IRB.setup(nil)
        @irb = IRB::Irb.new(nil)
        IRB.conf[:MAIN_CONTEXT] = @irb.context
        IRB.conf[:PROMPT][:EY_CLI] = IRB.conf[:PROMPT][:SIMPLE].dup
        IRB.conf[:PROMPT][:EY_CLI][:RETURN] = "%s\n"
        @irb.context.prompt_mode = :EY_CLI
        @irb.context.workspace = IRB::WorkSpace.new(binding)
        term.say('Welcome to ey_cli interactive!')

        catch(:IRB_EXIT) { @irb.eval_input }
      end

      def help
        <<-EOF

Usage: ey_cli console
Note: starts an interactive session.
EOF
      end

      def term
        EYCli.term
      end

      def api
        EYCli.api
      end
    end
  end
end
