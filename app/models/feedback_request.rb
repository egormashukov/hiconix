class FeedbackRequest < ActiveRecord::Base
  # default_scope { order('created_at') }

  STI_TYPES = %w{Email Phone Xxx}
  STATES = %w{new read archived removed}

  belongs_to :manager

  validates :contact_data, presence: true
  validates :type, inclusion: STI_TYPES
  validates :state, inclusion: STATES

  state_machine :state, initial: :new do
    after_transition new: :read, do: :set_manager

    event :new
    event :read do
      transition new: :read
    end
    event :archived do
      transition read: :archived
    end
    event :removed do
      transition archived: :removed
    end
  end

  def set_manager
    # TODO how to get current_user.id ?
    update_attributes(manager_id: 100500)
  end

  STI_TYPES.each do |t|
    define_method "#{t.downcase}_type?" do
      type == t
    end
  end
end
