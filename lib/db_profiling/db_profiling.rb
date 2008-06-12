ActiveRecord::ConnectionAdapters::QueryCache.module_eval do
  @@stats_hits = []
  @@stats_misses = []
  @@stats_bytes = @@stats_rows = 0
  
  def self.get_stats
    { :hits => @@stats_hits,
      :misses => @@stats_misses,
      :rows => @@stats_rows,
      :bytes => @@stats_bytes,
      :queries => @@stats_hits.size + @@stats_misses.size,
    }
  end
  
  def self.reset_stats
    @@stats_hits = []
    @@stats_misses = []
    @@stats_bytes = @@stats_rows = 0
  end
  
  def cache_sql_with_stats(sql, &block)
    if @query_cache.has_key?(sql)
      @@stats_hits << sql
    else
      @@stats_misses << sql
    end
    bytes = 0
    rows = cache_sql_without_stats(sql, &block)
    rows.each do |row|
      row.each do |key, value|
        bytes += key.length
        bytes += value.length if value
      end
    end
    @@stats_rows += rows.length
    @@stats_bytes += bytes
    rows
  end
  alias_method_chain :cache_sql, :stats
end

ActionController::Base.module_eval do
  def perform_action_with_reset
    ActiveRecord::ConnectionAdapters::QueryCache::reset_stats
    perform_action_without_reset
  end

  alias_method_chain :perform_action, :reset

  def active_record_runtime(runtime)
    stats = ActiveRecord::ConnectionAdapters::QueryCache::get_stats
    "#{super} #{sprintf("%.1fk", stats[:bytes].to_f / 1024)} queries: #{stats[:queries]}"
  end
end
