require 'set'

class WordChain
  attr_reader :steps

  def initialize(start_word, end_word)
    @steps = Hash.new { |hash, key| hash[key] = [] }
    load_steps(start_word.length)
    build_word_chain(start_word, end_word)
  end

  def add_word(word)
    symbol = word.to_sym
    step = word.dup
    (0...word.size).each do |i|
      step[i] = "_"
      @steps[step] << symbol
      step[i] = word[i]
    end
  end

  def load_steps(length)
    File.readlines("dictionary.txt").each do |line|
      word = line.chomp
      if word.length == length
        add_word(word)
      end
    end
  end

  def adjacent_words(word)
    words = Set.new
    step = word.dup
    (0...word.size).each do |i|
      step[i] = "_"
      words += @steps[step]
      step[i] = word[i]
    end
    words.delete(word.to_sym)
  end

  def build_word_chain(start_word, end_word)
    children = Set.new([start_word.to_sym])
    parents = { start_word.to_sym => nil }
    target = end_word.to_sym
    until children.empty?
      steps = Set.new
      children.each do |child|
        adjacent_words(child.to_s).each do |next_step|
          unless parents.has_key?(next_step)
            parents[next_step] = child
            return word_chain(parents, target) if next_step == target
            steps << next_step
          end
        end
      end
      children = steps
    end
    p "no chain"
  end

  def word_chain(parents, target)
    chain = [target]
    chain << target while target = parents[target]
    p chain.reverse
  end

  def inspect

  end

end
