require 'spec_helper'

RSpec.describe ReportsController, :type => :controller do

  before :each do
    @buddha = create :user
    @ananda = create :user, username: 'ananda'
    @sit = create :sit, user: @buddha
    @report = build :report, user: @ananda, reportable_id: @sit.id, reportable_type: @sit.class.to_s
    sign_in :user, @ananda
  end

  describe "POST create" do
    it "creates a report" do
      expect(Report.count).to eq 0
      post :create, report: @report.as_json(only: [:reportable_id, :reportable_type, :user_id, :reason, :body])
      expect(response).to have_http_status(:redirect)
      expect(Report.count).to eq 1
      expect(@buddha.reports.count).to eq 0
      expect(@ananda.reports.count).to eq 1
      expect(@sit.reports.count).to eq 1
    end
  end

end
