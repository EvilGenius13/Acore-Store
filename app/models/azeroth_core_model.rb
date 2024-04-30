class AzerothCoreModel < ActiveRecord::Base
  self.abstract_class = true
  # Ensure model uses AzerothCore database connection
  connects_to database: {writing: :azerothcore, reading: :azerothcore}
end