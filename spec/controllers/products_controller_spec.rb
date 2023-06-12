require 'rails_helper'

RSpec.describe ProductsController, type: :controller do
  describe 'GET #index' do
    it 'renders the index template' do
      get :index
      expect(response).to render_template(:index)
    end

    it 'assigns @products with the list of products' do
      products = [{ 'id' => 1, 'name' => 'Product 1', 'price' => 10.0 }]
      allow(HTTParty).to receive(:get).and_return(double(body: products.to_json))
      
      get :index
      expect(assigns(:products)).to eq(products)
    end
  end

  describe 'GET #show' do
    it 'renders the show template' do
      get :show, params: { id: 1 }
      expect(response).to render_template(:show)
    end

    it 'assigns @product with the product details' do
      product = { 'id' => 1, 'name' => 'Product 1', 'price' => 10.0 }
      allow(HTTParty).to receive(:get).and_return(double(body: product.to_json))

      get :show, params: { id: 1 }
      expect(assigns(:product)).to eq(product)
    end
  end

  describe 'DELETE #destroy' do
    it 'redirects to the products index page when product is successfully deleted' do
      allow(HTTParty).to receive(:delete).and_return(double(code: 204))

      delete :destroy, params: { id: 1 }
      expect(response).to redirect_to(products_path)
      expect(flash[:notice]).to eq('Product deleted successfully.')
    end

    it 'redirects to the products index page with an alert when product deletion fails' do
      allow(HTTParty).to receive(:delete).and_return(double(code: 500))

      delete :destroy, params: { id: 1 }
      expect(response).to redirect_to(products_path)
      expect(flash[:alert]).to eq('Failed to delete product.')
    end
  end

  describe 'GET #new' do
    it 'renders the new template' do
      get :new
      expect(response).to render_template(:new)
    end

    it 'assigns an empty @product object' do
      get :new
      expect(assigns(:product)).to eq({})
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'redirects to the products index page with a success flash message' do
        allow(HTTParty).to receive(:post).and_return(double(success?: true))

        post :create, params: { product: { name: 'New Product', price: 10.0 } }
        expect(response).to redirect_to(products_path)
        expect(flash[:success]).to eq('Product created successfully')
      end
    end

    context 'with invalid parameters' do
      it 'renders the new template with an error flash message' do
        post :create, params: { product: { name: '', price: 10.0 } }
        expect(response).to render_template(:new)
        expect(flash[:error]).to eq('Name and Price are required fields.')
      end
    end
  end
end
