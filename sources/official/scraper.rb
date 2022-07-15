#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class MemberList
  class Member
    def name
      Name.new(
        full:     noko.css('.c-name').text,
        prefixes: %w[Senator The Hon Dame Lt Col Mr Mrs Ms Dr],
        suffixes: %w[M.P. J.P. Q.C. D.A. GCMG]
      ).short.tidy.sub(/,$/, '').sub(/\.$/, '')
    end

    def position
      # These two are only in the body text
      return 'Governor-General' if name == 'Sandra Prunella Mason'
      return 'Prime Minister' if name == 'Mia Amor Mottley'

      noko.css('.c-position').text.tidy
    end
  end

  class Members
    def member_container
      noko.css('.c-body')
    end
  end
end

file = Pathname.new 'official.html'
puts EveryPoliticianScraper::FileData.new(file).csv
