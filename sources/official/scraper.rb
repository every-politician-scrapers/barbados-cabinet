#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class MemberList
  class Member
    def name
      Name.new(
        full:     noko.css('.c-name').text,
        prefixes: %w[Her Excellency Most Senator The Hon Dame Lt Col Mr Mrs Ms Dr Sir],
        suffixes: %w[K.A. PhD M.P. J.P. LLD Q.C. D.A. GCMG FB K.A]
      ).short.tidy.sub(/,$/, '').sub(/\.$/, '')
    end

    def position
      noko.css('.c-position').text.tidy.split(/(?:,|and) (?=Minister|Senior|Leader)/).map(&:tidy)
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
