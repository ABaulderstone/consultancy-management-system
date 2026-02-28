class Contracts::CreateContract < ApplicationService
  def initialize(params:)
    @params = params
  end

  def call
    ActiveRecord::Base.transaction do
      contract = Contract.new(@params)

      contract.validate!

      close_existing_contract!(contract.user, contract.start_date)

      contract.save!

      contract
    end
  end

  private

    def close_existing_contract!(user, new_start_date)
      overlapping = Contract.where(user: user)
                        .where("start_date < ? AND (end_date IS NULL OR end_date >= ?)", new_start_date, new_start_date)
                        .first
      return unless overlapping

      overlapping.update!(end_date: new_start_date - 1.day)
    end
end
