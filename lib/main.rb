require_relative '../lib/budget_app'
require_relative '../lib/transaction'

PROMPT.on(:keypress) do |event|
  if event.value == "q"
    BudgetAppConsole::BudgetApp.go_to_main_menu
  elsif event.value == "Q"
    exit
  end
end

BudgetAppConsole::BudgetApp.main_banner

BudgetAppConsole::BudgetApp.main_menu

