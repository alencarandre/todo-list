require 'rails_helper'
require "devise_support"

RSpec.describe ListsController, type: :controller do
  include DeviseSupport

  describe '#create' do
    context 'when user is logged' do
      let(:user) { FactoryBot.create(:user) }

      before(:each) { login(user) }

      it 'assign logged user' do
        post(:create,
              format: :js,
              params: { list: { name: 'List 1', access_type: :shared } })

        expect(response).to have_http_status(200)

        list = List.by_user(user).first

        expect(list.name).to eq("List 1")
        expect(list.user.id).to eq(user.id)
        expect(list.access_type).to eq("shared")
      end
    end

    context 'when user is not logged' do
      subject do
        post(:create,
            format: :js,
            params: { list: { name: 'List 1', access_type: :shared } })
      end

      it 'gives redirect to sign_in page' do
        expect(subject).to have_http_status(401)
      end
    end
  end

  describe '#update' do
    let(:user) { FactoryBot.create(:user) }

    context 'when user is logged' do
      before(:each) { login(user) }

      it 'assign logged user' do
        list = FactoryBot.create(:list, user: user, name: "List 1", access_type: :shared )

        params = {
          id: list.id,
          list: { name: 'List 1 (edited)', access_type: :personal }
        }
        put(:update, format: :js, params: params)

        expect(response).to have_http_status(200)

        list = List.by_user(user).first

        expect(list.name).to eq('List 1 (edited)')
        expect(list.access_type.to_sym).to eq(:personal)
        expect(list.user.id).to eq(user.id)
      end

      it 'when try update list from another user, gives record not found' do
        another_user = FactoryBot.create(:user)

        list_1 = FactoryBot.create(:list, user: user, name: "List 1", access_type: :shared )
        list_2 = FactoryBot.create(:list, user: another_user, name: "List 1", access_type: :shared )

        params = {
          id: list_2.id,
          list: { name: 'List 2 (edited)', access_type: :personal }
        }
        expect {
          put(:update, format: :js, params: params)
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when user is not logged' do
      let!(:list) { FactoryBot.create(:list, user: user, name: "List 1") }
      subject do
        params = {
          id: list.id,
          list: { name: 'List 1 (edited)' }
        }
        put(:update, format: :js, params: params)
      end

      it 'gives redirect to sign_in page' do
        expect(subject).to have_http_status(401)
      end
    end
  end

end
