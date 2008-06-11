ActiveRecord::ConnectionAdapters::MysqlAdapter.module_eval do
  @@stats_queries = @@stats_bytes = @@stats_rows = 0

  def self.get_stats
    { :queries => @@stats_queries,
      :rows => @@stats_rows,
      :bytes => @@stats_bytes }
  end
  def self.reset_stats
    @@stats_queries = @@stats_bytes = @@stats_rows = 0
  end

  def select_with_stats(sql, name)
    bytes = 0
    rows = select_without_stats(sql, name)
    rows.each do |row|
      row.each do |key, value|
        bytes += key.length
        bytes += value.length if value
      end
    end
    @@stats_queries += 1
    @@stats_rows += rows.length
    @@stats_bytes += bytes
    rows
  end
  alias_method_chain :select, :stats
end

ActiveRecord::ConnectionAdapters::QueryCache.module_eval do
  @@hits = []
  @@misses = []

  def self.get_stats
    { :hits => @@hits,
      :misses => @@misses }
  end
  def self.reset_stats
    @@hits = []
    @@misses = []
  end

  def cache_sql_with_stats(sql, &block)
    if @query_cache.has_key?(sql)
      @@hits << sql
    else
      @@misses << sql
    end
    cache_sql_without_stats(sql, &block)
  end
  alias_method_chain :cache_sql, :stats
end

ActionController::Base.module_eval do
  def perform_action_with_reset
    ActiveRecord::ConnectionAdapters::MysqlAdapter::reset_stats
    ActiveRecord::ConnectionAdapters::QueryCache::reset_stats
    perform_action_without_reset
  end

  alias_method_chain :perform_action, :reset

  def active_record_runtime(runtime)
    stats = ActiveRecord::ConnectionAdapters::MysqlAdapter::get_stats
    "#{super} #{sprintf("%.1fk", stats[:bytes].to_f / 1024)} queries: #{stats[:queries]}"
  end
end