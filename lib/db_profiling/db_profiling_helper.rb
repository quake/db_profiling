module JavaEye
  module DbProfiling
    module Helper
      def db_profiling_view
        cache_stats = ActiveRecord::ConnectionAdapters::QueryCache.get_stats
        sql_stats = ActiveRecord::ConnectionAdapters::MysqlAdapter.get_stats
        <<HTML
  <div id="db_profiling" style="background:pink;color:black;position:absolute;top:16px;left:25%;padding:0.5em;border: 2px solid red;z-index:999;text-align:left;">
      <strong>
        Queries: <a href="#" onclick="$('cache_hits').toggle();return false;">#{cache_stats[:hits].size}</a> / <a href="#" onclick="$('cache_misses').toggle();return false;">#{cache_stats[:misses].size}</a> / #{number_to_percentage((cache_stats[:hits].size.to_f / (cache_stats[:hits].size + cache_stats[:misses].size)) * 100, :precision => 0)} |
        Rows: #{sql_stats[:rows]} |
        Transfer: #{sprintf("%.1fk", sql_stats[:bytes].to_f / 1024)}
      </strong>
      <ul id="cache_hits" style="text-align:left;display:none;"><li>#{cache_stats[:hits].join("</li><li>")}</li></ul>
      <ul id="cache_misses" style="text-align:left;display:none;"><li>#{cache_stats[:misses].join("</li><li>")}</li></ul>
  </div>        
HTML
      end
    end
  end
end