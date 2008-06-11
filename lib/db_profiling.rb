require 'db_profiling/db_profiling'
require 'db_profiling/db_profiling_helper'

ActionView::Base.send :include, JavaEye::DbProfiling::Helper
