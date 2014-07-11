class Entry
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :type,         type: String # Can be "Credit", "Debit", "Bill"
  field :payment_mode,         type: String # Can be 'Cash', 'Cheque'
  field :amount,       type: Integer
  field :info,         type: String # Any extra info that you want to enter. Like cheque number etc
  
  embedded_in :account
  
  ALLOWED_ENTRY_TYPES = ["Credit", "Debit", "Bill"]
  ALLOWED_MODES = ['Cash', 'Cheque']
  
  # TODO : Add validations for type and modes 
  # TODO : Add check for cheque no when cheque is given and the bank details, dated?
end