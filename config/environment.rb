require 'active_record'
require "tty-prompt"
require 'sqlite3'
require 'colorize'
require 'tty-pager'
require 'tty-box'
require 'tty-table'
require 'tty-table'
require 'tty-progressbar'
require_relative '../lib/transaction'

# READER = TTY::Reader.new

PROMPT = TTY::Prompt.new(interrupt: :exit, symbols: {radio_on: "x"})
PASTEL = Pastel.new


ActiveRecord::Base.establish_connection(
  'adapter'  => 'sqlite3',
  'database' => 'budget_app_console.sqlite3'
)


