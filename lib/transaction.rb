class Transaction < ActiveRecord::Base

  def self.last_transactions
    header = %w[ID Name Value Description Date Category]
    rows = []
    Transaction.all.order('id DESC').first(10).each do |i|
      rows << [i.id, i.name, i.value, i.description, i.date, i.category]
    end

    table = TTY::Table.new(header, rows)
    puts "Last 10 transactions"
    puts table.render(:unicode, resize: :true)

  end

  def self.all_transactions
    header = %w[ID Name Value Description Date Category]
    rows = []
    Transaction.all.each do |i|
      rows << [i.id, i.name, i.value, i.description, i.date, i.category]
    end

    table = TTY::Table.new(header, rows)
    puts table.render(:unicode, resize: :true)

  end

end