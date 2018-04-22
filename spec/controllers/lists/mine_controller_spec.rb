require 'rails_helper'
require "devise_support"

RSpec.describe Lists::MineController, type: :controller do
  include DeviseSupport

  describe '#index' do
    context 'when user is logged' do
      render_views

      let(:user) { FactoryBot.create(:user)}
      before(:each) { login(user) }

      it 'gives http status 200' do
        get :index
        expect(response).to have_http_status(200)
      end

      it 'list only lists of user logged' do
        another_user = FactoryBot.create(:user)

        list_1 = FactoryBot.create(:list, name: "List 1 - Another User", user: another_user)
        list_2 = FactoryBot.create(:list, name: "List 2 - Logged User", user: user)
        list_3 = FactoryBot.create(:list, name: "List 3 - Logged User", user: user)
        list_4 = FactoryBot.create(:list, name: "List 4 - Another User", user: another_user)

        get :index

        expect(response.body).to_not include(list_1.name)
        expect(response.body).to include(list_2.name)
        expect(response.body).to include(list_3.name)
        expect(response.body).to_not include(list_4.name)
      end
    end

    context 'when user not logged' do
      it 'gives http status 401 ' do
        get :index
        expect(response).to redirect_to("/users/sign_in")
      end
    end
  end
end
