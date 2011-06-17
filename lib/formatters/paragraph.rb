
class Paragraph

  def initialize
    # An array of sentences (strings) and links
    @paragraph = []
  end

  def add_link description, link
    @paragraph << {:link => [description, link]}
  end

  def add_sentence sentence
    @paragraph << {:sentence => sentence}
  end

  def get_paragraph
    @paragraph
  end
end