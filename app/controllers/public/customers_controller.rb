class Public::CustomersController < ApplicationController
    before_action :authenticate_customer!
  def show
    @customer = current_customer
  end

  def edit
    @customer = current_customer
  end

  def update
    @customer = current_customer
    if @customer.update(customer_params)
      redirect_to customer_path(current_customer)
    else
      render :edit
    end
  end

  def unsubscribe
  end

  def withdraw
    @customer = current_customer
    @customer.update(is_delete: true)
    reset_session
    flash[:notice] = "退会処理を完了しました"
    redirect_to root_path
  end
  
  private
  
  def customer_params
    params.permit(Customer.attribute_names)
    # params.require(:customer).permit(:last_name, :first_name, :first_name_kana, :last_name_kana, :email, :post_code, :address, :phone_number,:is_delete)
  end
end