class Admin::ProductsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_product, only: [:edit, :update, :destroy]
  before_action :authenticate_admin!

  def index 
    @products = Product.all
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to admin_products_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @product.update(product_params)
      redirect_to admin_products_path
    else
      render :edit
    end
  end

  def destroy
    @product.destroy
    redirect_to admin_products_path
  end

  private
    def set_product
      @product = Product.find_by(id: params[:id])
    end

    def product_params
      params.require(:product).permit(:name, :image, :description, :price, :quantity)
    end
end
