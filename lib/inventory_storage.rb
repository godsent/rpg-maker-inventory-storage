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

require 'inventory_storage/patch'
