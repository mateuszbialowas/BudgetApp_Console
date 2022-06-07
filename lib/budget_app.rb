# frozen_string_literal: true

require_relative "BudgetApp_Console/version"
require_relative '../config/environment'
module BudgetAppConsole
  class Error < StandardError; end
  class BudgetApp
    def self.main_banner
      system("clear")
      puts "\n" * 2
      print "               WELCOME TO".light_white.bold.center(TTY::Screen.width)
      puts "\n" * 2
      puts "
            ██████╗░██╗░░░██╗██████╗░░██████╗░███████╗████████╗  ░█████╗░██████╗░██████╗░
            ██╔══██╗██║░░░██║██╔══██╗██╔════╝░██╔════╝╚══██╔══╝  ██╔══██╗██╔══██╗██╔══██╗
            ██████╦╝██║░░░██║██║░░██║██║░░██╗░█████╗░░░░░██║░░░  ███████║██████╔╝██████╔╝
            ██╔══██╗██║░░░██║██║░░██║██║░░╚██╗██╔══╝░░░░░██║░░░  ██╔══██║██╔═══╝░██╔═══╝░
            ██████╦╝╚██████╔╝██████╔╝╚██████╔╝███████╗░░░██║░░░  ██║░░██║██║░░░░░██║░░░░░
            ╚═════╝░░╚═════╝░╚═════╝░░╚═════╝░╚══════╝░░░╚═╝░░░  ╚═╝░░╚═╝╚═╝░░░░░╚═╝░░░░░
                                                                       ".lines.map{ |line| line.strip.center(TTY::Screen.width)}.join("\n").light_white.bold
      puts "\n"
      puts ("\s"*TTY::Screen.width).colorize( :background => :light_white)
      puts "\n"

    end

    def self.main_menu
      Transaction.last_transactions
      puts total_expenditure + " " + total_expenditure_in_this_month + " " + total_expenditure_in_this_week
      puts ("\n"+"\s"*TTY::Screen.width).colorize( :background => :light_white)+"\n"*2
      main_menu = PROMPT.select("Main menu") do |menu|
        menu.choice "Add Transaction", 0
        menu.choice "Delete Transaction", 1
        menu.choice "Edit Transaction", 2
        menu.choice "Show all Transactions", 3
      end

      case main_menu
      when 0
        BudgetAppConsole::BudgetApp.main_banner
        BudgetAppConsole::BudgetApp.add_transaction
      when 1
        delete_transaction
      when 2
        edit_transaction
      when 3
        main_banner
        Transaction.all_transactions
        puts go_to_main_menu_button
        PROMPT.ask("Hit q or Enter to back to main menu")
        go_to_main_menu
      end

    end

    def self.go_to_main_menu
      main_banner
      main_menu
    end

    def self.total_expenditure
      PASTEL.white.on_bright_black.bold" Total expenditure  " + PASTEL.black.on_white.bold(" #{Transaction.sum(:value)} ")
    end

    def self.total_expenditure_in_this_month
      PASTEL.white.on_bright_black.bold" Total expenditure in this month  " + PASTEL.black.on_white.bold(" #{Transaction.all.where('date > ?', Time.now.at_beginning_of_month).sum(:value)} ")
    end
    def self.total_expenditure_in_this_week
      PASTEL.white.on_bright_black.bold" Total expenditure in this week  " + PASTEL.black.on_white.bold(" #{Transaction.all.where('date > ?', Time.now.beginning_of_week).sum(:value)} ")
    end

    def self.go_to_main_menu_button
      PASTEL.bright_yellow.on_bright_black.bold" q " + PASTEL.black.on_bright_yellow.bold("Back to main MENU")
    end
    def self.arrow_to_move
      PASTEL.bright_yellow.on_bright_black.bold" ↑/↓/←/→  " + PASTEL.black.on_bright_yellow.bold("arrow to move")
    end
    def self.space_ctrl
      PASTEL.bright_yellow.on_bright_black.bold" Space/Ctrl+A|R  " + PASTEL.black.on_bright_yellow.bold(" select (all|rev)")
    end
    def self.enter_finish
      PASTEL.bright_yellow.on_bright_black.bold" Enter  " + PASTEL.black.on_bright_yellow.bold(" finish ")
    end
    def self.letter_filter
      PASTEL.bright_yellow.on_bright_black.bold" letters  " + PASTEL.black.on_bright_yellow.bold(" filter ")
    end


    def self.edit_transaction
     unless Transaction.any?
       box = TTY::Box.error "There is no transactions to edit",
                              top: TTY::Screen.height/2-3,
                              left: TTY::Screen.width/2-15,
                              width: 30,
                              height: 6,
                              align: :center
       print box
       sleep(2)
       go_to_main_menu
     end
      selected_transaction_style = Pastel.new.black.on_white.detach
      main_banner
      puts "Edit transaction\n".bold
      puts go_to_main_menu_button + " " + arrow_to_move + " " + space_ctrl + " " + enter_finish

      puts "Select one transaction to edit"
      transactions_h = {}
      transactions = Transaction.all.map do |transaction|
        transactions_h['%-6s|' % transaction.id + '%3s' % "" +
                       '%-18s|' % transaction.name + '%3s' % "" +
                       '%-7s|' % transaction.value + '%3s' % "" +
                       '%-18s|' % transaction.description + '%3s' % "" +
                       '%-18s|' % transaction.date + '%3s' % "" +
                       '%-15s|' % transaction.category + '%3s' % ""
        ] = transaction.id
      end
      puts "--------+---------------------+----------+---------------------+--------------------------+------------------|"
      puts "|  ID   |         Name        |   Value  |     Description     |           Date           |    Category      |"
      puts "--------+---------------------+----------+---------------------+--------------------------+=-----------------|"

      transaction_to_edit = PROMPT.select("",
                                             transactions_h,
                                             per_page: 20,
                                             echo: false,
                                             active_color: selected_transaction_style)
      transaction_to_edit = Transaction.find(transaction_to_edit)

      puts "\n#{PASTEL.bright_yellow.on_bright_black.bold"Type new values or hit enter "}\n"
      name = PROMPT.ask("Name: ", default: transaction_to_edit.name)
      value= PROMPT.ask("Value: ", convert: :float, required: true, default: transaction_to_edit.value) do |q|
        q.messages[:convert?] = "Value must be a number."
      end
      description = PROMPT.ask("Description: ", default: transaction_to_edit.description)
      date = PROMPT.ask("Date: ", convert: :date, default: transaction_to_edit.date.to_date.strftime("%d/%m/%Y"))
      category = PROMPT.ask("Category: ", default: transaction_to_edit.category)

      if transaction_to_edit.update(name: name, value: value, description: description, date: date, category: category)
        box = TTY::Box.success "Transaction edited",
                               top: TTY::Screen.height/2-3,
                               left: TTY::Screen.width/2-15,
                               width: 30,
                               height: 6,
                               align: :center
        print box
        puts ""
        sleep 1.5
      end
      go_to_main_menu

    end

    def self.delete_transaction
      selected_transaction_style = Pastel.new.red.detach
      main_banner
      puts "Delete transaction\n".bold
      puts go_to_main_menu_button + " " + arrow_to_move + " " + space_ctrl + " " + enter_finish + " " + letter_filter

      puts "Select transactions to delete"
      transactions_h = {}
      transactions = Transaction.all.map do |transaction|
        transactions_h['%-6s|' % transaction.id + '%3s' % "" +
                       '%-18s|' % transaction.name + '%3s' % "" +
                       '%-7s|' % transaction.value + '%3s' % "" +
                       '%-18s|' % transaction.description + '%3s' % "" +
                       '%-18s|' % transaction.date + '%3s' % "" +
                       '%-15s|' % transaction.category + '%3s' % ""
        ] = transaction.id
      end
      puts "----------+---------------------+----------+---------------------+--------------------------+------------------|"
      puts "|    ID   |         Name        |   Value  |     Description     |           Date           |    Category      |"
      puts "----------+---------------------+----------+---------------------+--------------------------+------------------|"

      transactions_to_delete = PROMPT.multi_select("",
                                                   transactions_h,
                                                   per_page: 20,
                                                   echo: false,
                                                   active_color: selected_transaction_style,
                                                   filter: true)
      if Transaction.delete(transactions_to_delete) && !transactions_to_delete.blank?
        box = TTY::Box.success "Transactions deleted",
                               top: TTY::Screen.height/2-3,
                               left: TTY::Screen.width/2-15,
                               width: 30,
                               height: 6,
                               align: :center
        print box
        puts ""
        sleep 1.5
      end
      go_to_main_menu
    end

    def self.add_transaction
      puts "Add transaction\n".bold
      puts go_to_main_menu_button + " " + enter_finish + "\n\n"

      name = PROMPT.ask("Name: ", required: true)
      value= PROMPT.ask("Value: ", convert: :float, required: true) do |q|
        q.messages[:convert?] = "Value must be a number."
      end
      category = PROMPT.ask("Category: ", required: true)
      description = PROMPT.ask("Description: ", required: false)
      date = PROMPT.ask("Date: ",default: Time.now.strftime("%d/%m/%Y"), convert: :date, required: true )
      Transaction.create(name: name, description: description, category: category, value: value, date: date)

      box = TTY::Box.success "Transaction added",
                             top: TTY::Screen.height/2-3,
                             left: TTY::Screen.width/2-15,
                             width: 30,
                             height: 6,
                             align: :center
      print box
      puts ""
      sleep 1.5

      BudgetAppConsole::BudgetApp.main_banner
      main_menu
    end
  end
end
