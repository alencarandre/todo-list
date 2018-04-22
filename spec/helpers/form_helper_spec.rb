require 'rails_helper'

RSpec.describe FormHelper, type: :helper do
  describe "#input_text" do
    it 'call input_field as: :text' do
      expect(self).to receive(:input_field).with(:foo, :bar, as: :text)
      input_text(:foo, :bar)
    end
  end

  describe "#input_email" do
    it 'call input_field as: :email' do
      expect(self).to receive(:input_field).with(:foo, :bar, as: :email)
      input_email(:foo, :bar)
    end
  end

  describe "#input_password" do
    it 'call input_field as: :password' do
      expect(self).to receive(:input_field).with(:foo, :bar, as: :password)
      input_password(:foo, :bar)
    end
  end

  describe "#input_select" do
    it 'call input_field as: :select' do
      expect(self).to receive(:input_field).with(:foo, :bar, as: :select, options: [:test])
      input_select(:foo, :bar, [:test])
    end
  end

  describe "#input_field" do

    it 'render label, independent of input' do
      form_for(User.new, url: "/") do |f|
        [:text, :email, :foo, :bar].each do |input_type|
          expect(input_field(:name, f, as: :input_type)).to include("<label")
        end
      end
    end

    it 'render error message when has error, independent of input' do
      form_for(User.new, url: "/") do |f|
        allow(f.object).to receive(:errors).and_return(name: ["Error message"])

        [:text, :email, :foo, :bar].each do |input_type|
          span_error = "<span class=\"error\">Error message</span>"
          expect(input_field(:name, f, as: input_type)).to include(span_error)
        end
      end
    end

    it 'when as: :text render input text' do
      form_for(User.new, url: "/") do |f|
        input = "<input class=\"form-control\" type=\"text\""
        expect(input_field(:name, f, as: :text)).to include(input)
      end
    end

    it 'when as: :email render input email' do
      form_for(User.new, url: "/") do |f|
        input = "<input class=\"form-control\" autofocus=\"autofocus\" " + \
                "autocomplete=\"email\" type=\"email\""

        expect(input_field(:name, f, as: :email)).to include(input)
      end
    end

    it 'when as: :password render input password' do
      form_for(User.new, url: "/") do |f|
        input = "<input class=\"form-control\" autocomplete=\"off\" " + \
                "type=\"password\""
        expect(input_field(:name, f, as: :password)).to include(input)
      end
    end

    it 'when as: :select render select with options' do
      form_for(List.new, url: "/") do |f|
        field = input_field(:name, f, as: :select, options: [:foo, :bar])

        expect(field).to include("<select class=\"form-control\" ")
        expect(field).to include("<option value=\"foo\">foo</option>")
        expect(field).to include("<option value=\"bar\">bar</option>")
      end
    end

  end

end
