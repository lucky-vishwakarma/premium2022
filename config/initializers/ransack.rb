Ransack.configure do |config|
  config.add_predicate 'due_date_eq',
    arel_predicate: 'eq',
    formatter: proc { |v| process_user_due_date_search_string(v).to_date },
    validator: proc { |v| v.present? },
    type: :string
    
   config.add_predicate 'gteq',
    arel_predicate: 'gteq',
    formatter: proc { |v| v.beginning_of_day },
    type: :date

  config.add_predicate 'lteq',
    arel_predicate: 'lteq',
    formatter: proc { |v| v.end_of_day },
    type: :date
end