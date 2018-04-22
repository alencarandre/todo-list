require 'rails_helper'
require "devise_support"

RSpec.describe ListTasksController, type: :controller do
  include DeviseSupport

  describe '#create' do
    context 'when user is logged' do
      let(:logged_user) { FactoryBot.create(:user) }
      before(:each) { login(logged_user) }

      context 'when try create task for list' do
        context 'when logged user is not owner' do
          let(:list) { FactoryBot.create(:list, user: FactoryBot.create(:user)) }

          it 'raise error ActiveRecord::RecordNotFound' do
            expect {
              post(:create,
                format: :js,
                params: { list_id: list.id, list_task: { name: "Task 1" } })
            }.to raise_error(ActiveRecord::RecordNotFound)
          end
        end

        context 'when logged user is owner' do
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

      context 'when try create sub task' do
        context 'when parent task not belongs to some list' do
          let(:list) { FactoryBot.create(:list, user: logged_user) }

          it 'not create sub task' do
            parent_task = FactoryBot.create(:list_task)

            post(:create,
                format: :js,
                params: {
                  list_id: list.id,
                  list_task: {
                    name: "Wrong parent task",
                    list_task_id: parent_task.id
                  }
                })

            expect(ListTask.where(name: "Wrong parent task")).to be_blank
          end
        end

        context 'when parent task belongs to some list' do
          let(:list) { FactoryBot.create(:list, user: logged_user) }

          it 'create sub task' do
            parent_task = FactoryBot.create(:list_task, list: list)

            post(:create,
                format: :js,
                params: {
                  list_id: list.id,
                  list_task: {
                    name: "New Sub Task",
                    list_task_id: parent_task.id
                  }
                })

            task = ListTask.where(name: "New Sub Task").first

            expect(task).to be_present
            expect(task.list_task.id).to eq(parent_task.id)
          end
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
                                        name: "Task") }

        it 'is able to do' do
          expect(list.list_tasks.count).to eq(1)

          put(:update,
              format: :js,
              params: {
                list_id: task.list.id,
                id: task.id,
                  list_task: { name: 'Task (Edited)' }
              })

          task = list.list_tasks.first

          expect(list.list_tasks.count).to eq(1)
          expect(task.name).to eq('Task (Edited)')
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


  describe '#destroy' do
    context 'when user is logged' do
      let(:logged_user) { FactoryBot.create(:user) }
      before(:each) { login(logged_user) }

      context 'when try destroy task for list when logged user is not owner' do
        let(:list) { FactoryBot.create(:list, user: FactoryBot.create(:user)) }
        let(:task) { FactoryBot.create(:list_task, list: list) }

        it 'raise error ActiveRecord::RecordNotFound' do
          expect {
            delete(:destroy,
              format: :js,
              params: {
                list_id: task.list.id,
                id: task.id
              })
          }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      context 'when try destroy task for list when logged user is owner' do
        let(:list) { FactoryBot.create(:list, user: logged_user) }
        let!(:task) { FactoryBot.create(:list_task,
                                        list: list,
                                        name: "Task") }

        it 'is able to do' do
          expect(list.list_tasks.count).to eq(1)

          delete(:destroy,
              format: :js,
              params: {
                list_id: task.list.id,
                id: task.id,
              })

          task = list.list_tasks.first

          expect(task).to be_blank
        end
      end
    end

    context 'when user not logged' do
      subject do
        delete(:destroy,
            format: :js,
            params: { list_id: 1, id: 1 })
      end

      it 'gives http status 401' do
        expect(subject).to have_http_status(401)
      end
    end
  end

  describe '#mark_as_opened' do
    context 'when user is logged' do
      let(:logged_user) { FactoryBot.create(:user) }

      before(:each) { login(logged_user) }

      context 'when task has already opened' do
        let(:list) { FactoryBot.create(:list, user: logged_user) }
        let(:task) { FactoryBot.create(:list_task, list: list, status: :opened) }

        it'keep opened' do
          get(:mark_as_opened,
            format: :js,
            params: { list_id: task.list.id, list_task_id: task.id },
            xhr: true )

          expect(ListTask.find(task.id).status).to eq("opened")
        end
      end

      context 'when task status is closed' do
        let(:list) { FactoryBot.create(:list, user: logged_user) }
        let(:task) { FactoryBot.create(:list_task, list: list, status: :closed) }

        it 'put status closed' do
          get(:mark_as_opened,
            format: :js,
            params: { list_id: task.list.id, list_task_id: task.id },
            xhr: true )

          expect(ListTask.find(task.id).status).to eq("opened")
        end
      end
    end

    context 'when user not logged' do
      subject do
        get(:mark_as_opened,
          format: :js,
          params: { list_id: 1, list_task_id: 1 },
          xhr: true )
      end

      it 'gives http status 401' do
        expect(subject).to have_http_status(401)
      end
    end
  end

  describe '#mark_as_closed' do
    context 'when user is logged' do
      let(:logged_user) { FactoryBot.create(:user) }

      before(:each) { login(logged_user) }

      context 'when task has already closed' do
        let(:list) { FactoryBot.create(:list, user: logged_user) }
        let(:task) { FactoryBot.create(:list_task, list: list, status: :closed) }

        it'keep opened' do
          get(:mark_as_closed,
            format: :js,
            params: { list_id: task.list.id, list_task_id: task.id },
            xhr: true )

          expect(ListTask.find(task.id).status).to eq("closed")
        end
      end

      context 'when task status is opened' do
        let(:list) { FactoryBot.create(:list, user: logged_user) }
        let(:task) { FactoryBot.create(:list_task, list: list, status: :opened) }

        it 'put status closed' do
          get(:mark_as_closed,
            format: :js,
            params: { list_id: task.list.id, list_task_id: task.id },
            xhr: true )

          expect(ListTask.find(task.id).status).to eq("closed")
        end
      end
    end

    context 'when user not logged' do
      subject do
        get(:mark_as_closed,
          format: :js,
          params: { list_id: 1, list_task_id: 1 },
          xhr: true )
      end

      it 'gives http status 401' do
        expect(subject).to have_http_status(401)
      end
    end
  end

end
