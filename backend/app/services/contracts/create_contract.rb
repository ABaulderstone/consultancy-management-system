class Contracts::CreateContract
  def self.call(...)
    new(...).call
  end

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
      current = user.current_contract
      return unless current

      current.update!(end_date: new_start_date - 1.day)
    end
end
