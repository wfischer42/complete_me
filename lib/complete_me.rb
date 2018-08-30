require './lib/trie'
require './lib/importer'

class CompleteMe
  attr_reader :tries,
              :default,
              :weight_list,
              :deleted

  def initialize(default = "words")
    @default = default
    @tries = {"words" => Trie.new, "addresses" => Trie.new}
    @weight_list = Hash.new(0)
    @deleted = []
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
    return false if deleted.include?(word)

    if @tries[trie_name]
      @tries[trie_name].include?(word)
    else
     return false
   end
  end

  def count(trie_name: @default)
    lexicon(trie_name: trie_name).size
  end

  def lexicon(trie_name: @default)
    if @tries[trie_name]
      words = @tries[trie_name].lexicon
      words = filter_deletions(words)
    end
  end

  def suggest(snippit, trie_name: @default)
    if @tries[trie_name]
      suggestions = @tries[trie_name].suggest(snippit)
      suggestions = filter_deletions(suggestions)
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

  # Deletions are handled outside the trie object so they can be rolled
  # back easily, and eventually scaled for multiple users
  def delete(word)
    @deleted << word
  end

  def filter_deletions(words)
    @deleted.each do |word|
      words.delete(word)
    end
    return words
  end

  def reset_deletions
    @deleted = []
  end

end
