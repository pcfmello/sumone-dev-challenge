class DrinksController < ApplicationController

  def index
    @drinks = Drink.all.order(:created_at).paginate(page: params[:page], per_page: 10)
    @base_ingredient_list = Drink.distinct.pluck(:base_ingredient)
    @origin_list = Drink.distinct.pluck(:origin)
    @drinkware_list = Drink.distinct.pluck(:drinkware)

    respond_to do |format|
      format.html
    end
  end

  def search
    drink_name = params[:drink_name] || ""
    if drink_name.nil? || drink_name.blank?
      @drinks = Drink.all.order(:created_at).paginate(page: params[:page], per_page: 10)
    else 
      @drinks = Drink.where("lower(name) LIKE :query", query: "%#{drink_name.downcase}%").order(:name).paginate(page: params[:page], per_page: 10)
    end
    respond_to do |format|
      format.js
    end
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

    @drinks = Drink.where(query)

    respond_to do |format|
      format.js
    end
  end
end
