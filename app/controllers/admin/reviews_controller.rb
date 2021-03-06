class Admin::ReviewsController < Admin::ApplicationController
  before_action :current_paper, if: -> { params.has_key?(:paper_id) }

  def create
    @paper.reviews.create!(user: current_user, reviewed: true)
    @paper.activity.notify("paper_status_changed", @paper)
    redirect_to admin_activity_papers_path(@paper.activity)
    rescue StandardError
      redirect_to admin_activity_papers_path(@paper.activity), alert: "You already reviewed this paper"
  end

  def accept
    @paper.accept!
    @paper.activity.notify("paper_status_changed", @paper)
    redirect_to admin_activity_papers_path(@paper.activity)
    rescue StandardError
      redirect_to admin_activity_papers_path(@paper.activity_id), alert: "發生錯誤"

  end

  def reject
    @paper.reject!
    @paper.activity.notify("paper_status_changed", @paper)
    redirect_to admin_activity_papers_path(@paper.activity)
    rescue StandardError
      redirect_to admin_activity_papers_path(@paper.activity), alert: "發生錯誤"
  end

  protect_from_forgery

  protected
  def current_paper
    @paper = Paper.find_by(uuid: params[:paper_id])
  end
end
