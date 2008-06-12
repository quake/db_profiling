module JavaEye
  module DbProfiling
    module Helper
      def db_profiling_view
        stats = ActiveRecord::ConnectionAdapters::QueryCache.get_stats
        <<HTML
  <div id="db_profiling" style="background:pink;color:black;position:absolute;top:16px;left:25%;padding:0.5em;border: 2px solid red;z-index:999;text-align:left;">
      <strong>
        Queries: <a href="#" onclick="$('cache_hits').toggle();return false;">#{stats[:hits].size}</a> / <a href="#" onclick="$('cache_misses').toggle();return false;">#{stats[:misses].size}</a> / #{number_to_percentage((stats[:hits].size.to_f / (stats[:queries])) * 100, :precision => 0)} |
        Rows: #{stats[:rows]} |
        Transfer: #{sprintf("%.1fk", stats[:bytes].to_f / 1024)} |
        <a href="#" onclick="$('db_profiling').remove();return false;" title="close">[X]</a>
      </strong>
      <ul id="cache_hits" style="text-align:left;display:none;"><li>#{stats[:hits].join("</li><li>")}</li></ul>
      <ul id="cache_misses" style="text-align:left;display:none;"><li>#{stats[:misses].join("</li><li>")}</li></ul>
  </div>        
HTML
      end
    end
  end
end
