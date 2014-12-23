class ReportsController < ApplicationController
  before_filter :authenticate_user!

  def create
    @user = current_user
    @obj = params[:report][:reportable_type].constantize.find(params[:report][:reportable_id])
    confirmation = 'Your report has been sent. Thanks for letting us know!'
    respond_to do |format|
      if @user.reports.create(report_params)
        format.html { redirect_to @obj, notice: confirmation }
        format.js
      else
        format.html { redirect_to @obj, flash: { alert: confirmation } }
        format.js
      end
    end
  end

  private

    def report_params
      params.require(:report).permit(:reportable_id, :reportable_type, :reason, :body)
    end
end
