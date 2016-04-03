class SolutionsController < ApplicationController
	def index
		@lecture = Lecture.find(params[:lecture_id])
		@task = Task.find(params[:task_id])
		@solutions = @task.solutions 
	end

	def new
		@lecture = Lecture.find(params[:lecture_id])
		@task = Task.find(params[:task_id])
		@solution = Solution.new
	end

	def create
		@lecture = Lecture.find(params[:lecture_id])
		@task = Task.find(params[:task_id])
		@solution = @task.solutions.build(solution_params)
		if @solution.save
		  redirect_to lecture_task_solutions_path(params[:lecture_id], params[:task_id])
   	else
			render :new, status: :unprocessable_entity
    end
	end

	def show
		@lecture = Lecture.find(params[:lecture_id])
		@task = Task.find(params[:task_id])
		@solution = Solution.find(params[:id])
	end

	def edit
		@lecture = Lecture.find(params[:lecture_id])
		@task = Task.find(params[:task_id])
		@solution = Solution.find(params[:id])
	end

	def update
		@lecture = Lecture.find(params[:lecture_id])
		@task = Task.find(params[:task_id])
		@solution = @task.solutions.find(params[:id])
		if @solution.update(solution_params)
			redirect_to lecture_task_solutions_path(params[:lecture_id], params[:task_id])
		else
			render :new, status: :unprocessable_entity
		end
	end

	def destroy
		@task = Task.find(params[:task_id])
		@solution = @task.solutions.find(params[:id])
		@solution.destroy
		redirect_to lecture_task_solutions_path
	end

	private

	def solution_params
		params.require(:solution).permit(:text_block)
	end
end