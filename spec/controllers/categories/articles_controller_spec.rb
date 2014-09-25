require 'rails_helper'

describe Categories::ArticlesController do
	describe 'GET #index' do
		def do_request
			get :index, category_id: category.id
		end

		let!(:category) { create(:category) }
		let!(:articles) { create_list(:article, 2, category: category) }

		it 'populates an array of articles in the category' do
			do_request
			expect(assigns(:articles).size).to eq 2
		end

		it 'renders the :index view' do
			do_request
			expect(response).to render_template :index
		end
	end

	describe 'GET #show' do
		def do_request
			get :show, { category_id: article.category.id, id: article.id }
		end

		let!(:article) { create(:article) }

		it 'assigns the requested article to @article' do
			do_request
			expect(assigns(:article)).to eq article
		end

		it 'renders the :show view' do
			do_request
			expect(response).to render_template :show
		end
	end

	describe 'GET #new' do
		def do_request
			get :new, category_id: category.id
		end

		let!(:category) { create(:category) }

		it 'renders the :new view' do
			do_request
			expect(response).to render_template :new
		end
	end

	describe 'POST #create' do
		let!(:category) { create(:category) }

		context 'with valid attributes' do
			def do_request
				post :create, { category_id: category.id, article: attributes_for(:article) }
			end

			it 'creates a new article' do
				expect{do_request}.to change(Article, :count).by(1)
			end

			it 'redirects to the homepage' do
				do_request
				expect(response).to redirect_to root_url
			end
		end

		context 'with invalid attributes' do
			def do_request
				post :create, { category_id: category.id, article: attributes_for(:invalid_article) }
			end

			it 'does not save the new article' do
				expect{do_request}.to_not change(Article, :count)
			end

			it 're-renders to the :new view' do
				do_request
				expect(response).to render_template :new
			end
		end
	end
end