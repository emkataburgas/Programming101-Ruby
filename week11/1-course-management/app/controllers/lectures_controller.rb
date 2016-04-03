class LecturesController < ApplicationController
  def index
    @lectures = Lecture.all
  end

  def new
    @lecture = Lecture.new
  end

  def create
    @lecture = Lecture.new(lectures_params)
    if @lecture.save
      redirect_to action: 'index'
    else
      redirect_to action: 'new'
    end
  end

  def show
    @lecture = Lecture.find(params[:id])
  end

  def destroy
    @lecture = Lecture.find(params[:id])
    @lecture.destroy
    if @lecture.destroyed?
      redirect_to action: 'index'
    else
      redirect_to action: 'show'
    end
  end

  def edit
    @lecture = Lecture.find(params[:id])
  end

  def update
    @lecture = Lecture.find(params[:id])
    @lecture.name = lectures_params[:name]
    @lecture.text_body = lectures_params[:text_body] 
    if @lecture.save
      redirect_to action: 'index'
    else
      redirect_to action: 'edit'
    end

  end

  private

  def lectures_params
    params.require(:lecture).permit(:name, :text_body)
  end
end