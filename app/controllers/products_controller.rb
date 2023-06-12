class ProductsController < ApplicationController
    def index
        response = HTTParty.get('http://localhost:3000/products.json')
        @products = JSON.parse(response.body)
      end
    
      def show
        id = params[:id]
        response = HTTParty.get("http://localhost:3000/products/#{id}.json")
        @product = JSON.parse(response.body)
      end

      def destroy
        url = "http://localhost:3000/products/#{params[:id]}"
        response = HTTParty.delete(url)
      
        if response.code == 204
          redirect_to products_path, notice: 'Product deleted successfully.'
        else
          redirect_to products_path, alert: 'Failed to delete product.'
        end
    end

    def new
      @product = {}
    end
    

    def create
      product_params = {
        name: params[:product][:name],
        price: params[:product][:price]
      }
      if product_params[:name].blank? || product_params[:price].blank?
        flash.now[:error] = 'Name and Price are required fields.'
        render :new
      else
        response = HTTParty.post("http://localhost:3000/products.json", body: { product: product_params })

      if response.success?
        flash[:success] = 'Product created successfully'
        redirect_to products_path
      else
        flash.now[:error] = 'Failed to create product'
        render :new
      end
    end
    end    

    def edit
      id = params[:id]
      response = HTTParty.get("http://localhost:3000/products/#{id}.json")
      if response.success?
        @product = JSON.parse(response.body)
      else
        flash.now[:error] = 'Failed to fetch product'
        redirect_to products_path
      end
    rescue StandardError
      flash.now[:error] = 'An error occurred while fetching the product'
      redirect_to products_path    
    end
    

    def update
      id = params[:id]
      product_params = {
        name: params[:product][:name],
        price: params[:product][:price]
      }
      response = HTTParty.patch("http://localhost:3000/products/#{id}.json", body: { product: product_params })
      puts response
      if response.success?
        flash[:success] = 'Product updated successfully'
        redirect_to products_path
      else
        flash.now[:error] = 'Failed to update product'
        render :edit
      end
    end 
end
