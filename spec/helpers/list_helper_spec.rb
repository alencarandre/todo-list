require 'rails_helper'
require 'devise_support'

RSpec.describe ListHelper, type: :helper do
  include DeviseSupport

  let(:list) { FactoryBot.create(:list) }

  describe '#list_mark_as_closed_link' do
    context 'when pass screen :mine' do
      it 'has link to close list' do
        element = list_mark_as_closed_link(list, :mine)
        href = list_mark_as_closed_path(list)

        expect(element).to include("href=\"#{href}\"")
      end
    end

    context 'when pass screen :public' do
      it 'has link to close list' do
        element = list_mark_as_closed_link(list, :public)
        href = list_mark_as_closed_path(list)

        expect(element).to_not include("href=\"#{href}\"")
      end

      it 'has only list name' do
        element = list_mark_as_closed_link(list, :public)
        expect(element).to eq(list.name)
      end
    end
  end

  describe '#list_mark_as_opened_link' do
    context 'when pass screen :mine' do
      it 'has link to open list' do
        element = list_mark_as_opened_link(list, :mine)
        href = list_mark_as_opened_path(list)

        expect(element).to include("href=\"#{href}\"")
      end
    end

    context 'when pass screen :public' do
      it 'has link to open list' do
        element = list_mark_as_opened_link(list, :public)
        href = list_mark_as_opened_path(list)

        expect(element).to_not include("href=\"#{href}\"")
      end

      it 'has only list name' do
        element = list_mark_as_opened_link(list, :public)
        expect(element).to eq(list.name)
      end
    end
  end

  describe '#edit_list_link' do
    context 'when pass screen :mine' do

      it 'has a link to edit list' do
        element = edit_list_link(list, :mine)
        href = edit_list_path(list)

        expect(element).to include("href=\"#{href}\"")
      end
    end

    context 'when pass screen :public' do
      it 'gives nil' do
        element = edit_list_link(list, :public)
        expect(element).to be_nil
      end
    end
  end

  describe '#new_list_list_task_path' do
    context 'when pass screen :mine' do
      before(:each) { stub(:controller_name) { 'some_controller' } }

      it 'has a link to new list' do
        element = new_list_list_task_link(list, :mine)
        href = new_list_list_task_path(list)

        expect(element).to include("href=\"#{href}\"")
      end
    end

    context 'when pass screen :public' do
      it 'gives nil' do
        element = new_list_list_task_link(list, :public)
        expect(element).to be_nil
      end
    end
  end

  describe '#link_to_favor_to_list' do
    context 'when pass screen :public' do
      let(:current_user) { FactoryBot.create(:user) }

      context 'when list is not favorite' do
        let(:list) { FactoryBot.create(:list) }

        it 'gives link to favor the list' do
          expect(self).to receive(:current_user).and_return(current_user)

          element = link_to_favor_the_list(list, :public)
          href = list_mark_as_favorite_path(list)

          expect(element).to include("href=\"#{href}\"")
        end
      end

      context 'when list is favorite' do
        let(:list) { FactoryBot.create(:list) }

        before(:each) { list.favor!(current_user) }

        it 'gives link to unfavor to list' do
          expect(self).to receive(:current_user).and_return(current_user)

          element = link_to_favor_the_list(list, :public)
          href = list_mark_as_unfavorite_path(list)

          expect(element).to include("href=\"#{href}\"")
        end
      end
    end

    context 'when pass screen :mine' do
      before(:each) { stub(:controller_name) { 'mine' } }

      it 'gives nil' do
        element = link_to_favor_the_list(list, :mine)
        expect(element).to be_nil
      end
    end
  end

end
