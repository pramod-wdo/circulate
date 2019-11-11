require "test_helper"

class PotentialVolunteersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:admin)
    sign_in @user
  end

  test "displays index" do
    5.times do
      create(:member, volunteer_interest: true)
    end

    create(:member, preferred_name: "Too Busy", volunteer_interest: false)

    get admin_potential_volunteers_url
    assert_response :success

    assert_select "table tbody" do
      assert_select "tr", 5
    end

    assert_select "Too Busy", false
  end

  test "downloads a csv" do
    5.times do
      create(:member, volunteer_interest: true)
    end

    create(:member, preferred_name: "Too Busy", volunteer_interest: false)

    get admin_potential_volunteers_url(format: "csv")
    assert_response :success

    assert_equal 6, response.body.lines.size
    assert_equal "text/csv", response.content_type
    assert_includes response.headers["Content-Disposition"], "attachment"
  end
end