module Nelou
  module SanitizeHelper

    def scrub(text)
      sanitize(Loofah.fragment(text).scrub!(:prune).to_s)
    end

    def longtext_to_html(text)
      scrub(text).lines.map do |line|
        next if line.strip.blank?
        content_tag :p, line.html_safe
      end.join('').html_safe
    end

  end
end
