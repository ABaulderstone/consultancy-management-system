class ApplicationController < ActionController::API
  include ActionController::Cookies
  include ActionController::RequestForgeryProtection
  include Pagy::Method
  include Authentication
  include Authorization
  include ErrorHandling

# TODO - reintroduce CSRF
# protect_from_forgery with: :exception

private
  def paginated_response(scope, blueprint)
    per_page = params.fetch(:limit, 20).to_i.clamp(1, 100)
    pagy, records = pagy(scope, limit: per_page)
    pagy_data = pagy.data_hash(data_keys: %i[page limit pages count previous next])
    render json: {
      data: blueprint.render_as_hash(records),
      meta: pagy_data.slice(:page, :limit, :pages, :count),
      links: { next: pagy_data[:next], prev: pagy_data[:previous] }
    }
  end
end
