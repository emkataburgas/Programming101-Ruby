class TasksController < ApplicationController
	def index
		@lecture = Lecture.find(params[:lecture_id])
		@tasks = @lecture.tasks
	end

	def new
		@lecture = Lecture.find(params[:lecture_id])
		@task = Task.new
	end

	def create
		@lecture = Lecture.find(params[:lecture_id])
		@task = @lecture.tasks.build(task_params)
		if @task.save
		  redirect_to lecture_tasks_path(params[:lecture_id])
    else
			render :new, status: :unprocessable_entity
    end
	end

	def edit
		@lecture = Lecture.find(params[:lecture_id])
		@task = @lecture.tasks.find(params[:id])
	end	

	def update
		@lecture = Lecture.find(params[:lecture_id])
		@task = @lecture.tasks.find(params[:id])
		if @task.update(task_params)
			redirect_to lecture_tasks_path(params[:lecture_id])
		else
			render :new, status: :unprocessable_entity
		end
	end

	def destroy
		@lecture = Lecture.find(params[:lecture_id])
		@task = @lecture.tasks.find(params[:id])
		@task.destroy
		redirect_to lecture_tasks_path
	end

	def show
		@lecture = Lecture.find(params[:lecture_id])
		@task = Task.find(params[:id])
	end

	private

	def task_params
		params.require(:task).permit(:name, :description)
	end
end