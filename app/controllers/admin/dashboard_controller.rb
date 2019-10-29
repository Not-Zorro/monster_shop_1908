class Admin::DashboardController < Admin::BaseController

  def index
    @sorted_orders = Order.dashboard_sort
  end

end
