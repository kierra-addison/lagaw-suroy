class DestinationsController < ApplicationController
  def new
    @tag_id = session[:for_id] # for cancel redirection
    @tag_title = session[:for_tag_title] # views Tag title
    @tag_description = session[:for_tag_description] # views Tag description
    @destination = Destination.new
  end
  
  def create
    @tag_id = session[:for_id] # for cancel redirection
    @tag_title = session[:for_tag_title] # views Tag title
    @tag_description = session[:for_tag_description] # views Tag description
    @destination = Destination.new(destination_params)
    @destination.tag_id = @tag_id
    
    if @destination.save
      flash[:notice] = "New blog successfully added"
      redirect_to tag_path(id: @destination.tag_id)
    else
      render 'new'
    end
  end
  
  private
    def destination_params
      params.require(:destination).permit(:tag_id, :blog_title, :blog_body)
    end
end
