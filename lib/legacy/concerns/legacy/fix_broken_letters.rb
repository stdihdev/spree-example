module Legacy
  module FixBrokenLetters
    extend ActiveSupport::Concern

    included do
      after_find :fix_broken_letters!
    end

    private

    # Because even this is broken in nelou.
    def fix_broken_letters!
      umlauts = {
        'Ã-' => 'í',
        'Ã–' => 'Ö',
        'Ã¡' => 'á',
        'Å¡' => 'š',
        'Å?' => 'Õ',
        'Ä‘' => 'ð',
        'Å‘' => 'õ',
        'Ä‚' => 'Ã',
        'Ã‚' => 'Â',
        'Ã‹' => 'Ë',
        'Ä›' => 'ì',
        'Å›' => 'œ',
        'Ã“' => 'Ó',
        'Å”' => 'À',
        'Ã”' => 'Ô',
        'Ã„' => 'Ä',
        'Å„' => 'ñ',
        'Ã«' => 'ë',
        'Ã§' => 'ç',
        'Ã¶' => 'ö',
        'Ã‰' => 'É',
        'Ä†' => 'Æ',
        'Ä‡' => 'æ',
        'Ã‡' => 'Ç',
        'Å‡' => 'Ò',
        'Å•' => 'à',
        'Ã´' => 'ô',
        'Ä˜' => 'Ê',
        'Å˜' => 'Ø',
        'Å¯' => 'ù',
        'Åˆ' => 'ò',
        'Å°' => 'Û',
        'Ã©' => 'é',
        'Ã®' => 'î',
        'Å®' => 'Ù',
        'Ã±' => 'ñ',
        'Å±' => 'û',
        'Â¦' => '¦',
        'Ã¤' => 'ä',
        'Ã¢' => 'â',
        'Å¢' => 'Þ',
        'Å£' => 'þ',
        'Ä¹' => 'Å',
        'Ã¹' => 'ù',
        'Ã½' => 'ý',
        'Å½' => 'Ž',
        'Ã¼' => 'ü',
        'Ã³' => 'ó',
        'Å¾' => 'ž',
        'Äƒ' => 'ã',
        'Åƒ' => 'Ñ',
        'Äº' => 'å',
        'Ãº' => 'ú',
        'Åº' => 'Ÿ',
        'ÄŒ' => 'È',
        'Ãœ' => 'Ü',
        'Äš' => 'Ì',
        'Åš' => 'Œ',
        'Ãš' => 'Ú',
        'Ä™' => 'ê',
        'Å™' => 'ø',
        'ÃŸ' => 'ß',
        'ÄŽ' => 'Ï',
        'ÃŽ' => 'Î',
        'Ë˜' => '¢',
        'Ë™' => 'ÿ'
      }

      attributes.each do |name, value|
        begin
          if value.is_a? String
            umlauts.each do |k, r|
              value = value.gsub(k, r)
            end
            write_attribute name, value
          end
          # write_attribute name, value.force_encoding('UTF-8').gsub(/#{umlauts.keys.join("|")}/u, umlauts) if value.is_a? String
        rescue => e
          # Probably a broken binary that should not be a TEXT field. Ignore.
          # Because everything in nelou is broken.
          logger.error e
        end
      end
    end
  end
end
