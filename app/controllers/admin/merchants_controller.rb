class Admin::MerchantsController < Admin::BaseController

  def show
    @merchant = Merchant.find(params[:id])
  end

  def disable
    merchant = Merchant.find(params[:id])
    merchant.update(active?: false)
    flash[:success] = "#{merchant.name} has been disabled"
    redirect_to '/merchants'
  end

  def enable
    merchant = Merchant.find(params[:id])
    merchant.update(active?: true)
    flash[:success] = "#{merchant.name} has been enabled"
    redirect_to '/merchants'
  end
end
