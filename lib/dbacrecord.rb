module Xenop
module Dbutil
  class Count < ActiveRecord::Base
    has_many :invalidxenoplists
  end

  class Countdatetime < ActiveRecord::Base
  end

  class Xenop < ActiveRecord::Base
  end

  class Xenoplist < ActiveRecord::Base
  end

  class Invalidxenoplist < ActiveRecord::Base
    belongs_to :xenoplist, foreign_key: 'org_id'
    belongs_to :count, foreign_key: ''
  end

  class Currentxenoplist < ActiveRecord::Base
    belongs_to :xenoplist, foreign_key: 'org_id'
  end

end
end
