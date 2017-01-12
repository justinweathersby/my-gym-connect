class StaticPagesController < ApplicationController

  def index
    render layout: "landing_page"
  end

  def terms
  end
end
