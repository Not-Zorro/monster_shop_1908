class Admin::MerchantsController < Admin::BaseController

  def show
    @merchant = Merchant.find(params[:id])
  end

  def new
  end

  def create
    merchant = Merchant.create(merchant_params)
    if merchant.save
      redirect_to merchants_path
    else
      flash[:error] = merchant.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit
    @merchant = Merchant.find(params[:id])
  end

  def update
    @merchant = Merchant.find(params[:id])
    @merchant.update(merchant_params)
    if @merchant.save
      redirect_to "/merchants/#{@merchant.id}"
    else
      flash[:error] = @merchant.errors.full_messages.to_sentence
      render :edit
    end
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

  def destroy
    Merchant.destroy(params[:id])
    redirect_to '/merchants'
  end

  private

  def merchant_params
    params.permit(:name,:address,:city,:state,:zip)
  end

end
