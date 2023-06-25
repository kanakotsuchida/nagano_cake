class Admin::OrdersController < ApplicationControlle
  def show
    @order = Order.find(params[:id])
    @customer = @order.customer
  end
end