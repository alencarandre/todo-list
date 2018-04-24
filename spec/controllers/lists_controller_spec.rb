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
      subject do
        params = {
          id: 1,
          list: { name: 'List 1 (edited)' }
        }
        put(:update, format: :js, params: params)
      end

      it 'gives redirect to sign_in page' do
        expect(subject).to have_http_status(401)
      end
    end
  end

  describe '#destroy' do
    context 'when user is logged' do
      before(:each) { login(FactoryBot.create(:user)) }

      context 'when list owner is not logged user' do
        let(:list) { FactoryBot.create(:list, user: FactoryBot.create(:user)) }

        it 'raise ActiveRecord::RecordNotFound' do
          expect {
            delete(:destroy,
                format: :js,
                params: { id: list.id },
                xhr: true)
          }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      context 'when list owner is logged user' do
        let(:list) { FactoryBot.create(:list, user: current_user) }

        it 'destroy the list' do
          list_id = list.id
          delete(:destroy, params: { id: list_id }, format: :js)

          expect(List.where(id: list_id).first).to be_blank
        end

        context 'when have tasks' do
          before(:each) do
            (0..1).each do |n|
              FactoryBot.create(:list_task, list: list)
            end
          end

          it 'destroy all tasks as well' do
            list_id = list.id
            delete(:destroy, params: { id: list_id }, format: :js)

            expect(ListTask.where(list_id: list_id)).to be_blank
          end
        end
      end
    end

    context 'when user is not logged' do
      subject { delete(:destroy, format: :js, params: { id: 1}) }

      it 'gives redirect to sign_in page' do
        expect(subject).to have_http_status(401)
      end
    end
  end

  describe '#mark_as_opened' do
    context 'when user is logged' do
      before(:each) { login(FactoryBot.create(:user)) }

      context 'when list owner is not logged user' do
        let(:list) { FactoryBot.create(:list, user: FactoryBot.create(:user)) }

        it 'raise ActiveRecord::RecordNotFound' do
          expect {
            get(:mark_as_opened,
                format: :js,
                params: { list_id: list.id },
                xhr: true)
          }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      context 'when list has already opened' do
        let(:list) { FactoryBot.create(:list, user: current_user) }

        it'keep opened' do
          get(:mark_as_opened,
              format: :js,
              params: { list_id: list.id },
              xhr: true )

          expect(List.find(list.id)).to be_opened
        end
      end

      context 'when list status is closed' do
        let(:list) { FactoryBot.create(:list, status: :closed, user: current_user) }

        it 'put status opened' do
          get(:mark_as_opened,
            format: :js,
            params: { list_id: list.id },
            xhr: true)

          expect(List.find(list.id)).to be_opened
        end
      end
    end

    context 'when user not logged' do
      subject do
        get(:mark_as_opened,
          format: :js,
          params: { list_id: 1 },
          xhr: true )
      end

      it 'gives http status 401' do
        expect(subject).to have_http_status(401)
      end
    end
  end

  describe '#mark_as_closed' do
    context 'when user is logged' do
      before(:each) { login(FactoryBot.create(:user)) }

      context 'when list owner is not logged user' do
        let(:list) { FactoryBot.create(:list, user: FactoryBot.create(:user)) }

        it 'raise ActiveRecord::RecordNotFound' do
          expect {
            get(:mark_as_closed,
                format: :js,
                params: { list_id: list.id },
                xhr: true)
          }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      context 'when list has already closed' do
        let(:list) { FactoryBot.create(:list, status: :closed, user: current_user) }

        it'keep closed' do
          get(:mark_as_closed,
              format: :js,
              params: { list_id: list.id },
              xhr: true )

          expect(List.find(list.id)).to be_closed
        end
      end

      context 'when list status is opened' do
        let(:list) { FactoryBot.create(:list, status: :opened, user: current_user) }

        it 'put status closed' do
          get(:mark_as_closed,
            format: :js,
            params: { list_id: list.id },
            xhr: true)

          expect(List.find(list.id)).to be_closed
        end
      end
    end

    context 'when user not logged' do
      subject do
        get(:mark_as_closed,
          format: :js,
          params: { list_id: 1 },
          xhr: true )
      end

      it 'gives http status 401' do
        expect(subject).to have_http_status(401)
      end
    end
  end

  describe '#mark_as_favorite' do
    context 'when user is not logged' do
      it 'redirect to login page' do
        get(:mark_as_favorite,
            format: :js,
            xhr: true,
            params: { list_id: 1 })
        expect(response).to have_http_status(401)
      end
    end

    context 'when user is logged' do
      before(:each) { login(FactoryBot.create(:user)) }

      context 'when list is public' do
        let!(:list) { FactoryBot.create(:list, access_type: :shared) }

        it 'mark list as favorite for logged user' do
          get(:mark_as_favorite,
              format: :js,
              xhr: true,
              params: { list_id: list.id })

          current_user.favorites.reload
          favorite = current_user.favorites.first

          expect(favorite.id).to eq(list.id)
        end
      end

      context 'when list is private' do
        let!(:list) { FactoryBot.create(:list, access_type: :personal) }

        subject { get(:mark_as_favorite, format: :js, params: { list_id: list.id }) }

        it 'raise ActiveRecord:RecordNotFound' do
          expect{ subject }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end


  describe '#mark_as_unfavorite' do
    context 'when user is not logged' do
      it 'redirect to login page' do
        delete(:mark_as_unfavorite, params: { list_id: 1 })
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when user is logged' do
      before(:each) { login(FactoryBot.create(:user)) }

      context 'when unfavorite list from another user' do
        let!(:list) { FactoryBot.create(:list) }

        subject { get(:mark_as_unfavorite, format: :js, params: { list_id: list.id }) }

        it 'raise ActiveRecord::RecordNotFound' do
          FactoryBot.create(:list, user: current_user)
          expect{ subject }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end

end
