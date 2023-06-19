class Public::CartItemsController < ApplicationController
  before_action :authenticate_customer!
  # devise使用の際に使う(current_customer)
  def index
    @cart_items = current_customer.cart_items
    # @cart_items = CartItem.where(customer:current_customer)
     @total = @cart_items.inject(0) { |sum, item| sum + item.subtotal }
  end

  def update
    @cart_item = CartItem.find(params[:id])
    @cart_item.update(quantity: params[:cart_item][:quantity])
    redirect_to cart_items_path
  end

  def destroy
    @cart_item = CartItem.find(params[:id])
    @cart_item.destroy
    redirect_to cart_items_path
  end

  def all_destroy
    @cart_items = current_customer.cart_items
    @cart_items.destroy_all
    redirect_to cart_items_path
  end

  def create
    @cart_item = CartItem.new(cart_item_params)
    @cart_item.customer_id = current_customer.id
    
     @old_cart_item = CartItem.find_by(item: @cart_item.item )
    if @old_cart_item.present?
      @cart_item.quantity += @old_cart_item.quantity
      @old_cart_item.destroy
    end
      @cart_item.save
      redirect_to cart_items_path
  end
  
  private
  
  def cart_item_params
    params.require(:cart_item).permit(:item_id,:quantity)
  end
  
 end