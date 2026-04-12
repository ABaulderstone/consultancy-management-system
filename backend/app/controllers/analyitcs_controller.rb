class AnalyticsController < ApplicationController
  before_action :only_admin!

  def profit_summary
    render json: Analytics::ProfitSummary.call(period: parse_period)
  end

  private

  def parse_period
    if params[:month].present?
      date = Date.strptime(params[:month], "%Y-%m") rescue nil
      raise InvalidParamsError, "Invalid month format. Use YYYY-MM." unless date
      { month: date }
    elsif params[:year].present?
      date = Date.strptime(params[:year], "%Y") rescue nil
      raise InvalidParamsError, "Invalid year format. Use YYYY." unless date
      { year: date }
    else
      { month: Date.today }
    end
  end
end