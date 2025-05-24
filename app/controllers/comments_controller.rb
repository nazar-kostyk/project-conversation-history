class CommentsController < ApplicationController
  before_action :set_project, only: %i[ new create ]
  before_action :set_comment, only: %i[ show edit update destroy ]

  def index
    @comments = Comment.all
  end

  def show
  end

  def new
    @comment = @project.comments.build(user: Current.user)
  end

  def edit
  end

  def create
    @comment = Comment.new(comment_params)

    respond_to do |format|
      if @comment.save
        format.html { redirect_to @comment, notice: "Comment was successfully created." }
        format.json { render :show, status: :created, location: @comment }
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.append(@project, partial: "comments/comment", locals: { comment: @comment }),
            turbo_stream.replace("new_comment_form", partial: "comments/new_comment_button", locals: { project: @project })
          ]
        end
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("new_comment_form", partial: "comments/form", locals: { project: @project, comment: @comment }), status: :unprocessable_entity
        end
      end
    end
  end

  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to @comment, notice: "Comment was successfully updated." }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @comment.destroy!

    respond_to do |format|
      format.html { redirect_to project_comments_path, status: :see_other, notice: "Comment was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_project
    @project = Project.find(params.expect(:project_id))
  end

  def set_comment
    @comment = Comment.find(params.expect(:id))
  end

  def comment_params
    params.expect(comment: [ :body, :project_id, :user_id ])
  end
end
