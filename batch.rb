#Author Iren_Rin
#How to use
# 1) Store current inventory with InventoryStorage.store(UNIQUE_KEY)
# where UNIQUE_KEY is unique number, string or symbol
# 2) If needed clear currrent inventory with $game_party.clear_inventory
# 3) Load saved inventory with InventoryStorage.restore(UNIQUE_KEY)
# where UNIQUE_KEY is key that was used to save the inventory

module InventoryStorage
  class << self
    def store(key)
      inventories[key] = keys.each_with_object({}) do |key, result|
        result[key] = $game_party.instance_variable_get("@#{key}")
      end
    end

    def restore(key)
      if inventory = inventories[key]
        keys.each do |key|
          $game_party.instance_variable_set "@#{key}", inventory[key]
        end
      end
    end

    def load_saved_data(saved)
      @inventories = saved
    end

    def data_to_save
      inventories
    end

    private

    def keys
      %w(items weapons armors gold)
    end

    def inventories
      @inventories ||= {}
    end
  end
end

#gems/inventory_storage/lib/inventory_storage/patch.rb
module InventoryStorage::Patch
end

#gems/inventory_storage/lib/inventory_storage/patch/game_party_patch.rb
class Game_Party
  def clear_inventory
    init_all_items
    @gold = 0
  end
end
#gems/inventory_storage/lib/inventory_storage/patch/data_manager_patch.rb
module DataManager
  instance_eval do
    alias make_save_contents_for_inventory_storage make_save_contents
    def make_save_contents
      make_save_contents_for_inventory_storage.tap do |contents|
        contents[:inventory_storage] = InventoryStorage.data_to_save
      end
    end

    alias extract_save_contents_for_inventory_storage extract_save_contents
    def extract_save_contents(contents)
      extract_save_contents_for_inventory_storage contents
      InventoryStorage.load_saved_data contents[:inventory_storage]
    end
  end
end
