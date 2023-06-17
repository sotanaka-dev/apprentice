class ArticlesController < ApplicationController
  before_action :authenticate_request, except: [:show]
  before_action :set_article_by_slug, except: [:create]

  def create
    slug = generate_unique_slug(article_params[:title], @current_user.username)

    if Article.exists?(slug:)
      render json: { error: 'Slug already exists' }, status: :unprocessable_entity
      return
    end

    new_article = Article.new(article_params.merge(user_id: @current_user.id, slug:))

    if new_article.save
      render json: { article: new_article.as_json_response(@current_user) }, status: :created
    else
      render json: { errors: new_article.errors }, status: :unprocessable_entity
    end
  end

  def show
    author = User.find(@article.user_id)
    render json: { article: @article.as_json_response(author) }, status: :ok
  end

  def update
    @article.assign_attributes(article_params)

    if @article.will_save_change_to_title?
      new_slug = generate_unique_slug(@article.title, @current_user.username)

      if Article.exists?(slug: new_slug)
        render json: { error: 'Slug already exists' }, status: :unprocessable_entity
        return
      end

      @article.slug = new_slug
    end

    if @article.save
      render json: { article: @article.as_json_response(@current_user) }, status: :ok
    else
      render json: { errors: @article.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    if @article.destroy
      render json: {}, status: :no_content
    else
      render json: { error: 'Failed to delete article' }, status: :unprocessable_entity
    end
  end

  private

  def article_params
    params.require(:article).permit(:title, :description, :body)
  end

  def set_article_by_slug
    @article = Article.find_by(slug: params[:slug])
    render json: { error: 'Article not found' }, status: :not_found unless @article
  end

  def generate_unique_slug(title, user_name)
    "#{title}-#{user_name}".parameterize
  end
end
