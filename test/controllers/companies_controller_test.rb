require "test_helper"
require "application_system_test_case"

class CompaniesControllerTest < ApplicationSystemTestCase

  def setup
    @company = companies(:hometown_painting)
  end

  test "Index" do
    visit companies_path

    assert_text "Companies"
    assert_text "Hometown Painting"
    assert_text "Wolf Painting"
  end

  test "Show" do
    visit company_path(@company)

    assert_text @company.name
    assert_text @company.phone
    assert_text @company.email
    assert_text "City, State"
  end

  test "Update" do
    visit edit_company_path(@company)

    within("form#edit_company_#{@company.id}") do
      fill_in("company_name", with: "Updated Test Company")
      fill_in("company_zip_code", with: "93009")
      click_button "Update Company"
    end

    assert_text "Changes Saved"

    @company.reload
    assert_equal "Updated Test Company", @company.name
    assert_equal "93009", @company.zip_code
  end

  test "Destroy" do
    visit company_path(@company)

    check_company_count = Company.count
    accept_alert do
      click_link('Delete')
    end

    assert_text "Deleted"
    assert_equal check_company_count - 1, Company.count
  end

  test "Valid Company Email" do
    visit new_company_path

    within("form#new_company") do
      fill_in("company_name", with: "New Tester Company")
      fill_in("company_zip_code", with: "28173")
      fill_in("company_phone", with: "5553335555")
      fill_in("company_email", with: "new_test_company@getmainstreet.com")
      click_button "Create Company"
    end
  end

  test "Create" do
    visit new_company_path

    within("form#new_company") do
      fill_in("company_name", with: "New Test Company")
      fill_in("company_zip_code", with: "28173")
      fill_in("company_phone", with: "5553335555")
      fill_in("company_email", with: "new_test_company@test.com")
      click_button "Create Company"
    end

    assert_text "Saved"

    last_company = Company.last
    get_state_and_city = ZipCodes.identify('60008')
    assert_equal "New Test Company", last_company.name
    assert_equal "60008", last_company.zip_code
    assert_equal get_state_and_city[:city], last_company.city
    assert_equal get_state_and_city[:city], last_company.state_name
  end

end
