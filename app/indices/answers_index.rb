ThinkingSphinx::Index.define :answer, with: :active_record do
  indexes body
  indexes user.email, as: :author

  has user_id, rating, created_at, updated_at
end