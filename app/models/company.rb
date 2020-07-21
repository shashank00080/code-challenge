class Company < ApplicationRecord
  has_rich_text :description
#adding condition for  when  company's zip code is updated then  only city and state should be updated.
  before_save :get_city_and_state, if: :will_save_change_to_zip_code?
  def get_city_and_state
    city_and_state_data = ZipCodes.identified(zip_code)
    
    if city_and_state_data.present?
      self.city = city_and_state_data[:city]
      self.state = city_and_state_data[:state]
    else
      logger.info 'city and state data  not found,pincode is invalid' # logger to log the error
    end
end
