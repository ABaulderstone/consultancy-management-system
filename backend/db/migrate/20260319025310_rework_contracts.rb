class ReworkContracts < ActiveRecord::Migration[8.1]
  def change

    remove_column :contracts, :title


    rename_column :contracts, :salary, :rate

    add_column :contracts, :contract_type, :integer, null: false, default: 0
    add_column :contracts, :fte, :decimal, precision: 4, scale: 2
    add_reference :contracts, :position, null: false, foreign_key: { on_delete: :restrict }
  end
end
