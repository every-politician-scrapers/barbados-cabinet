#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class MemberList
  # details for an individual member
  class Member < Scraped::HTML
    PREFIXES = %w[Senator The Hon Dame Lt Col Mr Mrs Ms Dr].freeze
    SUFFIXES = %w[M.P. J.P. Q.C. D.A. GCMG].freeze

    field :name do
      SUFFIXES.reduce(unprefixed_name) { |current, suffix| current.sub(/#{suffix}/, '').tidy.sub(/,$/, '') }.sub(/\.$/, '')
    end

    field :position do
      noko.css('.c-position').text.tidy
    end

    private

    def full_name
      noko.css('.c-name').text.tidy
    end

    def unprefixed_name
      PREFIXES.reduce(full_name) { |current, prefix| current.sub(/#{prefix}\.? /, '') }
    end
  end

  # The page listing all the members
  class Members < Scraped::HTML
    field :members do
      member_container.flat_map do |member|
        data = fragment(member => Member).to_h
        [data.delete(:position)].flatten.map { |posn| data.merge(position: posn) }
      end
    end

    private

    def member_container
      noko.css('.c-body')
    end
  end
end

file = Pathname.new 'html/official.html'
puts EveryPoliticianScraper::FileData.new(file).csv
