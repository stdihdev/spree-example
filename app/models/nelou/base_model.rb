module Nelou
  class BaseModel < ActiveRecord::Base

    # Has to be set explicitely, as rails does not detect namespace
    self.table_name_prefix = 'nelou_'

    self.abstract_class = true

  end
end
