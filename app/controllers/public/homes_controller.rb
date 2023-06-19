class Public::HomesController < ApplicationController
  def top
    # default_scope -> {order(created_at: desc)}
    @genres = Genre.all
    @items = Item.last(4)
  end

  def about
  end
end
