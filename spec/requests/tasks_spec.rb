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
      let(:task){create(:task)}
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
      it "タスクが見つからない" do
        expect {subject}.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Task" do
        expect {
          post tasks_url,
               params: { task: valid_attributes }, headers: valid_headers, as: :json
        }.to change(Task, :count).by(1)
      end

      it "renders a JSON response with the new task" do
        post tasks_url,
             params: { task: valid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Task" do
        expect {
          post tasks_url,
               params: { task: invalid_attributes }, as: :json
        }.to change(Task, :count).by(0)
      end

      it "renders a JSON response with errors for the new task" do
        post tasks_url,
             params: { task: invalid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested task" do
        task = Task.create! valid_attributes
        patch task_url(task),
              params: { task: new_attributes }, headers: valid_headers, as: :json
        task.reload
        skip("Add assertions for updated state")
      end

      it "renders a JSON response with the task" do
        task = Task.create! valid_attributes
        patch task_url(task),
              params: { task: new_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid parameters" do
      it "renders a JSON response with errors for the task" do
        task = Task.create! valid_attributes
        patch task_url(task),
              params: { task: invalid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including("application/json"))
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
