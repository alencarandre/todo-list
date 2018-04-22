require 'rails_helper'
require "devise_support"

RSpec.describe ListTasksController, type: :controller do
  include DeviseSupport

  describe '#create' do
    context 'when user is logged' do
      let(:logged_user) { FactoryBot.create(:user) }
      before(:each) { login(logged_user) }

      context 'when try create task for list that logged user is not owner' do
        let(:list) { FactoryBot.create(:list, user: FactoryBot.create(:user)) }

        it 'raise error ActiveRecord::RecordNotFound' do
          expect {
            post(:create,
              format: :js,
              params: { list_id: list.id, list_task: { name: "Task 1" } })
          }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      context 'when try create task for list that logged user is owner' do
        let(:list) { FactoryBot.create(:list, user: logged_user) }

        it 'is able to do' do
          expect(list.list_tasks.count).to eq(0)

          post(:create,
              format: :js,
              params: { list_id: list.id, list_task: { name: 'New Task 1' } })

          task = list.list_tasks.first

          expect(list.list_tasks.count).to eq(1)
          expect(task.name).to eq("New Task 1")
        end
      end
    end

    context 'when user not logged' do
      subject do
        post(:create,
            format: :js,
            params: { list_id: 1, list_task: { name: 'Task 1' } })
      end

      it 'gives http status 401' do
        expect(subject).to have_http_status(401)
      end
    end
  end

  describe '#update' do
    context 'when user is logged' do
      let(:logged_user) { FactoryBot.create(:user) }
      before(:each) { login(logged_user) }

      context 'when try create task for list that logged user is not owner' do
        let(:list) { FactoryBot.create(:list, user: FactoryBot.create(:user)) }
        let(:task) { FactoryBot.create(:list_task, list: list) }

        it 'raise error ActiveRecord::RecordNotFound' do
          expect {
            put(:update,
              format: :js,
              params: {
                list_id: task.list.id,
                id: task.id,
                list_task: { name: "Task (Edited)" }
              })
          }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      context 'when try create task for list that logged user is owner' do
        let(:list) { FactoryBot.create(:list, user: logged_user) }
        let!(:task) { FactoryBot.create(:list_task,
                                        list: list,
                                        name: "Task",
                                        status: :opened) }

        it 'is able to do' do
          expect(list.list_tasks.count).to eq(1)

          put(:update,
              format: :js,
              params: {
                list_id: task.list.id,
                id: task.id,
                  list_task: { name: 'Task (Edited)', status: :closed }
              })

          task = list.list_tasks.first

          expect(list.list_tasks.count).to eq(1)
          expect(task.name).to eq('Task (Edited)')
          expect(task.status).to eq("closed")
        end
      end
    end

    context 'when user not logged' do
      subject do
        post(:create,
            format: :js,
            params: { list_id: 1, list_task: { name: 'Task 1' } })
      end

      it 'gives http status 401' do
        expect(subject).to have_http_status(401)
      end
    end
  end
end
