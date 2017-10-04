class SearchesController < ApplicationController
  before_action :set_search_params
  skip_authorization_check

  def show
    @results = ThinkingSphinx.search @search, classes: [@scope]
    respond_with @results
  end

  private

  def set_search_params
    @search = params[:search]
    @scope  = params[:scope].singularize.constantize unless params[:scope] == 'All'
  end
end
