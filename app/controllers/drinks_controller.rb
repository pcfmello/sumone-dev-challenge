class DrinksController < ApplicationController

  def index
    @drinks = Drink.all.order(:created_at).paginate(page: params[:page], per_page: 10)
    @base_ingredient_list = Drink.distinct.pluck(:base_ingredient)
    @origin_list = Drink.distinct.pluck(:origin)
    @drinkware_list = Drink.distinct.pluck(:drinkware)
  end

  def recommend
    query = {}
    if !params[:base_ingredient].blank?
      query[:base_ingredient] = params[:base_ingredient]
    end
    if !params[:origin].blank?
      query[:origin] = params[:origin]
    end
    if !params[:drinkware].blank?
      query[:drinkware] = params[:drinkware]
    end

    @drinks_found = Drink.where(query)

    respond_to do |format|
      format.js
    end
  end
end
