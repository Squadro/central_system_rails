class Account
  include Mongoid::Document
  
  belongs_to :client
  embeds_many :entries

  def add_single_entry(entry_inputs)
    entry = Entry.build(entry_inputs)
    if self.entries.present?
      self.entries += entry
    else
      self.entries = [entry]
    end
    self.save!
    self
  end
end