class Admin::MerchantsController < Admin::BaseController

  def show
    @merchant = Merchant.find(params[:id])
  end

  def disable
    merchant = Merchant.find(params[:id])
    merchant.update(active?: false)
    redirect_to '/merchants'
  end

  def enable
    merchant = Merchant.find(params[:id])
    merchant.update(active?: true)
    redirect_to '/merchants'
  end
end
