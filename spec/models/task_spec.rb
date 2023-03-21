require 'rails_helper'

RSpec.describe Task, type: :model do
  context "titleに文字入力されているとき" do
    it "taskが作成される" do
      task = Task.new(title: "title", description: "description")
      expect(task.valid?).to eq true
    end
  end
  context "titleに文字入力されていないとき" do
    it "taskが作成されない" do
      task = Task.new(title: nil, description: "description")
      expect(task.valid?).to eq false
    end
  end
end
