module JavaEye
  module DbProfiling
    module Helper
      def db_profiling_view
        stats = ActiveRecord::ConnectionAdapters::QueryCache.get_stats
        <<HTML
  <div id="db_profiling" style="background:pink;color:black;position:absolute;top:16px;left:25%;padding:0.5em;border: 2px solid red;z-index:999;text-align:left;">
      <strong>
        Queries: <a href="#" onclick="$('cache_hits').toggle();return false;" title="Query cache hits">#{stats[:hits].size}</a> / <a href="#" onclick="$('cache_misses').toggle();return false;" title="DB queries">#{stats[:misses].size}</a> / #{number_to_percentage((stats[:hits].size.to_f / (stats[:queries])) * 100, :precision => 0)} |
        Rows: #{stats[:rows]} |
        Transfer: #{sprintf("%.1fk", stats[:bytes].to_f / 1024)} |
        <a href="#" onclick="$('db_profiling').remove();return false;" title="Close">[X]</a>
      </strong>
      <ul id="cache_hits" style="text-align:left;display:none;">#{stats[:hits].inject("") {|output, s| output << "<li title='Click to display detail' onclick='$(this).next().toggle();return false;' style='cursor: pointer'>#{s[0]}</li><li style='display:none;list-style:none;'>#{s[1].join('<br/>')}</li>" }}</ul>
      <ul id="cache_misses" style="text-align:left;display:none;">#{stats[:misses].inject("") {|output, s| output << "<li title='Click to display detail' onclick='$(this).next().toggle();return false;' style='cursor: pointer'>#{s[0]}</li><li style='display:none;list-style:none;'>#{s[1].join('<br/>')}</li>" }}</ul>
  </div>        
HTML
      end
    end
  end
end
