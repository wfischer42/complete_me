require './lib/trie'
require './lib/importer'

class CompleteMe
  attr_reader :tries,
              :default,
              :weight_list

  def initialize(default = "words")

    @default = default
    @tries = {"words" => Trie.new, "addresses" => Trie.new}
    @weight_list = Hash.new(0)
  end

  def add_trie(new_trie)
    @tries[new_trie] = Trie.new
  end

  def default=(new_default)
    if @tries[new_default]
      @default = new_default
    end
  end

  def populate(filename = nil, csv_header: nil, trie_name: @default)
    importer = Importer.new(filename, csv_header: csv_header)
    words = importer.words
    if @tries[trie_name]
      trie = @tries[trie_name]
      words.each do |word|
        trie.insert(word)
      end
    end
  end

  def insert(word, trie_name: @default)
    if @tries[trie_name]
      @tries[trie_name].insert(word)
    end
  end

  def include?(word, trie_name: @default)
    if @tries[trie_name]
      @tries[trie_name].include?(word)
    else
     return false
   end
  end

  def count(trie_name: @default)
    if @tries[trie_name]
      @tries[trie_name].count
    end
  end

  def lexicon(trie_name: @default)
    if @tries[trie_name]
      @tries[trie_name].lexicon
    end
  end

  def suggest(snippit, trie_name: @default)
    if @tries[trie_name]
      suggestions = @tries[trie_name].suggest(snippit)
      sort_suggestions(snippit, suggestions)
    end
  end

  def select(snippit, selection)
    key = [snippit, selection]
    @weight_list[key] += 1
  end

  def sort_suggestions(snippit, suggestions)
    suggestions.sort_by do |suggestion|
      key = [snippit, suggestion]
      @weight_list[key] * -1
    end
  end

end
