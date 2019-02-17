# https://github.com/pry/pry/wiki/Customization-and-configuration

Rails.application.eager_load!

if defined?(PryByebug)
  Pry.commands.alias_command 's', 'step'
  Pry.commands.alias_command 'n', 'next'
  Pry.commands.alias_command 'f', 'finish'
  Pry.commands.alias_command 'c', 'continue'
end

# Save time, don't paginate output
Pry.config.pager = false

