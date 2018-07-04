class Ask < ApplicationRecord

  validates :content, :presence => { message: "내용을 입력해주세요" }

  scope :q, -> { where(question_id: 0) }
  scope :a, -> { where.not(question_id: 0) }

  scope :x, -> { where.not(answered: 1) }
  scope :c, -> { where(answered: 1) }

  has_one :question, class_name: 'Ask', foreign_key: 'id'

  def answer
    Ask.find_by(question_id: self.id)
  end

  def is_answer?
    !self.question_id.to_i.zero?
  end

  after_create :mark_answered

    def mark_answered
      return if self.question_id.to_i.zero?
      Ask.where(id: self.question_id).update_all(answered: 1)
    end

end
