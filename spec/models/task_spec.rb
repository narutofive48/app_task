require 'rails_helper'

RSpec.describe Task, type: :model do
  context "titleに文字入力されているとき" do
    it "taskが作成される" do
      task = build(:task)
      expect(task.valid?).to eq true
    end
  end
  context "titleに文字入力されていないとき" do
    it "taskが作成されない" do
      task = build(:task, title: nil)
      expect(task.valid?).to eq false
    end
  end
end
