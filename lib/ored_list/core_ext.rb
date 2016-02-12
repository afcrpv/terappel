Array.class_eval do
  def ored_list(method)
    map(&method).to_sentence(two_words_connector: ' ou ', last_word_connector: ' ou ')
  end
end
