require 'rails_helper'

RSpec.describe MenuHelper, type: :helper do
  describe "#render_main_menu" do
    context 'when pass true to logged param' do
      it 'expect view layouts/nav/logged_in' do
        expect(main_menu(true)).to eq("layouts/nav/logged_in")
      end
    end

    context 'whenn pass false to logged param' do
      it 'expect view layouts/nav/logged_out' do
        expect(main_menu(false)).to eq("layouts/nav/logged_out")
      end
    end
  end
end
