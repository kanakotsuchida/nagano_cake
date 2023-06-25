class Public::HomesController < ApplicationController

    # default_scope -> {order(created_at: desc)}
  def top
    @items = Item.order('id DESC').limit(4)
  end
end