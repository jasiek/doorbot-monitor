require 'json'

class CardDB
  def initialize(file)
    @json = JSON.parse(File.read(file))
    @cards_to_id_index = @json.inject({}) do |h, entry|
      entry['cards'].each do |card|
        h[card] = entry['id'].to_i
      end
      h
    end
    @id_to_nick_index = @json.inject({}) do |h, entry|
      h[entry['id'].to_i] = entry['nick']
      h
    end
  end

  def nick_for_card(card)
    @id_to_nick_index[@cards_to_id_index[card]]
  end

  def cards_by_id
    @cards_by_id_index ||=
      begin
        @json.inject({}) do |h, entry|
          h[entry['id']] = entry['cards']
          h
        end
      end
  end

  def nick_for_id(id)
    @id_to_nick_index[id]
  end

  def id_for_card(card)
    @cards_to_id_index[card]
  end
end
