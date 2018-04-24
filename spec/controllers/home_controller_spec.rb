require 'rails_helper'
require 'devise_support'

RSpec.describe HomeController, type: :controller do
  include DeviseSupport
  describe '#index' do
    subject { get :index }

    context 'when user is not logged' do
      it 'render home/index template' do
        expect(subject).to render_template("home/index")
      end
    end

    context 'when user is logged' do
      before(:each) { login(FactoryBot.create(:user)) }

      it 'redirect to lists/mine' do
        expect(subject).to redirect_to(lists_mine_index_path)
      end
    end
  end
end
