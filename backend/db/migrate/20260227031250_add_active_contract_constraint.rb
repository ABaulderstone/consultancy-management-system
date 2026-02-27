class AddActiveContractConstraint < ActiveRecord::Migration[8.1]
  def change
    add_index :contracts,
          :user_id,
          unique: true,
          where: "end_date IS NULL",
          name: "index_one_active_contract_per_user"
  end
end
