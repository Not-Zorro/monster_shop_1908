class Admin::MerchantsController < Admin::BaseController

  def show
    @merchant = Merchant.find(params[:id])
  end

  def disable
    merchant = Merchant.find(params[:id])
    merchant.update(active?: false)
    merchant.items.update_all(active?: false)
    flash[:success] = "#{merchant.name} has been disabled"
    redirect_to '/merchants'
    # binding.pry
  end

  def enable
    merchant = Merchant.find(params[:id])
    merchant.update(active?: true)
    merchant.items.update_all(active?: true)
    flash[:success] = "#{merchant.name} has been enabled"
    redirect_to '/merchants'
  end
end
