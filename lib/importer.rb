require './lib/text_adapter'
require './lib/csv_adapter'

class Importer
  attr_accessor :adapter

  def initialize(file_name, adapter_type, *args)
    if adapter_type == :text
        @adapter = TextAdapter.new(file_name)
    elsif adapter_type == :csv && args.length == 1
        @adapter = CSVAdapter.new(file_name, args[0])
    end
  end

  def adapter_valid?
    adapter_methods = @adapter.class.instance_methods(false)
    adapter_methods.include?(:array_of_strings)
  end

  def words
    if adapter_valid?
      get_valid_words
    else
      p "Adapter is invalid"
      return nil
    end
  end

  def get_valid_words
    word_list = @adapter.array_of_strings
    if words_valid?(word_list)
      return word_list
    else
      p "Error: #{word_list}"
      return nil
    end
  end

  def words_valid?(word_list)
    return false if word_list.class != Array

    word_list.all? do |word|
      word.class == String
    end
  end
end
