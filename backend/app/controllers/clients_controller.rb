class ClientsController < ApplicationController
  before_action :only_admin!

  def index
    clients = Client.with_job_stats.order("clients.name asc")
    paginated_response(clients, EnrichedClientBlueprint)
  end

  def simple
    clients = Client.order(name: :asc).select(:id, :name)
    render json: ClientBlueprint.render(clients)
  end
end