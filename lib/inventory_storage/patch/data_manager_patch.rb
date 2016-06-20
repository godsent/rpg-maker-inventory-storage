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
