require 'rails_helper'

RSpec.describe "Tasks", type: :request do

  describe "GET /tasks" do
    context "タスクの一覧表示(index)をリクエストした時" do
      subject { get(tasks_path) }
      before { create_list(:task, 3)}
      it "タスクの一覧を取得できる" do
        subject
        res=JSON.parse(response.body)
        expect(res.length).to eq 3
        expect(res[0].keys).to eq ["title", "description", "due_date", "completed"]
        expect(response).to have_http_status(200)
      end
    end
  end

  describe "GET /tasks/:id" do
    subject{ get(task_path(task_id))}
    context "指定したidのタスクが存在する場合" do
      let(:task){ create(:task) }
      let(:task_id){task.id}
      it "指定したタスクが取得できる" do
        subject
        res = JSON.parse(response.body)
        expect(res["title"]).to eq task.title
        expect(res["description"]).to eq task.description
        expect(res["due_date"]).to eq task.due_date.as_json(DateTime)
        expect(res["completed"]).to eq task.completed
        expect(response).to have_http_status(200)
      end
    end
    context "指定したidのタスクが存在しないとき" do
      let(:task_id){10000}
      it "指定したタスクが見つからない" do
        expect { subject }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe "POST /tasks" do
    subject { post(tasks_path, params: params)}
    context "適切なパラメーターを送信したとき" do
      let(:params) {{ task: attributes_for(:task)}}
      it "タスクのレコードが作成される" do
        expect { subject }.to change{Task.count}.by(1)
        res = JSON.parse(response.body)
        expect(res["title"]).to eq params[:task][:title]
        expect(res["description"]).to eq params[:task][:description]
        expect(res["due_date"]).to eq params[:task][:due_date].strftime("%Y-%m-%dT00:00:00.000Z")
        expect(res["completed"]).to eq params[:task][:completed]
      end
    end
    context "不適切なパラメーターを送信したとき" do
      let(:params){attributes_for(:task)}
      it "エラーする" do
        expect { subject }.to raise_error(ActionController::ParameterMissing)
      end
    end
  end

  describe "PATCH /tasks/:id" do
    subject{ patch(tasks_path(task_id), params: params)}
    context "指定したタスクを書き換えるとき" do
      let(:params) do
        {task:{title: "fff", created_at: 1.day.ago}}
      end
      let(:task_id){task.id}
      let(:task){create(:task)}
      it "タスクのレコードが更新できる" do
       expect{ subject }.to change {Task.find(task.id).title}.from(task.title).to(params[:task][:title])
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested task" do
      task = Task.create! valid_attributes
      expect {
        delete task_url(task), headers: valid_headers, as: :json
      }.to change(Task, :count).by(-1)
    end
  end
end
